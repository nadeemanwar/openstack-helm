#!/bin/bash

# Copyright 2017 The Openstack-Helm Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

status=0
total_charts=0
failed_charts=0
charts_with_warning=0
successful_charts=0

echo "" > /tmp/dry-run-errors.log
echo "" > /tmp/dry-run-warnings.log
for chart in *.tgz; do
  (( total_charts++ ))
  echo "Running helm install --dry-run --debug on $chart";
  helm install --dry-run --debug local/$chart 2>&1 > /tmp/dry-run-output.log
  if [ $? -ne 0 ];
  then
    echo "ERROR: Found error and setting status to 1"
    cat /tmp/dry-run-output.log >> /tmp/dry-run-errors.log
    status=1;
    (( failed_charts++ )) 
  else
    echo "Install Successful, checking for template issues"
    #cat travis-ci/errors.list
    if [ `egrep -f travis-ci/errors.list /tmp/dry-run-output.log | wc -l` -ne 0 ]; 
    then
      echo "ERROR: Found errors, setting the status to 1 and printing the log" 
      status=1;
      (( failed_charts++ )) 
      egrep -f travis-ci/errors.list /tmp/dry-run-output.log >> /tmp/dry-run-errors.log
     # cat /tmp/dry-run-output.log >> /tmp/dry-run-errors.log
    else
       (( successful_charts++ )) 
    fi
    echo "Checking warning issues with the templates"
    #cat travis-ci/warnings.list
    if [ `egrep -f travis-ci/warnings.list /tmp/dry-run-output.log | wc -l` -ne 0 ]; 
    then
        echo "Found warnings"
        (( charts_with_warning++ )) 
        egrep -f travis-ci/warnings.list /tmp/dry-run-output.log >> /tmp/dry-run-warnings.log
        #cat /tmp/dry-run-output.log >> /tmp/dry-run-warnings.log
    fi
 fi
done
echo "==============================================================="
echo "Total charts = $total_charts"
echo "Successful chart Install = $successful_charts"
echo "Failed Charts Install = $failed_charts"
echo "Charts Installed with warnings = $charts_with_warning"
echo "==============================================================="

exit $status

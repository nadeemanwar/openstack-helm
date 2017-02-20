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
echo "" > /tmp/dry-run-errors.log
for chart in *.tgz; do
  echo "Running helm install --dry-run --debug on $chart";
  helm install --dry-run --debug local/$chart 2>&1 > /tmp/dry-run-output.log
  if [ $? -ne 0 ];
  then
    echo "Found error printing the log"
    cat /tmp/dry-run-output.log >> /tmp/dry-run-errors.log
    status=1;
  else
    echo "No Error found for dry run checking for gotpl"
    if [ `egrep -f travis-ci/errors.list /tmp/dry-run-output.log | wc -l` -ne 0 ]; 
    then
      echo "Found errors, setting the status to 1 and printing the log" 
      status=1;
      cat /tmp/dry-run-output.log >> /tmp/dry-run-errors.log 
    fi
 fi
done
exit $status

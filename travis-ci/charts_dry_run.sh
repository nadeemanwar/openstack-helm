#!/bin/bash

status=0;
for chart in *.tgz; do
  echo "Running helm install --dry-run --debug on $chart";
  helm install --dry-run --debug local/$chart 2>&1 > /tmp/dry-run-output.log
  if [ $? -ne 0 ];
  then
    echo "Found error printing the log"
    cat /tmp/dry-run-output.log
    status=$?;
  else
    echo "No Error found for dry run checking for gotpl"
    if [ `grep gotpl /tmp/dry-run-output.log | wc -l` -ne 0 ]; 
    then
      echo ("Found gotpl, setting the status to 1 and printing the log") 
      status=1;
      cat /tmp/dry-run-output.log 
    fi
 fi
done
exit $status

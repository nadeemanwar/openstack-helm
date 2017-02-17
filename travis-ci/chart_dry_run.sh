#!/bin/bash

status=0;
  echo "Running helm install --dry-run --debug on $1";
  helm install --dry-run --debug local/$1 2>&1 > /tmp/dry-run-output.log
  if [ $? -ne 0 ];
  then
    echo "Found error printing the log"
    cat /tmp/dry-run-output.log
    status=$?;
  else
    echo "No Error found for dry run checking for gotpl"
    if [ `egrep -f travis-ci/errors.list /tmp/dry-run-output.log | wc -l` -ne 0 ]; 
    then
      echo "Found errors, setting the status to 1 and printing the log" 
      status=1;
      cat /tmp/dry-run-output.log 
    fi
 fi
exit $status

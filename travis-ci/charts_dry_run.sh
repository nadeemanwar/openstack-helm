#!/bin/bash

for chart in *.tgz; do
  echo "Running helm install --dry-run --debug on $chart";
  helm install --dry-run --debug local/$chart 2>&1 > /tmp/dry-run-output.log
  if [ $? -ne 0 ];
  then
    echo "Found error printing the log"
    cat /tmp/dry-run-output.log
  else
    echo "No Error found for dry run checking for gotpl"
    grep gotpl /tmp/dry-run-output.log || true
  fi
done

#!/bin/bash

for chart in *.tgz; do
  echo "Running helm install --dry-run --debug on $chart";
  helm install --dry-run --debug local/$chart 2>&1 > /tmp/dry-run-output.log
  if [ $? -ne 0 ];
  then
    cat /tmp/dry-run-output.log
  else
    grep gotpl /tmp/dry-run-output.log
  fi
done

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
docker run -it -e quay.io/attcomdev/kubeadm-ci:v1.1.0 --name kubeadm-ci --privileged=true -d --net=host --security-opt seccomp:unconfined --cap-add=SYS_ADMIN -v /sys/fs/cgroup:/sys/fs/cgroup:ro -v /var/run/docker.sock:/var/run/docker.sock quay.io/attcomdev/kubeadm-ci:v1.1.0 /sbin/init  2>&1 > /tmp/docker-run-output.log
if [ $? -ne 0 ];
then
  echo "ERROR:  Found error, setting status to 1 printing the log"
  cat /tmp/docker-run-output.log 
  status=1;
else
  echo "docker started successfully"
fi

docker exec kubeadm-ci kubeadm.sh 2>&1 > /tmp/docker-run-output.log
if [ $? -ne 0 ];
then
  echo "ERROR: Found error, setting status to 1 and printing the log"
  cat /tmp/docker-run-output.log
  status=1;
else
  echo "kubeadm.sh script ran successfully"
fi

exit $status

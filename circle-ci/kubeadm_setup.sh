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

docker run -it -e quay.io/attcomdev/kubeadm-ci:v1.1.0 --name kubeadm-ci --privileged=true -d --net=host --cap-add=SYS_ADMIN -v /sys/fs/cgroup:/sys/fs/cgroup:ro -v /var/run/docker.sock:/var/run/docker.sock quay.io/attcomdev/kubeadm-ci:v1.1.0 /sbin/init

docker ps -a
sudo lxc-info --name kubeadm-ci
sudo lxc-start --name kubeadm-ci
sudo lxc-info --name kubeadm-ci
sudo lxc-attach -n "$(docker inspect --format "{{.Id}}" kubeadm-ci)" -- bash -c "docker exec kubeadm-ci kubeadm.sh" 


#docker exec kubeadm-ci kubeadm.sh
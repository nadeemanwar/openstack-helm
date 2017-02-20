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

set -ex

if [[ -f /var/run/libvirtd.pid ]]; then
   test -d /proc/$(< /var/run/libvirtd.pid) && \
   ( echo "Libvirtd daemon is running" && exit 10 )
fi

rm -f /var/run/libvirtd.pid

if [[ -c /dev/kvm ]]; then
    chmod 660 /dev/kvm
    chown root:kvm /dev/kvm
fi


sleep 30

{{- if .Values.ceph.enabled }}
cat > /tmp/secret.xml <<EOF
<secret ephemeral='no' private='no'>
  <uuid>{{ .Values.ceph.secret_uuid }}</uuid>
  <usage type='ceph'>
    <name>client.{{ .Values.ceph.cinder_user }} secret</name>
  </usage>
</secret>
EOF

virsh secret-define --file /tmp/secret.xml
virsh secret-set-value --secret {{ .Values.ceph.secret_uuid }} --base64 {{ .Values.ceph.cinder_keyring }}
rm /tmp/secret.xml
{{- end }}


exec libvirtd -v --listen

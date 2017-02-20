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

[DEFAULT]
debug = {{ .Values.misc.debug }}
use_syslog = False
use_stderr = True

deferred_auth_method = "trusts"

enable_stack_adopt = "True"
enable_stack_abandon = "True"

heat_metadata_server_url = {{ .Values.service.cfn.proto }}://{{ .Values.service.cfn.name }}:{{ .Values.service.cfn.port }}
heat_waitcondition_server_url = {{ .Values.service.cfn.proto }}://{{ .Values.service.cfn.name }}:{{ .Values.service.cfn.port }}/v1/waitcondition
heat_watch_server_url = {{ .Values.service.cloudwatch.proto }}://{{ .Values.service.cloudwatch.name }}:{{ .Values.service.cloudwatch.port }}

num_engine_workers = {{ .Values.resources.engine.workers }}

stack_user_domain_name = {{ .Values.keystone.heat_stack_user_domain }}
stack_domain_admin = {{ .Values.keystone.heat_stack_user }}
stack_domain_admin_password = {{ .Values.keystone.heat_stack_password }}

trusts_delegated_roles = "Member"

[cache]
enabled = "True"
backend = oslo_cache.memcache_pool
memcache_servers = "{{ .Values.memcached.host }}:{{ .Values.memcached.port }}"

[database]
connection = mysql+pymysql://{{ .Values.database.heat_user }}:{{ .Values.database.heat_password }}@{{ .Values.database.address }}:{{ .Values.database.port }}/{{ .Values.database.heat_database_name }}
max_retries = -1

[keystone_authtoken]
signing_dir = "/var/cache/heat"
memcached_servers = "{{ .Values.memcached.host }}:{{ .Values.memcached.port }}"
auth_version = v3
auth_url = {{ include "helm-toolkit.endpoint_keystone_internal" . }}
auth_type = password
region_name = {{ .Values.keystone.heat_region_name }}
project_domain_name = {{ .Values.keystone.heat_project_domain }}
project_name = {{ .Values.keystone.heat_project_name }}
user_domain_name = {{ .Values.keystone.heat_user_domain }}
username = {{ .Values.keystone.heat_user }}
password = {{ .Values.keystone.heat_password }}

[heat_api]
bind_port = {{ .Values.service.api.port }}
bind_host = 0.0.0.0
workers = {{ .Values.resources.api.workers }}

[heat_api_cloudwatch]
bind_port = {{ .Values.service.cloudwatch.port }}
bind_host = 0.0.0.0
workers = {{ .Values.resources.cloudwatch.workers }}

[heat_api_cfn]
bind_port = {{ .Values.service.cfn.port }}
bind_host = 0.0.0.0
workers = {{ .Values.resources.cfn.workers }}

[oslo_messaging_rabbit]
rabbit_userid = {{ .Values.messaging.user }}
rabbit_password = {{ .Values.messaging.password }}
rabbit_ha_queues = true
rabbit_hosts = {{ .Values.messaging.hosts }}

[paste_deploy]
config_file = /etc/heat/api-paste.ini

[trustee]
auth_type = "password"
auth_section = "trustee_keystone"

[trustee_keystone]
signing_dir = "/var/cache/heat"
memcached_servers = "{{ .Values.memcached.host }}:{{ .Values.memcached.port }}"
auth_version = v3
auth_url = {{ include "helm-toolkit.endpoint_keystone_internal" . }}
auth_type = password
region_name = {{ .Values.keystone.heat_trustee_region_name }}
user_domain_name = {{ .Values.keystone.heat_trustee_user_domain }}
username = {{ .Values.keystone.heat_trustee_user }}
password = {{ .Values.keystone.heat_trustee_password }}


[clients]
endpoint_type = internalURL

[clients_keystone]
endpoint_type = internalURL
auth_uri = {{ include "helm-toolkit.endpoint_keystone_internal" . }}

[DEFAULT]
debug = {{ .Values.api.default.debug }}
use_syslog = False
use_stderr = True

[database]
connection = mysql+pymysql://{{ .Values.database.keystone_user }}:{{ .Values.database.keystone_password }}@{{ include "helm-toolkit.mariadb_host" . }}/{{ .Values.database.keystone_database_name }}
max_retries = -1

[memcache]
servers = {{ include "helm-toolkit.rabbitmq_host" . }}:11211

[token]
provider = {{ .Values.api.token.provider }}

[cache]
backend = dogpile.cache.memcached
memcache_servers = {{ include "helm-toolkit.rabbitmq_host" . }}:11211
config_prefix = cache.keystone
enabled = True


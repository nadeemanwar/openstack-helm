#!/bin/bash

echo "Hello World"

set -ex
export HOME=/tmp

ansible localhost -vvv -m mysql_db -a "login_host='{{ include "helm-toolkit.mariadb_host" . }}' \
login_port='{{ .Values.database.port }}' \
login_user='{{ .Values.database.root_user }}' \
login_password='{{ .Values.database.root_password }}' \
name='{{ .Values.database.nova_database_name }}'"

ansible localhost -vvv -m mysql_user -a "login_host='{{ include "helm-toolkit.mariadb_host" . }}' \
login_port='{{ .Values.database.port }}' \
login_user='{{ .Values.database.root_user }}' \
login_password='{{ .Values.database.root_password }}' \
name='{{ .Values.database.nova_user }}' \
password='{{ .Values.database.nova_password }}' \
host='%' \
priv='{{ .Values.database.nova_database_name }}.*:ALL' append_privs='yes'"

ansible localhost -vvv -m mysql_db -a "login_host='{{ include "helm-toolkit.mariadb_host" . }}' \
login_port='{{ .Values.database.port }}' \
login_user='{{ .Values.database.root_user }}' \
login_password='{{ .Values.database.root_password }}' \
name='{{ .Values.database.nova_api_database_name }}'"

ansible localhost -vvv -m mysql_user -a "login_host='{{ include "helm-toolkit.mariadb_host" . }}' \
login_port='{{ .Values.database.port }}' \
login_user='{{ .Values.database.root_user }}' \
login_password='{{ .Values.database.root_password }}' \
name='{{ .Values.database.nova_user }}' \
password='{{ .Values.database.nova_password }}' \
host='%' \
priv='{{ .Values.database.nova_api_database_name }}.*:ALL' append_privs='yes'"

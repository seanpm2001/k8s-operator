{{/* The Alluxio Open Foundation licenses this work under the Apache License, version 2.0
(the "License"). You may not use this work except in compliance with the License, which is
available at www.apache.org/licenses/LICENSE-2.0

This software is distributed on an "AS IS" basis, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
either express or implied, as more fully set forth in the License.

See the NOTICE file distributed with this work for information regarding copyright ownership. */}}

{{/* vim: set filetype=mustache: */}}

{{- define "alluxio.site.properties" -}}
# Enable Dora
alluxio.dora.client.read.location.policy.enabled=true
alluxio.user.short.circuit.enabled=false
alluxio.master.worker.register.lease.enabled=false

# Common properties
alluxio.k8s.env.deployment=true
{{- if ne (get .Values.properties "alluxio.mount.table.source") "ETCD" }}
alluxio.dora.client.ufs.root={{ .Values.dataset.path }}
{{- end }}
{{- range $key, $val := .Values.dataset.credentials }}
{{ printf "%v=%v" $key $val }}
{{- end }}
{{- range $key, $val := .Values.properties }}
{{ printf "%v=%v" $key $val }}
{{- end }}
alluxio.cluster.name={{ .Release.Namespace }}-{{ .Release.Name }}

{{- if eq (int .Values.master.count) 1 }}
# Master address for single master
alluxio.master.hostname={{ include "alluxio.fullname" . }}-master-0
{{- end }}

# Journal properties
{{ printf "alluxio.master.journal.folder=%v" (include "alluxio.mount.basePath" "/journal") }}
{{- if gt (int .Values.master.count) 1 }}
{{- $embeddedJournalAddresses := ""}}
{{- range $i := until (int .Values.master.count) }}
  {{- $embeddedJournalAddresses = printf "%v,%v-master-%v:19200" $embeddedJournalAddresses (include "alluxio.fullname" $) $i }}
{{- end }}
{{ printf "alluxio.master.embedded.journal.addresses=%v" $embeddedJournalAddresses }}
{{- end }}

# Page Storage
alluxio.worker.block.store.type=PAGE
alluxio.worker.page.store.type=LOCAL
alluxio.worker.page.store.dirs={{ .Values.pagestore.hostPath }}
{{ printf "alluxio.worker.page.store.sizes=%v" .Values.pagestore.quota }}

# Worker Identity
{{ printf "alluxio.worker.identity.uuid.file.path=%v/worker_identity" (include "alluxio.mount.basePath" "/system-info") }}

# Metastore
alluxio.dora.worker.metastore.rocksdb.dir={{ include "alluxio.mount.basePath" "/metastore" }}

{{- if .Values.etcd.enabled }}
alluxio.worker.membership.manager.type=ETCD
{{ printf "alluxio.etcd.endpoints=http://%v-etcd:%v" .Release.Name .Values.etcd.containerPorts.client }}
{{- end }}

{{- end -}}

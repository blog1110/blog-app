{{/*
Common template functions for naming conventions
*/}}

{{/*
Expand the name of the chart.
*/}}
{{- define "blog.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "blog.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s-%s" $name .Values.environment .Values.app | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "blog.release" -}}
{{- printf "%s" .Release.Name }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "blog.labels" -}}
environment: {{ .Values.environment }}
project: {{ .Values.project }}
owner: {{ .Values.owner }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/Release: {{ include "blog.release" . }}
{{ include "blog.selectorLabels" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "blog.selectorLabels" -}}
app.kubernetes.io/name: {{ include "blog.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "blog.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{- default (printf "%s-serviceaccount" (include "blog.fullname" .)) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

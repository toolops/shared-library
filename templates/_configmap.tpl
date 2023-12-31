{{- define "shared-library.configmap" -}}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "shared-library.fullname" . }}
  labels:
  {{- include "shared-library.labels" . | nindent 4 }}
data: 
  {{ range $k, $v := .Values.config.templates -}}
  {{ $k }}: |
{{- tpl $v $ | nindent 4 }}
  {{ end }}
{{- end -}}

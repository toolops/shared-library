{{- define "shared-library.service" -}}
apiVersion: v1
kind: Service
metadata:
  name: {{ .Release.Name }}-service
  labels:
    monitoring: "true"
  {{- include "shared-library.labels" . | nindent 4 }}
spec:
  type: {{ .Values.service.type }}
  selector:
    app: {{ .Release.Name }}
  {{- include "shared-library.selectorLabels" . | nindent 4 }}
  ports:
	{{- .Values.service.ports | toYaml | nindent 2 -}}
{{- end }}

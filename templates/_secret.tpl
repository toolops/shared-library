{{- define "shared-library.secret" -}}
apiVersion: v1
kind: Secret
metadata:
  name: {{ include "shared-library.fullname" . }}
type: Opaque
stringData: {{- toYaml .Values.secrets | nindent 2 -}}
{{- end -}}
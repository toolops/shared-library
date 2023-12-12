{{- define "shared-library.secret" -}}
apiVersion: v1
kind: Secret
metadata:
  name: {{ include "shared-library.fullname" . }}
type: Opaque
stringData:
{{- range $k, $v := .Values.secrets }}
  {{ $k }}: {{ quote $v }}
{{- end -}}
{{- end -}}

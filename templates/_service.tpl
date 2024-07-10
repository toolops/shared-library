{{- define "shared-library.service" -}}
apiVersion: v1
kind: Service
metadata:
  name: {{ include "shared-library.fullname" . }}
  labels:
    {{- include "shared-library.labels" . | nindent 4 }}
spec:
  type: {{ .Values.service.type }}
  selector:
    {{- include "shared-library.selectorLabels" . | nindent 4 }}
  {{- with .Values.ports }}
  ports:
  {{- range . }}
  - name: {{ .name }}
    port: {{ .servicePort }}
    protocol: {{ .protocol | upper }}
    targetPort: {{ .containerPort }}
	{{- end }}
  {{- end }}
{{- end }}

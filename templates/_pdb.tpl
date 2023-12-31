{{- define "shared-library.pdb" -}}
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: {{ include "shared-library.fullname" . }}
  labels:
    {{- include "shared-library.labels" . | nindent 4 }}
spec:
  minAvailable: {{ required "value 'pdb.minAvailable' is required" .Values.pdb.minAvailable }}
  selector:
    matchLabels:
      {{- include "shared-library.labels" . | nindent 6 }}
{{- end }}

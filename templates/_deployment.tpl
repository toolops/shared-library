{{- define "shared-library.deployment" -}}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Release.Name }}-deployment
  labels:
  {{- include "shared-library.labels" . | nindent 4 }}
spec:
  replicas: {{ .Values.deployment.replicas }}
  selector:
    matchLabels:
      app: {{ .Release.Name }}
      {{- include "shared-library.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      labels:
        app: {{ .Release.Name }}
        environment: {{ .Values.environment }}
        {{- include "shared-library.selectorLabels" . | nindent 8 }}
      {{- if .Values.config }}
      annotations:
        checksum/config: {{ include ("shared-library.configmap") . | sha256sum }}
      {{- end }}
    spec:
      {{- if .Values.deployment.affinity }}
      affinity:
        {{- toYaml .Values.deployment.affinity | nindent 8 -}}
      {{- end }}
      containers:
      - name: {{ .Release.Name }}
        {{- if .Values.deployment.env}}
        env:
        {{- if .Values.deployment.env -}}
        {{- range $k, $v := .Values.deployment.env }}
        - name: {{ $k }}
          value: {{ quote $v }}
        {{- end -}}
        {{- end }}
      {{- end -}}
        image: {{ .Values.deployment.image.repository }}:{{ .Values.deployment.image.tag | default .Chart.AppVersion }}
        imagePullPolicy: {{ .Values.deployment.imagePullPolicy }}
        {{- if .Values.deployment.startupProbe }}
        startupProbe: {{- toYaml .Values.deployment.startupProbe | nindent 10 }}
        {{- end }}
        {{- if .Values.deployment.readinessProbe }}
        readinessProbe: {{- toYaml .Values.deployment.readinessProbe | nindent 10 }}
        {{- end }}
        {{- if .Values.deployment.livenessProbe }}
        livenessProbe: {{- toYaml .Values.deployment.livenessProbe | nindent 10 }}
        {{- end }}
        {{- if .Values.deployment.ports }}
        ports: {{- toYaml .Values.deployment.ports | nindent 8 }}
        {{- end }}
        {{- if .Values.deployment.resources }}
        resources: {{- toYaml .Values.deployment.resources | nindent 10 }}
        {{- end }}
        {{- if .Values.deployment.containerSecurityContext }}
        securityContext: {{- toYaml .Values.deployment.containerSecurityContext | nindent 10 }}
        {{- end }}
        {{- if or (.Values.deployment.volumeMounts) (.Values.config) }}
        volumeMounts:
        {{- if .Values.config }}
        - mountPath: {{ .Values.config.mountPath }}
          name: {{ .Release.Name }}-config
        {{- end -}}
        {{- if .Values.deployment.volumeMounts }}
        {{- toYaml .Values.deployment.volumeMounts | nindent 8 }}
        {{- end -}}
        {{- end }}
      {{- if .Values.deployment.imagePullSecret }}
      imagePullSecrets:
      - name: {{ .Values.deployment.imagePullSecret }}
      {{- end }}
      {{- if .Values.deployment.tolerations }}
      tolerations: {{- toYaml .Values.deployment.tolerations | nindent 6 }}
      {{- end }}
      {{- if or (.Values.volumes) (.Values.config) }}
      volumes:
      {{- if .Values.config }}
      - configMap:
          name: {{ .Release.Name }}-configmap
        name: {{ .Release.Name }}-config
      {{- end -}}
      {{- if .Values.volumes -}}
      {{- toYaml .Values.volumes | nindent 6 }}
      {{- end -}}
      {{- end -}}
{{- end -}}

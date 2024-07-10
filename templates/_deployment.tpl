{{- define "shared-library.deployment" -}}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "shared-library.fullname" . }}
  labels:
    {{- include "shared-library.labels" . | nindent 4 }}
spec:
  {{- if not .Values.autoscaling.enabled }}
  replicas: {{ .Values.replicaCount }}
  {{- end }}
  selector:
    matchLabels:
      {{- include "shared-library.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      {{- if or (.Values.podAnnotations) (.Values.config) }}
      annotations:
        {{- if .Values.podAnnotations }}
        {{- toYaml .Values.podAnnotations | nindent 8 }}
        {{- end }}
        {{- if .Values.config }}
        checksum/config: {{ include ("shared-library.configmap") . | sha256sum}}
        {{- end }}
      {{- end }}
      labels:
        {{- include "shared-library.labels" . | nindent 8 }}
	{{- with .Values.podLabels }}
        {{- toYaml . | nindent 8 }}
        {{- end }}
    spec:
      {{- with .Values.imagePullSecrets }}
      imagePullSecrets:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      serviceAccountName: {{ include "shared-library.serviceAccountName" . }}
      securityContext:
        {{- toYaml .Values.podSecurityContext | nindent 8 }}
      containers:
        - name: {{ .Chart.Name }}
          securityContext:
            {{- toYaml .Values.securityContext | nindent 12 }}
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          {{- with .Values.environment }}
          env:
          {{- toYaml . | nindent 10 }}
          {{- end }}
          {{- with .Values.ports }}
          ports:
          {{- range . }}
          - containerPort: {{ .containerPort }}
            name: {{ .name }}
            protocol: {{ .protocol | upper }}
          {{- end -}}
          {{- end -}}
          {{- if .Values.startupProbe }}
          startupProbe: {{- toYaml .Values.startupProbe | nindent 10 }}
          {{- end }}
          {{- if .Values.readinessProbe }}
          readinessProbe: {{- toYaml .Values.readinessProbe | nindent 10 }}
          {{- end }}
          {{- if .Values.livenessProbe }}
          livenessProbe: {{- toYaml .Values.livenessProbe | nindent 10 }}
          {{- end }}
          resources:
            {{- toYaml .Values.resources | nindent 12 }}
          {{- with .Values.volumeMounts }}
          volumeMounts:
            {{- toYaml . | nindent 12 }}
          {{- end }}
      {{- with .Values.volumes }}
      volumes:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.nodeSelector }}
      nodeSelector:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.affinity }}
      affinity:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.tolerations }}
      tolerations:
        {{- toYaml . | nindent 8 }}
      {{- end }}

{{- end -}}

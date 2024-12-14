dex:
  enabled: false
global:
  domain: $ARGOCD_HOSTNAME
server:
  ingress:  
    enabled: true
    tls: 
      - secretName: secret-tls
        hosts:
          - $ARGOCD_HOSTNAME
  extraArgs:
    - --insecure
  config:
    repositories: |
      - type: helm
        name: stable
        url: https://charts.helm.sh/stable
      - type: helm
        name: argo-cd
        url: https://argoproj.github.io/argo-helm
configs:        
  secret:
    argocdServerAdminPassword: "$ARGOCD_PASSWORD_ENC"
    argocdServerAdminPasswordMtime: "2021-11-07T13:47:35Z"
applicationSet:
  enabled: false

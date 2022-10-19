installCRDs: false
dex:
  enabled: false
server:
  ingress:  
    enabled: true
    hosts: [ $ARGOCD_HOSTNAME ]
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

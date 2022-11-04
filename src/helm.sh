function helm_install {
    local FOUND=`whereis helm | awk '{print $2}'`
    if [ -z "$FOUND" ];
    then
        curl -fsSL -o /tmp/get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
        chmod 700 /tmp/get_helm.sh
        /tmp/get_helm.sh

        helm_install_repos
    fi
}

function helm_install_repos {
    helm repo add argo https://argoproj.github.io/argo-helm
    helm repo update
}
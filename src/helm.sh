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

function helm_install_tls {
    local APP_PATH=$K3S_BASE/../config/tls/app/tls.yaml
    local CHART_PATH=vendor/k3s-base/config/tls/chart
    PATH=$CHART_PATH kubectl apply -n argocd -f $APP_PATH
    #local NAMESPACE=$1
    #local NAME=$2

    #if [ -z "$NAME" ];
    #then
    #    local NAME=secret-tls
    #fi
    
    #local CRT=`cat "$CERT" | base64 | tr --delete '\n'` 
    #local KEY=`cat "$PRIVATE_KEY" | base64 | tr --delete '\n'`    
    #echo "$K3S_BASE/../config/tls/" 
    #exit;
    #helm upgrade --install \
    #    "secret-tls-$NAMESPACE" \
    #    -n $NAMESPACE \
    #    --set crt="$CRT" \
    #    --set key="$KEY" \
    #    --set name="$NAME" \
    #    "$K3S_BASE/../config/tls/" 
}
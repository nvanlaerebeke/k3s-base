function bootstrap {
    check_requirements
    check_config
}

function check_requirements {
    REQUIRED=("cat" "sudo" "base64" "tr" "helm" "kubectl" "kubeseal" "htpasswd" )
    for t in ${REQUIRED[@]}; 
    do
        local FOUND=`whereis $t | awk '{print $2}' | tr --delete '\n'`
        if [ -z "$FOUND" ];
        then
            echo "$t cannot be found, please install it"
            exit 1
        fi
    done
}

function check_config {
    if [ -z "$ARGOCD_HOSTNAME" ];
    then
        echo "ARGOCD_HOSTNAME not set in config"
        exit
    fi

    if [ -z "$ARGOCD_PASSWORD" ];
    then
        echo "ARGOCD_PASSWORD is not set in config"
        exit
    fi

    if [ -z "$GIT_URL" ];
    then
        echo "GIT_URL is not set"
        exit
    fi

    if [ -z "$GIT_KEY" ];
    then
        echo "GIT_KEY is not set"
        exit
    fi
}
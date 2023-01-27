function bootstrap {
    check_requirements
    check_config
    base_setup
}

function check_requirements {
    REQUIRED=("cat" "sudo" "base64" "tr" "kubeseal" "htpasswd" "touch" )
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
    if [ -z "$ROOT" ];
    then
        echo "ROOT not set, invalid exec file?"
        exit
    fi

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

function base_setup {
    local INCLUDE="$ROOT/lib/include.sh"
    local ARGO_APP_DIR="$ROOT/applications/argocd"
    local ARGO_CHART_DIR="$ROOT/applications/charts"

    if [ ! -f "$INCLUDE" ];
    then
        mkdir -p `dirname "$INCLUDE"`
        cat << EOF > "$INCLUDE"

function configure {
    echo "No custom charts have been added yet"
}

EOF
    fi

    if [ ! -d "$ARGO_APP_DIR" ];
    then
        mkdir -p "$ARGO_APP_DIR"
    fi

    if [ ! -d "$ARGO_CHART_DIR" ];
    then
        mkdir -p "$ARGO_CHART_DIR"
    fi

    if [ ! -f "$ROOT/.gitignore" ];
    then
        cat << EOF > "$ROOT/.gitignore"
settings.env
config
EOF
    fi

    if [ ! -f "$ROOT/config/sealed-secrets/tls.key" ];
    then
        secrets_create_keys
    fi
}

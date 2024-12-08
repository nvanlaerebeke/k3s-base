function secrets_install {
    local EXISTS=`kubectl get pods -A | grep 'sealed-secrets' | wc -l`

    if [ $EXISTS -ne 0 ];
    then
        echo "Sealed serets already deployed and running, skipping..."
        return;
    fi

    secrets_create_keys
}

function secrets_create_keys {
    local SEALED_SECRETS_PATH="$ROOT/config/sealed-secrets"
    local PRIVATEKEY="$SEALED_SECRETS_PATH/tls.key"
    local PUBLICKEY="$SEALED_SECRETS_PATH/tls.crt"
    local NAMESPACE="kube-system"
    local SECRETNAME="secret.$DOMAIN"

    if [ ! -d "$SEALED_SECRETS_PATH" ];
    then
        echo "sealed secrets directory '$SEALED_SECRETS_PATH' does not exist, creating"
        mkdir -p "$SEALED_SECRETS_PATH"
    fi

    if [ ! -f "$PRIVATEKEY" ];
    then
        echo "Sealed secrets key ($PRIVATEKEY) does not exist, generating new key..."
        openssl req -x509 -nodes -newkey rsa:4096 -days 3650 -keyout "$PRIVATEKEY" -out "$PUBLICKEY" -subj "/CN=sealed-secret/O=sealed-secret"
    fi

    local EXISTS=`kubectl get secrets -n "$NAMESPACE" | grep "$SECRETNAME" | wc -l`
    if [ $EXISTS -gt 0 ];
    then
        echo "Secret with custom sealed secrets key already exists, delete it first if a new one is required"
        return;
    fi

    kubectl -n "$NAMESPACE" create secret tls "$SECRETNAME" --cert="$PUBLICKEY" --key="$PRIVATEKEY"
    kubectl -n "$NAMESPACE" label secret "$SECRETNAME" sealedsecrets.bitnami.com/sealed-secrets-key=active
    kubectl -n "$NAMESPACE" delete pod -l name=sealed-secrets-controller
}

function secrets_enc {
    SEALED_SECRET=`kubeseal --controller-name sealed-secrets`
}

function secrets_seal {
    kubeseal --cert "$ROOT/config/sealed-secrets/tls.crt" --controller-name sealed-secrets -o yaml < "$1"
}

function secrets_seal_update_key {
    local SEALED_SECRETS_PATH="$ROOT/config/sealed-secrets"
    local PRIVATEKEY="$SEALED_SECRETS_PATH/tls.key"
    local PUBLICKEY="$SEALED_SECRETS_PATH/tls.crt"
    local NAMESPACE="kube-system"
    local LABEL="sealedsecrets.bitnami.com/sealed-secrets-key=active"

    kubectl get secret -n "$NAMESPACE" -l "$LABEL" -o jsonpath='{.items[0].data.tls\.key}' | base64 -d > "$PRIVATEKEY"
    kubectl get secret -n "$NAMESPACE" -l "$LABEL" -o jsonpath='{.items[0].data.tls\.crt}' | base64 -d > "$PUBLICKEY"
}
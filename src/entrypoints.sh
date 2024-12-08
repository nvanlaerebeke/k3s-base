function start {
    k3s_start
    helm_install
    secrets_install
    argocd_install
    config
}

function stop {
    k3s_stop
}

function uninstall {
    k3s_uninstall
}

function config {
    argocd_install_application "$K3S_BASE/../applications/argocd/cluster-config.yaml"
    argocd_install_application "$K3S_BASE/../applications/argocd/sealed-secrets.yaml"
}

function seal {
    secrets_seal $1
}

function seal-update {
    secrets_seal_update_key
}
function argocd_install {
	create_namespace argocd
	argocd_install_app
	argocd_install_repository
}

function argocd_install_app {
    argocd_generate_password_enc

	ARGOCD_PASSWORD_ENC=$ARGOCD_PASSWORD_ENC ARGOCD_HOSTNAME=$ARGOCD_HOSTNAME envsubst < "$K3S_BASE/../config/argocd/values.yaml.tpl" > "$ROOT/config/argocd.yaml"
	
    helm_install_repos
    helm upgrade \
		--install \
		argocd \
		argo/argo-cd \
		-n argocd \
		-f "$ROOT/config/argocd.yaml"
}

function argocd_generate_password_enc {
    ARGOCD_PASSWORD_ENC=`htpasswd -nbBC 10 "" "$ARGOCD_PASSWORD" | tr -d ':\n' | sed 's/$2y/$2a/'`
}

function argocd_install_repository {
    local GIT_KEY_VALUE=`cat "$GIT_KEY" | sed 's/^/    /'`
    GIT_KEY=$GIT_KEY_VALUE GIT_URL=$GIT_URL envsubst < "$K3S_BASE/../config/repositories/repository.yaml" | kubectl apply -n argocd -f -
}

function argocd_install_application {
	GIT_KEY=$GIT_KEY_VALUE GIT_URL=$GIT_URL envsubst < "$1" | kubectl apply -n argocd -f -
}
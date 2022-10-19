.PHONY: repo install uninstall template

repo:
	helm repo add argo https://argoproj.github.io/argo-helm

namespace:
	../../bin/main.sh namespace argocd

install:
	helm upgrade \
		--install \
		argocd \
		argo/argo-cd \
		-n argocd \
		-f values.yaml

uninstall:
	helm uninstall -n argocd argocd

template:
	helm template \
		argocd \
		argo/argo-cd \
		-n argocd \
		-f values.yaml


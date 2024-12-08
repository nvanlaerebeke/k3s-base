K3S_BASE="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)/src/"

. $ROOT/settings.env
. $K3S_BASE/argocd.sh
. $K3S_BASE/bootstrap.sh
. $K3S_BASE/entrypoints.sh
. $K3S_BASE/helm.sh
. $K3S_BASE/k3s.sh
. $K3S_BASE/kubectl.sh
. $K3S_BASE/sealed_secrets.sh

bootstrap

case $1 in
start)
  start; exit;
  ;;
stop)
  stop; exit;
  ;;
uninstall)
  uninstall ; exit;
  ;;
base_config)
  config ; exit;
  ;;
seal)
  seal $2; exit;
  ;;
seal-update)
  seal-update; exit;
  ;;
esac
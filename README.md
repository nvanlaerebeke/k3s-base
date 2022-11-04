# k3s-base

Base framework to start and stop k3s environments based on argocd

This is used to set up an environment based on gitops, so a git repository will be required for your environments.

## Requirements

- cat
- sudo
- tr
- helm 
- kubectl
- htpasswd
- [kubeseal](https://github.com/bitnami-labs/sealed-secrets/releases)

## Setup

### Step 1

Create a new git repository and add a new bash file that adds this repository as a module

Example:

```
cd <new git repo>
git submodule add https://github.com/nvanlaerebeke/k3s-base.git ./vendor/k3s-base
```

### Step 2

Setup the project by creating a new bash script that includes the k3s-base and includes the configuration.

Create the config file:

```
cat <<EOF > settings.env
#
# DOMAIN name for this environment
#
DOMAIN=

#
# Hostname that will be used to access the argocd installation of this cluster
# ex. : argocd.example.com
#
ARGOCD_HOSTNAME=

#
# Password that will be used to access the argocd installation
# default username is 'admin' 
# ex. : password
#
ARGOCD_PASSWORD=

#
# GIT repository where the argocd configuration files are
# default is the current repository
#
GIT_URL=`git config --get remote.origin.url`

#
# GIT ssh key to connect to the above repository
#
GIT_KEY=
EOF
```

Create the entrypoint to control the project:

```
cat <<EOF > exec
#!/bin/bash
ROOT="\$(cd "$(dirname "\${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

. \$ROOT/vendor/k3s-base/include.sh
. \$ROOT/lib/include.sh

case \$1 in
configure)
  echo "Configure Environment"
  configure
  ;;
*)
  echo "Please provide a valid action"
  exit 1
  ;;
esac

EOF
chmod +x exec
```

The file above is just a baseline, can be extended for the project in question.

### Step 3

By default the following will be deployed:

- argocd
- basic cluster configuration
- sealed-secrets

Launch the environment by running:

```console
./exec start
```

Wait a bit and once argocd has started up it will be reachable on the configured URL and password, the default user is `admin`.

## Usage

Build in commands are:

- start: starts/installs the k3s cluster
- stop: stops the k3s cluster
- uninstall: removes k3s entirely
- base_config: installs the base configuration
- seal: creates the sealed secret

## Adding your own charts

To start there are several examples available in the examples folder.  

Create the application yaml in `applications/argocd/<app>.yaml` and add the cart in `applications/charts/<app>`.  

## Working with sealed secrets

Secrets should never be put on a git repository, for this reason they're encrypted and can only be decrypted by the cluster itself.  
To do this sealed-secrets is installed by default and a key is generated.  

The keys are located in config/sealed+secrets, make sure to backup these keys when using secrets.  

To create a `SealedSecret`, first create the secret that needs to be encrypted, example:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: digitalocean-dns
  namespace: cert-manager
data:
  # insert your DO access token here
  access-token: "base64 encoded access-token here"
```

Make sure to fill in the namespace, this is important!

Now get the encrypted version by running:

```console
./exec seal /tmp/secret.yaml
```
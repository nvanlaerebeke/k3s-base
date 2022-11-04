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

## Usage

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

EOF
```

Create the entrypoint to control the project:

```
cat <<EOF > exec
#!/bin/bash
ROOT="\$(cd "$(dirname "\${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

. \$ROOT/vendor/k3s-base/include.sh

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
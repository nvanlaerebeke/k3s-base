function k3s_install {
    curl -sfL https://get.k3s.io | sh - 
    if [ ! -f "/usr/local/bin/kubectl" ];
    then
        sudo ln -s /usr/local/bin/k3s /usr/local/bin/kubectl
    fi
}

function k3s_uninstall {
    if [ -L "/usr/local/bin/kubectl" ];
    then
        unlink "/usr/local/bin/kubectl"
    fi
    /usr/local/bin/k3s-uninstall.sh    
}

function k3s_start {
    local STATUS=`sudo systemctl is-active k3s | tr -d "\n"`

    if [ "$STATUS" == "inactive" ];
    then
        k3s_install
    elif [ "$STATUS" == "failed" ];
    then
        sudo systemctl start k3s
    fi

    if [ ! -d ~/.kube ];
    then
        mkdir ~/.kube
    fi

    if [ ! -f "~/.kube/config" ];
    then
        sudo cp "/etc/rancher/k3s/k3s.yaml" ~/.kube/config
        sudo chown -R $USER:$USER ~/.kube/
        chmod 600 ~/.kube/config
    fi
 
    sudo chmod 644 /etc/rancher/k3s/k3s.yaml

    k3s_firewall
}

function k3s_stop {
    sudo systemctl stop k3s
}

function k3s_firewall {
    local HTTP_PORT_COUNT=`sudo ufw status verbose | grep "80/tcp" | wc -l`
    local HTTPS_PORT_COUNT=`sudo ufw status verbose | grep "443" | wc -l`

    if [ $HTTP_PORT_COUNT -eq 0 ];
    then
        sudo ufw allow http
    fi

    if [ $HTTPS_PORT_COUNT -eq 0 ];
    then
        sudo ufw allow https
    fi
}
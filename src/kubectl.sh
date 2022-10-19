function create_namespace {
    local NAME=$1
    local NAMESPACE=`kubectl get namespace | awk '{print $1}' | grep -x "$NAME" | wc -l`

    if [ $NAMESPACE -eq 0 ];
    then
        echo "Create the $NAME namespace"
        kubectl create namespace "$NAME"
    else 
        echo "$NAME namespace already exists"
    fi
}
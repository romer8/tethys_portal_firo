# K8s and Helm Development Tips

## Setup K8s Dev Environment with Docker Desktop

* Enable k8s in Docker Desktop: https://docs.docker.com/desktop/kubernetes/
* Install kubectl:
* Install helm:
* Switch to the Docker desktop context:

    ```bash
    kubectl config use-context docker-desktop
    ```

## Install the K9s Dashboard

* Install K9s Dashboard: https://k9scli.io/topics/install/

## Install the Nginx Ingress Controller

* Install Nginx ingress controller: https://kubernetes.github.io/ingress-nginx/deploy/#aws
* Using the K8s Dashboard, update the ConfigMap for the Nginx Ingress Controller to allow larger file uploads (see: https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/configmap/):

    ```json
    {
        ...
        "proxy-body-size": "1G"
    }
    ```

## Update Dependencies

```bash
helm dep up
```

## Lint and Package

``` bash
helm lint . && helm package .
```

## Setup namespace (helm 3 does not do this by default):

```bash
kubectl create namespace firoportal
kubectl config set-context docker-desktop --namespace=firoportal
```

## Run helm install:

```bash
helm install -n firoportal -f values-local.yaml firoportal firoportal-<version>.tgz
```

### Remove

```bash
helm uninstall -n firoportal firoportal
```

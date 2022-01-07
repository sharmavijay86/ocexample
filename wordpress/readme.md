# setup wordpress with helm chart

- this folder have a wordpress values.yaml, which you can modify based on your need. No need to give any DB password as this generates one during initialization.
- this helm chart command will setup mariadb Statefullset also, so no need to setup seperatly.
- if your wordpress pod is crashing and restarting initially, dont worry about it, it may restart atleast 6+ times to get stable so just wait.
- To run the helm command use bellow 

### Repo add by bitnami

```
helm repo add bitnami https://charts.bitnami.com/bitnami
```

### check the versions available

```
helm search repo wordpress --versions
```

### choose desired version to setup and run this

```
kubectl create namespace nswordpress

helm install wordpress bitnami/wordpress --values=wordpress-values.yaml --namespace nswordpress --version 10.0.3
```

### if you wish to see the readme of any particuler version do this

```
helm show readme bitnami/wordpress --version 10.0.3
```

### if you wish to see the values.yaml of any particuler version do this

```
helm show values bitnami/wordpress --version 10.0.3
```

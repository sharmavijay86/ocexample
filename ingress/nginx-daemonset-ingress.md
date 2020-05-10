### Nginx Ingress Controller

In order to setup nginx as ingress controller daemonset use bellow -

1) create a new namespace

```kubectl create ns ingress```

2) label master node ( because controller will run on master as daemonset and we will use master node ip as ingress ip )

```kubectl label node kmaster.mevijay.com master=true```

3) add stable helm repo ( if not already have )

```helm repo add stable https://kubernetes-charts.storage.googleapis.com```

4) install nginx ingress controller
```
helm install nginx stable/nginx-ingress --namespace=ingress \
--set controller.kind=DaemonSet \
--set controller.hostNetwork=true \
--set-string  controller.nodeSelector.master=true \
--set controller.daemonset.useHostPort=true  \
--set controller.daemonset.hostPorts.https=443 \
--set controller.service.type=""
```
5) make enable master to run daemonset 

```kubectl taint nodes kmaster.mevijay.com node-role.kubernetes.io/master:NoSchedule\```

Done!

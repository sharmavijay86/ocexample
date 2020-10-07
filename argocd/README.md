***Argocd setup***   

```
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v1.7.7/manifests/ha/install.yaml
```

***Ingress for contour***      

```
apiVersion: projectcontour.io/v1
kind: HTTPProxy
metadata:
  name: argo
spec:
  virtualhost:
    fqdn: argocd.k8s.mevijay.com
    tls:
      passthrough: true
  tcpproxy:
    services:
    - name: argocd-server
      port: 443
```

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
## argocd working cli 
```
argocd login  --server https://argocd.k8s.myk8s.com --username admin --password myhardpass --grpc-web argocd.k8s.myk8s.com
argocd cluster add arn:aws:eks:us-east-2:333333333:cluster/eks-demo --name aws-eksdemo
```

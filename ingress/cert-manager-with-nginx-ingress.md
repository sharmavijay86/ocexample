## Cert Manager ( Lets encrypt ) with Nginx Ingress

1) create a namespace 

```kubectl create namespace cert-manager```

2) add jetstack helm repo 
```
helm repo add jetstack https://charts.jetstack.io
helm repo update
```
3) now install cert-manager along with crd

```helm install cert-manager jetstack/cert-manager --namespace cert-manager --version v0.15.0  --set installCRDs=true```

4) validate installation 
```
$ kubectl get pods --namespace cert-manager

NAME                                       READY   STATUS    RESTARTS   AGE
cert-manager-5c6866597-zw7kh               1/1     Running   0          2m
cert-manager-cainjector-577f6d9fd7-tr77l   1/1     Running   0          2m
cert-manager-webhook-787858fcdb-nlzsq      1/1     Running   0          2m
```

5) Create a Certificate issuer 
```
vim issuer.yaml

apiVersion: cert-manager.io/v1alpha2
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
  labels:
    name: letsencrypt-prod
spec:
  acme:
    email: EMAIL-ADDRESS
    privateKeySecretRef:
      name: letsencrypt-prod
    server: https://acme-v02.api.letsencrypt.org/directory
    solvers:
    - http01:
        ingress:
          class: nginx
```

Change EMAIL-ADDRESS with your email id 

save and exit 

6) now apply this to kubernetes
```
kubectl apply -f issuer.yaml
```

7) in order to test add bitnami helm repo 

```
helm repo add bitnami https://charts.bitnami.com/bitnami
```

8) run a joomla deploymnet 
```
helm upgrade joomla bitnami/joomla \
  --set joomlaPassword=secretpassword \
  --set mariadb.root.password=secretpassword \
  --set service.type=ClusterIP \
  --set ingress.enabled=true \
  --set ingress.certManager=true \
  --set ingress.tls[0].secretName=joomla.local-tls \
  --set ingress.annotations."kubernetes\.io/ingress\.class"=nginx \
  --set ingress.annotations."cert-manager\.io/cluster-issuer"=letsencrypt-prod \
  --set ingress.tls[0].hosts[0]=DOMAIN \
  --set ingress.hosts[0].name=DOMAIN
  ```
  
  replace DOMAIN with your domain name
  
 9) Now acme pod along with joomla pods will be apear and once certificate issued it will terminate. you can see certificate issued using bellow
  ```
  $ kubectl get certificate
NAME               READY   SECRET             AGE
joomla.local-tls   True    joomla.local-tls   8m26s
```

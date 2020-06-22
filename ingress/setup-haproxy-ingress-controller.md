### Setup and install

Setup haproxy ingress controller

```$ kubectl create -f https://haproxy-ingress.github.io/resources/haproxy-ingress.yaml```

If wish to change controller image version etc follow bellow else optional

```$ kubectl -n ingress-controller edit configmap haproxy-ingress```
```$ kubectl -n ingress-controller edit daemonset haproxy-ingress```

now label master node or worker node - ( note the node ip will be haproxy route frontend ip )

``` $ kubectl label node k8smaster.mylab.local role=ingress-controller```

And Done!!

### test run

deploy and expose nginx to test 

```$ kubectl create deployment nginx --image nginx:alpine```
```$ kubectl expose deployment nginx --port=80```

Now create ingress.yaml

```apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: nginx
spec:
  rules:
  - host: webapp1.mevijay.com
    http:
      paths:
      - backend:
          serviceName: nginx
          servicePort: 80
        path: /
```        
        
Apply ingress now

``` kubectl apply -f ingress.yaml```

And done!!

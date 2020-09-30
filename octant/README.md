### Octant on kubernetes   
1. Use dockerfile to build your own docker image, use that in deployment.
1. manifest directory containes required deployment yamls.
2. A kubeconfig context is required to mount using config map.

###### How to use ?   
Create configmap as per your kubeconfig
```
kubectl create configmap octant-ctx --from-file=config
```

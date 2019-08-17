
### Install helm cli from 
```
https://github.com/kubernetes/helm/releases
```

### Install helm tiller
```
wget https://get.helm.sh/helm-v2.14.3-linux-amd64.tar.gz
tar xvf helm-v2.14.3-linux-amd64.tar.gz 
cd linux-amd64/
cp helm /usr/local/bin/
cp tiller /usr/local/bin/
chmod +x /usr/local/bin/*
oc project kube-system
helm init --wait
oc -n kube-system get deployments
oc create serviceaccount --namespace kube-system tiller
oc create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
oc patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'
helm install stable/heapster
oc get pods
```

### Deploy Redis example
```
helm install stable/redis
```

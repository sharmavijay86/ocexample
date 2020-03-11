Install metrics-server in kubernetes

Add helm repo 

```$ helm repo add stable https://kubernetes-charts.storage.googleapis.com```

search metrics-server helm chart 

```$ helm search repo metrics-server
NAME                 	CHART VERSION	APP VERSION	DESCRIPTION                                       
stable/metrics-server	2.10.0       	0.3.6      	Metrics Server is a cluster-wide aggregator of ...
```
inspect chart values to alter them 

```$ helm inspect values stable/metrics-server > /tmp/metrics-server.values```

edit values as bellow-

```$ vim /tmp/metrics-server.values```

in hostnetwork: 

set

```enabled: true```

and in 

args:

uncomment 
```
args:
- --kubelet-insecure-tls
```

save and exit

```
$ kubectl create ns metrics

$ helm install metrics-server stable/metrics-server --namespace metrics --values /tmp/metrics-server.values

$ helm ls -n metrics
NAME          	NAMESPACE	REVISION	UPDATED                                	STATUS  	CHART                	APP VERSION
metrics-server	metrics  	1       	2020-03-12 00:58:20.999663318 +0530 IST	deployed	metrics-server-2.10.0	0.3.6      

$ kubectl get all -n metrics

$ kubectl top node
NAME                  CPU(cores)   CPU%   MEMORY(bytes)   MEMORY%   
kmaster.mylab.local   125m         6%     1351Mi          17%       
knode1.mylab.local    49m          2%     507Mi           6%        
knode2.mylab.local    51m          2%     499Mi           6%        
knode3.mylab.local    57m          2%     493Mi           6%   
```

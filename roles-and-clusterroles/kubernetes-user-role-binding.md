Refernace -

User: developer

Project: project

Create a project for user developer

```# kubectl create ns project```

create a directory for user certificates

```# mkdir developer && cd developer```

generate a user key 

```# openssl genrsa -out developer.key 2048```

generate certificate signing request. Considering username as developer. You can use own username in CN section.

```# openssl req -new -key developer.key -out developer.csr -subj "/CN=developer/O=mevijay"```

Now signe the CSR using kubernetes cluster CA certificate and key. You can copy these certificate and key from kubernetes server to local jump server etc if you wish or generate user certificate in directly kubernetes master node.

```# openssl x509 -req -in developer.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out developer.crt -days 500```

create a role file yaml

```# vim developerrole.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: project
  name: project-manager
rules:
- apiGroups: ["", "extensions", "apps"] 
  resources: ["pods", "deployments", "replicasets"]
  verbs: ["get", "watch", "list", "create", "update", "patch", "delete"]
  create role```
 
# kubectl create -f developerrole.yaml
  ```
 
 Now create a rolebinding file for user and role

``` # vim developerrolebinding.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: project-manager
  namespace: project
subjects:
- kind: User
  name: developer 
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: project-manager 
  apiGroup: rbac.authorization.k8s.io
  ```
  Now create the rolebinding
  ```
# kubectl create -f developerrolebinding.yaml
  ```
  now create user developer crdedentials using certificate

```# kubectl config set-credentials developer --client-certificate=/root/developer.crt --client-key=/root/developer.key```

and set the context for namespace and cluster 

```# kubectl config set-context developer-context --cluster=kubernetes --namespace=project --user=developer```

Now you can generate a separate config for user by copying .kube/config file to otherplace and delete cluster roles of admin

so file will be like 

```
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LabcdURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRereretsdsfsdsdJME0xb1hEVE13TURReU5qSXdNekkwTTFvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBTUxwCnZrVzVmUDRqMGRkWE5jc2VFVmcrY1ppZ2YxRmhZN09SNE96THR0U3dZMGRUdmRTQkRvNjlPTWQzWFgrbXdXYlQKVmc0ZkNaczhkaUZLWitHNitBdUJ2OTVaWmJEcVpSWnQrVDZEb2dZK0J4QTZlSCt2U0RvVmc1NXVja1NXS0dEZgpKR3VjRU1Nb3QvNnRhNzdPcFREV0Z4UTNoNG9SUTN0T01YMUNYUml5bU5uMkhQbzBmYlI5YnRDMkRVVXhwTGtGCkpOSFVRZlNrdWNtQUE0WVBOMzU4bzdqekJyU1lpbkpPR2ZhQytOaEtOeUF3RlJ0WEx5UDI4eWFBbS9hK3NQUE8KcktEWWYwQXZMKzVVWk1OMTRFTmFWYmtwaW9mUGd3ZlZTbG45SmNlT0s2R29MQzE1SE1OSkRSYXFnNllmeUZqbAo2aEYyL0lyUmRPdENIWTh5N3hFQ0F3RUFBYU1qTUNFd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0RRWUpLb1pJaHZjTkFRRUxCUUFEZ2dFQkFHZ0oxa1dCRDZuRE9FWkZXZlNIUjUwdnRoWUMKcU82Rk5BUVptT1FDMlBBZXZ4V2l3bGNRTkU3RmlsZ3lRSDdiTzJYeklBL0dVTG1sQjFJWWU2VDk2czUzUVJiaQo3TnVDdHg4N2g5SEtabDRrbHZVTUtjS0NqeWZlVUpRM3M0ZE4zMUkrTS9jOThxZno5RnZTL2dmYks3RGZoVFJxCkhGSzVPWWNRZlk5MHkrY3lPTVVqRnE3azhFK004cHlPNEdTRU9rVFRSbTYySEdNYkJQVkFQT25BeGc2MFRpUDIKb3k3bUxrYmZrNkxFVUxjSFQyT2dkeUVzMG5XbXg3WlZWMmtXT0VZVVVqS0Z5cVpCVTJKbnpTL2grVzNTdDNhWQo2ZE5EZnZGR2JBeSsvaGlFL29JOHMzTTJUaVNVREtLeWdXMHRMYkd4em1rQjc4L244Wkx2eU5UUUNnbz0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=
    server: https://192.168.100.50:6443
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    namespace: project
    user: developer
  name: developer-context
current-context: developer-context
kind: Config
preferences: {}
users:
- name: developer
  user:
    client-certificate: /root/developer.crt
    client-key: /root/developer.key

```


## Work in progress
####  subdomain based ingress
```sh
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: ingress
spec:
  rules:
  - host: api.mydomain.com
    http:
      paths:
        - backend:
            serviceName: api-service
            servicePort: 80
  - host: console.mydomain.com
    http:
      paths:
        - backend:
            serviceName: console-service
            servicePort: 80
```

## here is an example

```
  apiVersion: extensions/v1beta1
  kind: Ingress
  metadata:
    annotations:
      kubernetes.io/ingress.class: nginx
    name: example
    namespace: foo
  spec:
    rules:
      - host: www.example.com
        http:
          paths:
            - backend:
                serviceName: exampleService
                servicePort: 80
              path: /
    # This section is only required if TLS is to be enabled for the Ingress
    tls:
        - hosts:
            - www.example.com
          secretName: example-tls
```
If TLS is enabled for the Ingress, a Secret containing the certificate and key must also be provided:
```
  apiVersion: v1
  kind: Secret
  metadata:
    name: example-tls
    namespace: foo
  data:
    tls.crt: <base64 encoded cert>
    tls.key: <base64 encoded key>
  type: kubernetes.io/tls

```
Creating a tls secret you can generate csr and key pair first using bellow command. Send this to your CA get a certificate signed and post that using key and cert, create  a new secret to be used in above ingress example.

to generate the csr.   
```
openssl req -new -newkey rsa:2048 -nodes -keyout server.key -out server.csr
```   
to create secret   
```
kubectl create secret tls ${CERT_NAME} --key ${KEY_FILE} --cert ${CERT_FILE}
```

Create Dir 
```
mkdir CA-cert
cd CA-cert/
```
##  Generate key for your CA
```
openssl genrsa -des3 -out CA-key.pem 2048
```
## Generate CA certificate. ( pls take note of passphrase )
```
openssl req -new -key CA-key.pem -x509 -days 1000 -out CA-cert.pem
```
## Generate the csr key pair. ( Pls mention domain or ip in common name section )
```
openssl req -new -newkey rsa:2048 -nodes -keyout your_domain.key -out your_domain.csr
```

## get the csr signed by your generate CA in step 2
```
openssl x509 -req -days 365 -in your_domain.csr  -CA CA-cert.pem -CAkey CA-key.pem -CAcreateserial -out server-cer.pem
```

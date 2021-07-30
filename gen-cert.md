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
# Wants this more simplified? Then use bellow shell script.

```
mkdir tls
```
now create a file with any name and use bellow content in file as script.
```bash
#!/bin/sh

certdir="tls"
host="web1.mevijay.com"

# setup a CA key
if [ ! -f "$certdir/ca-key.pem" ]; then
  openssl genrsa -out "${certdir}/ca-key.pem" 4096
fi

# setup a CA cert
openssl req -new -x509 -days 365 \
  -subj "/CN=Local CA" \
  -key "${certdir}/ca-key.pem" \
  -sha256 -out "${certdir}/ca.pem"

# setup a host key
if [ ! -f "${certdir}/key.pem" ]; then
  openssl genrsa -out "${certdir}/${host}.key" 2048
fi

# create a signing request
extfile="${certdir}/extfile"
openssl req -subj "/CN=${host}" -new -key "${certdir}/${host}.key" \
   -out "${certdir}/${host}.csr"
echo "subjectAltName = IP:192.168.1.10,DNS:${host}" >> ${extfile}

# create the host cert
openssl x509 -req -days 365 \
   -in "${certdir}/${host}.csr" -extfile "${certdir}/extfile" \
   -CA "${certdir}/ca.pem" -CAkey "${certdir}/ca-key.pem" -CAcreateserial \
   -out "${certdir}/${host}.pem"

# cleanup
if [ -f "${certdir}/${host}.csr" ]; then
        rm -f -- "${certdir}/${host}.csr"
fi
if [ -f "${extfile}" ]; then
        rm -f -- "${extfile}"
fi
```

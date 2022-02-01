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
## To generate the SAN CSR.
To generate the SAN csr we need to create a request file and then to mention alternate domain names there and get it signed. bellow is template.

### **Template req.conf** file -
```
[req]
distinguished_name = req_distinguished_name
req_extensions = v3_req
prompt = no
[req_distinguished_name]
C = %country%
ST = %state%
L = %city%
O = %company name%
OU = %department%
CN = example.com
[v3_req]
keyUsage = keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names
[alt_names]
DNS.1 = www.example.com
DNS.2 = example.com
DNS.3 = www.example1.com
DNS.4 = example1.com
```

### Generate CSR
```
openssl req -new -out company_san.csr -newkey rsa:2048 -nodes -sha256 -keyout company_san.key.temp -config req.conf
```
Run the following command to verify the Certificate Signing Request:
 ```
openssl req -text -noout -verify -in company_san.csr
```
Run the following command to move the Key file into the correct format for use on NetScaler:
 ```
openssl rsa -in company_san.key.temp -out company_san.key
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

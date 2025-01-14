# SSL

TODO: not ported yet

<!-- INDEX_START -->

- [SSLLabs](#ssllabs)
- [Convert Certs and Private Key to PEM format](#convert-certs-and-private-key-to-pem-format)
- [Find the Right Intermediate Chain Certificate](#find-the-right-intermediate-chain-certificate)
  - [Inspect Cert Issuer](#inspect-cert-issuer)
  - [Inspect Chain Certificate](#inspect-chain-certificate)
  - [Confirm the Chain of Trust](#confirm-the-chain-of-trust)
  - [Inspect the Chain Certificate Issuer](#inspect-the-chain-certificate-issuer)
  - [Inspect the Root CA Certificate Subject](#inspect-the-root-ca-certificate-subject)
- [Combine Certificates into Complete Chain of Trust](#combine-certificates-into-complete-chain-of-trust)
- [Verify the Chain](#verify-the-chain)
- [Check SSL Certificate and Private Key formats](#check-ssl-certificate-and-private-key-formats)
  - [Check the Certificate Format](#check-the-certificate-format)
  - [Check the Private Key Format](#check-the-private-key-format)
  - [Check the Chain Certificate Format](#check-the-chain-certificate-format)

<!-- INDEX_END -->

## SSLLabs

Detailed report on your website's SSL certificate:

<https://www.ssllabs.com/ssltest/>

## Convert Certs and Private Key to PEM format

Using OpenSSL...

Convert the public cert:

```shell
openssl x509 -in "$name.crt" -out "$name.pem" -outform PEM
```

Convert the private key:

```shell
openssl rsa -in "$name-private.key" -out "$name-privatekey.pem" -outform PEM
```

For any intermediate chain certs:

```shell
openssl x509 -in chain.crt -out chain.pem -outform PEM
```

## Find the Right Intermediate Chain Certificate

### Inspect Cert Issuer

```shell
openssl x509 -in "$name-cert.pem" -noout -issuer
```

Output:

```text
issuer= /C=US/O=DigiCert Inc/CN=DigiCert Global G2 TLS RSA SHA256 2020 CA1
```

### Inspect Chain Certificate

```shell
openssl x509 -in "$chain.pem" -noout -subject
```

eg.

```shell
openssl x509 -in "DigiCert Global G2 TLS RSA SHA256 2020 CA1.pem" -noout -subject
```

Output:

```text
subject= /C=US/O=DigiCert Inc/CN=DigiCert Global G2 TLS RSA SHA256 2020 CA1
```

```shell
openssl x509 -in "DigiCert Global Root G2.pem" -noout -subject
```

Output:

```shell
subject= /C=US/O=DigiCert Inc/OU=www.digicert.com/CN=DigiCert Global Root G2
```

The right chain certificate is the one that matches the output from your domain cert, in this case:

```text
DigiCert Global G2 TLS RSA SHA256 2020 CA1.pem
```

If the issuer and subject are the same for a chain certificate, it is the root certificate

This makes sense when you look at the file naming as the other certificate is the Root CA certificate,
not an intermediate chain certificate.

### Confirm the Chain of Trust

Since each chain certificate may lead to a different root certificate, you can confirm the complete chain of trust.

### Inspect the Chain Certificate Issuer

```shell
openssl x509 -in "DigiCert Global G2 TLS RSA SHA256 2020 CA1.pem" -noout -issuer -subject
```

### Inspect the Root CA Certificate Subject

```shell
openssl x509 -in "DigiCert Global Root G2.pem" -noout -issuer -subject
```

If the chain cert issuer matches the root CA cert subject, then the chain of trust is complete.

## Combine Certificates into Complete Chain of Trust

Add the intermediate chain certificate for maximum client compatibility (had issues with this in public Ad Tech due
to some clients not being able to resolve the intermediate chain certificate themselves).

```shell
cat "$name-cert.pem" "DigiCert Global G2 TLS RSA SHA256 2020 CA1.pem" > fullchain.pem
```

Or including the root certificate -
you'd think it'd not be needed as most browsers should already have the root CA cert in their list of trusted certs
but see the next section [verify the chain](#verify-the-chain)...

```shell
cat "$name-cert.pem" "DigiCert Global G2 TLS RSA SHA256 2020 CA1.pem" "DigiCert Global Root G2.pem" > fullchain-with-root.pem
```

## Verify the Chain

```shell
openssl verify -CAfile fullchain.pem $name-cert.pem
```

Output:

```text
$name-cert.pem: C = US, O = DigiCert Inc, CN = DigiCert Global G2 TLS RSA SHA256 2020 CA1
error 2 at 1 depth lookup:unable to get issuer certificate
```

```shell
openssl verify -CAfile fullchain-with-root.pem $name-cert.pem
```

Output:

```text
$name-cert.pem: OK
```

## Check SSL Certificate and Private Key formats

### Check the Certificate Format

```shell
openssl x509 -in "$name-cert.pem" -text -noout
```

### Check the Private Key Format

```shell
openssl rsa -in "$name-privatekey.pem" -check
RSA key ok
writing RSA key
-----BEGIN RSA PRIVATE KEY-----
...
```

### Check the Chain Certificate Format

```shell
openssl x509 -in "$chain.pem" -text -noout
```

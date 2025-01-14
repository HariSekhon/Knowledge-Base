# SSL

TODO: not ported yet

<!-- INDEX_START -->

- [SSLLabs](#ssllabs)
- [Convert Certs and Private Key to PEM format](#convert-certs-and-private-key-to-pem-format)
- [Find the Right Intermediate Chain Certificate](#find-the-right-intermediate-chain-certificate)
  - [Inspect Cert Issuer](#inspect-cert-issuer)
  - [Inspect Chain Certificate](#inspect-chain-certificate)

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

This makes sense when you look at the file naming as the other certificate is the Root CA certificate,
not an intermediate chain certificate.

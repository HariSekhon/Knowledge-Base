# SSL

TODO: not ported yet

<!-- INDEX_START -->

- [SSLLabs](#ssllabs)
- [Convert Certs and Private Key to PEM format](#convert-certs-and-private-key-to-pem-format)

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

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
- [Check Base64 Encoding](#check-base64-encoding)
  - [Check the Certificate Encoding](#check-the-certificate-encoding)
  - [Check the Private Key Encoding](#check-the-private-key-encoding)
  - [Check the Chain Certificate Encoding](#check-the-chain-certificate-encoding)
- [Correct Base64 Padding](#correct-base64-padding)
- [JKS - Java Key Store](#jks---java-key-store)
  - [Inspect Java Key Store](#inspect-java-key-store)
  - [Convert JKS to PKCS12](#convert-jks-to-pkcs12)
- [Troubleshooting](#troubleshooting)
  - [Error outputting keys and certificates](#error-outputting-keys-and-certificates)

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
openssl verify -CAfile fullchain.pem "$name-cert.pem"
```

Output:

```text
$name-cert.pem: C = US, O = DigiCert Inc, CN = DigiCert Global G2 TLS RSA SHA256 2020 CA1
error 2 at 1 depth lookup:unable to get issuer certificate
```

```shell
openssl verify -CAfile fullchain-with-root.pem "$name-cert.pem"
```

Output:

```text
$name-cert.pem: OK
```

## Check Base64 Encoding

### Check the Certificate Encoding

```shell
openssl x509 -in "$name-cert.pem" -text -noout
```

Output:

```text
Certificate:
  ...
```

### Check the Private Key Encoding

```shell
openssl rsa -in "$name-privatekey.pem" -check
```

Output:

```text
RSA key ok
writing RSA key
-----BEGIN RSA PRIVATE KEY-----
...
```

### Check the Chain Certificate Encoding

```shell
openssl x509 -in "$chain.pem" -text -noout
```

Output:

```text
Certificate:
  ...
```

## Correct Base64 Padding

If you're getting errors like this:

```text
Invalid base64: "-----BEGIN PRIVATE KEY-----
```

Re-pad the files:

```shell
grep -v -- "-----" "$name-cert.pem" | base64 --decode | base64 > "$name-cert-fixed.pem"
```

```shell
grep -v -- "-----" "$name-privatekey.pem" | base64 --decode | base64 > "$name-privatekey-fixed.pem"
```

```shell
grep -v -- "-----" "$chain.pem" | base64 --decode | base64 > "$chain-fixed.pem"
```

## JKS - Java Key Store

### Inspect Java Key Store

List keystore entries:

```shell
keytool -list -keystore "$JKS_NAME".jks -storepass "$JKS_PASSWORD"
```

List keystore entries with detailed info:

```shell
keytool -list -v -keystore "$JKS_NAME".jks -storepass "$JKS_PASSWORD"
```

List a specific alias:

```shell
keytool -list -v -keystore "$JKS_NAME".jks -alias "$JKS_KEY_ALIAS" -storepass "$JKS_PASSWORD"
```

Check the certificate chain in RFC (PEM) format:

```shell
keytool -list -rfc -keystore "$JKS_NAME".jks -storepass "$JKS_PASSWORD"
```

Export the cert:

```shell
keytool -export -alias "$JKS_KEY_ALIAS" -keystore "$JKS_NAME".jks -storepass "$JKS_PASSWORD" -file "$JKS_NAME"_cert.cer
```

View the extracted certificate:

```shell
openssl x509 -in "$JKS_NAME"_cert.cer -text -noout
```

### Convert JKS to PKCS12

```shell
keytool -importkeystore -srckeystore "$JKS_NAME".jks -destkeystore "$JKS_NAME".p12 -deststoretype PKCS12 -srcstorrcalias "$JKS_KEY_ALIAS" -srckeypass "$JKS_KEY_PASSWORD"
```

Different store and key passwords are not supported for p12 stores
so `-destkeypass` is not needed and would be ignored with this warning:

```text
Warning:  Different store and key passwords not supported for PKCS12 KeyStores. Ignoring user-specified -destkeypass value.
```

Inspect the p12:

```shell
openssl pkcs12 -info -in "$JKS_NAME".p12 -passin env:JKS_PASSWORD -passout env:JKS_PASSWORD
```

## Troubleshooting

### Error outputting keys and certificates

```text
Error outputting keys and certificates
C01EECDE01000000:error:0308010C:digital envelope routines:inner_evp_generic_fetch:unsupported:crypto/evp/evp_fetch.c:355:Global default library context, Algorithm (RC2-40-CBC : 0), Properties ()
```

Add this switch to support legacy algorithms:

```text
-legacy
```

eg.

```shell
openssl pkcs12 -in "$file.p12" -info -noout -password pass:"$CERTIFICATE_PASSWORD" -legacy
```

```text
MAC: sha1, Iteration 1
MAC length: 20, salt length: 8
PKCS7 Encrypted data: pbeWithSHA1And40BitRC2-CBC, Iteration 2048
Certificate bag
PKCS7 Data
Shrouded Keybag: pbeWithSHA1And3-KeyTripleDES-CBC, Iteration 2048
```

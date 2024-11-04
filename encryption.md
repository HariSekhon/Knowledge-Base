# Encryption

The process of changing a file or data stream to be unreadable by someone with the passphrase or key.

## SSL

See [SSL](ssl.md) doc.

## File Encryption

For maximum strength,
encrypt individual files using one tool and then place the encrypted files into VeraCrypt encrypted mounted volume.

### GnuPG

<https://gnupg.org/>

GNU Privacy Guard is the open source implementation of the OpenPGP standard.

Supports both asymmetric (public-private) and symmetric encryption.

Compatible across platforms, and highly customizable.

Install on Mac:

```shell
brew install gnupg
```

`-c` is short for `--symmetric` encryption, defaults to AES-128, and curses prompts for a password:

```shell
gpg -c "$file"
```

You will want to increase this to the current max AED-256 and stop it caching the passphrase locally:

```shell
gpg -c --cipher-algo AES256 --no-symkey-cache "$file"
```

Creates `$file.gpg` encrypted file (can change this using `--output filename.gpg`.

Decrypt (the `-d` / `--decrypt` is implicit):

```shell
gpg "$file.gpg"
```

### VeraCrypt

<https://veracrypt.fr/en/Home.html>

Fork of TrueCrypt.

Supports strong encryption algorithms (e.g., AES, Serpent), including hidden volumes, which allow plausible deniability.

Install on Mac:

```shell
brew install veracrypt
```

Create a 100 MB volume with a cascade of three encryption algorithms for strongest layered security:

```shell
veracrypt --create /path/to/volume --encryption AES-Twofish-Serpent --hash sha-512 --size 100M --password 'your_password' --volume-type normal
```

Then put files inside it.

### OpenSSL

Encrypt:

```shell
openssl enc -aes-256-cbc -pbkdf2 -salt -in "$file" -out "$file.enc"
```

Decrypt:

```shell
openssl enc -d -aes-256-cbc -pbkdf2 -salt -in "$file.enc" -out "$file"
```

### Age - Actually Good Encryption

Install on Mac:

```shell
brew install age
```

Encrypt original_file into encrypted_file.age using a passphrase with high-strength elliptic curve encryption (X25519):

```shell
age -p -o "$file.age" "$file"
```

Decrypt:

```shell
age -d -o "$file" "$file.age"
```

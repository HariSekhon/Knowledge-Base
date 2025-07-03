# Veracrypt

<https://veracrypt.io>

Based on TrueCrypt, encrypt volumes or create encrypted file volumes. Also supports hidden volumes.

Alternatively, on macOS, you can also create basic encrypted file volumes using the native mac tools
as concisely documented on the [Mac](mac.md#create-an-encrypted-file-volume) page.

## Install

<https://veracrypt.io/en/Downloads.html>

For Apple Silicon, it's recommended to install the Fuse-T version.

On macOS, this downloads the installer:

```shell
package="veracrypt-fuse-t"
```

```shell
brew install "$package"
```

Then find the downloaded package installer:

```shell
pkg="$(brew ls --verbose "$package" | grep '\.pkg$' | tee /dev/stderr)"
```
It'll print the package path, eg:

```shell
/opt/homebrew/Caskroom/veracrypt-fuse-t/1.26.24/VeraCrypt_Installer.pkg
```

Run the GUI installer package:

```shell
open "$pkg"
```

Follow the GUI prompts to complete installation.

Note: re-running the installer will not detect that it's already installed and appears to just overwrite the installation.

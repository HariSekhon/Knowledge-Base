# Veracrypt

<https://veracrypt.io>

Based on TrueCrypt, supports hidden volumes.

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

Then run the GUI installer:

```shell
pkg="$(brew ls --verbose "$package" | grep '\.pkg$' | tee /dev/stderr)"

open "$pkg"
```

Follow the GUI prompts to complete installation.

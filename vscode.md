# VS Code

Visual Studio Code is a popular free IDE from Microsoft.

<!-- INDEX_START -->

- [Download](#download)
- [VS Code CLI](#vs-code-cli)
- [Extensions](#extensions)
  - [Install Extensions](#install-extensions)

<!-- INDEX_END -->

## Download

<https://code.visualstudio.com/docs/>

## VS Code CLI

Ensure the `code` CLI binary is in your `$PATH` by adding this directory to the `$PATH`:

```none
/Applications/Visual Studio Code.app/Contents/Resources/app/bin
```

## Extensions

<https://marketplace.visualstudio.com/vscode>

- [Bash IDE](https://marketplace.visualstudio.com/items?itemName=mads-hartmann.bash-ide-vscode)
- [Markdown All in One](https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one)

### Install Extensions

```shell
code --install-extension <extension_id>
```

```shell
for x in \
    mads-hartmann.bash-ide-vscode \
    yzhang.markdown-all-in-one \
    ; do
    code --install-extension "$x"
done
```

```none
Installing extensions...
Installing extension 'mads-hartmann.bash-ide-vscode'...
Extension 'mads-hartmann.bash-ide-vscode' v1.42.0 was successfully installed.
Installing extensions...
Installing extension 'yzhang.markdown-all-in-one'...
Extension 'yzhang.markdown-all-in-one' v3.6.2 was successfully installed.
```

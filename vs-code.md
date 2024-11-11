# VS Code

Visual Studio Code is a popular free IDE from Microsoft.

<!-- INDEX_START -->

- [Download](#download)
- [Run](#run)
- [VS Code CLI](#vs-code-cli)
- [Extensions](#extensions)
  - [Install Extensions](#install-extensions)

<!-- INDEX_END -->

## Download

<https://code.visualstudio.com/docs/>

## Run

From the `Applications` icon or on the command line:

```shell
open -a "Visual Studio Code"
```

## VS Code CLI

Ensure the `code` CLI binary is in your `$PATH` by adding this directory to the `$PATH`:

```text
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

Define the list of extensions you want to install:

```shell
EXTENSIONS="
dbaeumer.vscode-eslint
golang.go
mads-hartmann.bash-ide-vscode
msazurermtools.azurerm-vscode-tools
ms-azure-devops.azure-pipelines
ms-azuretools.vscode-azurecontainerapps
ms-azuretools.vscode-azureresourcegroups
ms-azuretools.vscode-azurestaticwebapps
ms-azuretools.vscode-azurestorage
ms-azuretools.vscode-azureterraform
ms-azuretools.vscode-azurevirtualmachines
ms-azuretools.vscode-cosmosdb
ms-kubernetes-tools.vscode-aks-tools
ms-kubernetes-tools.vscode-kubernetes-tools
ms-ossdata.vscode-postgresql
ms-python.autopep8
ms-python.debugpy
ms-python.black-formatter
ms-python.flake8
ms-python.python
ms-python.pylint
ms-python.vscode-pylance
ms-mssql.mssql
ms-toolsai.vscode-ai
ms-vscode.azurecli
ms-vscode.azure-repos
ms-vscode.cmake-tools
ms-vscode.makefile-tools
ms-vscode.vscode-node-azure-pack
ms-vscode.vscode-typescript-next
terrastruct.d2
vsciot-vscode.azure-iot-toolkit
vscjava.vscode-maven
vscjava.vscode-gradle
yzhang.markdown-all-in-one
"
#ms-vscode.powershell
```

Iterate `code --install-extension` over them:

```shell
for extension in $EXTENSIONS; do
    code --install-extension "$extension"
done
```

output:

```text
Installing extensions...
Installing extension 'mads-hartmann.bash-ide-vscode'...
Extension 'mads-hartmann.bash-ide-vscode' v1.42.0 was successfully installed.
Installing extensions...
Installing extension 'yzhang.markdown-all-in-one'...
Extension 'yzhang.markdown-all-in-one' v3.6.2 was successfully installed.
```

```shell
code --list-extensions
```

```shell
code --uninstall-extension <extension-id>
```

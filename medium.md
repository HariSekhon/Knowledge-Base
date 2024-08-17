# Medium

Medium is a popular blogging platform.

This is widely used by tech authors.

Here is mine:

https://medium.com/@harisekhon

<!-- INDEX_START -->
<!-- INDEX_END -->

## Keyboard Shortcuts

| Action            | Mac                     | Windows                    |
|-------------------|-------------------------|----------------------------|
| Shortcuts help    | `⌘ + ?`                 | `Ctrl + ?`                 |
| Bold              | `⌘ + B`                 | `Ctrl + B`                 |
| Italic            | `⌘ + I`                 | `Ctrl + I`                 |
| Link              | `⌘ + K`                 | `Ctrl + K`                 |
| Header            | `⌘ + Opt + 1`           | `Ctrl + Alt + 1`           |
| Subheader         | `⌘ + Opt + 2`           | `Ctrl + Alt + 2`           |
| Separator         | `⌘ + Enter`             | `Ctrl + Enter`             |
| Inline code       | ``` ` ```               | ``` ` ```                  |
| Code block        | `⌘ + Opt + 6` / ` ``` ` | `Ctrl + Alt + 6` / ` ``` ` |
| Bullet-point list | `* + Space`             | `* + Space`                |
| Numbered list     | `1. + Space`            | `1. + Space`               |
| Quote             | `⌘ + Opt + 5`           | `Ctrl + Alt + 5`           |
| Featured Image    | `Shift + F`             | `Shift + F`                |
| Focal point       | `Opt + Right-click`     | `Alt + Right-click`        |
| Mention a user    | `@username` / `@name`   | `@username` / `@name`      |

## Convert WebP Images to PNG format

Medium doesn't accept modern `webp` format images.

You must convert them to `jpg` or `png` format.

On Mac, install the `dwebp` [homebrew](brew.md) package:

```shell
brew install webp
```

Convert the image:

```shell
dwebp "$name.webp" -o "$name.png"
```

or shorter and safer using function in [DevOps-Bash-tools](devops-bash-tools.md) repo:

```shell
webp_to_png "$name.webp"
```

This function adds safety to not overwrite the destination file if it already exists because `dwebp` will blindly
overwrite the `-o outfile`.

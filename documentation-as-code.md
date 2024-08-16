# Documentation-as-Code

- [Markdown, GitHub, `README.md`](#markdown-github-readmemd)
  - [GitHub Markdown Documentation](#github-markdown-documentation)
- [MKDocs](#mkdocs)
- [Markdown Best Practices](#markdown-best-practices)
  - [URL Handling](#url-handling)
  - [Code Blocks vs Inline Code](#code-blocks-vs-inline-code)
  - [Syntax Highlighting](#syntax-highlighting)
  - [IntelliJ Code Block Execution](#intellij-code-block-execution)
- [Badges & Icons](#badges--icons)
  - [Badges](#badges)
  - [Icons](#icons)
- [Link Team Support Numbers to WhatsApp Desktop](#link-team-support-numbers-to-whatsapp-desktop)

## Markdown, GitHub, `README.md`

Document right in your Git repo by creating a `README.md` and have your Git repo hosting platform render it as your
repo's home page - put links in it to your other markdown `*.md` doc files in your repo.

### GitHub Markdown Documentation

[GitHub Markdown Syntax Documentation](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax)

## MKDocs

[MKDocs](mkdocs.md) converts standard markdown files into a website.

## Markdown Best Practices

### URL Handling

It's important not to put a bare URL because they won't by hyperlinked in some systems like [MKDocs](mkdocs.md).

Use a text hyperlink:

```markdown
[Some Text](https://my.domain.com/path)
```

or if you want to show the URL wrap it in `<` and `>` to ensure it maintains compatibility to become a hyperlink:

```markdown
<https://my.domain.com/path>
```

### Code Blocks vs Inline Code

Use triple backticks on separate lines to create code blocks and put a language attribute immediately after the opening
backticks:

```shell
some_command -with -args 1
```

This is much more readable than an inline code of `some_command -with args 1` and then carry on with your day.

Code blocks get a Copy to Clipboard link making your life easier.

Inline code should only be for short references to command names or an arg eg.
use the `git` command or specify `--force-with-lease` option in git if you really insist on doing rebases and force
pushes.

(See also: [The Evils of Git Rebasing](https://medium.com/@harisekhon/the-evils-of-git-rebasing-beec34a607c7))

### Syntax Highlighting

Put a language name immediately after the first triple backticks then you get syntax highlighting eg.

````markdown
```groovy
````

Compare the readability of this:

```
if (isCommandAvailable('gcloud')) {
    echo 'Using GCloud SDK to configure Docker'
    // configures docker config with a token
    sh "gcloud auth configure-docker '$GAR_REGISTRY'"
}
```

with this having syntax highlighting:

```groovy
if (isCommandAvailable('gcloud')) {
    echo 'Using GCloud SDK to configure Docker'
    // configures docker config with a token
    sh "gcloud auth configure-docker '$GAR_REGISTRY'"
}
```

(example from [HariSekhon/Jenkins](https://github.com/HariSekhon/Jenkins) repo)

### IntelliJ Code Block Execution

If you run [IntelliJ](intellij.md) there is also a green triangle arrow next to `shell` blocks to execute them with
only one click, code notebook style.

````
```shell
echo "execute this command"
```
````

```shell
echo execute this command
```

## Badges & Icons

### Badges

Use [Shields.io](https://shields.io) to create many different types of badges.

### Icons

Use [Simple Icons](https://simpleicons.org) for a great selection of icons.

These can be used with the `logo=` parameter in [Shields.io](https://shields.io) above.

However, for icons that are not available on the Simple Icons site, or those that
[got removed](https://github.com/simple-icons/simple-icons/issues/11372)
you can use the `shields_embed_logo.sh` script from the [DevOps-Bash-tools](devops-bash-tools.md) repo:

Download the icon:

```shell
wget -nc https://raw.githubusercontent.com/simple-icons/simple-icons/e8de041b64586c0c532f9ea5508fd8e29d850937/icons/linkedin.svg
```

```shell
shields_embed_logo.sh linkedin.svg
```

or directly from a URL containing the icon:

```shell
shields_embed_logo.sh https://raw.githubusercontent.com/simple-icons/simple-icons/e8de041b64586c0c532f9ea5508fd8e29d850937/icons/linkedin.svg
```

Either will result in an output like this:

```none
logo=data:image/svg%2bxml;base64,PHN2ZyByb2xlPSJpbWciIHZpZXdCb3g9IjAgMCAyNCAyNCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48dGl0bGU+TGlua2VkSW48L3RpdGxlPjxwYXRoIGQ9Ik0yMC40NDcgMjAuNDUyaC0zLjU1NHYtNS41NjljMC0xLjMyOC0uMDI3LTMuMDM3LTEuODUyLTMuMDM3LTEuODUzIDAtMi4xMzYgMS40NDUtMi4xMzYgMi45Mzl2NS42NjdIOS4zNTFWOWgzLjQxNHYxLjU2MWguMDQ2Yy40NzctLjkgMS42MzctMS44NSAzLjM3LTEuODUgMy42MDEgMCA0LjI2NyAyLjM3IDQuMjY3IDUuNDU1djYuMjg2ek01LjMzNyA3LjQzM2MtMS4xNDQgMC0yLjA2My0uOTI2LTIuMDYzLTIuMDY1IDAtMS4xMzguOTItMi4wNjMgMi4wNjMtMi4wNjMgMS4xNCAwIDIuMDY0LjkyNSAyLjA2NCAyLjA2MyAwIDEuMTM5LS45MjUgMi4wNjUtMi4wNjQgMi4wNjV6bTEuNzgyIDEzLjAxOUgzLjU1NVY5aDMuNTY0djExLjQ1MnpNMjIuMjI1IDBIMS43NzFDLjc5MiAwIDAgLjc3NCAwIDEuNzI5djIwLjU0MkMwIDIzLjIyNy43OTIgMjQgMS43NzEgMjRoMjAuNDUxQzIzLjIgMjQgMjQgMjMuMjI3IDI0IDIyLjI3MVYxLjcyOUMyNCAuNzc0IDIzLjIgMCAyMi4yMjIgMGguMDAzeiIvPjwvc3ZnPgo=
```

Paste that generated parameter to the end of the shields.io URL, prefix with a `?` if the first parameter or a `&`
if appended to existing parameters:

```markdown
[![My LinkedIn](https://img.shields.io/badge/LinkedIn%20Profile-HariSekhon-blue?logo=data:image/svg%2bxml;base64,PHN2ZyByb2xlPSJpbWciIHZpZXdCb3g9IjAgMCAyNCAyNCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48dGl0bGU+TGlua2VkSW48L3RpdGxlPjxwYXRoIGQ9Ik0yMC40NDcgMjAuNDUyaC0zLjU1NHYtNS41NjljMC0xLjMyOC0uMDI3LTMuMDM3LTEuODUyLTMuMDM3LTEuODUzIDAtMi4xMzYgMS40NDUtMi4xMzYgMi45Mzl2NS42NjdIOS4zNTFWOWgzLjQxNHYxLjU2MWguMDQ2Yy40NzctLjkgMS42MzctMS44NSAzLjM3LTEuODUgMy42MDEgMCA0LjI2NyAyLjM3IDQuMjY3IDUuNDU1djYuMjg2ek01LjMzNyA3LjQzM2MtMS4xNDQgMC0yLjA2My0uOTI2LTIuMDYzLTIuMDY1IDAtMS4xMzguOTItMi4wNjMgMi4wNjMtMi4wNjMgMS4xNCAwIDIuMDY0LjkyNSAyLjA2NCAyLjA2MyAwIDEuMTM5LS45MjUgMi4wNjUtMi4wNjQgMi4wNjV6bTEuNzgyIDEzLjAxOUgzLjU1NVY5aDMuNTY0djExLjQ1MnpNMjIuMjI1IDBIMS43NzFDLjc5MiAwIDAgLjc3NCAwIDEuNzI5djIwLjU0MkMwIDIzLjIyNy43OTIgMjQgMS43NzEgMjRoMjAuNDUxQzIzLjIgMjQgMjQgMjMuMjI3IDI0IDIyLjI3MVYxLjcyOUMyNCAuNzc0IDIzLjIgMCAyMi4yMjIgMGguMDAzeiIvPjwvc3ZnPgo=)](https://www.linkedin.com/in/HariSekhon/)
```

Result:

[![My LinkedIn](https://img.shields.io/badge/LinkedIn%20Profile-HariSekhon-blue?logo=data:image/svg%2bxml;base64,PHN2ZyByb2xlPSJpbWciIHZpZXdCb3g9IjAgMCAyNCAyNCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48dGl0bGU+TGlua2VkSW48L3RpdGxlPjxwYXRoIGQ9Ik0yMC40NDcgMjAuNDUyaC0zLjU1NHYtNS41NjljMC0xLjMyOC0uMDI3LTMuMDM3LTEuODUyLTMuMDM3LTEuODUzIDAtMi4xMzYgMS40NDUtMi4xMzYgMi45Mzl2NS42NjdIOS4zNTFWOWgzLjQxNHYxLjU2MWguMDQ2Yy40NzctLjkgMS42MzctMS44NSAzLjM3LTEuODUgMy42MDEgMCA0LjI2NyAyLjM3IDQuMjY3IDUuNDU1djYuMjg2ek01LjMzNyA3LjQzM2MtMS4xNDQgMC0yLjA2My0uOTI2LTIuMDYzLTIuMDY1IDAtMS4xMzguOTItMi4wNjMgMi4wNjMtMi4wNjMgMS4xNCAwIDIuMDY0LjkyNSAyLjA2NCAyLjA2MyAwIDEuMTM5LS45MjUgMi4wNjUtMi4wNjQgMi4wNjV6bTEuNzgyIDEzLjAxOUgzLjU1NVY5aDMuNTY0djExLjQ1MnpNMjIuMjI1IDBIMS43NzFDLjc5MiAwIDAgLjc3NCAwIDEuNzI5djIwLjU0MkMwIDIzLjIyNy43OTIgMjQgMS43NzEgMjRoMjAuNDUxQzIzLjIgMjQgMjQgMjMuMjI3IDI0IDIyLjI3MVYxLjcyOUMyNCAuNzc0IDIzLjIgMCAyMi4yMjIgMGguMDAzeiIvPjwvc3ZnPgo=&logoColor=white)](https://www.linkedin.com/in/HariSekhon/)

## Link Team Support Numbers to WhatsApp Desktop

Support mobile phone numbers should be created as WhatsApp links to allow one-click opening of chats in
[WhatsApp Desktop](https://www.whatsapp.com/download)
for convenience:

```markdown
[+44 0776 999 1234](https://wa.me/447769991234)
```

This is not my real number. Recruiters please do not call it.

Also, if you have my real number, please do not call it.
Always [LinkedIn](https://www.linkedin.com/in/HariSekhon) message me instead and read my profile's summary
bullet point criteria - it'll give you nearly everything you need to know about my availability and preferences.

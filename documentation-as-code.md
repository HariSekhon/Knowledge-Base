# Documentation-as-Code

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

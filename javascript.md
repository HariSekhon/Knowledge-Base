# JavaScript

It's nothing to do with Java.

<!-- INDEX_START -->

- [NodeJS](#nodejs)
  - [NPM](#npm)
  - [NVM - Node Version Manager](#nvm---node-version-manager)
  - [REPL](#repl)
- [TypeScript](#typescript)
  - [Install TypeScript](#install-typescript)
  - [Convert TypeScript to JavaScript](#convert-typescript-to-javascript)
  - [TypeScript Config](#typescript-config)
  - [TypeScript REPL](#typescript-repl)
    - [tsx](#tsx)
    - [ts-node](#ts-node)
- [Libraries](#libraries)
- [Repos](#repos)
- [Memes](#memes)
  - [JavaScript - The Good Parts](#javascript---the-good-parts)
  - [JavaScript TypeScript Friends](#javascript-typescript-friends)
  - [Men Who Take Risks](#men-who-take-risks)
  - [Imported Package Tariffs](#imported-package-tariffs)
  - [Why Are You Crying Son](#why-are-you-crying-son)

<!-- INDEX_END -->

## NodeJS

NodeJS or Node.js is a server-side JavaScript engine built on Google Chrome's V8 JavaScript engine
that can be used for both frontend and backend development.

Uses a non-blocking, event-driven architecture, making it ideal for building scalable and high-performance applications
that handle a large number of simultaneous connections.

NodeJS operates on a single-threaded event loop model, but it uses non-blocking asynchronous I/O operations to handle concurrency efficiently

Like [Python](python.md), NodeJS has a vast ecosystem of libraries, which you can search at
[npmjs.com](https://www.npmjs.com/).

NodeJS is used for everything from web development, to APIs and microservices, to CLI tools
(although there are better languages for CLI like [Golang](go.md), [Python](python.md), [Perl](perl.md) and [Bash](bash.md)).

### NPM

NodeJS Package Manager.

Install it using your system package manager and then use it to install your NodeJS libraries.

```shell
brew install npm
```

On any Mac or Linux, from [DevOps-Bash-tools](devops-bash-tools.md):

```shell
install_packages.sh npm
```

NPM install package:

```shell
npm install "$package"
```

**Remember to commit the resulting `package.json` and `package-lock.json` files to [Git](git.md).**

Both files as in [JSON](json.md) format.

- `package.json` - lists packages you've installed directly
- `package-lock.json` - lists the exact versions of all package dependencies so you can reproduce without annoying
  library version change related issues

Install all packages of the exact versions from ``packages-lock.json`:

```shell
npm install
```

### NVM - Node Version Manager

[:octocat: nvm-sh/nvm](https://github.com/nvm-sh/nvm)

```shell
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash
```

Clones to `~/.nvm`.

Reload shell to pick up the addition to `.bashrc`.

Show current node version:

```shell
nvm ls
```

```text
->       system
iojs -> N/A (default)
node -> stable (-> N/A) (default)
unstable -> N/A (default)
```

List available versions:

```shell
nvm ls-remote
```

Install latest version of NodeJS:

```shell
nvm install node
```

Install specific version:

```shell
nvm install v23.11.0
```

```shell
nvm use node
```

```shell
node --version
```

```text
v23.11.0
```

```shell
nvm ls
```

```text
->     v23.11.0
         system
default -> node (-> v23.11.0)
iojs -> N/A (default)
unstable -> N/A (default)
node -> stable (-> v23.11.0) (default)
stable -> 23.11 (-> v23.11.0) (default)
...
```

### REPL

To start an interactive Javascript shell, just type:

```shell
node
```

Then behold this horror:

```javascript
> "11" + 1
'111'
> "11" - 1
10
```

![Javascript string add minus](images/javascript_string_add_minus.jpeg)

Which brings us on to... strict variable typing...

## TypeScript

Type safe superset of JavaScript with optional static type checking.

Transpiles (converts) to JavaScript eg. `src/*.ts` => `dist/index.js`.

Not compiles since it doesn't translate to binary or byte code.

Example variable type enforcement, just suffix the `: <type>` to a variable:

```typescript
let name: string = "Hari";

name = 1; // type error
```

### Install TypeScript

```shell
npm install -g typescript
```

### Convert TypeScript to JavaScript

```text
tsc example.ts
```

Generates `example.js`.

Run it:

```shell
node example.js
```

### TypeScript Config

Create a `tsconfig.json` for project settings:

```shell
tsc --init
```

### TypeScript REPL

#### tsx

```shell
npm install -g tsx
```

```shell
tsx
```

```text
Welcome to Node.js v23.7.0.
Type ".help" for more information.
> 1 + 1
2
>
```

#### ts-node

```shell
npm install -g ts-node
```

Start the REPL:

```yaml
ts-node
```

List the packages:

```shell
npm ls -g ts-node typescript
```

```text
/opt/homebrew/lib
└─┬ ts-node@10.9.2
  └── typescript@5.8.3
```

If you get an issue with REPL commands resulting in `...` line continuation instead of returning the result.

```text
ts-node
> 1 + 1
...
... ;
... ;
...
```

Use `tsx` instead.

## Libraries

- [:octocat: cure53/DOMPurify](https://github.com/cure53/DOMPurify) - sanitize HTML to avoid XSS attacks.
  You can see this used in my [TamperMonkey](tampermonkey.md) script
  [jira_description_autofill.js](https://github.com/HariSekhon/TamperMonkey/blob/main/jira_description_autofill.js).
- [:octocat: https://github.com/highlightjs/highlight.js](https://github.com/highlightjs/highlight.js) -
  syntax highlighter
  - <https://highlightjs.org/>
  - online [Demo](https://highlightjs.org/demo)
  - [NPM package - highlight.js](https://www.npmjs.com/package/highlight.js)
  - [ReadTheDocs - HighlightJS](https://highlightjs.readthedocs.io/en/latest/readme.html)

## Repos

[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=HariSekhon&repo=TamperMonkey&theme=ambient_gradient&description_lines_count=3)](https://github.com/HariSekhon/TamperMonkey)

## Memes

### JavaScript - The Good Parts

![JavaScript the Good Parts](images/javascript_the_good_parts.jpg)

### JavaScript TypeScript Friends

![JavaScript TypeScript Friends](images/javascript_typescript_are_you_two_friends.jpg)

### Men Who Take Risks

![Men Who Take Risks](images/men_who_take_risks_javascript_framework_written_by_facebook.jpeg)

### Imported Package Tariffs

![Imported Package Tariffs](images/imported_package_tariffs.jpeg)

### Why Are You Crying Son

![Why Are You Crying Son, You've Been Coding in JavaScript](images/crying_coding_in_javascript.jpeg)

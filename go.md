# Golang

<!-- INDEX_START -->

- [Instantiate New Golang Project](#instantiate-new-golang-project)
  - [Initiate Your Repo Module](#initiate-your-repo-module)
  - [Populate Libraries](#populate-libraries)
- [Go Releaser](#go-releaser)
- [Memes](#memes)
  - [Never Be Good At Programming](#never-be-good-at-programming)

<!-- INDEX_END -->

## Instantiate New Golang Project

### Initiate Your Repo Module

```shell
go mod init "github.com/$owner/$repo"
```

### Populate Libraries

Reads the local `*.go` code files to find out what dependencies the program uses and populates
the `go.mod` and `go.sum` build files.

```shell
 go mod tidy
```

## Go Releaser

[:octocat: goreleaser/goreleaser](https://github.com/goreleaser/goreleaser)

<https://goreleaser.com/>

The entire build & release process is defined in `.goreleaser.yaml` and then the `goreleaser` binary is run.

This simplifies local and [CI/CD](cicd.md) builds.

## Memes

### Never Be Good At Programming

![Never Be Good At Programming](images/never_be_good_at_coding_rust_golang.jpeg)

**Page Not Ported from Private Knowledge Base Yet**

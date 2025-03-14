# Dockerfile

NOT PORTED YET

The build file for a docker image.

<!-- INDEX_START -->

- [Template](#template)
- [HariSekhon/Dockerfiles](#harisekhondockerfiles)
- [Docker Build Best Practices](#docker-build-best-practices)
- [Amazing Cache Busting Trick](#amazing-cache-busting-trick)
- [Python - Create Smaller Docker Images Using the Builder Pattern](#python---create-smaller-docker-images-using-the-builder-pattern)

<!-- INDEX_END -->

## Template

[HariSekhon/Templates - Dockerfile](https://github.com/HariSekhon/Templates/blob/master/Dockerfile)

## HariSekhon/Dockerfiles

Large repo full of Dockerfiles for different open source technologies full of real world tricks like DockerHub auto-hook
scripts to do extra tags, cache busting upon new commits to GitHub repos etc.

:octocat: [HariSekhon/Dockerfiles](https://github.com/HariSekhon/Dockerfiles)

## Docker Build Best Practices

<https://docs.docker.com/build/building/best-practices>

<<https://sysdig.com/learn-cloud-native/dockerfile-best-practices/>>

## Amazing Cache Busting Trick

If you're building from GitHub repos that you want to trigger rebuilds upon any change by busting the Docker build cache
you can put this in your Dockerfile:

```dockerfile
# Cache Bust upon new commits
ADD https://api.github.com/repos/HariSekhon/DevOps-Bash-tools/git/refs/heads/master /.git-hashref
```

I used this in my [HariSekhon/Dockerfiles](https://github.com/HariSekhon/Dockerfiles) repo for several of my major
GitHub repos like [DevOps-Bash-tools](devops-bash-tools.md) and [DevOps-Python-tools](devops-python-tools.md).

## Python - Create Smaller Docker Images Using the Builder Pattern

Use the Python builder pattern to make small Python docker images, see
this [Medium article](https://medium.com/@harisekhon/docker-python-builder-pattern-to-reduce-docker-image-size-e78feee68295).

The code for this is in the Dockerfile template above.

# Make

The classic build system used by C programmers which is now commonly used by unix sysadmins in Git repos because it's such a short command.

It's hard to find a shorter easier build command than running:

```shell
make
```

to run whatever build commands you want.

Even when I use Maven, Gradle, SBT, Pip, Cpanm, Go Build etc... I wrap them in a `Makefile` because it makes the
commands shorter and captures any special command line arguments that you may want to pass to the build systems.

## Best Make Examples

All of my repos use Makefiles to standardize CI/CD across different systems.

[HariSekhon/Templates - Makefile](https://github.com/HariSekhon/Templates/blob/master/Makefile)

[HariSekhon/DevOps-Bash-tools - Makefile](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/Makefile)

[HariSekhon/DevOps-Bash-tools - Makefile.in](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/Makefile.in)

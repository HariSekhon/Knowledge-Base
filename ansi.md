# ANSI Terminal Codes

Useful Terminal Escape sequences that I use in [Bash](bash.md) scripts (can be used in any programming language really):

You might see functions like this in my [DevOps-Bash-tools](devop-bash-tools.md) repo:

```shell
clear_current_line(){
    printf "\r\033[K"
}

clear_previous_line(){
    printf "\033[1A\033[2K\r"
}
```

and think what the hell are those codes.

You're not alone, it looks like magic until you have a cheet sheet for it.

TODO - make a cheet sheet for it below.

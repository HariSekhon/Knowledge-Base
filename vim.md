# ViM Cheat Sheet

```shell
vim testfile.txt
```

Starts in command mode. Below are mostly commands to remember since everything in insert mode is typed out literally.

Commands can often be used together in shorthand combinations or prefixed with a number to repeat the operation
N times or for N lines.

Lowercase vs Capitals often do the opposite action / direction.

You can run the `vimtutor` command on unix or inside `vim` the command `:help tutor` to get an interactive tutorial.

| Keystrokes               | Description                                                                                                                                  |
|--------------------------|----------------------------------------------------------------------------------------------------------------------------------------------|
| `i`                      | Enter insert mode to start typing                                                                                                            |
| `a`                      | Enter insert mode after the current cursor position. Same as right and then `i`                                                              |
| `I`                      | Enter insert mode at beginning of line                                                                                                       |
| `A`                      | Enter insert mode at end of line                                                                                                             |
| `yy`                     | Copy entire line. `5yy` copies the next 5 lines                                                                                              |
| `dd`                     | Delete entire line (also copies it in the buffer like `yy`)                                                                                  |
| `dw`                     | Delete until the next word. `3dw` or `d3w` deletes the next 3 words                                                                          |
| `p`                      | Paste last copied character after cursor, or last copied line underneath current line                                                        |
| `P`                      | Paste last copied line before current line, or last copied character before cursor                                                           |
| `c`                      | Change a character - deletes the character under the cursor and enters insert mode. Equivalent to `x` and then `i`                           |
| `cw`                     | Change word - deletes until the next word and enters insert mode                                                                             |
| `cc`                     | Change line - deletes entire line and enters insert mode to type to replace it                                                               |
| `c$` / `C`               | Change until end of line - deletes to end of line and enters insert mode                                                                     |
| `o`                      | Open a new line in insert mode below the current line                                                                                        |
| `O`                      | Open a new line in insert mode above the current line                                                                                        |
| `Esc`                    | Escape from insert mode back to command mode, or cancel the current combination of keystroke command                                         |
| `x`                      | Delete the character under the cursor                                                                                                        |
| `u`                      | Undo last character change                                                                                                                   |
| `U`                      | Undo all changes to last edited line                                                                                                         |
| Ctrl + `R`               | Redo                                                                                                                                         |
| `:help`  / `:help topic` | Open the help menu                                                                                                                           |
| Ctrl + `]`               | Jumps to the hyperlink (called tag in vim) denoted by `\|:something \|`                                                                      |
| Ctrl + `T`               | Go back from the hyperlink                                                                                                                   |
| `:q`                     | Quit / exit vim                                                                                                                              |
| `:wq` or `ZZ`            | Write & quit                                                                                                                                 |
| `:w!`                    | Force write                                                                                                                                  |
| `:q!`                    | Force Quit, discarding changes                                                                                                               |
| `:wa`                    | Write all open files                                                                                                                         |
| `:wqa`                   | Write all open files and quit                                                                                                                |
| `h` / `j` / `k` / `l`    | move cursor left / up / down / right, respectively. Just use the arrow keys on your keyboard instead, seriously                              |
| `w`                      | Jump forwards one word. Type `4w` to jump forwards 4 words                                                                                   |
| `b`                      | Jump backwards one word                                                                                                                      |
| `^` / `0`                | Jump to the start of the line. Remember `^` mean start of line anchor in [regex](regex.md) too                                               |
| `$`                      | Jump to the end of the line. Remember `$` means the end of line anchor in [regex](regex.md) too. `2$` takes you to the end of the next line  |
| `f`                      | Search forwards on the current line for the next character you type and jumps there. Prefixing with a number will jump to the Nth occurrence |
| `F`                      | Search backwards on the current line for the next character you type and jump there                                                          |
| `t`                      | Search forwards until, same as `f` but stops cursor one character before                                                                     |
| `T`                      | Search backwards until, same as `F`, but stops cursor one character after                                                                    |
| `gg`                     | Jump to first line of file                                                                                                                   |
| `G`                      | Jump to last line of file                                                                                                                    |
| `10G` / `:10`            | Jump to 10th line of file                                                                                                                    |
| `\|`                     | Jump to column, without a prefix number jumps to start of line                                                                               |
| Ctrl + `G`               | Show the filename, line number and % through file in the bottom row status line                                                              |
| Ctrl + `U`               | Jumps cursor up half a page                                                                                                                  |
| Ctrl + `D`               | Jumps cursor down half a page                                                                                                                |
| Ctrl + `F`               | Moves the file forward down a page                                                                                                           |
| Ctrl + `B`               | Moves the file backwards up a page                                                                                                           |
| `.`                      | Repeats the last command                                                                                                                     |
| `J`                      | Joins the current and next line                                                                                                              |
| `r`                      | Replaces the character under the cursor with the next character you type. `5ra` replaces the next 5 characters with `aaaaa`                  |
| `~`                      | Toggles the case of the character under the cursor. Hold to toggle through the letters of the word under the cursor                          |

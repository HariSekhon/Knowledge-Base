# GNU Screen

The classic terminal multiplexer.

<!-- INDEX_START -->

- [Key Points](#key-points)
  - [Tip: embedding multiplexers](#tip-embedding-multiplexers)
- [Commands](#commands)
- [Screen Config](#screen-config)
- [KeyStrokes](#keystrokes)

<!-- INDEX_END -->

## Key Points

- horizontal and vertical screen splitting
- built-in serial and telnet support which [tmux](tmux.md) lacks
- status bar requires [config](#screen-config)
- dynamic term titles requires [config](#commands)

Several Linux distributions are moving to [Tmux](tmux.md) which is another newer alternative.

### Tip: embedding multiplexers

You can run one terminal multiplexer inside another.

eg. on a remote SSH session inside another multiplexer on your local machine.

By using screen at one layer and [tmux](tmux.md) at another, you can avoid embedded keybindings clashes and having to double escape
keybindings all the time to send them through to the embedded multiplexer.

## Commands

Start a basic screen session:

```shell
screen
```

`Ctrl-a w` after this command to show the status bar to see you're inside screen.

List running screens:

```shell
screen -ls
```

- Start screen with options:
  - `-D` - detaching it from another terminal
  - `-R` - and reattaching it here
  - `-A` - adjusting the height and width to the current terminal

```shell
screen -DRA
```

Multi-attach to an already attached screen (useful to screen your screen with colleagues' terminals to follow along):

```shell
screen -x
```

Open new screen pane at number `$num` or next highest available:

```shell
screen $num
```

## Screen Config

`$HOME/.screenrc`

Screen requires a good configuration to make it more usable, such as:

- showing a permanent status bar along the bottom to see which screen terminal number you're in
- dynamic term titles (what command each term is running)
- custom keybindings

([Tmux](tmux.md) has this by default).

See my advanced screen config here:

[HariSekhon/DevOps-Bash-tools - configs/.screenrc](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/configs/.screenrc)

## KeyStrokes

`Ctrl-a` is the default primary keybinding action key prefix, followed by the next key.

Escape the shell key of `Ctrl-a` to jump to the start of the line by doing `Ctrl-a` , `a`.

| Action                                                                                            | Keystrokes                    |
|---------------------------------------------------------------------------------------------------|-------------------------------|
| Create a new screen                                                                               | `Ctrl-a` , `c`                |
| Switch to the next screen                                                                         | `Ctrl-a` , `n`                |
| Switch to the previous screen                                                                     | `Ctrl-a` , `p`                |
| Jump to screen number                                                                             | `Ctrl-a` , `<num>`            |
| Jump to screen number greater than 9                                                              | `Ctrl-a` , `'`, `<num>`       |
| Jump to last screen number                                                                        | `Ctrl-a` , `Ctrl-a`           |
| List screens and jump to menu selected one                                                        | `Ctrl-a` , `"`                |
| Rename screen                                                                                     | `Ctrl-a` , `A`                |
| Renumber screen<br>(will swap position with the other screen<br>if already on of that number)     | `Ctrl-a` , `:number <num>`    |
| Detach from the current screen<br>(shells stay running, can reattach later using command below)   | `Ctrl-a` , `d`                |
| Reattach to a detached screen                                                                     | `screen -r`                   |
| Split the terminal horizontally                                                                   | `Ctrl-a` , `S`                |
| Split the terminal vertically<br>(requires patching, only Mac / Debian / Ubuntu seem to have this) | `Ctrl-a` , `\|`               |
| Switch between split screens                                                                      | `Ctrl-a` , `Tab`              |
| Unify on current split                                                                            | `Ctrl-a` , `Q`                |
| Remove the current split                                                                          | `Ctrl-a` , `X`                |
| Resize the current split region                                                                   | `Ctrl-a` , `:resize <number>` |
| Enter Scroll / Copy mode                                                                          | `Ctrl-a` , `[`                |
| Search backwards in the scrollback buffer                                                         | `?`                           |
| Search forwards in the scrollback buffer                                                          | `/`                           |
| Next search match                                                               | `n`                           |
| Copy text in scrollback mode to buffer - Start / Stop copy section                                | `Space`                       |
| Paste text from buffer                                                                            | `Ctrl-a` , `]`                |
| Jump backwards one screen in scrollback buffer (or use arrow keys)                                | `Ctrl-b`                      |
| Jump forwards one screen in scrollback buffer                                                     | `Ctrl-f`                      |
| Jump to top line in current screen of scrollback buffer                                           | `H`                           |
| Jump to middle line in current screent of scrollback buffer                                       | `M`                           |
| Jump to bottom line in current screent of scrollback buffer                                       | `L`                           |
| Send a literal `Ctrl-a`                                                                           | `Ctrl-a` , `a`                |
| Text Screenshot to `~/hardcopy.$WINDOW`<br>Overwrites this same text file each time called        | `Ctrl-a` , `h`                |
| Append Start / Stop screen log to `~/screenlog.$WINDOW`                                           | `Ctrl-a` , `H`                |

**Ported from private Knowledge Base page 2012+** (should have had earlier notes)

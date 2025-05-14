# Tmux

Modern terminal multiplexer, newer alternative to [GNU Screen](screen.md).

<!-- INDEX_START -->

- [Key Points](#key-points)
  - [Tmux vs Screen](#tmux-vs-screen)
  - [Tip: embedding multiplexers](#tip-embedding-multiplexers)
- [Commands](#commands)
- [Tmux Config](#tmux-config)
- [Scripts](#scripts)
- [Key Bindings](#key-bindings)

<!-- INDEX_END -->

## Key Points

- easier for beginners
- works well without any config:
  - has a permanent status bar along the bottom
  - dynamic term titles
- more powerful command line interface for managing sessions and panes
- more easily scriptable and configurable since everything is a `tmux` command line that can be put in
  `$HOME/.tmux.conf`
- server spawns to manage sessions
- horizontal and vertical screen splitting
- supports more modern terminal features and can better handle UTF-8 and other character encodings
- lacks built-in serial and telnet support (which [screen](screen.md) has)

Many Linux distributions are transitioning from [screen](screen.md) to tmux as the newer preferred terminal multiplexer.

I still use [screen](screen.md) as my primary and tmux as my secondary terminal multiplexer.

### Tmux vs Screen

Tmux is considered more secure by default.

It historically had tighter socket permissions (screen is on parity when check though).

Tmux does not require setuid for terminal controls, and is more actively maintained.

### Tip: embedding multiplexers

You can run one terminal multiplexer inside another.

eg. on a remote SSH session inside another multiplexer on your local machine.

By using [screen](screen.md) at one layer and tmux at another, you can avoid embedded keybindings clashes and having to double escape
keybindings all the time to send them through to the embedded multiplexer.

## Commands

```shell
tmux
```

List tmux sessions to reattach to

```shell
tmux ls
```

Reattach to session zero:

```shell
tmux attach -t 0
```

or if there's only one session you can just omit the `-t 0`:

```shell
tmux attach
```

Inside tmux, you can send it commands from the command line, not just [keystrokes](keycloak.md).

```shell
tmux new-window -n some_name
```

```shell
tmux new-window -n another_name
```

## Tmux Config

`$HOME/.tmux.conf`

Tmux does't require as much configuration as [screen](screen.md) as it comes with a default status bar at the bottom to
show you which terminal window number you're in.

My tmux config is here:

[HariSekhon/DevOps-Bash-tools - configs/.tmux.conf](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/configs/.tmux.conf)

## Scripts

See these scripts in [DevOps-Bash-tools](devops-bash-tools.md) for quickly launching new screens with vertical or horizontal screen splits:

```shell
tmux_vertical.sh
```

```shell
tmux_horizontal.sh
```

## Key Bindings

`Ctrl-b` is the default primary keybinding action key prefix, followed by the next key.

| Action                                                             | Keystroke                                                                     |
|--------------------------------------------------------------------|-------------------------------------------------------------------------------|
| Create a new session                                               | `tmux`                                                                        |
| Detach from the current session                                    | `Ctrl-b` , `d`                                                                |
| Attach to a session                                                | `tmux attach-session -t <session_name>`                                       |
| List all sessions                                                  | `tmux ls`                                                                     |
| Create a new window                                                | `Ctrl-b` , `c`                                                                |
| Switch to the next window                                          | `Ctrl-b` , `n`                                                                |
| Switch to the previous window                                      | `Ctrl-b` , `p`                                                                |
| Switch to the last window                                          | `Ctrl-b` , `l`                                                                |
| List all windows                                                   | `Ctrl-b` , `w`                                                                |
| Find window                                                        | `Ctrl-b` , `f`                                                                |
| Rename the current window                                          | `Ctrl-b` , `,`                                                                |
| Split the window horizontally                                      | `Ctrl-b` , `"`                                                                |
| Split the window vertically                                        | `Ctrl-b` , `%`                                                                |
| Move cursor to other pane                                          | `Ctrl-b` then arrow keys                                                      |
| Resize current pane                                                | `Ctrl-b` , `Ctrl-<arrow>`                                                     |
| Rearrange all panes                                                | `Ctrl-b` , `Space`                                                            |
| Kill the current pane                                              | `Ctrl-b` , `x`                                                                |
| Keep current pane, close other pane                                | `Ctrl-b` , `z`                                                                |
| Unify on current split                                             | `Ctrl-a` , `!`                                                                |
| Enter Scroll / Copy mode                                           | `Ctrl-b` , `[`                                                                |
| Search backwards in the scrollback buffer                          | `?`                                                                           |
| Search forwards in the scrollback buffer                           | `/`                                                                           |
| Next search match                                                  | `n`                                                                           |
| Copy text in scrollback mode to buffer - Start / Stop copy section | `Space` to begin marker, select text, `Enter` to end marker to copy to buffer |
| Paste text from buffer                                             | `Ctrl-b` , `]`                                                                |
| Send a literal `Ctrl-b`                                            | `Ctrl-b` , `b`                                                                |
| Create a new tmux session with a name                              | `tmux new-session -s <session_name>`                                          |
| Advanced command line mode                                         | `Ctrl-b` , `:`                                                                |
| List commands                                                      | `Ctrl-b` , `:list-commands`                                                   |
| List windows                                                       | `Ctrl-b` , `:list-window`                                                     |
| Show list of bindings                                              | `Ctrl-b` , `?`                                                                |

**Ported from private Knowledge Base page 2017+**

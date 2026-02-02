# MPV

<https://mpv.io/>

[:octocat: mpv-player/mpv](https://github.com/mpv-player/mpv)

<!-- INDEX_START -->

- [Summary](#summary)
- [Install](#install)
- [Basic Usage](#basic-usage)
- [Keyboard Shortcuts](#keyboard-shortcuts)
- [Config](#config)
- [Scripts](#scripts)
- [Start Video At Double Speed](#start-video-at-double-speed)
- [Resuming Playback At Last Position](#resuming-playback-at-last-position)
- [Auto-Delete Video File After Played to Completion](#auto-delete-video-file-after-played-to-completion)
- [Screenshot Video](#screenshot-video)

<!-- INDEX_END -->

## Summary

Excellent open source video player with Lua scripting capabilities to customize its behaviours.

Based on MPlayer but more features like being able to skip to a specific time in the video
by clicking the time tracker bar at the bottom.

## Install

On macOS use [Homebrew](brew.md):

```shell
brew install mpv
```

## Basic Usage

Just give a file argument to the `mpv` command:

```shell
mpv "$file"
```

## Keyboard Shortcuts

| Key          | Description                 |
|--------------|-----------------------------|
| `]`          | Increase Speed              |
| `[`          | Decrease Speed              |
| `Backspace`  | Reset Speed to 1            |
| `Space`      | Pause / Unpause             |
| `s`          | Take a screenshot           |
| `Option`-`s` | Rapid continual screenshots |

## Config

You can find my MPV config here - it is symlinked along with my other configs by `make link` in that project:

[:octocat: HariSekhon/DevOps-Bash-tools - configs/.config/mpv/mpv.conf](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/configs/.config/mpv/mpv.conf)

## Scripts

You can find my MPV scripts here:

[:octocat: HariSekhon/DevOps-Bash-tools - configs/.config/mpv/scripts/](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/configs/.config/mpv/scripts/)

## Start Video At Double Speed

This is much better than using a hotkey to speed up QuickTime to play a video because MPV keeps the same playback speed
so when you pause and unpause (even if you set the speed with a hotkey),
whereas QuickTime unpauses back to slow 1x speed.

Yes I really watch most videos at double speed because most humans are simply far too slow.

```shell
mpv --speed=2 "$file"
```

## Resuming Playback At Last Position

You can either append the `--save-position-on-quit` command line switch:

```shell
mpv --save-position-on-quit "$file"
```

or for more permanence, put it in the [MPV config](#config) file as shown above.

[:octocat: HariSekhon/DevOps-Bash-tools - configs/.config/mpv/mpv.conf](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/configs/.config/mpv/mpv.conf)

For more advanced conditional resume,
I now instead use this [Lua](lua.md) code so I only resume for videos of a certain length
and only if I am a certain amount of time into them:

[:octocat: HariSekhon/DevOps-Bash-tools - configs/.config/mpv/scripts/resume-conditions.lua](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/configs/.config/mpv/scripts/resume-conditions.lua)

## Auto-Delete Video File After Played to Completion

I use the following code to auto-delete a video if it is played to completion for videos I only ever intend to watch once:

[:octocat: HariSekhon/DevOps-Bash-tools - configs/.config/mpv/scripts/resume-conditions.lua](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/configs/.config/mpv/scripts/delete-on-eof.lua)

It is only activated if you set the environment variable:

```text
MPV_DELETE_ON_EOF=1 mpv "$file"
```

In [DevOps-Bash-tools](devops-bash-tools.md) `.bash.d/` I set the alias `mpvd` alias to make this shorter:

```shell
alias mpvd='MPV_DELETE_ON_EOF=1 mpv --speed 2
```

## Screenshot Video

In `mpv` hitting the `s` key takes a screenshot.

But if you type `Option`-`s` on macOS then it takes continual screenshots until you stop it.

**Warning: this can run up GB of space in thousands of screenshots quite quickly though**

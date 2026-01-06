# Lua

<!--INDEX_START -->

- [Summary](#summary)
- [Linting](#linting)
  - [LuaCheck](#luacheck)
- [Real World Lua Code](#real-world-lua-code)
  - [Hammerspoon Event Handler for macOS](#hammerspoon-event-handler-for-macos)
  - [MPV video player](#mpv-video-player)

<!--INDEX_END -->

## Summary

Used as scripting language inside various tools like:

- [Hammerspoon](https://github.com/Hammerspoon/hammerspoon) - system event handler for macOS
- [MPV](https://mpv.io/) - video player

## Linting

### LuaCheck

LuaCheck is the standard linter.

Install it on [macOS](mac.md) using [Homebrew](brew.md):

```shell
brew install luacheck
```

Run it against a lua script:

```shell
luacheck "$filename.lua"
```

Output:

```text
Checking resume-conditions.lua                    OK

Total: 0 warnings / 0 errors in 1 file
```

This is called via hotkey in my
[.vimrc](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/configs/.vimrc)
which calls
[lint.sh](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/bin/lint.sh)
which is in my `$PATH` from
[DevOps-Bash-tools](devops-bash-tools.md).

## Real World Lua Code

Here is some real world Lua code for you as examples of how I've used this language.

### Hammerspoon Event Handler for macOS

I this code to automatically switch macOS sound when AirPods connect to a dual output channel so that I can Shazam songs from Love Island while watching it:

[:octocat: HariSekhon/DevOps-Bash-tools - configs/.hammerspoon/init.lua](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/configs/.hammerspoon/init.lua)

More details are in the [Mac](mac.md) page's sections:

- [Hammerspoon - System Event Handler](#hammerspoon---system-event-handler)
- [Shazam Songs while using Headphones](#shazam-songs-while-using-headphones)

### MPV video player

I use this code to automatically resume playing videos in mpv only if they match the conditions I want,
such as videos have to be a certain length
and I have to be more than a certain amount of time into the video otherwise you may as well start it from the beginning.

This is impressively flexible to suit your preferences.

[:octocat: HariSekhon/DevOps-Bash-tools - configs/.config/mpv/scripts/resume-conditions.lua](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/configs/.config/mpv/scripts/resume-conditions.lua)

More details are found in the [Video](video.md) page's [MPV](video.md#mpv) section.

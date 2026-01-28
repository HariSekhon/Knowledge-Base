# Raycast

<https://www.Raycast.com/>

<!-- INDEX_START -->

- [Summary](#summary)
- [Install](#install)
  - [Start Raycast](#start-raycast)
  - [Start at Login](#start-at-login)
- [Configure](#configure)
  - [Raycast Hotkey](#raycast-hotkey)
  - [Spotlight Indexing](#spotlight-indexing)
  - [Disable Updates](#disable-updates)
- [Raycast Extensions](#raycast-extensions)
- [Raycast Script Commands](#raycast-script-commands)
  - [Ray-so - Dev Tools](#ray-so---dev-tools)

<!-- INDEX_END -->

## Summary

Shortcut to everything.

Use as a drop in replacement for Spotlight which is full of garbage results like web pages in recent versions
of Mac.

macOS power users often switch to Raycast or Alfred to use as app launchers as they are more predictable
and respect local app priority rather than Spotlight which has been ruined trying to be a universal search usually
resulting in poor results not giving you the local app you want to launch.

## Install

```shell
brew install --cask Raycast
```

### Start Raycast

This might request permissions:

```shell
open -a Raycast
```

### Start at Login

Make Raycast auto-start every login:

```shell
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/Raycast.app", hidden:false}'
```

This can be done manually via the Settings UI too.

## Configure

### Raycast Hotkey

By default Raycast claims the `Option` + `Space` hotkey to bring it up to not clash with Spotlight.

Change this to replace Spotlight.

Go to `Settings` -> `Keyboard` -> `Keyboard Shorts` -> `Spotlight` and untick
`Show Spotlight search` and `Show Finder search window`.

Then go to Raycast's settings and change the Raycast hotkey to be `Cmd` + `Space`.

### Spotlight Indexing

Raycast uses Spotlight file indexing, so don't disable Spotlight entirely or you will lose file search.

If you really want to disable file search in Raycast, you can disable indexing entirely to save resources:

```shell
sudo mdutil -a -i off
```

### Disable Updates

Disable Raycast in-app upgrades to allow `homebrew upgrade` to run without conflict with `/Applications/Raycast.app`.

Use Mac settings which Raycast should respect:

```shell
defaults write com.raycast.macos updaterEnabled -bool false
```

Then restart Raycast to ensure the setting takes effect:

```shell
pkill -f Raycast
open -a Raycast
```

## Raycast Extensions

<https://www.Raycast.com/store>

[:octocat: Raycast/extensions](https://github.com/Raycast/extensions)

Some extensions that might be of interest.

I personally find it easier to `Cmd`-`Tab` to my browser and run a lot of things there.

- [WhatsApp](https://www.raycast.com/vimtor/whatsapp)
- [Spotify Player](https://www.Raycast.com/mattisssa/spotify-player)
- [ChatGPT](https://www.raycast.com/abielzulio/chatgpt)
- [Google Gemini](https://www.raycast.com/EvanZhouDev/raycast-gemini)
- [Google Translate](https://www.raycast.com/gebeto/translate)
- [Cursor](https://www.raycast.com/degouville/cursor-recent-projects)
- [Claude](https://www.raycast.com/florisdobber/claude)
- [Raindrop.io](https://www.raycast.com/lardissone/raindrop-io)
- [Obsidian](https://www.raycast.com/marcjulian/obsidian)
- [Remove Paywall](https://www.raycast.com/tegola/remove-paywall)
- [Iconify](https://www.raycast.com/destiner/iconify)
- [Base64](https://www.raycast.com/DanielSinclair/base64)
- [Color Picker](https://www.raycast.com/thomas/color-picker)
- [Manage Homebrew Services](https://www.raycast.com/erics118/brew-services)

## Raycast Script Commands

[:octocat: Raycast/script-commands](https://github.com/Raycast/script-commands)

Create scripts to customize Raycast.

Documentation and samples repo.

### Ray-so - Dev Tools

[:octocat: Raycast/ray-so](https://github.com/Raycast/ray-so)

Dev tools to create code snippets, browse AI prompts, create extension icons and more.

# Mas

[:octocat: mas-cli/mas](https://github.com/mas-cli/mas)

<!-- INDEX_START -->

- [Summary](#summary)
- [Install](#install)
- [Usage](#usage)
  - [List Already Installed Apps from the App Store](#list-already-installed-apps-from-the-app-store)
  - [Search for an App](#search-for-an-app)
  - [Get Status of a Specific App by ID](#get-status-of-a-specific-app-by-id)
  - [Get Detailed Info About a Specific App by ID](#get-detailed-info-about-a-specific-app-by-id)
  - [Install an App](#install-an-app)
  - [Save All Installed Packages](#save-all-installed-packages)
  - [Install All Packages from Saved List](#install-all-packages-from-saved-list)
  - [See Outdated Apps](#see-outdated-apps)
  - [Upgrade An Installed App](#upgrade-an-installed-app)
  - [Upgrade All Installed Apps](#upgrade-all-installed-apps)

<!-- INDEX_END -->

## Summary

Open source macOS command interface to the App Store.

## Install

Using [Homebrew](brew.md):

```shell
brew install mas
```

## Usage

### List Already Installed Apps from the App Store

```shell
mas list
```

### Search for an App

Example: [Shazam](shazam.md)

```shell
mas search Shazam
```

```text
 897118787  Shazam: Identify Songs          (2.11)
 545519333  Amazon Prime Video              (10.114)
1320450034  DaftCloud                       (4.2.0)
1478418722  Just Dance Now                  (8.3.0)
1556054655  Vinyls                          (2.3.2)
1599264580  WaveSavr                        (1.0)
6449814769  Swipefy for Spotify             (2.11.6)
6742663367  tynlau - music recogniser       (2025.2)
1549017891  BeatsBuddy                      (5.1.0)
1525123200  Shared: Music and Podcasts      (4.0.5)
6748985865  Daft Music: Music Player        (1.6.3)
6476125287  Dynamic-Lyrics                  (1.9.1)
1561696730  DiscoCat: Discography Catalog   (1.2.2)
 975364678  SongPop Classic - Music trivia  (2.38.2)
1592867431  Music Recognizer                (1.1)
1563765031  Crane Sudoku - Puzzle game      (0.1.1)
6739261943  TrackTrack - Gather Playlists   (1.0)
```

The first entry is the one we want, note the App ID on the left is `897118787`.

### Get Status of a Specific App by ID

```text
mas get <app_id>
```

Using the App ID from above for the Shazam app:

```shell
mas get 897118787
```

```text
Warning: Already got Shazam (897118787)
```

### Get Detailed Info About a Specific App by ID

```shell
mas lookup 897118787
```

```text
Shazam: Identify Songs 2.11 [Free]
By: Apple Distribution International
Released: 2022-08-11
Minimum OS: 10.14
Size: 11.8 MB
From: https://apps.apple.com/gb/app/shazam-identify-songs/id897118787?mt=12&uo=4
```

### Install an App

```text
mas install <app_id> [<app_id2> ...]
```
Install Shazam by its App ID:

```shell
mas install 897118787
```

```text
Warning: Already installed Shazam (897118787)
```

The `lucky` command installs the top hit for the search term, in the Shazam case above we know it's the top hit:

```shell
mas lucky Shazam
```

```text
Warning: Already installed Shazam (897118787)
```

### Save All Installed Packages

Create a text file list of all the installed App Store apps with their IDs,
stripping off the trailing version numbers using `cut`:

```shell
mas list | cut -c-40 >> mas-packages.txt
```

You can see my list in
[HariSekhon/DevOps-Bash-tools - setup/mas-packages.txt](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/setup/mas-packages.txt).

### Install All Packages from Saved List

First stripping out all `#` comment lines and then passing the first column of App IDs to `mas install`:

```shell
sed 's/#.*//' mas-packages.txt | awk '{print $1}' | xargs mas install
```

### See Outdated Apps

```shell
mas outdated
```

```text
 663592361  DuckDuckGo                (1.169.0  -> 1.174.0)
 406056744  Evernote                  (10.158.1 -> 11.1.2)
 408981434  iMovie                    (10.4.2   -> 10.4.4)
 409183694  Keynote                   (14.4     -> 14.5)
1295203466  Microsoft Remote Desktop  (10.9.9   -> 11.3.2)
 409203825  Numbers                   (14.4     -> 14.5)
 409201541  Pages                     (14.4     -> 14.5)
 803453959  Slack                     (4.46.101 -> 4.47.72)
 747648890  Telegram                  (12.1     -> 12.4.1)
 310633997  WhatsApp                  (25.37.76 -> 26.3.75)
 497799835  Xcode                     (15.4     -> 26.2)
```

### Upgrade An Installed App

Upgrade WhatsApp using its ID as seen in the leftmost column above:

```shell
mas upgrade 310633997
```

It will download and then macOS will pop-up prompt you to close WhatsApp desktop if it's open.

```text
==> Downloading WhatsApp Messenger (26.3.75)
==> Downloaded WhatsApp Messenger (26.3.75)
==> Updating WhatsApp Messenger (26.3.75)
==> Updated WhatsApp Messenger (26.3.75)
```

If you trying upgrading an app like Shazam which is already at the latest version
then there will be no output and a zero exit code.

Using the Shazam app with ID `897118787` from further above:

```shell
mas upgrade 897118787
```

No output.

### Upgrade All Installed Apps

```shell
mas upgrade
```

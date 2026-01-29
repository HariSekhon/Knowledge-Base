# Shazam

<https://www.shazam.com/>

<!-- INDEX_START -->

- [Summary](#summary)
- [Shazam Apps](#shazam-apps)
  - [Mobile App](#mobile-app)
  - [Desktop App](#desktop-app)
  - [Chrome Browser Extension](#chrome-browser-extension)
- [Shazam Desktop App Scripts](#shazam-desktop-app-scripts)
  - [List Tracks from the Shazam Desktop App](#list-tracks-from-the-shazam-desktop-app)
  - [Deletes an `Artist` + `Track` name Combination](#deletes-an-artist--track-name-combination)
  - [Search Spotify Desktop App for Shazam'd Track, Then Delete It From Shazam](#search-spotify-desktop-app-for-shazamd-track-then-delete-it-from-shazam)

<!-- INDEX_END -->

## Summary

Listens to music and matches it using Shazam's databases of digital music fingerprints.

## Shazam Apps

### Mobile App

<https://www.shazam.com/apps>

iOS and Android apps.

### Desktop App

I use the Desktop app on Mac a lot to shazam songs from TV shows as documented in the [Audio](audio.md) page section:

[Shazam Songs While Using Headphones on Mac](audio.md#shazam-songs-while-using-headphones-on-mac)

Unfortunately the desktop app is just a thin wrapper to the online service and doesn't have the store and try later
unfortunately capability of the mobile app, but you can't use your phone to Shazam songs while you're watching something
in headphones.

If the network connectivity is down the desktop Shazam app will just return a generic error
that it couldn't determine the track instead of properly notifying you that it wasn't able to contact the upstream
Shazam servers to check the database.

This is an area that should have been improved in the desktop app.

To mitigate this a little you should use apps like Stats and Pingr
as documented on the [Mac](mac.md) page to keep network monitoring in your status bar
to know when it's a real failure to determine the song fingerprint vs just a network failure.

Install on macOS from the [App Store](https://apps.apple.com/us/app/shazam-identify-songs/id897118787):

```shell
open https://apps.apple.com/us/app/shazam-identify-songs/id897118787
```

or install on the command line using [Mas](mas.md):

```shell
mas search Shazam
```

```text
 897118787  Shazam: Identify Songs          (2.11)
<more irrelevant results>
```

```shell
mas install 897118787
```

### Chrome Browser Extension

[Shazam in the Chrome Store](https://chrome.google.com/webstore/detail/shazam-find-song-names-fr/mmioliijnhnoblpgimnlajmefafdfilb)

I'm not sure why you'd want to bloat your browser with this extension instead of just using the separate desktop app.

## Shazam Desktop App Scripts

The Shazam desktop app uses Apple's _"Core Data"_ object persistence framework that usually stores data in
[SQLite](sqlite.md) using a 2001-based UTC timestamp and auto-generated schemas.

I have written the following scripts to use this.

From [DevOps-Bash-tools](devops-bash-tools.md) under the `applescript/` directory:

### List Tracks from the Shazam Desktop App

Gets the list of tracks (newest first) from the SQLite DB on the command line for piping to other commands:

```shell
shazam_app_dump_tracks.sh
```

You can pass it a limited number of tracks to return.

You can also pass it an argument to only return `today` / `yesterday` / `week` or a specific `YYYY-MM-DD` date.

In that case it returns the tracks in the order they were shazam'd first
(for building a playlist of the tracks in the order they appear in the episode).

### Deletes an `Artist` + `Track` name Combination

Deletes a given track from the Shazam app directly in is [SQLite](sqlite.md) DB:

```shell
shazam_app_delete_track.sh "<artist>" "<track>"
```

If there are multiple instances of that song,
it deletes all of them which is useful to automatically get rid of duplicates because sometimes we shazam more than once
to be sure we have the right track.

### Search Spotify Desktop App for Shazam'd Track, Then Delete It From Shazam

Searches for a track in the local Spotify desktop app,
waits for a command line enter prompt before continuing (to allow you to add the song to a playlist),
and then deletes the track from the Shazam SQLite DB.

Utilizes my above two list and delete shazam scripts along with my `applescript/keystrokes.sh` script to
automate searching in the Spotify desktop app.

```shell
shazam_search_spotify_then_delete_track.sh
```

This is a workaround to the removal of Spotify integration by Apple as the competitor to their own Apple Music.

# Spotify

<https://spotify.com/>

<!-- INDEX_START -->

- [Summary](#summary)
- [Desktop Player](#desktop-player)
  - [Clear Local Spotify Desktop Cache](#clear-local-spotify-desktop-cache)
- [Mobile Player](#mobile-player)
- [Web Player](#web-player)
- [Spotify API](#spotify-api)
- [Spotify API Code](#spotify-api-code)
- [Spotify Playlists & Playlist Management Code](#spotify-playlists--playlist-management-code)
- [Playlist Migration Between Different Music Platforms](#playlist-migration-between-different-music-platforms)
  - [MakeList](#makelist)
  - [Soundiiz](#soundiiz)

<!-- INDEX_END -->

## Summary

Excellent music streaming platform with ultra low latency instant playing and offline downloads on Premium.

Has Desktop, Mobile and Web players.

I've been using this platform and writing API code for it for about 15+ years.

There are a couple main weaknesses to this platform:

- Some tracks aren't available due to licensing, leaving you to source and load them yourself into the app,
  although this is rare
- Spotify API is not quite complete (misses folder structure)
- Spotify itself does not respond to community improvement requests and there have been improvement requests open for
  years for some things

Overall this is still my favourite music platform for the last 15+ years.

## Desktop Player

<https://www.spotify.com/us/download/>

My preferred player as it's slightly more polished and you can have offline downloads on Premium.

### Clear Local Spotify Desktop Cache

Close Spotify, delete the cache and then re-open the app.

On Mac:

```shell
rm -rf ~/Library/"Application Support"/Spotify/PersistentCache/Storage
```

On Linux:

```shell
rm -rf ~/.cache/spotify/Storage
```

## Mobile Player

Available in the iPhone [AppStore](https://spotify.link/h5TbcGLLkhb?label=sp_cid%3A47120e64f796e76ec16a8baea3cdde53)
and Android [Google Play Store](https://spotify.link/T1vKH6Kr9ib?label=sp_cid%3A47120e64f796e76ec16a8baea3cdde53).

## Web Player

<https://open.spotify.com/>

Usable immediately from your browser without any installation needed,
but the Desktop player is better if you're using it extensively.

## Spotify API

The API is fairly good and exposes a lot of information, although not folder structure.

My extensive Spotify API code is available for free publicly (listed further down) to back up and manage playlists,
deduplicate, blacklist tracks and more.

My extensive Spotify playlists and filtering through tens of thousands of songs would not be sustainable without this
management code.

## Spotify API Code

Spotify scripts and API tools can be found in the following repos.

Extensive API code can be found in here:

[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=HariSekhon&repo=DevOps-Bash-tools&theme=ambient_gradient&description_lines_count=3)](https://github.com/HariSekhon/DevOps-Bash-tools)

Some generalization such as a Spotify command line and track name normalization rules can be found here:

[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=HariSekhon&repo=Spotify-tools&theme=ambient_gradient&description_lines_count=3)](https://github.com/HariSekhon/Spotify-tools)

## Spotify Playlists & Playlist Management Code

Playlist specific management code scripting can be found here:

[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=HariSekhon&repo=Spotify-playlists&theme=ambient_gradient&description_lines_count=3)](https://github.com/HariSekhon/Spotify-playlists)

## Playlist Migration Between Different Music Platforms

### MakeList

<https://www.makelist.co/>

Generates a Spotify playlist from a URL containing tracks.

You may want to use [File Upload Sites](upload-sites.md) to create that URL with a text file of your tracks.

In the case of [HariSekhon/Spotify-Playlists](https://github.com/HariSekhon/Spotify-playlists) I provide these
`Artist - Track` format text files which could be used directly from GitHub
by just clicking the `Raw` link at the top of GitHub's website on any of those files to get the URL with the raw text.

Their counterpart Spotify URI format files are also provided in that repo.

### Soundiiz

<https://soundiiz.com/>

Migrates playlists between music service of your choice, although that requires a paid plan.

The free plan only allows you to create or import playlists but not translate or export them to other platform formats.

I'd personally just write the code to push them to another music service if I wanted to,
although if you were only doing a one time migration, paying for a month would be the most time-cost effective way to go.

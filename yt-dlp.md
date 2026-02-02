# YouTube Downloader

[:octocat: yt-dlp/yt-dlp](https://github.com/yt-dlp/yt-dlp)

<!-- INDEX_START -->

- [Summary](#summary)
- [Website](#website)
- [Install](#install)
- [Download Single Video](#download-single-video)
- [Download Video Not Inferred from Web Page](#download-video-not-inferred-from-web-page)
- [Download All Videos from YouTube Channel](#download-all-videos-from-youtube-channel)
- [Stacher7 - GUI for yt-dlp](#stacher7---gui-for-yt-dlp)

<!-- INDEX_END -->

## Summary

Open source YouTube Downloader can download both video and audio from not just YouTube but many other social media sites
including Facebook, Twitter / X etc.

## Website

If you don't want to run the open source command line version, you can try this website:

<https://ytdlp.online/>

## Install

Install `yt-dlp` to download, and ffmpeg for conversions:

```shell
brew install yt-dlp ffmpeg
```

There's a long list of extractors for different sites:

```shell
yt-dlp --list-extractors
```

but it even works on even sites for which there aren't special extractors.

Show available download formats:

```shell
yt-dlp -F "$url"
```

You can then choose the format quality you want:

```shell
yt-dlp -f "$format_id" "$url"
```

If you get an error like this:

```shell
ERROR: [youtube] ...: Sign in to confirm you’re not a bot.
```

You can add this switch with your browser to use its cookies:

```text
--cookies-from-browser chrome
```

## Download Single Video

Use script from
[DevOps-Bash-tools](devops-bash-tools.md) repo
to simplify downloading with maximum quality and compatibility, with continue and no overwrite settings.

This script has symlinks for X/Twitter and Facebook too as it can download from those sites and should also work for all
those listed by the above command of `yt-dlp --list-extractors`:

```shell
youtube_download_video.sh "$url"
```

These are just symlinks for convenience:

```shell
x_download_video.sh "$url"
```

```shell
twitter_download_video.sh "$url"
```

```shell
facebook_download_video.sh "$url"
```

The script will even attempt to install `yt-dlp` and `ffmpeg` prerequisites if not already installed.

If you get an error like this:

```shell
ERROR: [youtube] ...: Sign in to confirm you’re not a bot.
```

then export this:

```shell
export YT_DLP_COOKIES_FROM_BROWSER=chrome
```

and re-run the script, which will then use the switch `--cookies-from-browser chrome`.

## Download Video Not Inferred from Web Page

The `yt-dlp` tool works really well for extracting the video from many different web pages, but
if it fails to parse the page, there is a workaround:

1. Open Chrome Developer Tools or similar network request tracing
2. Click to play the video
3. Record the `m3u8` url from the Network section
4. Pass the `m3u8` url to the script - since `yt-dlp` will infer the filename from the m3u8 filename, you'll likely want
   to pass a second argument to the script for the real filename eg. `Some Video.mp4`

```shell
youtube_download_video.sh "https://.../index.m3u8" "Some Video.mp4"
```

## Download All Videos from YouTube Channel

Using [DevOps-Bash-tools](devops-bash-tools.md) repo:

```shell
youtube_download_channel.sh "$url"
```

## Stacher7 - GUI for yt-dlp

<https://stacher.io/>

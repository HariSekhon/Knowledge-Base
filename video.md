# Video

<!-- INDEX_START -->

- [Buffer Videos](#buffer-videos)
  - [Faststream](#faststream)
- [Download Videos](#download-videos)
  - [yt-dlp](#yt-dlp)
  - [Download Single Video](#download-single-video)
  - [Download Video Not Inferred from Web Page](#download-video-not-inferred-from-web-page)
  - [Download All Videos from YouTube Channel](#download-all-videos-from-youtube-channel)
  - [Stacher7 - GUI for yt-dlp](#stacher7---gui-for-yt-dlp)
- [Inspect Video File Metadata](#inspect-video-file-metadata)
  - [Get the resolution and other details like codec for a video file](#get-the-resolution-and-other-details-like-codec-for-a-video-file)
- [Downscale Video to 720p mp4](#downscale-video-to-720p-mp4)
- [Clip Video](#clip-video)
  - [Clip Video Interactively using QuickTime Player](#clip-video-interactively-using-quicktime-player)
  - [Clip Video on Command Line using `ffmpeg`](#clip-video-on-command-line-using-ffmpeg)
- [Transcode mkv into standard mp4 for smart TVs to play](#transcode-mkv-into-standard-mp4-for-smart-tvs-to-play)

<!-- INDEX_END -->

## Buffer Videos

### Faststream

<https://faststream.online/>

Install the extension and then just click the extension when on a web page.

It'll replace the video placer with a custom one that buffers.

## Download Videos

### yt-dlp

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

### Download Single Video

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

### Download Video Not Inferred from Web Page

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

### Download All Videos from YouTube Channel

Using [DevOps-Bash-tools](devops-bash-tools.md) repo:

```shell
youtube_download_channel.sh "$url"
```

### Stacher7 - GUI for yt-dlp

<https://stacher.io/>

## Inspect Video File Metadata

```shell
ffprobe "$file"
```

If you just want to see whether a video is 480p or 720p or 1080p etc:

```shell
ffprobe "$file" 2>&1 | grep 'Stream.*Video'
```

```shell
exiftool "$file"
```

```shell
mediainfo "$file"
```

```shell
mediainfo --fullscan "$file"
```

```shell
avprobe "$file"
```

```shell
mplayer -vo null -ao null -identify -frames 0 "$file"
```

```shell
tovid id "$file"
```

### Get the resolution and other details like codec for a video file

```shell
ffmpeg -i "$file"
```

or

```shell
ffprobe "$file"
```

## Downscale Video to 720p mp4

Useful to make good trade-off of quality vs size for social media posting.

Using [DevOps-Bash-tools](devops-bash-tools.md) repo:

```shell
video_to_720p_mp4 "$file"
```

If the video is less than this resolution already, it'll do nothing.

## Clip Video

### Clip Video Interactively using QuickTime Player

Quickly clip a video on Mac using QuickTime Player:

```shell
open -a "QuickTime Player" "$file"
```

Then press shortcut `Cmd` + `T`
or click `Edit` -> `Trim` to bring up a slider to drag and then save the resulting clip as a new file.

### Clip Video on Command Line using `ffmpeg`

Create a clip from a video file using `ffmpeg` args:

- `-ss <offset>` and `-to <duration>` where duration is integer seconds or `HH:MM:SS` format
- `-c copy` - `-c` specifies codec, `copy` is quick and cheap codec compared to transcoding

```shell
ffmpeg -i input_vid.mp4 -ss 00:08:35.0 -t 72 -c copy output_vid.mp4
```

or using time format `-to 00:01:12` which is the same as 72 seconds from offset start.

<!--

## Generate Transcript for Video on Instagram

<https://www.klippyo.com/tools/instagram-reel-transcriber/>

## Translate Video

<https://clideo.com/translate-instagram-video>

## Translate Video on Instagram

<https://videotranslator.blipcut.com/instagram-video-translator.html>

-->

## Transcode mkv into standard mp4 for smart TVs to play

```shell
ffmpeg -i "input.mkv" "output.mp4"
```

There is an automated script in the [DevOps-Bash-tools](devops-bash-tools.md) repo's `media/` directory to iterate many files easily:

```shell
mkv_to_mp4.sh *.mkv
```

or find all mkv files recursively under the given directory and convert them (retains originals), in this case the `$pwd` denoted by a dot:

```shell
mkv_to_mp4.sh .
```

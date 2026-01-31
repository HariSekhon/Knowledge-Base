# Video

<!-- INDEX_START -->

- [Best Video Players](#best-video-players)
- [Buffer Streaming Videos in Browser](#buffer-streaming-videos-in-browser)
  - [Faststream](#faststream)
- [Download Videos from Social Media](#download-videos-from-social-media)
  - [YouTube Downloader- yt-dlp](#youtube-downloader--yt-dlp)
- [Inspect Video File Metadata](#inspect-video-file-metadata)
  - [Get the resolution and other details like codec for a video file](#get-the-resolution-and-other-details-like-codec-for-a-video-file)
- [Downscale Video to 720p mp4](#downscale-video-to-720p-mp4)
- [Clip Video](#clip-video)
  - [Clip Video Interactively using QuickTime Player](#clip-video-interactively-using-quicktime-player)
  - [Clip Video on Command Line using FFmpeg](#clip-video-on-command-line-using-ffmpeg)
- [Transcode mkv into standard mp4 for smart TVs to play](#transcode-mkv-into-standard-mp4-for-smart-tvs-to-play)

<!-- INDEX_END -->

## Best Video Players

- [VLC](https://www.videolan.org/) - the open source champion forever, very mature with lots of features and built-in
  codec support for nearly every video format out there - it plays just about anything
- [MPlayer](http://www.mplayerhq.hu/) - another good open source media player, can sometimes play partially broken files
  better than VLC which may crash / exit the file if it's incomplete, and better for triggering off the command line
- [MPV](https://mpv.io/) - excellent open source video player based on MPlayer with more features and [Lua](lua.md)
  scripting capabilities to customize its behaviours.
  See the [MPV](mpv.md) page for more details

```shell
brew install vlc
```

```shell
brew install mplayer
```

```shell
brew install mpv
```

From the command line, `mpv` and `mplayer` are better than VLC:

```shell
mpv "$file"
```

```shell
mplayer "$file"
```

Compared to:

```shell
"/Applications/VLC.app/Contents/MacOS/VLC" "$file"
```

If you want a short `vlc` command, try this:

```shell
alias vlc='/Applications/VLC.app/Contents/MacOS/VLC'
```

then you can do:

```shell
vlc "$file"
```

This is already included in the alaises in the [DevOps-Bash-tools](devops-bash-tools.md) repo.

## Buffer Streaming Videos in Browser

### Faststream

<https://faststream.online/>

Install the extension and then just click the extension when on a web page.

It'll replace the video placer with a custom one that buffers.

## Download Videos from Social Media

### YouTube Downloader- yt-dlp

Works for various social media including YouTube, Facebook and Twitter / X.

See the [YouTube Downloader](yt-dlp.md) page for details.

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

### Clip Video on Command Line using FFmpeg

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

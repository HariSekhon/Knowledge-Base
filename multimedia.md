# MultiMedia

Media file analysis, editing, transcoding and conversions.

<!-- INDEX_START -->

- [Image](#image)
  - [Open a file from the command line](#open-a-file-from-the-command-line)
  - [Check & Change the default Application for a given file type](#check--change-the-default-application-for-a-given-file-type)
  - [Convert Webp to PNG format](#convert-webp-to-png-format)
  - [Convert SVG to PNG format](#convert-svg-to-png-format)
  - [Trim Pixels off one side of an Image](#trim-pixels-off-one-side-of-an-image)
  - [Join Two Images Together](#join-two-images-together)
  - [Create Animated GIFs of Commands](#create-animated-gifs-of-commands)
  - [Inspect Image File Metadata](#inspect-image-file-metadata)
  - [Look for Watermarks](#look-for-watermarks)
  - [Steghide](#steghide)
  - [Image Upload Sites](#image-upload-sites)
- [Video](#video)
  - [Get the resolution and other details like codec for a video file](#get-the-resolution-and-other-details-like-codec-for-a-video-file)
  - [Transcode mkv into standard mp4 for smart TVs to play](#transcode-mkv-into-standard-mp4-for-smart-tvs-to-play)
  - [Video Clipping](#video-clipping)
  - [Inspect Media File](#inspect-media-file)
- [Audio](#audio)
  - [MP3 metadata editing](#mp3-metadata-editing)
- [MediaBox Setup](#mediabox-setup)
  - [Remote control](#remote-control)

<!-- INDEX_END -->

## Image

### Open a file from the command line

From [DevOps-Bash-tools](devops-bash-tools.md) repo,
determines whatever tool is available on either Linux or Mac and uses that to open the image file:

```shell
imageopen.sh "$filename"
```

This uses the default application for the file type.

### Check & Change the default Application for a given file type

```shell
brew install duti
```

Check default Application for a given file type:

```shell
duti -x svg
```

Change this from say Inkscape which is a slow editor for just file viewing, to Google Chrome which is faster:

```shell
duti -s com.google.Chrome public.svg-image all
```

### Convert Webp to PNG format

[medium.com](medium.md) doesn't support using newer webp format images on the site so you need to convert them first:

On Mac, install the Imagemagick or Webp [homebrew](brew.md) packages:

```shell
brew install imagemagick
```

or

```shell
brew install webp
```

Convert the image using ImageMagick:

```shell
magick "$name.webp" "$name.png"
```

or using `dwebp`:

```shell
dwebp "$name.webp" -o "$name.png"
```

or more simply use this script in [DevOps-Bash-tools](devops-bash-tools.md) repo
which will find / install and use one of the above tools, and protect against overwriting:

```shell
webp_to_png.sh "$name.webp"
```

You can also inspect the webp header like this:

```shell
webpinfo "$name.webp"
```

### Convert SVG to PNG format

Many major websites like [LinkedIn](https://linkedin.com), [Medium](https://medium.com) and [Reddit](https://reddit.com)
do not accept SVG images so you must convert to another supported format like PNG.

Using ImageMagick:

```shell
convert "$name.svg" "$name.png"
```

or using Inkscape (slower than ImageMagick):

```shell
inkscape "$name.svg" --export-filename="$name.png"
```

or using `rsvg-convert`:

```shell
rsvg-convert "$name.svg" -o "$name.png"
```

or more simply use this script in [DevOps-Bash-tools](devops-bash-tools.md) repo
which will find / install and use one of the above tools and protect against overwriting:

```shell
svg_to_png.sh "$name.svg"
```

### Trim Pixels off one side of an Image

Useful for tweaking Screenshots before sharing them.

You can use Imagemagick to do this from the command line more easily than using Gimp.

Use this script from [DevOps-Bash-tools](devops-bash-tools.md) repo,
as it's easier than using UI tools like Gimp or even ImageMagick directly etc.

```shell
image_trim_pixels.sh "$image" <top|bottom|left|right> "$num_pixels"
```

### Join Two Images Together

Useful to create memes.

Since images can have different widths and end up with whitespace around the smaller image,
use this script from the [DevOps-Bash-tools](devops-bash-tools.md) repo
to joins them after matching their heights or widths so they align correctly:

```shell
image_join_vertical.sh "$top_image" "$bottom_image" "joined_image.png"
```

```shell
image_join_horizontal.sh "$left_image" "$right_image" "joined_image.png"
```

### Create Animated GIFs of Commands

[:octocat: icholy/ttygif](https://github.com/icholy/ttygif)

[:octocat: asciinema/asciinema](https://github.com/asciinema/asciinema)

[:octocat: faressoft/terminalizer](https://github.com/faressoft/terminalizer)

From [DevOps-Bash-tools](devops-bash-tools.md):

```shell
ttygif.sh
```

```shell
asciinema.sh
```

```shell
terminalizer.sh
```

Create custom Terminalizer config:

```shell
terminalizer init
```

```text
The global config directory is created at
/Users/hari/.config/terminalizer
```

Then edit:

```shell
vim ~/.config/terminalizer/config.yml
```

![Gif All the Things](images/gif_all_the_things.jpeg)

### Inspect Image File Metadata

```shell
exiftool "$file"
```

Identify command from imagemagick is more verbose:

```shell
identify -verbose "$file"
```

Exiv2 is less reliable:

```shell
exiv2
```

### Look for Watermarks

```shell
magick "$file" -edge 1 output.jpg
```

Then visually inspect the `output.jpg` which is blacked out to see sillouttes more easily.

You can also try converting to black & white (grey):

```shell
magick "$file" -channel Red -separate output.jpg
```

### Steghide

This on only works if you've hidden something inside the image and know the password to extract it:

```shell
steghide info "$file"
```

Looks like this is removed from Mac Homebrew, launch it in a debian docker container instead:

```shell
steghide extract -sf "$file"
```

### Image Upload Sites

See the [File Upload & Code PasteBin sites](upload-sites.md) doc.

## Video

### Get the resolution and other details like codec for a video file

```shell
ffmpeg -i "$file"
```

or

```shell
ffprobe "$file"
```

### Transcode mkv into standard mp4 for smart TVs to play

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

### Video Clipping

Create a clip from a video file using ffmpeg args:

- `-ss <offset>` and `-to <duration>` where duration is integer seconds or `HH:MM:SS` format
- `-c copy` - `-c` specifies codec, `copy` is quick and cheap codec compared to transcoding

```shell
ffmpeg -i input_vid.mp4 -ss 00:08:35.0 -t 72 -c copy output_vid.mp4
```

or using time format `-to 00:01:12` which is the same as 72 seconds from offset start.

### Inspect Media File

```shell
ffprobe "$file"
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
mplayer -vo null -ao null -identify -frames 0 $file
```

```shell
tovid id "$file"
```

## Audio

### MP3 metadata editing

Use the `id3v2` program to set metadata on mp3 files.

Useful to group a bunch of mp3 files for an audiobook.

Set the `--author` / `-a` and `--album` / `-A` tags at once so Mac's `Books.app` groups them properly into one audiobook:

```shell
id3v2 -a "MyAuthor" -A "MyAlbum" *.mp3
```

The scripts `mp3_set_artist.sh` and `mp3_set_album.sh` in the [DevOps-Bash-tools](devops-bash-tools.md) repo's `media/`
directory make it slightly easier.

Set the `--track` number for each mp3 file, so they play in the right order:

```shell
i=0
for x in *.mp3; do
  ((i+=1))
  id3v2 -T $i "$x"
done
```

The scripts `mp3_set_track_order.sh` and `mp3_set_track_name.sh` in the [DevOps-Bash-tools](devops-bash-tools.md) repo's `media/`
directory make this slightly easier.

Recursively set Artist/Album - XXX: Danger, use only in an audiobook subdirectory, otherwise it'll ruin the metadata of your MP3 library!

```shell
find . -maxdepth 2 -iname '*.mp3' |
{
  i=0
  while read mp3; do
    ((i+=1))
    id3v2 -a "MyAuthor" -A "MyAlbum" "$mp3"
  done
}
```

Recursively set Track Order - for subdirectories eg. CD1, CD2 etc... XXX: use with care - misused at the top it'd ruin your MP3 library's metadata:

```shell
find . -maxdepth 2 -iname '*.mp3' |
{
  i=0
  while read mp3; do
    ((i+=1))
    id3v2 -T $i "$mp3"
  done
}
```

## MediaBox Setup

This is old from 2010 and probably needs some updates:

```shell
aptitude install nvidia-glx-173
aptitude -y purge samba
aptitude -y purge bluez bluetooth gnome-bluetooth bluez-utils
aptitude -y purge cups bluez-cups cups-driver-gutenprint foo2zjs foomatic-db foomatic-db-engine ghostscript-cups hpijs hplip openprinting-ppds pxljr splix
apt-get -y purge evolution evolution-common
aptitude -y purge openssh-server
dpkg -l | grep openoffice | awk '{print $2}' | xargs aptitude -y purge language-support-en language-support-writing-en python-uno
```

```shell
aptitude -y install sysstat
aptitude -y install unrar
```

```shell
aptitude -y install libdvdread4
/usr/share/doc/libdvdread4/install-css.sh
```

### Remote control

as root:

```shell
mkdir /var/run/lirc # it wouldn't create it and it wouldn't start without it on ubuntu
```

```shell
aptitude -y install dvb-utils
```

Cyberlink remote shows us as /dev/input/event3 according to google.

Can cat that or after installing `dvb-utils`, can do:

```shell
evtest /dev/input/event3
```

except dvb-utils has no install candidate and tells you to instead get dvb-apps which is already installed and doesn't have evtest, only the c file for it

```shell
less /proc/bus/input/devices
```

remote control is detected as a keyboard so a bunch of stuff just works out of the box.
Should use `xmodmap` to add the remaining buttons to do things I want

**Ported from private Knowledge Base pages 2010+**

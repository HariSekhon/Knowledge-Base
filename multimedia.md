# MultiMedia

Media file analysis, editing, transcoding and conversions.

<!-- INDEX_START -->

- [PDF](#pdf)
- [Image](#image)
- [Video](#video)
- [Audio](#audio)
  - [MP3 metadata editing](#mp3-metadata-editing)
- [MediaBox Setup](#mediabox-setup)
  - [Remote control](#remote-control)
- [Troubleshooting](#troubleshooting)
  - [ImageMagic error converting from Avif image format](#imagemagic-error-converting-from-avif-image-format)
- [Memes](#memes)
  - [Marketing Matters](#marketing-matters)

<!-- INDEX_END -->

## PDF

See [PDF](pdf.md) doc.

## Image

See [Image](image.md) doc.

## Video

See [Video](video.md) doc.

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

## Troubleshooting

### ImageMagic error converting from Avif image format

```text
magick: unable to load module '/opt/homebrew/Cellar/imagemagick/7.1.1-43/lib/ImageMagick/modules-Q16HDRI/coders/heic.la': file not found @ error/module.c/OpenModule/1293.
magick: no decode delegate for this image format `AVIF' @ error/constitute.c/ReadImage/746.
```

Solution:

```shell
brew info libheif
```

## Memes

### Marketing Matters

![Marketing Matters](images/multimedia_marketing_matters.jpeg)

**Ported from private Knowledge Base pages 2010+**

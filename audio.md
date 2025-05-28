# Audio

<!-- INDEX_START -->

- [MP3 metadata editing](#mp3-metadata-editing)
  - [Setting Author and Album metadata](#setting-author-and-album-metadata)
  - [Setting Track Number metadata](#setting-track-number-metadata)
  - [Recursively Set Metadata](#recursively-set-metadata)
    - [Recursively Set Artist and Album](#recursively-set-artist-and-album)
    - [Recursively Set Track Order](#recursively-set-track-order)
- [Memes](#memes)
  - [Marketing Matters](#marketing-matters)

<!-- INDEX_END -->

## MP3 metadata editing

Use the `id3v2` program to set metadata on mp3 files.

Useful to group a bunch of mp3 files for an audiobook.

### Setting Author and Album metadata

Set the `--author` / `-a` and `--album` / `-A` tags at once so Mac's `Books.app` groups them properly into one audiobook:

```shell
id3v2 -a "MyAuthor" -A "MyAlbum" *.mp3
```

The scripts `mp3_set_artist.sh` and `mp3_set_album.sh` in the [DevOps-Bash-tools](devops-bash-tools.md) repo's `media/`
directory make it slightly easier.

### Setting Track Number metadata

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

### Recursively Set Metadata

#### Recursively Set Artist and Album

**XXX: Danger, use only in an audiobook subdirectory, otherwise it'll ruin the metadata of your MP3 library!**

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

#### Recursively Set Track Order

For subdirectories eg. CD1, CD2 etc...

**XXX: use with care - if misused at the top dir it'd ruin your MP3 library's metadata**

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

## Memes

### Marketing Matters

![Marketing Matters](images/multimedia_marketing_matters.jpeg)

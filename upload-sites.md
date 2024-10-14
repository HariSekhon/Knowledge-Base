# File Upload & Code PasteBin sites

Shortlist of the best sites to upload files, images, or paste code snippets to share with others for debugging.

More useful than huge lists since you only need a few of the best sites to work with.

Double check the Terms & Conditions around [Hotlinking](https://simple.wikipedia.org/wiki/Hotlinking)
before you link from another site so you don't get blocked!

Also check the sites rights to your keep and redistribute your content permanently!

<!-- INDEX_START -->

- [Code Pasting Sites](#code-pasting-sites)
  - [Pastebin](#pastebin)
  - [GitHub Gists](#github-gists)
- [File Upload Sites](#file-upload-sites)
  - [0x0.st](#0x0st)
  - [Catbox](#catbox)
  - [Litterbox](#litterbox)
  - [Uguu](#uguu)
  - [File.io](#fileio)
- [Image Upload Sites](#image-upload-sites)
  - [Imgur](#imgur)
  - [PostImage](#postimage)
  - [Vgy.me](#vgyme)

<!-- INDEX_END -->

## Code Pasting Sites

### Pastebin

<https://pastebin.com/>

The original code pasting site.

Optional expiration auto-deletion.

### GitHub Gists

<https://gist.github.com/>

- Easy to use
- Code paste or files
- Private or Public
- Has revisions
- Easy to track in your [GitHub](github.md) account

## File Upload Sites

### 0x0.st

<https://0x0.st/>

- Fast
- Simple
- up to 512MB
- Very basic as you can see from the ASCII page
- Retention is only 1 month to 1 year

```shell
curl -F "file=@$image" https://0x0.st
```

Output is simply the file URL:

```text
https://0x0.st/X6d2.png
```

### Catbox

<https://catbox.moe/>

- All uploads are Anonymous
- Up to 200MB
- Retained Forever
- Does not allow [Hotlinking](https://simple.wikipedia.org/wiki/Hotlinking)
- [blocked in several countries](https://catbox.moe/faq.php) like the UK, Australia etc.
- [Tools Doc](https://catbox.moe/tools.php) for how to use it

Catbox (permanent retention):

```shell
curl -F "reqtype=fileupload" \
     -F "fileToUpload=@$image" \
     https://catbox.moe/user/api.php
```

Output is just the file URL:

```text
https://files.catbox.moe/pihtj4.png
```

### Litterbox

<https://litterbox.catbox.moe/>

By the same people as Catbox

- Temporary
- Up to 1GB

Litterbox with 1 day retention - [doc](https://litterbox.catbox.moe/tools.php)

```shell
curl -F "reqtype=fileupload" \
     -F "time=24h" \
     -F "fileToUpload=@$image" \
     https://litterbox.catbox.moe/resources/internals/api.php
```

Output is just the file URL:

```text
https://litter.catbox.moe/toh6ua.png
```

### Uguu

<https://uguu.se/>

Temporary anonymous file hosting with support for image uploads.

[API Doc](https://uguu.se/api) (for how to use curl).

```shell
curl -i -F "files[]=@$image" https://uguu.se/upload
```

Output is JSON:

```json
{
    "success": true,
    "files": [
        {
            "hash": "6afdae66370604df",
            "filename": "asKLYtPk.png",
            "url": "https:\/\/f.uguu.se\/asKLYtPk.png",
            "size": 37644,
            "dupe": false
        }
    ]
}
```

Unless you add `?output=text` to the URL:

```shell
curl -F "files[]=@$image" https://uguu.se/upload?output=text
```

in which it outputs just the URL:

```text
https://f.uguu.se/hLquEFAW.png
```

### File.io

<https://www.file.io/>

Anonymous but free version auto-deletes file after 1 download!

Paid plans have optional expiration.

Doesn't render images but gives a Download box button.

```shell
curl -F "file=@$image" https://file.io
```

<!-- Dead

### Transfer.sh

<https://transfer.sh/>

Anonymous file uploads with public link generation and encryption support.

```shell
curl --upload-file "$image" "https://transfer.sh/${image##*/}"
```

### AnonFiles

<https://anonfiles.com/>

Free and anonymous.

```shell
curl -F "file=@$image" https://api.anonfiles.com/upload
```

### Bayfiles

<https://bayfiles.com/>

```shell
curl -F "file=@path_to_image" https://api.bayfiles.com/upload
```

-->

## Image Upload Sites

Useful to send things like graph or diagrams then reference them in GitHub docs without bloating your repos by
constantly replacing the images in your repo.

- [Imgur](https://imgur.com/) - popular image hosting site with anonymous uploads, direct links and a robust API
- [Vgy.me](https://vgy.me/) - temporary anonymous image hosting with hotlinking allowed

### Imgur

- UI insists on disabling Ad-blocker

Posting to Imgur is as simple as:

```shell
curl -H "Authorization: Client-ID YOUR_CLIENT_ID" \
     -F "image=@$image" \
     https://api.imgur.com/3/image
```

The output should look like this indicating success HTTP 200 status code:

```json
{"status":200,"success":true,"data":{"id":"nsLltwo","deletehash":"UuID9Xe3MsmeUni","account_id":null,"account_url":null,"ad_type":null,"ad_url":null,"title":null,"description":null,"name":"","type":"image/png","width":1280,"height":720,"size":37103,"views":0,"section":null,"vote":null,"bandwidth":0,"animated":false,"favorite":false,"in_gallery":false,"in_most_viral":false,"has_sound":false,"is_ad":false,"nsfw":null,"link":"https://i.imgur.com/nsLltwo.png","tags":[],"datetime":1728939379,"mp4":"","hls":""}}
```

or piped through `jq` to prettify it:

```json
{
  "data": {
    "account_id": null,
    "account_url": null,
    "ad_type": null,
    "ad_url": null,
    "animated": false,
    "bandwidth": 0,
    "datetime": 1728939379,
    "deletehash": "UuID9Xe3MsmeUni",
    "description": null,
    "favorite": false,
    "has_sound": false,
    "height": 720,
    "hls": "",
    "id": "nsLltwo",
    "in_gallery": false,
    "in_most_viral": false,
    "is_ad": false,
    "link": "https://i.imgur.com/nsLltwo.png",
    "mp4": "",
    "name": "",
    "nsfw": null,
    "section": null,
    "size": 37103,
    "tags": [],
    "title": null,
    "type": "image/png",
    "views": 0,
    "vote": null,
    "width": 1280
  },
  "status": 200,
  "success": true
}
```

But is heavily throttled, 2-3 requests results in this:

```json
{"errors":[{"id":"legacy-api-78f9c8f745-s5j42/S6uT0TTUDU-25139224","code":"429","status":"Too Many Requests","detail":"Too Many Requests"}]}
```

<!--
From [DevOps-Bash-tools](devops-bash-tools.md):

```shell
imgur_api.sh --help
```

```shell
imgur_upload.sh --help
```

```shell
imgur_upload.sh "$image"
```

-->

### PostImage

<https://postimages.org/>

- Anonymous
- UI only
- Does not allow Hotlinking

### Vgy.me

<https://vgy.me/>

- No longer anonymous
- Images only
- Supported format: `jpg`, `jpeg`, `png`, `gif`
- Temporary - deleted after 6 months if not view, 1 year if not view for an account
- Hotlinking policy unknown
- 20MB per image
- no videos

```shell
curl -F "file=@$image" https://vgy.me/upload
```

Looks like anonymous uploads are no longer allowed in either the UI or `curl`:

```json
{"error":true,"messages":{"Unauthorized":"Anonymous uploads are not allowed."}}
```

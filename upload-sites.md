# File Upload & Code Pastebin sites

Shortlist of the best sites to upload files, images, or paste code snippets to share with others for debugging.

More useful than huge lists since you only need a few of the best sites to work with.

Double check the Terms & Conditions around [Hotlinking](https://simple.wikipedia.org/wiki/Hotlinking)
before you link from another site so you don't get blocked!

Also check the sites rights to your keep and redistribute your content permanently!

<!-- INDEX_START -->

- [Code Pasting Sites](#code-pasting-sites)
  - [dpaste](#dpaste)
  - [Pastebin](#pastebin)
  - [Termbin](#termbin)
  - [Pasty](#pasty)
  - [Hastebin](#hastebin)
  - [Paste.ee](#pasteee)
  - [Highlight.js](#highlightjs)
  - [GitHub Gists](#github-gists)
- [File Upload Sites](#file-upload-sites)
  - [0x0.st](#0x0st)
  - [Catbox](#catbox)
  - [Litterbox](#litterbox)
  - [Uguu](#uguu)
  - [File.io](#fileio)
- [Image Upload Sites](#image-upload-sites)
  - [0x0.st Again](#0x0st-again)
  - [Imgur](#imgur)
  - [PostImage](#postimage)
  - [Vgy.me](#vgyme)

<!-- INDEX_END -->

## Code Pasting Sites

### dpaste

<https://dpaste.org/>

- Simplest
- Fast
- Syntax highlighting
- Expiration option

[dpaste.sh](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/bin/dpaste.sh)
is the shortest easiest command, auto-adds syntax highlighting,
and prompts to approve text / code before uploading for safety.

```shell
curl -X POST https://dpaste.org/api/ -d "content=$text"
```

```text
"https://dpaste.org/caVZ2"
```

### Pastebin

<https://pastebin.com/>

The original code pasting site.

- Expiration option
- Web UI ok
- CLI poor experience
  - requires API key authentication and too many fields
  - use dpaste or Termbin for CLI easier pasting instead

[pastebin.sh](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/bin/pastebin.sh)
is a shorter easier command which auto-adds syntax highlighting,
and prompts to approve text / code before uploading for safety.

Manually:

```shell
curl -X POST https://pastebin.com/api/api_post \
  -d "api_dev_key=$API_KEY" \
  -d "api_user_name=$USERNAME" \
  -d "api_user_password=$PASSWORD" \
  -d "api_option=paste" \
  -d "api_paste_code=$text" \
  -d "api_paste_name=$title" \
  -d "api_paste_private=0" \
  -d "api_paste_expire_date=N"
```

### Termbin

<http://termbin.com/>

- Terminal-based pastebin
- Allows piping content directly from the command line to create pastes
- Plaintext TCP port `9999` will probably be blocked by your corporate firewall

[termbin.sh](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/bin/termbin.sh)
is a shorter command, finds and uses whatever netcat is available or installs netcat if necessary.
Prompts to approve text / code before uploading for safety.

Manually:

```shell
echo "$text" | nc termbin.com 9999
```

```text
https://termbin.com/b2h7
```

### Pasty

<https://pasty.lus.pm/>

- Minimalist UI
- Doesn't look like CLI works any more
- self-hosted pastebin alternative for text and code snippets
  - easy to set up and use

```shell
curl -X POST https://pasty.lus.pm/api/pastes -d "$text"
```

```text
Method Not Allowed
```

### Hastebin

<https://hastebin.com/>

- Simple Minimalist Web UI

```shell
curl -X POST https://hastebin.com/documents -d "$text"
```

Requires access token:

```json
{"message":"Unauthorized request: missing access token. To generate a token, go to https://toptal.com/developers/hastebin/documentation and follow the instructions."}
```

### Paste.ee

<https://paste.ee/>

- Expiration option
- Syntax highlighting
- Password protection for private pastes

```shell
curl -X POST https://paste.ee/api -F 'key=your_api_key' -F 'paste=$text'
```

Requires API key:

```json
{"status":"error","errorcode":3,"error":"error_invalid_key"}
```

### Highlight.js

<https://highlightjs.org/demo>

Syntax highlighting site for 192 languages with automatic language detection.

Do not use it as a CDN, they will block it as you can see on this page when you try to click a link through to it from
Stack Overflow:

<https://highlightjs.org/not-a-cdn>

### GitHub Gists

<https://gist.github.com/>

- Easy to use in UI
- Harder to use on CLI compared to above anonymous `curl` uploads
- Code paste or files
- Private or Public
- Has revisions
- Easy to track in your [GitHub](github.md) account
- Best used via  [GitHub CLI](https://cli.github.com/)
  - can be installed with `install_github_cli.sh` in [DevOps-Bash-tools](devops-bash-tools.md)

GitHub CLI:

```shell
gh auth login
```

```shell
gh gist create "$file" --public --description "My Gist"
```

or from standard input:

```shell
echo "$text" | gh gist create - --public --description "My Gist"
```

Create a Gist with multiple files:

```shell
gh gist create "$file1" "$file2" --public --description "My Multi-File Gist"
```

Doing even a basic post via curl is very inconvenient compared to the other specialist pastebin sites above:

```shell
curl -X POST https://api.github.com/gists \
  -H "Authorization: token YOUR_GITHUB_TOKEN" \
  -d '{
  "description": "Description of your Gist",
  "public": true,
  "files": {
    "file1.txt": {
      "content": "$text"
    }
  }
}'
```

<!-- Hangs
### 0bin

<https://0bin.net/>

A minimalist, open-source pastebin service that encrypts pastes in the browser, ensuring privacy.

```shell
curl -X POST https://0bin.net/ -d "$text"
```

-->

<!--
### PrivateBin

<https://privatebin.info/>

Private and secure pastebin with end-to-end encryption and no storage of user IP addresses or metadata.

Spews HTML all over screen:

```text
curl -X POST https://privatebin.net/ -F 'text="$text"'
```

-->

<!-- dead

### Ghostbin

<https://ghostbin.com/>

Secure pastebin with encryption, syntax highlighting, and the ability to set expiration times for pastes.

```shell
curl -X POST https://ghostbin.com/paste -d "$text"
```

### Cl1p.net

<https://cl1p.net/>

A web clipboard service that allows you to paste text between devices or users via a custom URL.

```shell
curl -X POST https://cl1p.net/your_custom_url -d "$text"
```

Spews HTML all over screen.

### JustPaste.it

<https://justpaste.it/>

A free pastebin alternative with a focus on user-friendly interface, supporting text and image uploads.

```shell
curl -X POST https://justpaste.it/submit -d "text=$text"
```

Spews HTML all over screen.

-->

## File Upload Sites

### 0x0.st

<https://0x0.st/>

- Fast
- Simple
- up to 512MB
- Very basic as you can see from the ASCII page
- Retention is only 1 month to 1 year

[0x0.sh](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/bin/0x0.sh)
is the shortest command, prompts to approve text / code before uploading for safety.

Manually:

```shell
curl -F "file=@$image" https://0x0.st
```

Output is simply the file URL:

```text
https://0x0.st/X6d2.png
```

### Catbox

<https://catbox.moe/>

- Slow
- **Permanent Retention!! Be Careful**
- All uploads are Anonymous
- Up to 200MB
- Does not allow [Hotlinking](https://simple.wikipedia.org/wiki/Hotlinking)
- [blocked in several countries](https://catbox.moe/faq.php) like the UK, Australia etc.
- [Tools Doc](https://catbox.moe/tools.php) for how to use it

[catbox.sh](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/bin/catbox.sh)
is the shortest command, prompts to approve text / code before uploading for safety.

Manually:

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

- Slow
- Temporary - 1-72 hour expiry
- Up to 1GB

Litterbox with 1 day retention - [doc](https://litterbox.catbox.moe/tools.php)

[litterbox.sh](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/bin/litterbox.sh)
is a shorter command, prompts to approve text / code before uploading for safety.

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

API Documentation: <https://www.file.io/developers>

Doesn't render images but gives a Download box button.

```shell
curl -F "file=@$image" https://file.io
```

[file.io.sh](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/bin/file.io.sh)
is a shorter command, prompts to approve text / code before uploading for safety.

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

### 0x0.st Again

Simplest to use again - see above [0x0.st](#0x0st)

### Imgur

<https://imgur.com>

Popular image hosting site.

- UI insists on disabling Ad-blocker
- Anonymous uploads
- Direct links
- Robust well documented API

[imgur.sh](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/bin/imgur.sh)
is the shortest command to upload.

Manually posting to Imgur is as simple as:

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

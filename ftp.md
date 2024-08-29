# FTP

An old protocol for file transfers.

You shouldn't use this normally, except some companies may use it for anonymous uploads for vendor support cases,
eg. [Informatica](informatica.md).

<!-- INDEX_START -->

- [FTP Clients](#ftp-clients)
  - [GUI](#gui)
  - [Command Line](#command-line)
- [FTP Servers](#ftp-servers)
- [FTP Client Commands](#ftp-client-commands)

<!-- INDEX_END -->

## FTP Clients

### GUI

- [Filezilla](https://filezilla-project.org/)
- [CyberDuck](https://cyberduck.io/)

### Command Line

The `ftp` command is provided by several packages

- GNU [inetutils](https://www.gnu.org/software/inetutils/)
  - on [Mac](mac.md) `brew install inetutils`
- [lftp](https://lftp.yar.ru/) - more sophisticated - bookmarking, tab completion
  can transfer several files in parallel
  - on [Mac](mac.md) `brew install lftp`
- [ncftp](https://www.ncftp.com/ncftp/) -  - more sophisticated - bookmarking, tab completion
  can transfer several files in parallel
  - on [Mac](mac.md) `brew install inetutils`
- curl - `curl -u user:password ftp://ftp.example.com/file.txt -O`
  - built-in on Mac, usually the `curl` package on most Linux distributions

## FTP Servers

- [vsftpd](https://security.appspot.com/vsftpd.html)
- [proftpd](http://www.proftpd.org/)

## FTP Client Commands

Usually as simple as:

```shell
ftp <host.domain.com>
```

and then using a series of FTP commands to put or get files inside the FTP shell.

Many of these will be familiar to unix command line users.

| Command        | Description                                                                                                                                  |
|----------------|----------------------------------------------------------------------------------------------------------------------------------------------|
| `open`         | connect to an ftp server eg. `open <host.domain.com>`. Usually you don't need to do this if starting `ftp <host.domain.com>`                 |
| `login`        | login if not using anonymous FTP. Enter username and password when prompted                                                                  |
| `ls`           | list directory contents                                                                                                                      |
| `dir`          | list directory contents with more details like file sizes                                                                                    |
| `mkdir`        | Creates a directory on the remote server eg. `mkdir my_new_directory`                                                                        |
| `cd`           | change to a directory                                                                                                                        |
| `lcd`          | change to a local directory on your machine                                                                                                  |
| `get`          | download a file from the remote server to the local machine eg. `get filename.txt`                                                           |
| `mget`         | download multiple files from the remote server eg. `get *.txt`                                                                               |
| `put`          | upload a file from the local machine to the remote server eg. `put filename.txt`                                                             |
| `mput`         | upload multiple files to the remote server eg. `put *.txt`                                                                                   |
| `delete`       | deletes a file on the remote server eg. `delete filename.txt`                                                                                |
| `rmdir`        | delete a directory on the remote server eg. `rmdir my_new_directory`                                                                         |
| `pwd`          | display the current directory on the remote server                                                                                           |
| `lpwd`         | display the current local directory on your machine                                                                                          |
| `ascii`        | switch the transfer mode to ASCII (useful for text files)                                                                                    |
| `binary`       | switch the transfer mode to binary (useful for non-text files like images, videos or `.tar.gz` tarballs)                                     |
| `quit` / `bye` | logs out and end the FTP session                                                                                                             |
| `prompt`       | toggles interactive mode on/off, which asks for confirmation before performing multiple operations (like `mget` and `mput`)                  |
| `rename`       | rename a file on the remote FTP server eg. `rename oldname.txt newname.txt`                                                                  |
| `chmod`        | change the permissions of a file on the remote server (if supported) eg. `chmod 755 script.sh`                                               |
| `status`       | shows the current status of your FTP session                                                                                                 |
| `hash`         | toggle hash-mark printing (#) for file transfers to show progress                                                                            |
| `!`            | executes a command on the local machine without leaving the FTP session eg. `! ls` to list local directory files to see filenames to transfer |
| `quote`        | send an arbitrary command to the remote FTP server eg. `quote SITE CHMOD 755 filename.txt`                                                   |
| `passive`      | toggle passive mode on/off to work around network issues connecting                                                                          |

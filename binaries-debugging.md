# Binaries Debugging

Tools for examining and working with compiled binaries.

<!-- INDEX_START -->

- [File](#file)
- [Dynamic Linking](#dynamic-linking)
  - [LIBRARY_PATH](#library_path)
  - [LD_LIBRARY_PATH](#ld_library_path)
    - [Usages](#usages)
    - [Pitfalls](#pitfalls)
- [Examine dynamic library dependencies](#examine-dynamic-library-dependencies)
  - [Linux](#linux)
    - [LDD](#ldd)
    - [PLDD](#pldd)
    - [Readelf](#readelf)
  - [Mac](#mac)
    - [Otool](#otool)
  - [Portable](#portable)
    - [Objdump](#objdump)
- [Strings](#strings)
- [System Call Tracing](#system-call-tracing)
  - [Strace](#strace)
  - [Mac](mac-system-call-tracing)
    - [Dtruss](#dtruss)
    - [fs_usage](#fs_usage)
    - [Instruments](#instruments)

<!-- INDEX_END -->

## File

See if it's statically compiled or dynamically linked:

```shell
file "$binary"
```

eg.

```shell
$ file opt/vertica/bin/vsql
opt/vertica/bin/vsql: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, for GNU/Linux 3.2.0, BuildID[xxHash]=69f8be01a192ea83, not stripped
```

## Dynamic Linking

If the above `file` output shows `dynamically linked`,
then it requires external shared libraries and can be influenced on where to find them during compilation or runtime by
these environment variables.

Both environment variables are in the same format of colon separated directories like the standard `$PATH` environment
variable.

These add to the list of library directory locations searched _before_ the standard library locations such as `/lib`,
`/usr/lib` and `/usr/local/lib`.

### LIBRARY_PATH

Used by the GCC compiler during linking.

This is probably not the LD PATH you are looking for as a user / systems administrator.

The GNU linker, `ld`, uses these directories before the standard lib directories.

If you've set this to link a compiled binary against a library in a non-standard location, you'll probably also need
to specify `LD_LIBRARY_PATH` at runtime to make the binary work.

### LD_LIBRARY_PATH

Used at runtime.

This is usually the one you usually want as a user / systems administrator.

 The dynamic linker `ld.so` (which starts all applications) searches these directories in addition to the standard lib
 directories for the dynamic shared library dependencies an application was linked against.

#### Usages

- testing new versions of a shared library against an already compiled application
- re-locating shared libraries, eg. to preserve old versions
- creating a self-contained, relocatable environment for larger applications, such that they do not depend on system
  libraries – many software vendors use this approach.

#### Pitfalls

- **Security** - since `LD_LIBRARY_PATH` is searched *before* the standard library locations, it could load the wrong
  libraries or worse libraries with malicious code
  - setuid/setgid executables ignore this variable for this reason
- **Performance**:
  - the link loader has to search all the directories in `LD_LIBRARY_PATH` as well as the standard library
    locations, until it finds the first matching shared library
  - tt has to do this for ALL shared libraries the application is linked against!
  - this means a lot of system calls to `open()`, that will fail with `ENOENT (No such file or directory)` which you can
    see in an `strace`
  - if the `LD_LIBRARY_PATH` contains many directories, the number of failed calls will increase linearly,
    and this will slow down the start-up time of the application
  - if any of the directories are on network mounts like in an NFS share, this can hugely slow down the start-up time of
    your applications and potentially slow down the whole system
- **Inconsistency**:
  - `LD_LIBRARY_PATH` can force an application to load the wrong version of a shared library leading to unpredictable
    results.
    The app could crash, or worse, return the wrong results which is hard to debug and understand

**DO NOT SET `LD_LIBRARY_PATH` IN THE USER, OR WORSE, GLOBAL SYSTEM ENVIRONMENT**

## Examine dynamic library dependencies

To see what libraries a binary expects in its `$LD_LIBRARY_PATH`.

### Linux

#### LDD

Shows what libraries the binary is linked against:

```shell
ldd "$binary"
```

#### PLDD

Show what runtime libraries the binary is using:

```shell
pldd "$binary"
```

Since this often fails to attach to a process:

```none
pldd: cannot attach to process 32781: Operation not permitted
```

You can get either a Bash or Golang version of this program which parses `/proc` to do this on Linux from my
[DevOps Bash tools](devops-bash-tools.md) or [DevOps Goland tools](devops-golang-tools.md) repos.

```shell
pldd.sh "$binary"
```

You can run the Golang version without even compiling it due to shebang magic in my programs:

```shell
pldd.go "$pid"
```

#### Readelf

More detailed tool, you'll need to grep:

```shell
readelf -d "$binary"
```

### Mac

#### Otool

Nice and concise, one line per library:

```shell
otool -L "$binary"
```

### Portable

#### Objdump

Works on both Linux and Mac.

```shell
objdump -p "$binary"
```

## Strings

Dump all strings from inside the binary to get clues about its internals:

```shell
strings "$binary"
```

## System Call Tracing

### Strace

See all the system calls an application is making as it runs.

```shell
strace "$command"
```

To trace just filesystem calls:

```shell
strace -e trace=file "$command"
```

Primarily used on Linux but can be installed and used on Mac, although may not be as efficient as Mac's native `dtruss`:

```shell
brew install strace
```

<h3 id="mac-system-call-tracing">Mac</h3>

#### Dtruss

Requires `sudo` for best results.

Not as good or reliable as Linux's `strace` but if you have a better alternative let me know.

```shell
sudo dtruss -f "$command"
```

The `-f` switch is to follow child processes.

#### fs_usage

Trace just filesystem calls instead of all system calls like `dtruss`

```shell
sudo fs_usage "$command"
```

#### Instruments

```shell
open /Applications/Xcode.app/Contents/Applications/Instruments.app
```

# Binary

Tools for examining and working with compiled binaries.

<!-- INDEX_START -->

- [File](#file)
- [Dynamic Linking](#dynamic-linking)
- [Examine dynamic library dependencies](#examine-dynamic-library-dependencies)
  - [Linux](#linux)
    - [LDD](#ldd)
    - [Readelf](#readelf)
  - [Mac](#mac)
    - [Otool](#otool)
  - [Portable](#portable)
    - [Objdump](#objdump)
- [Strings](#strings)

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
then it requires external shared libraries and can be influenced on where to find them at the post-compile linking phase
or runtime by these environment variables.

Both environment variables are in the same format of colon separated directories like the standard `$PATH` environmen
variable.

These add to the standard list of library locations used such as `/usr/lib` and `/usr/local/lib`

- `LD_LIBRARY_PATH` - used at runtime
  - this is usually the one you usually want as a user / systems administrator
  - the dynamic linker `ld.so` uses these directories in addition to the standard lib directories
- `LIBRARY_PATH` - used by the GCC compiler during linking after compiling sources
  - you probably don't want to mess with this as a user / systems administrator
  - the GNU linker, `ld`, uses these directories in addition to the standard lib directories

## Examine dynamic library dependencies

To see what libraries a binary expects in its `$LD_LIBRARY_PATH`.

### Linux

#### LDD

The classic linux command:

```shell
ldd "$string"
```

#### Readelf

More detailed tool, you'll need to grep:

```shell
readelf -d "$binary" | grep NEEDED
```

### Mac

#### Otool

```shell
otool -L "$binary"
```

### Portable

#### Objdump

Works on both Linux and Mac.

```shell
objdump -p "$binary" | grep NEEDED
```

## Strings

Dump all strings from inside the binary to get clues about its internals:

```shell
strings "$binary"
```

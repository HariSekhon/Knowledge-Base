# Binary

Tools for examining and working with compiled binaries.

<!-- INDEX_START -->

- [File](#file)
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

## Examine dynamic library dependencies

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

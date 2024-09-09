# Binary

<!-- INDEX_START -->

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

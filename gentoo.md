# Gentoo

Compiles packages from source using Portage package manager.

If you tune the compilation settings and have the patience to wait for it, this creates the most elite systems,
ultra customized and noticeably snappier.

Downside is that you spend your life compiling software.
When you go to [Debian](debian.md) it's shocking how quick it is to install packages and get on with your life...

Fetch the package list from mirrors via rsync:

```shell
#emaint -a sync
emerge --sync
```

Sync via http tarball download (faster for first time sync, use with docker):

```shell
emerge-webrsync
```

Search packages:

```shell
emerge -s "$term"
```

There is now a `net-analyzer/nagios-check_glsa2` package.

I ran elite desktops, laptops, and server fleet on Gentoo in the 2000s for 5 years

My boss was highly technical good quality high class guy who was pro this because we had CPU-bound processing servers
so this made them go faster, and so I rebuilt and standardized the entire server fleet on Gentoo.

I'd  really love to build elite personal desktops and laptops again - the height of nerdiness :)

Alas, Macs are just quicker to get on with the day job...

**Ported from various private Knowledge Base pages 2002+**

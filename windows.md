# Windows

## Commands

### List Volumes

```shell
fsutil volume list | findstr :
```

### Get Free Disk Space on All Volumes

```shell
powershell "Get-PSDrive -PSProvider FileSystem | Select-Object Name, @{Name='FreeSpace(GB)';Expression={($_.Free/1GB).ToString('F2')}}, @{Name='UsedSpace(GB)';Expression={((($_.Used)/1GB).ToString('F2'))}}, @{Name='TotalSize(GB)';Expression={($_.Used+$_.Free/1GB).ToString('F2')}}"
```

### Disk Check Analysis

```shell
chkdsk c:
```

output:

```
Windows has scanned the file system and found no problems.
No further action is required.

  51796991 KB total disk space.
  30478208 KB in 771533 files.
    438244 KB in 283686 indexes.
         0 KB in bad sectors.
   1194783 KB in use by the system.
     55232 KB occupied by the log file.
  19685756 KB available on disk.

      4096 bytes in each allocation unit.
  12949247 total allocation units on disk.
   4921439 allocation units available on disk.
```

### Find the location of a binary in the %PATH%

```shell
where bash
```

output:

```
C:\Program Files\Git\bin\bash.exe
```

### List Disk Space

```shell
fsutil volume diskfree c:
```

### File Permissions

Set owner of file administrator:

```shell
icacls "D:\test\test.txt" /setowner "administrator"
```

Recursively change `/app` directory and its contents be readable by all users

```shell
icacls "D:\test\test.txt" /grant "users:(R)" /t
```

Grant full control permission to administrator:

```shell
icacls "D:\test\test.txt" /grant "administrator:(F)"
```

Grant read and execute to all users:

```shell
icacls "D:\test\test.txt" /grant "users:(RX)"
```

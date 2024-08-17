# Windows

<!-- INDEX_START -->
- [Remote Desktop](#remote-desktop)
- [Screenshots](#screenshots)
- [Start At Login](#start-at-login)
- [MMCs](#mmcs)
- [Commands](#commands)
  - [Networking](#networking)
  - [List Volumes](#list-volumes)
  - [Get Free Disk Space on All Volumes](#get-free-disk-space-on-all-volumes)
  - [Disk Check Analysis](#disk-check-analysis)
  - [Find the location of a binary in the %PATH%](#find-the-location-of-a-binary-in-the-path)
  - [List Disk Space](#list-disk-space)
  - [File Permissions](#file-permissions)
<!-- INDEX_END -->

## Remote Desktop

You can find your corporate workspace by downloading
[Remote Desktop app](https://apps.apple.com/us/app/microsoft-remote-desktop/id1295203466)
from the Apple Store and then Add Workspace and entering this URL:

https://rdweb.wvd.microsoft.com/api/arm/feeddiscovery

You'll be prompted for your Microsoft login, enter your company corporate email and password, and your RDP session will
be seen as an icon to click through to.

This icon will remain under Workspaces, not PCs when you are starting RDP again to connect.

This conveniently also reconnects if you leave the app running and move locations / wifi as a digital nomad or even just
going home.

On Mac use the `Cmd` key as the Windows key.

## Screenshots

Screenshots can be tricky when using WVD above from a Mac
as the Print Screen key isn't available on Mac and shortcuts like `Windows`-`Shift`-`S`
don't work.

Pull up the Snipping Tool from the task search and use that to take a screenshot of a given area.

On Mac hit the `Cmd` key which is equivalent of the Windows key inside the WVD session to bring up the task bar search
and then type`snip` and enter.

Once the Snipping Tool is up, click New and then drag a selection window and save it as a screenshot file to share.

## Start At Login

To have any program start at login, such as Teams or Outlook to save you clicks
(especially if you're starting new WVD sessions every day or every 4 hours):

`Start` -> `Run`:

This opens the Startup folder for your user account:

```cmd
shell:startup
```

Then just drag a shortcut of the app into that folder:

eg. `Start` and drag the icon of the app over that Startup folder to create the shortcut.

Test by logging out and back in.

## MMCs

Microsoft Management Consoles are UI utilities to administer the system.

You can launch them from `Start` -> `Run` menu and typing their name which ends in `.msc`:

| Command          | Name                                 | Description                                                                  |
|------------------|--------------------------------------|------------------------------------------------------------------------------|
| `compmgmt.msc`   | Computer Management                  | Comprehensive console with tools like Disk Management, Task Scheduler ...    |
| `diskmgmt.msc`   | Disk Management                      | Manages disk drives and partitions                                           |
| `taskschd.msc`   | Task Scheduler                       | Automates task execution based on specific conditions                        |
| `services.msc`   | Services                             | Displays and manages all services installed on the system                    |
| `devmgmt.msc`    | Device Manager                       | Interface to view and manage hardware devices installed on the computer      |
| `dsa.msc`        | Active Directory Users and Computers | Manages users, computers, and objects in a domain                            |
| `lusrmgr.msc`    | Local Users and Groups               | Manages local user accounts and groups                                       |
| `gpedit.msc`     | Group Policy Management              | Centralized management environment for configuring Group Policy settings     |
| `perfmon.msc`    | Performance Monitor                  | Monitors system performance, displaying real-time data about system usage    |
| `eventvwr.msc`   | Event Viewer                         | Allows viewing and managing system, application, and security event logs     |

## Commands

Show the current time:

```cmd
time /t
```
(without the `/t` switch it prompts to set a new time)

### Networking

See [Networking](networking.md) doc.

### List Volumes

```cmd
fsutil volume list | findstr :
```

### Get Free Disk Space on All Volumes

```cmd
powershell "Get-PSDrive -PSProvider FileSystem | Select-Object Name, @{Name='FreeSpace(GB)';Expression={($_.Free/1GB).ToString('F2')}}, @{Name='UsedSpace(GB)';Expression={((($_.Used)/1GB).ToString('F2'))}}, @{Name='TotalSize(GB)';Expression={($_.Used+$_.Free/1GB).ToString('F2')}}"
```

### Disk Check Analysis

```cmd
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

```cmd
where bash
```

output:

```
C:\Program Files\Git\bin\bash.exe
```

### List Disk Space

```cmd
fsutil volume diskfree c:
```

### File Permissions

Set owner of file administrator:

```cmd
icacls "D:\test\test.txt" /setowner "administrator"
```

Recursively change `/app` directory and its contents be readable by all users

```cmd
icacls "D:\test\test.txt" /grant "users:(R)" /t
```

Grant full control permission to administrator:

```cmd
icacls "D:\test\test.txt" /grant "administrator:(F)"
```

Grant read and execute to all users:

```cmd
icacls "D:\test\test.txt" /grant "users:(RX)"
```

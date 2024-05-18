# Windows

### File Permissions

Set owner of file adminstrator:

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

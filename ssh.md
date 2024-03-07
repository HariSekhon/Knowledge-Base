# SSH

### X Forwarding

```shell
ssh -X hari@"$HOST"
```

```shell
sudo su
cp .Xauthority /root
virt-manager
```

### Legacy SSH Servers

If you see an error like this when trying to SSH to an older system running an older version of SSH:

```
Unable to negotiate with 192.168.1.46 port 22: no matching host key type found. Their offer: ssh-rsa,ssh-dss
```

add the `-oHostKeyAlgorithms=+ssh-rsa` option to the SSH command line to accept the older algo:

```shell
ssh -oHostKeyAlgorithms=+ssh-rsa ...
```

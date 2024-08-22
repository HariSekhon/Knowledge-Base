# SSH

<!-- INDEX_START -->

- [SSH using only publickey](#ssh-using-only-publickey)
- [Use SSH Agent](#use-ssh-agent)
- [SSH Config](#ssh-config)
- [X Forwarding](#x-forwarding)
- [Legacy SSH Servers](#legacy-ssh-servers)

<!-- INDEX_END -->

## SSH using only publickey

```shell
ssh -o PreferredAuthentications=publickey ...
```

## Use SSH Agent

Start ssh-agent and save the output to a file to import into other shells:

```shell
ssh-agent | tee ~/.ssh-agent.env
```

In each shell:

```shell
. ~/.ssh-agent.env
```

Add your SSH key to the agent:

```shell
ssh-add ~/.ssh/id_rsa
```

List loaded keys:

```shell
ssh-add -l
```

## SSH Config

Make it fast and easy
to connect to SSH servers which have long names or only IP addresses without having to remember them:

```sshconfig
cat >> ~/.ssh/config <<EOF
Host myhost
  TCPKeepAlive yes
  ServerAliveInterval 300
  HostName x.x.x.x
  IdentityFile ~/.ssh/id_rsa
  User hari
EOF
```

or to specify `User ec2-user` and the key pair generated at EC2 VM creation time, to use different user accounts and
keys for different servers:

```sshconfig
cat >> ~/.ssh/config <<EOF
Host myhost
  TCPKeepAlive yes
  ServerAliveInterval 300
  HostName x.x.x.x
  IdentityFile ~/.ssh/ec2-user.pem
  User ec2-user
EOF
```

## X Forwarding

```shell
ssh -X hari@"$HOST"
```

```shell
sudo su
cp .Xauthority /root
virt-manager
```

## Legacy SSH Servers

If you see an error like this when trying to SSH to an older system running an older version of SSH:

```none
Unable to negotiate with 192.168.1.46 port 22: no matching host key type found. Their offer: ssh-rsa,ssh-dss
```

add the `-oHostKeyAlgorithms=+ssh-rsa` option to the SSH command line to accept the older algo:

```shell
ssh -o HostKeyAlgorithms=+ssh-rsa,ssh-dss ...
```

If you're using an SSH key you'll get prompted for a password when your SSH key fails to authenticate because you need
this switch `-o PubkeyAcceptedAlgorithms=+ssh-rsa,ssh-dss`:

```shell
ssh -o HostKeyAlgorithms=+ssh-rsa,ssh-dss -o PubkeyAcceptedAlgorithms=+ssh-rsa,ssh-dss ...
```

If using `rsync` over ssh then use the -e switch to pass this option to `ssh`:

```shell
rsync -av -e 'ssh -oHostKeyAlgorithms=+ssh-rsa,ssh-dss -oPubkeyAcceptedAlgorithms=+ssh-rsa,ssh-dss' ...
```

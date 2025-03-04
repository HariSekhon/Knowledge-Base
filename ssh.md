# SSH

<!-- INDEX_START -->

- [Generate an SSH Key](#generate-an-ssh-key)
- [SSH Public Key and Authorized Keys](#ssh-public-key-and-authorized-keys)
- [SSH Login using only SSH Key](#ssh-login-using-only-ssh-key)
- [Use SSH Agent](#use-ssh-agent)
- [SSH Config](#ssh-config)
- [X Forwarding](#x-forwarding)
- [Legacy SSH Servers](#legacy-ssh-servers)

<!-- INDEX_END -->

## Generate an SSH Key

The comment makes your public key distinguishable
when it's copied to `~/.ssh/authorized_keys` on servers or Cloud systems.

```shell
ssh-keygen -f ~/.ssh/"$filename" -t rsa -b 4096 -C "$comment"
```

It'll prompt you for a passphrase to protect the private key with.
If you add a passphease, use SSH Agent as documented further down.

## SSH Public Key and Authorized Keys

Copy the `.pub` public key file contents generated from the command above in `~/.ssh/"$filename.pub"` to
`~/ssh/authorized_keys` to any server you want to SSH to without a password.

## SSH Login using only SSH Key

To enforce logging in using only the public key and error out otherwise rather than fall back to a password prompt.

```shell
ssh -o PreferredAuthentications=publickey ...
```

Useful to stop automated scripts or [CI/CD](cicd.md) from getting stuck on a password prompt.
It's better to error out immediately for faster debugging and also not wasting chargeable [CI/CD](cicd.md)
build minutes.

## Use SSH Agent

Password protect your SSH key on disk and then load it into SSH Agent once at startup.

Start ssh-agent and save the output to a file to import into other shells:

```shell
ssh-agent | tee ~/.ssh-agent.env
```

In each shell:

```shell
. ~/.ssh-agent.env
```

Add your SSH key to the agent (will prompt you this one time for passphrase if the private key is protected):

```shell
ssh-add ~/.ssh/id_rsa
```

List loaded keys:

```shell
ssh-add -l
```

## SSH Config

Make it fast and easy
to connect to SSH servers which have long names or only IP addresses without having to remember them,
by adding a block to your `~/.ssh/config`:

```sshconfig
Host myhost
  TCPKeepAlive yes
  ServerAliveInterval 300
  HostName x.x.x.x
  IdentityFile ~/.ssh/id_rsa
  User hari
```

You can now `ssh myhost` without DNS, it'll replace the hostname with `HostName` field's value,
in this case the IP `x.x.x.x`.

For AWS EC2 VMs, specify `User ec2-user` and the key pair generated at creation time.

To use different user accounts and keys for different servers:

```sshconfig
Host myhost
  TCPKeepAlive yes
  ServerAliveInterval 300
  HostName x.x.x.x
  IdentityFile ~/.ssh/ec2-user.pem
  User ec2-user
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

```text
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

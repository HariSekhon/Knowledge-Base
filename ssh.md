# SSH

### Only SSH to a Remote host using your SSH key

```shell
ssh -o PreferredAuthentications=publickey ...
```

### Use SSH Agent

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

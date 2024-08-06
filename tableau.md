# Tableau

Tableau is a widely used visualization tool.

<https://www.tableau.com/>

### Tableau User Authentication

Can use LDAP integration.

Often this will use your short form username of first letter of first name followed by surname,
all lower case eg. for Hari Sekhon the username will be `hsekhon`.


| Admin UI Port |
|---------------|
| 8850          |

### SSH Config

Add this SSH config block to your `~/.ssh/config` to make SSH connections easier:

```sshconfig
cat >> ~/.ssh/config <<EOF
Host tableau
  TCPKeepAlive yes
  ServerAliveInterval 300
  HostName x.x.x.x
  IdentityFile ~/.ssh/tableau-ec2-user.pem
  User ec2-user
EOF
```

then you can use the shortened SSH form of just:

```shell
ssh tableau
```

### On the Tableau Server

```shell
sudo su - tableauadmin
```

```shell
tsm status
```

output should look like:

```
Status: RUNNING
```

Edit the `tableauadmin` user's crontab:

```shell
crontab -e
```

and put this in it to clean up disk space every midnight:

```crontab
0 0 * * * tsm maintenance cleanup -a
```

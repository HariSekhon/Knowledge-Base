# Tableau

Tableau is a widely used visualization tool.

<https://www.tableau.com/>

<!-- INDEX_START -->

- [Tableau User Authentication](#tableau-user-authentication)
- [SSH Config](#ssh-config)
- [Tableau Server Administration](#tableau-server-administration)
  - [TSM - Tableau Services Manager](#tsm---tableau-services-manager)
  - [Tabcmd](#tabcmd)
  - [Recover Server Admin with no remaining LDAP server admins](#recover-server-admin-with-no-remaining-ldap-server-admins)
- [Dashboards](#dashboards)
  - [Data Extract Refreshes](#data-extract-refreshes)
- [Troubleshooting](#troubleshooting)
  - [Disk Space](#disk-space)
    - [Logs](#logs)
  - [Unable to proceed because of an error from the data source / Unable to connect to the Tableau Data Extract Server ""](#unable-to-proceed-because-of-an-error-from-the-data-source--unable-to-connect-to-the-tableau-data-extract-server-)

<!-- INDEX_END -->

## Tableau User Authentication

Can use LDAP integration.

Often this will use your short form username of first letter of first name followed by surname,
all lower case eg. for Hari Sekhon the username will be `hsekhon`.

| Admin UI Port |
|---------------|
| 8850          |

## SSH Config

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

## Tableau Server Administration

```shell
sudo su - tableauadmin
```

```shell
tsm status
```

output should look like:

```text
Status: RUNNING
```

To see individual component statuses:

```shell
tsm status -v
```

List configuration keys:

```shell
tsm configuration list
```

Show each configuration value:

```shell
tsm configuration list |
while read -r key; do
  echo -n "$key:  ";
  tsm configuration get -k "$key";
done
```

Edit the `tableauadmin` user's crontab:

```shell
crontab -e
```

and put this in it to clean up disk space every midnight:

```crontab
0 0 * * * tsm maintenance cleanup -a
```

### TSM - Tableau Services Manager

TSM is designed primarily for managing and configuring the underlying Tableau Server instance itself,
for server administration tasks such as installation, configuration, maintenance, and upgrades.

Here you can configure server health email alerts or LDAP integration.

But you cannot use it to manage user permissions or roles within Tableau Server.

### Tabcmd

Login:

```shell
tabcmd login -s "https://$TABLEAU_SERVER" -u admin -p adminpassword
```

Grant my LDAP user the ServerAdmnistrator role:

```shell
tabcmd edituser --username hari --role ServerAdministrator
```

```shell
tabcmd logout
```

### Backup Tableau Server

[Backup & Restore Documentation](https://help.tableau.com/current/server/en-us/backup_restore.htm)

**The backup process can take a long time to run during which no other jobs can run, so backup out of business hours.**

Create a backup archive of the Tableau Server, optionally encrypted to protect the sensitive contents.

```shell
tsm maintenance backup -f "tableau-backup-$(date '+%F_%H%M%S').tsbak"  # --encrypt-password "$password"
```

This will create a local backup file in the following naming convention:

```text
tableau-backup-2024-11-13_143341.tsbak
```

Indicating it was done at `14:33:41` local time on the 13th Nov 2024.
We leave out the colons in the filename which can cause issues.

It saves the backup file to this default location:

```text
/var/opt/tableau/tableau_server/data/tabsvc/files/backups
```

Full output:

```text
Job id is '24', timeout is 1440 minutes.
7% - Starting the Active Repository instance, File Store, and Cluster Controller.
14% - Waiting for the Active Repository, File Store, and Cluster Controller to start.
Running - Installing backup services.
21% - Installing backup services.
28% - Estimating required disk space.
35% - Gathering disk space information from all nodes.
42% - Analyzing disk space information.
50% - Checking if sufficient disk space is available on all nodes.
57% - Backing up configuration.
64% - Backing up object storage data.
71% - Backing up database.
78% - Assembling the tsbak archive.
85% - Stopping the Active Repository if necessary.
92% - Waiting for the Active Repository to stop if necessary.
100% - Uninstalling backup services.
Backup written to '/var/opt/tableau/tableau_server/data/tabsvc/files/backups/tableau-backup-2024-11-13_143341.tsbak' on the controller node.
```

### Restore Tableau Server

```shell
tsm maintenance restore -f "tableau-backup-2024-11-13_143341.tsbak"  # --encrypt-password "$password"
```

### Recover Server Admin with no remaining LDAP server admins

[Backup the Tableau Server](#backup-tableau-server) first.

```shell
tsm authentication set-identity-store --type local
```

```shell
tsm pending-changes apply
```

```shell
password="$(pwgen -s 15)"
```

```shell
tsm user-identity create --username "admin" --password "$password"
```

Log in to Tableau Server using the newly created local admin account.

Use the Tableau Server web interface or `tabcmd` to promote an LDAP user to Server Administrator:

```shell
tabcmd login -s "https://$TABLEAU_SERVER" -u admin -p "$password"
```

```shell
tabcmd edituser --username hari --role ServerAdministrator
```

Switch back to LDAP authentication:

```shell
tsm authentication set-identity-store --type ldap
```

```shell
tsm pending-changes apply
```

May need to restart Tableau:

```shell
tsm restart
```

## Dashboards

### Data Extract Refreshes

You can schedule data extract refreshes on the Dashboard's `Extract Refreshes` tab.

## Troubleshooting

### Disk Space

#### Logs

Logs were taking up 134GB out of 200GB root disk space causing disk full errors even on `tsm maintenance cleanup -a`
and `du | sort` type commands.

`/tmp` was only a few KB but clearing that allowed the few KB for `du | sort` to work again:

```shell
sudo rm -fr /tmp/*
```

Found that this deeply embedded log path `/var/opt/tableau/tableau_server/data/tabsvc/logs` was taking up the space
with 5500 log files.

Cleared logs older than 7 days to free up space:

```shell
find /var/opt/tableau/tableau_server/data/tabsvc/logs -type f -mtime +7 -exec rm -f {} \;
```

and added this cron to prevent it recurring:

```shell
0 0 * * * find /var/opt/tableau/tableau_server/data/tabsvc/logs -type f -mtime +7 -exec rm -f {} \;
```

but Tableau was still gave this next error in the web UI: `Unable to proceed because of an error from the data
source` / `Unable to connect to the Tableau Data Extract Server ""` (which previously used to work).

### Unable to proceed because of an error from the data source / Unable to connect to the Tableau Data Extract Server ""

Web UI still giving this error (used to work before out of disk space issue):

```text
Unable to proceed because of an error from the data source

Try connecting again. If the problem persists, disconnect from the data source and contact the data source owner.

Try again

Could not find Hyper hosts to connect to.
Unable to connect to the Tableau Data Extract Server "". Check that the server is running and that you have access privileges to the requested database.
```

Tableau server still had error:

```shell
tsm status
```

```text
The server encountered an unexpected error processing the request. Look at the server logs for more information.

See '/home/tableauadmin/.tableau/tsm/tsm.log' for more information.
```

```shell
tsm restart
```

```text
Stopping service...

Service failed to stop properly.


See '/home/tableauadmin/.tableau/tsm/tsm.log' for more information.

500 - Server Error
```

Had to kill processes, but can't do this at `tableauadmin` since the processes are owned by `tableau` user switch to
it from `ec2-user`:

```shell
sudo su - tableau
```

Do not `kill -9`, just regular `kill` to allow graceful termination and avoid risking data loss:

```shell
ps -ef |
grep '/tableau/tableau_server/' |
grep -v 'pgsql' |
awk '{print $2}' |
xargs kill
```

```shell
tsm stop
```

```shell
tsm start
```

```text
Starting service...
Starting service...
The last successful run of StartServerJob took 11 minute(s).

Job id is '21', timeout is 30 minutes.
```

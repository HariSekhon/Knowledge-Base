# Google Drive

## Fix Non-Syncing / Location Change

Fix Google Drive on macOS not syncing or having switched to the wrong location
(`~/Library/CloudStorage/GoogleDrive-<account>/` - this was forced by an Apple change):

1. Quit Google Drive app

2. Check it's no longer running:

```shell
pgrep -f DriveFS
```

3. Move the database to force it to rebuild after restart:

```shell
mv "$HOME/Library/Application Support/Google/DriveFS" \
   "$HOME/Library/Application Support/Google/DriveFS.bak.$(date +%s)"
```

4. Re-open the Google Drive app:

```shell
open -a "Google Drive"
```

5. Sign in

6. Reconfigure `Preferences` -> set `Mirror Mode` and choose the location as `~/Google Drive`

7. Wait for it to reconcile

8. Verify new files were sync'd

# Mac

The best laptop money can buy:

https://www.apple.com/uk/macbook-pro/

If you don't have an M3 Pro / Max - you're missing out on an excellent (but overpriced) machine.

## Homebrew - Package Management

The best most widely used package manager for Mac in the world.

See [brew.md](brew.md) for how to use it and great package lists I've spent years discovering and building up.

## Service Management

Load and start a service from a `plist` file:

```shell
sudo launchctl load -F "/System/Library/LaunchDaemons/$name.plist"
sudo launchctl start "com.apple.$name"
```

Stop and unload a service:

```shell
sudo launchctl stop "com.apple.$name"
sudo launchctl unload "/System/Library/LaunchDaemons/$name.plist"
```

See [dhcp.md](dhcp.md) for a practical example of using this for the built-in tftp server for PXE boot installing Debian off your Mac.

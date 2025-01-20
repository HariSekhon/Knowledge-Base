# Networking

<!-- INDEX_START -->

- [CIDR visualizer](#cidr-visualizer)
- [VPNs](#vpns)
- [Browser Fingerprinting](#browser-fingerprinting)
- [I2P](#i2p)
- [Commands](#commands)
  - [Show routing table](#show-routing-table)
  - [DNS lookup](#dns-lookup)
  - [Add static route](#add-static-route)
  - [Show your public IP](#show-your-public-ip)
  - [Linux - show your local IP Tables software firewall rules](#linux---show-your-local-ip-tables-software-firewall-rules)
  - [Network Speed Test](#network-speed-test)
    - [Local Network Speed Test](#local-network-speed-test)
    - [Internet Network Speed Test](#internet-network-speed-test)
      - [Speedtest.net](#speedtestnet)
      - [Fast.com](#fastcom)
- [Diagrams](#diagrams)
  - [Network - Layer 2 - Local - ARP](#network---layer-2---local---arp)
  - [Network - Layer 3 - Remote - IP](#network---layer-3---remote---ip)
  - [Web Basics](#web-basics)
  - [Browser Flow](#browser-flow)
- [Meme](#meme)
  - [Which Server is Fastest](#which-server-is-fastest)

<!-- INDEX_END -->

## CIDR visualizer

Shows bits, netmask, first IP, last IP, number of IPs in range.

<http://cidr.xyz/>

Especially those of you who never learnt to do your IP network calculations for your CCNA upwards.

## VPNs

See [VPNs](vpn.md).

## Browser Fingerprinting

[fingerprint.com](https://fingerprint.com/) can still sort of identify you using a hash of common characteristics.
Click the link from Incognito/Private Browsing and on/off VPN to see

Documentation:

<https://dev.fingerprint.com/>

Open source library (TODO read this code):

<https://github.com/fingerprintjs/fingerprintjs>

## I2P

<https://geti2p.net/>

Invisible Internet Protocol.

Anonymous internet network layer to route traffic through.

## Commands

```shell
ping 4.2.2.1
```

### Show routing table

On Linux:

```shell
route -n
```

On Windows or Mac:

```shell
netstat -rn
```

### DNS lookup

Look up a well known public DNS address:

On Linux or Mac:

```shell
host google.com
```

On Windows:

```shell
nslookup google.com
```

### Add static route

[man route](https://linux.die.net/man/8/route)

```shell
route add ...
```

[man ip-route](https://man7.org/linux/man-pages/man8/ip-route.8.html)

```shell
ip route ...
```

### Show your public IP

...that you are NAT'd through as well as geolocation and other details:

```shell
curl ifconfig.co
```

### Linux - show your local IP Tables software firewall rules

```shell
iptables -nL -line-numbers
```

### Network Speed Test

#### Local Network Speed Test

Test your local network speed between two machines.

Start `iperf` server on one machine:

```shell
iperf -s
```

Run `iperf` client on another machine:

```shell
iperf -c "$ip"  # of above machine
```

#### Internet Network Speed Test

##### Speedtest.net

<https://www.speedtest.net/>

You can use it website or the CLI version below:

[:ctocat: sivel/speedtest-cli](https://github.com/sivel/speedtest-cli)

On Mac:

```shell
brew install speedtest
```

or generically

```shell
pip install speedtest-cli
```

If installed via [Homebrew](brew.md) on Mac:

```shell
speedtest
```

If installed via Pip:

```shell
speedtest-cli
```

Output at one of my favourite cafe's in [Vietnam](travel.md#vietnam):

```text
Retrieving speedtest.net configuration...
Testing from xTom (45.14.71.20)...
Retrieving speedtest.net server list...
Selecting best server based on ping...
Hosted by xTom (Osaka) [0.00 km]: 143.447 ms
Testing download speed................................................................................
Download: 21.80 Mbit/s
Testing upload speed......................................................................................................
```

Add the `--share` switch to generate a URL to an image

```shell
speedtest-cli --share
```

```text
Retrieving speedtest.net configuration...
Testing from xTom (45.14.71.20)...
Retrieving speedtest.net server list...
Selecting best server based on ping...
Hosted by Verizon (Tokyo) [395.51 km]: 126.545 ms
Testing download speed................................................................................
Download: 21.13 Mbit/s
Testing upload speed......................................................................................................
Upload: 10.67 Mbit/s
Share results: http://www.speedtest.net/result/17241162768.png
```

An alternative CLI for speedtest.net can be found at

[:octocat: sindresorhus/speed-test](https://github.com/sindresorhus/speed-test)

```shell
npm install --global speed-test
```

```shell
speed-test
```

##### Fast.com

<https://fast.com>

Internet speed test by Netflix

[:octocat: sindresorhus/fast-cli](https://github.com/sindresorhus/fast-cli)

```shell
npm install -g fast-cli
```

```shell
fast-cli
```

or if installed without the `-g` global switch:

```shell
~/node_modules/fast-cli/distribution/cli.js
```

Does download speed by default, use `--upload` switch for upload speed.

Optionally use `--json` switch to output in [JSON](json.md) format.

```shell
./node_modules/fast-cli/distribution/cli.js --upload --json
```

```text
{
        "downloadSpeed": 210,
        "uploadSpeed": 18,
        "downloaded": 300,
        "uploaded": 80,
        "latency": 74,
        "bufferBloat": 131,
        "userLocation": "Osaka, JP",
        "userIp": "45.14.71.20"
}
```

## Diagrams

From the [HariSekhon/Diagrams-as-Code](https://github.com/HariSekhon/Diagrams-as-Code) repo:

### Network - Layer 2 - Local - ARP

![Network Layer 2 - Local - ARP](https://github.com/HariSekhon/Diagrams-as-Code/raw/master/images/network_layer2_local.svg)

### Network - Layer 3 - Remote - IP

![Network - Layer 3 - Remote - IP](https://github.com/HariSekhon/Diagrams-as-Code/raw/master/images/network_layer3_remote.svg)

### Web Basics

![Web Basics](https://github.com/HariSekhon/Diagrams-as-Code/raw/master/images/web_basics.svg)

### Browser Flow

![Browser Flow](images/browser_workflow.gif)

## Meme

### Which Server is Fastest

![Which Server is Fastest](images/which_server_is_fastest_google_facebook_localhost.jpeg)

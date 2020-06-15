# pi-gen-baselite
Files to create a base raspbian headless server using pi-gen-utils

This repo is useful as a test for generating an image using the pi-gen-utils 
package and pi-gen. It is also useful as a starting point for creating your 
own headless server. It will work on any pi though, in general, servers that
are used in production should be pi3B+ or pi4 as the older pis can run in
to performance issues under real load.

The repo creates a Raspbian Lite image with some minor tweaks that make it a good basic headless server. The tweaks are:
 * user/password is server/server
 * SSH is enabled by default
 * If a file called netcfg.txt with dhcpcd.conf lines is placed in /boot/ those lines will be appended to dhcpcd.conf so that the pi boots with a static IP address/gateway/dns as specified in the file

## Dependencies

 * RPI pi-gen tool ( https://github.com/RPi-Distro/pi-gen )
 * my pi-gen-utils scripts (https://github.com/FrancisTurner/pi-gen-utils )

## Usage


```
cd /path/to/pi-gen/projects
git clone
git clone

sudo cp pi-gen-utils/*.sh /usr/local/bin
cd pi-gen-baselite
setuppigen.sh
cd ../pi-gen
build-docker.sh # or build.sh if you don't want to use docker
```
Pi-gen creates an image in pi-gen/deploy/ 
```
cp deploy/image*serverpi-lite* /some/where/useful/
cd -
restorepigen.sh
```
Burn pi image - using tool of choice e.g. Balena Etcher ( https://www.balena.io/etcher/ )

Edit samplenetcfg.txt and save to the boot partition on the newly flashed SD card as netcfg.txt.
Notes:
 * You may need to eject and reinsert the SD card for your OS to correcly
mount the newly created partition(s). 
 * If you are flashing from a windows machine, ignore suggestions to format the
new drive when you reinsert the SD card
 * Creating a netcfg.txt file is optional as without it the pi will query 
for a DHCP address, but it is strongly recommended because otherwise it
can be tricky to figure out how to connect 
to your server and the server address may change over time, which is usually
a bad thing. 

Optionally create a wifi profile wpa_supoplicant.conf in the boot partition 
following these instructions - https://www.raspberrypi-spy.co.uk/2017/04/manually-setting-up-pi-wifi-using-wpa_supplicant-conf/

eject the SD card, stick it in the pi, connect network cable and power the pi on

wait a minute or so for the pi to boot (check by pinging its IP address) then 
ssh to it as user server password server. Change the password and set up 
whatever you need on it (i.e. your preferred web server, email etc.)

```
$ ping 192.168.1.250
PING 192.168.1.250 (192.168.1.250) 56(84) bytes of data.
64 bytes from 192.168.1.250: icmp_seq=6 ttl=63 time=8.70 ms
64 bytes from 192.168.1.250: icmp_seq=7 ttl=63 time=5.11 ms
^C
$ ssh server@192.168.1.250
The authenticity of host '192.168.101.250 (192.168.101.250)' can't be established.
ECDSA key fingerprint is SHA256:E7QQpIhTTvh8WfaFaVUF2IYRP/bNyqSQM7eyU4t9Fcg.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '192.168.101.250' (ECDSA) to the list of known hosts.
server@192.168.101.250's password: 
Linux serverpi 4.19.118-v7+ #1311 SMP Mon Apr 27 14:21:24 BST 2020 armv7l

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
server@serverpi:~ $ passwd
...
```


# pi-gen-baselite
Files to create a base raspbian server using pi-gen-utils

This repo is useful as a test for generating an image using the pi-gen-utils package and pi-gen. It is also useful as
a starting point for creating your own 

It creates a Raspbian Lite image with some minor tweaks. The tweaks are:
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
cp deploy/image*serverpi* /some/where/useful/
cd -
restorepigen.sh
```

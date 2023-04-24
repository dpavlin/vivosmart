#!/bin/sh -xe

today=$( date +%Y-%m-%d )

lsusb | grep Garmin
#dmesg -T -w &
udevadm monitor -k
python3 ./send_command.py 
test -e sdb || mkdir sdb
mount /dev/sdb sdb/ -o ro
rsync -rav sdb/ out/
git -C out commit -m $today -a

#eject /dev/sdb

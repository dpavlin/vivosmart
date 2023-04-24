#!/bin/sh -xe

today=$( date +%Y-%m-%d )

# cleanup background processes /bin/sh (dash) compatible
trap "exit" INT TERM
trap "kill 0" EXIT


lsusb | grep Garmin
#test [ $( ps a | grep dmesg | wc -l ) -lt 2 ] || sudo dmesg -T -w &
udevadm monitor -k &
# add      /devices/pci0000:00/0000:00:14.0/usb1/1-1/1-1:1.0/host1/target1:0:0/1:0:0:0/block/sdb

dev=/dev/sdb

test -e $dev || sudo python3 ./send_command.py 

test -e sdb || mkdir sdb
sudo mount $dev sdb/ -o ro

test -d out || mkdir out && git -C out init

rsync -rav sdb/ out/
git -C out add '*'
git -C out commit -m $today -a

#eject /dev/sdb

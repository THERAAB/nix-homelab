#!/bin/sh
if [ $# -le 1 ] 
then
  echo $0: usage: $0 'type1 event1 typen eventn'
  exit 1
fi

len=$#
# Get device with `sudo libinput list-devices | grep -A1 "AT Translated Set 2 keyboard" | tail -n1 | sed 's/Kernel:\s*//'`
keydevice=/dev/input/event0
declare -a arr
for ((i=0; $# > 0; i++)) {
 arr[$i]=$1
 shift
}
for ((i=0;i < len; i+=2)) {
 evemu-event $keydevice --type ${arr[i]} --code ${arr[i+1]} --value 1 --sync
}
for ((i=len-2;i >= 0; i-=2)) { 
 evemu-event $keydevice --type ${arr[i]} --code ${arr[i+1]} --value 0 --sync
}

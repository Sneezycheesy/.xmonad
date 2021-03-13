#!/usr/bin/bash
if [[ $1 == sink ]]; then
	bluetooth_devices=`pactl list sinks | grep "Name: bluez_*"`;
elif [[ $1 == source ]]; then
	bluetooth_devices=`pactl list sources | grep "Name: bluez_input*"`;
fi
device=$(cut -d':' -f2 <<< ${bluetooth_devices});

#echo "${device}";

default_device=`pactl set-default-$1 ${device}`;

#!/usr/bin/bash
bluetooth_devices=`pactl list sinks | grep "Name: bluez_*"`;

device=$(cut -d':' -f2 <<< ${bluetooth_devices});

#echo "${device}";

default_device=`pactl set-default-sink ${device}`;

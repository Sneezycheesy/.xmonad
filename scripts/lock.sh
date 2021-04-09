#!/usr/bin/bash
playerctl -a pause;
if [ -e "/tmp/mpvsocket" ]; then
echo '{ "command": ["set_property", "pause", true] }' | socat - /tmp/mpvsocket;
fi
pactl set-source-mute @DEFAULT_SOURCE@ 1;
betterlockscreen -l;

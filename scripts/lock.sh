#!/usr/bin/bash
playerctl -a pause;
if [ -e "/tmp/mpvsocket" ]; then
echo '{ "command": ["set_property", "pause", true] }' | socat - /tmp/mpvsocket;
fi
betterlockscreen -l;

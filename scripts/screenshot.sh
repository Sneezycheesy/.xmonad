#!/usr/bin/bash
#kitty -e scrot;

if [[ $1 == select ]]; then
lxterminal -e scrot -sof "/tmp/screenshot.png" && cat /tmp/screenshot.png | xclip -selection clipboard -target image/png -i;

elif [[ $1 == full ]]; then
lxterminal -e scrot -o "/tmp/screenshot.png" && cat /tmp/screenshot.png | xclip -selection clipboard -target image/png -i;

elif [[ $1 == current ]]; then
lxterminal -e scrot -uo "/tmp/screenshot.png" && cat /tmp/screenshot.png | xclip -selection clipboard -target image/png -i;
fi
#kitty -e flameshot gui

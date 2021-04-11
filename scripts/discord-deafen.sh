#!/bin/bash
dir="${HOME}/.xmonad/scripts/discord-deafened";
while read value; do
	echo=$value;
done < $dir;

if [[ $echo -eq 1 ]]; then
	if [[ $1 != lock ]]; then
		echo 0 > $dir;
		xdotool key shift+control+alt+d;
	fi
else
	echo 1 > $dir;
	xdotool key shift+control+alt+d;
fi

echo $1;


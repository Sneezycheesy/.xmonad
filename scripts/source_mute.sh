#!/usr/bin/bash
if [[ $1 == get ]]; then
	while read muted; do
		if [[ $muted == 1 ]]; then
			echo "source.xpm";
		else
			echo "source_muted.xpm";
		fi
	done < $HOME/.xmonad/scripts/.muted;
elif [[ $1 == toggle ]]; then
	while read muted; do
		if [ ${muted} == 0 ]; then
			echo 1 > $HOME/.xmonad/scripts/.muted
		else echo 0 > $HOME/.xmonad/scripts/.muted
		fi
	done < $HOME/.xmonad/scripts/.muted

	pactl set-source-mute @DEFAULT_SOURCE@ toggle;
fi
#sleep 3600;

#!/usr/bin/bash
if [[ $1 == get ]]; then
	while read muted; do
		if [[ $muted == 1 ]]; then
			echo "source.xpm";
		else
			echo "source_muted.xpm";
		fi
	done < $HOME/.wm/.muted;
elif [[ $1 == toggle ]]; then
	while read muted; do
		if [ ${muted} == 0 ]; then
			echo 1 > $HOME/.wm/.muted
		else echo 0 > $HOME/.wm/.muted
		fi
	done < $HOME/.wm/.muted

	pactl set-source-mute @DEFAULT_SOURCE@ toggle;
fi
#sleep 3600;

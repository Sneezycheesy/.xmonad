#!/usr/bin/bash
if [[ $1 == get ]]; then
	muted=$(pamixer --get-mute);
	if [[ $muted == true ]]; then
		echo "sink_muted.xpm";
	else 
		volume=$(pamixer --get-volume);
		if [[ $volume -lt 12 ]]; then
			echo "sink.xpm";
		elif [[ $volume -lt 30 ]]; then
			echo "sink_low.xpm";
		elif [[ $volume -lt 60 ]]; then
			echo "sink_med.xpm";
		else
			echo "sink_high.xpm";
		fi
	fi
fi

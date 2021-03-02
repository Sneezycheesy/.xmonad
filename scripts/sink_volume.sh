#!/usr/bin/bash
if [[ $1 == get ]]; then
	volume=$(pamixer --get-volume);
	echo "${volume}%"
fi

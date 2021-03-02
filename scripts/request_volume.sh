#!/usr/bin/bash
if [[ $1 == sink ]]; then
	volume="$(pamixer --get-volume)";
fi

echo "${volume}%";

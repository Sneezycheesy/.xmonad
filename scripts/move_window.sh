#!/usr/bin/bash
x_left=0;
x_right=960;
width=960;
height=1040;
title_height=22;
y_openbox=40;


while read value; do
		if [ ${value} == "default-amd" ]; then
			windowposition=`xdotool getactivewindow getwindowgeometry |grep "Position:"`;
			position="$(cut -d':' -f2 <<< $windowposition)";

			for val in $position; do
				x=$(cut -d',' -f1 <<< $val);
				if [ $x != null ]; then
					break;
				fi
			done

			if [ $x -gt 1920 ]; then				
				x_left=1920;
				x_right=2880;
			fi
		fi
done < /home/joshii/.screenlayout/check.txt;

if [ $1 == left ]; then
	if [ ! -z $2 ]; then
		height=$[(${height} - ${title_height}) / 2];
		if [ $2 == top ]; then
			$(`xdotool getactivewindow windowsize ${width} ${height} windowmove ${x_left} ${y_openbox}`);
		elif [ $2 == bottom ]; then
			$(`xdotool getactivewindow windowsize ${width} ${height} windowmove ${x_left} $[${y_openbox} + $height + ${title_height}]`);
		fi
	else
		$(`xdotool getactivewindow windowsize ${width} ${height} windowmove ${x_left} ${y_openbox}`);
	fi
elif [ $1 == right ]; then
	if [ ! -z $2 ]; then
		height=$[(${height} - ${title_height}) / 2];
		if [ $2 == top ]; then
			$(`xdotool getactivewindow windowsize ${width} ${height} windowmove ${x_right} ${y_openbox}`);
		elif [ $2 == bottom ]; then
			$(`xdotool getactivewindow windowsize ${width} ${height} windowmove ${x_right} $[${y_openbox} + $height + ${title_height}]`);
		fi
	else
		$(`xdotool getactivewindow windowsize ${width} ${height} windowmove ${x_right} ${y_openbox}`);
	fi
elif [ $1 == move_left ]; then
	$(`xdotool getactivewindow windowmove 0 40`);
elif [ $1 == move_right ]; then
	$(`xdotool getactivewindow windowmove 1920 40`);
fi
#!/usr/bin/bash
updates=$(pacman -Qu | wc -l);
echo "<icon=updates.xpm/> ${updates}";

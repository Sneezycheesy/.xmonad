#!/usr/bin/bash
export LANG=C.UTF-8;
kernel="$(uname -r | cut -d'-' -f1)";
echo -e "${kernel}";

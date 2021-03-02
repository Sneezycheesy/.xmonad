#!/usr/bin/bash
result="";
if [ -e "/tmp/mpvsocket" ]; then
    echo "loadfile $1 append-play" | socat -lf ~/.config/qutebrowser/socat.log - /tmp/mpvsocket;
else
    $(rm ~/.config/qutebrowser/socat.log);
    mpv --vd-queue-enable=yes --autofit=1920x1080 --input-ipc-server=/tmp/mpvsocket $1;
fi

while read value; do
    result=${value};
done < ~/.config/qutebrowser/socat.log;

if [[ ${result} -eq 0 ]]; then
    echo ${result};
else
    echo "${result}";
    $(rm ~/.config/qutebrowser/socat.log);
    `mpv --vd-queue-enable=yes --autofit=1920x1080 --input-ipc-server=/tmp/mpvsocket $1`;
fi
if [ ! -z `pgrep stalonetray` ]; then 
$(`killall -q stalonetray && killall -q nm-applet`);
else 
$(`nm-applet & stalonetray &`);
fi

#!/bin/sh

#export LC_ALL="en.utf-8"
export LC_ALL=C
export HOME=/config

exec /usr/bin/grass

sleep 1s

bash wmctrl_retry.sh   # hidden   

#ls /usr/bin/grass && dpkg -i /grass/grass.deb && sleep 3s
#sleep 7s ; ls /config/xdg/data/io.getgrass.desktop/localstorage && wmctrl -r grass -b add,hidden   

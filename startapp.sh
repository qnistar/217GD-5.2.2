#!/bin/sh

#export LC_ALL="en.utf-8"
export LC_ALL=C
export HOME=/config
#ls /usr/bin/grass && dpkg -i /grass/grass.deb && sleep 3s
exec /usr/bin/grass

#sleep 7s ; ls /config/xdg/data/io.getgrass.desktop/localstorage && wmctrl -r grass -b add,hidden   

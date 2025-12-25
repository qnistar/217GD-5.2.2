#!/bin/bash
set -e

export DISPLAY=:99
export HOME=/config


  

# 4. 컨테이너 유지
echo "Container is running..."
tail -f /dev/null


#ls /usr/bin/grass && dpkg -i /grass/grass.deb && sleep 3s
#sleep 7s ; ls /config/xdg/data/io.getgrass.desktop/localstorage && wmctrl -r grass -b add,hidden   

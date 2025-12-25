#!/bin/sh

#export LC_ALL="en.utf-8"
export LC_ALL=C
export HOME=/config

# exec /usr/bin/grass

rm -rf \
  /etc/services.d/nginx \
  /etc/services.d/xvnc \
  /etc/services.d/certsmonitor \
  /etc/services.d/logmonitor \
  /etc/services.d/logrotate

# 4. 컨테이너 유지
echo "Container is running..."
tail -f /dev/null


#ls /usr/bin/grass && dpkg -i /grass/grass.deb && sleep 3s
#sleep 7s ; ls /config/xdg/data/io.getgrass.desktop/localstorage && wmctrl -r grass -b add,hidden   

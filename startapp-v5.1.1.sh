#!/bin/sh

#export LC_ALL="en.utf-8"
export LC_ALL=C
export HOME=/config


# mv /etc/services.d/nginx.disabled /etc/services.d/nginx

# v5.1.1 ~
exec /usr/bin/grass
# =================================


# v7.4.4  ubuntu24.04 (전용)
#exec /usr/bin/grass-desktop
# =================================

# mv /etc/services.d/nginx /etc/services.d/nginx.disabled
# pkill -9 -f nginx
# ls -al /etc/services.d

# 4. 컨테이너 유지
#echo "Container is running..."
#tail -f /dev/null


#ls /usr/bin/grass && dpkg -i /grass/grass.deb && sleep 3s
#sleep 7s ; ls /config/xdg/data/io.getgrass.desktop/localstorage && wmctrl -r grass -b add,hidden   

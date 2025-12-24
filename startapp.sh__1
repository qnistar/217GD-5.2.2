#!/bin/sh

#export LC_ALL="en.utf-8"
export LC_ALL=C
export HOME=/config

#exec /usr/bin/grass

# 0)
XVFB_DISPLAY=":99"
XAUTH_FILE="/tmp/.Xauthority_${XVFB_DISPLAY}"

# 1) 실행전 기존 프로세스 정리
pkill -f "Xvfb ${XVFB_DISPLAY}"
pkill -f "openbox"
pkill -f "/usr/bin/grass"
#pkill -f "grass"

sleep 3s

# 2)
nohup xvfb-run -a \
    --auth "$XAUTH_FILE" \
    -n 99 \
    -s "-screen 0 1x1x8" \
    /bin/bash -c '
        /usr/bin/grass \
            --headless \
            --disable-extensions \
            --hide-scrollbars \
            --mute-audio \
            --disable-gpu \
            --disable-software-rasterizer \
            --no-sandbox \
            > /dev/null 2>&1 &

        openbox
    ' \
    > /dev/null 2>&1 &


sleep 4s


bash wmctrl_retry.sh   # hidden   

#ls /usr/bin/grass && dpkg -i /grass/grass.deb && sleep 3s
#sleep 7s ; ls /config/xdg/data/io.getgrass.desktop/localstorage && wmctrl -r grass -b add,hidden   

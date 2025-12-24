#!/bin/bash


# 1. 홈 디렉토리 설정 (설정값 저장 위치)
mkdir -p /config
export HOME=/config

XVFB_DISPLAY=":99"
XAUTH_FILE="/tmp/.Xauthority_${XVFB_DISPLAY}"


# nohup xvfb-run -a --auth {XAUTH_FILE} -n 99 -s "-screen 0 1024x768x24" /bin/bash -c "grass --disable-gpu --disable-software-rasterizer --no-sandbox > /dev/null 2>&1 & openbox ; " > /dev/null 2>&1 &
nohup xvfb-run -a --auth $XAUTH_FILE -n 99 -s '-screen 0 1024x768x24' \
    /bin/bash -c " \
        dpn --headless --disable-extensions --hide-scrollbars --mute-audio --disable-gpu --disable-software-rasterizer --no-sandbox > /dev/null 2>&1 & \
        openbox ; \
    " > /dev/null 2>&1 &

        
#xvfb-run -n 99 -s "-screen 0 1024x768x24" /bin/bash -c 'grass --disable-gpu --disable-software-rasterizer --no-sandbox'
#xvfb-run -a --auth "$XAUTH_FILE" -n 99 -s "-screen 0 1024x768x24" /bin/bash -c 'grass --disable-gpu --disable-software-rasterizer --no-sandbox & openbox' &



#sleep 5
#/wmctrl_retry.sh


# 4. 컨테이너 유지
echo "Container is running..."
tail -f /dev/null



# 2. Xvfb 가상 디스플레이 시작
# :99 디스플레이를 생성하고 해상도를 설정합니다.
#Xvfb :99 -screen 0 1280x1024x24 &
#export DISPLAY=:99


# 2. 윈도우 매니저 실행 (창 크기 조절 등을 위해 필요)
#openbox &

# 3. Grass 앱 실행 (경로 확인 필요, 보통 /usr/bin/grass)
# 만약 root 권한 문제 발생 시 --no-sandbox 옵션 추가
#/usr/bin/grass --no-sandbox &

# 4. wmctrl 등을 이용한 추가 스크립트 실행 (필요한 경우)
#sleep 5
#/wmctrl_retry.sh

# 5. 프로세스가 종료되지 않도록 유지
#wait


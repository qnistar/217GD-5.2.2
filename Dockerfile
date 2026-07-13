#===================================================================================================================================
# name: U26-v7.4
# 
#===================================================================================================================================


# 베이스 이미지: Ubuntu 26.04 (Resolute)
FROM ubuntu:26.04

# 상호작용 없는 설치 설정 (타임존 등 프롬프트 무시)
ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:0
ENV RESOLUTION=1280x800x24

# 환경 변수 (요청하신 다운로드 URL)
ARG APP_URL=https://files.grass.io/file/grass-extension-upgrades/v7.4.4/grass-desktop_7.4.4_amd64.deb

# 1. 필수 패키지 및 미니멀 GUI / VNC / noVNC 환경 설치
RUN apt-get update && apt-get install -y --no-install-recommends \
    # GUI 및 VNC 관련
    xvfb \
    fluxbox \
    x11vnc \
    novnc \
    websockify \
    # 필수 설치 및 기타 유틸리티
    libwebkit2gtk-4.1-0 \
    gdebi-core \
    inetutils-ping \
    curl \
    xdotool \
    wmctrl \
    scrot \
    nano \
    ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 2. grass-desktop 다운로드 및 gdebi로 설치
RUN curl -L -o /tmp/grass-desktop.deb "$APP_URL" \
    && gdebi -n /tmp/grass-desktop.deb \
    && rm /tmp/grass-desktop.deb

# 3. 컨테이너 시작 시 실행될 엔트리포인트 스크립트 작성
RUN echo '#!/bin/bash\n\
# 가상 프레임버퍼(Xvfb) 실행\n\
Xvfb :0 -screen 0 ${RESOLUTION} -nolisten tcp &\n\
sleep 2\n\
\n\
# 미니멀 창 관리자 실행\n\
fluxbox &\n\
\n\
# VNC 서버 실행\n\
x11vnc -display :0 -nopw -forever -shared &\n\
\n\
# noVNC 웹소켓 프록시 실행 (포트 8080)\n\
websockify --web=/usr/share/novnc/ 8080 localhost:5900 &\n\
sleep 2\n\
\n\
# grass-desktop 실행 (도커 root 환경을 위한 no-sandbox 옵션 추가)\n\
exec /usr/bin/grass-desktop --no-sandbox\n\
' > /start.sh && chmod +x /start.sh

# noVNC 웹 접속을 위한 포트 개방
EXPOSE 8080

# 스크립트 실행
CMD ["/start.sh"]

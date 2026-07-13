#===================================================================================================================================
# name: U26-v7.4.4
# 
#===================================================================================================================================


# 베이스 이미지: Ubuntu 26.04 (Resolute)
FROM ubuntu:26.04

# 상호작용 없는 설치 설정 (타임존 등 프롬프트 무시)
ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:0
ENV RESOLUTION=1280x800x24

# 환경 변수
ARG APP_URL=https://files.grass.io/file/grass-extension-upgrades/v7.4.4/grass-desktop_7.4.4_amd64.deb

# 1. 필수 패키지 및 미니멀 GUI / VNC / noVNC 환경 설치
RUN apt-get update && apt-get install -y --no-install-recommends \
    # GUI 및 VNC 관련
    xvfb \
    fluxbox \
    x11vnc \
    novnc \
    websockify \
    # grass-desktop 필수/대체 패키지 및 기타 유틸리티
    libwebkit2gtk-4.1-0 \
    libayatana-appindicator3-1 \
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

# 2. grass-desktop 다운로드, 의존성 수정(repack) 및 설치
RUN curl -L -o /tmp/grass.deb "$APP_URL" \
    # 패키지 압축 풀기
    && dpkg-deb -R /tmp/grass.deb /tmp/grass-extracted \
    # 문제가 되는 구형 의존성을 신형 패키지 이름으로 치환
    && sed -i 's/libappindicator3-1/libayatana-appindicator3-1/g' /tmp/grass-extracted/DEBIAN/control \
    # 패키지 다시 묶기(repack)
    && dpkg-deb -b /tmp/grass-extracted /tmp/grass-fixed.deb \
    # 수정된 패키지를 gdebi로 설치
    && gdebi -n /tmp/grass-fixed.deb \
    # 임시 파일 정리
    && rm -rf /tmp/grass.deb /tmp/grass-extracted /tmp/grass-fixed.deb

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

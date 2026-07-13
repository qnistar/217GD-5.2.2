#===================================================================================================================================
# name: U26-v5.1.1
# 
#===================================================================================================================================



# 베이스 이미지: Ubuntu 26.04 (Resolute)
FROM ubuntu:26.04

# 상호작용 없는 설치 설정 및 환경 변수
ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:0
ENV RESOLUTION=1024x1024x24

# 환경 변수 (요청하신 다운로드 URL)
#ARG APP_URL=https://files.grass.io/file/grass-extension-upgrades/v7.4.4/grass-desktop_7.4.4_amd64.deb
ARG APP_URL=https://files.getgrass.io/file/grass-extension-upgrades/ubuntu-22.04/Grass_5.1.1_amd64.deb


# 1. 모든 패키지 설치 및 앱 빌드 과정을 하나의 레이어로 통합 (캐시 유실 방지)
RUN apt-get update && apt-get install -y --no-install-recommends \
    xvfb \
    openbox \
    x11vnc \
    novnc \
    websockify \
    inetutils-ping \
    curl \
    xdotool \
    wmctrl \
    scrot \
    nano \
    gdebi-core \
    ca-certificates \
    # [앱 다운로드 및 repack 작업]
    && curl -L -o /tmp/grass.deb "$APP_URL" \
    && dpkg-deb -R /tmp/grass.deb /tmp/grass-extracted \
    # control 파일에서 libappindicator3-1 의존성 완전히 제거 구문
    && sed -i -E 's/libappindicator3-1[[:space:]]*(\([^)]+\))?//g' /tmp/grass-extracted/DEBIAN/control \
    && sed -i -E 's/,[[:space:]]*,/, /g' /tmp/grass-extracted/DEBIAN/control \
    && sed -i -E 's/,[[:space:]]*$//g' /tmp/grass-extracted/DEBIAN/control \
    && sed -i -E 's/:[[:space:]]*,/: /g' /tmp/grass-extracted/DEBIAN/control \
    # 패키지 재조립
    && dpkg-deb -b /tmp/grass-extracted /tmp/grass-fixed.deb \
    # gdebi로 의존성 자동 해결하며 설치 (이 시점엔 apt 캐시가 유지되어 있어 성공함)
    && gdebi -n /tmp/grass-fixed.deb \
    # 사용 후 모든 임시 파일 및 apt 캐시 완전 정리 (최종 이미지 용량 최소화)
    && rm -rf /tmp/grass.deb /tmp/grass-extracted /tmp/grass-fixed.deb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 2. 오직 프로그램 창만 제어하는 초경량 엔트리포인트 스크립트 작성
RUN echo '#!/bin/bash\n\
# 가상 디스플레이 시작\n\
Xvfb :0 -screen 0 ${RESOLUTION} -nolisten tcp &\n\
sleep 1\n\
\n\
# 오픈박스 실행 (바탕화면 구성요소 없음)\n\
openbox-session &\n\
\n\
# VNC 및 웹소켓 프록시 실행\n\
x11vnc -display :0 -nopw -forever -shared -quiet &\n\
websockify --web=/usr/share/novnc/ 8080 localhost:5900 >/dev/null 2>&1 &\n\
sleep 1\n\
\n\
# 앱이 켜지면 감지하여 화면에 100% 꽉 채우는 백그라운드 스레드\n\
(\n\
  for i in {1..30}; do\n\
    if wmctrl -l | grep -qi "grass"; then\n\
      wmctrl -r "grass" -b add,maximized_vert,maximized_horz\n\
      break\n\
    fi\n\
    sleep 0.5\n\
  done\n\
) &\n\
\n\
# 메인 프로그램 실행\n\
exec /usr/bin/grass --no-sandbox\n\
' > /start.sh && chmod +x /start.sh

# noVNC 전용 포트
EXPOSE 8080

# 실행 명령어 (오직 최종 시작 스크립트 단 하나만 사용)
CMD ["/start.sh"]

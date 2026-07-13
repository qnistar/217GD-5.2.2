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


# 1. 최소한의 X11 실행 환경 및 유틸리티 설치 (gdebi-core 다시 추가)
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
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 2. grass-desktop 다운로드, 의존성 수정(repack) 후 gdebi로 설치
RUN curl -L -o /tmp/grass.deb "$APP_URL" \
    # 패키지 압축 해제
    && dpkg-deb -R /tmp/grass.deb /tmp/grass-extracted \
    # control 파일에서 libappindicator3-1 의존성 완전히 제거 구문
    && sed -i -E 's/libappindicator3-1[[:space:]]*(\([^)]+\))?//g' /tmp/grass-extracted/DEBIAN/control \
    && sed -i -E 's/,[[:space:]]*,/, /g' /tmp/grass-extracted/DEBIAN/control \
    # 끝에 남은 쉼표 제거 및 포맷 정렬
    && sed -i -E 's/,[[:space:]]*$//g' /tmp/grass-extracted/DEBIAN/control \
    && sed -i -E 's/:[[:space:]]*,/: /g' /tmp/grass-extracted/DEBIAN/control \
    # 패키지 재조립
    && dpkg-deb -b /tmp/grass-extracted /tmp/grass-fixed.deb \
    # 요청하신 gdebi 방식으로 의존성 자동 해결하며 설치
    && gdebi -n /tmp/grass-fixed.deb \
    # 임시 빌드 파일 완전 정리
    && rm -rf /tmp/grass.deb /tmp/grass-extracted /tmp/grass-fixed.deb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 3. 오직 프로그램 창만 제어하는 초경량 엔트리포인트 스크립트 작성
RUN echo '#!/bin/bash\n\
# 1. 가상 디스플레이 시작\n\
Xvfb :0 -screen 0 ${RESOLUTION} -nolisten tcp &\n\
sleep 1\n\
\n\
# 2. 오픈박스 실행 (바탕화면 구성요소 없음)\n\
openbox-session &\n\
\n\
# 3. VNC 및 웹소켓 프록시 실행\n\
x11vnc -display :0 -nopw -forever -shared -quiet &\n\
websockify --web=/usr/share/novnc/ 8080 localhost:5900 >/dev/null 2>&1 &\n\
sleep 1\n\
\n\
# 4. 앱이 켜지면 감지하여 화면에 100% 꽉 채우는 백그라운드 스레드\n\
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
# 5. 메인 프로그램 실행\n\
exec /usr/bin/grass --no-sandbox\n\
' > /start.sh && chmod +x /start.sh

# noVNC 전용 포트
EXPOSE 8080

CMD ["/start.sh"]

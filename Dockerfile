############################################
# Builder
############################################
FROM jlesage/baseimage-gui:ubuntu-22.04-v4.5.3 AS builder

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /grass

COPY startapp.sh /grass/startapp.sh
RUN chmod +x /grass/startapp.sh

COPY main-window-selection.jwmrc /grass/main-window-selection.jwmrc

ARG APP_URL=https://files.grass.io/file/grass-extension-upgrades/v6.1.2/Grass_6.1.2_amd64.deb
RUN curl -sSL ${APP_URL} -o /grass/grass.deb


############################################
# Runtime
############################################
FROM jlesage/baseimage-gui:ubuntu-22.04-v4.5.3

############################################
# VNC / Web UI 완전 비활성화
############################################
ENV ENABLE_VNC=0
ENV ENABLE_WEB=0
ENV ENABLE_NOVNC=0
ENV WEB_LISTENING_PORT=
ENV VNC_LISTENING_PORT=

############################################
# App Info
############################################
ENV KEEP_APP_RUNNING=1

RUN set-cont-env APP_NAME "Grass" && \
    set-cont-env APP_VERSION "6.1.2"

############################################
# 필수 GUI / 런타임 라이브러리
############################################
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        inetutils-ping \
        procps \
        dbus-x11 \
        xvfb \
        xauth \
        openbox \
        wmctrl \
        xdotool \
        fonts-liberation \
        libwebkit2gtk-4.1-0 \
        libayatana-appindicator3-1 \
        libegl-dev \
        libgl1-mesa-dri \
        libgl1-mesa-glx && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

############################################
# VNC / Web 서비스 완전 제거
############################################
RUN rm -rf \
    /etc/services.d/vnc \
    /etc/services.d/web \
    /etc/services.d/novnc

############################################
# Grass 설치
############################################
COPY --from=builder /grass /grass

RUN mkdir -p /etc/jwm && \
    mv /grass/main-window-selection.jwmrc /etc/jwm/main-window-selection.jwmrc && \
    mv /grass/startapp.sh /startapp.sh && \
    dpkg -i /grass/grass.deb

RUN chmod +x /startapp.sh

############################################
# 실행
############################################
ENTRYPOINT ["/startapp.sh"]

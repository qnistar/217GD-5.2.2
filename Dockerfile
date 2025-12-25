FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive
ARG APP_URL=https://files.grass.io/file/grass-extension-upgrades/v6.1.2/Grass_6.1.2_amd64.deb

# HOME 경로 고정 (grass 설정/프로필 저장용)
ENV HOME=/config
ENV DISPLAY=:99

# 필수 패키지 + GUI (xvfb / openbox / wmctrl)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        wget \
        curl \
        xvfb \
        openbox \
        wmctrl \
        xauth \
        dbus-x11 \
        libgtk-3-0 \
        libnss3 \
        libxss1 \
        libasound2 \
        fonts-liberation \
    && rm -rf /var/lib/apt/lists/*

# HOME 디렉토리 생성
RUN mkdir -p /config && chmod 755 /config

# Grass 다운로드 & 설치
WORKDIR /tmp
RUN wget -O grass.deb "${APP_URL}" && \
    dpkg -i grass.deb || apt-get update && apt-get install -f -y && \
    rm -f grass.deb && \
    rm -rf /var/lib/apt/lists/*

# Openbox 설정 (HOME=/config 기준)
RUN mkdir -p /config/.config/openbox && \
    echo "exec openbox-session &" > /config/.xinitrc

# xvfb + openbox + grass 실행
CMD xvfb-run -a -n 99 -s "-screen 0 1024x768x24" \
    /bin/bash -c "export HOME=/config && openbox-session & exec /usr/bin/grass --no-sandbox"

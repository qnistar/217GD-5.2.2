FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:99
ENV HOME=/config

ARG APP_URL=https://files.grass.io/file/grass-extension-upgrades/v6.1.2/Grass_6.1.2_amd64.deb

# 기본 패키지 + GUI 환경
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        wget \
        git \
        scrot \
        sudo \
        gdebi-core \
        xvfb \
        dbus-x11 \
        xauth \
        openbox \
        lxqt-core \
        lxqt-session \
        lxqt-panel \
        lxqt-config \
        lxqt-policykit \
    && mkdir -p /grass /config \
    && rm -rf /var/lib/apt/lists/*

# Grass 다운로드
RUN curl -fsSL ${APP_URL} -o /grass/grass.deb



# ============================================================

# Ayatana 대체 라이브러리
RUN apt-get update && \
    apt-get install -y \
        libayatana-appindicator3-1 \
        libayatana-indicator3-7 \
        libindicator3-7 \
        libnss3 \
        libatk1.0-0 \
        libatk-bridge2.0-0 \
        libx11-xcb1 \
        libgbm1 \
        libasound2t64 \
        libxcomposite1 \
        libxdamage1 \
        libxrandr2

# Grass 설치
RUN dpkg -i /grass/grass.deb || true && \
    apt-get install -f -y && \
    rm -f /grass/grass.deb && \
    apt-get clean


#RUN rm -f /grass/grass.deb

# ============================================================



# 시작 스크립트
COPY startapp.sh /startapp.sh
RUN chmod +x /startapp.sh

WORKDIR /config

CMD ["/startapp.sh"]

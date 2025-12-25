FROM ubuntu:22.04

# 환경 변수 설정
ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:99

# 필수 패키지 설치 (의존성 강화)
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    dbus-x11 \
    at-spi2-core \
    fonts-liberation \
    libgl1-mesa-dri \
    libgl1-mesa-glx \
    curl \
    xvfb \
    openbox \
    libnss3 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libgtk-3-0 \
    libgbm1 \
    libasound2 \
    libayatana-appindicator3-1 \
    libwebkit2gtk-4.1-0 \
    xdotool \
    wmctrl \
    procps \
    libgtk-3-0 \
    libglib2.0-0 \
    libx11-6 \
    libxrandr2 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxinerama1 \
    libxi6 \
    libpangocairo-1.0-0 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libwebkit2gtk-4.1-0 \
    && rm -rf /var/lib/apt/lists/*

# Grass 설치 파일 다운로드 및 설치
ARG APP_URL=https://files.grass.io/file/grass-extension-upgrades/v6.1.2/Grass_6.1.2_amd64.deb
RUN curl -L ${APP_URL} -o /tmp/grass.deb && \
    apt-get update && dpkg -i /tmp/grass.deb || apt-get install -f -y && \    
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    ls -al
    #rm /tmp/grass.deb

# 설정 파일 및 스크립트 복사
COPY startapp.sh /startapp.sh
COPY wmctrl_retry.sh /wmctrl_retry.sh


RUN chmod +x /startapp.sh /wmctrl_retry.sh

# 실행
ENTRYPOINT ["/startapp.sh"]

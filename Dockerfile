# 1. 베이스 이미지 선택 (Selkies 기반으로 GUI 환경 지원)
FROM ghcr.io/linuxserver/baseimage-selkies:ubuntunoble

# 작성자 레이블
#LABEL maintainer="217heidai@gmail.com"

# 환경 변수 설정
ENV APP_NAME="Grass" \
    APP_VERSION="6.1.2" \
    DEBIAN_FRONTEND=noninteractive

# 2. 필수 패키지 설치 및 환경 구성
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    libayatana-appindicator3-1 \
    libwebkit2gtk-4.1-0 \
    libegl-dev \
    inetutils-ping \
    xdotool \
    wmctrl \
    xvfb \
    openbox \
    xauth \
    procps \
    dbus-x11 \
    fonts-liberation \
    # 22.04 전용
    #libgl1-mesa-dri \
    #libgl1-mesa-glx && \

    # 24.04 >>> 아래 두 패키지가 libgl1-mesa-glx를 대체합니다.
    libgl1 \
    libglx-mesa0 && \
    
    # 패키지 정리
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 3. Grass 어플리케이션 다운로드 및 설치
ARG APP_URL=https://files.grass.io/file/grass-extension-upgrades/v6.1.2/Grass_6.1.2_amd64.deb

RUN curl -sS -L ${APP_URL} -o /tmp/grass.deb && \
    dpkg -i /tmp/grass.deb || apt-get install -fy && \
    rm /tmp/grass.deb

# 4. 스크립트 복사 및 권한 설정
# 작성하신 startapp.sh와 wmctrl_retry.sh가 Dockerfile과 같은 경로에 있어야 합니다.
COPY startapp.sh /startapp.sh
COPY wmctrl_retry.sh /wmctrl_retry.sh

RUN chmod +x /startapp.sh /wmctrl_retry.sh

# 5. 실행 설정
# LinuxServer.io 베이스 이미지는 내부적으로 S6-overlay를 사용하므로 
# CMD 대신 직접 실행하거나 서비스로 등록하는 것이 좋습니다.
# 여기서는 요청하신 대로 /startapp.sh를 진입점으로 설정합니다.
ENTRYPOINT ["/startapp.sh"]

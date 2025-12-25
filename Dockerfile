# 베이스 이미지
FROM ubuntu:22.04

# 환경 변수
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    DISPLAY=:99 \
    HOME=/config

# 필수 패키지 설치
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash coreutils curl dash dpkg file findutils grep gzip hostname locales lsb-release sudo tzdata \
    fonts-dejavu-core fontconfig adwaita-icon-theme hicolor-icon-theme humanity-icon-theme \
    xvfb x11-utils x11-xserver-utils x11-common x11proto-dev \
    libx11-6 libx11-dev libxext6 libxrender1 libxrandr2 libxinerama1 libxcursor1 libxcomposite1 libxtst6 libxfixes3 libxi6 libxmu6 \
    libgtk-3-0 libglib2.0-0 libcairo2 libpango-1.0-0 libgdk-pixbuf-2.0-0 libfreetype6 libjpeg-turbo8 libtiff5 \
    libsm6 libice6 libglu1-mesa libgl1-mesa-glx \
    openbox obconf \
    xdotool wmctrl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# GRASS 다운로드 및 설치
RUN mkdir -p /grass
ARG APP_URL=https://files.grass.io/file/grass-extension-upgrades/v6.1.2/Grass_6.1.2_amd64.deb
RUN curl -sS -L ${APP_URL} -o /grass/grass.deb && \
    dpkg -i /grass/grass.deb || apt-get install -f -y && \
    rm -f /grass/grass.deb

# Openbox 설정 폴더 생성
RUN mkdir -p /root/.config/openbox

# GRASS 실행용 entrypoint
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# 기본 명령
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

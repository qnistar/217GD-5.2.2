FROM jlesage/baseimage-gui:ubuntu-22.04-v4.5.3

# 빌드 및 실행에 필요한 기본 패키지 및 의존성 다운로드
ARG APP_URL=https://files.grass.io/file/grass-extension-upgrades/v7.4.4/grass-desktop_7.4.4_amd64.deb

WORKDIR /grass

# 1. wget으로 데비안 패키지 다운로드
# 2. apt-get update 후 로컬 패키지 설치(로컬 설치 시 의존성 자동 추적)
# 3. 설치 후 캐시 및 패키지 파일 정리로 용량 최적화
RUN apt-get update && apt-get install -y wget && \
    wget -q "${APP_URL}" -O grass.deb && \
    apt-get install -y ./grass.deb || (apt-get install -f -y) && \
    rm -rf /var/lib/apt/lists/* grass.deb

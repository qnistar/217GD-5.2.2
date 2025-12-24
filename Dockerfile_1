#FROM jlesage/baseimage-gui:ubuntu-22.04-v4.5.3 AS builder    
#FROM ubuntu:22.04 AS builder 
#FROM linuxserver/xvfb:ubuntunoble AS builder 

# Xvfb 이미지를 'xvfb'라는 이름의 스테이지로 가져옵니다.
FROM lscr.io/linuxserver/xvfb:ubuntunoble AS xvfb

# 애플리케이션을 빌드할 기본 이미지를 선택합니다 (예: 다른 Ubuntu noble 이미지).
# 이 이미지는 LinuxServer.io의 기본 이미지를 사용하는 것이 좋습니다.
FROM ghcr.io/linuxserver/baseimage-selkies:ubuntunoble 

# Xvfb 스테이지에서 필요한 Xvfb 바이너리 및 라이브러리를 최종 이미지로 복사합니다.
COPY --from=xvfb / /


#FROM jlesage/baseimage-gui:ubuntu-22.04-v4.7.1 AS builder   
#grass-로그인창 나옴!!!


RUN apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests ca-certificates curl

RUN mkdir -p /grass

COPY startapp.sh /grass/startapp.sh
RUN chmod +x /grass/startapp.sh

COPY wmctrl_retry.sh /grass/wmctrl_retry.sh
RUN chmod +x /grass/wmctrl_retry.sh


COPY main-window-selection.jwmrc /grass/main-window-selection.jwmrc

#ARG APP_URL=https://files.getgrass.io/file/grass-extension-upgrades/ubuntu-22.04/Grass_5.2.2_amd64.deb
#ARG APP_URL=https://files.getgrass.io/file/grass-extension-upgrades/ubuntu-22.04/Grass_5.1.1_amd64.deb
#ARG APP_URL=https://files.getgrass.io/file/grass-extension-upgrades/ubuntu-22.04/Grass_5.3.1_amd64.deb
#ARG APP_URL=https://files.grass.io/file/grass-extension-upgrades/v5.7.1/Grass_5.7.1_amd64.deb
ARG APP_URL=https://files.grass.io/file/grass-extension-upgrades/v6.1.2/Grass_6.1.2_amd64.deb
# =========================================================================================================
RUN curl -sS -L ${APP_URL} -o /grass/grass.deb

#FROM ubuntu:22.04
#FROM linuxserver/xvfb:ubuntunoble

# Xvfb 이미지를 'xvfb'라는 이름의 스테이지로 가져옵니다.
FROM lscr.io/linuxserver/xvfb:ubuntunoble

# 애플리케이션을 빌드할 기본 이미지를 선택합니다 (예: 다른 Ubuntu noble 이미지).
# 이 이미지는 LinuxServer.io의 기본 이미지를 사용하는 것이 좋습니다.
FROM ghcr.io/linuxserver/baseimage-selkies:ubuntunoble 

# Xvfb 스테이지에서 필요한 Xvfb 바이너리 및 라이브러리를 최종 이미지로 복사합니다.
COPY --from=xvfb / /


#FROM jlesage/baseimage-gui:ubuntu-22.04-v4.5.3
#FROM jlesage/baseimage-gui:ubuntu-22.04-v4.7.1
#LABEL org.opencontainers.image.authors="217heidai@gmail.com"

###ENV KEEP_APP_RUNNING=1
# jlesage/baseimage-gui:ubuntu-22.04-v4.6 报错：Could not create surfaceless EGL display: EGL_NOT_INITIALIZED，待jlesage/baseimage-gui修复
# jlesage/baseimage-gui:ubuntu-22.04-v4.5 不支持 web auth
###ENV SECURE_CONNECTION=1
###ENV WEB_AUTHENTICATION=1
###ENV WEB_AUTHENTICATION_USERNAME=grass
###ENV WEB_AUTHENTICATION_PASSWORD=grass

###RUN set-cont-env APP_NAME "Grass" && \
    #set-cont-env APP_VERSION "5.2.2"
    #set-cont-env APP_VERSION "5.1.1"
    #set-cont-env APP_VERSION "5.3.1"
    #set-cont-env APP_VERSION "5.7.1"
    #set-cont-env APP_VERSION "6.1.2"
    ###set-cont-env APP_VERSION "xvfb_6.1.2"
    # =========================================================================================================
    
RUN apt-get update && \
    # dnsutils psmisc git iproute2
    apt-get install -y --no-install-recommends --no-install-suggests ca-certificates libayatana-appindicator3-1 libwebkit2gtk-4.1-0 libegl-dev inetutils-ping curl xdotool wmctrl xvfb openbox xauth procps dbus-x11 fonts-liberation libgl1-mesa-dri libgl1-mesa-glx && \
    apt-get autoremove -y && \
    apt-get -y --purge autoremove && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /grass/ /grass/

RUN mkdir -p /etc/jwm && \
    #mv /grass/main-window-selection.jwmrc /etc/jwm/main-window-selection.jwmrc && \
    mv /grass/startapp.sh /startapp.sh && \
    mv /grass/wmctrl_retry.sh /wmctrl_retry.sh && \
    dpkg -i /grass/grass.deb && \
    #rm -rf /grass

RUN chmod +x /startapp.sh
CMD ["/startapp.sh"]
#ENTRYPOINT ["/startapp.sh"]    

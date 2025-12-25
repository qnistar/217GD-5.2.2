FROM jlesage/baseimage-gui:ubuntu-22.04-v4.5.3 AS builder    

#FROM jlesage/baseimage-gui:ubuntu-22.04-v4.7.1 AS builder   
#grass-로그인창 나옴!!!


RUN apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests ca-certificates curl

RUN mkdir -p /grass

COPY startapp.sh /grass/startapp.sh
RUN chmod +x /grass/startapp.sh

COPY main-window-selection.jwmrc /grass/main-window-selection.jwmrc

#ARG APP_URL=https://files.getgrass.io/file/grass-extension-upgrades/ubuntu-22.04/Grass_5.2.2_amd64.deb
#ARG APP_URL=https://files.getgrass.io/file/grass-extension-upgrades/ubuntu-22.04/Grass_5.1.1_amd64.deb
#ARG APP_URL=https://files.getgrass.io/file/grass-extension-upgrades/ubuntu-22.04/Grass_5.3.1_amd64.deb
#ARG APP_URL=https://files.grass.io/file/grass-extension-upgrades/v5.7.1/Grass_5.7.1_amd64.deb
ARG APP_URL=https://files.grass.io/file/grass-extension-upgrades/v6.1.2/Grass_6.1.2_amd64.deb
# =========================================================================================================
RUN curl -sS -L ${APP_URL} -o /grass/grass.deb







FROM jlesage/baseimage-gui:ubuntu-22.04-v4.5.3
#FROM jlesage/baseimage-gui:ubuntu-22.04-v4.7.1
#LABEL org.opencontainers.image.authors="217heidai@gmail.com"

# ==============================================================================

ENV ENABLE_VNC=0
ENV ENABLE_HTTP=0
ENV ENABLE_NGINX=0
ENV ENABLE_WEB=0
ENV WEB_AUTH=0
#ENV DISPLAY_WIDTH=1
#ENV DISPLAY_HEIGHT=1
#ENV DISPLAY=
#ENV VNC_PASSWORD=
#ENV ENABLE_X11=0
#ENV ENABLE_GUI=0
ENV WEB_LISTENING_PORT=
ENV VNC_LISTENING_PORT=
#ENV WEB_LISTENING_PORT=5800
#ENV VNC_LISTENING_PORT=5900
#ENV 
#ENV 
#ENV 



# nginx, vnc 포트 노출 안함
#EXPOSE 0  # 0사용시 에러발생됨!

# Expose ports.
#   - 5800: VNC web interface
#   - 5900: VNC
#EXPOSE 5800 5900

# ==============================================================================

ENV KEEP_APP_RUNNING=1
# jlesage/baseimage-gui:ubuntu-22.04-v4.6 报错：Could not create surfaceless EGL display: EGL_NOT_INITIALIZED，待jlesage/baseimage-gui修复
# jlesage/baseimage-gui:ubuntu-22.04-v4.5 不支持 web auth
ENV SECURE_CONNECTION=1
ENV WEB_AUTHENTICATION=1
ENV WEB_AUTHENTICATION_USERNAME=grass
ENV WEB_AUTHENTICATION_PASSWORD=grass

RUN set-cont-env APP_NAME "Grass" && \
    #set-cont-env APP_VERSION "5.2.2"
    #set-cont-env APP_VERSION "5.1.1"
    #set-cont-env APP_VERSION "5.3.1"
    #set-cont-env APP_VERSION "5.7.1"
    set-cont-env APP_VERSION "6.1.2"
    # =========================================================================================================
    
RUN apt-get update && \
    # dnsutils psmisc git iproute2
    apt-get install -y --no-install-recommends --no-install-suggests ca-certificates libayatana-appindicator3-1 libwebkit2gtk-4.1-0 libegl-dev inetutils-ping curl xdotool wmctrl scrot openbox xauth procps && \
    apt-get autoremove -y && \
    apt-get -y --purge autoremove && \
    rm -rf /var/lib/apt/lists/*



COPY --from=builder /grass/ /grass/

RUN mkdir -p /etc/jwm && \
    mv /grass/main-window-selection.jwmrc /etc/jwm/main-window-selection.jwmrc && \
    mv /grass/startapp.sh /startapp.sh && \
    dpkg -i /grass/grass.deb && \
    rm -rf /grass


RUN rm -rf \
    /etc/services.d/nginx \
    /etc/services.d/xvnc \
    /etc/services.d/certsmonitor \
    /etc/services.d/logmonitor \
    /etc/services.d/logrotate



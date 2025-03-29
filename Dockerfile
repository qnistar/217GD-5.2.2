
FROM jlesage/baseimage-gui:ubuntu-22.04-v4.5.3



ENV KEEP_APP_RUNNING=1


ENV SECURE_CONNECTION=1
ENV WEB_AUTHENTICATION=1
ENV WEB_AUTHENTICATION_USERNAME=grass
ENV WEB_AUTHENTICATION_PASSWORD=grass

RUN set-cont-env APP_NAME "Grass" && \
    set-cont-env APP_VERSION "5.2.2"

RUN apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests ca-certificates libayatana-appindicator3-1 libwebkit2gtk-4.1-0 libegl-dev inetutils-ping curl iproute2 dnsutils && \
    apt-get autoremove -y && \
    apt-get -y --purge autoremove && \
    rm -rf /var/lib/apt/lists/*

# --------------------------------------
#COPY --from=builder /grass/ /grass/


#RUN apt-get install -y --no-install-recommends --no-install-suggests inetutils-ping curl iproute2 dnsutils && \
#    apt-get autoremove -y && \
#    apt-get -y --purge autoremove && \
#    rm -rf /var/lib/apt/lists/*


RUN mkdir -p /grass

COPY startapp.sh /grass/startapp.sh
RUN chmod +x /grass/startapp.sh

COPY main-window-selection.jwmrc /grass/main-window-selection.jwmrc

ARG APP_URL=https://files.getgrass.io/file/grass-extension-upgrades/ubuntu-22.04/Grass_5.2.2_amd64.deb
RUN curl -sS -L ${APP_URL} -o /grass/grass.deb


# --------------------------------------


RUN mkdir -p /etc/jwm && \
    mv /grass/main-window-selection.jwmrc /etc/jwm/main-window-selection.jwmrc && \
    mv /grass/startapp.sh /startapp.sh && \
    #dpkg -i /grass/grass.deb && \
    #rm -rf /grass

#===================================================================================================================================
# name: 24.04-v4.7.1/apt-grass

#               ubuntu-24.04-v4.7.1   //   apt-get install -y /grass/grass.deb || (apt-get install -f -y) && 


#===================================================================================================================================




#FROM jlesage/baseimage-gui:ubuntu-22.04-v4.5.3 AS builder    
FROM jlesage/baseimage-gui:ubuntu-24.04-v4.7.1 AS builder
#FROM jlesage/baseimage-gui:ubuntu-24.04-v4.5.3 AS builder   #이미지 존재하지않음//없음

#FROM jlesage/baseimage-gui:ubuntu-24.04-v4 AS builder  #에러나타남 호환성 문제

#FROM jlesage/baseimage-gui:ubuntu-22.04-v4.7.1 AS builder   
#grass-로그인창 나옴!!!


RUN apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests ca-certificates curl

RUN mkdir -p /grass

COPY startapp.sh /grass/startapp.sh
RUN chmod +x /grass/startapp.sh

COPY run /grass/run
RUN chmod +x /grass/run


COPY main-window-selection.jwmrc /grass/main-window-selection.jwmrc

#ARG APP_URL=https://files.getgrass.io/file/grass-extension-upgrades/ubuntu-22.04/Grass_5.2.2_amd64.deb
#ARG APP_URL=https://files.getgrass.io/file/grass-extension-upgrades/ubuntu-22.04/Grass_5.1.1_amd64.deb
#ARG APP_URL=https://files.getgrass.io/file/grass-extension-upgrades/ubuntu-22.04/Grass_5.3.1_amd64.deb
#ARG APP_URL=https://files.grass.io/file/grass-extension-upgrades/v5.7.1/Grass_5.7.1_amd64.deb
#ARG APP_URL=https://files.grass.io/file/grass-extension-upgrades/v6.1.2/Grass_6.1.2_amd64.deb
#ARG APP_URL=https://files.grass.io/file/grass-extension-upgrades/v6.3.2/Grass_6.3.2_amd64.deb
#ARG APP_URL=https://files.grass.io/file/grass-extension-upgrades/v7.3.1/Grass_7.3.1_amd64.deb   #### 구동실패버젼

#ARG APP_URL=https://files.getgrass.io/file/grass-extension-upgrades/ubuntu-22.04/Grass_5.1.1_amd64.deb
#ARG APP_URL=https://files.grass.io/file/grass-extension-upgrades/v6.3.2/Grass_6.3.2_amd64.deb
ARG APP_URL=https://files.grass.io/file/grass-extension-upgrades/v7.4.4/grass-desktop_7.4.4_amd64.deb
            
# =========================================================================================================
RUN curl -sS -L ${APP_URL} -o /grass/grass.deb


#FROM jlesage/baseimage-gui:ubuntu-22.04-v4.5.3

# 2단계: 메인 실행 스테이지 (마찬가지로 ubuntu-24.04 기반으로 변경하여 GLIBC 2.39 확보)
FROM jlesage/baseimage-gui:ubuntu-24.04-v4.7.1

#FROM jlesage/baseimage-gui:ubuntu-24.04-v4


#FROM jlesage/baseimage-gui:ubuntu-22.04-v4.7.1
#LABEL org.opencontainers.image.authors="217heidai@gmail.com"

ENV KEEP_APP_RUNNING=1
# jlesage/baseimage-gui:ubuntu-22.04-v4.6 报错：Could not create surfaceless EGL display: EGL_NOT_INITIALIZED，待jlesage/baseimage-gui修复
# jlesage/baseimage-gui:ubuntu-22.04-v4.5 不支持 web auth
ENV SECURE_CONNECTION=1
ENV WEB_AUTHENTICATION=1
ENV WEB_AUTHENTICATION_USERNAME=grass
ENV WEB_AUTHENTICATION_PASSWORD=grass

RUN set-cont-env APP_NAME "Grass" && \
    set-cont-env APP_VERSION "7.4.4"
    
    #set-cont-env APP_VERSION "5.1.1"
    #set-cont-env APP_VERSION "6.3.2"
    
    #set-cont-env APP_VERSION "5.2.2"
    #set-cont-env APP_VERSION "5.1.1"
    #set-cont-env APP_VERSION "5.3.1"
    #set-cont-env APP_VERSION "5.7.1"
    #set-cont-env APP_VERSION "6.1.2"
    #set-cont-env APP_VERSION "scrot_5.1.1"
    #set-cont-env APP_VERSION "scrot_6.1.2"
    #set-cont-env APP_VERSION "6.3.2"


    
    # =========================================================================================================



    
# [수정/확인] apt-get 청소(rm -rf)는 아래에서 grass.deb 설치가 모두 끝난 후 한 번에 처리합니다.
#RUN apt-get update && \
    # [중요] dpkg 에러 방지를 위해 전처리로 messagebus 시스템 그룹 생성   //////////  7.4.4 전용
    #groupadd -r messagebus && \
    # dnsutils psmisc git iproute2
    #apt-get install -y --no-install-recommends --no-install-suggests ca-certificates libayatana-appindicator3-1 libwebkit2gtk-4.1-0 libwebkit2gtk-4.0-37 libegl-dev inetutils-ping curl xdotool wmctrl scrot nano


# [수정 완료] 줄바꿈(\) 연속선상에 있던 빈 라인 및 주석 배치 수정
RUN apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests ca-certificates libayatana-appindicator3-1 libwebkit2gtk-4.1-0 libegl-dev inetutils-ping curl xdotool wmctrl scrot nano

# libwebkit2gtk-4.0-37   >>  22.04 전용
    
COPY --from=builder /grass/ /grass/

RUN mv /grass/run /etc/services.d/nginx/run


# [교정 완료] 상대 경로 분기 오류 해결 및 캐시 정리 일원화
#RUN mkdir -p /etc/jwm && \
#    mv /grass/main-window-selection.jwmrc /etc/jwm/main-window-selection.jwmrc && \
#    mv /grass/startapp.sh /startapp.sh && \
#    # 절대 경로(/grass/grass.deb)로 명시하여 어디서든 파일 참조가 가능하게 변경
#    apt-get install -y /grass/grass.deb || (apt-get install -f -y) && \
#    # 설치가 완벽히 끝난 후 패키지 원본 및 불필요한 apt 인덱스 목록 삭제 (용량 최적화)
#    rm -rf /grass && \
#    apt-get autoremove -y && \
#    apt-get -y --purge autoremove && \
#    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/jwm && \
    mv /grass/main-window-selection.jwmrc /etc/jwm/main-window-selection.jwmrc && \
    mv /grass/startapp.sh /startapp.sh && \
    apt-get install -y /grass/grass.deb ; (apt-get install -f -y) && \
    rm -rf /grass && \
    apt-get autoremove -y && \
    apt-get -y --purge autoremove && \
    rm -rf /var/lib/apt/lists/*

# apt-get install -y /grass/grass.deb || (apt-get install -f -y) && \    



#COPY move_nginx.sh /move_nginx.sh
#RUN chmod +x /move_nginx

# 기본 명령
#ENTRYPOINT ["/move_nginx.sh"]

#CMD ["/bin/sh", "-c", "if [ -f /etc/services.d/nginx.disabled ]; then mv /etc/services.d/nginx.disabled /etc/services.d/nginx; fi && exec sleep infinity"]

#CMD ["/bin/sh", "-c", "ls /etc/services.d/nginx.disabled && mv /etc/services.d/nginx.disabled /etc/services.d/nginx"]

# CMD ["/bin/sh", "-c", "if [ -f /etc/services.d/nginx.disabled ]; then mv /etc/services.d/nginx.disabled /etc/services.d/nginx; fi && exec nginx -g 'daemon off;'"]
    

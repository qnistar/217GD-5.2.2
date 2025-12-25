#!/bin/bash
set -e


# 환경 변수 설정
export LANG=C.UTF-8
export LC_ALL=C.UTF-8
export DISPLAY=:99
export HOME=/config


# Xvfb 실행
Xvfb :99 -screen 0 1024x768x24 &

# Openbox 실행
openbox-session &


# GRASS 실행 (절대 경로)
/usr/bin/grass "$@"

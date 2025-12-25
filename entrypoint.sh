#!/bin/bash
set -e

# Xvfb 실행
Xvfb :99 -screen 0 1024x768x24 &

# Openbox 실행
openbox-session &


# GRASS 실행 (절대 경로)
/usr/bin/grass "$@"

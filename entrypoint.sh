#!/bin/bash
set -e


# 환경 변수 설정
export LANG=C.UTF-8
export LC_ALL=C.UTF-8
export DISPLAY=:99
export HOME=/config



# 4. 컨테이너 유지
echo "Container is running..."
tail -f /dev/null

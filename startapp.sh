#!/bin/sh
set -e

export LC_ALL=C
export HOME=/config
export DISPLAY=:99

Xvfb :99 -screen 0 1280x720x24 &
sleep 2

openbox &
sleep 1

exec /usr/bin/grass


#!/bin/bash
set -e

export LC_ALL=C
export HOME=/config

echo "[+] Starting Openbox"
openbox-session &

sleep 2

echo "[+] Starting Grass"
grass \
  --disable-gpu \
  --disable-software-rasterizer \
  --disable-extensions \
  --hide-scrollbars \
  --mute-audio \
  --no-sandbox &

sleep 5

echo "[+] Applying window rules"
 /wmctrl_retry.sh

echo "[+] Running..."
wait

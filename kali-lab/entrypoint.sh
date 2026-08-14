#!/bin/bash
set -e

mkdir -p /root/.vnc
echo "${VNC_PASSWORD:-changeme}" | vncpasswd -f > /root/.vnc/passwd
chmod 600 /root/.vnc/passwd

vncserver -kill :1 >/dev/null 2>&1 || true
rm -f /tmp/.X1-lock /tmp/.X11-unix/X1 2>/dev/null || true

vncserver :1 -geometry 1280x800 -depth 24

tail -f /root/.vnc/*.log

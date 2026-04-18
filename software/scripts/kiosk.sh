#!/bin/bash
# kiosk.sh — Launch tar1090 (or dashboard) fullscreen on the 7" touchscreen
#
# To use the custom dashboard instead, change the URL below to:
#   http://localhost:5000

KIOSK_URL="http://localhost/tar1090"

# Wait for dump1090 to be ready
sleep 15

# Disable screen blanking
xset s off
xset -dpms
xset s noblank

# Hide cursor after 3 seconds of inactivity
unclutter -idle 3 &

# Kill any existing Chromium instances
pkill -f chromium || true
sleep 2

# Launch Chromium in kiosk mode
chromium-browser \
  --noerrdialogs \
  --disable-infobars \
  --disable-session-crashed-bubble \
  --kiosk \
  --incognito \
  --disable-translate \
  --no-first-run \
  --start-fullscreen \
  --window-size=800,480 \
  --window-position=0,0 \
  "$KIOSK_URL"

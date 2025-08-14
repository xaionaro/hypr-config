#!/bin/sh

REQUESTED_WS=$1

MONITOR=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')

OFFSET=0
case "$MONITOR" in
    HDMI-A-2)
        OFFSET=0
        ;;
    DP-2)
        OFFSET=10
        ;;
    DP-3)
        OFFSET=20
        ;;
    HDMI-A-3)
        OFFSET=30
        ;;
esac 

echo "$(( REQUESTED_WS + OFFSET ))"
exit 0
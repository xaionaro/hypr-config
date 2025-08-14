#!/bin/sh

REQUESTED_WS=$1

WS_ID="$(/home/xaionaro/.config/hypr/scripts/GetMonitorWorkspaceID.sh "$REQUESTED_WS")"

exec hyprctl dispatch movetoworkspace "$WS_ID"

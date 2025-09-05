#!/bin/bash


while true; do
    swww img --outputs HDMI-A-3 "$HOME"/.dwm/particle_flares.png
    /usr/local/bin/mpvpaper -o 'input-ipc-server=/tmp/mpvpaper-back.sock --no-audio --loop=100' HDMI-A-3 "$HOME"/.dwm/particle_flares.mkv
done

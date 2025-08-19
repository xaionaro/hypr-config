#!/bin/bash

swww img --outputs HDMI-A-3 "$HOME"/.dwm/particle_flares.png

while true; do
    /usr/local/bin/mpvpaper -o 'input-ipc-server=/tmp/mpvpaper-back.sock --no-audio --loop=10' HDMI-A-3 "$HOME"/.dwm/particle_flares.mkv
done

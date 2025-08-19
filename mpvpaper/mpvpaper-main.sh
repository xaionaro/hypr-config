#!/bin/bash

WALLPAPERS_PATH="$HOME/.config/wallpapers"
OUTPUTS="DP-2,HDMI-A-2,DP-3"
TARGET_LENGTH=300

FILENAME_PREV=''
while true; do
    ( pgrep swww-daemon >/dev/null || swww-daemon --format xrgb &) &
    while true; do
        FILENAME="$(find "$WALLPAPERS_PATH"/*.mp4 -type f -print0 | shuf -z -n 1 | xargs -0 basename)"
        if [[ "$FILENAME" != "$FILENAME_PREV" ]]; then
            FILENAME_PREV="$FILENAME"
            break
        fi
    done
    FILEPATH="$WALLPAPERS_PATH"/"$FILENAME"
    if ! [[ -f "$FILEPATH.frame0.png" ]]; then
        ffmpeg -i "$FILEPATH" -frames:v 1 "$FILEPATH.frame0-pre.png"
        convert "$FILEPATH.frame0-pre.png" -resize 3840x2160 "$FILEPATH.frame0.png"
        rm -f "$FILEPATH.frame0-pre.png"
    fi
    swww img --transition-fps 10 --transition-duration 5 --transition-type fade --outputs "$OUTPUTS" "$FILEPATH.frame0.png"
    sleep 2 &
    if ! [[ -f "$FILEPATH.frame_eof.png" ]]; then
        ffmpeg -sseof -1 -i "$FILEPATH" -update 1 "$FILEPATH.frame_eof-pre.png"
        convert "$FILEPATH.frame_eof-pre.png" -resize 3840x2160 "$FILEPATH.frame_eof.png"
        rm -f "$FILEPATH.frame_eof-pre.png"
    fi
    if ! [[ -f "$FILEPATH.length" ]]; then
        ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$FILEPATH" > "$FILEPATH.length"
    fi
    FILE_LENGTH="$(cat "$FILEPATH.length")"
    REPEATS="$(echo "($TARGET_LENGTH + $FILE_LENGTH - 1) / $FILE_LENGTH" | bc)"
    wait
    (
        
        swww img --transition-type none --transition-duration 0 --outputs "$OUTPUTS" "$FILEPATH.frame_eof.png"
    ) &
    /usr/local/bin/mpvpaper -o "input-ipc-server=/tmp/mpvpaper-main.sock --no-audio --loop-playlist=$REPEATS" "$OUTPUTS" "$FILEPATH"
done

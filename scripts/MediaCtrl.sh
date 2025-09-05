#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Playerctl

music_icon="$HOME/.config/swaync/icons/music.png"

# Play the next track
play_next() {
    playerctl -p spotify next
    show_music_notification
}

# Play the previous track
play_previous() {
    playerctl -p spotify previous
    show_music_notification
}

# Toggle play/pause
toggle_play_pause() {
    playerctl -p spotify play-pause
    show_music_notification
}

# Stop playback
stop_playback() {
    playerctl -p spotify stop
    notify-send -e -u low -i $music_icon " Playback:" " Stopped"
}

# Display notification with song information
show_music_notification() {
    status=$(playerctl -p spotify status)
    if [[ "$status" == "Playing" ]]; then
        song_title=$(playerctl -p spotify metadata title)
        song_artist=$(playerctl -p spotify metadata artist)
        notify-send -e -u low -i $music_icon "Now Playing:" "$song_title by $song_artist"
    elif [[ "$status" == "Paused" ]]; then
        notify-send -e -u low -i $music_icon " Playback:" " Paused"
    fi
}

# Get media control action from command line argument
case "$1" in
    "--nxt")
        play_next
        ;;
    "--prv")
        play_previous
        ;;
    "--pause")
        toggle_play_pause
        ;;
    "--stop")
        stop_playback
        ;;
    *)
        echo "Usage: $0 [--nxt|--prv|--pause|--stop]"
        exit 1
        ;;
esac

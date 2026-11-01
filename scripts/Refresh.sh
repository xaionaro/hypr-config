#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Scripts for refreshing ags, waybar, rofi, swaync, wallust

SCRIPTSDIR=$HOME/.config/hypr/scripts
UserScripts=$HOME/.config/hypr/UserScripts

# Define file_exists function
file_exists() {
    if [ -e "$1" ]; then
        return 0  # File exists
    else
        return 1  # File does not exist
    fi
}

# Kill already running processes and their long-lived module children. Waybar
# custom modules (playerctl, swaync-client, cava) otherwise become orphans and
# survive every refresh.
kill_tree() {
    local root="$1"
    local child
    while read -r child; do
        [ -n "$child" ] && kill_tree "$child"
    done < <(pgrep -P "$root" 2>/dev/null || true)
    kill -TERM "$root" 2>/dev/null || true
}

_ps=(waybar rofi swaync ags)
for _prs in "${_ps[@]}"; do
    while read -r _pid; do
        [ -n "$_pid" ] && kill_tree "$_pid"
    done < <(pgrep -x "${_prs}" 2>/dev/null || true)
done

# added since wallust sometimes not applying
killall -SIGUSR2 waybar 

# quit ags & relaunch ags
#ags -q && ags &

# some process to kill
for pid in $(pidof waybar rofi swaync ags swaybg); do
    kill -SIGUSR1 "$pid"
done

#Restart waybar
sleep 1
waybar &

# relaunch swaync
sleep 0.5
swaync > /dev/null 2>&1 &
# reload swaync
swaync-client --reload-config

# Relaunching rainbow borders if the script exists
sleep 1
if file_exists "${UserScripts}/RainbowBorders.sh"; then
    ${UserScripts}/RainbowBorders.sh &
fi

exit 0

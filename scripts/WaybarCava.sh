#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Not my own work. This was added through Github PR. Credit to original author

#----- Optimized bars animation without much CPU usage increase --------
bar="▁▂▃▄▅▆▇█"
dict="s/;//g"

# Calculate the length of the bar outside the loop
bar_length=${#bar}

# Create dictionary to replace char with bar
for ((i = 0; i < bar_length; i++)); do
    dict+=";s/$i/${bar:$i:1}/g"
done

# Create a private cava config for this Waybar instance. Multiple bars run this
# script at once, so sharing one file and killing other cava processes races.
config_dir="${XDG_RUNTIME_DIR:-/tmp}"
config_file="$config_dir/waybar-cava-${PPID}.conf"
cleanup() {
    rm -f "$config_file"
}
trap cleanup EXIT INT TERM

cat >"$config_file" <<EOF
[general]
# Keep the animation smooth without making each Waybar bar wake up too often.
# Four Waybar bars run this module, so a lower rate noticeably reduces CPU.
# You can increase the value if you wish
framerate = 20
bars = 10

[input]
# Capture Spotify's PipeWire node directly. The default sink monitor also
# contains mpv, Firefox, and every other application playing audio.
method = pipewire
source = spotify

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
EOF

# Read stdout from cava and perform substitution in a single sed command
cava -p "$config_file" | sed -u "$dict"

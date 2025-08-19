#!/bin/bash

THRESHOLD_KB="$(( 1024 * 1024 ))"

ps --no-headers -C mpvpaper -o pid,rss= | \
while read -r PID RSS; do
	if [ "$RSS" -lt "$THRESHOLD_KB" ]; then
		continue
	fi
	MPVPAPER_SUFFIX=''
	if grep DP-2 /proc/"$PID"/cmdline; then
		MPVPAPER_SUFFIX='-main'
	else
		MPVPAPER_SUFFIX='-back'
	fi
	systemctl --user restart mpvpaper"$MPVPAPER_SUFFIX".service
done


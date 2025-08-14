#!/bin/bash

PID="$(hyprctl activewindow -j | jq '.pid')"
kill -9 "$PID"
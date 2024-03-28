#!/bin/bash

if tmux ls &>/dev/null; then
	kitty -e tmux attach
else
	kitty -e tmux
fi

#!/bin/bash

alacritty_output=$(alacritty msg create-window 2>/dev/null)

if [ -z "$alacritty_output" ]; then
  open /Applications/Alacritty.app
fi

#!/bin/bash

focus() {
	yabai -m space --focus "$1"
}

get_fs_displays() {
	yabai -m query --spaces | jq -c 'map(select(."is-native-fullscreen" == true))'
}

get_visible() {
	printf '%s' "$1" | jq -c 'map(select(."is-visible" == true))'
}

is_empty() {
	length="$(printf '%s' "$1" | jq 'length')"
	[ "$length" -le 0 ]
}

first() {
	printf '%s' "$1" | jq 'sort_by(.index) | .[0].index'
}

try_focus_visible() {
	# This should be at max length 1. Though this may likely break in a multimonitor environment
	visible_fullscreen_displays=$(get_visible "$1")

	if ! is_empty "$visible_fullscreen_displays"; then
		visible_index=$(printf '%s' "$visible_fullscreen_displays" | jq -c '.[0].index')
		next_index=$((visible_index + 1))
		if [ "$(printf '%s' "$fullscreen_displays" | jq "map(select(.index == $next_index)) | length")" -gt "0" ]; then
			focus "$next_index"
			return 0
		fi
	fi

	return 1
}

main() {
	fullscreen_displays="$(get_fs_displays)"

	is_empty "$fullscreen_displays" && focus 1 && return

	try_focus_visible "$fullscreen_displays" && return

	focus "$(first "$fullscreen_displays")"
}

main

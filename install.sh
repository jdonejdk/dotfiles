#!/bin/sh

set -e

if [ ! "$(command -v chzmoi)" ]; then
	bin_dir="$HOME/tools/bin"
	if [ "$(command -v curl)" ]; then
		sh -c "$(curl -fsSL https://git.io/chezmoi)"  -- -b "$bin_dir"
	else
		echo "To install chezmoi,you must have curl or wget installed." >&2
		exit 1
	fi
fi

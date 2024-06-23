#!/bin/sh

src="$(dirname "$0")"

# Symlink home directory files
for file in "$src"/.*; do
	[ "${file##*/}" = '.git' ] && continue

	if [ "$(file "$file")" = "$file: directory" ]; then
		case "${file##*/}" in
			# these directories have other programs that write to them,
			# so we create them if they don't exist
			# and symlink only what we want
			.config | .local)
				[ -d "$HOME/${file##*/}" ] || mkdir "$HOME/${file##*/}"
				for subfile in "$file"/*; do
					ln -s "$subfile" "$HOME/${file##*/}/${subfile##*/}"
				done
				;;
			*)
				ln -s "$file" "$HOME/${file##*/}"
				;;
		esac
	else
		ln -s "$file" "$HOME/${file##*/}"
	fi
done

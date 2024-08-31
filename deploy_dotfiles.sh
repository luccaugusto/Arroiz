#!/bin/sh

src="$(dirname "$0")"
if [ "$src" = '.' ]; then
	src="$PWD"
else
	src="$PWD/${src#*/}"
fi

create_symlink()
{
	origin="$1"
	destination_link="$2"

	if [ -e "$destination_link" ]; then
		[ -L "$destination_link" ] && echo "INFO: $destination_link already exists, skipping"
		[ ! -L "$destination_link" ] && echo "WARNING: $destination_link exists and is not a symlink, please check it manually"
	else
		ln -s "$origin" "$destination_link"
	fi
}

synchome()
{
	# Symlink home directory files
	for entry in "$src"/.*; do
		if [ "${entry##*/}" = '.git' ] || [ "${entry##*/}" = '.gitignore' ]; then
			continue
		fi

		if [ "$(file -b "$entry")" = "directory" ]; then
			case "${entry##*/}" in
				# these directories have other programs that write to them,
				# so we create them if they don't exist
				# and symlink only what we want
				.config | .local)
					[ -d "$HOME/${entry##*/}" ] || mkdir "$HOME/${entry##*/}"
					for subentry in "$entry"/*; do
						create_symlink "$subentry" "$HOME/${entry##*/}/${subentry##*/}"
					done
					;;
				*)
					create_symlink "$entry" "$HOME/${entry##*/}"
					;;
			esac
		else
			create_symlink "$entry" "$HOME/${entry##*/}"
		fi
	done
}

synchome

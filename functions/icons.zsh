#!/usr/bin/env zsh
# vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8
################################################################
# @title powerlevel9k Icon Functions
# @source https://github.com/bhilburn/powerlevel9k
##
# @authors
#   Ben Hilburn (bhilburn)
#   Dominik Ritter (dritter)
##
# @info
#   This file contains the core icon definitions and icon-functions.
#
#   These characters require the Powerline fonts to work properly. If you see
#   boxes or bizarre characters below, your fonts are not correctly installed. If
#   you do not want to install a special font, you can set `P9K_MODE` to
#   `compatible`. This shows all icons in regular symbols.
#
# For specific fonts configurations, please refer to:
# - [Awesome-Patched Font](https://github.com/gabrielelana/awesome-terminal-fonts/tree/patching-strategy/patched)
# - [fontconfig with awesome-font](https://github.com/gabrielelana/awesome-terminal-fonts)
# - [mapped fontconfig with awesome-font](https://github.com/gabrielelana/awesome-terminal-fonts) and don't forget
#   to source the font maps in your startup script
# - [nerd-font patched (complete)](https://github.com/ryanoasis/nerd-fonts) and the [cheat sheet](http://nerdfonts.com/#cheat-sheet)
# - [Powerline-Patched Font](https://github.com/Lokaltog/powerline-fonts)
##

# Set the right locale to protect special characters
local LC_ALL="" LC_CTYPE="en_US.UTF-8"
typeset -gAH icons

if [[ P9K_MODE == "awesome-mapped-fontconfig" && -z "$AWESOME_GLYPHS_LOADED" ]]; then
    echo "Powerlevel9k warning: Awesome-Font mappings have not been loaded.
    Source a font mapping in your shell config, per the Awesome-Font docs
    (https://github.com/gabrielelana/awesome-terminal-fonts),
    or use a different Powerlevel9k font configuration.";
fi

################################################################
# @description
#   This function allows a segment to register the icons that it
#   requires. It will check for icons overriden by the user first
#   and if found, will use those instead of the ones defined by
#   the segment.
##
# @args
#   $1 string Name of icon
#   $2 string Generic icon
#   $3 string Flat / Awesome Patched icon
#   $4 string Awesome FontConfig icon
#   $5 string Awesome Mapped FontConfig icon
#   $6 string NerdFont Complete / FontConfig icon
##
# @note
#   You can specify a string, unicode string or codepoint string (for Mapped fonts only).
##
# @usage
#   registerIcon "name_of_icon" 'Gen' $'\uXXX' $'\uXXX' '\u'$CODEPOINT_OF_AWESOME_xxx '\uXXX'
##
# @example
#   registerIcon "LOCK_ICON"  $'\UE0A2'  $'\UE138'  $'\UF023'  '\u'$CODEPOINT_OF_AWESOME_LOCK  $'\UF023'
##
function registerIcon() {
  local map
	local ICON_USER_VARIABLE=P9K_${1}
	if defined "$ICON_USER_VARIABLE"; then # check for icon override first
		map="${(P)ICON_USER_VARIABLE}"
	else # use the icons that are registered by the segment
    case $P9K_MODE in
    	'flat'|'awesome-patched')                   map=$3 ;;
    	'awesome-fontconfig')                       map=$4 ;;
    	'awesome-mapped-fontconfig')                map=$5 ;;
    	'nerdfont-complete'|'nerdfont-fontconfig')  map=$6 ;;
    	*)                                          map=$2 ;;
    esac
  fi
	icons[$1]=${map}
}

#                                                                                                                           
registerIcon "LEFT_SEGMENT_SEPARATOR"           $'\uE0B0'           $'\uE0B0'           $'\uE0B0'           $'\uE0B0'           $'\uE0B0'
#                                                                                                                           
registerIcon "RIGHT_SEGMENT_SEPARATOR"          $'\uE0B2'           $'\uE0B2'           $'\uE0B2'           $'\uE0B2'           $'\uE0B2'
#                                               Whitespace          Whitespace          Whitespace          Whitespace          Whitespace
registerIcon "LEFT_SEGMENT_END_SEPARATOR"       ' '                 ' '                 ' '                 ' '                 ' '
#                                                                                                                           
registerIcon "LEFT_SUBSEGMENT_SEPARATOR"        $'\uE0B1'           $'\uE0B1'           $'\uE0B1'           $'\uE0B1'           $'\uE0B1'
#                                                                                                                           
registerIcon "RIGHT_SUBSEGMENT_SEPARATOR"       $'\uE0B3'           $'\uE0B3'           $'\uE0B3'           $'\uE0B3'           $'\uE0B3'
#                                               ╭─                  ╭─                 ╭─                  ╭─                 ╭─
registerIcon "MULTILINE_FIRST_PROMPT_PREFIX"    $'\u256D'$'\U2500'  $'\u256D'$'\U2500'  $'\u256D'$'\U2500'  $'\u256D'$'\U2500'  $'\u256D'$'\U2500'
#                                               ├─                 ├─                  ├─                 ├─                  ├─
registerIcon "MULTILINE_NEWLINE_PROMPT_PREFIX"  $'\u251C'$'\U2500'  $'\u251C'$'\U2500'  $'\u251C'$'\U2500'  $'\u251C'$'\U2500'  $'\u251C'$'\U2500'
#                                               ╰─                 ╰─                  ╰─                 ╰─                  ╰─
registerIcon "MULTILINE_LAST_PROMPT_PREFIX"     $'\u2570'$'\U2500 ' $'\u2570'$'\U2500 ' $'\u2570'$'\U2500 ' $'\u2570'$'\U2500 ' $'\u2570'$'\U2500 '

# Override the above icon settings with any user-defined variables.
case $P9K_MODE in
	'flat')
		# Set the right locale to protect special characters
		local LC_ALL="" LC_CTYPE="en_US.UTF-8"
		icons[LEFT_SEGMENT_SEPARATOR]=''
		icons[RIGHT_SEGMENT_SEPARATOR]=''
		icons[LEFT_SUBSEGMENT_SEPARATOR]='|'
		icons[RIGHT_SUBSEGMENT_SEPARATOR]='|'
	;;
	'compatible')
		# Set the right locale to protect special characters
		local LC_ALL="" LC_CTYPE="en_US.UTF-8"
		icons[LEFT_SEGMENT_SEPARATOR]=$'\u2B80'                 # ⮀
		icons[RIGHT_SEGMENT_SEPARATOR]=$'\u2B82'                # ⮂
	;;
esac

################################################################
# @description
#   Prints the requested icon.
##
# @args
#   $1 string Name of icon
##
function printIcon() {
	echo -n "${icons[$1]}"
}

################################################################
# @description
#   Print all the configured icons alphabetically as KEY -> VALUE pairs.
##
# @noargs
##
showDefinedIcons() {
  for k v in ${(kv)icons}; do; echo "$k -> $v"; done | sort
}

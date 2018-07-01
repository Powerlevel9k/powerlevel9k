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
typeset -gAH p9k_data
typeset -gAH p9k_icons

if [[ P9K_MODE == "awesome-mapped-fontconfig" && -z "$AWESOME_GLYPHS_LOADED" ]]; then
    echo "Powerlevel9k warning: Awesome-Font mappings have not been loaded.
    Source a font mapping in your shell config, per the Awesome-Font docs
    (https://github.com/gabrielelana/awesome-terminal-fonts),
    or use a different Powerlevel9k font configuration.";
fi

################################################################
# @description
#   This function allows the core code to register the icons that it
#   requires. It will check for icons overriden by the user first,
#   and, if found, will use those instead of the ones defined by the
#   core code.
##
# @args
#   $1 string Icon name
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
#   registerIcon "LOCK_ICON"  $'\uE0A2'  $'\uE138'  $'\uF023'  '\u'$CODEPOINT_OF_AWESOME_LOCK  $'\uF023'
##
function registerIcon() {
  local map
	local ICON_USER_VARIABLE="P9K_${1}"
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
	p9k_icons[$1]=${map}
}

################################################################
# @description
#   This function allows a segment to register the colors and icons
#   that it requires. It will check for user icon / color overrides
#   first and, if found, will use those instead of the ones defined
#   by the segment.
##
# @args
#   $1 string Segment name
#   $2 string State name or ""
#   $3 misc Default background color
#   $4 misc Default foreground color
#   $5 string Generic icon
#   $6 string Flat / Awesome Patched icon
#   $7 string Awesome FontConfig icon
#   $8 string Awesome Mapped FontConfig icon
#   $9 string NerdFont Complete / FontConfig icon
##
# @note
#   You can specify a string, unicode string or codepoint string (for Mapped fonts only).
##
# @usage
#   registerSegment "segmentName" "stateNameOrEmpty" "backgroundColor" "foregroundColor" 'Gen' $'\uXXX' $'\uXXX' '\u'$CODEPOINT_OF_AWESOME_xxx '\uXXX'
##
# @example
#   registerSegment "DIR_WRITABLE" "" "red" "yellow1"  $'\uE0A2'  $'\uE138'  $'\uF023'  '\u'$CODEPOINT_OF_AWESOME_LOCK  $'\uF023'
##
function registerSegment() {
  local STATEFUL_NAME=${(U)1#PROMPT_}
  # add state if required
  [[ -n $2 ]] && STATEFUL_NAME=${STATEFUL_NAME}_${(U)2}
  [[ -z $3 ]] && 3=${DEFAULT_COLOR_INVERTED}
  [[ -z $4 ]] && 4=${DEFAULT_COLOR}

  local BG_USER_VARIABLE="P9K_${STATEFUL_NAME}_BACKGROUND"
  if defined "$BG_USER_VARIABLE"; then # check for background override first
    p9k_data[${STATEFUL_NAME}_BG]="$(backgroundColor ${(P)BG_USER_VARIABLE})"
  else
    p9k_data[${STATEFUL_NAME}_BG]="$(backgroundColor $3)"
  fi

  local FG_USER_VARIABLE="P9K_${STATEFUL_NAME}_FOREGROUND"
  if defined "$FG_USER_VARIABLE"; then # check for foreground override first
    p9k_data[${STATEFUL_NAME}_FG]="$(foregroundColor ${(P)FG_USER_VARIABLE})"
  else
    p9k_data[${STATEFUL_NAME}_FG]="$(foregroundColor $4)"
  fi

  local map
	local ICON_USER_VARIABLE="P9K_${STATEFUL_NAME}_ICON"
	if defined "$ICON_USER_VARIABLE"; then # check for icon override first
		map="${(P)ICON_USER_VARIABLE}"
	else # use the icons that are registered by the segment
    case $P9K_MODE in
    	'flat'|'awesome-patched')                   map=$6 ;;
    	'awesome-fontconfig')                       map=$7 ;;
    	'awesome-mapped-fontconfig')                map=$8 ;;
    	'nerdfont-complete'|'nerdfont-fontconfig')  map=$9 ;;
    	*)                                          map=$5 ;;
    esac
  fi
	p9k_icons[${STATEFUL_NAME}]=${map}

  local ICON_COLOR_VARIABLE="P9K_${STATEFUL_NAME}_ICON_COLOR"
  if defined "$ICON_COLOR_VARIABLE"; then
    p9k_data[${STATEFUL_NAME}_VI]="$(foregroundColor ${(P)ICON_COLOR_VARIABLE})"
  else
    p9k_data[${STATEFUL_NAME}_VI]=$p9k_data[${STATEFUL_NAME}_FG]
  fi

  # Overwrite given bold directive by user defined variable for this segment.
  local BOLD_USER_VARIABLE="P9K_${STATEFUL_NAME}_BOLD"
  local BOLD="${(P)BOLD_USER_VARIABLE}"
  [[ -z "${BOLD}" ]] || p9k_data[${STATEFUL_NAME}_BD]=true
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
registerIcon "MULTILINE_FIRST_PROMPT_PREFIX"    $'\u256D'$'\u2500'  $'\u256D'$'\u2500'  $'\u256D'$'\u2500'  $'\u256D'$'\u2500'  $'\u256D'$'\u2500'
#                                               ├─                 ├─                  ├─                 ├─                  ├─
registerIcon "MULTILINE_NEWLINE_PROMPT_PREFIX"  $'\u251C'$'\u2500'  $'\u251C'$'\u2500'  $'\u251C'$'\u2500'  $'\u251C'$'\u2500'  $'\u251C'$'\u2500'
#                                               ╰─                 ╰─                  ╰─                 ╰─                  ╰─
registerIcon "MULTILINE_LAST_PROMPT_PREFIX"     $'\u2570'$'\u2500 ' $'\u2570'$'\u2500 ' $'\u2570'$'\u2500 ' $'\u2570'$'\u2500 ' $'\u2570'$'\u2500 '

# Override the above icon settings with any user-defined variables.
case $P9K_MODE in
	'flat')
		# Set the right locale to protect special characters
		local LC_ALL="" LC_CTYPE="en_US.UTF-8"
		p9k_icons[LEFT_SEGMENT_SEPARATOR]=''
		p9k_icons[RIGHT_SEGMENT_SEPARATOR]=''
		p9k_icons[LEFT_SUBSEGMENT_SEPARATOR]='|'
		p9k_icons[RIGHT_SUBSEGMENT_SEPARATOR]='|'
	;;
	'compatible')
		# Set the right locale to protect special characters
		local LC_ALL="" LC_CTYPE="en_US.UTF-8"
		p9k_icons[LEFT_SEGMENT_SEPARATOR]=$'\u2B80'                 # ⮀
		p9k_icons[RIGHT_SEGMENT_SEPARATOR]=$'\u2B82'                # ⮂
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
	echo -n "${p9k_icons[$1]}"
}

################################################################
# @description
#   Print all the configured icons alphabetically as KEY -> VALUE pairs.
##
# @noargs
##
showDefinedIcons() {
  # changed (kv) to (k) in case there are empty keys, which causes the printing to be done wrong
  for k in ${(k)p9k_icons}; do; echo "$k -> '$p9k_icons[$k]'"; done | sort
}

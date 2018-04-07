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
#   This file contains some the core icon definitions and
#   icon-functions.
#
#   These characters require the Powerline fonts to work properly. If you see
#   boxes or bizarre characters below, your fonts are not correctly installed. If
#   you do not want to install a special font, you can set `P9K_MODE` to
#   `compatible`. This shows all icons in regular symbols.
##

typeset -gAH icons

################################################################
# @description
#   This function allows a segment to register the icons that it requires.
#   These icons may be overriden by the user later.
#   Arguments may be a direct call or an array.
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
registerIcon() {
  local map
  case $P9K_MODE in
  	'flat'|'awesome-patched')                   map=$3 ;;
  	'awesome-fontconfig')                       map=$4 ;;
  	'awesome-mapped-fontconfig')                map=$5 ;;
  	'nerdfont-complete'|'nerdfont-fontconfig')  map=$6 ;;
  	*)                                          map=$2 ;;
  esac
	icons[$1]=${map}
}

# Initialize the icon list according to the user's `P9K_MODE`.
typeset -gAH icons
case $P9K_MODE in
  'flat'|'awesome-patched')
    # Awesome-Patched Font required! See:
    # https://github.com/gabrielelana/awesome-terminal-fonts/tree/patching-strategy/patched
    # Set the right locale to protect special characters
    local LC_ALL="" LC_CTYPE="en_US.UTF-8"
    icons=(
      LEFT_SEGMENT_SEPARATOR         $'\uE0B0'              # 
      RIGHT_SEGMENT_SEPARATOR        $'\uE0B2'              # 
      LEFT_SEGMENT_END_SEPARATOR     ' '                    # Whitespace
      LEFT_SUBSEGMENT_SEPARATOR      $'\uE0B1'              # 
      RIGHT_SUBSEGMENT_SEPARATOR     $'\uE0B3'              # 
      MULTILINE_FIRST_PROMPT_PREFIX  $'\u256D'$'\U2500'     # ╭─
      MULTILINE_NEWLINE_PROMPT_PREFIX  $'\u251C'$'\U2500'   # ├─
      MULTILINE_LAST_PROMPT_PREFIX   $'\u2570'$'\U2500 '    # ╰─
    )
  ;;
  'awesome-fontconfig')
    # fontconfig with awesome-font required! See
    # https://github.com/gabrielelana/awesome-terminal-fonts
    # Set the right locale to protect special characters
    local LC_ALL="" LC_CTYPE="en_US.UTF-8"
    icons=(
      LEFT_SEGMENT_SEPARATOR         $'\uE0B0'              # 
      RIGHT_SEGMENT_SEPARATOR        $'\uE0B2'              # 
      LEFT_SEGMENT_END_SEPARATOR     ' '                    # Whitespace
      LEFT_SUBSEGMENT_SEPARATOR      $'\uE0B1'              # 
      RIGHT_SUBSEGMENT_SEPARATOR     $'\uE0B3'              # 
      MULTILINE_FIRST_PROMPT_PREFIX  $'\u256D'$'\U2500'     # ╭─
      MULTILINE_NEWLINE_PROMPT_PREFIX  $'\u251C'$'\U2500'   # ├─
      MULTILINE_LAST_PROMPT_PREFIX   $'\u2570'$'\U2500 '    # ╰─
    )
  ;;
  'awesome-mapped-fontconfig')
    # mapped fontconfig with awesome-font required! See
    # https://github.com/gabrielelana/awesome-terminal-fonts
    # don't forget to source the font maps in your startup script
    # Set the right locale to protect special characters
    local LC_ALL="" LC_CTYPE="en_US.UTF-8"

    if [ -z "$AWESOME_GLYPHS_LOADED" ]; then
        echo "Powerlevel9k warning: Awesome-Font mappings have not been loaded.
        Source a font mapping in your shell config, per the Awesome-Font docs
        (https://github.com/gabrielelana/awesome-terminal-fonts),
        Or use a different Powerlevel9k font configuration.";
    fi

    icons=(
      LEFT_SEGMENT_SEPARATOR         $'\uE0B0'              # 
      RIGHT_SEGMENT_SEPARATOR        $'\uE0B2'              # 
      LEFT_SEGMENT_END_SEPARATOR     ' '                    # Whitespace
      LEFT_SUBSEGMENT_SEPARATOR      $'\uE0B1'              # 
      RIGHT_SUBSEGMENT_SEPARATOR     $'\uE0B3'              # 
      MULTILINE_FIRST_PROMPT_PREFIX  $'\u256D'$'\U2500'     # ╭─
      MULTILINE_NEWLINE_PROMPT_PREFIX  $'\u251C'$'\U2500'   # ├─
      MULTILINE_LAST_PROMPT_PREFIX   $'\u2570'$'\U2500 '    # ╰─
    )
  ;;
  'nerdfont-complete'|'nerdfont-fontconfig')
    # nerd-font patched (complete) font required! See
    # https://github.com/ryanoasis/nerd-fonts
    # http://nerdfonts.com/#cheat-sheet
    # Set the right locale to protect special characters
    local LC_ALL="" LC_CTYPE="en_US.UTF-8"
    icons=(
      LEFT_SEGMENT_SEPARATOR         $'\uE0B0'              # 
      RIGHT_SEGMENT_SEPARATOR        $'\uE0B2'              # 
      LEFT_SEGMENT_END_SEPARATOR     ' '                    # Whitespace
      LEFT_SUBSEGMENT_SEPARATOR      $'\uE0B1'              # 
      RIGHT_SUBSEGMENT_SEPARATOR     $'\uE0B3'              # 
      MULTILINE_FIRST_PROMPT_PREFIX  $'\u256D'$'\U2500'     # ╭─
      MULTILINE_NEWLINE_PROMPT_PREFIX  $'\u251C'$'\U2500'   # ├─
      MULTILINE_LAST_PROMPT_PREFIX   $'\u2570'$'\U2500 '    # ╰─
    )
  ;;
  *)
    # Powerline-Patched Font required!
    # See https://github.com/Lokaltog/powerline-fonts
    # Set the right locale to protect special characters
    local LC_ALL="" LC_CTYPE="en_US.UTF-8"
    icons=(
      LEFT_SEGMENT_SEPARATOR         $'\uE0B0'              # 
      RIGHT_SEGMENT_SEPARATOR        $'\uE0B2'              # 
      LEFT_SEGMENT_END_SEPARATOR     ' '                    # Whitespace
      LEFT_SUBSEGMENT_SEPARATOR      $'\uE0B1'              # 
      RIGHT_SUBSEGMENT_SEPARATOR     $'\uE0B3'              # 
      MULTILINE_FIRST_PROMPT_PREFIX  $'\u256D'$'\U2500'     # ╭─
      MULTILINE_NEWLINE_PROMPT_PREFIX  $'\u251C'$'\U2500'   # ├─
      MULTILINE_LAST_PROMPT_PREFIX   $'\u2570'$'\U2500 '    # ╰─
    )
  ;;
esac

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

# Hide branch icon if user wants it hidden
[[ "$P9K_HIDE_BRANCH_ICON" == true ]] && icons[VCS_BRANCH_ICON]=''

################################################################
# @description
#   Safety function for printing icons. Prints the named icon,
#   or if that icon is undefined, the string name.
##
# @args
#   $1 string Name of icon
##
function printIcon() {
	local icon_name=$1
	local ICON_USER_VARIABLE=P9K_${icon_name}
	if defined "$ICON_USER_VARIABLE"; then
		echo -n "${(P)ICON_USER_VARIABLE}"
	else
		echo -n "${icons[$icon_name]}"
	fi
}

# Get a list of configured icons
#   * $1 string - If "original", then the original icons are printed,
#                 otherwise "printIcon" is used, which takes the users
#                 overrides into account.
get_icon_names() {
	# Iterate over a ordered list of keys of the icons array
	for key in ${(@kon)icons}; do
		echo -n "P9K_$key: "
		if [[ "${1}" == "original" ]]; then
			# print the original icons as they are defined in the array above
			echo "${icons[$key]}"
		else
			# print the icons as they are configured by the user
			echo "$(printIcon "$key")"
		fi
	done
}

#!/usr/bin/env zsh
# vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8
################################################################
# @title powerlevel9k Icon Functions
# @source [powerlevel9k](https://github.com/bhilburn/powerlevel9k)
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

typeset -gAH __P9K_ICONS

if [[ "${P9K_MODE}" == "awesome-mapped-fontconfig" && -z "${AWESOME_GLYPHS_LOADED}" ]]; then
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
#   p9k::register_icon "name_of_icon" 'Gen' $'\uXXX' $'\uXXX' '\u'${CODEPOINT_OF_AWESOME_xxx} '\uXXX'
##
# @example
#   p9k::register_icon "LOCK_ICON"  $'\uE0A2'  $'\uE138'  $'\uF023'  '\u'${CODEPOINT_OF_AWESOME_LOCK}  $'\uF023'
##
function p9k::register_icon() {
  local map
  local ICON_USER_VARIABLE="P9K_${1}_ICON"
  if p9k::defined "${ICON_USER_VARIABLE}"; then # check for icon override first
    map="${(P)ICON_USER_VARIABLE}"
  else # use the icons that are registered by the segment
    case ${P9K_MODE} in
      'flat'|'awesome-patched')                   map=$3 ;;
      'awesome-fontconfig')                       map=$4 ;;
      'awesome-mapped-fontconfig')                map=$5 ;;
      'nerdfont-complete'|'nerdfont-fontconfig')  map=$6 ;;
      *)                                          map=$2 ;;
    esac
  fi
  __P9K_ICONS[$1]=${map}
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
#   p9k::register_segment "segmentName" "stateNameOrEmpty" "p9k::background_color" "p9k::foreground_color" 'Gen' $'\uXXX' $'\uXXX' '\u'${CODEPOINT_OF_AWESOME_xxx} '\uXXX'
##
# @example
#   p9k::register_segment "DIR_WRITABLE" "" "red" "yellow1"  $'\uE0A2'  $'\uE138'  $'\uF023'  '\u'${CODEPOINT_OF_AWESOME_LOCK}  $'\uF023'
##
function p9k::register_segment() {
  local STATEFUL_NAME=${(U)1#PROMPT_}
  # add state if required
  [[ -n $2 ]] && STATEFUL_NAME=${STATEFUL_NAME}_${(U)2}
  [[ -z $3 ]] && 3=${DEFAULT_COLOR_INVERTED}
  [[ -z $4 ]] && 4=${DEFAULT_COLOR}

  local BG_USER_VARIABLE="P9K_${STATEFUL_NAME}_BACKGROUND"
  if p9k::defined "${BG_USER_VARIABLE}"; then # check for background override first
    __P9K_DATA[${STATEFUL_NAME}_BG]="$(p9k::background_color ${(P)BG_USER_VARIABLE})"
  else
    __P9K_DATA[${STATEFUL_NAME}_BG]="$(p9k::background_color $3)"
  fi

  local FG_USER_VARIABLE="P9K_${STATEFUL_NAME}_FOREGROUND"
  if p9k::defined "${FG_USER_VARIABLE}"; then # check for foreground override first
    __P9K_DATA[${STATEFUL_NAME}_FG]="$(p9k::foreground_color ${(P)FG_USER_VARIABLE})"
  else
    __P9K_DATA[${STATEFUL_NAME}_FG]="$(p9k::foreground_color $4)"
  fi

  p9k::register_icon "${STATEFUL_NAME}" "${5}" "${6}" "${7}" "${8}" "${9}"

  local ICON_COLOR_VARIABLE="P9K_${STATEFUL_NAME}_ICON_COLOR"
  if p9k::defined "${ICON_COLOR_VARIABLE}"; then
    __P9K_DATA[${STATEFUL_NAME}_VI]="$(p9k::foreground_color ${(P)ICON_COLOR_VARIABLE})"
  else
    __P9K_DATA[${STATEFUL_NAME}_VI]=${__P9K_DATA[${STATEFUL_NAME}_FG]}
  fi

  # Left whitespace of left segments
  __P9K_DATA[${STATEFUL_NAME}_LEFT_LEFT_WHITESPACE]=$(p9k::find_first_defined P9K_${STATEFUL_NAME}_LEFT_WHITESPACE \
    P9K_LEFT_WHITESPACE_OF_LEFT_SEGMENTS P9K_WHITESPACE_BETWEEN_LEFT_SEGMENTS)
  # Middle whitespace of left segments
  __P9K_DATA[${STATEFUL_NAME}_LEFT_MIDDLE_WHITESPACE]=$(p9k::find_first_defined P9K_${STATEFUL_NAME}_MIDDLE_WHITESPACE \
    P9K_MIDDLE_WHITESPACE_OF_LEFT_SEGMENTS)
  # Right whitespace of left segments
  __P9K_DATA[${STATEFUL_NAME}_LEFT_RIGHT_WHITESPACE]=$(p9k::find_first_defined P9K_${STATEFUL_NAME}_RIGHT_WHITESPACE \
    P9K_RIGHT_WHITESPACE_OF_LEFT_SEGMENTS P9K_WHITESPACE_BETWEEN_LEFT_SEGMENTS)

  # Left whitespace of right segments
  __P9K_DATA[${STATEFUL_NAME}_RIGHT_LEFT_WHITESPACE]=$(p9k::find_first_defined P9K_${STATEFUL_NAME}_LEFT_WHITESPACE \
    P9K_LEFT_WHITESPACE_OF_RIGHT_SEGMENTS P9K_WHITESPACE_BETWEEN_RIGHT_SEGMENTS)
  # Middle whitespace of right segments
  __P9K_DATA[${STATEFUL_NAME}_RIGHT_MIDDLE_WHITESPACE]=$(p9k::find_first_defined P9K_${STATEFUL_NAME}_MIDDLE_WHITESPACE \
    P9K_MIDDLE_WHITESPACE_OF_RIGHT_SEGMENTS)
  # Right whitespace of right segments
  __P9K_DATA[${STATEFUL_NAME}_RIGHT_RIGHT_WHITESPACE]=$(p9k::find_first_defined P9K_${STATEFUL_NAME}_RIGHT_WHITESPACE \
    P9K_RIGHT_WHITESPACE_OF_RIGHT_SEGMENTS P9K_WHITESPACE_BETWEEN_RIGHT_SEGMENTS)

  # First and last whitespaces. This should always win over segment specific configuration
  local first_ws="${__P9K_DATA[${STATEFUL_NAME}_LEFT_LEFT_WHITESPACE]}"
  __P9K_DATA[FIRST_WHITESPACE]=$(p9k::find_first_defined P9K_LEFT_PROMPT_FIRST_SEGMENT_START_WHITESPACE first_ws)
  local last_ws="${__P9K_DATA[${STATEFUL_NAME}_RIGHT_RIGHT_WHITESPACE]}"
  __P9K_DATA[LAST_WHITESPACE]=$(p9k::find_first_defined P9K_RIGHT_PROMPT_LAST_SEGMENT_END_WHITESPACE last_ws)

  # Overwrite given bold directive by user defined variable for this segment.
  local BOLD_USER_VARIABLE="P9K_${STATEFUL_NAME}_BOLD"
  local BOLD="${(P)BOLD_USER_VARIABLE}"
  [[ -z "${BOLD}" ]] || __P9K_DATA[${STATEFUL_NAME}_BD]=true
}

(){
  # Set the right locale to protect special characters
  local LC_ALL="" LC_CTYPE="en_US.UTF-8"
  #                                                                                                                                
  p9k::register_icon "LEFT_SEGMENT_SEPARATOR"           $'\uE0B0'           $'\uE0B0'           $'\uE0B0'           $'\uE0B0'           $'\uE0B0'
  #                                                                                                                                
  p9k::register_icon "RIGHT_SEGMENT_SEPARATOR"          $'\uE0B2'           $'\uE0B2'           $'\uE0B2'           $'\uE0B2'           $'\uE0B2'
  #                                                    Whitespace          Whitespace          Whitespace          Whitespace          Whitespace
  p9k::register_icon "LEFT_SEGMENT_END_SEPARATOR"       ' '                 ' '                 ' '                 ' '                 ' '
  #                                                                                                                                
  p9k::register_icon "LEFT_SUBSEGMENT_SEPARATOR"        $'\uE0B1'           $'\uE0B1'           $'\uE0B1'           $'\uE0B1'           $'\uE0B1'
  #                                                                                                                                
  p9k::register_icon "RIGHT_SUBSEGMENT_SEPARATOR"       $'\uE0B3'           $'\uE0B3'           $'\uE0B3'           $'\uE0B3'           $'\uE0B3'
  #                                                    ╭─                  ╭─                 ╭─                  ╭─                 ╭─
  p9k::register_icon "MULTILINE_FIRST_PROMPT_PREFIX"    $'\u256D'$'\u2500'  $'\u256D'$'\u2500'  $'\u256D'$'\u2500'  $'\u256D'$'\u2500'  $'\u256D'$'\u2500'
  #                                                    ├─                 ├─                  ├─                 ├─                  ├─
  p9k::register_icon "MULTILINE_NEWLINE_PROMPT_PREFIX"  $'\u251C'$'\u2500'  $'\u251C'$'\u2500'  $'\u251C'$'\u2500'  $'\u251C'$'\u2500'  $'\u251C'$'\u2500'
  #                                                    ╰─                 ╰─                  ╰─                 ╰─                  ╰─
  p9k::register_icon "MULTILINE_LAST_PROMPT_PREFIX"     $'\u2570'$'\u2500 ' $'\u2570'$'\u2500 ' $'\u2570'$'\u2500 ' $'\u2570'$'\u2500 ' $'\u2570'$'\u2500 '

  # Override the above icon settings with any user-defined variables.
  case ${P9K_MODE} in
    'flat')
      # Set the right locale to protect special characters
      local LC_ALL="" LC_CTYPE="en_US.UTF-8"
      __P9K_ICONS[LEFT_SEGMENT_SEPARATOR]=''
      __P9K_ICONS[RIGHT_SEGMENT_SEPARATOR]=''
      __P9K_ICONS[LEFT_SUBSEGMENT_SEPARATOR]='|'
      __P9K_ICONS[RIGHT_SUBSEGMENT_SEPARATOR]='|'
    ;;
    'compatible')
      # Set the right locale to protect special characters
      local LC_ALL="" LC_CTYPE="en_US.UTF-8"
      __P9K_ICONS[LEFT_SEGMENT_SEPARATOR]=$'\u2B80'                 # ⮀
      __P9K_ICONS[RIGHT_SEGMENT_SEPARATOR]=$'\u2B82'                # ⮂
    ;;
  esac
}

################################################################
# @description
#   Prints the requested icon.
##
# @args
#   $1 string Name of icon
##
function p9k::print_icon() {
  echo -n "${__P9K_ICONS[$1]}"
}

################################################################
# @description
#   Print all the configured icons alphabetically as KEY -> VALUE pairs.
##
# @noargs
##
function show_defined_icons() {
  # changed (kv) to (k) in case there are empty keys, which causes the printing to be done wrong
  print "You can copy these variables to your ~/.zshrc and modify them to your needs."
  print -P "Know that the variable definition %F{red}must be written before the theme is sourced%f!"
  print
  for k in ${(k)__P9K_ICONS}; do; echo "P9K_${k}_ICON -> '${__P9K_ICONS[$k]}'"; done | sort
}

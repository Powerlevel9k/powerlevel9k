#!/usr/bin/env zsh
# vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8
################################################################
# @title powerlevel9k Utility Functions
# @source https://github.com/bhilburn/powerlevel9k
##
# @authors
#   Ben Hilburn (bhilburn)
#   Dominik Ritter (dritter)
##
# @info
#   This file contains various utility functions for
#   the powerlevel9k ZSH theme.
#
#   It also contains the core icon definitions and icon-functions.
#
#   These characters require the Powerline fonts to work properly. If you see
#   boxes or bizarre characters below, your fonts are not correctly installed. If
#   you do not want to install a special font, you can set `P9K_MODE` to
#   `compatible`. This shows all icons in regular symbols.
#
#   For specific fonts configurations, please refer to:
#   - [Awesome-Patched Font](https://github.com/gabrielelana/awesome-terminal-fonts/tree/patching-strategy/patched)
#   - [fontconfig with awesome-font](https://github.com/gabrielelana/awesome-terminal-fonts)
#   - [mapped fontconfig with awesome-font](https://github.com/gabrielelana/awesome-terminal-fonts) and don't forget
#     to source the font maps in your startup script
#   - [nerd-font patched (complete)](https://github.com/ryanoasis/nerd-fonts) and the [cheat sheet](http://nerdfonts.com/#cheat-sheet)
#   - [Powerline-Patched Font](https://github.com/Lokaltog/powerline-fonts)
##

# Set the right locale to protect special characters
local LC_ALL="" LC_CTYPE="en_US.UTF-8"

###############################################################
# description
#   Determine the OS and version (if applicable).
case $(uname) in
  Darwin) OS='OSX' ;;
  CYGWIN_NT-*) OS='Windows' ;;
  FreeBSD|OpenBSD|DragonFly) OS='BSD' ;;
  Linux)
    OS='Linux'
    OS_ID="$(grep -E '^ID=([a-zA-Z]*)' /etc/os-release | cut -d '=' -f 2)"
    case $(uname -o 2>/dev/null) in
      Android) OS='Android' ;;
    esac
  ;;
  SunOS) OS='Solaris' ;;
esac

################################################################
# description
#   Identify Terminal Emulator.
##
#   Find out which emulator is being used for terminal specific options
#   The testing order is important, since some override others.
if [[ "$TMUX" =~ "tmux" ]]; then
  readonly TERMINAL="tmux"
elif [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
  readonly TERMINAL="iterm"
elif [[ "$TERM_PROGRAM" == "Apple_Terminal" ]]; then
  readonly TERMINAL="appleterm"
else
  if [[ "$OS" == "OSX" ]]; then
    local termtest=$(ps -o 'command=' -p $(ps -o 'ppid=' -p $$) | tail -1 | awk '{print $NF}')
    # test if we are in a sudo su -
    if [[ $termtest == "-" || $termtest == "root" ]]; then
      termtest=($(ps -o 'command=' -p $(ps -o 'ppid=' -p $(ps -o 'ppid='$$))))
      termtest=$(basename $termtest[1])
    fi
  else
    local termtest=$(ps -o 'cmd=' -p $(ps -o 'ppid=' -p $$) | tail -1 | awk '{print $NF}')
    # test if we are in a sudo su -
    if [[ $termtest == "-" || $termtest == "root" ]]; then
      termtest=($(ps -o 'cmd=' -p $(ps -o 'ppid=' $(ps -o 'ppid='$$))))
      if [[ $termtest[1] == "zsh" ]]; then  # gnome terminal works differently than the rest... sigh
        termtest=$termtest[-1]
      elif [[ $termtest[1] =~ "python" ]]; then   # as does guake
        termtest=$termtest[3]
      else
        termtest=$termtest[1]
      fi
    fi
  fi
  case "${termtest##*/}" in
    gnome-terminal-server)    readonly TERMINAL="gnometerm";;
    guake.main)               readonly TERMINAL="guake";;
    iTerm2)                   readonly TERMINAL="iterm";;
    konsole)                  readonly TERMINAL="konsole";;
    termite)                  readonly TERMINAL="termite";;
    urxvt)                    readonly TERMINAL="rxvt";;
    yakuake)                  readonly TERMINAL="yakuake";;
    xterm | xterm-256color)   readonly TERMINAL="xterm";;
    *tty*)                    readonly TERMINAL="tty";;
    *)                        readonly TERMINAL=${termtest##*/};;
  esac

  unset termtest
  unset uname
fi

###############################################################
# @description
#   This function determines if POWERLEVEL9K_ variables have
#   been previously defined and changes them to P9K_ variables.
##
# @noargs
##
updateEnvironmentVars() {
  local envVar var varName origVar newVar newVal
  local oldVarsFound=false
  for envVar in $(declare); do
    if [[ "${envVar}" =~ "POWERLEVEL9K_" ]]; then
      oldVarsFound=true
      var="$(declare -p ${envVar})"
      varName="${${var##*POWERLEVEL9K_}%=*}"
      origVar="POWERLEVEL9K_${varName}"
      newVar="P9K_${varName}"
      if [[ "${var[13]}" == "a" ]]; then # array variable
        newVal="${${var##*\(}%\)*}"
        case "${(U)varName}" in
          BATTERY_LEVEL_BACKGROUND) typeset -g -a P9K_BATTERY_LEVEL_BACKGROUND=(${(s: :)newVal});;
          BATTERY_STAGES)
            local newVal="${${(P)origVar}//\'/}"
            typeset -g -a P9K_BATTERY_STAGES=( ${(s: :)newVal} )
          ;;
          LEFT_PROMPT_ELEMENTS)     typeset -g -a P9K_LEFT_PROMPT_ELEMENTS=(${(s: :)newVal});;
          RIGHT_PROMPT_ELEMENTS)    typeset -g -a P9K_RIGHT_PROMPT_ELEMENTS=(${(s: :)newVal});;
        esac
      else
        newVal="${(P)origVar}"
        typeset -g $newVar=$newVal
      fi
      unset "${origVar}"
    fi
  done
  [[ $P9K_IGNORE_VAR_WARNING == true ]] && oldVarsFound=false # disable warning if user sets P9K_IGNORE_VAR_WARNING to true.
  [[ $oldVarsFound == true ]] && print -P "%F{yellow}Information!%f As of this update, the %F{cyan}POWERLEVEL9K_*%f variables have been replaced by %F{cyan}P9K_*%f.
  Variables are been converted automatically, but there may still be some errors. For more informations, have a look at the CHANGELOG.md.
  To disable this warning, please modify your configuration file to use the new style variables, or add %F{green}P9K_IGNORE_VAR_WARNING=true%f to your config."
}

updateEnvironmentVars

###############################################################
# @description
#   This function determines if a variable has been previously
#   defined, even if empty.
##
# @args
#   $1 string The name of the variable that should be checked.
##
# @returns
#   0 if the variable has been defined.
##
function defined() {
  local varname="$1"

  typeset -p "$varname" > /dev/null 2>&1
}

###############################################################
# @description
#   This function determine if a variable has been previously defined,
#   and only sets the value to the specified default if it hasn't.
##
# @args
#   $1 string The name of the variable that should be checked.
#   $2 string The default value
##
# @returns
#   Nothing.
##
# @note
#   Typeset cannot set the value for an array, so this will only work
#   for scalar values.
##
function setDefault() {
  local varname="$1"
  local default_value="$2"

  defined "$varname" || typeset -g "$varname"="$default_value"
}

###############################################################
# @description
#   Converts large memory values into a human-readable unit (e.g., bytes --> GB)
##
# @args
#   $1 integer Size - The number which should be prettified.
#   $2 string Base - The base of the number (default Bytes).
##
# @note
#   The base can be any of the following: B, K, M, G, T, P, E, Z, Y.
##
printSizeHumanReadable() {
  typeset -F 2 size
  size="$1"+0.00001
  local extension
  extension=('B' 'K' 'M' 'G' 'T' 'P' 'E' 'Z' 'Y')
  local index=1

  # if the base is not Bytes
  if [[ -n $2 ]]; then
    local idx
    for idx in "${extension[@]}"; do
      if [[ "$2" == "$idx" ]]; then
        break
      fi
      index=$(( index + 1 ))
    done
  fi

  while (( (size / 1024) > 0.1 )); do
    size=$(( size / 1024 ))
    index=$(( index + 1 ))
  done

  echo "$size${extension[$index]}"
}

###############################################################
# @description
#   Gets the first value out of a list of items that is not empty.
#   The items are examined by a callback-function.
##
# @args
#   $1 array A list of items.
#   $2 string A callback function to examine if the item is worthy.
##
# @notes
#   The callback function has access to the inner variable $item.
##
function getRelevantItem() {
  local -a list
  local callback
  # Explicitly split the elements by whitespace.
  list=(${=1})
  callback=$2

  for item in $list; do
    # The first non-empty item wins
    try=$(eval "$callback")
    if [[ -n "$try" ]]; then
      echo "$try"
      break;
    fi
  done
}

###############################################################
# description
#   Determines the correct sed parameter.
##
# noargs
##
# note
#   `sed` is unfortunately not consistent across OSes when it comes to flags.
##
SED_EXTENDED_REGEX_PARAMETER="-r"
if [[ "$OS" == 'OSX' ]]; then
  local IS_BSD_SED="$(sed --version &>> /dev/null || echo "BSD sed")"
  if [[ -n "$IS_BSD_SED" ]]; then
    SED_EXTENDED_REGEX_PARAMETER="-E"
  fi
fi

# Combine the PROMPT_ELEMENTS
typeset -gU P9K_PROMPT_ELEMENTS
P9K_PROMPT_ELEMENTS=("${P9K_LEFT_PROMPT_ELEMENTS[@]}" "${P9K_RIGHT_PROMPT_ELEMENTS[@]}")

###############################################################
# @description
#   Determine if the passed segment is used in either the LEFT or
#   RIGHT prompt arrays.
##
# @args
#   $1 string The segment to be tested.
##
segmentInUse() {
  local key="${1}"
  [[ -n "${P9K_PROMPT_ELEMENTS[(r)$key]}" ]] && return 0
  # Check for joined segments
  key="${key}_joined"
  [[ -n "${P9K_PROMPT_ELEMENTS[(r)$key]}" ]] && return 0
  # Default: not found
  return 1
}

###############################################################
# @description
#   Print a deprecation warning if an old segment is in use.
# @args
#   $1 associative-array An associative array that contains the
#   deprecated segments as keys, and the new segment names as values.
##
printDeprecationWarning() {
  typeset -AH raw_deprecated_segments
  raw_deprecated_segments=(${(kvP@)1})

  for key in ${(@k)raw_deprecated_segments}; do
    if segmentInUse $key; then
      # segment is deprecated
      print -P "%F{yellow}Warning!%f The '$key' segment is deprecated. Use '%F{blue}${raw_deprecated_segments[$key]}%f' instead. For more informations, have a look at the CHANGELOG.md."
    fi
  done
}

###############################################################
# @description
#   A helper function to determine if a segment should be
#   joined or promoted to a full one.
##
# @args
#   $1 integer The array index of the current segment.
#   $2 integer The array index of the last printed segment.
#   $3 array The array of segments of the left or right prompt.
##
function segmentShouldBeJoined() {
  local current_index=$1
  local last_segment_index=$2
  # Explicitly split the elements by whitespace.
  local -a elements
  elements=(${=3})

  local current_segment=${elements[$current_index]}
  local joined=false
  if [[ ${current_segment[-7,-1]} == '_joined' ]]; then
    joined=true
    # promote segment to a full one, if the predecessing full segment
    # was conditional. So this can only be the case for segments that
    # are not our direct predecessor.
    if (( $(($current_index - $last_segment_index)) > 1)); then
      # Now we have to examine every previous segment, until we reach
      # the last printed one (found by its index). This is relevant if
      # all previous segments are joined. Then we want to join our
      # segment as well.
      local examined_index=$((current_index - 1))
      while (( $examined_index > $last_segment_index )); do
        local previous_segment=${elements[$examined_index]}
        # If one of the examined segments is not joined, then we know
        # that the current segment should not be joined, as the target
        # segment is the wrong one.
        if [[ ${previous_segment[-7,-1]} != '_joined' ]]; then
          joined=false
          break
        fi
        examined_index=$((examined_index - 1))
      done
    fi
  fi

  # Return 1 means error; return 0 means no error. So we have
  # to invert $joined
  if [[ "$joined" == "true" ]]; then
    return 0
  else
    return 1
  fi
}

###############################################################
# @description
#   A helper function to determine if a segment should be
#   printed or not.
#
#   Conditions have three layers:
#     1. No segment should print if they provide no
#        content (default condition).
#     2. Segments can define a default condition on
#        their own, overriding the previous one.
#     3. Users can set a condition for each segment.
#        This is the trump card, and has highest
#        precedence.
##
# @args
#   $1 string The stateful name of the segment
#   $2 string The user condition that gets evaluated
#   $3 string Content of the segment (for default condition)
##
segmentShouldBePrinted() {
  local STATEFUL_NAME="${1}"
  local USER_CONDITION="${2}"
  local CONTENT="${3}"

  local CONDITION
  local SEGMENT_CONDITION="P9K_${STATEFUL_NAME}_CONDITION"
  if defined "${SEGMENT_CONDITION}"; then
    CONDITION="${(P)SEGMENT_CONDITION}"
  elif [[ -n "${USER_CONDITION}" && "${USER_CONDITION[0,1]}" == "[" ]]; then
    CONDITION="${USER_CONDITION}"
  else
    CONDITION='[[ -n "${CONTENT}" ]]'
  fi
  # Precompile condition.
  eval "${CONDITION}"
  return $?
}

################################################################
# @description
#   Given a directory path, truncate it according to the settings.
##
# @args
#   $1 string The directory path to be truncated.
#   $2 integer Length to truncate to.
#   $3 string Delimiter to use.
#   $4 string Where to truncate from - "right" | "middle". If omited, assumes right.
##
function truncatePath() {
  # if the current path is not 1 character long (e.g. "/" or "~")
  if (( ${#1} > 1 )); then
    # convert $2 from string to integer
    2=$(( $2 ))
    # set $3 to "" if not defined
    [[ -z $3 ]] && 3="" || 3=$(echo -n $3)
    # set $4 to "right" if not defined
    [[ -z $4 ]] && 4="right"
    # create a variable for the truncated path.
    local trunc_path
    # if the path is in the home folder, add "~/" to the start otherwise "/"
    [[ $1 == "~"* ]] && trunc_path='~/' || trunc_path='/'
    # split the path into an array using "/" as the delimiter
    local paths=$1
    paths=(${(s:/:)${paths//"~\/"/}})
    # declare locals for the directory being tested and its length
    local test_dir test_dir_length
    # do the needed truncation
    case $4 in
      right)
        # include the delimiter length in the threshhold
        local threshhold=$(( $2 + ${#3} ))
        # loop through the paths
        for (( i=1; i<${#paths}; i++ )); do
          # get the current directory value
          test_dir=$paths[$i]
          test_dir_length=${#test_dir}
          # only truncate if the resulting truncation will be shorter than
          # the truncation + delimiter length and at least 3 characters
          if (( $test_dir_length > $threshhold )) && (( $test_dir_length > 3 )); then
            # use the first $2 characters and the delimiter
            trunc_path+="${test_dir:0:$2}$3/"
          else
            # use the full path
            trunc_path+="${test_dir}/"
          fi
        done
      ;;
      middle)
        # we need double the length for start and end truncation + delimiter length
        local threshhold=$(( $2 * 2 ))
        # create a variable for the start of the end truncation
        local last_pos
        # loop through the paths
        for (( i=1; i<${#paths}; i++ )); do
          # get the current directory value
          test_dir=$paths[$i]
          test_dir_length=${#test_dir}
          # only truncate if the resulting truncation will be shorter than
          # the truncation + delimiter length
          if (( $test_dir_length > $threshhold )); then
            # use the first $2 characters, the delimiter and the last $2 characters
            last_pos=$(( $test_dir_length - $2 ))
            trunc_path+="${test_dir:0:$2}$3${test_dir:$last_pos:$test_dir_length}/"
          else
            # use the full path
            trunc_path+="${test_dir}/"
          fi
        done
      ;;
    esac
    # return the truncated path + the current directory
    echo $trunc_path${1:t}
  else # current path is 1 character long (e.g. "/" or "~")
    echo $1
  fi
}

###############################################################
# @description
#   Given a directory path, truncate it according to the settings for
#   `truncate_from_right`.
##
# @args
#   $1 string Directory path.
##
# @note
#   Deprecated. Use `truncatePath` instead.
##
function truncatePathFromRight() {
  local delim_len=${#P9K_SHORTEN_DELIMITER:-1}
  echo $1 | sed $SED_EXTENDED_REGEX_PARAMETER \
 "s@(([^/]{$((P9K_SHORTEN_DIR_LENGTH))})([^/]{$delim_len}))[^/]+/@\2$P9K_SHORTEN_DELIMITER/@g"
}

###############################################################
# @description
#   Search recursively in parent folders for given file.
##
# @args
#   $1 string Filename to search for.
##
function upsearch() {
  if [[ "$PWD" == "$HOME" || "$PWD" == "/" ]]; then
    echo "$PWD"
  elif test -e "$1"; then
    pushd .. > /dev/null
    upsearch "$1"
    popd > /dev/null
    echo "$PWD"
  else
    pushd .. > /dev/null
    upsearch "$1"
    popd > /dev/null
  fi
}

typeset -gAH p9k_icons
typeset -gAH p9k_bgs
typeset -gAH p9k_fgs

if [[ P9K_MODE == "awesome-mapped-fontconfig" && -z "$AWESOME_GLYPHS_LOADED" ]]; then
    echo "Powerlevel9k warning: Awesome-Font mappings have not been loaded.
    Source a font mapping in your shell config, per the Awesome-Font docs
    (https://github.com/gabrielelana/awesome-terminal-fonts),
    or use a different Powerlevel9k font configuration.";
fi

################################################################
# @description
#   This function allows a segment to register the colors and icons
#   that it requires. It will check for icons overriden by the user
#   first and if found, will use those instead of the ones defined
#   by the segment.
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
#   registerSegment "name_of_icon" 'Gen' $'\uXXX' $'\uXXX' '\u'$CODEPOINT_OF_AWESOME_xxx '\uXXX'
##
# @example
#   registerSegment "LOCK_ICON"  $'\uE0A2'  $'\uE138'  $'\uF023'  '\u'$CODEPOINT_OF_AWESOME_LOCK  $'\uF023'
##
function registerIcon() {
  local map
	local ICON_USER_VARIABLE
  [[ "${1}" =~ "SEGMENT" ]] && ICON_USER_VARIABLE="P9K_${1}" || ICON_USER_VARIABLE="P9K_${1}_ICON"
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
	p9k_icons[${(U)1}]=${map}
}

################################################################
# @description
#   This function allows a segment to register the colors and icons
#   that it requires. It will check for icons overriden by the user
#   first and if found, will use those instead of the ones defined
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
#   registerSegment "name_of_icon" 'Gen' $'\uXXX' $'\uXXX' '\u'$CODEPOINT_OF_AWESOME_xxx '\uXXX'
##
# @example
#   registerSegment "LOCK_ICON"  $'\uE0A2'  $'\uE138'  $'\uF023'  '\u'$CODEPOINT_OF_AWESOME_LOCK  $'\uF023'
##
function registerSegment() {
  # add state if required
  [[ -n $2 ]] && 1=${(U)1}_${(U)2}

  local BG_USER_VARIABLE="P9K_${1}_BACKGROUND"
  if defined "$BG_USER_VARIABLE"; then # check for background override first
    p9k_bgs[$1]=${(P)BG_USER_VARIABLE}
  else
    p9k_bgs[$1]=$3
  fi

  local FG_USER_VARIABLE="P9K_${1}_FOREGROUND"
  if defined "$FG_USER_VARIABLE"; then # check for foreground override first
    p9k_fgs[$1]=${(P)FG_USER_VARIABLE}
  else
    p9k_fgs[$1]=$4
  fi

  local map
	local ICON_USER_VARIABLE="P9K_${1}_ICON"
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
	p9k_icons[${(U)1}]=${map}
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
registerIcon "MULTILINE_FIRST_PROMPT_PREFIX"    $'\u256D\u2500'  $'\u256D\u2500'  $'\u256D\u2500'  $'\u256D\u2500'  $'\u256D\u2500'
#                                               ├─                 ├─                  ├─                 ├─                  ├─
registerIcon "MULTILINE_NEWLINE_PROMPT_PREFIX"  $'\u251C\u2500'  $'\u251C\u2500'  $'\u251C\u2500'  $'\u251C\u2500'  $'\u251C\u2500'
#                                               ╰─                 ╰─                  ╰─                 ╰─                  ╰─
registerIcon "MULTILINE_LAST_PROMPT_PREFIX"     $'\u2570\u2500 ' $'\u2570\u2500 ' $'\u2570\u2500 ' $'\u2570\u2500 ' $'\u2570\u2500 '

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
show_p9k_icons() {
  for k in ${(k)p9k_icons}; do; echo "$k -> '$p9k_icons[$k]'"; done | sort
}

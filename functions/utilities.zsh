#!/usr/bin/env zsh
# vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8
################################################################
# @title powerlevel9k Utility Functions
# @source [powerlevel9k](https://github.com/bhilburn/powerlevel9k)
##
# @info
#   This file contains some utility-functions for
#   the powerlevel9k ZSH theme.
##

################################################################
# Source autoload functions
################################################################
local autoload_path="$p9kDirectory/functions/autoload"
# test if we already autoloaded the functions
if [[ ${fpath[(ie)$autoload_path]} -gt ${#fpath} ]]; then
  fpath=( $autoload_path "${fpath[@]}" )
  autoload -Uz segmentShouldBeJoined
  autoload -Uz segmentShouldBePrinted
  autoload -Uz truncatePath
  autoload -Uz upsearch
fi

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
    if [[ $envVar =~ "POWERLEVEL9K_" ]]; then
      oldVarsFound=true
      var=$(declare -p ${envVar})
      varName=${${var##*POWERLEVEL9K_}%=*}
      origVar="POWERLEVEL9K_${varName}"
      newVar="P9K_${varName}"
      if [[ ${var[13]} == "a" ]]; then # array variable
        newVal=${${var##*\(}%\)*}
        case ${(U)varName} in
          BATTERY_LEVEL_BACKGROUND) typeset -g -a P9K_BATTERY_LEVEL_BACKGROUND=(${(s: :)newVal});;
          BATTERY_STAGES)
            local newVal=${${(P)origVar}//\'/}
            typeset -g -a P9K_BATTERY_STAGES=( ${(s: :)newVal} )
          ;;
          LEFT_PROMPT_ELEMENTS)     typeset -g -a P9K_LEFT_PROMPT_ELEMENTS=(${(s: :)newVal});;
          RIGHT_PROMPT_ELEMENTS)    typeset -g -a P9K_RIGHT_PROMPT_ELEMENTS=(${(s: :)newVal});;
        esac
      else
        newVal=${(P)origVar}
        typeset -g $newVar=$newVal
      fi
      unset $origVar
    fi
  done
  [[ $P9K_IGNORE_VAR_WARNING == true ]] && oldVarsFound=false # disable warning if user sets P9K_IGNORE_VAR_WARNING to true.
  [[ $oldVarsFound == true ]] && print -P "%F{yellow}Information!%f As of this update, the %F{cyan}POWERLEVEL9K_*%f variables have been replaced by %F{cyan}P9K_*%f.
  Variables have been converted automatically, but there may still be some errors. For more informations, have a look at the CHANGELOG.md.
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
#   0 if the variable has been defined (even when empty).
##
function defined() {
  [[ ! -z "${(tP)1}" ]]
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
  [[ -n "${P9K_PROMPT_ELEMENTS[(r)$1]}" ]] && return 0 || return 1
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
#   This function determines if older variable namess have been
#   previously defined and changes them to newer variable names.
##
# @args
#   $1 string Old variable name
#   $2 string New variable name
##
# @returns
#   0 if variable was renamed
#   1 if variable could not be renamed
##
function updateVarName() {
  # check if old variable is defined
  if defined $1 && [[ -n "$2" ]]; then
    # check for multiple Variables
    local newVars=("${(@s:,:)2}")
    for key in ${newVars}; do
      # set new variable name
      typeset -g "$key"="${(P)1}"
      print -P "%F{yellow}Warning!%f The '$1' variable is deprecated. This has been updated to '%F{cyan}${key}%f' for you. For more informations, have a look at the CHANGELOG.md."
    done
    unset $1
    return 0
  else
    return 1
  fi
}

###############################################################
# @description
#   Print a deprecation warning if an old variable is in use.
# @args
#   $1 associative-array An associative array that contains
#   the deprecated variables as keys, and the new variable
#   names as values.
##
printDeprecationVarWarning() {
  typeset -AH raw_deprecated_variables
  raw_deprecated_variables=(${(kvP@)1})

  for key in ${(@k)raw_deprecated_variables}; do
    if defined $key; then
      # segment is deprecated
      if ! updateVarName $key $raw_deprecated_variables[$key]; then
        print -P "%F{yellow}Warning!%f The '$key' variable is deprecated. This could not be updated to '%F{cyan}${raw_deprecated_variables[$key]}%f' for you. For more informations, have a look at the CHANGELOG.md."
      fi
    fi
  done
}

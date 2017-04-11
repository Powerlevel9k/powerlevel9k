#!/usr/bin/env zsh
# vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8
################################################################
# @title Color functions
# @source https://github.com/bhilburn/powerlevel9k
# @info
# This file holds some color-functions for the powerlevel9k-ZSH-theme
##

################################################################
# @description
# Get numerical color codes. That way we translate ANSI codes ZSH-Style color codes.
##
# @example
#   getColorCode 'black'
#
# @args
#   $1 string|number If string, ANSI color code.
#
# @returns
#   Zsh style color code.
##
function getColorCode() {
  # Check if given value is already numerical
  if [[ "$1" = <-> ]]; then
    # ANSI color codes distinguish between "foreground"
    # and "background" colors. We don't need to do that,
    # as ZSH uses a 256 color space anyway.
    if [[ "$1" = <8-15> ]]; then
      echo $(($1 - 8))
    else
      echo "$1"
    fi
  else
    typeset -A codes
    codes=(
      'black'   '000'
      'red'     '001'
      'green'   '002'
      'yellow'  '003'
      'blue'    '004'
      'magenta' '005'
      'cyan'    '006'
      'white'   '007'
    )

    # Strip eventual "bg-" prefixes
    1=${1#bg-}
    # Strip eventual "fg-" prefixes
    1=${1#fg-}
    # Strip eventual "br" prefixes ("bright" colors)
    1=${1#br}
    echo $codes[$1]
  fi
}

################################################################
# @description
# Check if two colors are equal, even if one is specified as ANSI code.
##
# @examples isSameColor 'black' 0
#   isSameColor 'white' 0
#
# @args
#   $1 string|number First color.
#   $2 string|number Second color.
#
# @returns
#   true if they are the same color.
#   false if they are different colors.
#
# @see
#   getColorCode
##
function isSameColor() {
  if [[ "$1" == "NONE" || "$2" == "NONE" ]]; then
    return 1
  fi

  local color1=$(getColorCode "$1")
  local color2=$(getColorCode "$2")

  return $(( color1 != color2 ))
}


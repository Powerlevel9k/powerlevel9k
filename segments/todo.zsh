#!/usr/env/bin zsh
# vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8
################################################################
# Todo segments
# This file holds integration of todo.sh for
# the powerlevel9k-ZSH-theme
# https://github.com/bhilburn/powerlevel9k
################################################################

################################################################
# For basic documentation, please refer to the README.md in the top-level
# directory. For more detailed documentation, refer to the project wiki, hosted
# on Github: https://github.com/bhilburn/powerlevel9k/wiki
#
# There are a lot of easy ways you can customize your prompt segments and
# theming with simple variables defined in your `~/.zshrc`.
################################################################

###############################################################
# todo.sh: shows the number of tasks in your todo.sh file
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
prompt_todo() {
  local todos=$(todo.sh ls 2>/dev/null | egrep "TODO: [0-9]+ of ([0-9]+) tasks shown" | awk '{ print $4 }')

  serialize_segment "$0" "" "$1" "$2" "${3}" "244" "$DEFAULT_COLOR" "${todos}" "TODO_ICON"
}


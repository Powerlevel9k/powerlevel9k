#!/usr/env/bin zsh
# vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8
################################################################
# Virtual segments
# This file holds the virtualization segments for
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
# Detection for virtualization (systemd based systems only)
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
prompt_detect_virt() {
  local virt=$(systemd-detect-virt 2> /dev/null)
  if [[ "$virt" == "none" ]]; then
    if [[ "$(ls -di / | grep -o 2)" != "2" ]]; then
      virt="chroot"
    fi
  fi

  serialize_segment "$0" "" "$1" "$2" "${3}" "yellow" "${DEFAULT_COLOR}" "${virt}"
}

###############################################################
# Docker machine
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
prompt_docker_machine() {
  serialize_segment "$0" "" "$1" "$2" "${3}" "magenta" "${DEFAULT_COLOR}" "${DOCKER_MACHINE_NAME}" "SERVER_ICON"
}

###############################################################
# Virtualenv: current working virtualenv
# More information on virtualenv (Python):
# https://virtualenv.pypa.io/en/latest/
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
prompt_virtualenv() {
  serialize_segment "$0" "" "$1" "$2" "${3}" "blue" "$DEFAULT_COLOR" "$(basename "${VIRTUAL_ENV}")" "PYTHON_ICON"
}

###############################################################
# pyenv: current active python version (with restrictions)
# More information on pyenv (Python version manager like rbenv and rvm):
# https://github.com/yyuu/pyenv
# the prompt parses output of pyenv version and only displays the first word
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
prompt_pyenv() {
  local pyenv_version="$(pyenv version 2>/dev/null)"
  pyenv_version="${pyenv_version%% *}"
  # XXX: The following should return the same as above.
  # This reads better for devs familiar with sed/awk/grep/cut utilities
  # Using shell expansion/substitution may hamper future maintainability
  #local pyenv_version="$(pyenv version 2>/dev/null | head -n1 | cut -d' ' -f1)"
  if [[ "${pyenv_version}" != "system" ]]; then
    pyenv_version=""
  fi
  serialize_segment "$0" "" "$1" "$2" "${3}" "blue" "$DEFAULT_COLOR" "$pyenv_version" "PYTHON_ICON"
}

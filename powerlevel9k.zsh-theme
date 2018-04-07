#!/usr/bin/env zsh
# vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8
################################################################
# @title powerlevel9k Theme
# @source https://github.com/bhilburn/powerlevel9k
##
# @authors
#   Ben Hilburn
#   Dominik Ritter
##
# @info
#   This theme was inspired by [agnoster's Theme](https://gist.github.com/3712874)
#
#   For basic documentation, please refer to the README.md in the top-level
#   directory. For more detailed documentation, refer to the
#   [project wiki](https://github.com/bhilburn/powerlevel9k/wiki).
#
#   There are a lot of easy ways you can customize your prompt segments and
#   theming with simple variables defined in your `~/.zshrc`. Please refer to
#   the `sample-zshrc` file for more details.
################################################################

## Turn on for Debugging
#PS4='%s%f%b%k%F{blue}%{λ%}%L %F{240}%N:%i%(?.. %F{red}%?) %1(_.%F{yellow}%-1_ .)%s%f%b%k '
#zstyle ':vcs_info:*+*:*' debug true
#set -o xtrace

# Try to set the installation path
if [[ -n "$P9K_INSTALLATION_DIR" ]]; then
  p9kDirectory=${P9K_INSTALLATION_DIR:A}
else
  if [[ "${(%):-%N}" == '(eval)' ]]; then
    if [[ "$0" == '-antigen-load' ]] && [[ -r "${PWD}/powerlevel9k.zsh-theme" ]]; then
      # Antigen uses eval to load things so it can change the plugin (!!)
      # https://github.com/zsh-users/antigen/issues/581
      p9kDirectory=$PWD
    else
      print -P "%F{red}You must set P9K_INSTALLATION_DIR to work from within an (eval).%f"
      return 1
    fi
  else
    # Get the path to file this code is executing in; then
    # get the absolute path and strip the filename.
    # See https://stackoverflow.com/a/28336473/108857
    p9kDirectory=${${(%):-%x}:A:h}
  fi
fi

################################################################
# Source icon functions
################################################################

source "${p9kDirectory}/functions/icons.zsh"

################################################################
# Source utility functions
################################################################

source "${p9kDirectory}/functions/utilities.zsh"

################################################################
# Source color functions
################################################################

source "${p9kDirectory}/functions/colors.zsh"

################################################################
# Color Scheme
################################################################

if [[ "$P9K_COLOR_SCHEME" == "light" ]]; then
  DEFAULT_COLOR=white
  DEFAULT_COLOR_INVERTED=black
else
  DEFAULT_COLOR=black
  DEFAULT_COLOR_INVERTED=white
fi

################################################################
# Choose the generator
################################################################

case "${(L)P9K_GENERATOR}" in
  "zsh-async")
    source "${p9kDirectory}/generator/zsh-async.p9k"
  ;;
  *)
    source "${p9kDirectory}/generator/default.p9k"
  ;;
esac

################################################################
# Load Prompt Segment Definitions
################################################################

# load only the segments that are being used!
local segmentName
typeset -gU loadedSegments
for segment in $p9kDirectory/segments/*.p9k; do
  segmentName=${${segment##*/}%.p9k}
  if segmentInUse "$segmentName"; then
    source "${segment}" 2>&1
    loadedSegments+=("${segmentName}")
  fi
done

# cleanup temporary variable - not done because it is used for autoloading segments
#unset p9kDirectory

# Launch the generator
prompt_powerlevel9k_setup "$@"

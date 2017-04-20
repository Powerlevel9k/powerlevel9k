#!/usr/bin/env zsh
# vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8
################################################################
# @title powerlevel9k Theme
# @source https://github.com/bhilburn/powerlevel9k
#
# @authors
#   Ben Hilburn
#   Dominic Ritter
#
# @info
# This theme was inspired by [agnoster's Theme](https://gist.github.com/3712874)
#
# For basic documentation, please refer to the README.md in the top-level
# directory. For more detailed documentation, refer to the
# [project wiki](https://github.com/bhilburn/powerlevel9k/wiki).
#
# There are a lot of easy ways you can customize your prompt segments and
# theming with simple variables defined in your `~/.zshrc`. Please refer to
# the `sample-zshrc` file for more details.
################################################################

## Turn on for Debugging
#zstyle ':vcs_info:*+*:*' debug true
#set -o xtrace

################################################################
# Set required ZSH options
################################################################

# Fix for Prezto/ZIM. We need to make our traps global, so that
# they are still active when Prezto/ZIM finally execute the theme.
setopt nolocaltraps

setopt LOCAL_OPTIONS
unsetopt KSH_ARRAYS
setopt PROMPT_CR
setopt PROMPT_PERCENT
setopt MULTIBYTE

################################################################
# Load our functions
################################################################

# Try to set the installation path
if [[ -n "$POWERLEVEL9K_INSTALLATION_PATH" ]]; then
  # If an installation path was set manually,
  # it should trump any other location found.
  # Do nothing. This is all right, as we use the
  # POWERLEVEL9K_INSTALLATION_PATH for further processing.
elif [[ $(whence -w prompt_powerlevel9k_setup) =~ "function" ]]; then
  # Check if the theme was called as a function (e.g., from prezto)
  autoload -U is-at-least
  if is-at-least 5.0.8; then
    # Try to find the correct path of the script.
    POWERLEVEL9K_INSTALLATION_PATH=$(whence -w $0 | sed "s/$0 is a shell function from //")
  elif [[ -f "${ZDOTDIR:-$HOME}/.zprezto/modules/prompt/init.zsh" ]]; then
    # If there is an prezto installation, we assume that powerlevel9k is linked there.
    POWERLEVEL9K_INSTALLATION_PATH="${ZDOTDIR:-$HOME}/.zprezto/modules/prompt/functions/prompt_powerlevel9k_setup"
  fi
else
  # Last resort: Set installation path is script path
  POWERLEVEL9K_INSTALLATION_PATH="$0"
fi

# Resolve the installation path
if [[ -L "$POWERLEVEL9K_INSTALLATION_PATH" ]]; then
  # If this theme is sourced as a symlink, we need to locate the real URL
  filename="${POWERLEVEL9K_INSTALLATION_PATH:A}"
elif [[ -d "$POWERLEVEL9K_INSTALLATION_PATH" ]]; then
  # Directory
  filename="${POWERLEVEL9K_INSTALLATION_PATH}/powerlevel9k.zsh-theme"
elif [[ -f "$POWERLEVEL9K_INSTALLATION_PATH" ]]; then
  # Script is a file
  filename="$POWERLEVEL9K_INSTALLATION_PATH"
elif [[ -z "$POWERLEVEL9K_INSTALLATION_PATH" ]]; then
  # Fallback: specify an installation path!
  print -P "%F{red}We could not locate the installation path of powerlevel9k.%f"
  print -P "Please specify by setting %F{blue}POWERLEVEL9K_INSTALLATION_PATH%f (full path incl. file name) at the very beginning of your ~/.zshrc"
  return 1
else
  print -P "%F{red}Script location could not be found! Maybe your %F{blue}POWERLEVEL9K_INSTALLATION_PATH%F{red} is not correct?%f"
  return 1
fi
script_location="$(dirname $filename)"

################################################################
# Source icon functions
################################################################

source $script_location/functions/icons.zsh

################################################################
# Source utility functions
################################################################

source $script_location/functions/utilities.zsh

################################################################
# Source color functions
################################################################

source $script_location/functions/colors.zsh

################################################################
# Source VCS_INFO hooks / helper functions
################################################################

source $script_location/functions/vcs.zsh

################################################################
# Load Prompt Segment Definitions
################################################################

for segment in $script_location/segments/**/*.zsh; do source $segment; done

################################################################
# Choose the engine
################################################################

[[ "${(L)POWERLEVEL9K_GENERATOR}" == "default" || -z $POWERLEVEL9K_GENERATOR ]] && source $script_location/generator/default.zsh
[[ "${(L)POWERLEVEL9K_GENERATOR}" == "async" ]] && source $script_location/generator/async.zsh

################################################################
# Color Scheme
################################################################

if [[ "$POWERLEVEL9K_COLOR_SCHEME" == "light" ]]; then
  DEFAULT_COLOR=white
  DEFAULT_COLOR_INVERTED=black
else
  DEFAULT_COLOR=black
  DEFAULT_COLOR_INVERTED=white
fi
prompt_powerlevel9k_setup "$@"

# Show all active traps
# trap --

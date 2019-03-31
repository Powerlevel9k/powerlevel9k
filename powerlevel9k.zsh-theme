#!/usr/bin/env zsh
# vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8
################################################################
# @title powerlevel9k Theme
# @source [powerlevel9k](https://github.com/bhilburn/powerlevel9k)
##
# @authors
#   Ben Hilburn - [@bhilburn](https://github.com/bhilburn)
#   Dominik Ritter - [@dritter](https://github.com/dritter)
#   Christo Kotze - [@onaforeignshore](https://github.com/onaforeignshore)
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

# Define the version number. This will make it easier to support as users can report this with tickets.
readonly P9K_VERSION="0.7.0"

## Turn on for Debugging
# PS4='%s%f%b%k%F{blue}%{λ%}%L %F{240}%N:%i%(?.. %F{red}%?) %1(_.%F{yellow}%-1_ .)%s%f%b%k '
# zstyle ':vcs_info:*+*:*' debug true
# set -o xtrace

# Try to set the installation path
if [[ -n "$P9K_INSTALLATION_DIR" ]]; then
  __P9K_DIRECTORY=${P9K_INSTALLATION_DIR:A}
else
  if [[ "${(%):-%N}" == '(eval)' ]]; then
    if [[ "$0" == '-antigen-load' ]] && [[ -r "${PWD}/powerlevel9k.zsh-theme" ]]; then
      # Antigen uses eval to load things so it can change the plugin (!!)
      # https://github.com/zsh-users/antigen/issues/581
      __P9K_DIRECTORY=$PWD
    else
      print -P "%F{red}You must set P9K_INSTALLATION_DIR to work from within an (eval).%f"
      return 1
    fi
  else
    # Get the path to file this code is executing in; then
    # get the absolute path and strip the filename.
    # See https://stackoverflow.com/a/28336473/108857
    __P9K_DIRECTORY=${${(%):-%x}:A:h}
  fi
fi
#readonly __P9K_DIRECTORY

################################################################
# Source utility functions
################################################################

source "${__P9K_DIRECTORY}/functions/utilities.zsh"

################################################################
# Source icon functions
################################################################

source "${__P9K_DIRECTORY}/functions/icons.zsh"

################################################################
# Source color functions
################################################################

source "${__P9K_DIRECTORY}/functions/colors.zsh"

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
# Deprecated segments and variables
################################################################

# Display a warning if deprecated segments are in use.
typeset -AH deprecated_segments
# old => new
deprecated_segments=(
  'longstatus'      'status'
)
__p9k_print_deprecation_warning deprecated_segments

# Display a warning if deprecated variables have been updated.
typeset -AH deprecated_variables
# old => new
deprecated_variables=(
  # General icons
  # Due to the changes to `p9k::register_icon`, these now require the '_ICON' suffix to work.
???LIGNES MANQUANTES
???LIGNES MANQUANTES
???LIGNES MANQUANTES
???LIGNES MANQUANTES
???LIGNES MANQUANTES
???LIGNES MANQUANTES
???LIGNES MANQUANTES
???LIGNES MANQUANTES
???LIGNES MANQUANTES
    RPROMPT="${RPROMPT_PREFIX}"'%f%b%k$(build_right_prompt)%{$reset_color%}'"${RPROMPT_SUFFIX}"
  fi

local NEWLINE='
'

  if [[ $POWERLEVEL9K_PROMPT_ADD_NEWLINE == true ]]; then
    NEWLINES=""
    repeat ${POWERLEVEL9K_PROMPT_ADD_NEWLINE_COUNT:-1} { NEWLINES+=$NEWLINE }
    PROMPT="$NEWLINES$PROMPT"
  fi

  # Allow iTerm integration to work
  [[ $ITERM_SHELL_INTEGRATION_INSTALLED == "Yes" ]] && PROMPT="%{$(iterm2_prompt_mark)%}$PROMPT"
}

zle-keymap-select () {
	zle reset-prompt
	zle -R
}

set_default POWERLEVEL9K_IGNORE_TERM_COLORS false
set_default POWERLEVEL9K_IGNORE_TERM_LANG false

prompt_powerlevel9k_setup() {
  # The value below was set to better support 32-bit CPUs.
  # It's the maximum _signed_ integer value on 32-bit CPUs.
  # Please don't change it until 19 January of 2038. ;)

  # Disable false display of command execution time
  _P9K_TIMER_START=0x7FFFFFFF

  # The prompt function will set these prompt_* options after the setup function
  # returns. We need prompt_subst so we can safely run commands in the prompt
  # without them being double expanded and we need prompt_percent to expand the
  # common percent escape sequences.
  prompt_opts=(cr percent sp subst)

  # Borrowed from promptinit, sets the prompt options in case the theme was
  # not initialized via promptinit.
  setopt noprompt{bang,cr,percent,sp,subst} "prompt${^prompt_opts[@]}"

  # Display a warning if the terminal does not support 256 colors
  termColors

  # If the terminal `LANG` is set to `C`, this theme will not work at all.
  if [[ $POWERLEVEL9K_IGNORE_TERM_LANG == false ]]; then
      local term_lang
      term_lang=$(echo $LANG)
      if [[ $term_lang == 'C' ]]; then
          print -P "\t%F{red}WARNING!%f Your terminal's 'LANG' is set to 'C', which breaks this theme!"
          print -P "\t%F{red}WARNING!%f Please set your 'LANG' to a UTF-8 language, like 'en_US.UTF-8'"
          print -P "\t%F{red}WARNING!%f _before_ loading this theme in your \~\.zshrc. Putting"
          print -P "\t%F{red}WARNING!%f %F{blue}export LANG=\"en_US.UTF-8\"%f at the top of your \~\/.zshrc is sufficient."
      fi
  fi

  defined POWERLEVEL9K_LEFT_PROMPT_ELEMENTS || POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs)
  defined POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS || POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs history time)

  # Display a warning if deprecated segments are in use.
  typeset -AH deprecated_segments
  # old => new
  deprecated_segments=(
    'longstatus'      'status'
  )
  print_deprecation_warning deprecated_segments

  # initialize colors
  autoload -U colors && colors

  if segment_in_use "vcs"; then
    powerlevel9k_vcs_init
  fi

  # initialize timing functions
  zmodload zsh/datetime

  # Initialize math functions
  zmodload zsh/mathfunc

  # initialize hooks
  autoload -Uz add-zsh-hook

  # prepare prompts
  add-zsh-hook precmd powerlevel9k_prepare_prompts
  add-zsh-hook preexec powerlevel9k_preexec

  zle -N zle-keymap-select
}

prompt_powerlevel9k_teardown() {
  add-zsh-hook -D precmd powerlevel9k_\*
  add-zsh-hook -D preexec powerlevel9k_\*
  PROMPT='%m%# '
  RPROMPT=
}

>>>>>>> Stashed changes
prompt_powerlevel9k_setup "$@"


################################################################
# Virtualenv: current working virtualenv
# More information on virtualenv (Python):
# https://virtualenv.pypa.io/en/latest/
prompt_virtualenv() {
  if [[ -n "$VIRTUAL_ENV" ]]; then
    if [[ "$POWERLEVEL9K_VIRTUALENV_SHOW_VERSION" == true ]]; then
      local python_version=$(python -V | awk '{print $2}') 
      "$1_prompt_segment" "$0" "$2" "blue" "$DEFAULT_COLOR" "${python_version} ${${VIRTUAL_ENV:t}//\%/%%}" 'PYTHON_ICON'
    else
      "$1_prompt_segment" "$0" "$2" "blue" "$DEFAULT_COLOR" "${${VIRTUAL_ENV:t}//\%/%%}" 'PYTHON_ICON'
    fi
  fi
}


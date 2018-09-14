# vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8
################################################################
# powerlevel9k Theme
# https://github.com/bhilburn/powerlevel9k
#
# This theme was inspired by agnoster's Theme:
# https://gist.github.com/3712874
################################################################

################################################################
# For basic documentation, please refer to the README.md in the top-level
# directory. For more detailed documentation, refer to the project wiki, hosted
# on Github: https://github.com/bhilburn/powerlevel9k/wiki
#
# There are a lot of easy ways you can customize your prompt segments and
# theming with simple variables defined in your `~/.zshrc`.
################################################################

# Define the version number. This will make it easier to support as users can report this with tickets.
readonly P9K_VERSION="0.7.0"

## Turn on for Debugging
#PS4='%s%f%b%k%F{blue}%{λ%}%L %F{240}%N:%i%(?.. %F{red}%?) %1(_.%F{yellow}%-1_ .)%s%f%b%k '
#zstyle ':vcs_info:*+*:*' debug true
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
# Source icon functions
################################################################

source "${__P9K_DIRECTORY}/functions/icons.zsh"

################################################################
# Source utility functions
################################################################

source "${__P9K_DIRECTORY}/functions/utilities.zsh"

################################################################
# Source color functions
################################################################

source "${__P9K_DIRECTORY}/functions/colors.zsh"

# cleanup temporary variables.
#unset __P9K_DIRECTORY

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

################################################################
# Choose the generator
################################################################

case "${(L)P9K_GENERATOR}" in
  "zsh-async")
    source "${__P9K_DIRECTORY}/generator/zsh-async.p9k"
  ;;
  *)
    source "${__P9K_DIRECTORY}/generator/default.p9k"
  ;;
esac

################################################################
# Set default prompt segments
################################################################

p9k::defined P9K_LEFT_PROMPT_ELEMENTS || P9K_LEFT_PROMPT_ELEMENTS=(context dir vcs)
p9k::defined P9K_RIGHT_PROMPT_ELEMENTS || P9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs history time)

################################################################
# Load Prompt Segment Definitions
################################################################

# load only the segments that are being used!
function __p9k_load_segments() {
  local segment
  for segment in ${P9K_LEFT_PROMPT_ELEMENTS} ${P9K_RIGHT_PROMPT_ELEMENTS}; do
    # Remove joined information
    segment=${segment%_joined}

    # Custom segments must be loaded by user
    if [[ $segment[0,7] =~ "custom_" ]]; then
      continue
    fi
    source "${__P9K_DIRECTORY}/segments/${segment}.p9k" 2>&1
  done
}
__p9k_load_segments

# lauch the prompt
prompt_powerlevel9k_setup "$@"

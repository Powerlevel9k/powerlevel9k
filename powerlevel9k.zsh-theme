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

## Turn on for Debugging
#PS4='%s%f%b%k%F{blue}%{λ%}%L %F{240}%N:%i%(?.. %F{red}%?) %1(_.%F{yellow}%-1_ .)%s%f%b%k '
#zstyle ':vcs_info:*+*:*' debug true
# set -o xtrace

# Try to set the installation path
if [[ -n "$POWERLEVEL9K_INSTALLATION_DIR" ]]; then
  p9k_directory=${POWERLEVEL9K_INSTALLATION_DIR:A}
else
  if [[ "${(%):-%N}" == '(eval)' ]]; then
    if [[ "$0" == '-antigen-load' ]] && [[ -r "${PWD}/powerlevel9k.zsh-theme" ]]; then
      # Antigen uses eval to load things so it can change the plugin (!!)
      # https://github.com/zsh-users/antigen/issues/581
      p9k_directory=$PWD
    else
      print -P "%F{red}You must set POWERLEVEL9K_INSTALLATION_DIR work from within an (eval).%f"
      return 1
    fi
  else
    # Get the path to file this code is executing in; then
    # get the absolute path and strip the filename.
    # See https://stackoverflow.com/a/28336473/108857
    p9k_directory=${${(%):-%x}:A:h}
  fi
fi

################################################################
# Source icon functions
################################################################

source "${p9k_directory}/functions/icons.zsh"

################################################################
# Source utility functions
################################################################

source "${p9k_directory}/functions/utilities.zsh"

################################################################
# Source color functions
################################################################

source "${p9k_directory}/functions/colors.zsh"

# cleanup temporary variables.
#unset p9k_directory

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

################################################################
# Deprecated segments and variables
################################################################

# Display a warning if deprecated segments are in use.
typeset -AH deprecated_segments
# old => new
deprecated_segments=(
  'longstatus'      'status'
)
print_deprecation_warning deprecated_segments

################################################################
# Choose the generator
################################################################

case "${(L)POWERLEVEL9K_GENERATOR}" in
  "zsh-async")
    source "${p9k_directory}/generator/zsh-async.p9k"
  ;;
  *)
    source "${p9k_directory}/generator/default.p9k"
  ;;
esac

################################################################
# Set default prompt segments
################################################################

defined POWERLEVEL9K_LEFT_PROMPT_ELEMENTS || POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs)
defined POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS || POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs history time)

################################################################
# Load Prompt Segment Definitions
################################################################

# load only the segments that are being used!
function __p9k_loadSegments() {
  local segment
  for segment in ${POWERLEVEL9K_LEFT_PROMPT_ELEMENTS} ${POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS}; do
    # Remove joined information
    segment=${segment%_joined}

    # Custom segments must be loaded by user
    if [[ $segment[0,7] =~ "custom_" ]]; then
      continue
    fi
    source "${p9k_directory}/segments/${segment}.p9k" 2>&1
  done
}
__p9k_loadSegments

# lauch the prompt
prompt_powerlevel9k_setup "$@"

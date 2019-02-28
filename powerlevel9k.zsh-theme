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
  'P9K_MULTILINE_FIRST_PROMPT_PREFIX' 'P9K_MULTILINE_FIRST_PROMPT_PREFIX_ICON'
  'P9K_MULTILINE_LAST_PROMPT_PREFIX'  'P9K_MULTILINE_LAST_PROMPT_PREFIX_ICON'
  'P9K_LEFT_SEGMENT_SEPARATOR'        'P9K_LEFT_SEGMENT_SEPARATOR_ICON'
  'P9K_LEFT_SUBSEGMENT_SEPARATOR'     'P9K_LEFT_SUBSEGMENT_SEPARATOR_ICON'
  'P9K_RIGHT_SEGMENT_SEPARATOR'       'P9K_RIGHT_SEGMENT_SEPARATOR_ICON'
  'P9K_RIGHT_SUBSEGMENT_SEPARATOR'    'P9K_RIGHT_SUBSEGMENT_SEPARATOR_ICON'
  # status icons
  'P9K_OK_ICON'                       'P9K_STATUS_OK_ICON'
  'P9K_FAIL_ICON'                     'P9K_STATUS_ERROR_ICON'
  'P9K_CARRIAGE_RETURN_ICON'          'P9K_STATUS_ERROR_CR_ICON'
  # aws segment
  'AWS_DEFAULT_PROFILE'               'P9K_AWS_DEFAULT_PROFILE'
  # aws_eb_env segment
  'P9K_AWS_EB_ICON'                   'P9K_AWS_EB_ENV_ICON'
  # command_execution_time segment
  'P9K_EXECUTION_TIME_ICON'           'P9K_COMMAND_EXECUTION_TIME_ICON'
  # context segment
  'P9K_ALWAYS_SHOW_CONTEXT'           'P9K_CONTEXT_ALWAYS_SHOW'
  'P9K_ALWAYS_SHOW_USER'              'P9K_CONTEXT_ALWAYS_SHOW_USER'
  # dir segment
  'P9K_HOME_ICON'                     'P9K_DIR_HOME_ICON'
  'P9K_HOME_SUB_ICON'                 'P9K_DIR_HOME_SUBFOLDER_ICON'
  'P9K_FOLDER_ICON'                   'P9K_DIR_DEFAULT_ICON'
  'P9K_LOCK_ICON'                     'P9K_DIR_NOT_WRITABLE_ICON'
  'P9K_ETC_ICON'                      'P9K_DIR_ETC_ICON'
  'P9K_SHORTEN_DIR_LENGTH'            'P9K_DIR_SHORTEN_LENGTH'
  'P9K_SHORTEN_STRATEGY'              'P9K_DIR_SHORTEN_STRATEGY'
  'P9K_SHORTEN_DELIMITER'             'P9K_DIR_SHORTEN_DELIMITER'
  'P9K_SHORTEN_FOLDER_MARKER'         'P9K_DIR_SHORTEN_FOLDER_MARKER'
  'P9K_HOME_FOLDER_ABBREVIATION'      'P9K_DIR_HOME_FOLDER_ABBREVIATION'
  # disk_usage segment
  'P9K_DISK_ICON'                     'P9K_DISK_USAGE_NORMAL_ICON,P9K_DISK_USAGE_WARNING_ICON,P9K_DISK_USAGE_CRITICAL_ICON'
  # docker_machine segment
  'P9K_SERVER_ICON'                   'P9K_DOCKER_MACHINE_ICON'
  # host segment
  'P9K_HOST_ICON'                     'P9K_HOST_LOCAL_ICON,P9K_HOST_REMOTE_ICON'
  # ip segment
  'P9K_NETWORK_ICON'                  'P9K_IP_ICON'
  # go_version segment
  'P9K_GO_ICON'                       'P9K_GO_VERSION_ICON'
  # kubecontext segment
  'P9K_KUBERNETES_ICON'               'P9K_KUBECONTEXT_ICON'
  # load segment
  'P9K_LOAD_ICON'                     'P9K_LOAD_NORMAL_ICON,P9K_LOAD_WARNING_ICON,P9K_LOAD_CRITICAL_ICON'
  # node_env and node_version segments
  'P9K_NODE_ICON'                     'P9K_NODE_ENV_ICON,P9K_NODE_VERSION_ICON'
  # pyenv segment
  'P9K_PYTHON_ICON'                   'P9K_PYENV_ICON'
  # rbenv segment
  'P9K_RUBY_ICON'                     'P9K_RBENV_ICON'
  # rust segment
  'P9K_RUST_ICON'                     'P9K_RUST_VERSION_ICON'
  # swift_version segment
  'P9K_SWIFT_ICON'                    'P9K_SWIFT_VERSION_ICON'
  # user segment
  'P9K_USER_ICON'                     'P9K_USER_DEFAULT_ICON'
  'P9K_ROOT_ICON'                     'P9K_USER_ROOT_ICON'
  'P9K_SUDO_ICON'                     'P9K_USER_SUDO_ICON'
  # vcs segment
  'P9K_HIDE_BRANCH_ICON'              'P9K_VCS_HIDE_BRANCH_ICON'
  'P9K_SHOW_CHANGESET'                'P9K_VCS_SHOW_CHANGESET'
  'P9K_CHANGESET_HASH_LENGTH'         'P9K_VCS_CHANGESET_HASH_LENGTH'
  # vi_mode segment
  'P9K_VI_INSERT_MODE_STRING'         'P9K_VI_MODE_INSERT_STRING'
  'P9K_VI_COMMAND_MODE_STRING'        'P9K_VI_MODE_NORMAL_STRING'
  'P9K_VI_VISUAL_MODE_STRING'         'P9K_VI_MODE_VISUAL_STRING'
  'P9K_VI_SEARCH_MODE_STRING'         'P9K_VI_MODE_SEARCH_STRING'
)
__p9k_print_deprecation_var_warning deprecated_variables

################################################################
# Choose the generator
################################################################

source "${__P9K_DIRECTORY}/generator/default.p9k"

################################################################
# Set default prompt segments
################################################################

p9k::defined P9K_LEFT_PROMPT_ELEMENTS || P9K_LEFT_PROMPT_ELEMENTS=(context dir vcs)
p9k::defined P9K_RIGHT_PROMPT_ELEMENTS || P9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs history time)

################################################################
# Load Prompt Segment Definitions
################################################################

function __p9k_polyfill_segment_tags() {
  # Replace old "custom_" elements with new Tag syntax.
  # This is done via the internal ZSH regex engine.
  # #b enables pattern matching
  # ? is any character
  # ## is one or more
  # S Flag for non-greedy matching
  P9K_LEFT_PROMPT_ELEMENTS=("${(@)P9K_LEFT_PROMPT_ELEMENTS//(#b)custom_(?##)/${match[1]}::custom}")
  P9K_LEFT_PROMPT_ELEMENTS=("${(@S)P9K_LEFT_PROMPT_ELEMENTS//(#b)(?##)_joined/${match[1]}::joined}")

  P9K_RIGHT_PROMPT_ELEMENTS=("${(@)P9K_RIGHT_PROMPT_ELEMENTS//(#b)custom_(?##)/${match[1]}::custom}")
  P9K_RIGHT_PROMPT_ELEMENTS=("${(@S)P9K_RIGHT_PROMPT_ELEMENTS//(#b)(?##)_joined/${match[1]}::joined}")

  # echo $P9K_LEFT_PROMPT_ELEMENTS
}
__p9k_polyfill_segment_tags

p9k::set_default P9K_CUSTOM_SEGMENT_LOCATION "$HOME/.config/powerlevel9k/segments"
# load only the segments that are being used!
function __p9k_load_segments() {
  local segment raw_segment
  for raw_segment in ${P9K_LEFT_PROMPT_ELEMENTS} ${P9K_RIGHT_PROMPT_ELEMENTS}; do
    local -a segment_meta
    # Split by double-colon
    segment_meta=(${(s.::.)raw_segment})
    # First value is always segment name
    segment=${segment_meta[1]}

    # Custom segments must be loaded by user
    if p9k::segment_is_tagged_as "custom" "${segment_meta}"; then
      continue
    fi
    # check if the file exists as a core segment
    if [[ -f ${__P9K_DIRECTORY}/segments/${segment}/${segment}.p9k ]]; then
      source "${__P9K_DIRECTORY}/segments/${segment}/${segment}.p9k" 2>&1
    else
      # check if the file exists as a custom segment
      if [[ -f "${P9K_CUSTOM_SEGMENT_LOCATION}/${segment}/${segment}.p9k" ]]; then
        # This is not muted, as we want to show if there are issues with
        # his custom segments.
        source "${P9K_CUSTOM_SEGMENT_LOCATION}/${segment}/${segment}.p9k"
      else
        # file not found!
        # If this happens, we remove the segment from the configured elements,
        # so that we avoid printing errors over and over.
        print -P "%F{yellow}Warning!%f The '%F{cyan}${segment}%f' segment was not found. Removing it from the prompt."
        P9K_LEFT_PROMPT_ELEMENTS=("${(@)P9K_LEFT_PROMPT_ELEMENTS:#${segment}}")
        P9K_RIGHT_PROMPT_ELEMENTS=("${(@)P9K_RIGHT_PROMPT_ELEMENTS:#${segment}}")
        P9K_PROMPT_ELEMENTS=("${(@)P9K_PROMPT_ELEMENTS:#${segment}}")
      fi
    fi
  done
}
__p9k_load_segments

# lauch the generator (prompt)
prompt_powerlevel9k_setup "$@"

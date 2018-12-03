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

p9k::set_default P9K_CUSTOM_SEGMENT_LOCATION "$HOME/.config/powerlevel9k/segments"
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
    # check if the file exists as a core segment
    if [[ -f ${__P9K_DIRECTORY}/segments/${segment}.p9k ]]; then
      source "${__P9K_DIRECTORY}/segments/${segment}.p9k" 2>&1
    else
      # check if the file exists as a custom segment
      if [[ -f "${P9K_CUSTOM_SEGMENT_LOCATION}/${segment}.p9k" ]]; then
        source "${P9K_CUSTOM_SEGMENT_LOCATION}/${segment}.p9k"
      else
        # file not found!
        print -P "%F{yellow}Warning!%f The '%F{cyan}${segment}%f' segment was not found. Removing it from the prompt."
        P9K_LEFT_PROMPT_ELEMENTS=("${(@)P9K_LEFT_PROMPT_ELEMENTS:#${segment}}")
        P9K_RIGHT_PROMPT_ELEMENTS=("${(@)P9K_RIGHT_PROMPT_ELEMENTS:#${segment}}")
        P9K_PROMPT_ELEMENTS=("${(@)P9K_PROMPT_ELEMENTS:#${segment}}")
      fi
    fi
  done
}
__p9k_load_segments

<<<<<<< HEAD
# lauch the generator (prompt)
=======
################################################################
# Segment to display the current IP address
prompt_ip() {
  if [[ "$OS" == "OSX" ]]; then
    if defined POWERLEVEL9K_IP_INTERFACE; then
      # Get the IP address of the specified interface.
      ip=$(ipconfig getifaddr "$POWERLEVEL9K_IP_INTERFACE")
    else
      local interfaces callback
      # Get network interface names ordered by service precedence.
      interfaces=$(networksetup -listnetworkserviceorder | grep -o "Device:\s*[a-z0-9]*" | grep -o -E '[a-z0-9]*$')
      callback='ipconfig getifaddr $item'

      ip=$(getRelevantItem "$interfaces" "$callback")
    fi
  else
    if defined POWERLEVEL9K_IP_INTERFACE; then
      # Get the IP address of the specified interface.
      ip=$(ip -4 a show "$POWERLEVEL9K_IP_INTERFACE" | grep -o "inet\s*[0-9.]*" | grep -o -E "[0-9.]+")
    else
      local interfaces callback
      # Get all network interface names that are up
      interfaces=$(ip link ls up | grep -o -E ":\s+[a-z0-9]+:" | grep -v "lo" | grep -o -E "[a-z0-9]+")
      callback='ip -4 a show $item | grep -o "inet\s*[0-9.]*" | grep -o -E "[0-9.]+"'

      ip=$(getRelevantItem "$interfaces" "$callback")
    fi
  fi

  if [[ -n "$ip" ]]; then
    "$1_prompt_segment" "$0" "$2" "cyan" "$DEFAULT_COLOR" "$ip" 'NETWORK_ICON'
  fi
}

################################################################
# Segment to display if VPN is active
set_default POWERLEVEL9K_VPN_IP_INTERFACE "tun"
# prompt if vpn active
prompt_vpn_ip() {
  for vpn_iface in $(/sbin/ifconfig | grep -e "^${POWERLEVEL9K_VPN_IP_INTERFACE}" | cut -d":" -f1)
  do
    ip=$(/sbin/ifconfig "$vpn_iface" | grep -o "inet\s.*" | cut -d' ' -f2)
    "$1_prompt_segment" "$0" "$2" "cyan" "$DEFAULT_COLOR" "$ip" 'VPN_ICON'
  done
}

################################################################
# Segment to display laravel version
prompt_laravel_version() {
  local laravel_version="$(php artisan --version 2> /dev/null)"
  if [[ -n "${laravel_version}" && "${laravel_version}" =~ "Laravel Framework" ]]; then
    # Strip out everything but the version
    laravel_version="${laravel_version//Laravel Framework /}"
    "$1_prompt_segment" "$0" "$2" "maroon" "white" "${laravel_version}" 'LARAVEL_ICON'
  fi
}

################################################################
# Segment to display load
set_default POWERLEVEL9K_LOAD_WHICH 5
prompt_load() {
  local ROOT_PREFIX="${4}"
  # The load segment can have three different states
  local current_state="unknown"
  local load_select=2
  local load_avg
  local cores

  typeset -AH load_states
  load_states=(
    'critical'      'red'
    'warning'       'yellow'
    'normal'        'green'
  )

  case "$POWERLEVEL9K_LOAD_WHICH" in
    1)
      load_select=1
      ;;
    5)
      load_select=2
      ;;
    15)
      load_select=3
      ;;
  esac

  case "$OS" in
    OSX|BSD)
      load_avg=$(sysctl vm.loadavg | grep -o -E '[0-9]+(\.|,)[0-9]+' | sed -n ${load_select}p)
      if [[ "$OS" == "OSX" ]]; then
        cores=$(sysctl -n hw.logicalcpu)
      else
        cores=$(sysctl -n hw.ncpu)
      fi
      ;;
    *)
      load_avg=$(cut -d" " -f${load_select} ${ROOT_PREFIX}/proc/loadavg)
      cores=$(nproc)
  esac

  # Replace comma
  load_avg=${load_avg//,/.}

  if [[ "$load_avg" -gt $((${cores} * 0.7)) ]]; then
    current_state="critical"
  elif [[ "$load_avg" -gt $((${cores} * 0.5)) ]]; then
    current_state="warning"
  else
    current_state="normal"
  fi

  "$1_prompt_segment" "${0}_${current_state}" "$2" "${load_states[$current_state]}" "$DEFAULT_COLOR" "$load_avg" 'LOAD_ICON'
}

################################################################
# Segment to diplay Node version
prompt_node_version() {
  local node_version=$(node -v 2>/dev/null)
  [[ -z "${node_version}" ]] && return

  "$1_prompt_segment" "$0" "$2" "green" "white" "${node_version:1}" 'NODE_ICON'
}

################################################################
# Segment to display Node version from NVM
# Only prints the segment if different than the default value
prompt_nvm() {
  local node_version nvm_default
  (( $+functions[nvm_version] )) || return

  node_version=$(nvm_version current)
  [[ -z "${node_version}" || ${node_version} == "none" ]] && return
  if [[ "$node_version" == "system" ]]; then
    node_version="$($(nvm which system) --version) system"
  fi

  nvm_default=$(nvm_version default)
  [[ "$node_version" =~ "$nvm_default" ]] && return

  if [[ "${node_version:0:1}" == "v" ]]; then
    node_version=${node_version:1}
  fi

  $1_prompt_segment "$0" "$2" "magenta" "black" "${node_version}" 'NODE_ICON'
}

################################################################
# Segment to display NodeEnv
prompt_nodeenv() {
  local nodeenv_path="$NODE_VIRTUAL_ENV"
  if [[ -n "$nodeenv_path" && "$NODE_VIRTUAL_ENV_DISABLE_PROMPT" != true ]]; then
    local info="$(node -v)[$(basename "$nodeenv_path")]"
    "$1_prompt_segment" "$0" "$2" "black" "green" "$info" 'NODE_ICON'
  fi
}

################################################################
# Segment to print a little OS icon
prompt_os_icon() {
  "$1_prompt_segment" "$0" "$2" "black" "white" "$OS_ICON"
}

################################################################
# Segment to display PHP version number
prompt_php_version() {
  local php_version
  php_version=$(php -v 2>&1 | grep -oe "^PHP\s*[0-9.]*")

  if [[ -n "$php_version" ]]; then
    "$1_prompt_segment" "$0" "$2" "fuchsia" "grey93" "$php_version"
  fi
}

################################################################
# Segment to display free RAM and used Swap
prompt_ram() {
  local ROOT_PREFIX="${4}"
  local base=''
  local ramfree=0
  if [[ "$OS" == "OSX" ]]; then
    # Available = Free + Inactive
    # See https://support.apple.com/en-us/HT201538
    ramfree=$(vm_stat | grep "Pages free" | grep -o -E '[0-9]+')
    ramfree=$((ramfree + $(vm_stat | grep "Pages inactive" | grep -o -E '[0-9]+')))
    # Convert pages into Bytes
    ramfree=$(( ramfree * 4096 ))
  else
    if [[ "$OS" == "BSD" ]]; then
      ramfree=$(grep 'avail memory' ${ROOT_PREFIX}/var/run/dmesg.boot | awk '{print $4}')
    else
      ramfree=$(grep -o -E "MemAvailable:\s+[0-9]+" ${ROOT_PREFIX}/proc/meminfo | grep -o -E "[0-9]+")
      base='K'
    fi
  fi

  "$1_prompt_segment" "$0" "$2" "yellow" "$DEFAULT_COLOR" "$(printSizeHumanReadable "$ramfree" $base)" 'RAM_ICON'
}

################################################################
# Segment to display rbenv information
# https://github.com/rbenv/rbenv#choosing-the-ruby-version
set_default POWERLEVEL9K_RBENV_PROMPT_ALWAYS_SHOW false
prompt_rbenv() {
  if [[ -n "$RBENV_VERSION" ]]; then
    "$1_prompt_segment" "$0" "$2" "red" "$DEFAULT_COLOR" "$RBENV_VERSION" 'RUBY_ICON'
  elif [ $commands[rbenv] ]; then
    local rbenv_version_name="$(rbenv version-name)"
    local rbenv_global="$(rbenv global)"
    if [[ "${rbenv_version_name}" != "${rbenv_global}" || "${POWERLEVEL9K_RBENV_PROMPT_ALWAYS_SHOW}" == "true" ]]; then
      "$1_prompt_segment" "$0" "$2" "red" "$DEFAULT_COLOR" "$rbenv_version_name" 'RUBY_ICON'
    fi
  fi
}

################################################################
# Segment to display chruby information
# see https://github.com/postmodern/chruby/issues/245 for chruby_auto issue with ZSH
prompt_chruby() {
  # Uses $RUBY_VERSION and $RUBY_ENGINE set by chruby
  set_default POWERLEVEL9K_CHRUBY_SHOW_VERSION true
  set_default POWERLEVEL9K_CHRUBY_SHOW_ENGINE true
  local chruby_label=""

  if [[ "$POWERLEVEL9K_CHRUBY_SHOW_ENGINE" == true ]]; then
    chruby_label+="$RUBY_ENGINE "
  fi
  if [[ "$POWERLEVEL9K_CHRUBY_SHOW_VERSION" == true ]]; then
    chruby_label+="$RUBY_VERSION"
  fi

  # Truncate trailing spaces
  chruby_label="${chruby_label%"${chruby_label##*[![:space:]]}"}"

  # Don't show anything if the chruby did not change the default ruby
  if [[ "$RUBY_ENGINE" != "" ]]; then
    "$1_prompt_segment" "$0" "$2" "red" "$DEFAULT_COLOR" "${chruby_label}" 'RUBY_ICON'
  fi
}

################################################################
# Segment to print an icon if user is root.
prompt_root_indicator() {
  if [[ "$UID" -eq 0 ]]; then
    "$1_prompt_segment" "$0" "$2" "$DEFAULT_COLOR" "yellow" "" 'ROOT_ICON'
  fi
}

################################################################
# Segment to display Rust version number
prompt_rust_version() {
  local rust_version
  rust_version=$(command rustc --version 2>/dev/null)
  # Remove "rustc " (including the whitespace) from the beginning
  # of the version string and remove everything after the next
  # whitespace. This way we'll end up with only the version.
  rust_version=${${rust_version/rustc /}%% *}

  if [[ -n "$rust_version" ]]; then
    "$1_prompt_segment" "$0" "$2" "darkorange" "$DEFAULT_COLOR" "$rust_version" 'RUST_ICON'
  fi
}

# RSpec test ratio
prompt_rspec_stats() {
  if [[ (-d app && -d spec) ]]; then
    local code_amount tests_amount
    code_amount=$(ls -1 app/**/*.rb | wc -l)
    tests_amount=$(ls -1 spec/**/*.rb | wc -l)

    build_test_stats "$1" "$0" "$2" "$code_amount" "$tests_amount" "RSpec" 'TEST_ICON'
  fi
}

################################################################
# Segment to display Ruby Version Manager information
prompt_rvm() {
  local version_and_gemset=${rvm_env_string/ruby-}

  if [[ -n "$version_and_gemset" ]]; then
    "$1_prompt_segment" "$0" "$2" "grey35" "$DEFAULT_COLOR" "$version_and_gemset" 'RUBY_ICON'
  fi
}

################################################################
# Segment to display SSH icon when connected
prompt_ssh() {
  if [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]]; then
    "$1_prompt_segment" "$0" "$2" "$DEFAULT_COLOR" "yellow" "" 'SSH_ICON'
  fi
}

################################################################
# Status: When an error occur, return the error code, or a cross icon if option is set
# Display an ok icon when no error occur, or hide the segment if option is set to false
#
set_default POWERLEVEL9K_STATUS_CROSS false
set_default POWERLEVEL9K_STATUS_OK true
set_default POWERLEVEL9K_STATUS_SHOW_PIPESTATUS true
set_default POWERLEVEL9K_STATUS_HIDE_SIGNAME false
# old options, retro compatibility
set_default POWERLEVEL9K_STATUS_VERBOSE true
set_default POWERLEVEL9K_STATUS_OK_IN_NON_VERBOSE false

exit_code_or_status() {
  local ec=$1
  if [[ "$POWERLEVEL9K_STATUS_HIDE_SIGNAME" = true ]]; then
    echo "$ec"
  elif (( ec <= 128 )); then
    echo "$ec"
  else
    local sig=$(( ec - 128 ))
    local idx=$(( sig + 1 ))
    echo "SIG${signals[$idx]}(${sig})"
  fi
}

prompt_status() {
  local ec_text
  local ec_sum
  local ec

  if [[ $POWERLEVEL9K_STATUS_SHOW_PIPESTATUS == true ]]; then
    if (( $#RETVALS > 1 )); then
      ec_text=$(exit_code_or_status "${RETVALS[1]}")
      ec_sum=${RETVALS[1]}
    else
      ec_text=$(exit_code_or_status "${RETVAL}")
      ec_sum=${RETVAL}
    fi

    for ec in "${(@)RETVALS[2,-1]}"; do
      ec_text="${ec_text}|$(exit_code_or_status "$ec")"
      ec_sum=$(( $ec_sum + $ec ))
    done
  else
    # We use RETVAL instead of the right-most RETVALS item because
    # PIPE_FAIL may be set.
    ec_text=$(exit_code_or_status "${RETVAL}")
    ec_sum=${RETVAL}
  fi

  if (( ec_sum > 0 )); then
    if [[ "$POWERLEVEL9K_STATUS_CROSS" == false && "$POWERLEVEL9K_STATUS_VERBOSE" == true ]]; then
      "$1_prompt_segment" "$0_ERROR" "$2" "red" "yellow1" "$ec_text" 'CARRIAGE_RETURN_ICON'
    else
      "$1_prompt_segment" "$0_ERROR" "$2" "$DEFAULT_COLOR" "red" "" 'FAIL_ICON'
    fi
  elif [[ "$POWERLEVEL9K_STATUS_OK" == true ]] && [[ "$POWERLEVEL9K_STATUS_VERBOSE" == true || "$POWERLEVEL9K_STATUS_OK_IN_NON_VERBOSE" == true ]]; then
    "$1_prompt_segment" "$0_OK" "$2" "$DEFAULT_COLOR" "green" "" 'OK_ICON'
  fi
}

################################################################
# Segment to display Swap information
prompt_swap() {
  local ROOT_PREFIX="${4}"
  local swap_used=0
  local base=''

  if [[ "$OS" == "OSX" ]]; then
    local raw_swap_used
    raw_swap_used=$(sysctl vm.swapusage | grep -o "used\s*=\s*[0-9,.A-Z]*" | grep -o "[0-9,.A-Z]*$")

    typeset -F 2 swap_used
    swap_used=${$(echo $raw_swap_used | grep -o "[0-9,.]*")//,/.}
    # Replace comma
    swap_used=${swap_used//,/.}

    base=$(echo "$raw_swap_used" | grep -o "[A-Z]*$")
  else
    swap_total=$(grep -o -E "SwapTotal:\s+[0-9]+" ${ROOT_PREFIX}/proc/meminfo | grep -o -E "[0-9]+")
    swap_free=$(grep -o -E "SwapFree:\s+[0-9]+" ${ROOT_PREFIX}/proc/meminfo | grep -o -E "[0-9]+")
    swap_used=$(( swap_total - swap_free ))
    base='K'
  fi

  "$1_prompt_segment" "$0" "$2" "yellow" "$DEFAULT_COLOR" "$(printSizeHumanReadable "$swap_used" $base)" 'SWAP_ICON'
}

################################################################
# Symfony2-PHPUnit test ratio
prompt_symfony2_tests() {
  if [[ (-d src && -d app && -f app/AppKernel.php) ]]; then
    local code_amount tests_amount
    code_amount=$(ls -1 src/**/*.php | grep -vc Tests)
    tests_amount=$(ls -1 src/**/*.php | grep -c Tests)

    build_test_stats "$1" "$0" "$2" "$code_amount" "$tests_amount" "SF2" 'TEST_ICON'
  fi
}

################################################################
# Segment to display Symfony2-Version
prompt_symfony2_version() {
  if [[ -f app/bootstrap.php.cache ]]; then
    local symfony2_version
    symfony2_version=$(grep " VERSION " app/bootstrap.php.cache | sed -e 's/[^.0-9]*//g')
    "$1_prompt_segment" "$0" "$2" "grey35" "$DEFAULT_COLOR" "$symfony2_version" 'SYMFONY_ICON'
  fi
}

################################################################
# Show a ratio of tests vs code
build_test_stats() {
  local code_amount="$4"
  local tests_amount="$5"+0.00001
  local headline="$6"

  # Set float precision to 2 digits:
  typeset -F 2 ratio
  local ratio=$(( (tests_amount/code_amount) * 100 ))

  (( ratio >= 75 )) && "$1_prompt_segment" "${2}_GOOD" "$3" "cyan" "$DEFAULT_COLOR" "$headline: $ratio%%" "$6"
  (( ratio >= 50 && ratio < 75 )) && "$1_prompt_segment" "$2_AVG" "$3" "yellow" "$DEFAULT_COLOR" "$headline: $ratio%%" "$6"
  (( ratio < 50 )) && "$1_prompt_segment" "$2_BAD" "$3" "red" "$DEFAULT_COLOR" "$headline: $ratio%%" "$6"
}

################################################################
# System time
prompt_time() {
  set_default POWERLEVEL9K_TIME_FORMAT "%D{%H:%M:%S}"

  "$1_prompt_segment" "$0" "$2" "$DEFAULT_COLOR_INVERTED" "$DEFAULT_COLOR" "$POWERLEVEL9K_TIME_FORMAT" "TIME_ICON"
}

################################################################
# System date
prompt_date() {
  set_default POWERLEVEL9K_DATE_FORMAT "%D{%d.%m.%y}"

  "$1_prompt_segment" "$0" "$2" "$DEFAULT_COLOR_INVERTED" "$DEFAULT_COLOR" "$POWERLEVEL9K_DATE_FORMAT" "DATE_ICON"
}

################################################################
# todo.sh: shows the number of tasks in your todo.sh file
prompt_todo() {
  if $(hash todo.sh 2>&-); then
    count=$(todo.sh ls | egrep "TODO: [0-9]+ of ([0-9]+) tasks shown" | awk '{ print $4 }')
    if [[ "$count" = <-> ]]; then
      "$1_prompt_segment" "$0" "$2" "grey50" "$DEFAULT_COLOR" "$count" 'TODO_ICON'
    fi
  fi
}

################################################################
# VCS segment: shows the state of your repository, if you are in a folder under
# version control
set_default POWERLEVEL9K_VCS_ACTIONFORMAT_FOREGROUND "red"
# Default: Just display the first 8 characters of our changeset-ID.
set_default POWERLEVEL9K_VCS_INTERNAL_HASH_LENGTH "8"
powerlevel9k_vcs_init() {
  if [[ -n "$POWERLEVEL9K_CHANGESET_HASH_LENGTH" ]]; then
    POWERLEVEL9K_VCS_INTERNAL_HASH_LENGTH="$POWERLEVEL9K_CHANGESET_HASH_LENGTH"
  fi

  # Load VCS_INFO
  autoload -Uz vcs_info

  VCS_WORKDIR_DIRTY=false
  VCS_WORKDIR_HALF_DIRTY=false

  # The vcs segment can have three different states - defaults to 'clean'.
  typeset -gAH vcs_states
  vcs_states=(
    'clean'         'green'
    'modified'      'yellow'
    'untracked'     'green'
  )

  VCS_CHANGESET_PREFIX=''
  if [[ "$POWERLEVEL9K_SHOW_CHANGESET" == true ]]; then
    VCS_CHANGESET_PREFIX="$(print_icon 'VCS_COMMIT_ICON')%0.$POWERLEVEL9K_VCS_INTERNAL_HASH_LENGTH""i "
  fi

  zstyle ':vcs_info:*' enable git hg svn
  zstyle ':vcs_info:*' check-for-changes true

  VCS_DEFAULT_FORMAT="$VCS_CHANGESET_PREFIX%b%c%u%m"
  zstyle ':vcs_info:*' formats "$VCS_DEFAULT_FORMAT"

  zstyle ':vcs_info:*' actionformats "%b %F{${POWERLEVEL9K_VCS_ACTIONFORMAT_FOREGROUND}}| %a%f"

  zstyle ':vcs_info:*' stagedstr " $(print_icon 'VCS_STAGED_ICON')"
  zstyle ':vcs_info:*' unstagedstr " $(print_icon 'VCS_UNSTAGED_ICON')"

  defined POWERLEVEL9K_VCS_GIT_HOOKS || POWERLEVEL9K_VCS_GIT_HOOKS=(vcs-detect-changes git-untracked git-aheadbehind git-stash git-remotebranch git-tagname)
  zstyle ':vcs_info:git*+set-message:*' hooks $POWERLEVEL9K_VCS_GIT_HOOKS
  defined POWERLEVEL9K_VCS_HG_HOOKS || POWERLEVEL9K_VCS_HG_HOOKS=(vcs-detect-changes)
  zstyle ':vcs_info:hg*+set-message:*' hooks $POWERLEVEL9K_VCS_HG_HOOKS
  defined POWERLEVEL9K_VCS_SVN_HOOKS || POWERLEVEL9K_VCS_SVN_HOOKS=(vcs-detect-changes svn-detect-changes)
  zstyle ':vcs_info:svn*+set-message:*' hooks $POWERLEVEL9K_VCS_SVN_HOOKS

  # For Hg, only show the branch name
  zstyle ':vcs_info:hg*:*' branchformat "$(print_icon 'VCS_BRANCH_ICON')%b"
  # The `get-revision` function must be turned on for dirty-check to work for Hg
  zstyle ':vcs_info:hg*:*' get-revision true
  zstyle ':vcs_info:hg*:*' get-bookmarks true
  zstyle ':vcs_info:hg*+gen-hg-bookmark-string:*' hooks hg-bookmarks

  # For svn, only
  # TODO fix the %b (branch) format for svn. Using %b breaks
  # color-encoding of the foreground for the rest of the powerline.
  zstyle ':vcs_info:svn*:*' formats "$VCS_CHANGESET_PREFIX%c%u"
  zstyle ':vcs_info:svn*:*' actionformats "$VCS_CHANGESET_PREFIX%c%u %F{${POWERLEVEL9K_VCS_ACTIONFORMAT_FOREGROUND}}| %a%f"

  if [[ "$POWERLEVEL9K_SHOW_CHANGESET" == true ]]; then
    zstyle ':vcs_info:*' get-revision true
  fi
}

################################################################
# Segment to show VCS information
prompt_vcs() {
  VCS_WORKDIR_DIRTY=false
  VCS_WORKDIR_HALF_DIRTY=false
  local current_state=""

  # Actually invoke vcs_info manually to gather all information.
  vcs_info
  local vcs_prompt="${vcs_info_msg_0_}"

  if [[ -n "$vcs_prompt" ]]; then
    if [[ "$VCS_WORKDIR_DIRTY" == true ]]; then
      # $vcs_visual_identifier gets set in +vi-vcs-detect-changes in functions/vcs.zsh,
      # as we have there access to vcs_info internal hooks.
      current_state='modified'
    else
      if [[ "$VCS_WORKDIR_HALF_DIRTY" == true ]]; then
        current_state='untracked'
      else
        current_state='clean'
      fi
    fi
    "$1_prompt_segment" "${0}_${(U)current_state}" "$2" "${vcs_states[$current_state]}" "$DEFAULT_COLOR" "$vcs_prompt" "$vcs_visual_identifier"
  fi
}

################################################################
# Vi Mode: show editing mode (NORMAL|INSERT)
set_default POWERLEVEL9K_VI_INSERT_MODE_STRING "INSERT"
set_default POWERLEVEL9K_VI_COMMAND_MODE_STRING "NORMAL"
prompt_vi_mode() {
  case ${KEYMAP} in
    vicmd)
      "$1_prompt_segment" "$0_NORMAL" "$2" "$DEFAULT_COLOR" "white" "$POWERLEVEL9K_VI_COMMAND_MODE_STRING"
    ;;
    main|viins|*)
      if [[ -z $POWERLEVEL9K_VI_INSERT_MODE_STRING ]]; then return; fi
      "$1_prompt_segment" "$0_INSERT" "$2" "$DEFAULT_COLOR" "blue" "$POWERLEVEL9K_VI_INSERT_MODE_STRING"
    ;;
  esac
}

################################################################
# Virtualenv: current working virtualenv
# More information on virtualenv (Python):
# https://virtualenv.pypa.io/en/latest/
prompt_virtualenv() {
  local virtualenv_path="$VIRTUAL_ENV"
  if [[ -n "$virtualenv_path" && -z "$VIRTUAL_ENV_DISABLE_PROMPT" ]]; then
    "$1_prompt_segment" "$0" "$2" "blue" "$DEFAULT_COLOR" "$(basename "$virtualenv_path")" 'PYTHON_ICON'
  fi
}

################################################################
# Segment to display pyenv information
# https://github.com/pyenv/pyenv#choosing-the-python-version
set_default POWERLEVEL9K_PYENV_PROMPT_ALWAYS_SHOW false
prompt_pyenv() {
  if [[ -n "$PYENV_VERSION" ]]; then
    "$1_prompt_segment" "$0" "$2" "blue" "$DEFAULT_COLOR" "$PYENV_VERSION" 'PYTHON_ICON'
  elif [ $commands[pyenv] ]; then
    local pyenv_version_name="$(pyenv version-name)"
    local pyenv_global="system"
    local pyenv_root="$(pyenv root)"
    if [[ -f "${pyenv_root}/version" ]]; then
      pyenv_global="$(pyenv version-file-read ${pyenv_root}/version)"
    fi
    if [[ "${pyenv_version_name}" != "${pyenv_global}" || "${POWERLEVEL9K_PYENV_PROMPT_ALWAYS_SHOW}" == "true" ]]; then
      "$1_prompt_segment" "$0" "$2" "blue" "$DEFAULT_COLOR" "$pyenv_version_name" 'PYTHON_ICON'
    fi
  fi
}

################################################################
# Display openfoam information
prompt_openfoam() {
  local wm_project_version="$WM_PROJECT_VERSION"
  local wm_fork="$WM_FORK"
  if [[ -n "$wm_project_version" ]] &&  [[ -z "$wm_fork" ]] ; then
    "$1_prompt_segment" "$0" "$2" "yellow" "$DEFAULT_COLOR" "OF: $(basename "$wm_project_version")"
  elif [[ -n "$wm_project_version" ]] && [[ -n "$wm_fork" ]] ; then
    "$1_prompt_segment" "$0" "$2" "yellow" "$DEFAULT_COLOR" "F-X: $(basename "$wm_project_version")"
  fi
}

################################################################
# Segment to display Swift version
prompt_swift_version() {
  # Get the first number as this is probably the "main" version number..
  local swift_version=$(swift --version 2>/dev/null | grep -o -E "[0-9.]+" | head -n 1)
  [[ -z "${swift_version}" ]] && return

  "$1_prompt_segment" "$0" "$2" "magenta" "white" "${swift_version}" 'SWIFT_ICON'
}

################################################################
# dir_writable: Display information about the user's permission to write in the current directory
prompt_dir_writable() {
  if [[ ! -w "$PWD" ]]; then
    "$1_prompt_segment" "$0_FORBIDDEN" "$2" "red" "yellow1" "" 'LOCK_ICON'
  fi
}

################################################################
# Kubernetes Current Context/Namespace
prompt_kubecontext() {
  local kubectl_version="$(kubectl version --client 2>/dev/null)"

  if [[ -n "$kubectl_version" ]]; then
    # Get the current Kuberenetes context
    local cur_ctx=$(kubectl config view -o=jsonpath='{.current-context}')
    cur_namespace="$(kubectl config view -o=jsonpath="{.contexts[?(@.name==\"${cur_ctx}\")].context.namespace}")"
    # If the namespace comes back empty set it default.
    if [[ -z "${cur_namespace}" ]]; then
      cur_namespace="default"
    fi

    local k8s_final_text=""

    if [[ "$cur_ctx" == "$cur_namespace" ]]; then
      # No reason to print out the same identificator twice
      k8s_final_text="$cur_ctx"
    else
      k8s_final_text="$cur_ctx/$cur_namespace"
    fi

    "$1_prompt_segment" "$0" "$2" "magenta" "white" "$k8s_final_text" "KUBERNETES_ICON"
  fi
}

################################################################
# Dropbox status
prompt_dropbox() {
  # The first column is just the directory, so cut it
  local dropbox_status="$(dropbox-cli filestatus . | cut -d\  -f2-)"

  # Only show if the folder is tracked and dropbox is running
  if [[ "$dropbox_status" != 'unwatched' && "$dropbox_status" != "isn't running!" ]]; then
    # If "up to date", only show the icon
    if [[ "$dropbox_status" =~ 'up to date' ]]; then
      dropbox_status=""
    fi

    "$1_prompt_segment" "$0" "$2" "white" "blue" "$dropbox_status" "DROPBOX_ICON"
  fi
}

# print Java version number
prompt_java_version() {
  local java_version
  # Stupid: Java prints its version on STDERR.
  # The first version ouput will print nothing, we just
  # use it to transport whether the command was successful.
  # If yes, we parse the version string (and need to
  # redirect the stderr to stdout to make the pipe work).
  java_version=$(java -version 2>/dev/null && java -fullversion 2>&1 | cut -d '"' -f 2)

  if [[ -n "$java_version" ]]; then
    "$1_prompt_segment" "$0" "$2" "red" "white" "$java_version" "JAVA_ICON"
  fi
}

################################################################
# Prompt processing and drawing
################################################################
# Main prompt
build_left_prompt() {
  local index=1
  local element
  for element in "${POWERLEVEL9K_LEFT_PROMPT_ELEMENTS[@]}"; do
    # Remove joined information in direct calls
    element=${element%_joined}

    # Check if it is a custom command, otherwise interpet it as
    # a prompt.
    if [[ $element[0,7] =~ "custom_" ]]; then
      "prompt_custom" "left" "$index" $element[8,-1]
    else
      "prompt_$element" "left" "$index"
    fi

    index=$((index + 1))
  done

  left_prompt_end
}

# Right prompt
build_right_prompt() {
  local index=1
  local element
  for element in "${POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS[@]}"; do
    # Remove joined information in direct calls
    element=${element%_joined}

    # Check if it is a custom command, otherwise interpet it as
    # a prompt.
    if [[ $element[0,7] =~ "custom_" ]]; then
      "prompt_custom" "right" "$index" $element[8,-1]
    else
      "prompt_$element" "right" "$index"
    fi

    index=$((index + 1))
  done

  # Clear to the end of the line
  echo -n "%E"
}

powerlevel9k_preexec() {
  _P9K_TIMER_START=$EPOCHREALTIME
}

set_default POWERLEVEL9K_PROMPT_ADD_NEWLINE false
powerlevel9k_prepare_prompts() {
  # Return values. These need to be global, because
  # they are used in prompt_status. Also, we need
  # to get the return value of the last command at
  # very first in this function. Do not move the
  # lines down, otherwise the last command is not
  # what you expected it to be.
  RETVAL=$?
  RETVALS=( "$pipestatus[@]" )

  local RPROMPT_SUFFIX RPROMPT_PREFIX
  _P9K_COMMAND_DURATION=$((EPOCHREALTIME - _P9K_TIMER_START))

  # Reset start time
  _P9K_TIMER_START=0x7FFFFFFF

  if [[ "$POWERLEVEL9K_PROMPT_ON_NEWLINE" == true ]]; then
    PROMPT='$(print_icon 'MULTILINE_FIRST_PROMPT_PREFIX')%f%b%k$(build_left_prompt)
$(print_icon 'MULTILINE_LAST_PROMPT_PREFIX')'
    if [[ "$POWERLEVEL9K_RPROMPT_ON_NEWLINE" != true ]]; then
      # The right prompt should be on the same line as the first line of the left
      # prompt. To do so, there is just a quite ugly workaround: Before zsh draws
      # the RPROMPT, we advise it, to go one line up. At the end of RPROMPT, we
      # advise it to go one line down. See:
      # http://superuser.com/questions/357107/zsh-right-justify-in-ps1
      local LC_ALL="" LC_CTYPE="en_US.UTF-8" # Set the right locale to protect special characters
      RPROMPT_PREFIX='%{'$'\e[1A''%}' # one line up
      RPROMPT_SUFFIX='%{'$'\e[1B''%}' # one line down
    else
      RPROMPT_PREFIX=''
      RPROMPT_SUFFIX=''
    fi
  else
    PROMPT='%f%b%k$(build_left_prompt)'
    RPROMPT_PREFIX=''
    RPROMPT_SUFFIX=''
  fi

  if [[ "$POWERLEVEL9K_DISABLE_RPROMPT" != true ]]; then
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

>>>>>>> 9d03e3d... nvm: render system node version when nvm current is system
prompt_powerlevel9k_setup "$@"

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
#zstyle ':vcs_info:*+*:*' debug true
#set -o xtrace

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
    POWERLEVEL9K_INSTALLATION_PATH=$(whence -v $0 | sed "s/$0 is a shell function from //")
  elif [[ -f "${ZDOTDIR:-$HOME}/.zprezto/modules/prompt/init.zsh" ]]; then
    # If there is an prezto installation, we assume that powerlevel9k is linked there.
    POWERLEVEL9K_INSTALLATION_PATH="${ZDOTDIR:-$HOME}/.zprezto/modules/prompt/functions/prompt_powerlevel9k_setup"
  fi
else
  # Last resort: Set installation path is script path
  POWERLEVEL9K_INSTALLATION_PATH="$0"
fi

# Resolve the instllation path
if [[ -L "$POWERLEVEL9K_INSTALLATION_PATH" ]]; then
  # If this theme is sourced as a symlink, we need to locate the real URL
  filename="$(realpath -P $POWERLEVEL9K_INSTALLATION_PATH 2>/dev/null || readlink -f $POWERLEVEL9K_INSTALLATION_PATH 2>/dev/null || perl -MCwd=abs_path -le 'print abs_path readlink(shift);' $POWERLEVEL9K_INSTALLATION_PATH 2>/dev/null)"
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
# Prompt Segment Constructors
################################################################

# Begin a left prompt segment
# Takes four arguments:
#   * $1: Name of the function that was orginally invoked (mandatory).
#         Necessary, to make the dynamic color-overwrite mechanism work.
#   * $2: The array index of the current segment
#   * $3: Background color
#   * $4: Foreground color
#   * $5: The segment content
#   * $6: An identifying icon (must be a key of the icons array)
#   * $7: Last segments background color
# The latter three can be omitted,
set_default last_left_element_index 1
set_default POWERLEVEL9K_WHITESPACE_BETWEEN_LEFT_SEGMENTS " "
left_prompt_segment() {
  local current_index="${2}"

  # Check if the segment should be joined with the previous one
  local joined
  segmentShouldBeJoined "left" "${current_index}" && joined=true || joined=false

  local BACKGROUND_OF_LAST_SEGMENT="${7}"

  local bg fg
  [[ -n "${3}" ]] && bg="%K{$3}" || bg="%k"
  [[ -n "${4}" ]] && fg="%F{$4}" || fg="%f"

  if [[ "${BACKGROUND_OF_LAST_SEGMENT}" != 'NONE' ]] && ! isSameColor "${3}" "${BACKGROUND_OF_LAST_SEGMENT}"; then
    echo -n "${bg}%F{$BACKGROUND_OF_LAST_SEGMENT}"
    if [[ ${joined} == false ]]; then
      # Middle segment
      echo -n "${_POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR}${POWERLEVEL9K_WHITESPACE_BETWEEN_LEFT_SEGMENTS}"
    fi
  elif isSameColor "${BACKGROUND_OF_LAST_SEGMENT}" "${3}"; then
    # Middle segment with same color as previous segment
    # We take the current foreground color as color for our
    # subsegment (or the default color). This should have
    # enough contrast.
    local complement
    [[ -n "${4}" ]] && complement="${4}" || complement="${DEFAULT_COLOR}"
    echo -n "${bg}%F{$complement}"
    if [[ ${joined} == false ]]; then
      echo -n "${_POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR}${POWERLEVEL9K_WHITESPACE_BETWEEN_LEFT_SEGMENTS}"
    fi
  else
    # First segment
    echo -n "${bg}${POWERLEVEL9K_WHITESPACE_BETWEEN_LEFT_SEGMENTS}"
  fi

  # Print the visual identifier
  echo -n "${6}"
  # Print the content of the segment, if there is any
  [[ -n "${5}" ]] && echo -n "${fg}${5}"
  echo -n "${POWERLEVEL9K_WHITESPACE_BETWEEN_LEFT_SEGMENTS}"

  BACKGROUND_OF_LAST_SEGMENT="${3}"
  last_left_element_index="${current_index}"
}

# End the left prompt, closes the final segment.
#   * $1: Last segments background color
left_prompt_end() {
  local BACKGROUND_OF_LAST_SEGMENT="${1}"
  if [[ -n "${BACKGROUND_OF_LAST_SEGMENT}" ]]; then
    echo -n "%k%F{$BACKGROUND_OF_LAST_SEGMENT}${_POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR}"
  else
    echo -n "%k"
  fi
  echo -n "%f${_POWERLEVEL9K_LEFT_SEGMENT_END_SEPARATOR}"
}

# Begin a right prompt segment
# Takes four arguments:
#   * $1: Name of the function that was orginally invoked (mandatory).
#         Necessary, to make the dynamic color-overwrite mechanism work.
#   * $2: The array index of the current segment
#   * $3: Background color
#   * $4: Foreground color
#   * $5: The segment content
#   * $6: An identifying icon (must be a key of the icons array)
#   * $7: Last segments background color
# No ending for the right prompt segment is needed (unlike the left prompt, above).
set_default last_right_element_index 1
set_default POWERLEVEL9K_WHITESPACE_BETWEEN_RIGHT_SEGMENTS " "
right_prompt_segment() {
  local current_index="${2}"
  local CURRENT_RIGHT_BG="${7}"

  # Check if the segment should be joined with the previous one
  local joined
  segmentShouldBeJoined "right" "${current_index}" && joined=true || joined=false

  local bg fg
  [[ -n "${3}" ]] && bg="%K{$3}" || bg="%k"
  [[ -n "${4}" ]] && fg="%F{$4}" || fg="%f"

  # If CURRENT_RIGHT_BG is "NONE", we are the first right segment.
  if [[ ${joined} == false ]] || [[ "${CURRENT_RIGHT_BG}" == "NONE" ]]; then
    if isSameColor "${CURRENT_RIGHT_BG}" "${3}"; then
      # Middle segment with same color as previous segment
      # We take the current foreground color as color for our
      # subsegment (or the default color). This should have
      # enough contrast.
      local complement
      [[ -n "${4}" ]] && complement="${4}" || complement=$DEFAULT_COLOR
      echo -n "%F{$complement}${_POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR}%f"
    else
      echo -n "%F{$3}${_POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR}%f"
    fi
  fi

  echo -n "${bg}${fg}"

  # Print whitespace only if segment is not joined or first right segment
  [[ ${joined} == false ]] || [[ "${CURRENT_RIGHT_BG}" == "NONE" ]] && echo -n "${POWERLEVEL9K_WHITESPACE_BETWEEN_RIGHT_SEGMENTS}"

  # Print segment content if there is any
  [[ -n "${5}" ]] && echo -n "${5}"
  # Print the visual identifier
  echo -n "${6}${POWERLEVEL9K_WHITESPACE_BETWEEN_RIGHT_SEGMENTS}%f"

  CURRENT_RIGHT_BG="${3}"
  last_right_element_index="${current_index}"
}

################################################################
# Prompt Segment Definitions
################################################################

# Anaconda Environment
prompt_anaconda() {
  # Depending on the conda version, either might be set. This
  # variant works even if both are set.
  local _path="${CONDA_ENV_PATH}${CONDA_PREFIX}"
  if ! [ -z "$_path" ]; then
    # config - can be overwritten in users' zshrc file.
    set_default POWERLEVEL9K_ANACONDA_LEFT_DELIMITER "("
    set_default POWERLEVEL9K_ANACONDA_RIGHT_DELIMITER ")"

    serialize_segment "$0" "" "$1" "$2" "${3}" "006" "white" "${POWERLEVEL9K_ANACONDA_LEFT_DELIMITER}$(basename $_path)${POWERLEVEL9K_ANACONDA_RIGHT_DELIMITER}" "PYTHON_ICON"
  fi
}

# AWS Profile
prompt_aws() {
  local aws_profile="$AWS_DEFAULT_PROFILE"

  serialize_segment "$0" "" "$1" "$2" "${3}" "red" "white" "${aws_profile}" "AWS_ICON"
}

# Current Elastic Beanstalk environment
prompt_aws_eb_env() {
  local eb_env=$(grep environment .elasticbeanstalk/config.yml 2> /dev/null | awk '{print $2}')

  serialize_segment "$0" "" "$1" "$2" "${3}" "black" "green" "${eb_env}" "AWS_EB_ICON"
}

# Segment to indicate background jobs with an icon.
set_default POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE true
prompt_background_jobs() {
  local background_jobs_number=${$(jobs -l | wc -l)// /}
  local wrong_lines=`jobs -l | awk '/pwd now/{ count++ } END {print count}'`
  if [[ wrong_lines -gt 0 ]]; then
     background_jobs_number=$(( $background_jobs_number - $wrong_lines ))
  fi
  if [[ background_jobs_number -gt 0 ]]; then
    local background_jobs_number_print=""
    if [[ "$POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE" == "true" ]] && [[ "$background_jobs_number" -gt 1 ]]; then
      background_jobs_number_print="$background_jobs_number"
    fi
    serialize_segment "$0" "" "$1" "$2" "${3}" "${DEFAULT_COLOR}" "cyan" "${background_jobs_number_print}" "BACKGROUND_JOBS_ICON"
  fi
}

prompt_battery() {
  # The battery can have four different states - default to 'unknown'.
  local current_state="unknown"
  typeset -AH battery_states
  battery_states=(
    'low'           'red'
    'charging'      'yellow'
    'charged'       'green'
    'disconnected'  "$DEFAULT_COLOR_INVERTED"
  )
  # Set default values if the user did not configure them
  set_default POWERLEVEL9K_BATTERY_LOW_THRESHOLD  10

  if [[ $OS =~ OSX && -f /usr/sbin/ioreg && -x /usr/sbin/ioreg ]]; then
    # Pre-Grep as much information as possible to save some memory and
    # avoid pollution of the xtrace output.
    local raw_data="$(ioreg -n AppleSmartBattery | grep -E "MaxCapacity|TimeRemaining|CurrentCapacity|ExternalConnected|IsCharging")"
    # return if there is no battery on system
    [[ -z $(echo $raw_data | grep MaxCapacity) ]] && return

    # Convert time remaining from minutes to hours:minutes date string
    local time_remaining=$(echo $raw_data | grep TimeRemaining | awk '{ print $5 }')
    if [[ -n $time_remaining ]]; then
      # this value is set to a very high number when the system is calculating
      [[ $time_remaining -gt 10000 ]] && local tstring="..." || local tstring=${(f)$(/bin/date -u -r $(($time_remaining * 60)) +%k:%M)}
    fi

    # Get charge values
    local max_capacity=$(echo $raw_data | grep MaxCapacity | awk '{ print $5 }')
    local current_capacity=$(echo $raw_data | grep CurrentCapacity | awk '{ print $5 }')

    if [[ -n "$max_capacity" && -n "$current_capacity" ]]; then
      typeset -i 10 bat_percent
      bat_percent=$(( (current_capacity * 100) / max_capacity ))
    fi

    local remain=""
    # Logic for string output
    if [[ $(echo $raw_data | grep ExternalConnected | awk '{ print $5 }') =~ "Yes" ]]; then
      # Battery is charging
      if [[ $(echo $raw_data | grep IsCharging | awk '{ print $5 }') =~ "Yes" ]]; then
        current_state="charging"
        remain=" ($tstring)"
      else
        current_state="charged"
      fi
    else
      [[ $bat_percent -lt $POWERLEVEL9K_BATTERY_LOW_THRESHOLD ]] && current_state="low" || current_state="disconnected"
      remain=" ($tstring)"
    fi
  fi

  if [[ $OS =~ Linux ]]; then
    local sysp="/sys/class/power_supply"
    # Reported BAT0 or BAT1 depending on kernel version
    [[ -a $sysp/BAT0 ]] && local bat=$sysp/BAT0
    [[ -a $sysp/BAT1 ]] && local bat=$sysp/BAT1

    # Return if no battery found
    [[ -z $bat ]] && return

    [[ $(cat $bat/capacity) -gt 100 ]] && local bat_percent=100 || local bat_percent=$(cat $bat/capacity)
    [[ $(cat $bat/status) =~ Charging ]] && local connected=true
    [[ $(cat $bat/status) =~ Charging && $bat_percent =~ 100 ]] && current_state="charged"
    [[ $(cat $bat/status) =~ Charging && $bat_percent -lt 100 ]] && current_state="charging"
    if [[ -z  $connected ]]; then
      [[ $bat_percent -lt $POWERLEVEL9K_BATTERY_LOW_THRESHOLD ]] && current_state="low" || current_state="disconnected"
    fi
    if [[ -f /usr/bin/acpi ]]; then
      local time_remaining=$(acpi | awk '{ print $5 }')
      if [[ $time_remaining =~ rate ]]; then
        local tstring="..."
      elif [[ $time_remaining =~ "[:digit:]+" ]]; then
        local tstring=${(f)$(date -u -d "$(echo $time_remaining)" +%k:%M)}
      fi
    fi
    [[ -n $tstring ]] && local remain=" ($tstring)"
  fi

  local message
  # Default behavior: Be verbose!
  set_default POWERLEVEL9K_BATTERY_VERBOSE true
  if [[ "$POWERLEVEL9K_BATTERY_VERBOSE" == true ]]; then
    message="$bat_percent%%$remain"
  else
    message="$bat_percent%%"
  fi

  # Draw the prompt_segment
  serialize_segment "$0" "${current_state}" "$1" "$2" "${3}" "${DEFAULT_COLOR}" "${battery_states[$current_state]}" "${message}" "BATTERY_ICON"
}

# Context: user@hostname (who am I and where am I)
# Note that if $DEFAULT_USER is not set, this prompt segment will always print
prompt_context() {
  local content
  local current_state="DEFAULT"
  typeset -AH context_states
  context_states=(
    'DEFAULT'      '011'
    'ROOT'         'yellow'
  )
  if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    content="${USER}@%m"
    if [[ $(print -P "%#") == '#' ]]; then
      # Shell runs as root
      state="ROOT"
    fi
  fi
  serialize_segment "$0" "${state}" "$1" "$2" "${3}" "${DEFAULT_COLOR}" "${context_states[$current_state]}" "${content}" ""
}

# The 'custom` prompt provides a way for users to invoke commands and display
# the output in a segment.
# arguments
#   * $1: Alignment
#   * $2: index
#   * $3: name
#   * $4: joined
prompt_custom() {
  local segment_name="${3:u}"
  local command="POWERLEVEL9K_CUSTOM_${segment_name}"
  local segment_content="$(eval ${(P)command})"

  serialize_segment "$0" "${segment_name}" "$1" "$2" "${4}" "${DEFAULT_COLOR_INVERTED}" "${DEFAULT_COLOR}" "${segment_content}" ""
}

# Dir: current working directory
prompt_dir() {
  local current_path='%~'
  if [[ -n "$POWERLEVEL9K_SHORTEN_DIR_LENGTH" ]]; then

    set_default POWERLEVEL9K_SHORTEN_DELIMITER $'\U2026'

    case "$POWERLEVEL9K_SHORTEN_STRATEGY" in
      truncate_middle)
        current_path=$(pwd | sed -e "s,^$HOME,~," | sed $SED_EXTENDED_REGEX_PARAMETER "s/([^/]{$POWERLEVEL9K_SHORTEN_DIR_LENGTH})[^/]+([^/]{$POWERLEVEL9K_SHORTEN_DIR_LENGTH})\//\1$POWERLEVEL9K_SHORTEN_DELIMITER\2\//g")
      ;;
      truncate_from_right)
        current_path=$(truncatePathFromRight "$(pwd | sed -e "s,^$HOME,~,")" )
      ;;
      truncate_with_package_name)
        local name repo_path package_path current_dir zero

        # Get the path of the Git repo, which should have the package.json file
        if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == "true" ]]; then
          package_path=$(git rev-parse --show-toplevel)
        elif [[ $(git rev-parse --is-inside-git-dir 2> /dev/null) == "true" ]]; then
          package_path=${$(pwd)%%/.git*}
        fi

        zero='%([BSUbfksu]|([FB]|){*})'
        current_dir=$(pwd)
        # Then, find the length of the package_path string, and save the
        # subdirectory path as a substring of the current directory's path from 0
        # to the length of the package path's string
        subdirectory_path=$(truncatePathFromRight "${current_dir:${#${(S%%)package_path//$~zero/}}}")
        # Parse the 'name' from the package.json; if there are any problems, just
        # print the file path
        if name=$( cat "$package_path/package.json" 2> /dev/null | grep -m 1 "\"name\""); then
          name=$(echo $name | awk -F ':' '{print $2}' | awk -F '"' '{print $2}')

          # Instead of printing out the full path, print out the name of the package
          # from the package.json and append the current subdirectory
          current_path="`echo $name | tr -d '"'`$subdirectory_path"
        else
          current_path=$(truncatePathFromRight "$(pwd | sed -e "s,^$HOME,~,")" )
        fi
      ;;
      *)
        current_path="%$((POWERLEVEL9K_SHORTEN_DIR_LENGTH+1))(c:$POWERLEVEL9K_SHORTEN_DELIMITER/:)%${POWERLEVEL9K_SHORTEN_DIR_LENGTH}c"
      ;;
    esac
  fi

  local current_icon=''
  if [[ $(print -P "%~") == '~' ]]; then
    serialize_segment "$0" "HOME" "$1" "$2" "${3}" "blue" "$DEFAULT_COLOR" "$current_path" 'HOME_ICON'
  elif [[ $(print -P "%~") == '~'* ]]; then
    serialize_segment "$0" "HOME_SUBFOLDER" "$1" "$2" "${3}" "blue" "$DEFAULT_COLOR" "$current_path" 'HOME_SUB_ICON'
  else
    serialize_segment "$0" "DEFAULT" "$1" "$2" "${3}" "blue" "$DEFAULT_COLOR" "$current_path" 'FOLDER_ICON'
  fi
}

# Docker machine
prompt_docker_machine() {
  local docker_machine="$DOCKER_MACHINE_NAME"

  serialize_segment "$0" "" "$1" "$2" "${3}" "magenta" "${DEFAULT_COLOR}" "${docker_machine}" "SERVER_ICON"
}

# GO prompt
prompt_go_version() {
  local go_version
  go_version=$(go version 2>/dev/null | sed -E "s/.*(go[0-9.]*).*/\1/")

  serialize_segment "$0" "" "$1" "$2" "${3}" "green" "255" "${go_version}" ""
}

# Command number (in local history)
prompt_history() {
  serialize_segment "$0" "" "$1" "$2" "${3}" "244" "${DEFAULT_COLOR}" "%h" ""
}

prompt_icons_test() {
  for key in ${(@k)icons}; do
    # The lower color spectrum in ZSH makes big steps. Choosing
    # the next color has enough contrast to read.
    local random_color=$((RANDOM % 8))
    local next_color=$((random_color+1))
    # TODO: How will that work async?
    "$1_prompt_segment" "$0" "$2" "$random_color" "$next_color" "$key" "$key"
  done
}

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
      ip=$(ip -4 a show "$POWERLEVEL9K_IP_INTERFACE" | grep -o "inet\s*[0-9.]*" | grep -o "[0-9.]*")
    else
      local interfaces callback
      # Get all network interface names that are up
      interfaces=$(ip link ls up | grep -o -E ":\s+[a-z0-9]+:" | grep -v "lo" | grep -o "[a-z0-9]*")
      callback='ip -4 a show $item | grep -o "inet\s*[0-9.]*" | grep -o "[0-9.]*"'

      ip=$(getRelevantItem "$interfaces" "$callback")
    fi
  fi

  serialize_segment "$0" "" "$1" "$2" "${3}" "cyan" "${DEFAULT_COLOR}" "${ip}" "NETWORK_ICON"
}

prompt_load() {
  # The load segment can have three different states
  local current_state="unknown"
  local cores

  typeset -AH load_states
  load_states=(
    'critical'      'red'
    'warning'       'yellow'
    'normal'        'green'
  )

  if [[ "$OS" == "OSX" ]] || [[ "$OS" == "BSD" ]]; then
    load_avg_1min=$(sysctl vm.loadavg | grep -o -E '[0-9]+(\.|,)[0-9]+' | head -n 1)
    if [[ "$OS" == "OSX" ]]; then
      cores=$(sysctl -n hw.logicalcpu)
    else
      cores=$(sysctl -n hw.ncpu)
    fi
  else
    load_avg_1min=$(grep -o "[0-9.]*" /proc/loadavg | head -n 1)
    cores=$(nproc)
  fi

  # Replace comma
  load_avg_1min=${load_avg_1min//,/.}

  if [[ "$load_avg_1min" -gt $(bc -l <<< "${cores} * 0.7") ]]; then
    current_state="critical"
  elif [[ "$load_avg_1min" -gt $(bc -l <<< "${cores} * 0.5") ]]; then
    current_state="warning"
  else
    current_state="normal"
  fi

  serialize_segment "$0" "${current_state}" "$1" "$2" "${3}" "${load_states[$current_state]}" "${DEFAULT_COLOR}" "${load_avg_1min}" "LOAD_ICON"
}

# Node version
prompt_node_version() {
  local node_version=$(node -v 2>/dev/null)

  serialize_segment "$0" "" "$1" "$2" "${3}" "green" "white" "${node_version:1}" "NODE_ICON"
}

# Node version from NVM
# Only prints the segment if different than the default value
prompt_nvm() {
  local node_version=$(nvm current 2> /dev/null)
  [[ "${node_version}" == "none" ]] && node_version=""
  local nvm_default=$(cat $NVM_DIR/alias/default 2> /dev/null)
  [[ "${node_version}" =~ "${nvm_default}" ]] && node_version=""

  serialize_segment "$0" "" "$1" "$2" "${3}" "green" "011" "${node_version:1}" "NODE_ICON"
}

# NodeEnv Prompt
prompt_nodeenv() {
  local nodeenv_path="$NODE_VIRTUAL_ENV"
  local info
  if [[ -n "$nodeenv_path" && "$NODE_VIRTUAL_ENV_DISABLE_PROMPT" != true ]]; then
    info="$(node -v)[$(basename "$nodeenv_path")]"
  fi
  serialize_segment "$0" "" "$1" "$2" "${3}" "black" "green" "${info}" "NODE_ICON"
}

# print a little OS icon
prompt_os_icon() {
  serialize_segment "$0" "" "$1" "$2" "${3}" "black" "255" "${OS_ICON}" ""
}

# print PHP version number
prompt_php_version() {
  local php_version
  php_version=$(php -v 2>&1 | grep -oe "^PHP\s*[0-9.]*")

  serialize_segment "$0" "" "$1" "$2" "${3}" "013" "255" "${php_version}" ""
}

# Show free RAM and used Swap
prompt_ram() {
  local base=''
  local ramfree=0
  if [[ "$OS" == "OSX" ]]; then
    ramfree=$(vm_stat | grep "Pages free" | grep -o -E '[0-9]+')
    # Convert pages into Bytes
    ramfree=$(( ramfree * 4096 ))
  else
    if [[ "$OS" == "BSD" ]]; then
      ramfree=$(vmstat | grep -E '([0-9]+\w+)+' | awk '{print $5}')
      base='M'
    else
      ramfree=$(grep -o -E "MemFree:\s+[0-9]+" /proc/meminfo | grep -o "[0-9]*")
      base='K'
    fi
  fi

  serialize_segment "$0" "" "$1" "$2" "${3}" "yellow" "$DEFAULT_COLOR" "$(printSizeHumanReadable "$ramfree" $base)" "RAM_ICON"
}

# rbenv information
prompt_rbenv() {
  if which rbenv 2>/dev/null >&2; then
    local rbenv_version_name="$(rbenv version-name)"
    local rbenv_global="$(rbenv global)"

    # Don't show anything if the current Ruby is the same as the global Ruby.
    if [[ "${rbenv_version_name}" == "${rbenv_global}" ]]; then
      rbenv_version_name=""
    fi

    serialize_segment "$0" "" "$1" "$2" "${3}" "red" "$DEFAULT_COLOR" "${rbenv_version_name}" "RUBY_ICON"
  fi
}

# chruby information
# see https://github.com/postmodern/chruby/issues/245 for chruby_auto issue with ZSH
prompt_chruby() {
  local chruby_env
  chruby_env="$(chruby 2> /dev/null | grep \* | tr -d '* ')"
  # Don't show anything if the chruby did not change the default ruby
  if [[ "${chruby_env:-system}" == "system" ]]; then
    chruby_env=""
  fi
  serialize_segment "$0" "" "$1" "$2" "${3}" "red" "$DEFAULT_COLOR" "${chruby_env}" "RUBY_ICON"
}

# Print an icon if user is root.
prompt_root_indicator() {
  # TODO: Here only the visual identifier is printed! This means, the segment
  # has no content and won't get printed anyway! FIXME!
  if [[ "$UID" -eq 0 ]]; then
    serialize_segment "$0" "" "$1" "$2" "${3}" "$DEFAULT_COLOR" "yellow" "" "ROOT_ICON"
  fi
}

# Print Rust version number
prompt_rust_version() {
  local rust_version
  rust_version=$(rustc --version 2>&1 | grep -oe "^rustc\s*[^ ]*" | grep -o '[0-9.a-z\\\-]*$')

  serialize_segment "$0" "" "$1" "$2" "${3}" "208" "$DEFAULT_COLOR" "Rust ${rust_version}" "RUST_ICON"
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

# Ruby Version Manager information
prompt_rvm() {
  local gemset=$(echo $GEM_HOME | awk -F'@' '{print $2}')
  [ "$gemset" != "" ] && gemset="@$gemset"

  local version=$(echo $MY_RUBY_HOME | awk -F'-' '{print $2}')

  serialize_segment "$0" "" "$1" "$2" "${3}" "240" "$DEFAULT_COLOR" "${version}${gemset}" "RUBY_ICON"
}

# Status: return code if verbose, otherwise just an icon if an error occurred
set_default POWERLEVEL9K_STATUS_VERBOSE true
set_default POWERLEVEL9K_STATUS_OK_IN_NON_VERBOSE false
prompt_status() {
  # TODO: Segment states? In some cases the segment has no content!
  if [[ "$RETVAL" -ne 0 ]]; then
    if [[ "$POWERLEVEL9K_STATUS_VERBOSE" == "true" ]]; then
      serialize_segment "$0" "ERROR" "$1" "$2" "${3}" "red" "226" "$RETVAL" "CARRIAGE_RETURN_ICON"
    else
      serialize_segment "$0" "ERROR" "$1" "$2" "${3}" "$DEFAULT_COLOR" "red" "" "FAIL_ICON"
    fi
  elif [[ "$POWERLEVEL9K_STATUS_VERBOSE" == "true" || "$POWERLEVEL9K_STATUS_OK_IN_NON_VERBOSE" == "true" ]]; then
    serialize_segment "$0" "OK" "$1" "$2" "${3}" "$DEFAULT_COLOR" "046" "" "OK_ICON"
  fi
}

prompt_swap() {
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
    swap_total=$(grep -o -E "SwapTotal:\s+[0-9]+" /proc/meminfo | grep -o "[0-9]*")
    swap_free=$(grep -o -E "SwapFree:\s+[0-9]+" /proc/meminfo | grep -o "[0-9]*")
    swap_used=$(( swap_total - swap_free ))
    base='K'
  fi

  serialize_segment "$0" "" "$1" "$2" "${3}" "yellow" "$DEFAULT_COLOR" "$(printSizeHumanReadable "$swap_used" $base)" "SWAP_ICON"
}

# Symfony2-PHPUnit test ratio
prompt_symfony2_tests() {
  if [[ (-d src && -d app && -f app/AppKernel.php) ]]; then
    local code_amount tests_amount
    code_amount=$(ls -1 src/**/*.php | grep -vc Tests)
    tests_amount=$(ls -1 src/**/*.php | grep -c Tests)

    build_test_stats "$1" "$0" "$2" "${3}" "$code_amount" "$tests_amount" "SF2" 'TEST_ICON'
  fi
}

# Symfony2-Version
prompt_symfony2_version() {
  local symfony2_version
  if [[ -f app/bootstrap.php.cache ]]; then
    symfony2_version=$(grep " VERSION " app/bootstrap.php.cache | sed -e 's/[^.0-9]*//g')
  fi
  serialize_segment "$0" "" "$1" "$2" "${3}" "240" "$DEFAULT_COLOR" "${symfony2_version}" "SYMFONY_ICON"
}

# Show a ratio of tests vs code
#   * $1 Alignment: string - left|right
#   * $2 Name: string - Name of the segment
#   * $3 Index: integer
#   * $4 Joined: bool
#   * $5 Amount of code: integer
#   * $6 Amount of tests: integer
#   * $7 Content: string - Content of the segment
#   * $8 Visual identifier: string - Icon of the segment
build_test_stats() {
  local joined="${4}"
  local code_amount="${5}"
  local tests_amount="${6}"+0.00001
  local headline="${7}"

  # Set float precision to 2 digits:
  typeset -F 2 ratio
  local ratio=$(( (tests_amount/code_amount) * 100 ))

  local current_state="unknown"
  typeset -AH test_states
  test_states=(
    'GOOD'          'cyan'
    'AVG'           'yellow'
    'BAD'           'red'
  )
  (( ratio >= 75 )) && current_state="GOOD"
  (( ratio >= 50 && ratio < 75 )) && current_state="AVG"
  (( ratio < 50 )) && current_state="BAD"

  serialize_segment "${2}" "$current_state" "${1}" "${3}" "${joined}" "${test_states[$current_state]}" "${DEFAULT_COLOR}" "$headline: $ratio%%" "${8}"
}

# System time
prompt_time() {
  local time_format="%D{%H:%M:%S}"
  if [[ -n "$POWERLEVEL9K_TIME_FORMAT" ]]; then
    time_format="$POWERLEVEL9K_TIME_FORMAT"
  fi

  serialize_segment "$0" "" "$1" "$2" "${3}" "$DEFAULT_COLOR_INVERTED" "$DEFAULT_COLOR" "$time_format" ""
}

# todo.sh: shows the number of tasks in your todo.sh file
prompt_todo() {
  if $(hash todo.sh 2>&-); then
    count=$(todo.sh ls | egrep "TODO: [0-9]+ of ([0-9]+) tasks shown" | awk '{ print $4 }')
    if [[ "$count" = <-> ]]; then
      serialize_segment "$0" "" "$1" "$2" "${3}" "244" "$DEFAULT_COLOR" "$count" "TODO_ICON"
    fi
  fi
}

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

  if [[ "$POWERLEVEL9K_SHOW_CHANGESET" == true ]]; then
    zstyle ':vcs_info:*' get-revision true
  fi
}

prompt_vcs() {
  powerlevel9k_vcs_init

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
    serialize_segment "$0" "$current_state" "$1" "$2" "${3}" "${vcs_states[$current_state]}" "$DEFAULT_COLOR" "$vcs_prompt" "$vcs_visual_identifier"
  fi
}

# Vi Mode: show editing mode (NORMAL|INSERT)
set_default "POWERLEVEL9K_VI_INSERT_MODE_STRING" "INSERT"
set_default "POWERLEVEL9K_VI_COMMAND_MODE_STRING" "NORMAL"
prompt_vi_mode() {
  local vi_mode
  local current_state
  typeset -gAH vi_states
  vi_states=(
    'NORMAL'      "${DEFAULT_COLOR_INVERTED}"
    'INSERT'      'blue'
  )
  case "${KEYMAP}" in
    main|viins)
      current_state="INSERT"
      vi_mode="${POWERLEVEL9K_VI_INSERT_MODE_STRING}"
    ;;
    vicmd)
      current_state="NORMAL"
      vi_mode="${POWERLEVEL9K_VI_COMMAND_MODE_STRING}"
    ;;
  esac
  serialize_segment "${0}" "${current_state}" "${1}" "${2}" "${3}" "${DEFAULT_COLOR}" "${vi_states[$current_state]}" "${vi_mode}" ''
}

# Virtualenv: current working virtualenv
# More information on virtualenv (Python):
# https://virtualenv.pypa.io/en/latest/
prompt_virtualenv() {
  serialize_segment "$0" "" "$1" "$2" "${3}" "blue" "$DEFAULT_COLOR" "$(basename "${VIRTUAL_ENV}")" "PYTHON_ICON"
}

# pyenv: current active python version (with restrictions)
# More information on pyenv (Python version manager like rbenv and rvm):
# https://github.com/yyuu/pyenv
# the prompt parses output of pyenv version and only displays the first word
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


################################################################
# Caching functions
################################################################

# This function serializes a segment to disk under /tmp/p9k/
# When done with writing to disk, the function sends a
# signal to the parent process.
#
# Parameters:
#   * $1 Name: string - Name of the segment
#   * $2 State: string - The state the segment is in
#   * $3 Alignment: string - left|right
#   * $4 Index: integer
#   * $5 Background: string - The default background color of the segment
#   * $6 Foreground: string - The default foreground color of the segment
#   * $7 Content: string - Content of the segment
#   * $8 Visual identifier: string - Icon of the segment
serialize_segment() {
  local NAME="${1}"
  local STATE="${2}"
  local ALIGNMENT="${3}"
  local INDEX="${4}"
  local JOINED="${5}"

  ################################################################
  # Methodology behind user-defined variables overwriting colors:
  #     The first parameter to the segment constructors is the calling function's
  #     name.  From this function name, we strip the "prompt_"-prefix and
  #     uppercase it.  This is then prefixed with "POWERLEVEL9K_" and suffixed
  #     with either "_BACKGROUND" or "_FOREGROUND", thus giving us the variable
  #     name. So each new segment is user-overwritable by a variable following
  #     this naming convention.
  ################################################################

  local STATEFUL_NAME="${(U)NAME#prompt_}"
  [[ -n "${STATE}" ]] && STATEFUL_NAME="${STATEFUL_NAME}_${(U)STATE}"
  # Overwrite given background-color by user defined variable for this segment.
  local BACKGROUND_USER_VARIABLE="POWERLEVEL9K_${STATEFUL_NAME}_BACKGROUND"
  local BACKGROUND="${(P)BACKGROUND_USER_VARIABLE}"
  [[ -z "${BACKGROUND}" ]] && BACKGROUND="${6}"

  # Overwrite given foreground-color by user defined variable for this segment.
  local FOREGROUND_USER_VARIABLE="POWERLEVEL9K_${STATEFUL_NAME}_FOREGROUND"
  local FOREGROUND="${(P)FOREGROUND_USER_VARIABLE}"
  [[ -z "${FOREGROUND}" ]] && FOREGROUND="${7}"

  local CONTENT="${8}"

  local VISUAL_IDENTIFIER
  if [[ -n "${9}" ]]; then
    VISUAL_IDENTIFIER="$(print_icon ${9})"
    if [[ -n "${VISUAL_IDENTIFIER}" ]]; then
      # Allow users to overwrite the color for the visual identifier only.
      local visual_identifier_color_variable="POWERLEVEL9K_${STATEFUL_NAME}_VISUAL_IDENTIFIER_COLOR"
      set_default "${visual_identifier_color_variable}" "${FOREGROUND}"
      VISUAL_IDENTIFIER="%F{${(P)visual_identifier_color_variable}%}${VISUAL_IDENTIFIER}%f"
      # Add an whitespace if we print more than just the visual identifier
      if [[ -n "${CONTENT}" ]]; then
        [[ "${ALIGNMENT}" == "left" ]] && VISUAL_IDENTIFIER="${VISUAL_IDENTIFIER} "
        [[ "${ALIGNMENT}" == "right" ]] && VISUAL_IDENTIFIER=" ${VISUAL_IDENTIFIER}"
      fi
    fi
  fi

  local FILE="${CACHE_DIR}/p9k_$$_${ALIGNMENT}_${(l:3::0:)INDEX}_${NAME}.sh"
  rm -f $FILE #Remove the previous file prior, due to weird > handling on OS X
  typeset -p "NAME" > $FILE
  typeset -p "STATE" >> $FILE
  typeset -p "ALIGNMENT" >> $FILE
  typeset -p "INDEX" >> $FILE
  typeset -p "JOINED" >> $FILE
  typeset -p "BACKGROUND" >> $FILE
  typeset -p "FOREGROUND" >> $FILE
  typeset -p "CONTENT" >> $FILE
  typeset -p "VISUAL_IDENTIFIER" >> $FILE

  # send WINCH signal to parent process
  kill -s WINCH $$
}

# Rebuild prompt from cache every time
# a child process terminates (= sends
# SIGWINCH). We read in the segments
# variables, use that information to
# glue the segments back togeher and
# finally reset the prompt.
set_default CACHE_DIR /tmp/p9k
p9k_build_prompt_from_cache() {
  last_left_element_index=1 # Reset
  local LAST_LEFT_BACKGROUND='NONE' # Reset
  local LAST_RIGHT_BACKGROUND='NONE' # Reset
  PROMPT='' # Reset
  RPROMPT='' # Reset
  # TODO: Optimize for speed!
  #POWERLEVEL9K_VISITED_SEGMENTS=()
  for i in $(ls -1 $CACHE_DIR/p9k_$$_* 2> /dev/null); do
    source "${i}"

    # If segment has no content, skip it!
    if [[ -z "${CONTENT}" ]]; then
      continue
    fi

    local statefulName="${NAME}"
    [[ -n "${STATE}" ]] && statefulName="${NAME}_${STATE}"

    if [[ "${ALIGNMENT}" == "left" ]]; then
      PROMPT+=$("${(L)ALIGNMENT}_prompt_segment" "${statefulName}" "${INDEX}" "${BACKGROUND}" "${FOREGROUND}" "${CONTENT}" "${VISUAL_IDENTIFIER}" "${LAST_LEFT_BACKGROUND}")
      LAST_LEFT_BACKGROUND="${BACKGROUND}"
    elif [[ "${ALIGNMENT}" == "right" ]]; then
      RPROMPT+=$("${(L)ALIGNMENT}_prompt_segment" "${statefulName}" "${INDEX}" "${BACKGROUND}" "${FOREGROUND}" "${CONTENT}" "${VISUAL_IDENTIFIER}" "${LAST_RIGHT_BACKGROUND}")
      LAST_RIGHT_BACKGROUND="${BACKGROUND}"
    fi
  done
  PROMPT+="$(left_prompt_end ${LAST_LEFT_BACKGROUND})"
  zle && zle reset-prompt
}
# Register trap on WINCH (Rebuild prompt)
trap p9k_build_prompt_from_cache WINCH

p9k_clear_cache() {
  rm -f "${CACHE_DIR}/p9k_$$_*" 2> /dev/null
}
# Register trap on EXIT (cleanup)
trap p9k_clear_cache EXIT

################################################################
# Prompt processing and drawing
################################################################
# Main prompt
build_left_prompt() {
  local index=1
  for element in "${POWERLEVEL9K_LEFT_PROMPT_ELEMENTS[@]}"; do
    local joined=false
    [[ "${element[-7,-1]}" == '_joined' ]] && joined=true
    # Remove joined information in direct calls
    element="${element%_joined}"

    # Check if it is a custom command, otherwise interpet it as
    # a prompt.
    if [[ $element[0,7] =~ "custom_" ]]; then
      "prompt_custom" "left" "${index}" "${element[8,-1]}" "${joined}" &!
    else
      # Could we display placeholders?
      # -> At most it could be static ones, but
      # e.g. states are the result of calculation..
      "prompt_$element" "left" "${index}" "${joined}" &!
    fi

    index=$((index + 1))
  done
}

# Right prompt
build_right_prompt() {
  local index=1
  for element in "${POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS[@]}"; do
    local joined=false
    [[ "${element[-7,-1]}" == '_joined' ]] && joined=true
    # Remove joined information in direct calls
    element="${element%_joined}"

    # Check if it is a custom command, otherwise interpet it as
    # a prompt.
    if [[ $element[0,7] =~ "custom_" ]]; then
      "prompt_custom" "right" "$index" "${element[8,-1]}" "${joined}" &!
    else
      "prompt_$element" "right" "$index" "${joined}" &!
    fi

    index=$((index + 1))
  done
}

ASYNC_PROC=0
powerlevel9k_prepare_prompts() {
  RETVAL=$?

  # Kill all spawns that are not the main process!
  # This method gets called every time, because it
  # is a precmd hook registered in powerlevel9k_init!
  # The child processes must be killed, because they
  # should only be triggered once to build their
  # segment and nothing else.
  if [[ "${ASYNC_PROC}" != 0 ]]; then
    kill -s HUP ${ASYNC_PROC} >/dev/null 2>&1 || :
  fi

  # Ensure that every time the user wants a new prompt,
  # he gets a new, fresh one.
  p9k_clear_cache

  if [[ "$POWERLEVEL9K_PROMPT_ON_NEWLINE" == true ]]; then
    PROMPT="$(print_icon 'MULTILINE_FIRST_PROMPT_PREFIX')%f%b%k$(build_left_prompt)
$(print_icon 'MULTILINE_SECOND_PROMPT_PREFIX')"
    if [[ "$POWERLEVEL9K_RPROMPT_ON_NEWLINE" != true ]]; then
      # The right prompt should be on the same line as the first line of the left
      # prompt.  To do so, there is just a quite ugly workaround: Before zsh draws
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
    #PROMPT="%f%b%k$(build_left_prompt)"
    build_left_prompt
    build_right_prompt
    RPROMPT_PREFIX=''
    RPROMPT_SUFFIX=''
  fi

#  if [[ "$POWERLEVEL9K_DISABLE_RPROMPT" != true ]]; then
#    RPROMPT="$RPROMPT_PREFIX%f%b%k$(build_right_prompt)%{$reset_color%}$RPROMPT_SUFFIX"
#  fi

  ASYNC_PROC=$!
}

function rebuild_vi_mode {
  if (( ${+terminfo[smkx]} )); then
    printf '%s' ${terminfo[smkx]}
  fi
  for index in $(get_indices_of_segment "vi_mode" "${POWERLEVEL9K_LEFT_PROMPT_ELEMENTS}"); do
     prompt_vi_mode "left" "${index}" "${1}" &!
  done
  for index in $(get_indices_of_segment "vi_mode" "${POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS}"); do
     prompt_vi_mode "right" "${index}" "${1}" &!
  done
}

function zle-line-init {
  rebuild_vi_mode "${KEYMAP}"
}

function zle-line-finish {
  rebuild_vi_mode "${KEYMAP}"
}

function zle-keymap-select {
  rebuild_vi_mode "${KEYMAP}"
}

powerlevel9k_init() {
  # Precompile the Segment Separators here!
  _POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR="$(print_icon 'LEFT_SEGMENT_SEPARATOR')"
  _POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR="$(print_icon 'LEFT_SUBSEGMENT_SEPARATOR')"
  _POWERLEVEL9K_LEFT_SEGMENT_END_SEPARATOR="$(print_icon 'LEFT_SEGMENT_END_SEPARATOR')"
  _POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR="$(print_icon 'RIGHT_SEGMENT_SEPARATOR')"
  _POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR="$(print_icon 'RIGHT_SUBSEGMENT_SEPARATOR')"

  # Display a warning if the terminal does not support 256 colors
  local term_colors
  term_colors=$(echotc Co)
  if (( $term_colors < 256 )); then
    print -P "%F{red}WARNING!%f Your terminal appears to support less than 256 colors!"
    print -P "If your terminal supports 256 colors, please export the appropriate environment variable"
    print -P "_before_ loading this theme in your \~\/.zshrc. In most terminal emulators, putting"
    print -P "%F{blue}export TERM=\"xterm-256color\"%f at the top of your \~\/.zshrc is sufficient."
  fi

  # If the terminal `LANG` is set to `C`, this theme will not work at all.
  local term_lang
  term_lang=$(echo $LANG)
  if [[ $term_lang == 'C' ]]; then
      print -P "\t%F{red}WARNING!%f Your terminal's 'LANG' is set to 'C', which breaks this theme!"
      print -P "\t%F{red}WARNING!%f Please set your 'LANG' to a UTF-8 language, like 'en_US.UTF-8'"
      print -P "\t%F{red}WARNING!%f _before_ loading this theme in your \~\.zshrc. Putting"
      print -P "\t%F{red}WARNING!%f %F{blue}export LANG=\"en_US.UTF-8\"%f at the top of your \~\/.zshrc is sufficient."
  fi

  defined POWERLEVEL9K_LEFT_PROMPT_ELEMENTS || POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir rbenv vcs)
  defined POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS || POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs history time)

  # Display a warning if deprecated segments are in use.
  typeset -AH deprecated_segments
  # old => new
  deprecated_segments=(
    'longstatus'      'status'
  )
  print_deprecation_warning deprecated_segments

  setopt prompt_subst

  setopt LOCAL_OPTIONS
  unsetopt XTRACE KSH_ARRAYS
  setopt PROMPT_CR PROMPT_PERCENT PROMPT_SUBST MULTIBYTE

  # initialize colors
  autoload -U colors && colors

  # initialize hooks
  autoload -Uz add-zsh-hook

  # prepare prompts
  add-zsh-hook precmd powerlevel9k_prepare_prompts

  zle -N zle-line-init
  zle -N zle-line-finish
  zle -N zle-keymap-select
}

powerlevel9k_init "$@"

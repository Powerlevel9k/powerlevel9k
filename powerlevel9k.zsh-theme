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
    POWERLEVEL9K_INSTALLATION_PATH=$(whence -v $0 | sed "s/$0 is a shell function from //")
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
# Takes eight arguments:
#   * $1: Name of the function that was originally invoked (mandatory).
#         Necessary, to make the dynamic color-overwrite mechanism work.
#   * $2: The array index of the current segment
#   * $3: Background color
#   * $4: Foreground color
#   * $5: The segment content
#   * $6: An identifying icon (must be a key of the icons array)
#   * $7: Last segments background color
#   * $8: Boolean - If the segment should be joined or not
# The latter three can be omitted,
set_default last_left_element_index 1
set_default POWERLEVEL9K_WHITESPACE_BETWEEN_LEFT_SEGMENTS " "
left_prompt_segment() {
  local current_index="${2}"
  local joined="${8}"

  local BACKGROUND_OF_LAST_SEGMENT="${7}"

  local bg fg
  [[ -n "${3}" ]] && bg="%K{$3}" || bg="%k"
  [[ -n "${4}" ]] && fg="%F{$4}" || fg="%f"

  if [[ "${BACKGROUND_OF_LAST_SEGMENT}" != 'NONE' ]] && ! isSameColor "${3}" "${BACKGROUND_OF_LAST_SEGMENT}"; then
    echo -n "${bg}%F{$BACKGROUND_OF_LAST_SEGMENT}"
    if [[ "${joined}" == "false" ]]; then
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
  # Print the content of the segment
  echo -n "${fg}${5}"
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
# Takes eight arguments:
#   * $1: Name of the function that was originally invoked (mandatory).
#         Necessary, to make the dynamic color-overwrite mechanism work.
#   * $2: The array index of the current segment
#   * $3: Background color
#   * $4: Foreground color
#   * $5: The segment content
#   * $6: An identifying icon (must be a key of the icons array)
#   * $7: Last segments background color
#   * $8: Boolean - If the segment should be joined or not
# No ending for the right prompt segment is needed (unlike the left prompt, above).
set_default last_right_element_index 1
set_default POWERLEVEL9K_WHITESPACE_BETWEEN_RIGHT_SEGMENTS " "
right_prompt_segment() {
  local current_index="${2}"
  local CURRENT_RIGHT_BG="${7}"
  local joined="${8}"

  local bg fg
  [[ -n "${3}" ]] && bg="%K{$3}" || bg="%k"
  [[ -n "${4}" ]] && fg="%F{$4}" || fg="%f"

  # If CURRENT_RIGHT_BG is "NONE", we are the first right segment.
  if [[ "${joined}" == "false" ]] || [[ "${CURRENT_RIGHT_BG}" == "NONE" ]]; then
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

  # Print segment content
  echo -n "${5}"
  # Print the visual identifier
  echo -n "${6}${POWERLEVEL9K_WHITESPACE_BETWEEN_RIGHT_SEGMENTS}%f"

  CURRENT_RIGHT_BG="${3}"
  last_right_element_index="${current_index}"
}

################################################################
# Prompt Segment Definitions
################################################################

# Anaconda Environment
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
prompt_anaconda() {
  # Depending on the conda version, either might be set. This
  # variant works even if both are set.
  local result
  local _path="${CONDA_ENV_PATH}${CONDA_PREFIX}"
  if [ ! -z "$_path" ]; then
    # config - can be overwritten in users' zshrc file.
    set_default POWERLEVEL9K_ANACONDA_LEFT_DELIMITER "("
    set_default POWERLEVEL9K_ANACONDA_RIGHT_DELIMITER ")"

    result="${POWERLEVEL9K_ANACONDA_LEFT_DELIMITER}$(basename $_path)${POWERLEVEL9K_ANACONDA_RIGHT_DELIMITER}"
  fi

  serialize_segment "$0" "" "$1" "$2" "${3}" "006" "white" "${result}" "PYTHON_ICON"
}

# AWS Profile
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
prompt_aws() {
  serialize_segment "$0" "" "$1" "$2" "${3}" "red" "white" "${AWS_DEFAULT_PROFILE}" "AWS_ICON"
}

# Current Elastic Beanstalk environment
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
prompt_aws_eb_env() {
  local eb_env=$(grep environment .elasticbeanstalk/config.yml 2> /dev/null | awk '{print $2}')

  serialize_segment "$0" "" "$1" "$2" "${3}" "black" "green" "${eb_env}" "AWS_EB_ICON"
}

# Segment to indicate background jobs with an icon.
set_default POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE true
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
prompt_background_jobs() {
  local background_jobs_number=${$(jobs -l | wc -l)// /}
  local wrong_lines=$(jobs -l | awk '/pwd now/{ count++ } END {print count}')
  if [[ wrong_lines -gt 0 ]]; then
     background_jobs_number=$(( $background_jobs_number - $wrong_lines ))
  fi
  if [[ background_jobs_number -gt 0 ]]; then
    local content=""
    if [[ "${POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE}" == "true" ]] && [[ "${background_jobs_number}" -gt 1 ]]; then
      content="$background_jobs_number"
    fi
  fi

  serialize_segment "$0" "" "$1" "$2" "${3}" "${DEFAULT_COLOR}" "cyan" "${content}" "BACKGROUND_JOBS_ICON" "[[ ${background_jobs_number} -gt 0 ]]"
}

# Segment that indicates usage level of current partition.
set_default POWERLEVEL9K_DISK_USAGE_ONLY_WARNING false
set_default POWERLEVEL9K_DISK_USAGE_WARNING_LEVEL 90
set_default POWERLEVEL9K_DISK_USAGE_CRITICAL_LEVEL 95
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
prompt_disk_usage() {
  local current_state="unknown"
  typeset -AH hdd_usage_forecolors
  hdd_usage_forecolors=(
    'normal'        'yellow'
    'warning'       "$DEFAULT_COLOR"
    'critical'      'white'
  )
  typeset -AH hdd_usage_backcolors
  hdd_usage_backcolors=(
    'normal'        $DEFAULT_COLOR
    'warning'       'yellow'
    'critical'      'red'
  )

  local disk_usage="${$(\df -P . | sed -n '2p' | awk '{ print $5 }')%%\%}"

  if [ "$disk_usage" -ge "$POWERLEVEL9K_DISK_USAGE_WARNING_LEVEL" ]; then
    current_state='warning'
    if [ "$disk_usage" -ge "$POWERLEVEL9K_DISK_USAGE_CRITICAL_LEVEL" ]; then
        current_state='critical'
    fi
  else
    if [[ "$POWERLEVEL9K_DISK_USAGE_ONLY_WARNING" == true ]]; then
        current_state=''
        return
    fi
    current_state='normal'
  fi

  # Draw the prompt_segment
  serialize_segment "${0}" "${current_state}" "$1" "$2" "${3}" "${hdd_usage_backcolors[$current_state]}" "${hdd_usage_forecolors[$current_state]}" "${disk_usage}%%" "DISK_ICON"
}

# Battery segment
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
#   * $4 Root Path: string - An optional root path (used for unit tests @see battery.spec)
prompt_battery() {
  local ROOT_PATH="${4}"
  # The battery can have four different states - default to 'unknown'.
  local current_state='unknown'
  typeset -AH battery_states
  battery_states=(
    'low'           'red'
    'charging'      'yellow'
    'charged'       'green'
    'disconnected'  "$DEFAULT_COLOR_INVERTED"
  )
  # Set default values if the user did not configure them
  set_default POWERLEVEL9K_BATTERY_LOW_THRESHOLD  10

  local pmsetExecutable="${ROOT_PATH}/usr/bin/pmset"
  if [[ $OS =~ OSX && -f ${pmsetExecutable} && -x ${pmsetExecutable} ]]; then
    # obtain battery information from system
    local raw_data="$(${pmsetExecutable} -g batt | awk 'FNR==2{print}')"
    # return if there is no battery on system
    if [[ -n $(echo $raw_data | grep "InternalBattery") ]]; then
      # Time remaining on battery operation (charging/discharging)
      local tstring=$(echo "${raw_data}" | awk -F ';' '{print $3}' | awk '{print $1}')
      # If time has not been calculated by system yet
      [[ $tstring =~ '(\(no|not)' ]] && tstring="..."

      # percent of battery charged
      typeset -i 10 bat_percent
      bat_percent=$(echo "${raw_data}" | grep -o '[0-9]*%' | sed 's/%//')

      local remain=""
      # Logic for string output
      case $(echo $raw_data | awk -F ';' '{print $2}' | awk '{$1=$1};1') in
        # for a short time after attaching power, status will be 'AC attached;'
        'charging'|'finishing charge'|'AC attached')
          current_state="charging"
          remain=" ($tstring)"
          ;;
        'discharging')
          [[ $bat_percent -lt $POWERLEVEL9K_BATTERY_LOW_THRESHOLD ]] && current_state="low" || current_state="disconnected"
          remain=" ($tstring)"
          ;;
        *)
          current_state="charged"
          ;;
      esac
    fi
  fi

  if [[ $OS =~ Linux ]]; then
    local sysp="${ROOT_PATH}/sys/class/power_supply"
    # Reported BAT0 or BAT1 depending on kernel version
    [[ -a $sysp/BAT0 ]] && local bat=$sysp/BAT0
    [[ -a $sysp/BAT1 ]] && local bat=$sysp/BAT1

    if [[ -n "${bat}" ]]; then
      local capacity=$(cat $bat/capacity)
      local battery_status=$(cat $bat/status)
      [[ $capacity -gt 100 ]] && local bat_percent=100 || local bat_percent=$capacity
      [[ $battery_status =~ Charging || $battery_status =~ Full ]] && local connected=true
      if [[ -z $connected ]]; then
        [[ $bat_percent -lt $POWERLEVEL9K_BATTERY_LOW_THRESHOLD ]] && current_state="low" || current_state="disconnected"
      else
        [[ $bat_percent =~ 100 ]] && current_state="charged"
        [[ $bat_percent -lt 100 ]] && current_state="charging"
      fi
      if [[ -f ${ROOT_PATH}/usr/bin/acpi ]]; then
        local time_remaining=$(acpi | awk '{ print $5 }')
        if [[ $time_remaining =~ rate ]]; then
          local tstring="..."
        elif [[ $time_remaining =~ "[[:digit:]]+" ]]; then
          local tstring=${(f)$(date -u -d "$(echo $time_remaining)" +%k:%M 2> /dev/null)}
        fi
      fi
      [[ -n $tstring ]] && local remain=" ($tstring)"
    fi
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

# Public IP segment
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
prompt_public_ip() {
  # set default values for segment
  set_default POWERLEVEL9K_PUBLIC_IP_TIMEOUT "300"
  set_default POWERLEVEL9K_PUBLIC_IP_NONE ""
  set_default POWERLEVEL9K_PUBLIC_IP_FILE "/tmp/p9k_public_ip"
  set_default POWERLEVEL9K_PUBLIC_IP_HOST "http://ident.me"

  # Do we need a fresh IP?
  local refresh_ip=false
  if [[ -f $POWERLEVEL9K_PUBLIC_IP_FILE ]]; then
    typeset -i timediff
    # if saved IP is more than
    timediff=$(($(date +%s) - $(date -r $POWERLEVEL9K_PUBLIC_IP_FILE +%s)))
    [[ $timediff -gt $POWERLEVEL9K_PUBLIC_IP_TIMEOUT ]] && refresh_ip=true
    # If tmp file is empty get a fresh IP
    [[ -z $(cat $POWERLEVEL9K_PUBLIC_IP_FILE) ]] && refresh_ip=true
    [[ -n $POWERLEVEL9K_PUBLIC_IP_NONE ]] && [[ $(cat $POWERLEVEL9K_PUBLIC_IP_FILE) =~ "$POWERLEVEL9K_PUBLIC_IP_NONE" ]] && refresh_ip=true
  else
    touch $POWERLEVEL9K_PUBLIC_IP_FILE && refresh_ip=true
  fi

  # grab a fresh IP if needed
  if [[ $refresh_ip =~ true && -w $POWERLEVEL9K_PUBLIC_IP_FILE ]]; then
    # if method specified, don't use fallback methods
    if [[ -n $POWERLEVEL9K_PUBLIC_IP_METHOD ]] && [[ $POWERLEVEL9K_PUBLIC_IP_METHOD =~ 'wget|curl|dig' ]]; then
      local method=$POWERLEVEL9K_PUBLIC_IP_METHOD
    fi
    if [[ -n $method ]]; then
      case $method in
        'dig')
          if type -p dig >/dev/null; then
              fresh_ip="$(dig +time=1 +tries=1 +short myip.opendns.com @resolver1.opendns.com 2> /dev/null)"
              [[ "$fresh_ip" =~ ^\; ]] && unset fresh_ip
          fi
          ;;
        'curl')
          if [[ -z "$fresh_ip" ]] && type -p curl >/dev/null; then
              fresh_ip="$(curl --max-time 10 -w '\n' "$POWERLEVEL9K_PUBLIC_IP_HOST" 2> /dev/null)"
          fi
          ;;
        'wget')
          if [[ -z "$fresh_ip" ]] && type -p wget >/dev/null; then
              fresh_ip="$(wget -T 10 -qO- "$POWERLEVEL9K_PUBLIC_IP_HOST" 2> /dev/null)"
          fi
          ;;
      esac
    else
      if type -p dig >/dev/null; then
          fresh_ip="$(dig +time=1 +tries=1 +short myip.opendns.com @resolver1.opendns.com 2> /dev/null)"
          [[ "$fresh_ip" =~ ^\; ]] && unset fresh_ip
      fi

      if [[ -z "$fresh_ip" ]] && type -p curl >/dev/null; then
          fresh_ip="$(curl --max-time 10 -w '\n' "$POWERLEVEL9K_PUBLIC_IP_HOST" 2> /dev/null)"
      fi

      if [[ -z "$fresh_ip" ]] && type -p wget >/dev/null; then
          fresh_ip="$(wget -T 10 -qO- "$POWERLEVEL9K_PUBLIC_IP_HOST" 2> /dev/null)"
      fi
    fi

    # write IP to tmp file or clear tmp file if an IP was not retrieved
    # Redirection with `>!`. From the manpage: Same as >, except that the file
    #   is truncated to zero length if it exists, even if CLOBBER is unset.
    # If the file already exists, and a simple `>` redirection and CLOBBER
    # unset, ZSH will produce an error.
    [[ -n "${fresh_ip}" ]] && echo $fresh_ip >! $POWERLEVEL9K_PUBLIC_IP_FILE || echo $POWERLEVEL9K_PUBLIC_IP_NONE >! $POWERLEVEL9K_PUBLIC_IP_FILE
  fi

  # read public IP saved to tmp file
  local public_ip=$(cat $POWERLEVEL9K_PUBLIC_IP_FILE)

  # Draw the prompt segment
  serialize_segment "$0" "" "$1" "$2" "${3}" "${DEFAULT_COLOR}" "${DEFAULT_COLOR_INVERTED}" "${public_ip}" "PUBLIC_IP_ICON"
}

# Context: user@hostname (who am I and where am I)
# Note that if $DEFAULT_USER is not set, this prompt segment will always print
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
prompt_context() {
  local content
  local current_state="DEFAULT"
  typeset -AH context_states
  context_states=(
    'DEFAULT'      '011'
    'ROOT'         'yellow'
  )
  set_default POWERLEVEL9K_CONTEXT_HOST_DEPTH "%m"
  content="${USER}@${POWERLEVEL9K_CONTEXT_HOST_DEPTH}"
  if [[ $(print -P "%#") == '#' ]]; then
    # Shell runs as root
    state="ROOT"
  fi
  serialize_segment "$0" "${state}" "$1" "$2" "${3}" "${DEFAULT_COLOR}" "${context_states[$current_state]}" "${content}" "" '[[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]'
}

# The 'custom` prompt provides a way for users to invoke commands and display
# the output in a segment.
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Name: string
#   * $4 Joined: bool - If the segment should be joined
prompt_custom() {
  local segment_name="${3:u}"
  # Get content of custom segment
  local command="POWERLEVEL9K_CUSTOM_${segment_name}"
  local segment_content="$(eval ${(P)command})"

  serialize_segment "$0" "${segment_name}" "$1" "$2" "${4}" "${DEFAULT_COLOR_INVERTED}" "${DEFAULT_COLOR}" "${segment_content}" "CUSTOM_${segment_name}_ICON"
}

# Dir: current working directory
set_default POWERLEVEL9K_DIR_PATH_SEPARATOR "/"
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
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
          # Get path from the root of the git repository to the current dir
          local gitPath=$(git rev-parse --show-prefix)
          # Remove trailing slash from git path, so that we can
          # remove that git path from the pwd.
          gitPath=${gitPath%/}
          package_path=${$(pwd)%%$gitPath}
          # Remove trailing slash
          package_path=${package_path%/}
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

  if [[ "${POWERLEVEL9K_DIR_PATH_SEPARATOR}" != "/" ]]; then
    current_path=$(print -P "${current_path}" | sed "s/\//${POWERLEVEL9K_DIR_PATH_SEPARATOR}/g")
  fi

  typeset -AH dir_states
  dir_states=(
    "DEFAULT"         "FOLDER_ICON"
    "HOME"            "HOME_ICON"
    "HOME_SUBFOLDER"  "HOME_SUB_ICON"
  )
  local current_state="DEFAULT"
  if [[ $(print -P "%~") == '~' ]]; then
    current_state="HOME"
  elif [[ $(print -P "%~") == '~'* ]]; then
    current_state="HOME_SUBFOLDER"
  fi
  serialize_segment "$0" "${current_state}" "$1" "$2" "${3}" "blue" "${DEFAULT_COLOR}" "${current_path}" "${dir_states[$current_state]}"
}

# Docker machine
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
prompt_docker_machine() {
  serialize_segment "$0" "" "$1" "$2" "${3}" "magenta" "${DEFAULT_COLOR}" "${DOCKER_MACHINE_NAME}" "SERVER_ICON"
}

# GO prompt
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
prompt_go_version() {
  local go_version
  go_version=$(go version 2>/dev/null | sed -E "s/.*(go[0-9.]*).*/\1/")

  serialize_segment "$0" "" "$1" "$2" "${3}" "green" "255" "${go_version}" ""
}

# Command number (in local history)
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
prompt_history() {
  serialize_segment "$0" "" "$1" "$2" "${3}" "244" "${DEFAULT_COLOR}" "%h" ""
}

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

# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
prompt_ip() {
  local ip
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

  # Trim whitespaces
  ip=${ip// /}
  serialize_segment "$0" "" "$1" "$2" "${3}" "cyan" "${DEFAULT_COLOR}" "${ip}" "NETWORK_ICON"
}

# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
#   * $4 Root Path: string - An optional root path (used for unit tests @see load.spec)
prompt_load() {
  local ROOT_PATH="${4}"
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
    load_avg_1min=$(grep -o -E "[0-9.]+" $ROOT_PATH/proc/loadavg | head -n 1)
    cores=$(nproc)
  fi

  # Replace comma
  load_avg_1min=${load_avg_1min//,/.}

  if (( $load_avg_1min > (${cores} * 0.7) )); then
    current_state="critical"
  elif (( $load_avg_1min > (${cores} * 0.5) )); then
    current_state="warning"
  else
    current_state="normal"
  fi

  serialize_segment "$0" "${current_state}" "$1" "$2" "${3}" "${load_states[$current_state]}" "${DEFAULT_COLOR}" "${load_avg_1min}" "LOAD_ICON"
}

# Node version
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
prompt_node_version() {
  local node_version=$(node -v 2>/dev/null)

  serialize_segment "$0" "" "$1" "$2" "${3}" "green" "white" "${node_version:1}" "NODE_ICON"
}

# Node version from NVM
# Only prints the segment if different than the default value
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
prompt_nvm() {
  local node_version=$(nvm current 2> /dev/null)
  [[ "${node_version}" == "none" ]] && node_version=""
  local nvm_default=$(cat $NVM_DIR/alias/default 2> /dev/null)
  [[ -n "${nvm_default}" && "${node_version}" =~ "${nvm_default}" ]] && node_version=""

  serialize_segment "$0" "" "$1" "$2" "${3}" "green" "011" "${node_version:1}" "NODE_ICON"
}

# NodeEnv Prompt
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
prompt_nodeenv() {
  local info
  if [[ -n "$NODE_VIRTUAL_ENV" && "$NODE_VIRTUAL_ENV_DISABLE_PROMPT" != true ]]; then
    info="$(node -v)[$(basename "$NODE_VIRTUAL_ENV")]"
  fi
  serialize_segment "$0" "" "$1" "$2" "${3}" "black" "green" "${info}" "NODE_ICON"
}

# print a little OS icon
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
prompt_os_icon() {
  local OS_ICON
  case "${OS}" in
    OSX)
      OS_ICON=$(print_icon 'APPLE_ICON')
      ;;
    BSD)
      OS_ICON=$(print_icon 'FREEBSD_ICON')
      ;;
    Linux)
      OS_ICON=$(print_icon 'LINUX_ICON')
      ;;
    Solaris)
      OS_ICON=$(print_icon 'SUNOS_ICON')
      ;;
  esac

  serialize_segment "$0" "" "$1" "$2" "${3}" "black" "255" "${OS_ICON}" ""
}

# print PHP version number
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
prompt_php_version() {
  local php_version
  php_version=$(php -v 2>&1 | grep -oe "^PHP\s*[0-9.]*")

  serialize_segment "$0" "" "$1" "$2" "${3}" "013" "255" "${php_version}" ""
}

# Show free RAM and used Swap
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
#   * $4 Root Path: string - An optional root path (used for unit tests @see ram.spec)
prompt_ram() {
  local ROOT_PATH="${4}"
  local base=''
  local ramfree=0
  if [[ "$OS" == "OSX" ]]; then
    ramfree=$(vm_stat | grep "Pages free" | grep -o -E '[0-9]+')
    # Convert pages into Bytes
    ramfree=$(( ramfree * 4096 ))
  elif [[ "$OS" == "BSD" ]]; then
    ramfree=$(vmstat | grep -E '([0-9]+\w+)+' | awk '{print $5}')
    base='M'
  else
    ramfree=$(grep -o -E "MemFree:\s+[0-9]+" $ROOT_PATH/proc/meminfo | grep -o -E "[0-9]+")
    base='K'
  fi

  serialize_segment "$0" "" "$1" "$2" "${3}" "yellow" "$DEFAULT_COLOR" "$(printSizeHumanReadable "$ramfree" $base)" "RAM_ICON"
}

# rbenv information
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
prompt_rbenv() {
  if which rbenv 2>/dev/null >&2; then
    local rbenv_version_name="$(rbenv version-name)"
    local rbenv_global="$(rbenv global)"

    # Don't show anything if the current Ruby is the same as the global Ruby.
    if [[ "${rbenv_version_name}" == "${rbenv_global}" ]]; then
      rbenv_version_name=""
    fi
  fi

  serialize_segment "$0" "" "$1" "$2" "${3}" "red" "$DEFAULT_COLOR" "${rbenv_version_name}" "RUBY_ICON"
}

# chruby information
# see https://github.com/postmodern/chruby/issues/245 for chruby_auto issue with ZSH
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
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
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
prompt_root_indicator() {
  serialize_segment "$0" "" "$1" "$2" "${3}" "$DEFAULT_COLOR" "yellow" "" "ROOT_ICON" '[[ "${UID}" -eq 0 ]]'
}

# Print Rust version number
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
prompt_rust_version() {
  local rust_version
  rust_version=$(rustc --version 2>&1 | grep -oe "^rustc\s*[^ ]*" | grep -o '[0-9.a-z\\\-]*$')

  serialize_segment "$0" "" "$1" "$2" "${3}" "208" "$DEFAULT_COLOR" "${rust_version}" "RUST_ICON"
}

# RSpec test ratio
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
prompt_rspec_stats() {
  local code_amount tests_amount
  # Careful! `ls` seems to now work correctly with NULL_GLOB,
  # as described here http://unix.stackexchange.com/a/26819
  # This is the reason, why we do not use NULL_GLOB here.
  code_amount=$({ls -1 app/**/*.rb} 2> /dev/null | wc -l)
  tests_amount=$({ls -1 spec/**/*.rb} 2> /dev/null | wc -l)

  build_test_stats "$1" "$0" "$2" "${3}" "$code_amount" "$tests_amount" "RSpec" 'TEST_ICON' '[[ (-d app && -d spec && -n ${CONTENT}) ]]'
}

# Ruby Version Manager information
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
prompt_rvm() {
  local gemset=$(echo $GEM_HOME | awk -F'@' '{print $2}')
  [ "$gemset" != "" ] && gemset="@$gemset"

  local version=$(echo $MY_RUBY_HOME | awk -F'-' '{print $2}')

  serialize_segment "$0" "" "$1" "$2" "${3}" "240" "$DEFAULT_COLOR" "${version}${gemset}" "RUBY_ICON"
}

# Status: return code if verbose, otherwise just an icon if an error occurred
set_default POWERLEVEL9K_STATUS_VERBOSE true
set_default POWERLEVEL9K_STATUS_OK_IN_NON_VERBOSE false
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
prompt_status() {
  typeset -Ah current_state
  if [[ "${RETVAL}" -ne 0 ]]; then
    if [[ "$POWERLEVEL9K_STATUS_VERBOSE" == "true" ]]; then
      # This is a variant of the error state,
      # that just has different colors and a
      # different visual identifier.. sigh.
      current_state=(
        "STATE"               "ERROR"
        "CONTENT"             "${RETVAL}"
        "BACKGROUND_COLOR"    "red"
        "FOREGROUND_COLOR"    "226"
        "VISUAL_IDENTIFIER"   "CARRIAGE_RETURN_ICON"
      )
    else
      current_state=(
        "STATE"               "ERROR"
        "CONTENT"             "${RETVAL}"
        "BACKGROUND_COLOR"    "${DEFAULT_COLOR}"
        "FOREGROUND_COLOR"    "red"
        "VISUAL_IDENTIFIER"   "FAIL_ICON"
      )
    fi
  elif [[ "$POWERLEVEL9K_STATUS_VERBOSE" == "true" || "$POWERLEVEL9K_STATUS_OK_IN_NON_VERBOSE" == "true" ]]; then
    current_state=(
      "STATE"               "OK"
      "CONTENT"             "${RETVAL}"
      "BACKGROUND_COLOR"    "${DEFAULT_COLOR}"
      "FOREGROUND_COLOR"    "046"
      "VISUAL_IDENTIFIER"   "OK_ICON"
    )
  fi

  serialize_segment "$0" "${current_state[STATE]}" "$1" "$2" "${3}" "${current_state[BACKGROUND_COLOR]}" "${current_state[FOREGROUND_COLOR]}" "${current_state[CONTENT]}" "${current_state[VISUAL_IDENTIFIER]}"
}

# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
#   * $4 Root Path: string - An optional root path (used for unit tests @see swap.spec)
prompt_swap() {
  local ROOT_PATH="${4}"
  local swap_used=0
  local base=''

  if [[ "$OS" == "OSX" ]]; then
    local raw_swap_used
    raw_swap_used=$(sysctl vm.swapusage | grep -o "used\s*=\s*[0-9,.A-Z]*" | grep -o -E "[0-9,.A-Z]+")

    typeset -F 2 swap_used
    swap_used=${$(echo $raw_swap_used | grep -o -E "[0-9,.]+")//,/.}
    # Replace comma
    swap_used=${swap_used//,/.}

    base=$(echo "$raw_swap_used" | grep -o -E "[A-Z]+")
  else
    swap_total=$(grep -o -E "SwapTotal:\s+[0-9]+" $ROOT_PATH/proc/meminfo | grep -o -E "[0-9]+")
    swap_free=$(grep -o -E "SwapFree:\s+[0-9]+" $ROOT_PATH/proc/meminfo | grep -o -E "[0-9]+")
    swap_used=$(( swap_total - swap_free ))
    base='K'
  fi

  serialize_segment "$0" "" "$1" "$2" "${3}" "yellow" "$DEFAULT_COLOR" "$(printSizeHumanReadable "$swap_used" $base)" "SWAP_ICON"
}

# Swift version
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
prompt_swift_version() {
  # Get the first number as this is probably the "main" version number..
  local swift_version=$(swift --version 2>/dev/null | grep -o -E "[0-9.]+" | head -n 1)

  serialize_segment "$0" "" "$1" "$2" "${3}" "magenta" "white" "${swift_version}" "SWIFT_ICON"
}

# Symfony2-PHPUnit test ratio
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
prompt_symfony2_tests() {
  local code_amount tests_amount
  # Careful! `ls` seems to now work correctly with NULL_GLOB,
  # as described here http://unix.stackexchange.com/a/26819
  # This is the reason, why we do not use NULL_GLOB here.
  code_amount=$({ls -1 src/**/*.php} 2> /dev/null | grep -vc Tests)
  tests_amount=$({ls -1 src/**/*.php} 2> /dev/null | grep -c Tests)

  build_test_stats "$1" "$0" "$2" "${3}" "$code_amount" "$tests_amount" "SF2" 'TEST_ICON' '[[ (-d src && -d app && -f app/AppKernel.php && -n "${CONTENT}") ]]'
}

# Symfony2-Version
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
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
#   * $9 Condition
build_test_stats() {
  local joined="${4}"
  local code_amount="${5}"
  local tests_amount="${6}"+0.00001
  local headline="${7}"

  local current_state="unknown"
  typeset -AH test_states
  test_states=(
    'GOOD'          'cyan'
    'AVG'           'yellow'
    'BAD'           'red'
  )

  # Set float precision to 2 digits:
  typeset -F 2 ratio
  local ratio=0
  local content=''
  if (( code_amount > 0 )); then
    ratio=$(( (tests_amount/code_amount) * 100 ))

    (( ratio >= 75 )) && current_state="GOOD"
    (( ratio >= 50 && ratio < 75 )) && current_state="AVG"
    (( ratio < 50 )) && current_state="BAD"

    content="$headline: $ratio%%"
  fi

  serialize_segment "${2}" "$current_state" "${1}" "${3}" "${joined}" "${test_states[$current_state]}" "${DEFAULT_COLOR}" "${content}" "${8}" "${9}"
}

# System time
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
prompt_time() {
  set_default POWERLEVEL9K_TIME_FORMAT "%D{%H:%M:%S}"

  serialize_segment "$0" "" "$1" "$2" "${3}" "$DEFAULT_COLOR_INVERTED" "$DEFAULT_COLOR" "${POWERLEVEL9K_TIME_FORMAT}" ""
}

# todo.sh: shows the number of tasks in your todo.sh file
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
prompt_todo() {
  local todos=$(todo.sh ls 2>/dev/null | egrep "TODO: [0-9]+ of ([0-9]+) tasks shown" | awk '{ print $4 }')

  serialize_segment "$0" "" "$1" "$2" "${3}" "244" "$DEFAULT_COLOR" "${todos}" "TODO_ICON"
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

# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
prompt_vcs() {
  powerlevel9k_vcs_init

  VCS_WORKDIR_DIRTY=false
  VCS_WORKDIR_HALF_DIRTY=false
  local current_state="unknown"
  # The vcs segment can have three different states - defaults to 'clean'.
  typeset -gAH vcs_states
  vcs_states=(
    'clean'         'green'
    'modified'      'yellow'
    'untracked'     'green'
  )

  # Actually invoke vcs_info manually to gather all information.
  vcs_info
  local vcs_prompt="${vcs_info_msg_0_}"

  if [[ -n "${vcs_prompt}" ]]; then
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
  fi
  serialize_segment "$0" "$current_state" "$1" "$2" "${3}" "${vcs_states[$current_state]}" "$DEFAULT_COLOR" "${vcs_prompt}" "$vcs_visual_identifier"
}

# Vi Mode: show editing mode (NORMAL|INSERT)
set_default "POWERLEVEL9K_VI_INSERT_MODE_STRING" "INSERT"
set_default "POWERLEVEL9K_VI_COMMAND_MODE_STRING" "NORMAL"
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
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
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
prompt_virtualenv() {
  serialize_segment "$0" "" "$1" "$2" "${3}" "blue" "$DEFAULT_COLOR" "$(basename "${VIRTUAL_ENV}")" "PYTHON_ICON"
}

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
#   * $5 Joined: bool - If the segment should be joined
#   * $6 Background: string - The default background color of the segment
#   * $7 Foreground: string - The default foreground color of the segment
#   * $8 Content: string - Content of the segment
#   * $9 Visual identifier: string - Icon of the segment
#   * $10 Condition - The condition, if the segment should be printed
serialize_segment() {
  local NAME="${1}"
  local STATE="${2}"
  local ALIGNMENT="${3}"
  local INDEX="${4}"
  local JOINED="${5}"

  ################################################################
  # Methodology behind user-defined variables overwriting colors:
  #     The first parameter to the segment constructors is the calling function's
  #     name. From this function name, we strip the "prompt_"-prefix and
  #     uppercase it. This is then prefixed with "POWERLEVEL9K_" and suffixed
  #     with either "_BACKGROUND" or "_FOREGROUND", thus giving us the variable
  #     name. So each new segment is user-overwritten by a variable following
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

  # Conditions have three layers:
  # 1. All segments should not print
  #    a segemnt, if they provide no
  #    content (default condition).
  # 2. All segments could define a
  #    default condition on their
  #    own, overriding the previous
  #    one.
  # 3. Users could set a condition
  #    for each segment. This is
  #    the trump card, and has
  #    highest precedence.
  local CONDITION
  local SEGMENT_CONDITION="POWERLEVEL9K_${STATEFUL_NAME}_CONDITION"
  if defined "${SEGMENT_CONDITION}"; then
    CONDITION="${(P)SEGMENT_CONDITION}"
  elif [[ -n "${10}" ]]; then
    CONDITION="${10}"
  else
    CONDITION='[[ -n "${CONTENT}" ]]'
  fi
  # Precompile condition, as we are here in the async child process.
  eval "${CONDITION}" && CONDITION=true || CONDITION=false

  local FILE="${CACHE_DIR}/p9k_$$_${ALIGNMENT}_${(l:3::0:)INDEX}_${NAME}.sh"

  # From the manpage of typeset:
  #   If the -p option is given, parameters and values are printed in the form
  #   of a typeset command with an assignment, regardless of other flags and
  #   options.  Note that the -H flag on parameters is respected; no value
  #   will  be  shown  for  these parameters.
  # Redirection with `>!`. From the manpage: Same as >, except that the file
  #   is truncated to zero length if it exists, even if CLOBBER is unset.
  # If the file already exists, and a simple `>` redirection and CLOBBER
  # unset, ZSH will produce an error.
  typeset -p "NAME" >! $FILE
  typeset -p "STATE" >> $FILE
  typeset -p "ALIGNMENT" >> $FILE
  typeset -p "INDEX" >> $FILE
  typeset -p "JOINED" >> $FILE
  typeset -p "BACKGROUND" >> $FILE
  typeset -p "FOREGROUND" >> $FILE
  typeset -p "CONTENT" >> $FILE
  typeset -p "VISUAL_IDENTIFIER" >> $FILE
  typeset -p "CONDITION" >> $FILE

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
# Create cache dir
mkdir -p "${CACHE_DIR}" 2> /dev/null
#   $1 - Signal that should be propagated
p9k_build_prompt_from_cache() {
  # Set option so that prompt gets expanded
  # See http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
  setopt PROMPT_SUBST
  last_left_element_index=1 # Reset
  local LAST_LEFT_BACKGROUND='NONE' # Reset
  local LAST_RIGHT_BACKGROUND='NONE' # Reset
  PROMPT='' # Reset
  RPROMPT='' # Reset
  local RPROMPT_SUFFIX=''
  local PROMPT_SUFFIX=''
  if [[ "${POWERLEVEL9K_PROMPT_ON_NEWLINE}" == true ]]; then
    PROMPT="$(print_icon 'MULTILINE_FIRST_PROMPT_PREFIX')%f%b%k${PROMPT}"
    PROMPT_SUFFIX="
$(print_icon 'MULTILINE_SECOND_PROMPT_PREFIX')"
    if [[ "${POWERLEVEL9K_RPROMPT_ON_NEWLINE}" != true ]]; then
      # The right prompt should be on the same line as the first line of the left
      # prompt. To do so, there is just a quite ugly workaround: Before zsh draws
      # the RPROMPT, we advise it, to go one line up. At the end of RPROMPT, we
      # advise it to go one line down. See:
      # http://superuser.com/questions/357107/zsh-right-justify-in-ps1
      local LC_ALL="" LC_CTYPE="en_US.UTF-8" # Set the right locale to protect special characters
      RPROMPT='%{'$'\e[1A''%}' # one line up
      RPROMPT_SUFFIX='%{'$'\e[1B''%}' # one line down
    fi
  fi

  typeset -Ah last_segments_print_states
  last_segments_print_states=()
  typeset -Ah last_segments_join_states
  last_segments_join_states=()

  # (N) sets the NULL_GLOB option, so that if the glob does
  # not return files, an error message is suppressed.
  for idx in ${CACHE_DIR}/p9k_$$_*(N); do
    source "${idx}"

    local paddedIndex="${(l:3::0:)INDEX}"

    # Default: Segment should NOT be joined.
    local should_join_segment=false

    # If the current segment wants to be joined, we need
    # to have a close look at our predecessors.
    if [[ "${JOINED}" == "true" ]]; then
      # If we want to know if the current segment should be joined or
      # not, we need to consider the previous segments join state and
      # whether they were printed or not.
      # Beginning from our current position and moving to the left (as
      # this is the joining direction; segments can always be joined
      # with their predecessor, a.k.a. previous left segment). As soon
      # as we find a segment that was not joined and not printed, we
      # promote the segment to a full one.
      should_join_segment=true
      for ((n=${INDEX}; n > 0; n=${n}-1)); do
        # Little magic trick: We start from current index, although we
        # just want to examine our ancestors because the current
        # segment is not yet in the array. So we just skip one step
        # implicitly.
        local currentPaddedIndex="${(l:3::0:)n}"
        local print_state=$last_segments_print_states["${ALIGNMENT}_${currentPaddedIndex}"]
        local join_state=$last_segments_join_states["${ALIGNMENT}_${currentPaddedIndex}"]

        if [[ "${join_state}" == "false" && "${print_state}" == "false" ]]; then
          should_join_segment=false
          # Break the loop as early as possible. If we know that our segment should
          # be promoted, we got the relevant information we wanted.
          break
        elif [[ "${join_state}" == "true" && "${print_state}" == "true" ]]; then
          # If previous segment was joined and printed, we can break here
          # because this previous segment should handle its join state.
          break
        elif [[ "${join_state}" == "false" ]]; then
          break
        fi
      done
    fi

    last_segments_join_states["${ALIGNMENT}_${paddedIndex}"]="${JOINED}"
    last_segments_print_states["${ALIGNMENT}_${paddedIndex}"]="${CONDITION}"

    # If the segments condition to print was not met, skip it!
    if ! ${CONDITION}; then
      continue
    fi

    local statefulName="${NAME}"
    [[ -n "${STATE}" ]] && statefulName="${NAME}_${STATE}"

    if [[ "${ALIGNMENT}" == "left" ]]; then
      PROMPT+=$("${(L)ALIGNMENT}_prompt_segment" "${statefulName}" "${INDEX}" "${BACKGROUND}" "${FOREGROUND}" "${CONTENT}" "${VISUAL_IDENTIFIER}" "${LAST_LEFT_BACKGROUND}" "${should_join_segment}")
      LAST_LEFT_BACKGROUND="${BACKGROUND}"
    elif [[ "${ALIGNMENT}" == "right" ]]; then
      RPROMPT+=$("${(L)ALIGNMENT}_prompt_segment" "${statefulName}" "${INDEX}" "${BACKGROUND}" "${FOREGROUND}" "${CONTENT}" "${VISUAL_IDENTIFIER}" "${LAST_RIGHT_BACKGROUND}" "${should_join_segment}")
      LAST_RIGHT_BACKGROUND="${BACKGROUND}"
    fi
  done
  PROMPT+="$(left_prompt_end ${LAST_LEFT_BACKGROUND})"
  PROMPT+="${PROMPT_SUFFIX}"
  RPROMPT+="${RPROMPT_SUFFIX}"
  # About .reset-promt see:
  # https://github.com/sorin-ionescu/prezto/issues/1026
  # https://github.com/zsh-users/zsh-autosuggestions/issues/107#issuecomment-183824034
  zle && zle .reset-prompt

  # Add zero to $1, so that we can call this function without parameters
  # in tests..
  return $(( 128 + ($1 + 0) ))
}
# Register trap on WINCH (Rebuild prompt)
trap "p9k_build_prompt_from_cache WINCH" WINCH

#   $1 - Signal that should be propagated
p9k_clear_cache() {
  # Stupid way to avoid "no matches found" globbing error on
  # deleting cache files.
  touch ${CACHE_DIR}/p9k_$$_dummy
  # (N) sets the NULL_GLOB option, so that if the glob does
  # not return files, an error message is suppressed.
  rm -f ${CACHE_DIR}/p9k_$$_*(N)

  # We also call this function from `powerlevel9k_prepare_prompt`
  # There we just want to clean the cache without having signal
  # to propagate. This is the reason, why we need the condition.
  if [[ -n "${1}" ]]; then
    return $(( 128 + $1 ))
  fi
}
# Register trap on EXIT (cleanup)
trap "p9k_clear_cache EXIT" EXIT
# Register trap on TERM (cleanup)
trap "p9k_clear_cache TERM" TERM

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

  # Initialize icon overrides
  _powerlevel9kInitializeIconOverrides

  # Precompile the Segment Separators here!
  _POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR="$(print_icon 'LEFT_SEGMENT_SEPARATOR')"
  _POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR="$(print_icon 'LEFT_SUBSEGMENT_SEPARATOR')"
  _POWERLEVEL9K_LEFT_SEGMENT_END_SEPARATOR="$(print_icon 'LEFT_SEGMENT_END_SEPARATOR')"
  _POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR="$(print_icon 'RIGHT_SEGMENT_SEPARATOR')"
  _POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR="$(print_icon 'RIGHT_SUBSEGMENT_SEPARATOR')"

  build_left_prompt
  if [[ "${POWERLEVEL9K_DISABLE_RPROMPT}" != "true" ]]; then
    build_right_prompt
  fi

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

prompt_powerlevel9k_setup() {
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

prompt_powerlevel9k_setup "$@"

# Show all active traps
# trap --

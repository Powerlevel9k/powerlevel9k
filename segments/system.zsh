#!usr/bin/env zsh
# vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8
################################################################
# System segments
# This file holds the system segments for
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

################################################################
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

################################################################
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

  if [[ "$OS" == "Linux" || "$OS" == "Android" ]]; then
    local sysp="${ROOT_PATH}/sys/class/power_supply"
    # Reported BAT0 or BAT1 depending on kernel version
    [[ -a $sysp/BAT0 ]] && local bat=$sysp/BAT0
    [[ -a $sysp/BAT1 ]] && local bat=$sysp/BAT1

    # Android-related
    # Tested on: Moto G falcon (CM 13.0)
    [[ -a $sysp/battery ]] && local bat=$sysp/battery

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

  local segment=$(( 100.0 / (${#POWERLEVEL9K_BATTERY_STAGES} - 1 ) ))
  if [[ $segment > 1 ]]; then
    local offset=$(( ($bat_percent / $segment) + 1 ))
    [[ "${(t)POWERLEVEL9K_BATTERY_STAGES}" =~ "array" ]] && POWERLEVEL9K_BATTERY_ICON="$POWERLEVEL9K_BATTERY_STAGES[$offset]" || POWERLEVEL9K_BATTERY_ICON=${POWERLEVEL9K_BATTERY_STAGES:$offset:1}
  fi

  if [[ "${(t)POWERLEVEL9K_BATTERY_LEVEL_BACKGROUND}" =~ "array" ]]; then
    local segment=$(( 100.0 / (${#POWERLEVEL9K_BATTERY_LEVEL_BACKGROUND} - 1 ) ))
    local offset=$(( ($bat_percent / $segment) + 1 ))
    serialize_segment "$0" "${current_state}" "$1" "$2" "${3}" "${POWERLEVEL9K_BATTERY_LEVEL_BACKGROUND[$offset]}" "${battery_states[$current_state]}" "${message}" "BATTERY_ICON"
  else
    # Draw the prompt_segment
    serialize_segment "$0" "${current_state}" "$1" "$2" "${3}" "${DEFAULT_COLOR}" "${battery_states[$current_state]}" "${message}" "BATTERY_ICON"
  fi
}

################################################################
# Segment that indicates usage level of current partition.
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
set_default POWERLEVEL9K_DISK_USAGE_ONLY_WARNING false
set_default POWERLEVEL9K_DISK_USAGE_WARNING_LEVEL 90
set_default POWERLEVEL9K_DISK_USAGE_CRITICAL_LEVEL 95
prompt_disk_usage() {
  local current_state="unknown"
  typeset -AH hdd_usage_forecolors
  hdd_usage_forecolors=(
    'normal'        'yellow'
    'warning'       "${DEFAULT_COLOR}"
    'critical'      "${DEFAULT_COLOR_INVERTED}"
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

################################################################
# Display the duration the command needed to run.
prompt_command_execution_time() {
  set_default POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD 3
  set_default POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION 2

  # Print time in human readable format
  # For that use `strftime` and convert
  # the duration (float) to an seconds
  # (integer).
  # See http://unix.stackexchange.com/a/89748
  local humanReadableDuration
  if (( _P9K_COMMAND_DURATION > 3600 )); then
    humanReadableDuration=$(TZ=GMT; strftime '%H:%M:%S' $(( int(rint(_P9K_COMMAND_DURATION)) )))
  elif (( _P9K_COMMAND_DURATION > 60 )); then
    humanReadableDuration=$(TZ=GMT; strftime '%M:%S' $(( int(rint(_P9K_COMMAND_DURATION)) )))
  else
    # If the command executed in seconds, print as float.
    # Convert to float
    if [[ "${POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION}" == "0" ]]; then
      # If user does not want microseconds, then we need to convert
      # the duration to an integer.
      typeset -i humanReadableDuration
    else
      typeset -F ${POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION} humanReadableDuration
    fi
    humanReadableDuration=$_P9K_COMMAND_DURATION
  fi

  if (( _P9K_COMMAND_DURATION <= POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD )); then
    # humanReadableDuration=''
    unset humanReadableDuration
  fi

  serialize_segment "$0" "" "$1" "$2" "${3}" "red" "226" "${humanReadableDuration}" "EXECUTION_TIME_ICON"
}

################################################################
# Context: user@hostname (who am I and where am I)
# Note that if $DEFAULT_USER is not set, this prompt segment will always print
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
set_default POWERLEVEL9K_ALWAYS_SHOW_CONTEXT false
set_default POWERLEVEL9K_ALWAYS_SHOW_USER false
set_default POWERLEVEL9K_CONTEXT_TEMPLATE "%n@%m"
prompt_context() {
  local current_state="DEFAULT"
  typeset -AH context_states
  context_states=(
    "ROOT"      "yellow"
    "DEFAULT"   "011"
  )

  local content=""

  if [[ "$POWERLEVEL9K_ALWAYS_SHOW_CONTEXT" == true ]] || [[ "$USER" != "$DEFAULT_USER" ]] || [[ -n "$SSH_CLIENT" || -n "$SSH_TTY" ]]; then

      if [[ $(print -P "%#") == '#' ]]; then
        current_state="ROOT"
      fi

      content="${POWERLEVEL9K_CONTEXT_TEMPLATE}"

  elif [[ "$POWERLEVEL9K_ALWAYS_SHOW_USER" == true ]]; then
      content="$USER"
  fi

  serialize_segment "$0" "${state}" "$1" "$2" "${3}" "${DEFAULT_COLOR}" "${context_states[$current_state]}" "${content}" ""
}

################################################################
# System date
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
prompt_date() {
  set_default POWERLEVEL9K_DATE_FORMAT "%D{%d.%m.%y}"

  serialize_segment "$0" "" "$1" "$2" "${3}" "$DEFAULT_COLOR_INVERTED" "$DEFAULT_COLOR" "${POWERLEVEL9K_DATE_FORMAT}" "DATE_ICON"
}

################################################################
# Dir: current working directory
set_default POWERLEVEL9K_DIR_PATH_SEPARATOR "/"
set_default POWERLEVEL9K_HOME_FOLDER_ABBREVIATION "~"
set_default POWERLEVEL9K_ROOT_FOLDER_ABBREVIATION "/"
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
prompt_dir() {
  local current_path="$(print -P "%~")"
  if [[ -n "$POWERLEVEL9K_SHORTEN_DIR_LENGTH" || "$POWERLEVEL9K_SHORTEN_STRATEGY" == "truncate_with_folder_marker" ]]; then
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

        # Replace the shortest possible match of the marked folder from
        # the current path. Remove the amount of characters up to the
        # folder marker from the left. Count only the visible characters
        # in the path (this is done by the "zero" pattern; see
        # http://stackoverflow.com/a/40855342/5586433).
        local zero='%([BSUbfksu]|([FB]|){*})'
        current_dir=$(pwd)
        # Then, find the length of the package_path string, and save the
        # subdirectory path as a substring of the current directory's path from 0
        # to the length of the package path's string
        subdirectory_path=$(truncatePathFromRight "${current_dir:${#${(S%%)package_path//$~zero/}}}")
        # Parse the 'name' from the package.json; if there are any problems, just
        # print the file path
        defined POWERLEVEL9K_DIR_PACKAGE_FILES || POWERLEVEL9K_DIR_PACKAGE_FILES=(package.json composer.json)

        local pkgFile="unknown"
        for file in "${POWERLEVEL9K_DIR_PACKAGE_FILES[@]}"; do
          if [[ -f "${package_path}/${file}" ]]; then
            pkgFile="${package_path}/${file}"
            break;
          fi
        done

        local packageName=$(jq '.name' ${pkgFile} 2> /dev/null \
          || node -e 'console.log(require(process.argv[1]).name);' ${pkgFile} 2>/dev/null \
          || cat "${pkgFile}" 2> /dev/null | grep -m 1 "\"name\"" | awk -F ':' '{print $2}' | awk -F '"' '{print $2}' 2>/dev/null \
          )
        if [[ -n "${packageName}" ]]; then
          # Instead of printing out the full path, print out the name of the package
          # from the package.json and append the current subdirectory
          current_path="`echo $packageName | tr -d '"'`$subdirectory_path"
        else
          current_path=$(truncatePathFromRight "$(pwd | sed -e "s,^$HOME,~,")" )
        fi
      ;;
      truncate_with_folder_marker)
        local last_marked_folder marked_folder
        set_default POWERLEVEL9K_SHORTEN_FOLDER_MARKER ".shorten_folder_marker"

        # Search for the folder marker in the parent directories and
        # buildup a pattern that is removed from the current path
        # later on.
        for marked_folder in $(upsearch $POWERLEVEL9K_SHORTEN_FOLDER_MARKER); do
          if [[ "$marked_folder" == "/" ]]; then
            # If we reached root folder, stop upsearch.
            current_path="/"
          elif [[ "$marked_folder" == "$HOME" ]]; then
            # If we reached home folder, stop upsearch.
            current_path="~"
          elif [[ "${marked_folder%/*}" == $last_marked_folder ]]; then
            current_path="${current_path%/}/${marked_folder##*/}"
          else
            current_path="${current_path%/}/$POWERLEVEL9K_SHORTEN_DELIMITER/${marked_folder##*/}"
          fi
          last_marked_folder=$marked_folder
        done

        # Replace the shortest possible match of the marked folder from
        # the current path.
        current_path=$current_path${PWD#${last_marked_folder}*}
      ;;
      *)
        current_path="$(print -P "%$((POWERLEVEL9K_SHORTEN_DIR_LENGTH+1))(c:$POWERLEVEL9K_SHORTEN_DELIMITER/:)%${POWERLEVEL9K_SHORTEN_DIR_LENGTH}c")"
      ;;
    esac
  fi

  local path_opt=$current_path # save state of path for highlighting and bold options

  if [[ "${POWERLEVEL9K_DIR_OMIT_FIRST_CHARACTER}" == "true" ]]; then
    current_path="${current_path[2,-1]}"
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

  local bd
  [[ -n "${POWERLEVEL9K_DIR_PATH_HIGHLIGHT_BOLD}" ]] && bd="%B" || bd=""

  local dir_state_user_foreground="POWERLEVEL9K_DIR_${current_state}_FOREGROUND"
  local dir_state_foreground="${(P)dir_state_user_foreground}"
  [[ -z "${dir_state_foreground}" ]] && dir_state_foreground="${DEFAULT_COLOR}"

  if [[ -n "${POWERLEVEL9K_DIR_PATH_HIGHLIGHT_FOREGROUND}" ]]; then
    if [[ $path_opt == "/" || $path_opt == "~" || $(dirname $path_opt) == "/" || ${POWERLEVEL9K_DIR_OMIT_FIRST_CHARACTER} ]]; then
      current_path="$bd%F{$POWERLEVEL9K_DIR_PATH_HIGHLIGHT_FOREGROUND}$current_path%F{$dir_state_foreground}"
    else
      current_path="$(dirname $current_path)/$bd%F{$POWERLEVEL9K_DIR_PATH_HIGHLIGHT_FOREGROUND}$(basename $current_path)%F{$dir_state_foreground}"
    fi
  fi

  if [[ -n "${POWERLEVEL9K_DIR_PATH_SEPARATOR_FOREGROUND}" && $path_opt != "/" ]]; then
    current_path="$( echo "${current_path}" | sed "s/\//%F{$POWERLEVEL9K_DIR_PATH_SEPARATOR_FOREGROUND}\/%F{$dir_state_foreground}/g")"
  fi

  if [[ "${POWERLEVEL9K_DIR_PATH_SEPARATOR}" != "/" && $path_opt != "/" ]]; then
    current_path="$( echo "${current_path}" | sed "s/\//${POWERLEVEL9K_DIR_PATH_SEPARATOR}/g")"
  fi

  if [[ "${POWERLEVEL9K_HOME_FOLDER_ABBREVIATION}" != "~" && ! ${POWERLEVEL9K_DIR_OMIT_FIRST_CHARACTER} ]]; then
    current_path="$( echo "${current_path}" | sed "s/~/${POWERLEVEL9K_HOME_FOLDER_ABBREVIATION}/1")"
  fi

  serialize_segment "$0" "${current_state}" "$1" "$2" "${3}" "blue" "${DEFAULT_COLOR}" "${current_path}" "${dir_states[$current_state]}"
}

################################################################
# dir_writable: Display information about the user's permission to write in the current directory
prompt_dir_writable() {
  serialize_segment "$0" "FORBIDDEN" "$1" "$2" "${3}" "red" "226" "" 'LOCK_ICON' '[[ ! -w "$PWD" ]]'
}

################################################################
# Command number (in local history)
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
prompt_history() {
  serialize_segment "$0" "" "$1" "$2" "${3}" "244" "${DEFAULT_COLOR}" "%h" ""
}

################################################################
# Host: machine (where am I)
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
set_default POWERLEVEL9K_HOST_TEMPLATE "%m"
prompt_host() {
  local current_state="LOCAL"
  typeset -AH host_state
  if [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]]; then
    host_state=(
      "STATE"               "REMOTE"
      "CONTENT"             "${POWERLEVEL9K_HOST_TEMPLATE}"
      "BACKGROUND_COLOR"    "${DEFAULT_COLOR}"
      "FOREGROUND_COLOR"    "yellow"
      "VISUAL_IDENTIFIER"   "SSH_ICON"
    )
  else
    host_state=(
      "STATE"               "LOCAL"
      "CONTENT"             "${POWERLEVEL9K_HOST_TEMPLATE}"
      "BACKGROUND_COLOR"    "${DEFAULT_COLOR}"
      "FOREGROUND_COLOR"    "011"
      "VISUAL_IDENTIFIER"   "HOST_ICON"
    )
  fi
  serialize_segment "$0" "${host_state[STATE]}" "$1" "$2" "${3}" "${host_state[BACKGROUND_COLOR]}" "${host_state[FOREGROUND_COLOR]}" "${host_state[CONTENT]}" "${host_state[VISUAL_IDENTIFIER]}"
}

################################################################
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

################################################################
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
    Android)
      OS_ICON=$(print_icon 'ANDROID_ICON')
      ;;
    Solaris)
      OS_ICON=$(print_icon 'SUNOS_ICON')
      ;;
  esac

  serialize_segment "$0" "" "$1" "$2" "${3}" "${DEFAULT_COLOR}" "${DEFAULT_COLOR_INVERTED}" "${OS_ICON}" ""
}

################################################################
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
    # Available = Free + Inactive
    # See https://support.apple.com/en-us/HT201538
    local pagesFree=$(vm_stat | grep "Pages free" | grep -o -E '[0-9]+')
    local pagesInactive=$(vm_stat | grep "Pages inactive" | grep -o -E '[0-9]+')
    ramfree=$((pagesFree + pagesInactive))
    # Convert pages into Bytes
    ramfree=$(( ramfree * 4096 ))
  elif [[ "$OS" == "BSD" ]]; then
      ramfree=$(grep 'avail memory' $ROOT_PATH/var/run/dmesg.boot | awk '{print $4}')
  else
    ramfree=$(grep -o -E "MemAvailable:\s+[0-9]+" $ROOT_PATH/proc/meminfo | grep -o -E "[0-9]+")
    base='K'
  fi

  serialize_segment "$0" "" "$1" "$2" "${3}" "yellow" "$DEFAULT_COLOR" "$(printSizeHumanReadable "$ramfree" $base)" "RAM_ICON"
}

################################################################
# Print an icon if user is root.
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
prompt_root_indicator() {
  serialize_segment "$0" "" "$1" "$2" "${3}" "$DEFAULT_COLOR" "yellow" "" "ROOT_ICON" '[[ "${UID}" -eq 0 ]]'
}

################################################################
# Status: return code if verbose, otherwise just an icon if an error occurred
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
set_default POWERLEVEL9K_STATUS_VERBOSE true
set_default POWERLEVEL9K_STATUS_OK_IN_NON_VERBOSE false
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

################################################################
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

################################################################
# System time
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
prompt_time() {
  set_default POWERLEVEL9K_TIME_FORMAT "%D{%H:%M:%S}"

  serialize_segment "$0" "" "$1" "$2" "${3}" "$DEFAULT_COLOR_INVERTED" "$DEFAULT_COLOR" "${POWERLEVEL9K_TIME_FORMAT}" "TIME_ICON"
}
################################################################
# User: user (who am I)
# Note that if $DEFAULT_USER is not set, this prompt segment will always print
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
set_default POWERLEVEL9K_USER_TEMPLATE "%n"
prompt_user() {
  local current_state="DEFAULT"
  typeset -AH user_state
  if [[ "$POWERLEVEL9K_ALWAYS_SHOW_USER" == true ]] || [[ "$USER" != "$DEFAULT_USER" ]] || [[ -n "$SSH_CLIENT" || -n "$SSH_TTY" ]]; then
    if [[ $(print -P "%#") == '#' ]]; then
      user_state=(
        "STATE"               "ROOT"
        "CONTENT"             "${POWERLEVEL9K_USER_TEMPLATE}"
        "BACKGROUND_COLOR"    "${DEFAULT_COLOR}"
        "FOREGROUND_COLOR"    "yellow"
        "VISUAL_IDENTIFIER"   "ROOT_ICON"
      )
    else
      user_state=(
        "STATE"               "DEFAULT"
        "CONTENT"             "$USER"
        "BACKGROUND_COLOR"    "${DEFAULT_COLOR}"
        "FOREGROUND_COLOR"    "011"
        "VISUAL_IDENTIFIER"   "USER_ICON"
      )
    fi
  fi
  serialize_segment "$0" "${user_state[STATE]}" "$1" "$2" "${3}" "${user_state[BACKGROUND_COLOR]}" "${user_state[FOREGROUND_COLOR]}" "${user_state[CONTENT]}" "${user_state[VISUAL_IDENTIFIER]}" "" "true"
}

################################################################
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


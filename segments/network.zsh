#!usr/bin/env zsh
# vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8
################################################################
# Network segments
# This file holds the network segments for
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

################################################################
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
  defined POWERLEVEL9K_PUBLIC_IP_METHODS || POWERLEVEL9K_PUBLIC_IP_METHODS=(dig curl wget)

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
  local fresh_ip
  if [[ $refresh_ip =~ true && -w $POWERLEVEL9K_PUBLIC_IP_FILE ]]; then
    for method in "${POWERLEVEL9K_PUBLIC_IP_METHODS[@]}"; do
      case $method in
        'dig')
            fresh_ip="$(dig +time=1 +tries=1 +short myip.opendns.com @resolver1.opendns.com 2> /dev/null)"
            [[ "$fresh_ip" =~ ^\; ]] && unset fresh_ip
          ;;
        'curl')
            fresh_ip="$(curl --max-time 10 -w '\n' "$POWERLEVEL9K_PUBLIC_IP_HOST" 2> /dev/null)"
          ;;
        'wget')
            fresh_ip="$(wget -T 10 -qO- "$POWERLEVEL9K_PUBLIC_IP_HOST" 2> /dev/null)"
          ;;
      esac
      # If we found a fresh IP, break loop.
      if [[ -n "${fresh_ip}" ]]; then
        break;
      fi
    done

    # write IP to tmp file or clear tmp file if an IP was not retrieved
    # Redirection with `>!`. From the manpage: Same as >, except that the file
    #   is truncated to zero length if it exists, even if CLOBBER is unset.
    # If the file already exists, and a simple `>` redirection and CLOBBER
    # unset, ZSH will produce an error.
    [[ -n "${fresh_ip}" ]] && echo $fresh_ip >! $POWERLEVEL9K_PUBLIC_IP_FILE || echo $POWERLEVEL9K_PUBLIC_IP_NONE >! $POWERLEVEL9K_PUBLIC_IP_FILE
  fi

  # read public IP saved to tmp file
  local public_ip="$(cat $POWERLEVEL9K_PUBLIC_IP_FILE)"

  # Draw the prompt segment
  serialize_segment "$0" "" "$1" "$2" "${3}" "${DEFAULT_COLOR}" "${DEFAULT_COLOR_INVERTED}" "${public_ip}" "PUBLIC_IP_ICON"
}

################################################################
# Print an icon if we are using SSH
prompt_ssh() {
  serialize_segment "$0" "" "$1" "$2" "${3}" "$DEFAULT_COLOR" "yellow" "" "SSH_ICON" '[[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]]'
}


#!/usr/bin/env zsh
# vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8
################################################################
# icons
# This file holds the icon definitions and
# icon-functions for the powerlevel9k-ZSH-theme
# https://github.com/bhilburn/powerlevel9k
################################################################

# These characters require the Powerline fonts to work properly. If you see
# boxes or bizarre characters below, your fonts are not correctly installed. If
# you do not want to install a special font, you can set `POWERLEVEL9K_MODE` to
# `compatible`. This shows all icons in regular symbols.

typeset -gAH icons_awesome_patched
function _powerlevel9k_setup_awesome_patched_icons() {
  # Awesome-Patched Font required! See:
  # https://github.com/gabrielelana/awesome-terminal-fonts/tree/patching-strategy/patched
  # Set the right locale to protect special characters
  local LC_ALL="" LC_CTYPE="en_US.UTF-8"

  icons_awesome_patched=(
      LEFT_SEGMENT_SEPARATOR         $'\uE0B0'              # 
      RIGHT_SEGMENT_SEPARATOR        $'\uE0B2'              # 
      LEFT_SEGMENT_END_SEPARATOR     ' '                    # Whitespace
      LEFT_SUBSEGMENT_SEPARATOR      $'\uE0B1'              # 
      RIGHT_SUBSEGMENT_SEPARATOR     $'\uE0B3'              # 
      CARRIAGE_RETURN_ICON           $'\u21B5'              # ↵
      ROOT_ICON                      $'\uE801'              # 
      RUBY_ICON                      $'\uE847 '             # 
      AWS_ICON                       $'\uE895'              # 
      AWS_EB_ICON                    $'\U1F331 '            # 🌱
      BACKGROUND_JOBS_ICON           $'\uE82F '             # 
      TEST_ICON                      $'\uE891'              # 
      TODO_ICON                      $'\u2611'              # ☑
      BATTERY_ICON                   $'\uE894'              # 
      DISK_ICON                      $'\uE1AE '             # 
      OK_ICON                        $'\u2713'              # ✓
      FAIL_ICON                      $'\u2718'              # ✘
      SYMFONY_ICON                   'SF'
      NODE_ICON                      $'\u2B22'              # ⬢
      MULTILINE_FIRST_PROMPT_PREFIX  $'\u256D'$'\U2500'
      MULTILINE_SECOND_PROMPT_PREFIX $'\u2570'$'\U2500 '
      ANDROID_ICON                   $'\uE270'              # 
      APPLE_ICON                     $'\uE26E'              # 
      FREEBSD_ICON                   $'\U1F608 '            # 😈
      LINUX_ICON                     $'\uE271'              # 
      SUNOS_ICON                     $'\U1F31E '            # 🌞
      HOME_ICON                      $'\uE12C'              # 
      HOME_SUB_ICON                  $'\uE18D'              # 
      FOLDER_ICON                    $'\uE818'              # 
      NETWORK_ICON                   $'\uE1AD'              # 
      LOAD_ICON                      $'\uE190 '             # 
      SWAP_ICON                      $'\uE87D'              # 
      RAM_ICON                       $'\uE1E2 '             # 
      SERVER_ICON                    $'\uE895'              # 
      VCS_UNTRACKED_ICON             $'\uE16C'              # 
      VCS_UNSTAGED_ICON              $'\uE17C'              # 
      VCS_STAGED_ICON                $'\uE168'              # 
      VCS_STASH_ICON                 $'\uE133 '             # 
      #VCS_INCOMING_CHANGES_ICON     $'\uE1EB '             # 
      #VCS_INCOMING_CHANGES_ICON     $'\uE80D '             # 
      VCS_INCOMING_CHANGES_ICON      $'\uE131 '             # 
      #VCS_OUTGOING_CHANGES_ICON     $'\uE1EC '             # 
      #VCS_OUTGOING_CHANGES_ICON     $'\uE80E '             # 
      VCS_OUTGOING_CHANGES_ICON      $'\uE132 '             # 
      VCS_TAG_ICON                   $'\uE817 '             # 
      VCS_BOOKMARK_ICON              $'\uE87B'              # 
      VCS_COMMIT_ICON                $'\uE821 '             # 
      VCS_BRANCH_ICON                $'\uE220'              # 
      VCS_REMOTE_BRANCH_ICON         $'\u2192'              # →
      VCS_GIT_ICON                   $'\uE20E '             # 
      VCS_GIT_GITHUB_ICON            $'\uE20E '             #
      VCS_GIT_BITBUCKET_ICON         $'\uE20E '             #
      VCS_GIT_GITLAB_ICON            $'\uE20E '             #
      VCS_HG_ICON                    $'\uE1C3 '             # 
      VCS_SVN_ICON                   '(svn) '
      RUST_ICON                      ''
      PYTHON_ICON                    $'\U1F40D'             # 🐍
      SWIFT_ICON                     ''
      PUBLIC_IP_ICON                 ''
      LOCK_ICON                      $'\UE138'              # 
      EXECUTION_TIME_ICON            $'\UE89C'              # 
      SSH_ICON                       '(ssh)'
  )
}
_powerlevel9k_setup_awesome_patched_icons

typeset -gAH icons_awesome_fontconfig
function _powerlevel9k_setup_awesome_fontconfig_icons() {
  # fontconfig with awesome-font required! See
  # https://github.com/gabrielelana/awesome-terminal-fonts

  # if not defined, set recommended linux path
  typeset -p "POWERLEVEL9K_FONTAWESOME_PATH" > /dev/null 2>&1  || POWERLEVEL9K_FONTAWESOME_PATH=~/.fonts

  source "$POWERLEVEL9K_FONTAWESOME_PATH/fontawesome-regular.sh"
  # source "$POWERLEVEL9K_FONTAWESOME_PATH/devicons-regular.sh" # no named codepoints
  source "$POWERLEVEL9K_FONTAWESOME_PATH/octicons-regular.sh"

  # Set the right locale to protect special characters
  local LC_ALL="" LC_CTYPE="en_US.UTF-8"

  icons_awesome_fontconfig=(
      LEFT_SEGMENT_SEPARATOR         $'\uE0B0'              # 
      RIGHT_SEGMENT_SEPARATOR        $'\uE0B2'              # 
      LEFT_SEGMENT_END_SEPARATOR     ' '                    # Whitespace
      LEFT_SUBSEGMENT_SEPARATOR      $'\uE0B1'              # 
      RIGHT_SUBSEGMENT_SEPARATOR     $'\uE0B3'              # 
      CARRIAGE_RETURN_ICON           $'\u21B5'              # ↵
      ROOT_ICON                      '\u'$CODEPOINT_OF_OCTICONS_ZAP                 # 
      RUBY_ICON                      '\u'$CODEPOINT_OF_OCTICONS_RUBY' '             # 
      AWS_ICON                       '\u'$CODEPOINT_OF_AWESOME_SERVER               # 
      AWS_EB_ICON                    $'\U1F331 '                                    # 🌱
      BACKGROUND_JOBS_ICON           '\u'$CODEPOINT_OF_AWESOME_COG' '               # 
      TEST_ICON                      '\u'$CODEPOINT_OF_AWESOME_BUG                  # 
      TODO_ICON                      '\u'$CODEPOINT_OF_AWESOME_CHECK_SQUARE_O       # 
      BATTERY_ICON                   '\U'$CODEPOINT_OF_AWESOME_BATTERY_FULL         # 
      DISK_ICON                      '\u'$CODEPOINT_OF_AWESOME_HDD_O' '             # 
      OK_ICON                        '\u'$CODEPOINT_OF_AWESOME_CHECK                # 
      FAIL_ICON                      '\u'$CODEPOINT_OF_AWESOME_TIMES                # 
      SYMFONY_ICON                   'SF'
      NODE_ICON                      $'\u2B22'                                      # ⬢
      MULTILINE_FIRST_PROMPT_PREFIX  $'\u256D'$'\U2500'                             # ╭─
      MULTILINE_SECOND_PROMPT_PREFIX $'\u2570'$'\U2500 '                            # ╰─
      APPLE_ICON                     '\u'$CODEPOINT_OF_AWESOME_APPLE                # 
      FREEBSD_ICON                   $'\U1F608 '                                    # 😈
      LINUX_ICON                     '\u'$CODEPOINT_OF_AWESOME_LINUX                # 
      SUNOS_ICON                     '\u'$CODEPOINT_OF_AWESOME_SUN_O' '             # 
      HOME_ICON                      '\u'$CODEPOINT_OF_AWESOME_HOME                 # 
      HOME_SUB_ICON                  '\u'$CODEPOINT_OF_AWESOME_FOLDER_OPEN          # 
      FOLDER_ICON                    '\u'$CODEPOINT_OF_AWESOME_FOLDER_O             # 
      NETWORK_ICON                   '\u'$CODEPOINT_OF_AWESOME_RSS                  # 
      LOAD_ICON                      '\u'$CODEPOINT_OF_AWESOME_BAR_CHART' '         # 
      SWAP_ICON                      '\u'$CODEPOINT_OF_AWESOME_DASHBOARD            # 
      RAM_ICON                       '\u'$CODEPOINT_OF_AWESOME_DASHBOARD            # 
      SERVER_ICON                    '\u'$CODEPOINT_OF_AWESOME_SERVER               # 
      VCS_UNTRACKED_ICON             '\u'$CODEPOINT_OF_AWESOME_QUESTION_CIRCLE      # 
      VCS_UNSTAGED_ICON              '\u'$CODEPOINT_OF_AWESOME_EXCLAMATION_CIRCLE   # 
      VCS_STAGED_ICON                '\u'$CODEPOINT_OF_AWESOME_PLUS_CIRCLE          # 
      VCS_STASH_ICON                 '\u'$CODEPOINT_OF_AWESOME_INBOX' '             # 
      VCS_INCOMING_CHANGES_ICON      '\u'$CODEPOINT_OF_AWESOME_ARROW_CIRCLE_DOWN' ' # 
      VCS_OUTGOING_CHANGES_ICON      '\u'$CODEPOINT_OF_AWESOME_ARROW_CIRCLE_UP' '   # 
      VCS_TAG_ICON                   '\u'$CODEPOINT_OF_AWESOME_TAG' '               # 
      VCS_BOOKMARK_ICON              '\u'$CODEPOINT_OF_OCTICONS_BOOKMARK            # 
      VCS_COMMIT_ICON                '\u'$CODEPOINT_OF_OCTICONS_GIT_COMMIT' '       # 
      VCS_BRANCH_ICON                '\u'$CODEPOINT_OF_OCTICONS_GIT_BRANCH' '       # 
      VCS_REMOTE_BRANCH_ICON         '\u'$CODEPOINT_OF_OCTICONS_REPO_PUSH           # 
      VCS_GIT_ICON                   '\u'$CODEPOINT_OF_AWESOME_GIT' '               # 
      VCS_GIT_GITHUB_ICON            '\u'$CODEPOINT_OF_AWESOME_GITHUB_ALT' '        # 
      VCS_GIT_BITBUCKET_ICON         '\u'$CODEPOINT_OF_AWESOME_BITBUCKET' '         # 
      VCS_GIT_GITLAB_ICON            '\u'$CODEPOINT_OF_AWESOME_GITLAB' '            # 
      VCS_HG_ICON                    '\u'$CODEPOINT_OF_AWESOME_FLASK' '             # 
      VCS_SVN_ICON                   '(svn) '
      RUST_ICON                      $'\uE6A8'                                      # 
      PYTHON_ICON                    $'\U1F40D'                                     # 🐍
      SWIFT_ICON                     $'\uE655'                                      # 
      PUBLIC_IP_ICON                 '\u'$CODEPOINT_OF_AWESOME_GLOBE                # 
      LOCK_ICON                      '\u'$CODEPOINT_OF_AWESOME_LOCK                 # 
      EXECUTION_TIME_ICON            '\u'$CODEPOINT_OF_AWESOME_HOURGLASS_END        # 
      SSH_ICON                       '(ssh)'
  )
}
_powerlevel9k_setup_awesome_fontconfig_icons

typeset -gAH icons_adobeSourceCodePro_fontconfig
function _powerlevel9k_setup_adobeSourceCodePro_fontconfig_icons() {
    # Set the right locale to protect special characters
    local LC_ALL="" LC_CTYPE="en_US.UTF-8"
    icons_adobeSourceCodePro_fontconfig=(
      LEFT_SEGMENT_SEPARATOR         $'\uE0B0'              # 
      RIGHT_SEGMENT_SEPARATOR        $'\uE0B2'              # 
      LEFT_SEGMENT_END_SEPARATOR     ' '                    # Whitespace
      LEFT_SUBSEGMENT_SEPARATOR      $'\uE0B1'              # 
      RIGHT_SUBSEGMENT_SEPARATOR     $'\uE0B3'              # 
      CARRIAGE_RETURN_ICON           $'\u21B5'              # ↵
      ROOT_ICON                      $'\uF201'              # 
      RUBY_ICON                      $'\uF219 '             # 
      AWS_ICON                       $'\uF270'              # 
      AWS_EB_ICON                    $'\U1F331 '            # 🌱
      BACKGROUND_JOBS_ICON           $'\uF013 '             # 
      TEST_ICON                      $'\uF291'              # 
      TODO_ICON                      $'\u2611'              # ☑
      BATTERY_ICON                   $'\U1F50B'             # 🔋
      DISK_ICON                      $'\uF0A0 '             # 
      OK_ICON                        $'\u2713'              # ✓
      FAIL_ICON                      $'\u2718'              # ✘
      SYMFONY_ICON                   'SF'
      NODE_ICON                      $'\u2B22'              # ⬢
      MULTILINE_FIRST_PROMPT_PREFIX  $'\u256D'$'\U2500'     # ╭─
      MULTILINE_SECOND_PROMPT_PREFIX $'\u2570'$'\U2500 '    # ╰─
      APPLE_ICON                     $'\uF179'              # 
      FREEBSD_ICON                   $'\U1F608 '            # 😈
      LINUX_ICON                     $'\uF17C'              # 
      SUNOS_ICON                     $'\uF185 '             # 
      HOME_ICON                      $'\uF015'              # 
      HOME_SUB_ICON                  $'\uF07C'              # 
      FOLDER_ICON                    $'\uF115'              # 
      NETWORK_ICON                   $'\uF09E'              # 
      LOAD_ICON                      $'\uF080 '             # 
      SWAP_ICON                      $'\uF0E4'              # 
      RAM_ICON                       $'\uF0E4'              # 
      SERVER_ICON                    $'\uF233'              # 
      VCS_UNTRACKED_ICON             $'\uF059'              # 
      VCS_UNSTAGED_ICON              $'\uF06A'              # 
      VCS_STAGED_ICON                $'\uF055'              # 
      VCS_STASH_ICON                 $'\uF01C '             # 
      VCS_INCOMING_CHANGES_ICON      $'\uF01A '             # 
      VCS_OUTGOING_CHANGES_ICON      $'\uF01B '             # 
      VCS_TAG_ICON                   $'\uF217 '             # 
      VCS_BOOKMARK_ICON              $'\uF27B'              # 
      VCS_COMMIT_ICON                $'\uF221 '             # 
      VCS_BRANCH_ICON                $'\uF126'              # 
      VCS_REMOTE_BRANCH_ICON         $'\u2192'              # →
      VCS_GIT_ICON                   $'\uF1D3 '             # 
      VCS_GIT_GITHUB_ICON            $'\uF113 '             # 
      VCS_GIT_BITBUCKET_ICON         $'\uF171 '             # 
      VCS_GIT_GITLAB_ICON            $'\uF296 '             # 
      VCS_HG_ICON                    $'\uF0C3 '             # 
      VCS_SVN_ICON                   '(svn) '
      RUST_ICON                      $'\uE6A8'              # 
      PYTHON_ICON                    $'\U1F40D'             # 🐍
      SWIFT_ICON                     ''
      PUBLIC_IP_ICON                 ''
      LOCK_ICON                      $'\UE138'              # 
      EXECUTION_TIME_ICON            $'\uF253'
      SSH_ICON                       '(ssh)'
  }
}
_powerlevel9k_setup_adobeSourceCodePro_fontconfig_icons

typeset -gAH icons_nerdfont_complete
function _powerlevel9k_setup_nerdfont_complete_icons() {
  # Set the right locale to protect special characters
  local LC_ALL="" LC_CTYPE="en_US.UTF-8"

  # nerd-font patched (complete) font required! See
  # https://github.com/ryanoasis/nerd-fonts
  icons_nerdfont_complete=(
      LEFT_SEGMENT_SEPARATOR         $'\uE0B0'              # 
      RIGHT_SEGMENT_SEPARATOR        $'\uE0B2'              # 
      LEFT_SEGMENT_END_SEPARATOR     ' '                    # Whitespace
      LEFT_SUBSEGMENT_SEPARATOR      $'\uE0B1'              # 
      RIGHT_SUBSEGMENT_SEPARATOR     $'\uE0B3'              # 
      CARRIAGE_RETURN_ICON           $'\u21B5'              # ↵
      ROOT_ICON                      $'\uE614 '             # 
      RUBY_ICON                      $'\uF219 '             # 
      AWS_ICON                       $'\uF270'              # 
      AWS_EB_ICON                    $'\UF1BD  '            # 
      BACKGROUND_JOBS_ICON           $'\uF013 '             # 
      TEST_ICON                      $'\uF188'              # 
      TODO_ICON                      $'\uF133'              # 
      BATTERY_ICON                   $'\UF240 '             # 
      DISK_ICON                      $'\uF0A0'              # 
      OK_ICON                        $'\uF00C'              # 
      FAIL_ICON                      $'\uF00D'              # 
      SYMFONY_ICON                   $'\uE757'              # 
      NODE_ICON                      $'\uE617 '             # 
      MULTILINE_FIRST_PROMPT_PREFIX  $'\u256D'$'\U2500'     # ╭─
      MULTILINE_SECOND_PROMPT_PREFIX $'\u2570'$'\U2500 '    # ╰─
      ANDROID_ICON                   $'\uF17B'              # 
      APPLE_ICON                     $'\uF179'              # 
      FREEBSD_ICON                   $'\UF30E '             # 
      LINUX_ICON                     $'\uF17C'              # 
      SUNOS_ICON                     $'\uF185 '             # 
      HOME_ICON                      $'\uF015'              # 
      HOME_SUB_ICON                  $'\uF07C'              # 
      FOLDER_ICON                    $'\uF115'              # 
      NETWORK_ICON                   $'\uF1EB'              # 
      LOAD_ICON                      $'\uF080 '             # 
      SWAP_ICON                      $'\uF464'              # 
      RAM_ICON                       $'\uF0E4'              # 
      SERVER_ICON                    $'\uF0AE'              # 
      VCS_UNTRACKED_ICON             $'\uF059'              # 
      VCS_UNSTAGED_ICON              $'\uF06A'              # 
      VCS_STAGED_ICON                $'\uF055'              # 
      VCS_STASH_ICON                 $'\uF01C '             # 
      VCS_INCOMING_CHANGES_ICON      $'\uF01A '             # 
      VCS_OUTGOING_CHANGES_ICON      $'\uF01B '             # 
      VCS_TAG_ICON                   $'\uF02B '             # 
      VCS_BOOKMARK_ICON              $'\uF461 '             # 
      VCS_COMMIT_ICON                $'\uE729 '             # 
      VCS_BRANCH_ICON                $'\uF126 '             # 
      VCS_REMOTE_BRANCH_ICON         $'\uE728 '             # 
      VCS_GIT_ICON                   $'\uF113 '             # 
      VCS_GIT_GITHUB_ICON            $'\uE709 '             # 
      VCS_GIT_BITBUCKET_ICON         $'\uE703 '             # 
      VCS_GIT_GITLAB_ICON            $'\uF296 '             # 
      VCS_HG_ICON                    $'\uF0C3 '             # 
      VCS_SVN_ICON                   $'\uE72D '             # 
      RUST_ICON                      $'\uE7A8 '             # 
      PYTHON_ICON                    $'\UE73C '             # 
      SWIFT_ICON                     $'\uE755'              # 
      PUBLIC_IP_ICON                 $'\UF0AC'              # 
      LOCK_ICON                      $'\UF023'              # 
      EXECUTION_TIME_ICON            $'\uF252'              # 
      SSH_ICON                       $'\uF489'              # 
  )
}
_powerlevel9k_setup_nerdfont_complete_icons

# kept for backward compatibility
icons_nerdfont_fontconfig=icons_nerdfont_complete

typeset -gAH icons_flat
function prepareFlatIcons() {
  # Set the right locale to protect special characters
  local LC_ALL="" LC_CTYPE="en_US.UTF-8"

  icons_flat=("${(kv)icons_awesome_patched[@]}")
  icons_flat[LEFT_SEGMENT_SEPARATOR]=''
  icons_flat[RIGHT_SEGMENT_SEPARATOR]=''
  icons_flat[LEFT_SUBSEGMENT_SEPARATOR]='|'
  icons_flat[RIGHT_SUBSEGMENT_SEPARATOR]='|'
}
prepareFlatIcons

typeset -gAH icons_default
function _powerlevel9k_setup_default_icons() {
  # Powerline-Patched Font required!
  # See https://github.com/Lokaltog/powerline-fonts
  # Set the right locale to protect special characters
  local LC_ALL="" LC_CTYPE="en_US.UTF-8"

  icons_default=(
      LEFT_SEGMENT_SEPARATOR         $'\uE0B0'              # 
      RIGHT_SEGMENT_SEPARATOR        $'\uE0B2'              # 
      LEFT_SEGMENT_END_SEPARATOR     ' '                    # Whitespace
      LEFT_SUBSEGMENT_SEPARATOR      $'\uE0B1'              # 
      RIGHT_SUBSEGMENT_SEPARATOR     $'\uE0B3'              # 
      CARRIAGE_RETURN_ICON           $'\u21B5'              # ↵
      ROOT_ICON                      $'\u26A1'              # ⚡
      RUBY_ICON                      ''
      AWS_ICON                       'AWS:'
      AWS_EB_ICON                    $'\U1F331 '            # 🌱
      BACKGROUND_JOBS_ICON           $'\u2699'              # ⚙
      TEST_ICON                      ''
      TODO_ICON                      $'\u2611'              # ☑
      BATTERY_ICON                   $'\U1F50B'             # 🔋
      DISK_ICON                      $'hdd '
      OK_ICON                        $'\u2713'              # ✓
      FAIL_ICON                      $'\u2718'              # ✘
      SYMFONY_ICON                   'SF'
      NODE_ICON                      $'\u2B22'              # ⬢
      MULTILINE_FIRST_PROMPT_PREFIX  $'\u256D'$'\u2500'
      MULTILINE_SECOND_PROMPT_PREFIX $'\u2570'$'\u2500 '
      ANDROID_ICON                   'And'
      APPLE_ICON                     'OSX'
      FREEBSD_ICON                   'BSD'
      LINUX_ICON                     'Lx'
      SUNOS_ICON                     'Sun'
      HOME_ICON                      ''
      HOME_SUB_ICON                  ''
      FOLDER_ICON                    ''
      NETWORK_ICON                   'IP'
      LOAD_ICON                      'L'
      SWAP_ICON                      'SWP'
      RAM_ICON                       'RAM'
      SERVER_ICON                    ''
      VCS_UNTRACKED_ICON             '?'
      VCS_UNSTAGED_ICON              $'\u25CF'              # ●
      VCS_STAGED_ICON                $'\u271A'              # ✚
      VCS_STASH_ICON                 $'\u235F'              # ⍟
      VCS_INCOMING_CHANGES_ICON      $'\u2193'              # ↓
      VCS_OUTGOING_CHANGES_ICON      $'\u2191'              # ↑
      VCS_TAG_ICON                   ''
      VCS_BOOKMARK_ICON              $'\u263F'              # ☿
      VCS_COMMIT_ICON                ''
      VCS_BRANCH_ICON                $'\uE0A0'              # 
      VCS_REMOTE_BRANCH_ICON         $'\u2192'              # →
      VCS_GIT_ICON                   ''
      VCS_GIT_GITHUB_ICON            ''
      VCS_GIT_BITBUCKET_ICON         ''
      VCS_GIT_GITLAB_ICON            ''
      VCS_HG_ICON                    ''
      VCS_SVN_ICON                   ''
      RUST_ICON                      ''
      PYTHON_ICON                    ''
      SWIFT_ICON                     'Swift'
      PUBLIC_IP_ICON                 ''
      LOCK_ICON                      $'\UE0A2'
      EXECUTION_TIME_ICON            'Dur'
      SSH_ICON                       '(ssh)'
  )
}
_powerlevel9k_setup_default_icons

typeset -gAH icons_compatible
function prepareCompatibleIcons() {
  # Set the right locale to protect special characters
  local LC_ALL="" LC_CTYPE="en_US.UTF-8"

  icons_compatible=("${(kv)icons_default[@]}")
  icons_compatible[LEFT_SEGMENT_SEPARATOR]=$'\u2B80'                 # ⮀
  icons_compatible[RIGHT_SEGMENT_SEPARATOR]=$'\u2B82'                # ⮂
  icons_compatible[VCS_BRANCH_ICON]=$'\U2387'                        # ⎇
}
prepareCompatibleIcons

# Gets called in powerlevel9k.zsh-theme
function _powerlevel9kInitializeIconOverrides() {
  if [[ "${POWERLEVEL9K_HIDE_BRANCH_ICON}" == "true" ]]; then
    icons_default[VCS_BRANCH_ICON]=''
    icons_awesome_fontconfig[VCS_BRANCH_ICON]=''
    icons_awesome_patched[VCS_BRANCH_ICON]=''
    icons_adobeSourceCodePro_fontconfig[VCS_BRANCH_ICON]=''
    icons_nerdfont_fontconfig[VCS_BRANCH_ICON]=''
    icons_flat[VCS_BRANCH_ICON]=''
    icons_compatible[VCS_BRANCH_ICON]=''
  fi
}

function _p9k_get_current_icon_array_name() {
  defined POWERLEVEL9K_MODE || POWERLEVEL9K_MODE="default"
  # Replace hyphens with underscores
  echo "icons_${POWERLEVEL9K_MODE:gs/-/_/}"
}

# Safety function for printing icons
# Prints the named icon, or if that icon is undefined, the string name.
function print_icon() {
  local icon_name=$1
  local ICON_USER_VARIABLE=POWERLEVEL9K_${icon_name}
  if defined "${ICON_USER_VARIABLE}"; then
    echo -n "${(P)ICON_USER_VARIABLE}"
  else
    local icon_variable="$(_p9k_get_current_icon_array_name)[$icon_name]"
    echo -n "${(P)icon_variable}"
  fi
}

# Get a list of configured icons
#   * $1 string - If "original", then the original icons are printed,
#                 otherwise "print_icon" is used, which takes the users
#                 overrides into account.
function get_icon_names() {
  local icon_array_name=$(_p9k_get_current_icon_array_name)
  typeset -Ah icon_array
  icon_array=${(@Pkv)icon_array_name}

  # Iterate over a ordered list of keys of the icons array
  for key in ${(@kon)icon_array}; do
    echo -n "POWERLEVEL9K_$key: "
    if [[ "${1}" == "original" ]]; then
      # print the original icons as they are defined in the array above
      echo "${icon_array[$key]}"
    else
      # print the icons as they are configured by the user
      echo "$(print_icon "$key")"
    fi
  done
}

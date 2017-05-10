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

# Initialize the icon list according to the user's `POWERLEVEL9K_MODE`.
typeset -gAH icons
case $POWERLEVEL9K_MODE in
  'flat'|'awesome-patched')
    # Awesome-Patched Font required! See:
    # https://github.com/gabrielelana/awesome-terminal-fonts/tree/patching-strategy/patched
    # Set the right locale to protect special characters
    local LC_ALL="" LC_CTYPE="en_US.UTF-8"
    icons=(
      LEFT_SEGMENT_SEPARATOR         $'\uE0B0'              # 
      RIGHT_SEGMENT_SEPARATOR        $'\uE0B2'              # 
      LEFT_SEGMENT_END_SEPARATOR     ' '                    # Whitespace
      LEFT_SUBSEGMENT_SEPARATOR      $'\uE0B1'              # 
      RIGHT_SUBSEGMENT_SEPARATOR     $'\uE0B3'              # 
      #VCS_INCOMING_CHANGES_ICON     $'\uE1EB '             # 
      #VCS_INCOMING_CHANGES_ICON     $'\uE80D '             # 
      #VCS_OUTGOING_CHANGES_ICON     $'\uE1EC '             # 
      #VCS_OUTGOING_CHANGES_ICON     $'\uE80E '             # 
      APPLE_ICON                     $'\uE26E'              # 
      AWS_EB_ICON                    $'\U1F331 '            # 🌱
      AWS_ICON                       $'\uE895'              # 
      BACKGROUND_JOBS_ICON           $'\uE82F '             # 
      BATTERY_ICON                   $'\uE894'              # 
      CARRIAGE_RETURN_ICON           $'\u21B5'              # ↵
      DATE_ICON                      $'\uE184'              # 
      DISK_ICON                      $'\uE1AE '             # 
      EXECUTION_TIME_ICON            $'\UE89C'              # 
      FAIL_ICON                      $'\u2718'              # ✘
      FOLDER_ICON                    $'\uE818'              # 
      FREEBSD_ICON                   $'\U1F608 '            # 😈
      HOME_ICON                      $'\uE12C'              # 
      HOME_SUB_ICON                  $'\uE18D'              # 
      LINUX_ICON                     $'\uE271'              # 
      LOAD_ICON                      $'\uE190 '             # 
      LOCK_ICON                      $'\UE138'              # 
      MULTILINE_FIRST_PROMPT_PREFIX  $'\u256D'$'\U2500'
      MULTILINE_SECOND_PROMPT_PREFIX $'\u2570'$'\U2500 '
      NETWORK_ICON                   $'\uE1AD'              # 
      NODE_ICON                      $'\u2B22'              # ⬢
      OK_ICON                        $'\u2713'              # ✓
      PUBLIC_IP_ICON                 ''
      PYTHON_ICON                    $'\U1F40D'             # 🐍
      RAM_ICON                       $'\uE1E2 '             # 
      ROOT_ICON                      $'\uE801'              # 
      RUBY_ICON                      $'\uE847 '             # 
      RUST_ICON                      ''
      SERVER_ICON                    $'\uE895'              # 
      SSH_ICON                       '(ssh)'
      SUNOS_ICON                     $'\U1F31E '            # 🌞
      SWAP_ICON                      $'\uE87D'              # 
      SWIFT_ICON                     ''
      SYMFONY_ICON                   'SF'
      TEST_ICON                      $'\uE891'              # 
      TIME_ICON                      $'\uE12E'              # 
      TODO_ICON                      $'\u2611'              # ☑
      VCS_BOOKMARK_ICON              $'\uE87B'              # 
      VCS_BRANCH_ICON                $'\uE220'              # 
      VCS_COMMIT_ICON                $'\uE821 '             # 
      VCS_GIT_BITBUCKET_ICON         $'\uE20E '             #
      VCS_GIT_GITHUB_ICON            $'\uE20E '             #
      VCS_GIT_GITLAB_ICON            $'\uE20E '             #
      VCS_GIT_ICON                   $'\uE20E '             # 
      VCS_HG_ICON                    $'\uE1C3 '             # 
      VCS_INCOMING_CHANGES_ICON      $'\uE131 '             # 
      VCS_OUTGOING_CHANGES_ICON      $'\uE132 '             # 
      VCS_REMOTE_BRANCH_ICON         $'\u2192'              # →
      VCS_STAGED_ICON                $'\uE168'              # 
      VCS_STASH_ICON                 $'\uE133 '             # 
      VCS_SVN_ICON                   '(svn) '
      VCS_TAG_ICON                   $'\uE817 '             # 
      VCS_UNSTAGED_ICON              $'\uE17C'              # 
      VCS_UNTRACKED_ICON             $'\uE16C'              # 
    )
  ;;
  'awesome-fontconfig')
    # fontconfig with awesome-font required! See
    # https://github.com/gabrielelana/awesome-terminal-fonts
    # Set the right locale to protect special characters
    local LC_ALL="" LC_CTYPE="en_US.UTF-8"
    icons=(
      LEFT_SEGMENT_SEPARATOR         $'\uE0B0'              # 
      RIGHT_SEGMENT_SEPARATOR        $'\uE0B2'              # 
      LEFT_SEGMENT_END_SEPARATOR     ' '                    # Whitespace
      LEFT_SUBSEGMENT_SEPARATOR      $'\uE0B1'              # 
      RIGHT_SUBSEGMENT_SEPARATOR     $'\uE0B3'              # 
      APPLE_ICON                     $'\uF179'              # 
      AWS_EB_ICON                    $'\U1F331 '            # 🌱
      AWS_ICON                       $'\uF270'              # 
      BACKGROUND_JOBS_ICON           $'\uF013 '             # 
      BATTERY_ICON                   $'\U1F50B'             # 🔋
      CARRIAGE_RETURN_ICON           $'\u21B5'              # ↵
      DATE_ICON                      $'\uF073 '             # 
      DISK_ICON                      $'\uF0A0 '             # 
      EXECUTION_TIME_ICON            $'\uF253'
      FAIL_ICON                      $'\u2718'              # ✘
      FOLDER_ICON                    $'\uF115'              # 
      FREEBSD_ICON                   $'\U1F608 '            # 😈
      HOME_ICON                      $'\uF015'              # 
      HOME_SUB_ICON                  $'\uF07C'              # 
      LINUX_ICON                     $'\uF17C'              # 
      LOAD_ICON                      $'\uF080 '             # 
      LOCK_ICON                      $'\UE138'              # 
      MULTILINE_FIRST_PROMPT_PREFIX  $'\u256D'$'\U2500'     # ╭─
      MULTILINE_SECOND_PROMPT_PREFIX $'\u2570'$'\U2500 '    # ╰─
      NETWORK_ICON                   $'\uF09E'              # 
      NODE_ICON                      $'\u2B22'              # ⬢
      OK_ICON                        $'\u2713'              # ✓
      PUBLIC_IP_ICON                 ''
      PYTHON_ICON                    $'\U1F40D'             # 🐍
      RAM_ICON                       $'\uF0E4'              # 
      ROOT_ICON                      $'\uF201'              # 
      RUBY_ICON                      $'\uF219 '             # 
      RUST_ICON                      $'\uE6A8'              #  
      SERVER_ICON                    $'\uF233'              # 
      SSH_ICON                       '(ssh)'
      SUNOS_ICON                     $'\uF185 '             # 
      SWAP_ICON                      $'\uF0E4'              # 
      SWIFT_ICON                     ''
      SYMFONY_ICON                   'SF'
      TEST_ICON                      $'\uF291'              # 
      TIME_ICON                      $'\uF017 '             # 
      TODO_ICON                      $'\u2611'              # ☑
      VCS_BOOKMARK_ICON              $'\uF27B'              # 
      VCS_BRANCH_ICON                $'\uF126'              # 
      VCS_COMMIT_ICON                $'\uF221 '             # 
      VCS_GIT_BITBUCKET_ICON         $'\uF171 '             # 
      VCS_GIT_GITHUB_ICON            $'\uF113 '             # 
      VCS_GIT_GITLAB_ICON            $'\uF296 '             # 
      VCS_GIT_ICON                   $'\uF1D3 '             # 
      VCS_HG_ICON                    $'\uF0C3 '             # 
      VCS_INCOMING_CHANGES_ICON      $'\uF01A '             # 
      VCS_OUTGOING_CHANGES_ICON      $'\uF01B '             # 
      VCS_REMOTE_BRANCH_ICON         $'\u2192'              # →
      VCS_STAGED_ICON                $'\uF055'              # 
      VCS_STASH_ICON                 $'\uF01C '             # 
      VCS_SVN_ICON                   '(svn) '
      VCS_TAG_ICON                   $'\uF217 '             # 
      VCS_UNSTAGED_ICON              $'\uF06A'              # 
      VCS_UNTRACKED_ICON             $'\uF059'              # 
    )
  ;;
  'nerdfont-complete'|'nerdfont-fontconfig')
    # nerd-font patched (complete) font required! See
    # https://github.com/ryanoasis/nerd-fonts
    # Set the right locale to protect special characters
    local LC_ALL="" LC_CTYPE="en_US.UTF-8"
    icons=(
      LEFT_SEGMENT_SEPARATOR         $'\uE0B0'              # 
      RIGHT_SEGMENT_SEPARATOR        $'\uE0B2'              # 
      LEFT_SEGMENT_END_SEPARATOR     ' '                    # Whitespace
      LEFT_SUBSEGMENT_SEPARATOR      $'\uE0B1'              # 
      RIGHT_SUBSEGMENT_SEPARATOR     $'\uE0B3'              # 
      APPLE_ICON                     $'\uF179'              # 
      AWS_EB_ICON                    $'\UF1BD  '            # 
      AWS_ICON                       $'\uF270'              # 
      BACKGROUND_JOBS_ICON           $'\uF013 '             # 
      BATTERY_ICON                   $'\UF240 '             # 
      CARRIAGE_RETURN_ICON           $'\u21B5'              # ↵
      DATE_ICON                      $'\uF073 '             # 
      DISK_ICON                      $'\uF0A0'              #  
      EXECUTION_TIME_ICON            $'\uF252'              #  
      FAIL_ICON                      $'\uF00D'              # 
      FOLDER_ICON                    $'\uF115'              # 
      FREEBSD_ICON                   $'\UF30E '             # 
      HOME_ICON                      $'\uF015'              # 
      HOME_SUB_ICON                  $'\uF07C'              # 
      LINUX_ICON                     $'\uF17C'              # 
      LOAD_ICON                      $'\uF080 '             # 
      LOCK_ICON                      $'\UF023'              #  
      MULTILINE_FIRST_PROMPT_PREFIX  $'\u256D'$'\U2500'     # ╭─
      MULTILINE_SECOND_PROMPT_PREFIX $'\u2570'$'\U2500 '    # ╰─
      NETWORK_ICON                   $'\uF1EB'              # 
      NODE_ICON                      $'\uE617 '             # 
      OK_ICON                        $'\uF00C'              # 
      PUBLIC_IP_ICON                 $'\UF0AC'              # 
      PYTHON_ICON                    $'\UE73C '             # 
      RAM_ICON                       $'\uF0E4'              # 
      ROOT_ICON                      $'\uE614 '             # 
      RUBY_ICON                      $'\uF219 '             # 
      RUST_ICON                      $'\uE7A8 '             # 
      SERVER_ICON                    $'\uF0AE'              # 
      SSH_ICON                       $'\uF489'              #  
      SUNOS_ICON                     $'\uF185 '             # 
      SWAP_ICON                      $'\uF464'              # 
      SWIFT_ICON                     $'\uE755'              # 
      SYMFONY_ICON                   $'\uE757'              # 
      TEST_ICON                      $'\uF188'              # 
      TIME_ICON                      $'\uF017 '             # 
      TODO_ICON                      $'\uF133'              # 
      VCS_BOOKMARK_ICON              $'\uF461 '             # 
      VCS_BRANCH_ICON                $'\uF126 '             # 
      VCS_COMMIT_ICON                $'\uE729 '             # 
      VCS_GIT_BITBUCKET_ICON         $'\uE703 '             # 
      VCS_GIT_GITHUB_ICON            $'\uE709 '             # 
      VCS_GIT_GITLAB_ICON            $'\uF296 '             #  
      VCS_GIT_ICON                   $'\uF113 '             # 
      VCS_HG_ICON                    $'\uF0C3 '             # 
      VCS_INCOMING_CHANGES_ICON      $'\uF01A '             # 
      VCS_OUTGOING_CHANGES_ICON      $'\uF01B '             # 
      VCS_REMOTE_BRANCH_ICON         $'\uE728 '             # 
      VCS_STAGED_ICON                $'\uF055'              # 
      VCS_STASH_ICON                 $'\uF01C '             # 
      VCS_SVN_ICON                   $'\uE72D '             # 
      VCS_TAG_ICON                   $'\uF02B '             # 
      VCS_UNSTAGED_ICON              $'\uF06A'              # 
      VCS_UNTRACKED_ICON             $'\uF059'              # 
    )
  ;;
  *)
    # Powerline-Patched Font required!
    # See https://github.com/Lokaltog/powerline-fonts
    # Set the right locale to protect special characters
    local LC_ALL="" LC_CTYPE="en_US.UTF-8"
    icons=(
      LEFT_SEGMENT_SEPARATOR         $'\uE0B0'              # 
      RIGHT_SEGMENT_SEPARATOR        $'\uE0B2'              # 
      LEFT_SEGMENT_END_SEPARATOR     ' '                    # Whitespace
      LEFT_SUBSEGMENT_SEPARATOR      $'\uE0B1'              # 
      RIGHT_SUBSEGMENT_SEPARATOR     $'\uE0B3'              # 
      APPLE_ICON                     'OSX'
      AWS_EB_ICON                    $'\U1F331 '            # 🌱
      AWS_ICON                       'AWS:'
      BACKGROUND_JOBS_ICON           $'\u2699'              # ⚙
      BATTERY_ICON                   $'\U1F50B'             # 🔋
      CARRIAGE_RETURN_ICON           $'\u21B5'              # ↵
      DATE_ICON                      $''                    #
      DISK_ICON                      $'hdd '
      EXECUTION_TIME_ICON            'Dur'
      FAIL_ICON                      $'\u2718'              # ✘
      FOLDER_ICON                    ''
      FREEBSD_ICON                   'BSD'
      HOME_ICON                      ''
      HOME_SUB_ICON                  ''
      LINUX_ICON                     'Lx'
      LOAD_ICON                      'L'
      LOCK_ICON                      $'\UE0A2'
      MULTILINE_FIRST_PROMPT_PREFIX  $'\u256D'$'\u2500'
      MULTILINE_SECOND_PROMPT_PREFIX $'\u2570'$'\u2500 '
      NETWORK_ICON                   'IP'
      NODE_ICON                      $'\u2B22'              # ⬢
      OK_ICON                        $'\u2713'              # ✓
      PUBLIC_IP_ICON                 ''
      PYTHON_ICON                    ''
      RAM_ICON                       'RAM'
      ROOT_ICON                      $'\u26A1'              # ⚡
      RUBY_ICON                      ''
      RUST_ICON                      ''
      SERVER_ICON                    ''
      SSH_ICON                       '(ssh)'
      SUNOS_ICON                     'Sun'
      SWAP_ICON                      'SWP'
      SWIFT_ICON                     'Swift'
      SYMFONY_ICON                   'SF'
      TEST_ICON                      ''
      TIME_ICON                      $''                    #
      TODO_ICON                      $'\u2611'              # ☑
      VCS_BOOKMARK_ICON              $'\u263F'              # ☿
      VCS_BRANCH_ICON                $'\uE0A0'              # 
      VCS_COMMIT_ICON                ''
      VCS_GIT_BITBUCKET_ICON         ''
      VCS_GIT_GITHUB_ICON            ''
      VCS_GIT_GITLAB_ICON            ''
      VCS_GIT_ICON                   ''
      VCS_HG_ICON                    ''
      VCS_INCOMING_CHANGES_ICON      $'\u2193'              # ↓
      VCS_OUTGOING_CHANGES_ICON      $'\u2191'              # ↑
      VCS_REMOTE_BRANCH_ICON         $'\u2192'              # →
      VCS_STAGED_ICON                $'\u271A'              # ✚
      VCS_STASH_ICON                 $'\u235F'              # ⍟
      VCS_SVN_ICON                   ''
      VCS_TAG_ICON                   ''
      VCS_UNSTAGED_ICON              $'\u25CF'              # ●
      VCS_UNTRACKED_ICON             '?'
    )
  ;;
esac

# Override the above icon settings with any user-defined variables.
case $POWERLEVEL9K_MODE in
  'flat')
    # Set the right locale to protect special characters
    local LC_ALL="" LC_CTYPE="en_US.UTF-8"
    icons[LEFT_SEGMENT_SEPARATOR]=''
    icons[RIGHT_SEGMENT_SEPARATOR]=''
    icons[LEFT_SUBSEGMENT_SEPARATOR]='|'
    icons[RIGHT_SUBSEGMENT_SEPARATOR]='|'
  ;;
  'compatible')
    # Set the right locale to protect special characters
    local LC_ALL="" LC_CTYPE="en_US.UTF-8"
    icons[LEFT_SEGMENT_SEPARATOR]=$'\u2B80'                 # ⮀
    icons[RIGHT_SEGMENT_SEPARATOR]=$'\u2B82'                # ⮂
    icons[VCS_BRANCH_ICON]='@'
  ;;
esac

if [[ "$POWERLEVEL9K_HIDE_BRANCH_ICON" == true ]]; then
    icons[VCS_BRANCH_ICON]=''
fi

# Safety function for printing icons
# Prints the named icon, or if that icon is undefined, the string name.
function print_icon() {
  local icon_name=$1
  local ICON_USER_VARIABLE=POWERLEVEL9K_${icon_name}
  if defined "$ICON_USER_VARIABLE"; then
    echo -n "${(P)ICON_USER_VARIABLE}"
  else
    echo -n "${icons[$icon_name]}"
  fi
}

# Get a list of configured icons
#   * $1 string - If "original", then the original icons are printed,
#                 otherwise "print_icon" is used, which takes the users
#                 overrides into account.
get_icon_names() {
  # Iterate over a ordered list of keys of the icons array
  for key in ${(@kon)icons}; do
    echo -n "POWERLEVEL9K_$key: "
    if [[ "${1}" == "original" ]]; then
      # print the original icons as they are defined in the array above
      echo "${icons[$key]}"
    else
      # print the icons as they are configured by the user
      echo "$(print_icon "$key")"
    fi
  done
}

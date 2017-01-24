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
      VCS_BRANCH_ICON                $'\uE220 '             # 
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
    )
  ;;
  'awesome-fontconfig')
    # fontconfig with awesome-font required! See
    # https://github.com/gabrielelana/awesome-terminal-fonts
    source ~/.fonts/fontawesome-regular.sh
    # source ~/.fonts/devicons-regular.sh # no named codepoints
    source ~/.fonts/octicons-regular.sh

    icons=(
      LEFT_SEGMENT_SEPARATOR         $'\uE0B0'                                      #        
      RIGHT_SEGMENT_SEPARATOR        $'\uE0B2'                                      # 
      LEFT_SEGMENT_END_SEPARATOR     ' '                                            # Whitespace
      LEFT_SUBSEGMENT_SEPARATOR      $'\uE0B1'                                      # 
      RIGHT_SUBSEGMENT_SEPARATOR     $'\uE0B3'                                      # 
      CARRIAGE_RETURN_ICON           $'\u21B5'                                      # ↵
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
    )
  ;;
  *)
    # Powerline-Patched Font required!
    # See https://github.com/Lokaltog/powerline-fonts
    icons=(
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
      VCS_BRANCH_ICON                $'\uE0A0 '             # 
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
    )
  ;;
esac

# Override the above icon settings with any user-defined variables.
case $POWERLEVEL9K_MODE in
  'flat')
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

get_icon_names() {
  for key in ${(@k)icons}; do
    echo "POWERLEVEL9K_$key: ${icons[$key]}"
  done
}

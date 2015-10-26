# vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8
################################################################
# powerlevel9k Theme
# https://github.com/bhilburn/powerlevel9k
#
# This theme was inspired by agnoster's Theme:
# https://gist.github.com/3712874
################################################################

################################################################
# Please see the README file located in the source repository for full docs.
# There are a lot of easy ways you can customize your prompt segments and
# theming with simple variables defined in your `~/.zshrc`.
################################################################

## Turn on for Debugging
#zstyle ':vcs_info:*+*:*' debug true
#set -o xtrace

################################################################
# Icons
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
      LEFT_SEGMENT_SEPARATOR         $'\UE0B0'              # 
      RIGHT_SEGMENT_SEPARATOR        $'\UE0B2'              # 
      LEFT_SUBSEGMENT_SEPARATOR      $'\UE0B1'              # 
      RIGHT_SUBSEGMENT_SEPARATOR     $'\UE0B3'              # 
      CARRIAGE_RETURN_ICON           $'\U21B5'              # ↵
      ROOT_ICON                      $'\UE801'              # 
      RUBY_ICON                      ' '$'\UE847 '          # 
      AWS_ICON                       $'\UE895'              # 
      BACKGROUND_JOBS_ICON           $'\UE82F '             # 
      TEST_ICON                      $'\UE891'              # 
      TODO_ICON                      $'\U2611'              # ☑
      BATTERY_ICON                   $'\UE894'              # 
      OK_ICON                        $'\U2713'              # ✓
      FAIL_ICON                      $'\U2718'              # ✘
      SYMFONY_ICON                   'SF'
      NODE_ICON                      $'\U2B22'              # ⬢
      MULTILINE_FIRST_PROMPT_PREFIX  $'\U256D'$'\U2500'
      MULTILINE_SECOND_PROMPT_PREFIX $'\U2570'$'\U2500 '
      APPLE_ICON                     $'\UE26E'              # 
      FREEBSD_ICON                   $'\U1F608 '            # 😈
      LINUX_ICON                     $'\UE271'              # 
      SUNOS_ICON                     $'\U1F31E '            # 🌞
      HOME_ICON                      $'\UE12C '             # 
      NETWORK_ICON                   $'\UE1AD '             # 
      LOAD_ICON                      $'\UE190 '             # 
      #RAM_ICON                       $'\UE87D'             # 
      RAM_ICON                       $'\UE1E2 '             # 
      VCS_UNTRACKED_ICON             $'\UE16C'              # 
      VCS_UNSTAGED_ICON              $'\UE17C'              # 
      VCS_STAGED_ICON                $'\UE168'              # 
      VCS_STASH_ICON                 $'\UE133 '             # 
      #VCS_INCOMING_CHANGES_ICON     $'\UE1EB '             # 
      #VCS_INCOMING_CHANGES_ICON     $'\UE80D '             # 
      VCS_INCOMING_CHANGES_ICON      $'\UE131 '             # 
      #VCS_OUTGOING_CHANGES_ICON     $'\UE1EC '             # 
      #VCS_OUTGOING_CHANGES_ICON     $'\UE80E '             # 
      VCS_OUTGOING_CHANGES_ICON      $'\UE132 '             # 
      VCS_TAG_ICON                   $'\UE817 '             # 
      VCS_BOOKMARK_ICON              $'\UE87B'              # 
      VCS_COMMIT_ICON                $'\UE821 '             # 
      VCS_BRANCH_ICON                $'\UE220'              # 
      VCS_REMOTE_BRANCH_ICON         ' '$'\UE804 '          # 
      VCS_GIT_ICON                   $'\UE20E  '            # 
      VCS_HG_ICON                    $'\UE1C3  '            # 
    )
  ;;
  'awesome-fontconfig')
    # fontconfig with awesome-font required! See
    # https://github.com/gabrielelana/awesome-terminal-fonts
    icons=(
      LEFT_SEGMENT_SEPARATOR         $'\UE0B0'              # 
      RIGHT_SEGMENT_SEPARATOR        $'\UE0B2'              # 
      LEFT_SUBSEGMENT_SEPARATOR      $'\UE0B1'              # 
      RIGHT_SUBSEGMENT_SEPARATOR     $'\UE0B3'              # 
      CARRIAGE_RETURN_ICON           $'\U21B5'              # ↵
      ROOT_ICON                      $'\uF201'              # 
      RUBY_ICON                      ' '$'\UF247 '          # 
      AWS_ICON                       $'\UF296'              # 
      BACKGROUND_JOBS_ICON           $'\UF013 '             # 
      TEST_ICON                      $'\UF291'              # 
      TODO_ICON                      $'\U2611'              # ☑
      BATTERY_ICON                   $'\u1F50B'             # 🔋
      OK_ICON                        $'\UF23A'              # 
      FAIL_ICON                      $'\UF281'              # 
      SYMFONY_ICON                   'SF'
      NODE_ICON                      $'\U2B22'              # ⬢
      MULTILINE_FIRST_PROMPT_PREFIX  $'\U256D'$'\U2500'     # ╭─
      MULTILINE_SECOND_PROMPT_PREFIX $'\U2570'$'\U2500 '    # ╰─
      APPLE_ICON                     $'\UF179'              # 
      FREEBSD_ICON                   $'\U1F608 '            # 😈
      LINUX_ICON                     $'\UF17C'              # 
      SUNOS_ICON                     $'\UF185 '             # 
      HOME_ICON                      $'\UF015 '             # 
      NETWORK_ICON                   $'\UF09E '             # 
      LOAD_ICON                      $'\UF080 '             # 
      RAM_ICON                       $'\UF0E4'              # 
      VCS_UNTRACKED_ICON             $'\UF059'              # 
      VCS_UNSTAGED_ICON              $'\UF06A'              # 
      VCS_STAGED_ICON                $'\UF055'              # 
      VCS_STASH_ICON                 $'\UF01C '             # 
      VCS_INCOMING_CHANGES_ICON      $'\UF01A '             # 
      VCS_OUTGOING_CHANGES_ICON      $'\UF01B '             # 
      VCS_TAG_ICON                   $'\UF217 '             # 
      VCS_BOOKMARK_ICON              $'\UF27B'              # 
      VCS_COMMIT_ICON                $'\UF221 '             # 
      VCS_BRANCH_ICON                $'\UF126'              # 
      VCS_REMOTE_BRANCH_ICON         ' '$'\UF204 '          # 
      VCS_GIT_ICON                   $'\UF113  '            # 
      VCS_HG_ICON                    $'\UF0C3  '            # 
    )
  ;;
  *)
    # Powerline-Patched Font required!
    # See https://github.com/Lokaltog/powerline-fonts
    icons=(
      LEFT_SEGMENT_SEPARATOR         $'\uE0B0'              # 
      RIGHT_SEGMENT_SEPARATOR        $'\uE0B2'              # 
      LEFT_SUBSEGMENT_SEPARATOR      $'\UE0B1'              # 
      RIGHT_SUBSEGMENT_SEPARATOR     $'\UE0B3'              # 
      CARRIAGE_RETURN_ICON           $'\U21B5'              # ↵
      ROOT_ICON                      $'\u26A1'              # ⚡
      RUBY_ICON                      ''
      AWS_ICON                       'AWS:'
      BACKGROUND_JOBS_ICON           $'\u2699'              # ⚙
      TEST_ICON                      ''
      TODO_ICON                      $'\U2611'              # ☑
      BATTERY_ICON                   $'\u1F50B'             # 🔋
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
      NETWORK_ICON                   'IP'
      LOAD_ICON                      'L'
      RAM_ICON                       'RAM'
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
      VCS_HG_ICON                    ''
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

################################################################
# Utility functions
################################################################

# Exits with 0 if a variable has been previously defined (even if empty)
# Takes the name of a variable that should be checked.
function defined() {
  local varname="$1"

  typeset -p "$varname" > /dev/null 2>&1
}

# Given the name of a variable and a default value, sets the variable
# value to the default only if it has not been defined.
#
# Typeset cannot set the value for an array, so this will only work
# for scalar values.
function set_default() {
  local varname="$1"
  local default_value="$2"

  defined "$varname" || typeset -g "$varname"="$default_value"
}

# Checks if an array contains a specific value.
# First parameter: the searched value
# Second parameter: array
function in_array() {
  local element
  for element in "${@:2}"; do
    [[ "$element" == "$1" ]] && return 0;
  done
  return 1
}

# Safety function for printing icons
# Prints the named icon, or if that icon is undefined, the string name.
function print_icon() {
  local icon_name=$1
  local ICON_USER_VARIABLE=POWERLEVEL9K_${icon_name}
  local USER_ICON=${(P)ICON_USER_VARIABLE}
  if defined "$ICON_USER_VARIABLE"; then
    echo -n "$USER_ICON"
  else
    echo -n "${icons[$icon_name]}"
  fi
}

# Converts large memory values into a human-readable unit (e.g., bytes --> GB)
printSizeHumanReadable() {
  typeset -F 2 size
  size="$1"+0.00001
  local extension
  extension=('B' 'K' 'M' 'G' 'T' 'P' 'E' 'Z' 'Y')
  local index=1

  # if the base is not Bytes
  if [[ -n $2 ]]; then
    for idx in "${extension[@]}"; do
      if [[ "$2" == "$idx" ]]; then
        break
      fi
      index=$(( index + 1 ))
    done
  fi

  while (( (size / 1024) > 0.1 )); do
    size=$(( size / 1024 ))
    index=$(( index + 1 ))
  done

  echo "$size${extension[$index]}"
}

# Gets the first value out of a list of items that is not empty.
# The items are examined by a callback-function.
# Takes two arguments:
#   * $list - A list of items
#   * $callback - A callback function to examine if the item is
#                 worthy. The callback function has access to
#                 the inner variable $item.
function getRelevantItem() {
  setopt shwordsplit # We need to split the words in $interfaces

  local list callback
  list=$1
  callback=$2

  for item in $list; do
    # The first non-empty item wins
    try=$(eval "$callback")
    if [[ -n "$try" ]]; then
      echo "$try"
      break;
    fi
  done
}

get_icon_names() {
  for key in ${(@k)icons}; do
    echo "POWERLEVEL9K_$key: ${icons[$key]}"
  done
}

# OS detection for the `os_icon` segment
case $(uname) in
    Darwin)
      OS='OSX'
      OS_ICON=$(print_icon 'APPLE_ICON')
      ;;
    FreeBSD)
      OS='BSD'
      OS_ICON=$(print_icon 'FREEBSD_ICON')
      ;;
    OpenBSD)
      OS='BSD'
      OS_ICON=$(print_icon 'FREEBSD_ICON')
      ;;
    DragonFly)
      OS='BSD'
      OS_ICON=$(print_icon 'FREEBSD_ICON')
      ;;
    Linux)
      OS='Linux'
      OS_ICON=$(print_icon 'LINUX_ICON')
      ;;
    SunOS)
      OS='Solaris'
      OS_ICON=$(print_icon 'SUNOS_ICON')
      ;;
    *)
      OS=''
      OS_ICON=''
      ;;
esac

# Determine the correct sed parameter.
#
# `sed` is unfortunately not consistent across OSes when it comes to flags.
SED_EXTENDED_REGEX_PARAMETER="-r"
if [[ "$OS" == 'OSX' ]]; then
  local IS_BSD_SED="$(sed --version &>> /dev/null || echo "BSD sed")"
  if [[ -n "$IS_BSD_SED" ]]; then
    SED_EXTENDED_REGEX_PARAMETER="-E"
  fi
fi

################################################################
# Color Scheme
################################################################

if [[ "$POWERLEVEL9K_COLOR_SCHEME" == "light" ]]; then
  DEFAULT_COLOR=white
  DEFAULT_COLOR_INVERTED=black
  DEFAULT_COLOR_DARK="252"
else
  DEFAULT_COLOR=black
  DEFAULT_COLOR_INVERTED=white
  DEFAULT_COLOR_DARK="236"
fi

set_default POWERLEVEL9K_VCS_FOREGROUND "$DEFAULT_COLOR"
set_default POWERLEVEL9K_VCS_DARK_FOREGROUND "$DEFAULT_COLOR_DARK"

################################################################
# Prompt Segment Constructors
#
# Methodology behind user-defined variables overwriting colors:
#     The first parameter to the segment constructors is the calling function's
#     name.  From this function name, we strip the "prompt_"-prefix and
#     uppercase it.  This is then prefixed with "POWERLEVEL9K_" and suffixed
#     with either "_BACKGROUND" or "_FOREGROUND", thus giving us the variable
#     name. So each new segment is user-overwritable by a variable following
#     this naming convention.
################################################################

# The `CURRENT_BG` variable is used to remember what the last BG color used was
# when building the left-hand prompt. Because the RPROMPT is created from
# right-left but reads the opposite, this isn't necessary for the other side.
CURRENT_BG='NONE'

# Begin a left prompt segment
# Takes four arguments:
#   * $1: Name of the function that was orginally invoked (mandatory).
#         Necessary, to make the dynamic color-overwrite mechanism work.
#   * $2: Background color
#   * $3: Foreground color
#   * $4: The segment content
# The latter three can be omitted,
set_default POWERLEVEL9K_WHITESPACE_BETWEEN_LEFT_SEGMENTS " "
left_prompt_segment() {
  # Overwrite given background-color by user defined variable for this segment.
  local BACKGROUND_USER_VARIABLE=POWERLEVEL9K_${(U)1#prompt_}_BACKGROUND
  local BG_COLOR_MODIFIER=${(P)BACKGROUND_USER_VARIABLE}
  [[ -n $BG_COLOR_MODIFIER ]] && 2="$BG_COLOR_MODIFIER"

  # Overwrite given foreground-color by user defined variable for this segment.
  local FOREGROUND_USER_VARIABLE=POWERLEVEL9K_${(U)1#prompt_}_FOREGROUND
  local FG_COLOR_MODIFIER=${(P)FOREGROUND_USER_VARIABLE}
  [[ -n $FG_COLOR_MODIFIER ]] && 3="$FG_COLOR_MODIFIER"

  local bg fg
  [[ -n $2 ]] && bg="%K{$2}" || bg="%k"
  [[ -n $3 ]] && fg="%F{$3}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' ]] && [[ "$2" != "$CURRENT_BG" ]]; then
    # Middle segment
    echo -n "%{$bg%F{$CURRENT_BG}%}$(print_icon 'LEFT_SEGMENT_SEPARATOR')%{$fg%}$POWERLEVEL9K_WHITESPACE_BETWEEN_LEFT_SEGMENTS"
  elif [[ "$CURRENT_BG" == "$2" ]]; then
    # Middle segment with same color as previous segment
    # We take the current foreground color as color for our
    # subsegment (or the default color). This should have
    # enough contrast.
    local complement
    [[ -n $3 ]] && complement=$3 || complement=$DEFAULT_COLOR
    echo -n "%{$bg%F{$complement}%}$(print_icon 'LEFT_SUBSEGMENT_SEPARATOR')%{$fg%}$POWERLEVEL9K_WHITESPACE_BETWEEN_LEFT_SEGMENTS"
  else
    # First segment
    echo -n "%{$bg%}%{$fg%}$POWERLEVEL9K_WHITESPACE_BETWEEN_LEFT_SEGMENTS"
  fi
  CURRENT_BG=$2
  [[ -n $4 ]] && echo -n "$4$POWERLEVEL9K_WHITESPACE_BETWEEN_LEFT_SEGMENTS"
}

# End the left prompt, closes the final segment.
left_prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n "%{%k%F{$CURRENT_BG}%}$(print_icon 'LEFT_SEGMENT_SEPARATOR')"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%} "
  CURRENT_BG=''
}

CURRENT_RIGHT_BG='NONE'

# Begin a right prompt segment
# Takes four arguments:
#   * $1: Name of the function that was orginally invoked (mandatory).
#         Necessary, to make the dynamic color-overwrite mechanism work.
#   * $2: Background color
#   * $3: Foreground color
#   * $4: The segment content
# No ending for the right prompt segment is needed (unlike the left prompt, above).
set_default POWERLEVEL9K_WHITESPACE_BETWEEN_RIGHT_SEGMENTS " "
right_prompt_segment() {
  # Overwrite given background-color by user defined variable for this segment.
  local BACKGROUND_USER_VARIABLE=POWERLEVEL9K_${(U)1#prompt_}_BACKGROUND
  local BG_COLOR_MODIFIER=${(P)BACKGROUND_USER_VARIABLE}
  [[ -n $BG_COLOR_MODIFIER ]] && 2="$BG_COLOR_MODIFIER"

  # Overwrite given foreground-color by user defined variable for this segment.
  local FOREGROUND_USER_VARIABLE=POWERLEVEL9K_${(U)1#prompt_}_FOREGROUND
  local FG_COLOR_MODIFIER=${(P)FOREGROUND_USER_VARIABLE}
  [[ -n $FG_COLOR_MODIFIER ]] && 3="$FG_COLOR_MODIFIER"

  local bg fg
  [[ -n $2 ]] && bg="%K{$2}" || bg="%k"
  [[ -n $3 ]] && fg="%F{$3}" || fg="%f"

  if [[ "$CURRENT_RIGHT_BG" == "$2" ]]; then
    # Middle segment with same color as previous segment
    # We take the current foreground color as color for our
    # subsegment (or the default color). This should have
    # enough contrast.
    local complement
    [[ -n $3 ]] && complement=$3 || complement=$DEFAULT_COLOR
    echo -n "%F{$complement}$(print_icon 'RIGHT_SUBSEGMENT_SEPARATOR')%f%{$bg%}%{$fg%}$POWERLEVEL9K_WHITESPACE_BETWEEN_RIGHT_SEGMENTS"
  else
    echo -n "%F{$2}$(print_icon 'RIGHT_SEGMENT_SEPARATOR')%f%{$bg%}%{$fg%}$POWERLEVEL9K_WHITESPACE_BETWEEN_RIGHT_SEGMENTS"
  fi
  [[ -n $4 ]] && echo -n "$4$POWERLEVEL9K_WHITESPACE_BETWEEN_RIGHT_SEGMENTS%f"

  CURRENT_RIGHT_BG=$2
}

################################################################
# The `vcs` Segment and VCS_INFO hooks / helper functions
################################################################
prompt_vcs() {
  autoload -Uz vcs_info

  VCS_WORKDIR_DIRTY=false
  VCS_CHANGESET_PREFIX=''
  if [[ "$POWERLEVEL9K_SHOW_CHANGESET" == true ]]; then
    # Default: Just display the first 12 characters of our changeset-ID.
    local VCS_CHANGESET_HASH_LENGTH=12
    if [[ -n "$POWERLEVEL9K_CHANGESET_HASH_LENGTH" ]]; then
      VCS_CHANGESET_HASH_LENGTH="$POWERLEVEL9K_CHANGESET_HASH_LENGTH"
    fi

    VCS_CHANGESET_PREFIX="%F{$POWERLEVEL9K_VCS_DARK_FOREGROUND}$(print_icon 'VCS_COMMIT_ICON')%0.$VCS_CHANGESET_HASH_LENGTH""i%f "
  fi

  zstyle ':vcs_info:*' enable git hg
  zstyle ':vcs_info:*' check-for-changes true

  VCS_DEFAULT_FORMAT="$VCS_CHANGESET_PREFIX%F{$POWERLEVEL9K_VCS_FOREGROUND}%b%c%u%m%f"
  zstyle ':vcs_info:git*:*' formats "%F{$POWERLEVEL9K_VCS_FOREGROUND}$(print_icon 'VCS_GIT_ICON')%f$VCS_DEFAULT_FORMAT"
  zstyle ':vcs_info:hg*:*' formats "%F{$POWERLEVEL9K_VCS_FOREGROUND}$(print_icon 'VCS_HG_ICON')%f$VCS_DEFAULT_FORMAT"

  zstyle ':vcs_info:*' actionformats "%b %F{red}| %a%f"

  zstyle ':vcs_info:*' stagedstr " %F{$POWERLEVEL9K_VCS_FOREGROUND}$(print_icon 'VCS_STAGED_ICON')%f"
  zstyle ':vcs_info:*' unstagedstr " %F{$POWERLEVEL9K_VCS_FOREGROUND}$(print_icon 'VCS_UNSTAGED_ICON')%f"

  zstyle ':vcs_info:git*+set-message:*' hooks vcs-detect-changes git-untracked git-aheadbehind git-stash git-remotebranch git-tagname
  zstyle ':vcs_info:hg*+set-message:*' hooks vcs-detect-changes

  # For Hg, only show the branch name
  zstyle ':vcs_info:hg*:*' branchformat "$(print_icon 'VCS_BRANCH_ICON')%b"
  # The `get-revision` function must be turned on for dirty-check to work for Hg
  zstyle ':vcs_info:hg*:*' get-revision true
  zstyle ':vcs_info:hg*:*' get-bookmarks true
  zstyle ':vcs_info:hg*+gen-hg-bookmark-string:*' hooks hg-bookmarks

  if [[ "$POWERLEVEL9K_SHOW_CHANGESET" == true ]]; then
    zstyle ':vcs_info:*' get-revision true
  fi

  # Actually invoke vcs_info manually to gather all information.
  vcs_info
  local vcs_prompt="${vcs_info_msg_0_}"

  if [[ -n "$vcs_prompt" ]]; then
    if [[ "$VCS_WORKDIR_DIRTY" == true ]]; then
      "$1_prompt_segment" "$0_MODIFIED" "yellow" "$DEFAULT_COLOR"
    else
      "$1_prompt_segment" "$0" "green" "$DEFAULT_COLOR"
    fi

    echo -n "$vcs_prompt "
  fi
}

function +vi-git-untracked() {
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' && \
            -n $(git ls-files --others --exclude-standard | sed q) ]]; then
        hook_com[unstaged]+=" %F{$POWERLEVEL9K_VCS_FOREGROUND}$(print_icon 'VCS_UNTRACKED_ICON')%f"
    fi
}

function +vi-git-aheadbehind() {
    local ahead behind branch_name
    local -a gitstatus

    branch_name=$(git symbolic-ref --short HEAD 2>/dev/null)

    # for git prior to 1.7
    # ahead=$(git rev-list origin/${branch_name}..HEAD | wc -l)
    ahead=$(git rev-list "${branch_name}"@{upstream}..HEAD 2>/dev/null | wc -l)
    (( ahead )) && gitstatus+=( " %F{$POWERLEVEL9K_VCS_FOREGROUND}$(print_icon 'VCS_OUTGOING_CHANGES_ICON')${ahead// /}%f" )

    # for git prior to 1.7
    # behind=$(git rev-list HEAD..origin/${branch_name} | wc -l)
    behind=$(git rev-list HEAD.."${branch_name}"@{upstream} 2>/dev/null | wc -l)
    (( behind )) && gitstatus+=( " %F{$POWERLEVEL9K_VCS_FOREGROUND}$(print_icon 'VCS_INCOMING_CHANGES_ICON')${behind// /}%f" )

    hook_com[misc]+=${(j::)gitstatus}
}

function +vi-git-remotebranch() {
    local remote branch_name

    # Are we on a remote-tracking branch?
    remote=${$(git rev-parse --verify HEAD@{upstream} --symbolic-full-name 2>/dev/null)/refs\/(remotes|heads)\/}
    branch_name=$(git symbolic-ref --short HEAD 2>/dev/null)

    hook_com[branch]="%F{$POWERLEVEL9K_VCS_FOREGROUND}$(print_icon 'VCS_BRANCH_ICON')${hook_com[branch]}%f"
    # Always show the remote
    #if [[ -n ${remote} ]] ; then
    # Only show the remote if it differs from the local
    if [[ -n ${remote} ]] && [[ "${remote#*/}" != "${branch_name}" ]] ; then
        hook_com[branch]+="%F{$POWERLEVEL9K_VCS_FOREGROUND}$(print_icon 'VCS_REMOTE_BRANCH_ICON')%f%F{$POWERLEVEL9K_VCS_FOREGROUND}${remote// /}%f"
    fi
}

function +vi-git-tagname() {
    local tag

    tag=$(git describe --tags --exact-match HEAD 2>/dev/null)
    [[ -n "${tag}" ]] && hook_com[branch]=" %F{$POWERLEVEL9K_VCS_FOREGROUND}$(print_icon 'VCS_TAG_ICON')${tag}%f"
}

# Show count of stashed changes
# Port from https://github.com/whiteinge/dotfiles/blob/5dfd08d30f7f2749cfc60bc55564c6ea239624d9/.zsh_shouse_prompt#L268
function +vi-git-stash() {
  local -a stashes

  if [[ -s $(git rev-parse --git-dir)/refs/stash ]] ; then
    stashes=$(git stash list 2>/dev/null | wc -l)
    hook_com[misc]+=" %F{$POWERLEVEL9K_VCS_FOREGROUND}$(print_icon 'VCS_STASH_ICON')${stashes// /}%f"
  fi
}

function +vi-hg-bookmarks() {
  if [[ -n "${hgbmarks[@]}" ]]; then
    hook_com[hg-bookmark-string]=" %F{$POWERLEVEL9K_VCS_FOREGROUND}$(print_icon 'VCS_BOOKMARK_ICON')${hgbmarks[@]}%f"

    # To signal that we want to use the sting we just generated, set the special
    # variable `ret' to something other than the default zero:
    ret=1
    return 0
  fi
}

function +vi-vcs-detect-changes() {
  if [[ -n "${hook_com[staged]}" ]] || [[ -n "${hook_com[unstaged]}" ]]; then
    VCS_WORKDIR_DIRTY=true
  else
    VCS_WORKDIR_DIRTY=false
  fi
}

################################################################
# Prompt Segment Definitions
################################################################

# The `CURRENT_BG` variable is used to remember what the last BG color used was
# when building the left-hand prompt. Because the RPROMPT is created from
# right-left but reads the opposite, this isn't necessary for the other side.
CURRENT_BG='NONE'

# AWS Profile
prompt_aws() {
  local aws_profile="$AWS_DEFAULT_PROFILE"
  if [[ -n "$aws_profile" ]];
  then
    "$1_prompt_segment" "$0" red white "$(print_icon 'AWS_ICON') $aws_profile"
  fi
}

prompt_battery() {
  icons[BATTERY_ICON]=$'\UE894'
  # set default values of not specified in shell
  [[ -z $POWERLEVEL9K_BATTERY_CHARGING ]] && POWERLEVEL9K_BATTERY_CHARGING="yellow"
  [[ -z $POWERLEVEL9K_BATTERY_CHARGED ]] && POWERLEVEL9K_BATTERY_CHARGED="green"
  [[ -z $POWERLEVEL9K_BATTERY_DISCONNECTED ]] && POWERLEVEL9K_BATTERY_DISCONNECTED="$DEFAULT_COLOR"
  [[ -z $POWERLEVEL9K_BATTERY_LOW_THRESHOLD ]] && POWERLEVEL9K_BATTERY_LOW_THRESHOLD=10
  [[ -z $POWERLEVEL9K_BATTERY_LOW_COLOR ]] && POWERLEVEL9K_BATTERY_LOW_COLOR="red"
  [[ -z $POWERLEVEL9K_BATTERY_FOREGROUND ]] && local fg_color="$DEFAULT_COLOR" || local fg_color=$POWERLEVEL9K_BATTERY_FOREGROUND

  if [[ $OS =~ OSX && -f /usr/sbin/ioreg && -x /usr/sbin/ioreg ]]; then
    # return if there is no battery on system
    [[ -z $(ioreg -n AppleSmartBattery | grep MaxCapacity) ]] && return

    # get charge status
    [[ $(ioreg -n AppleSmartBattery | grep ExternalConnected | awk '{ print $5 }') =~ "Yes" ]] && local connected=true
    [[ $(ioreg -n AppleSmartBattery | grep IsCharging | awk '{ print $5 }') =~ "Yes" ]] && local charging=true

    # convert time remaining from minutes to hours:minutes date string
    local time_remaining=$(ioreg -n AppleSmartBattery | grep TimeRemaining | awk '{ print $5 }')
    if [[ ! -z $time_remaining ]]; then
      # this value is set to a very high number when the system is calculating
      [[ $time_remaining -gt 10000 ]] && local tstring="..." || local tstring=${(f)$(date -u -r $(($time_remaining * 60)) +%k:%M)}
    fi

    # get charge values
    local max_capacity=$(ioreg -n AppleSmartBattery | grep MaxCapacity | awk '{ print $5 }')
    local current_capacity=$(ioreg -n AppleSmartBattery | grep CurrentCapacity | awk '{ print $5 }')

    [[ ! -z $max_capacity && ! -z $current_capacity ]] && local bat_percent=$(ruby -e "puts ($current_capacity.to_f / $max_capacity.to_f * 100).round.to_i")

    # logic for string output
    [[ $charging =~ true && $connected =~ true ]] && local conn="%F{$POWERLEVEL9K_BATTERY_CHARGING}" && local remain=" ($tstring)"
    [[ ! $charging =~ true && $connected =~ true ]] && local conn="%F{$POWERLEVEL9K_BATTERY_CHARGED}" && local remain=""
    if [[ ! $connected =~ true ]]; then
      [[ $bat_percent -lt $POWERLEVEL9K_BATTERY_LOW_THRESHOLD ]] && local conn="%F{$POWERLEVEL9K_BATTERY_LOW_COLOR}" || local conn="%F{$POWERLEVEL9K_BATTERY_DISCONNECTED}"
      local remain=" ($tstring)"
    fi
  fi

  if [[ $OS =~ Linux ]]; then
    local sysp="/sys/class/power_supply"
    # reported BAT0 or BAT1 depending on kernel version
    [[ -a $sysp/BAT0 ]] && local bat=$sysp/BAT0
    [[ -a $sysp/BAT1 ]] && local bat=$sysp/BAT1

    # return if no battery found
    [[ -z $bat ]] && return

    [[ $(cat $bat/capacity) -gt 100 ]] && local bat_percent=100 || local bat_percent=$(cat $bat/capacity)
    [[ $(cat $bat/status) =~ Charging ]] && local connected=true
    [[ $(cat $bat/status) =~ Charging && $bat_percent =~ 100 ]] && local conn="%F{$POWERLEVEL9K_BATTERY_CHARGED}"
    [[ $(cat $bat/status) =~ Charging && $bat_percent -lt 100 ]] && local conn="%F{$POWERLEVEL9K_BATTERY_CHARGING}"
    if [[ ! $connected =~ true ]]; then
      [[ $bat_percent -lt $POWERLEVEL9K_BATTERY_LOW_THRESHOLD ]] && local conn="%F{$POWERLEVEL9K_BATTERY_LOW_COLOR}" || local conn="%F{$POWERLEVEL9K_BATTERY_DISCONNECTED}"
    fi
    if [[ -f /usr/bin/acpi ]]; then
      local time_remaining=$(acpi | awk '{ print $5 }')
      if [[ $time_remaining =~ rate ]]; then
        local tstring="..."
      elif [[ $time_remaining =~ "[:digit:]+" ]]; then
        local tstring=${(f)$(date -u -d @$(echo $time_remaining | sed s/://g) +%k:%M)}
      fi
    fi
    [[ ! -z $tstring ]] && local remain=" ($tstring)"
  fi

  # display prompt_segment
  [[ ! -z $bat_percent ]] && "$1_prompt_segment" "$0" "black" "$DEFAULT_COLOR" "$conn$(print_icon 'BATTERY_ICON')%F{$fg_color} $bat_percent%%$remain"
}

# Context: user@hostname (who am I and where am I)
# Note that if $DEFAULT_USER is not set, this prompt segment will always print
prompt_context() {
  if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    if [[ $(print -P "%#") == '#' ]]; then
      # Shell runs as root
      "$1_prompt_segment" "$0_ROOT" "$DEFAULT_COLOR" "yellow" "$USER@%m"
    else
      "$1_prompt_segment" "$0_DEFAULT" "$DEFAULT_COLOR" "011" "$USER@%m"
    fi
  fi
}

# Dir: current working directory
prompt_dir() {
  local current_path='%~'
  if [[ -n "$POWERLEVEL9K_SHORTEN_DIR_LENGTH" ]]; then

    case "$POWERLEVEL9K_SHORTEN_STRATEGY" in
      truncate_middle)
        current_path=$(pwd | sed -e "s,^$HOME,~," | sed $SED_EXTENDED_REGEX_PARAMETER "s/([^/]{$POWERLEVEL9K_SHORTEN_DIR_LENGTH})[^/]+([^/]{$POWERLEVEL9K_SHORTEN_DIR_LENGTH})\//\1\.\.\2\//g")
      ;;
      truncate_from_right)
        current_path=$(pwd | sed -e "s,^$HOME,~," | sed $SED_EXTENDED_REGEX_PARAMETER "s/([^/]{$POWERLEVEL9K_SHORTEN_DIR_LENGTH})[^/]+\//\1..\//g")
      ;;
      *)
        current_path="%$((POWERLEVEL9K_SHORTEN_DIR_LENGTH+1))(c:.../:)%${POWERLEVEL9K_SHORTEN_DIR_LENGTH}c"
      ;;
    esac

  fi

  "$1_prompt_segment" "$0" "blue" "$DEFAULT_COLOR" "$(print_icon 'HOME_ICON')$current_path"
}

# GO-prompt
prompt_go_version() {
  local go_version
  go_version=$(go version 2>&1 | grep -oe "^go[0-9.]*")

  if [[ -n "$go_version" ]]; then
    "$1_prompt_segment" "$0" "green" "255" "$go_version"
  fi
}

# Command number (in local history)
prompt_history() {
  "$1_prompt_segment" "$0" "244" "$DEFAULT_COLOR" '%h'
}

prompt_icons_test() {
  for key in ${(@k)icons}; do
    # The lower color spectrum in ZSH makes big steps. Choosing
    # the next color has enough contrast to read.
    local random_color=$((RANDOM % 8))
    local next_color=$((random_color+1))
    "$1_prompt_segment" "$0" "$random_color" "$next_color" "$key: ${icons[$key]}"
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

  "$1_prompt_segment" "$0" "cyan" "$DEFAULT_COLOR" "$(print_icon 'NETWORK_ICON') $ip"
}

prompt_load() {
  if [[ "$OS" == "OSX" ]]; then
    load_avg_5min=$(sysctl vm.loadavg | grep -o -E '[0-9]+(\.|,)[0-9]+' | head -n 1)
  else
    load_avg_5min=$(grep -o "[0-9.]*" /proc/loadavg | head -n 1)
  fi

  # Replace comma
  load_avg_5min=${load_avg_5min//,/.}

  if [[ "$load_avg_5min" -gt 10 ]]; then
    BACKGROUND_COLOR="red"
    FUNCTION_SUFFIX="_CRITICAL"
  elif [[ "$load_avg_5min" -gt 3 ]]; then
    BACKGROUND_COLOR="yellow"
    FUNCTION_SUFFIX="_WARNING"
  else
    BACKGROUND_COLOR="green"
    FUNCTION_SUFFIX="_NORMAL"
  fi

  "$1_prompt_segment" "$0$FUNCTION_SUFFIX" "$BACKGROUND_COLOR" "$DEFAULT_COLOR" "$(print_icon 'LOAD_ICON') $load_avg_5min"
}

# Node version
prompt_node_version() {
  local nvm_prompt
  nvm_prompt=$(node -v 2>/dev/null)
  [[ -z "${nvm_prompt}" ]] && return

  "$1_prompt_segment" "$0" "green" "white" "${nvm_prompt:1} $(print_icon 'NODE_ICON')"
}

# print a little OS icon
prompt_os_icon() {
  "$1_prompt_segment" "$0" "black" "255" "$OS_ICON"
}

# print PHP version number
prompt_php_version() {
  local php_version
  php_version=$(php -v 2>&1 | grep -oe "^PHP\s*[0-9.]*")

  if [[ -n "$php_version" ]]; then
    "$1_prompt_segment" "$0" "013" "255" "$php_version"
  fi
}

# Show free RAM and used Swap
prompt_ram() {
  defined POWERLEVEL9K_RAM_ELEMENTS || POWERLEVEL9K_RAM_ELEMENTS=(ram_free swap_used)

  local rendition base
  for element in "${POWERLEVEL9K_RAM_ELEMENTS[@]}"; do
    case $element in
      ram_free)
        if [[ "$OS" == "OSX" ]]; then
          ramfree=$(vm_stat | grep "Pages free" | grep -o -E '[0-9]+')
          # Convert pages into Bytes
          ramfree=$(( ramfree * 4096 ))
          base=''
        else
          ramfree=$(grep -o -E "MemFree:\s+[0-9]+" /proc/meminfo | grep -o "[0-9]*")
          base=K
        fi

        rendition+="$(print_icon 'RAM_ICON') $(printSizeHumanReadable "$ramfree" $base) "
      ;;
      swap_used)
        if [[ "$OS" == "OSX" ]]; then
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
          base=K
        fi

        rendition+="$(printSizeHumanReadable "$swap_used" $base) "
      ;;
    esac
  done

  "$1_prompt_segment" "$0" "yellow" "$DEFAULT_COLOR" "${rendition% }"
}

# Node version from NVM
# Only prints the segment if different than the default value
prompt_nvm() {
  local node_version=$(nvm current)
  local nvm_default=$(cat $NVM_DIR/alias/default)
  [[ -z "${node_version}" ]] && return
  [[ "$node_version" =~ "$nvm_default" ]] && return
  NODE_ICON=$'\u2B22' # ⬢
  $1_prompt_segment "$0" "green" "011" "${node_version:1} $NODE_ICON"
}

# rbenv information
# DEPRECATED! Use `ruby_version` instead!
prompt_rbenv() {
  if [[ -n "$RBENV_VERSION" ]]; then
    "$1_prompt_segment" "$0" "red" "$DEFAULT_COLOR" "$RBENV_VERSION"
  fi
}

# RSpec test ratio
prompt_rspec_stats() {
  if [[ (-d app && -d spec) ]]; then
    local code_amount tests_amount
    code_amount=$(ls -1 app/**/*.rb | wc -l)
    tests_amount=$(ls -1 spec/**/*.rb | wc -l)

    build_test_stats "$1" "$0" "$code_amount" "$tests_amount" "RSpec $(print_icon 'TEST_ICON')"
  fi
}

# Ruby Version
set_default POWERLEVEL9K_SHOW_RUBY_VERSION_ALWAYS false
prompt_ruby_version() {
  defined POWERLEVEL9K_RUBY_VERSION_CHECKERS || POWERLEVEL9K_RUBY_VERSION_CHECKERS=('rvm' 'rbenv' 'chruby' 'ruby')
  defined POWERLEVEL9K_RUBY_VERSION_CONDITION || POWERLEVEL9K_RUBY_VERSION_CONDITION='[[ -n $(find . -name "*.rb" -maxdepth 2 -print | head -n 1) ]] && echo true'

  if [[ "$(eval $POWERLEVEL9K_RUBY_VERSION_CONDITION)" != "true" ]]; then
    # Fail fast: If we don't have a valid condition and therefore
    # have no idea how to render this segment, just exit. In the
    # opposite, this means if the user specified a "always true"
    # condition (`echo true`), that we can proceed to render as
    # a version string will hopefully be found by one of the
    # checkers.
    return
  fi

  local result
  for element in "${POWERLEVEL9K_RUBY_VERSION_CHECKERS[@]}"; do
    if [[ "$element" == "rvm" ]]; then
      local rvm_prompt=$(rvm-prompt i v g 2> /dev/null)
      local rvm_gemset=$(rvm gemset list 2> /dev/null)

      if [[ -n "$rvm_gemset" ]] && [[ -z "$(echo $rvm_gemset | grep "=> (default)")" ]]; then
        result=$rvm_prompt
      fi
    elif [[ "$element" == "rbenv" ]]; then
      result=$RBENV_VERSION
    elif [[ "$element" == "chruby" ]]; then
      result=$(chruby 2> /dev/null | sed -e 's/ \* //')
    elif [[ "$element" == "ruby" ]]; then
      result=$(ruby --version 2> /dev/null | grep -oe "ruby [0-9.a-z]*" | grep -oe "[0-9.a-z]*$")
    fi

    if [[ -n "$result" ]]; then
      # Exit for-loop, if we found a version.
      break
    fi
  done

  if [[ -n "$result" ]]; then
    "$1_prompt_segment" "$0" "red" "$DEFAULT_COLOR" "$result$(print_icon 'RUBY_ICON')"
  fi
}

# Ruby Version Manager information
# DEPRECATED! Use `ruby_version` instead!
prompt_rvm() {
  local rvm_prompt
  rvm_prompt=$(rvm-prompt)
  if [ "$rvm_prompt" != "" ]; then
    "$1_prompt_segment" "$0" "240" "$DEFAULT_COLOR" "$rvm_prompt$(print_icon 'RUBY_ICON')"
  fi
}

# Status: (return code, root status, background jobs)
set_default POWERLEVEL9K_STATUS_VERBOSE true
prompt_status() {
  local symbols bg
  symbols=()

  if [[ "$POWERLEVEL9K_STATUS_VERBOSE" == true ]]; then
    if [[ "$RETVAL" -ne 0 ]]; then
      symbols+="%F{226}$RETVAL $(print_icon 'CARRIAGE_RETURN_ICON')%f"
      bg="red"
    else
      symbols+="%F{046}$(print_icon 'OK_ICON')%f"
      bg="black"
    fi
  else
    [[ "$RETVAL" -ne 0 ]] && symbols+="%{%F{red}%}$(print_icon 'FAIL_ICON')%f"
    bg="$DEFAULT_COLOR"
  fi

  [[ "$UID" -eq 0 ]] && symbols+="%{%F{yellow}%} $(print_icon 'ROOT_ICON')%f"
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}$(print_icon 'BACKGROUND_JOBS_ICON')%f"

  [[ -n "$symbols" ]] && "$1_prompt_segment" "$0" "$bg" "white" "$symbols"
}

# Symfony2-PHPUnit test ratio
prompt_symfony2_tests() {
  if [[ (-d src && -d app && -f app/AppKernel.php) ]]; then
    local code_amount tests_amount
    code_amount=$(ls -1 src/**/*.php | grep -vc Tests)
    tests_amount=$(ls -1 src/**/*.php | grep -c Tests)

    build_test_stats "$1" "$0" "$code_amount" "$tests_amount" "SF2 $(print_icon 'TEST_ICON')"
  fi
}

# Symfony2-Version
prompt_symfony2_version() {
  if [[ -f app/bootstrap.php.cache ]]; then
    local symfony2_version
    symfony2_version=$(grep " VERSION " app/bootstrap.php.cache | sed -e 's/[^.0-9]*//g')
    "$1_prompt_segment" "$0" "240" "$DEFAULT_COLOR" "$(print_icon 'SYMFONY_ICON') $symfony2_version"
  fi
}

# Show a ratio of tests vs code
build_test_stats() {
  local code_amount="$3"
  local tests_amount="$4"+0.00001
  local headline="$5"

  # Set float precision to 2 digits:
  typeset -F 2 ratio
  local ratio=$(( (tests_amount/code_amount) * 100 ))

  (( ratio >= 75 )) && "$1_prompt_segment" "${2}_GOOD" "cyan" "$DEFAULT_COLOR" "$headline: $ratio%%"
  (( ratio >= 50 && ratio < 75 )) && "$1_prompt_segment" "$2_AVG" "yellow" "$DEFAULT_COLOR" "$headline: $ratio%%"
  (( ratio < 50 )) && "$1_prompt_segment" "$2_BAD" "red" "$DEFAULT_COLOR" "$headline: $ratio%%"
}

# System time
prompt_time() {
  local time_format="%D{%H:%M:%S}"
  if [[ -n "$POWERLEVEL9K_TIME_FORMAT" ]]; then
    time_format="$POWERLEVEL9K_TIME_FORMAT"
  fi

  "$1_prompt_segment" "$0" "$DEFAULT_COLOR_INVERTED" "$DEFAULT_COLOR" "$time_format"
}

# todo.sh: shows the number of tasks in your todo.sh file
prompt_todo() {
  if $(hash todo.sh 2>&-); then
    count=$(todo.sh ls | egrep "TODO: [0-9]+ of ([0-9]+) tasks shown" | awk '{ print $4 }')
    if [[ "$count" = <-> ]]; then
      "$1_prompt_segment" "$0" "244" "$DEFAULT_COLOR" "$(print_icon 'TODO_ICON') $count"
    fi
  fi
}

# Vi Mode: show editing mode (NORMAL|INSERT)
set_default POWERLEVEL9K_VI_INSERT_MODE_STRING "INSERT"
set_default POWERLEVEL9K_VI_COMMAND_MODE_STRING "NORMAL"
prompt_vi_mode() {
  case ${KEYMAP} in
    main|viins)
      "$1_prompt_segment" "$0_INSERT" "$DEFAULT_COLOR" "blue" "$POWERLEVEL9K_VI_INSERT_MODE_STRING"
    ;;
    vicmd)
      "$1_prompt_segment" "$0_NORMAL" "$DEFAULT_COLOR" "default" "$POWERLEVEL9K_VI_COMMAND_MODE_STRING"
    ;;
  esac
}

# Virtualenv: current working virtualenv
# More information on virtualenv (Python):
# https://virtualenv.pypa.io/en/latest/
prompt_virtualenv() {
  local virtualenv_path="$VIRTUAL_ENV"
  if [[ -n "$virtualenv_path" && "$VIRTUAL_ENV_DISABLE_PROMPT" != true ]]; then
    "$1_prompt_segment" "$0" "blue" "$DEFAULT_COLOR" "($(basename "$virtualenv_path"))"
  fi
}

################################################################
# Prompt processing and drawing
################################################################

# Main prompt
build_left_prompt() {
  defined POWERLEVEL9K_LEFT_PROMPT_ELEMENTS || POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir rbenv vcs)

  for element in "${POWERLEVEL9K_LEFT_PROMPT_ELEMENTS[@]}"; do
    "prompt_$element" "left"
  done

  left_prompt_end
}

# Right prompt
build_right_prompt() {
  defined POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS || POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status history time)

  for element in "${POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS[@]}"; do
    "prompt_$element" "right"
  done
}

powerlevel9k_prepare_prompts() {
  RETVAL=$?

  if [[ "$POWERLEVEL9K_PROMPT_ON_NEWLINE" == true ]]; then
    PROMPT="$(print_icon 'MULTILINE_FIRST_PROMPT_PREFIX')%{%f%b%k%}$(build_left_prompt)
$(print_icon 'MULTILINE_SECOND_PROMPT_PREFIX')"
    # The right prompt should be on the same line as the first line of the left
    # prompt.  To do so, there is just a quite ugly workaround: Before zsh draws
    # the RPROMPT, we advise it, to go one line up. At the end of RPROMPT, we
    # advise it to go one line down. See:
    # http://superuser.com/questions/357107/zsh-right-justify-in-ps1
    local LC_ALL="" LC_CTYPE="en_US.UTF-8" # Set the right locale to protect special characters
    RPROMPT_PREFIX='%{'$'\e[1A''%}' # one line up
    RPROMPT_SUFFIX='%{'$'\e[1B''%}' # one line down
  else
    PROMPT="%{%f%b%k%}$(build_left_prompt)"
    RPROMPT_PREFIX=''
    RPROMPT_SUFFIX=''
  fi

  if [[ "$POWERLEVEL9K_DISABLE_RPROMPT" != true ]]; then
    RPROMPT="$RPROMPT_PREFIX%{%f%b%k%}$(build_right_prompt)%{$reset_color%}$RPROMPT_SUFFIX"
  fi
}

function zle-line-init {
  powerlevel9k_prepare_prompts
  zle reset-prompt
}

function zle-keymap-select {
  powerlevel9k_prepare_prompts
  zle reset-prompt
}

function show_warning_if_deprecated() {
  if in_array "$1" "${POWERLEVEL9K_LEFT_PROMPT_ELEMENTS[@]}" || in_array "$1" "${POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS[@]}"; then
    print -P "%F{yellow}DEPRECATED!%f You use a deprecated segment '$1'. Please use '$2' instead!"
  fi
}

powerlevel9k_init() {
  # Display a warning if the terminal does not support 256 colors
  local term_colors
  term_colors=$(tput colors)
  if (( term_colors < 256 )); then
    print -P "%F{red}WARNING!%f Your terminal supports less than 256 colors!"
    print -P "You should put: %F{blue}export TERM=\"xterm-256color\"%f in your \~\/.zshrc"
  fi

  show_warning_if_deprecated "rvm" "ruby_version"
  show_warning_if_deprecated "rbenv" "ruby_version"

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
  zle -N zle-keymap-select
}

powerlevel9k_init "$@"

# vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8
################################################################
# Developer segments
# This file holds the developer segments for
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

###############################################################
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

###############################################################
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

  serialize_segment "$0" "" "$1" "$2" "${3}" "006" "${DEFAULT_COLOR_INVERTED}" "${result}" "PYTHON_ICON"
}

###############################################################
# AWS Profile
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
prompt_aws() {
  serialize_segment "$0" "" "$1" "$2" "${3}" "red" "${DEFAULT_COLOR_INVERTED}" "${AWS_DEFAULT_PROFILE}" "AWS_ICON"
}

###############################################################
# Current Elastic Beanstalk environment
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
prompt_aws_eb_env() {
  # TODO: Upsearch!
  local eb_env=$(grep environment .elasticbeanstalk/config.yml 2> /dev/null | awk '{print $2}')

  serialize_segment "$0" "" "$1" "$2" "${3}" "${DEFAULT_COLOR}" "green" "${eb_env}" "AWS_EB_ICON"
}

###############################################################
# GO prompt
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
prompt_go_version() {
  local go_version=$(go version 2>/dev/null | sed -E "s/.*(go[0-9.]*).*/\1/")

  serialize_segment "$0" "" "$1" "$2" "${3}" "green" "${DEFAULT_COLOR_INVERTED}" "${go_version}" ""
}

###############################################################
# Node version
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
prompt_node_version() {
  local node_version=$(node -v 2>/dev/null)

  serialize_segment "$0" "" "$1" "$2" "${3}" "green" "${DEFAULT_COLOR_INVERTED}" "${node_version:1}" "NODE_ICON"
}

###############################################################
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

###############################################################
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
  serialize_segment "$0" "" "$1" "$2" "${3}" "${DEFAULT_COLOR}" "green" "${info}" "NODE_ICON"
}

###############################################################
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

###############################################################
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

###############################################################
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

###############################################################
# print PHP version number
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
prompt_php_version() {
  local php_version=$(php -v 2>&1 | grep -oe "^PHP\s*[0-9.]*")

  serialize_segment "$0" "" "$1" "$2" "${3}" "013" "${DEFAULT_COLOR_INVERTED}" "${php_version}" ""
}

###############################################################
# Symfony2-PHPUnit test ratio
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
prompt_symfony_tests() {
  local code_amount tests_amount
  # Careful! `ls` seems to now work correctly with NULL_GLOB,
  # as described here http://unix.stackexchange.com/a/26819
  # This is the reason, why we do not use NULL_GLOB here.
  code_amount=$({ls -1 src/**/*.php} 2> /dev/null | grep -vc Tests)
  tests_amount=$({ls -1 src/**/*.php} 2> /dev/null | grep -c Tests)

  build_test_stats "$1" "$0" "$2" "${3}" "$code_amount" "$tests_amount" "SF2" 'TEST_ICON' '[[ (-d src && -d app && -f app/AppKernel.php && -n "${CONTENT}") ]]'
}

###############################################################
# Symfony2-Version
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
prompt_symfony_version() {
  local version=""
  # Search for app/AppKernel.php as this file is pretty unique to symfony.
  for marked_folder in $(upsearch app/AppKernel.php); do
    if [[ "$marked_folder" == "/" ]]; then
      # If we reached root folder, stop upsearch.
      version=""
    elif [[ "$marked_folder" == "$HOME" ]]; then
      # If we reached home folder, stop upsearch.
      version=""
    else
      cd "$marked_folder" &>/dev/null
      version=$(php bin/console --version --no-ansi 2>/dev/null | grep -E "Symfony version [0-9.]+" | grep -o -E "[0-9.]+")
      cd - &>/dev/null
    fi
  done

  serialize_segment "$0" "" "$1" "$2" "${3}" "240" "$DEFAULT_COLOR" "${version}" "SYMFONY_ICON"
}

###############################################################
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

###############################################################
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

###############################################################
# Swift version
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
#   * $3 Joined: bool - If the segment should be joined
prompt_swift_version() {
  # Get the first number as this is probably the "main" version number..
  local swift_version=$(swift --version 2>/dev/null | grep -o -E "[0-9.]+" | head -n 1)

  serialize_segment "$0" "" "$1" "$2" "${3}" "magenta" "${DEFAULT_COLOR_INVERTED}" "${swift_version}" "SWIFT_ICON"
}

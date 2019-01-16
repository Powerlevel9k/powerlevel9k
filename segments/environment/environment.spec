#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUp() {
  export TERM="xterm-256color"
  # Load Powerlevel9k
  source powerlevel9k.zsh-theme
  source segments/environment.p9k
}

# ================================ #
# ============ MOCKS ============= #
# ================================ #


# @args
#   $1 string environment {local, dev, test, prod, other}
#   $2 integer custom, custom=1 -> is custom, custom=0 -> default
function mockHostname() {
    local ret='fake'

    case "$1" in
    'local')
        if [[ $2 == 1 ]]; then
            ret='house'
        else
            ret='local'
        fi
    ;;
    'dev')
        if [[ $2 == 1 ]]; then
            ret='develop'
        else
            ret='dev'
        fi
    ;;
    'test')
        if [[ $2 == 1 ]]; then
            ret='testing'
        else
            ret='test'
        fi
    ;;
    'prod')
        if [[ $2 == 1 ]]; then
            ret='production'
        else
            ret='prod'
        fi
    ;;
    'other')
        ret='fake'
    ;;
    esac

    echo $ret
}

# @args
#   $1 string environment {local, dev, test, prod, other}
#   $2 integer custom, custom=1 -> is custom, custom=0 -> default
function mockHostnameCommand() {
    local env="$1"
    local custom=$2
    local ret='func() {
      local ret='$(mockHostname "$env" $custom)';
      local alias="test";
      [[ "$1" == "-t" ]] && ret=$alias.$ret;
      echo $ret;
    }; func'

    echo $ret
}

# ================================ #
# ========== FUNCTIONS =========== #
# ================================ #

# @args
#   $1 string environment {local, dev, test, prod, other}
#   $2 integer custom, custom=1 -> is custom, custom=0 -> default
function getKey() {
    local ret='other'

    case "$1" in
    'local')
        if [[ $2 == 1 ]]; then
            ret='house'
        else
            ret='local'
        fi
    ;;
    'dev')
        if [[ $2 == 1 ]]; then
            ret='develop'
        else
            ret='dev'
        fi
    ;;
    'test')
        if [[ $2 == 1 ]]; then
            ret='testing'
        else
            ret='test'
        fi
    ;;
    'prod')
        if [[ $2 == 1 ]]; then
            ret='production'
        else
            ret='prod'
        fi
    ;;
    'other')
        ret='other'
    ;;
    esac

    echo $ret
}

# @args
#   $1 string environment {local, dev, test, prod, other}
#   $2 integer custom, custom=1 -> is custom, custom=0 -> default
function getValue() {
    local ret='other'

    case "$1" in
    'local')
        if [[ $2 == 1 ]]; then
            ret='House'
        else
            ret='Local'
        fi
    ;;
    'dev')
        if [[ $2 == 1 ]]; then
            ret='Develop'
        else
            ret='Dev'
        fi
    ;;
    'test')
        if [[ $2 == 1 ]]; then
            ret='Testing'
        else
            ret='Test'
        fi
    ;;
    'prod')
        if [[ $2 == 1 ]]; then
            ret='Production'
        else
            ret='Prod'
        fi
    ;;
    'other')
        if [[ $2 == 1 ]]; then
            ret='Fake'
        else
            ret='Other'
        fi
    ;;
    esac

    echo $ret
}

# @args
#   $1 string environment {local, dev, test, prod, other}
function getColorBackground() {
    case "$1" in
    'local')
        echo '074'
    ;;
    'dev')
        echo '070'
    ;;
    'test')
        echo '172'
    ;;
    'prod')
        echo '196'
    ;;
    'other')
        echo '203'
    ;;
    esac
}

# @args
#   $1 string environment {local, dev, test, prod, other}
function getColorForeground() {
    case "$1" in
    'local')
        echo '000'
    ;;
    'dev')
        echo '000'
    ;;
    'test')
        echo '000'
    ;;
    'prod')
        echo '000'
    ;;
    'other')
        echo '000'
    ;;
    esac
}

# @args
#   $1 string environment {local, dev, test, prod, other}
function getIcon() {
    case "$1" in
    'local')
        echo ''
    ;;
    'dev')
        echo ''
    ;;
    'test')
        echo ''
    ;;
    'prod')
        echo ''
    ;;
    'other')
        echo ''
    ;;
    esac
}

# @args
#   $1 string environment {local, dev, test, prod, other}
#   $2 integer custom, custom=1 -> is custom, custom=0 -> default
function getPrompAssert() {
  local env="$1"
  local custom=$2
  local background=$(getColorBackground $env)
  local foreground=$(getColorForeground $env)
  local icon=$(getIcon $env)
  local value=$(getValue $env $custom)

  local ret="%K{$background} %F{$foreground}$icon%f %F{$foreground}$value %k%F{$background}%f "

  echo $ret
}

# ================================ #
# ========= TEST DEFAULT ========= #
# ================================ #

function testDefaultLocalCase() {
  local env="local"
  local custom=0
  local -a P9K_LEFT_PROMPT_ELEMENTS
  local promptAssert=$(getPrompAssert $env $custom)

  alias hostname="$(mockHostnameCommand $env $custom)"

  P9K_LEFT_PROMPT_ELEMENTS=(environment)

  local __P9K_OS="Linux" # Fake Linux
  assertEquals "$promptAssert " "$(__p9k_build_left_prompt)"

  local __P9K_OS="OSX" # Fake OSX
  assertEquals "$promptAssert " "$(__p9k_build_left_prompt)"

  unalias hostname
  unset P9K_LEFT_PROMPT_ELEMENTS
}

function testDefaultDevCase() {
  local env="dev"
  local custom=0
  local -a P9K_LEFT_PROMPT_ELEMENTS
  local promptAssert=$(getPrompAssert $env $custom)

  alias hostname="$(mockHostnameCommand $env $custom)"

  P9K_LEFT_PROMPT_ELEMENTS=(environment)

  local __P9K_OS="Linux" # Fake Linux
  assertEquals "$promptAssert " "$(__p9k_build_left_prompt)"

  local __P9K_OS="OSX" # Fake OSX
  assertEquals "$promptAssert " "$(__p9k_build_left_prompt)"

  unalias hostname
  unset P9K_LEFT_PROMPT_ELEMENTS
}

function testDefaultTestCase() {
  local env="test"
  local custom=0
  local -a P9K_LEFT_PROMPT_ELEMENTS
  local promptAssert=$(getPrompAssert $env $custom)

  alias hostname="$(mockHostnameCommand $env $custom)"

  P9K_LEFT_PROMPT_ELEMENTS=(environment)

  local __P9K_OS="Linux" # Fake Linux
  assertEquals "$promptAssert " "$(__p9k_build_left_prompt)"

  local __P9K_OS="OSX" # Fake OSX
  assertEquals "$promptAssert " "$(__p9k_build_left_prompt)"

  unalias hostname
  unset P9K_LEFT_PROMPT_ELEMENTS
}

function testDefaultProdCase() {
  local env="prod"
  local custom=0
  local -a P9K_LEFT_PROMPT_ELEMENTS
  local promptAssert=$(getPrompAssert $env $custom)

  alias hostname="$(mockHostnameCommand $env $custom)"

  P9K_LEFT_PROMPT_ELEMENTS=(environment)

  local __P9K_OS="Linux" # Fake Linux
  assertEquals "$promptAssert " "$(__p9k_build_left_prompt)"

  local __P9K_OS="OSX" # Fake OSX
  assertEquals "$promptAssert " "$(__p9k_build_left_prompt)"

  unalias hostname
  unset P9K_LEFT_PROMPT_ELEMENTS
}

function testDefaultOtherCase() {
  local env="other"
  local custom=0
  local -a P9K_LEFT_PROMPT_ELEMENTS
  local promptAssert=$(getPrompAssert $env $custom)

  alias hostname="$(mockHostnameCommand $env $custom)"

  P9K_LEFT_PROMPT_ELEMENTS=(environment)

  local __P9K_OS="Linux" # Fake Linux
  assertEquals "$promptAssert " "$(__p9k_build_left_prompt)"

  local __P9K_OS="OSX" # Fake OSX
  assertEquals "$promptAssert " "$(__p9k_build_left_prompt)"

  unalias hostname
  unset P9K_LEFT_PROMPT_ELEMENTS
}

# ================================ #
# ========= TEST CUSTOM ========== #
# ================================ #

function testCustomLocalCase() {
  local env="local"
  local custom=1
  local -a P9K_LEFT_PROMPT_ELEMENTS
  local promptAssert=$(getPrompAssert $env $custom)

  alias hostname="$(mockHostnameCommand $env $custom)"

  eval P9K_ENVIRONMENT_KEY_${env:u}=$(getKey $env $custom)
  eval P9K_ENVIRONMENT_VALUE_${env:u}=$(getValue $env $custom)

  P9K_LEFT_PROMPT_ELEMENTS=(environment)

  local __P9K_OS="Linux" # Fake Linux
  assertEquals "$promptAssert " "$(__p9k_build_left_prompt)"

  local __P9K_OS="OSX" # Fake OSX
  assertEquals "$promptAssert " "$(__p9k_build_left_prompt)"

  unalias hostname
  unset P9K_LEFT_PROMPT_ELEMENTS
  unset P9K_ENVIRONMENT_KEY_${env:u}
  unset P9K_ENVIRONMENT_VALUE_${env:u}
}

function testCustomDevCase() {
  local env="dev"
  local custom=1
  local -a P9K_LEFT_PROMPT_ELEMENTS
  local promptAssert=$(getPrompAssert $env $custom)

  alias hostname="$(mockHostnameCommand $env $custom)"

  eval P9K_ENVIRONMENT_KEY_${env:u}=$(getKey $env $custom)
  eval P9K_ENVIRONMENT_VALUE_${env:u}=$(getValue $env $custom)

  P9K_LEFT_PROMPT_ELEMENTS=(environment)

  local __P9K_OS="Linux" # Fake Linux
  assertEquals "$promptAssert " "$(__p9k_build_left_prompt)"

  local __P9K_OS="OSX" # Fake OSX
  assertEquals "$promptAssert " "$(__p9k_build_left_prompt)"

  unalias hostname
  unset P9K_LEFT_PROMPT_ELEMENTS
  unset P9K_ENVIRONMENT_KEY_${env:u}
  unset P9K_ENVIRONMENT_VALUE_${env:u}
}

function testCustomTestCase() {
  local env="test"
  local custom=1
  local -a P9K_LEFT_PROMPT_ELEMENTS
  local promptAssert=$(getPrompAssert $env $custom)

  alias hostname="$(mockHostnameCommand $env $custom)"

  eval P9K_ENVIRONMENT_KEY_${env:u}=$(getKey $env $custom)
  eval P9K_ENVIRONMENT_VALUE_${env:u}=$(getValue $env $custom)

  P9K_LEFT_PROMPT_ELEMENTS=(environment)

  local __P9K_OS="Linux" # Fake Linux
  assertEquals "$promptAssert " "$(__p9k_build_left_prompt)"

  local __P9K_OS="OSX" # Fake OSX
  assertEquals "$promptAssert " "$(__p9k_build_left_prompt)"

  unalias hostname
  unset P9K_LEFT_PROMPT_ELEMENTS
  unset P9K_ENVIRONMENT_KEY_${env:u}
  unset P9K_ENVIRONMENT_VALUE_${env:u}
}

function testCustomProdCase() {
  local env="prod"
  local custom=1
  local -a P9K_LEFT_PROMPT_ELEMENTS
  local promptAssert=$(getPrompAssert $env $custom)

  alias hostname="$(mockHostnameCommand $env $custom)"

  eval P9K_ENVIRONMENT_KEY_${env:u}=$(getKey $env $custom)
  eval P9K_ENVIRONMENT_VALUE_${env:u}=$(getValue $env $custom)

  P9K_LEFT_PROMPT_ELEMENTS=(environment)

  local __P9K_OS="Linux" # Fake Linux
  assertEquals "$promptAssert " "$(__p9k_build_left_prompt)"

  local __P9K_OS="OSX" # Fake OSX
  assertEquals "$promptAssert " "$(__p9k_build_left_prompt)"

  unalias hostname
  unset P9K_LEFT_PROMPT_ELEMENTS
  unset P9K_ENVIRONMENT_KEY_${env:u}
  unset P9K_ENVIRONMENT_VALUE_${env:u}
}

function testCustomOtherCase() {
  local env="other"
  local custom=1
  local -a P9K_LEFT_PROMPT_ELEMENTS
  local promptAssert=$(getPrompAssert $env $custom)

  alias hostname="$(mockHostnameCommand $env $custom)"

  eval P9K_ENVIRONMENT_KEY_${env:u}=$(getKey $env $custom)
  eval P9K_ENVIRONMENT_VALUE_${env:u}=$(getValue $env $custom)

  P9K_LEFT_PROMPT_ELEMENTS=(environment)

  local __P9K_OS="Linux" # Fake Linux
  assertEquals "$promptAssert " "$(__p9k_build_left_prompt)"

  local __P9K_OS="OSX" # Fake OSX
  assertEquals "$promptAssert " "$(__p9k_build_left_prompt)"

  unalias hostname
  unset P9K_LEFT_PROMPT_ELEMENTS
  unset P9K_ENVIRONMENT_KEY_${env:u}
  unset P9K_ENVIRONMENT_VALUE_${env:u}
}

source shunit2/shunit2

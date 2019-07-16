#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUp() {
  export TERM="xterm-256color"

  P9K_HOME=$(pwd)
  ### Test specific
  # Create default folder and git init it.
  FOLDER=/tmp/powerlevel9k-test
  mkdir -p "${FOLDER}"
  cd $FOLDER

  local -a P9K_RIGHT_PROMPT_ELEMENTS
  P9K_RIGHT_PROMPT_ELEMENTS=()
  # Load Powerlevel9k
  source ${P9K_HOME}/powerlevel9k.zsh-theme
  source ${P9K_HOME}/segments/symfony2_version/symfony2_version.p9k
}

function tearDown() {
  # Go back to powerlevel9k folder
  cd "${P9K_HOME}"
  # Remove eventually created test-specific folder
  rm -fr "${FOLDER}"
  # At least remove test folder completely
  rm -fr /tmp/powerlevel9k-test
}

function testSymfonyVersionSegmentPrintsNothingIfPhpIsNotAvailable() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(symfony2_version custom_world)
  local P9K_CUSTOM_WORLD='echo world'
  alias php="nophp"

  assertEquals "%K{015} %F{000}\${(Q)\${:-\"world\"}} %k%F{015}%f " "$(__p9k_build_left_prompt)"

  unalias php
}

function testSymfonyVersionSegmentPrintsNothingIfSymfonyIsNotAvailable() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(symfony2_version custom_world)
  # "Symfony" is not a command, but rather a framework.
  # To sucessfully execute this test, we just need to
  # navigate into a folder that does not contain symfony.
  local P9K_CUSTOM_WORLD='echo world'

  assertEquals "%K{015} %F{000}\${(Q)\${:-\"world\"}} %k%F{015}%f " "$(__p9k_build_left_prompt)"
}

function testSymfonyVersionPrintsNothingIfPhpThrowsAnError() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(symfony2_version custom_world)
  local P9K_CUSTOM_WORLD='echo world'
  mkdir app
  touch app/AppKernel.php
  function php() {
    echo "Warning: Unsupported declare strict_types in /Users/dr/Privat/vendor/ocramius/proxy-manager/src/ProxyManager/Configuration.php on line 19

    Parse error: parse error, expecting `;´ or `{´ in /Users/dr/Privat/vendor/ocramius/proxy-manager/src/ProxyManager/Configuration.php on line 97"
  }

  assertEquals "%K{015} %F{000}\${(Q)\${:-\"world\"}} %k%F{015}%f " "$(__p9k_build_left_prompt)"

  unfunction php
}

function testSymfonyVersionSegmentWorks() {
  startSkipping # Skip test
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(symfony2_version)
  mkdir app
  touch app/AppKernel.php

  function php() {
    echo "Symfony version 3.1.4 - app/dev/debug"
  }

  assertEquals "%K{240} %F{000}SF%f %F{000}\${(Q)\${:-\"3.1.4\"}} %k%F{240}%f " "$(__p9k_build_left_prompt)"

  unfunction php
}

function testSymfonyVersionSegmentWorksInNestedFolder() {
  startSkipping # Skip test
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(symfony2_version)
  mkdir app
  touch app/AppKernel.php

  function php() {
    echo "Symfony version 3.1.4 - app/dev/debug"
  }

  mkdir -p src/P9K/AppBundle
  cd src/P9K/AppBundle

  assertEquals "%K{240} %F{000}SF%f %F{000}\${(Q)\${:-\"3.1.4\"}} %k%F{240}%f " "$(__p9k_build_left_prompt)"

  unfunction php
}

source shunit2/shunit2

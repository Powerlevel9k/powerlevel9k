#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUp() {
  export TERM="xterm-256color"
  # Load Powerlevel9k
  source powerlevel9k.zsh-theme

  # Initialize icon overrides
  _powerlevel9kInitializeIconOverrides

  # Precompile the Segment Separators here!
  _POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR="$(print_icon 'LEFT_SEGMENT_SEPARATOR')"
  _POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR="$(print_icon 'LEFT_SUBSEGMENT_SEPARATOR')"
  _POWERLEVEL9K_LEFT_SEGMENT_END_SEPARATOR="$(print_icon 'LEFT_SEGMENT_END_SEPARATOR')"
  _POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR="$(print_icon 'RIGHT_SEGMENT_SEPARATOR')"
  _POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR="$(print_icon 'RIGHT_SUBSEGMENT_SEPARATOR')"

  # Disable TRAP, so that we have more control how the segment is build,
  # as shUnit does not work with async commands.
  trap WINCH

  P9K_HOME=$(pwd)
  ### Test specific
  # Create default folder and git init it.
  FOLDER=/tmp/powerlevel9k-test
  mkdir -p "${FOLDER}"
  cd $FOLDER
}

function tearDown() {
  # Go back to powerlevel9k folder
  cd "${P9K_HOME}"
  # Remove eventually created test-specific folder
  rm -fr "${FOLDER}"
  # At least remove test folder completely
  rm -fr /tmp/powerlevel9k-test
  p9k_clear_cache
}

function testSymfonyVersionSegmentPrintsNothingIfPhpIsNotAvailable() {
    alias php="nophp"
    POWERLEVEL9K_CUSTOM_WORLD='echo world'

    prompt_custom "left" "2" "world" "false"
    prompt_symfony_version "left" "1" "false"
    p9k_build_prompt_from_cache

    assertEquals "%K{white} %F{black}world %k%F{white}%f " "${PROMPT}"

    unset POWERLEVEL9K_CUSTOM_WORLD
    unalias php
}

function testSymfonyVersionSegmentPrintsNothingIfSymfonyIsNotAvailable() {
    # "Symfony" is not a command, but rather a framework.
    # To sucessfully execute this test, we just need to
    # navigate into a folder that does not contain symfony.
    POWERLEVEL9K_CUSTOM_WORLD='echo world'

    prompt_custom "left" "2" "world" "false"
    prompt_symfony_version "left" "1" "false"
    p9k_build_prompt_from_cache

    assertEquals "%K{white} %F{black}world %k%F{white}%f " "${PROMPT}"

    unset POWERLEVEL9K_CUSTOM_WORLD
}

function testSymfonyVersionPrintsNothingIfPhpThrowsAnError() {
    mkdir app
    touch app/AppKernel.php
    function php() {
        echo "Warning: Unsupported declare strict_types in /Users/dr/Privat/vendor/ocramius/proxy-manager/src/ProxyManager/Configuration.php on line 19

        Parse error: parse error, expecting `;´ or `{´ in /Users/dr/Privat/vendor/ocramius/proxy-manager/src/ProxyManager/Configuration.php on line 97"
    }
    POWERLEVEL9K_CUSTOM_WORLD='echo world'

    prompt_custom "left" "2" "world" "false"
    prompt_symfony_version "left" "1" "false"
    p9k_build_prompt_from_cache

    assertEquals "%K{white} %F{black}world %k%F{white}%f " "${PROMPT}"

    unset POWERLEVEL9K_CUSTOM_WORLD
    unfunction php
}

function testSymfonyVersionSegmentWorks() {
    mkdir app
    touch app/AppKernel.php

    function php() {
        echo "Symfony version 3.1.4 - app/dev/debug"
    }

    prompt_symfony_version "left" "1" "false"
    p9k_build_prompt_from_cache

    assertEquals "%K{240} %F{black%}SF%f %F{black}3.1.4 %k%F{240}%f " "${PROMPT}"

    unfunction php
}

function testSymfonyVersionSegmentWorksInNestedFolder() {
    mkdir app
    touch app/AppKernel.php
    
    function php() {
        echo "Symfony version 3.1.4 - app/dev/debug"
    }

    mkdir -p src/P9K/AppBundle
    cd src/P9K/AppBundle

    prompt_symfony_version "left" "1" "false"
    p9k_build_prompt_from_cache

    assertEquals "%K{240} %F{black%}SF%f %F{black}3.1.4 %k%F{240}%f " "${PROMPT}"

    unfunction php
}

source shunit2/source/2.1/src/shunit2
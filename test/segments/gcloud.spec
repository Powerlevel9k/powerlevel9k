#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUp() {
  export TERM="xterm-256color"
  export OLDHOME=$HOME
  export HOME="/tmp/powerlevel9k-test"
  mkdir -p /tmp/powerlevel9k-test/.config/gcloud/
}

function tearDown() {
  export HOME=$OLDHOME
  rm -fr /tmp/powerlevel9k-test
}

function testGcloudEnvSegmentPrintsNothingIfNoGcloudEnvironmentIsSet() {
    local POWERLEVEL9K_CUSTOM_WORLD='echo world'
    local -a POWERLEVEL9K_LEFT_PROMPT_ELEMENTS
    POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(gcloud custom_world)

    # Load Powerlevel9k
    source powerlevel9k.zsh-theme

    assertEquals "%K{007} %F{000}world %k%F{007}%f " "$(build_left_prompt)"
}

function testGcloudEnvSegmentWorksIfGcloudEnvironmentIsSet() {
    local -a POWERLEVEL9K_LEFT_PROMPT_ELEMENTS
    POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(gcloud)

    # Load Powerlevel9k
    source powerlevel9k.zsh-theme

    echo "test-profile" > /tmp/powerlevel9k-test/.config/gcloud/active_config
    cd /tmp/powerlevel9k-test

    assertEquals "%K{001} %F{007}test-profile %k%F{001}%f " "$(build_left_prompt)"

    cd -
}

source shunit2/shunit2

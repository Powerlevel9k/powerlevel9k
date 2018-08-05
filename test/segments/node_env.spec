#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUp() {
  export TERM="xterm-256color"

  # Load Powerlevel9k
  source powerlevel9k.zsh-theme
  source segments/node_env.p9k

  # Test specfic
  # unset all possible user specified variables
  unset NODE_VIRTUAL_ENV_DISABLE_PROMPT
  unset NODE_VIRTUAL_ENV
}

function testNodeenvSegmentPrintsNothingWithoutNode() {
    local -a P9K_LEFT_PROMPT_ELEMENTS
    P9K_LEFT_PROMPT_ELEMENTS=(node_env custom_world)
    local P9K_CUSTOM_WORLD='echo world'
    p9k::register_segment "WORLD"
    alias node="nonode 2>/dev/null"

    assertEquals "%K{white} %F{black}world %k%F{white}%f " "$(__p9k_build_left_prompt)"

    unalias node
}

function testNodeenvSegmentPrintsNothingIfNodeVirtualEnvIsNotSet() {
    local -a P9K_LEFT_PROMPT_ELEMENTS
    P9K_LEFT_PROMPT_ELEMENTS=(node_env custom_world)
    local P9K_CUSTOM_WORLD='echo world'
    p9k::register_segment "WORLD"
    node() {
        echo "v1.2.3"
    }

    assertEquals "%K{white} %F{black}world %k%F{white}%f " "$(__p9k_build_left_prompt)"

    unfunction node
}

function testNodeenvSegmentPrintsNothingIfNodeVirtualEnvDisablePromptIsSet() {
    local -a P9K_LEFT_PROMPT_ELEMENTS
    P9K_LEFT_PROMPT_ELEMENTS=(node_env custom_world)
    local P9K_CUSTOM_WORLD='echo world'
    p9k::register_segment "WORLD"
    node() {
        echo "v1.2.3"
    }
    NODE_VIRTUAL_ENV="node-env"
    NODE_VIRTUAL_ENV_DISABLE_PROMPT=true

    assertEquals "%K{white} %F{black}world %k%F{white}%f " "$(__p9k_build_left_prompt)"

    unset NODE_VIRTUAL_ENV_DISABLE_PROMPT
    unset NODE_VIRTUAL_ENV
    unfunction node
}

function testNodeenvSegmentPrintsAtLeastNodeEnvWithoutNode() {
    local -a P9K_LEFT_PROMPT_ELEMENTS
    P9K_LEFT_PROMPT_ELEMENTS=(node_env)
    alias node="nonode 2>/dev/null"
    NODE_VIRTUAL_ENV="node-env"

    assertEquals "%K{black} %F{green}⬢ %f%F{green}[node-env] %k%F{black}%f " "$(__p9k_build_left_prompt)"

    unset NODE_VIRTUAL_ENV
    unalias node
}

function testNodeenvSegmentWorks() {
    local -a P9K_LEFT_PROMPT_ELEMENTS
    P9K_LEFT_PROMPT_ELEMENTS=(node_env)
    node() {
        echo "v1.2.3"
    }
    NODE_VIRTUAL_ENV="node-env"

    assertEquals "%K{black} %F{green}⬢ %f%F{green}v1.2.3[node-env] %k%F{black}%f " "$(__p9k_build_left_prompt)"

    unfunction node
    unset NODE_VIRTUAL_ENV
}

source shunit2/shunit2

#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUp() {
  export TERM="xterm-256color"

  # Test specfic
  # unset all possible user specified variables
  unset NODE_VIRTUAL_ENV_DISABLE_PROMPT
  unset NODE_VIRTUAL_ENV
}

function testNodeenvSegmentPrintsNothingWithoutNode() {
    local -a P9K_LEFT_PROMPT_ELEMENTS
    P9K_LEFT_PROMPT_ELEMENTS=(nodeenv custom_world)
    local P9K_CUSTOM_WORLD='echo world'
    alias node="nonode 2>/dev/null"

    # Load Powerlevel9k
    source powerlevel9k.zsh-theme

    assertEquals "%K{white} %F{black}world %k%F{white}%f " "$(buildLeftPrompt)"

    unalias node
}

function testNodeenvSegmentPrintsNothingIfNodeVirtualEnvIsNotSet() {
    local -a P9K_LEFT_PROMPT_ELEMENTS
    P9K_LEFT_PROMPT_ELEMENTS=(nodeenv custom_world)
    local P9K_CUSTOM_WORLD='echo world'
    node() {
        echo "v1.2.3"
    }

    # Load Powerlevel9k
    source powerlevel9k.zsh-theme

    assertEquals "%K{white} %F{black}world %k%F{white}%f " "$(buildLeftPrompt)"

    unfunction node
}

function testNodeenvSegmentPrintsNothingIfNodeVirtualEnvDisablePromptIsSet() {
    local -a P9K_LEFT_PROMPT_ELEMENTS
    P9K_LEFT_PROMPT_ELEMENTS=(nodeenv custom_world)
    local P9K_CUSTOM_WORLD='echo world'
    node() {
        echo "v1.2.3"
    }
    NODE_VIRTUAL_ENV="node-env"
    NODE_VIRTUAL_ENV_DISABLE_PROMPT=true

    # Load Powerlevel9k
    source powerlevel9k.zsh-theme

    assertEquals "%K{white} %F{black}world %k%F{white}%f " "$(buildLeftPrompt)"

    unset NODE_VIRTUAL_ENV_DISABLE_PROMPT
    unset NODE_VIRTUAL_ENV
    unfunction node
}

function testNodeenvSegmentPrintsAtLeastNodeEnvWithoutNode() {
    local -a P9K_LEFT_PROMPT_ELEMENTS
    P9K_LEFT_PROMPT_ELEMENTS=(nodeenv)
    alias node="nonode 2>/dev/null"
    NODE_VIRTUAL_ENV="node-env"

    # Load Powerlevel9k
    source powerlevel9k.zsh-theme

    assertEquals "%K{black} %F{green%}⬢ %f%F{green}[node-env] %k%F{black}%f " "$(buildLeftPrompt)"

    unset NODE_VIRTUAL_ENV
    unalias node
}

function testNodeenvSegmentWorks() {
    local -a P9K_LEFT_PROMPT_ELEMENTS
    P9K_LEFT_PROMPT_ELEMENTS=(nodeenv)
    node() {
        echo "v1.2.3"
    }
    NODE_VIRTUAL_ENV="node-env"

    # Load Powerlevel9k
    source powerlevel9k.zsh-theme

    assertEquals "%K{black} %F{green%}⬢ %f%F{green}v1.2.3[node-env] %k%F{black}%f " "$(buildLeftPrompt)"

    unfunction node
    unset NODE_VIRTUAL_ENV
}

source shunit2/source/2.1/src/shunit2
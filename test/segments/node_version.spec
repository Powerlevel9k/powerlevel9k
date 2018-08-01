#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUp() {
  export TERM="xterm-256color"
  # Load Powerlevel9k
  source powerlevel9k.zsh-theme
  source segments/node_version.p9k
}

function testNodeVersionSegmentPrintsNothingWithoutNode() {
    local -a P9K_LEFT_PROMPT_ELEMENTS
    P9K_LEFT_PROMPT_ELEMENTS=(node_version custom_world)
    local P9K_CUSTOM_WORLD='echo world'
    registerSegment "WORLD"
    alias node="nonode 2>/dev/null"

    assertEquals "%K{white} %F{black}world %k%F{white}%f " "$(buildLeftPrompt)"

    unalias node
}

function testNodeVersionSegmentWorks() {
    local -a P9K_LEFT_PROMPT_ELEMENTS
    P9K_LEFT_PROMPT_ELEMENTS=(node_version)
    node() {
        echo "v1.2.3"
    }

    assertEquals "%K{green} %F{white}⬢ %f%F{white}1.2.3 %k%F{green}%f " "$(buildLeftPrompt)"

    unfunction node
}

source shunit2/source/2.1/src/shunit2

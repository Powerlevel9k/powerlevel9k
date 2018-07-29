#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUp() {
  export TERM="xterm-256color"
  source powerlevel9k.zsh-theme
}

function testAnacondaSegmentPrintsNothingIfNoAnacondaPathIsSet() {
    local P9K_CUSTOM_WORLD='echo world'
    registerSegment "WORLD"
    local -a P9K_LEFT_PROMPT_ELEMENTS
    P9K_LEFT_PROMPT_ELEMENTS=(anaconda custom_world)

    # Load Powerlevel9k
    source segments/anaconda.p9k

    # Unset anacona variables
    unset CONDA_ENV_PATH
    unset CONDA_PREFIX

    assertEquals "%K{white} %F{black}world %k%F{white}%f " "$(buildLeftPrompt)"
}

function testAnacondaSegmentWorksIfOnlyAnacondaPathIsSet() {
    local -a P9K_LEFT_PROMPT_ELEMENTS
    P9K_LEFT_PROMPT_ELEMENTS=(anaconda)
    local P9K_ANACONDA_ICON="*icon-here"

    # Load Powerlevel9k
    source segments/anaconda.p9k

    CONDA_ENV_PATH=/tmp
    unset CONDA_PREFIX

    assertEquals "%K{blue} %F{black}*icon-here %f%F{black}(tmp) %k%F{blue}%f " "$(buildLeftPrompt)"
}

function testAnacondaSegmentWorksIfOnlyAnacondaPrefixIsSet() {
    local -a P9K_LEFT_PROMPT_ELEMENTS
    P9K_LEFT_PROMPT_ELEMENTS=(anaconda)
    local P9K_ANACONDA_ICON="*icon-here"

    # Load Powerlevel9k
    source segments/anaconda.p9k

    unset CONDA_ENV_PATH
    local CONDA_PREFIX="test"

    assertEquals "%K{blue} %F{black}*icon-here %f%F{black}(test) %k%F{blue}%f " "$(buildLeftPrompt)"
}

function testAnacondaSegmentWorks() {
    local -a P9K_LEFT_PROMPT_ELEMENTS
    P9K_LEFT_PROMPT_ELEMENTS=(anaconda)
    local P9K_ANACONDA_ICON="*icon-here"

    # Load Powerlevel9k
    source segments/anaconda.p9k

    local CONDA_ENV_PATH=/tmp
    local CONDA_PREFIX="test"

    assertEquals "%K{blue} %F{black}*icon-here %f%F{black}(tmptest) %k%F{blue}%f " "$(buildLeftPrompt)"
}

source shunit2/source/2.1/src/shunit2

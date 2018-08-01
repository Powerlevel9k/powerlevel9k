#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUp() {
  export TERM="xterm-256color"

  # Load Powerlevel9k
  source powerlevel9k.zsh-theme
}

function testCustomDirectOutputSegment() {
    local -a P9K_LEFT_PROMPT_ELEMENTS
    P9K_LEFT_PROMPT_ELEMENTS=(custom_world)
    local P9K_CUSTOM_WORLD="echo world"
  registerSegment "WORLD"
    registerSegment "WORLD"

    assertEquals "%K{white} %F{black}world %k%F{white}%f " "$(buildLeftPrompt)"
}

function testCustomClosureSegment() {
    local -a P9K_LEFT_PROMPT_ELEMENTS
    P9K_LEFT_PROMPT_ELEMENTS=(custom_world)
    function p9k_hello_world() {
        echo "world"
    }
    local P9K_CUSTOM_WORLD='p9k_hello_world'
  registerSegment "WORLD"
    registerSegment "WORLD"

    assertEquals "%K{white} %F{black}world %k%F{white}%f " "$(buildLeftPrompt)"
}

function testSettingBackgroundForCustomSegment() {
    local -a P9K_LEFT_PROMPT_ELEMENTS
    P9K_LEFT_PROMPT_ELEMENTS=(custom_world)
    local P9K_CUSTOM_WORLD="echo world"
  registerSegment "WORLD"
    local P9K_WORLD_BACKGROUND="yellow"
    registerSegment "WORLD"

    assertEquals "%K{yellow} %F{black}world %k%F{yellow}%f " "$(buildLeftPrompt)"
}

function testSettingForegroundForCustomSegment() {
    local -a P9K_LEFT_PROMPT_ELEMENTS
    P9K_LEFT_PROMPT_ELEMENTS=(custom_world)
    local P9K_CUSTOM_WORLD="echo world"
  registerSegment "WORLD"
    local P9K_WORLD_FOREGROUND="red"
    registerSegment "WORLD"

    assertEquals "%K{white} %F{red}world %k%F{white}%f " "$(buildLeftPrompt)"
}

function testSettingVisualIdentifierForCustomSegment() {
    local -a P9K_LEFT_PROMPT_ELEMENTS
    P9K_LEFT_PROMPT_ELEMENTS=(custom_world)
    local P9K_CUSTOM_WORLD="echo world"
  registerSegment "WORLD"
    local P9K_WORLD_ICON="*hw"
    registerSegment "WORLD"

    assertEquals "%K{white} %F{black}*hw %f%F{black}world %k%F{white}%f " "$(buildLeftPrompt)"
}

function testSettingVisualIdentifierForegroundColorForCustomSegment() {
    local -a P9K_LEFT_PROMPT_ELEMENTS
    P9K_LEFT_PROMPT_ELEMENTS=(custom_world)
    local P9K_CUSTOM_WORLD="echo world"
  registerSegment "WORLD"
    local P9K_WORLD_ICON="*hw"
    local P9K_WORLD_ICON_COLOR="red"
    registerSegment "WORLD"

    assertEquals "%K{white} %F{red}*hw %f%F{black}world %k%F{white}%f " "$(buildLeftPrompt)"
}

source shunit2/source/2.1/src/shunit2

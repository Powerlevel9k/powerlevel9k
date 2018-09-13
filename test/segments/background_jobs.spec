#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUp() {
  export TERM="xterm-256color"
}

function testBackgroundJobsSegmentPrintsNothingWithoutBackgroundJobs() {
    local P9K_CUSTOM_WORLD='echo world'
    local -a P9K_LEFT_PROMPT_ELEMENTS
    P9K_LEFT_PROMPT_ELEMENTS=(background_jobs custom_world)
    alias jobs="nojobs 2>/dev/null"

    # Load Powerlevel9k
    source powerlevel9k.zsh-theme

    assertEquals "%K{007} %F{000}world %k%F{007}%f " "$(__p9k_build_left_prompt)"

    unalias jobs
}

function testBackgroundJobsSegmentWorksWithOneBackgroundJob() {
    unset P9K_BACKGROUND_JOBS_VERBOSE
    local -a P9K_LEFT_PROMPT_ELEMENTS
    P9K_LEFT_PROMPT_ELEMENTS=(background_jobs)
    jobs() {
        echo '[1]  + 30444 suspended  nvim xx'
    }

    # Load Powerlevel9k
    source powerlevel9k.zsh-theme

    assertEquals "%K{000} %F{006}⚙%f %k%F{000}%f " "$(__p9k_build_left_prompt)"

    unfunction jobs
}

function testBackgroundJobsSegmentWorksWithMultipleBackgroundJobs() {
    local P9K_BACKGROUND_JOBS_VERBOSE=false
    local -a P9K_LEFT_PROMPT_ELEMENTS
    P9K_LEFT_PROMPT_ELEMENTS=(background_jobs)
    jobs() {
        echo "[1]    31190 suspended  nvim xx"
        echo "[2]  - 31194 suspended  nvim xx2"
        echo "[3]  + 31206 suspended  nvim xx3"
    }

    # Load Powerlevel9k
    source powerlevel9k.zsh-theme

    assertEquals "%K{000} %F{006}⚙%f %k%F{000}%f " "$(__p9k_build_left_prompt)"

    unfunction jobs
}

function testBackgroundJobsSegmentWithVerboseMode() {
    local P9K_BACKGROUND_JOBS_VERBOSE=true
    local -a P9K_LEFT_PROMPT_ELEMENTS
    P9K_LEFT_PROMPT_ELEMENTS=(background_jobs)
    jobs() {
        echo "[1]    31190 suspended  nvim xx"
        echo "[2]  - 31194 suspended  nvim xx2"
        echo "[3]  + 31206 suspended  nvim xx3"
    }

    # Load Powerlevel9k
    source powerlevel9k.zsh-theme

    assertEquals "%K{000} %F{006}⚙ %f%F{006}3 %k%F{000}%f " "$(__p9k_build_left_prompt)"

    unfunction jobs
}

source shunit2/shunit2
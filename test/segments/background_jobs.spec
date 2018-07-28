#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUp() {
  export TERM="xterm-256color"
  source powerlevel9k.zsh-theme
}

function testBackgroundJobsSegmentPrintsNothingWithoutBackgroundJobs() {
    local P9K_CUSTOM_WORLD='echo world'
    registerSegment "WORLD"
    local -a P9K_LEFT_PROMPT_ELEMENTS
    P9K_LEFT_PROMPT_ELEMENTS=(background_jobs custom_world)
    alias jobs="nojobs 2>/dev/null"

    # Load Powerlevel9k
    source segments/background_jobs.p9k

    assertEquals "%K{white} %F{black}world %k%F{white}%f " "$(buildLeftPrompt)"

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
    source segments/background_jobs.p9k

    assertEquals "%K{black} %F{cyan%}⚙%f %k%F{black}%f " "$(buildLeftPrompt)"

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
    source segments/background_jobs.p9k

    assertEquals "%K{black} %F{cyan%}⚙%f %k%F{black}%f " "$(buildLeftPrompt)"

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
    source segments/background_jobs.p9k

    assertEquals "%K{black} %F{cyan}⚙ %f%F{cyan}3 %k%F{black}%f " "$(buildLeftPrompt)"

    unfunction jobs
}

source shunit2/source/2.1/src/shunit2

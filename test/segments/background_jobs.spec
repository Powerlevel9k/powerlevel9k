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
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(background_jobs custom_world)

  # Load Powerlevel9k
  source segments/background_jobs.p9k

  assertEquals "%K{015} %F{000}world %k%F{015}%f " "$(__p9k_build_left_prompt)"
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

  assertEquals "%K{000} %F{006}⚙ %f%F{006}%k%F{000}%f " "$(__p9k_build_left_prompt)"

  unfunction jobs
}

function testBackgroundJobsSegmentWorksWithMultipleBackgroundJobs() {
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

  assertEquals "%K{000} %F{006}⚙ %f%F{006}3 %k%F{000}%f " "$(__p9k_build_left_prompt)"
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

    assertEquals "%K{000} %F{006}⚙ %f%F{006}3 %k%F{000}%f " "$(__p9k_build_left_prompt)"

    unfunction jobs
}

source shunit2/shunit2

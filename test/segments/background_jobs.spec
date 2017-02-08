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
}

function tearDown() {
    p9k_clear_cache
}

function testBackgroundJobsSegmentPrintsNothingWithoutBackgroundJobs() {
    POWERLEVEL9K_CUSTOM_WORLD='echo world'
    alias jobs="nojobs 2>/dev/null"

    prompt_custom "left" "2" "world" "false"
    prompt_background_jobs "left" "1" "false"
    p9k_build_prompt_from_cache

    assertEquals "%K{white} %F{black}world %k%F{white}%f " "${PROMPT}"

    unset POWERLEVEL9K_CUSTOM_WORLD
    unalias jobs
}

function testBackgroundJobsSegmentWorksWithOneBackgroundJob() {
    unset POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE
    jobs() {
        echo '[1]  + 30444 suspended  nvim xx'
    }

    prompt_background_jobs "left" "1" "false"
    p9k_build_prompt_from_cache

    assertEquals "%K{black} %F{cyan%}⚙%f%F{cyan} %k%F{black}%f " "${PROMPT}"

    unfunction jobs
}

function testBackgroundJobsSegmentWorksWithMultipleBackgroundJobs() {
    unset POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE
    jobs() {
        echo "[1]    31190 suspended  nvim xx"
        echo "[2]  - 31194 suspended  nvim xx2"
        echo "[3]  + 31206 suspended  nvim xx3"
    }

    prompt_background_jobs "left" "1" "false"
    p9k_build_prompt_from_cache

    assertEquals "%K{black} %F{cyan%}⚙%f%F{cyan} %k%F{black}%f " "${PROMPT}"

    unfunction jobs
}

function testBackgroundJobsSegmentWithVerboseMode() {
    POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE=true
    jobs() {
        echo "[1]    31190 suspended  nvim xx"
        echo "[2]  - 31194 suspended  nvim xx2"
        echo "[3]  + 31206 suspended  nvim xx3"
    }

    prompt_background_jobs "left" "1" "false"
    p9k_build_prompt_from_cache

    assertEquals "%K{black} %F{cyan%}⚙%f %F{cyan}3 %k%F{black}%f " "${PROMPT}"

    unfunction jobs
    unset POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE
}

source shunit2/source/2.1/src/shunit2
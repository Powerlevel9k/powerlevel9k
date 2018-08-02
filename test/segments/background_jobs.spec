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
  p9k::register_segment "WORLD"
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(background_jobs custom_world)
  local jobs_running=0
  local jobs_suspended=0

  # Load Powerlevel9k
  source segments/background_jobs.p9k

  assertEquals "%K{white} %F{black}world %k%F{white}%f " "$(__p9k_build_left_prompt)"
}

function testBackgroundJobsSegmentVerboseAlwaysPrintsZeroWithoutBackgroundJobs() {
  local P9K_BACKGROUND_JOBS_VERBOSE_ALWAYS=true
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(background_jobs)
  local jobs_running=0
  local jobs_suspended=0

  # Load Powerlevel9k
  source segments/background_jobs.p9k

  assertEquals "%K{black} %F{cyan}⚙ %f%F{cyan}0 %k%F{black}%f " "$(__p9k_build_left_prompt)"
}

function testBackgroundJobsSegmentWorksWithOneBackgroundJob() {
  local P9K_BACKGROUND_JOBS_VERBOSE=false
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(background_jobs)
  local jobs_running=0
  local jobs_suspended=1

  # Load Powerlevel9k
  source segments/background_jobs.p9k
  assertEquals "%K{black} %F{cyan}⚙ %f%F{cyan}%k%F{black}%f " "$(__p9k_build_left_prompt)"
}

function testBackgroundJobsSegmentWorksWithMultipleBackgroundJobs() {
  local P9K_BACKGROUND_JOBS_VERBOSE=true
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(background_jobs)
  local jobs_running=0
  local jobs_suspended=3

  # Load Powerlevel9k
  source segments/background_jobs.p9k

  assertEquals "%K{black} %F{cyan}⚙ %f%F{cyan}3 %k%F{black}%f " "$(__p9k_build_left_prompt)"
}

function testBackgroundJobsSegmentWorksWithExpandedMode() {
  local P9K_BACKGROUND_JOBS_VERBOSE=true
  local P9K_BACKGROUND_JOBS_EXPANDED=true
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(background_jobs)
  local jobs_running=1
  local jobs_suspended=2

  # Load Powerlevel9k
  source segments/background_jobs.p9k

  assertEquals "%K{black} %F{cyan}⚙ %f%F{cyan}1r 2s %k%F{black}%f " "$(__p9k_build_left_prompt)"
}

source shunit2/source/2.1/src/shunit2

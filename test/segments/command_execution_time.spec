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

function testCommandExecutionTimeIsNotShownIfTimeIsBelowThreshold() {
  POWERLEVEL9K_CUSTOM_WORLD='echo world'
  _P9K_COMMAND_DURATION=2

  prompt_custom "left" "2" "world" "false"
  prompt_command_execution_time "left" "1" "false"
  p9k_build_prompt_from_cache 0

  assertEquals "%K{white} %F{black}world %k%F{white}%f " "${PROMPT}"

  unset POWERLEVEL9K_CUSTOM_WORLD
  unset _P9K_COMMAND_DURATION
}

function testCommandExecutionTimeThresholdCouldBeChanged() {
  POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=1
  _P9K_COMMAND_DURATION=2.03

  prompt_command_execution_time "left" "1" "false"
  p9k_build_prompt_from_cache 0

  assertEquals "%K{red} %F{226%}Dur%f %F{226}2.03 %k%F{red}%f " "${PROMPT}"

  unset _P9K_COMMAND_DURATION
  unset POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD
}

function testCommandExecutionTimeThresholdCouldBeSetToZero() {
  POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=0
  _P9K_COMMAND_DURATION=0.03

  prompt_command_execution_time "left" "1" "false"
  p9k_build_prompt_from_cache 0

  assertEquals "%K{red} %F{226%}Dur%f %F{226}0.03 %k%F{red}%f " "${PROMPT}"

  unset _P9K_COMMAND_DURATION
  unset POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD
}

function testCommandExecutionTimePrecisionCouldBeChanged() {
  POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=0
  POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=4
  _P9K_COMMAND_DURATION=0.0001

  prompt_command_execution_time "left" "1" "false"
  p9k_build_prompt_from_cache 0

  assertEquals "%K{red} %F{226%}Dur%f %F{226}0.0001 %k%F{red}%f " "${PROMPT}"

  unset _P9K_COMMAND_DURATION
  unset POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION
  unset POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD
}

function testCommandExecutionTimePrecisionCouldBeSetToZero() {
  POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0
  _P9K_COMMAND_DURATION=23.5001

  prompt_command_execution_time "left" "1" "false"
  p9k_build_prompt_from_cache 0

  assertEquals "%K{red} %F{226%}Dur%f %F{226}23 %k%F{red}%f " "${PROMPT}"

  unset _P9K_COMMAND_DURATION
  unset POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION
}

function testCommandExecutionTimeIsFormattedHumandReadbleForMinuteLongCommand() {
  _P9K_COMMAND_DURATION=180

  prompt_command_execution_time "left" "1" "false"
  p9k_build_prompt_from_cache 0

  assertEquals "%K{red} %F{226%}Dur%f %F{226}03:00 %k%F{red}%f " "${PROMPT}"

  unset _P9K_COMMAND_DURATION
}

function testCommandExecutionTimeIsFormattedHumandReadbleForHourLongCommand() {
  _P9K_COMMAND_DURATION=7200

  prompt_command_execution_time "left" "1" "false"
  p9k_build_prompt_from_cache 0

  assertEquals "%K{red} %F{226%}Dur%f %F{226}02:00:00 %k%F{red}%f " "${PROMPT}"

  unset _P9K_COMMAND_DURATION
}

source shunit2/source/2.1/src/shunit2
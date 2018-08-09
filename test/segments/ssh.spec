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

function testSshSegmentPrintsNothingIfNoSshConnection() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(ssh custom_world)
  local P9K_CUSTOM_WORLD='echo "world"'
  p9k::register_segment "WORLD"
  local P9K_SSH_ICON="*ssh-icon"
  source segments/ssh.p9k
  # Weak test: Emulate No SSH connection by unsetting
  # ${SSH_CLIENT} and $SSH_TTY
  unset SSH_CLIENT
  unset SSH_TTY

  assertEquals "%K{015} %F{000}world %k%F{015}%f " "$(__p9k_build_left_prompt)"
}

function testSshSegmentWorksIfOnlySshClientIsSet() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(ssh)
  local P9K_SSH_ICON="*ssh-icon"
  source segments/ssh.p9k
  # Weak test: Emulate No SSH connection by unsetting
  # ${SSH_CLIENT} and $SSH_TTY
  SSH_CLIENT='ssh-client'
  unset SSH_TTY

  assertEquals "%K{000} %F{003}*ssh-icon %f%F{003}%k%F{000}%f " "$(__p9k_build_left_prompt)"

  unset SSH_CLIENT
}

function testSshSegmentWorksIfOnlySshTtyIsSet() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(ssh)
  local P9K_SSH_ICON="*ssh-icon"
  source segments/ssh.p9k
  # Weak test: Emulate No SSH connection by unsetting
  # ${SSH_CLIENT} and $SSH_TTY
  SSH_TTY='ssh-tty'
  unset SSH_CLIENT

  assertEquals "%K{000} %F{003}*ssh-icon %f%F{003}%k%F{000}%f " "$(__p9k_build_left_prompt)"

  unset SSH_TTY
}

function testSshSegmentWorksIfAllNecessaryVariablesAreSet() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(ssh)
  local P9K_SSH_ICON="*ssh-icon"
  source segments/ssh.p9k
  # Weak test: Emulate No SSH connection by unsetting
  # ${SSH_CLIENT} and $SSH_TTY
  SSH_CLIENT='ssh-client'
  SSH_TTY='ssh-tty'

  assertEquals "%K{000} %F{003}*ssh-icon %f%F{003}%k%F{000}%f " "$(__p9k_build_left_prompt)"

  unset SSH_TTY
  unset SSH_CLIENT
}

source shunit2/shunit2

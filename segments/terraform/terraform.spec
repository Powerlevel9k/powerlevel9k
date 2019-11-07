#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUp() {
  export TERM="xterm-256color"
  local -a P9K_RIGHT_PROMPT_ELEMENTS
  P9K_RIGHT_PROMPT_ELEMENTS=()
  # Load Powerlevel9k
  source powerlevel9k.zsh-theme
  source segments/terraform/terraform.p9k
}

function testTerraformEnvironment() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(terraform)

  # Setup mock data, there is a .terraform/environment file showing the selected
  # environment/workspace so we will key off of that as its faster than running
  # a 'terraform workspace list'
  if [ -d '.terraform' ]; then
    echo "Bailing out, theres an active .terraform directory here!"
  else
    touch placeholder.tf # This is needed because we only run prompt when your inside a directory with .tf files in it
    mkdir .terraform
    touch ./.terraform/environment
    echo "workspace-name" > ./.terraform/environment

    assertEquals "%K{093} %F{000}TF:  %F{000}workspace-name %k%F{093}%f " "$(__p9k_build_left_prompt)"

    rm placeholder.tf
    rm -rf .terraform
  fi

  unset P9K_LEFT_PROMPT_ELEMENTS  
}

function testTerraformNoEnvironment() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(terraform)

  # No .terraform or workspace detected so show none.
  assertEquals "%k%FNONE%f " "$(__p9k_build_left_prompt)"

  unset P9K_LEFT_PROMPT_ELEMENTS
}

source shunit2/shunit2

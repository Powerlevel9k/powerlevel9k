#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUp() {
  export TERM="xterm-256color"
  __P9K_HOME="${PWD}"
  local -a P9K_RIGHT_PROMPT_ELEMENTS
  P9K_RIGHT_PROMPT_ELEMENTS=()
  # Load Powerlevel9k
  source powerlevel9k.zsh-theme
  source segments/vagrant/vagrant.p9k

  # Test specific
  TEST_BASE_FOLDER=/tmp/powerlevel9k-test
  FOLDER=${TEST_BASE_FOLDER}/vagrant-test
  mkdir -p "${FOLDER}/bin"
  OLD_PATH=$PATH
  PATH=${FOLDER}/bin:$PATH
  cd $FOLDER
}

function tearDown() {
  cd "${__P9K_HOME}"
  rm -fr "${TEST_BASE_FOLDER}"
  PATH="${OLD_PATH}"
  unset OLD_PATH
  unset __P9K_HOME
}

function mockVBoxManage() {
  echo "#!/bin/sh\n\necho '\"powerlevel9k-bsd\" {c68704a2-56fd-4522-a829-31730ec826ef}\n\"my-vm\" {$1}\n\"powerlevel9k\" {f129e025-0f7b-46e4-89cd-13ad88658d5a}'" > "${FOLDER}/bin/VBoxManage"
  chmod +x "${FOLDER}/bin/VBoxManage"
}

function mockVagrantFolder() {
  local vagrantFolder=".vagrant/machines/default/virtualbox"
  mkdir -p "${vagrantFolder}"

  echo "$1" > ${vagrantFolder}/id
}

function testVagrantSegmentPrintsNothingIfVirtualboxIsNotAvailable() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(vagrant custom_world)
  local P9K_CUSTOM_WORLD='echo world'
  # Change path, so that VBoxManage is not found
  local PATH=/bin:/usr/bin

  assertEquals "%K{015} %F{000}world %k%F{015}%f " "$(__p9k_build_left_prompt)"
}

function testVagrantSegmentSaysVmIsDownIfVirtualboxIsNotAvailableButVagrantFolderExists() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(vagrant custom_world)
  local P9K_CUSTOM_WORLD='echo world'
  # Change path, so that VBoxManage is not found
  local PATH=/bin:/usr/bin
  mockVagrantFolder "some-id"

  assertEquals "%K{001} %F{000}V%f %F{000}DOWN %K{015}%F{001} %F{000}world %k%F{015}%f " "$(__p9k_build_left_prompt)"
}

function testVagrantSegmentWorksIfVmIsUp() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(vagrant)
  local vagrantId="xxx234"
  mockVBoxManage "${vagrantId}"
  mockVagrantFolder "${vagrantId}"

  assertEquals "%K{002} %F{000}V%f %F{000}UP %k%F{002}%f " "$(__p9k_build_left_prompt)"
}

function testVagrantSegmentWorksIfVmIsDown() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(vagrant)
  local vagrantId="xxx234"
  mockVBoxManage "${vagrantId}"
  mockVagrantFolder "another-vm-id"

  assertEquals "%K{001} %F{000}V%f %F{000}DOWN %k%F{001}%f " "$(__p9k_build_left_prompt)"
}

function testVagrantSegmentWorksIfVmIsUpFromWithinSubdir() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(vagrant)
  local vagrantId="xxx234"
  mockVBoxManage "${vagrantId}"
  mockVagrantFolder "${vagrantId}"

  mkdir -p "subfolder/1/2/3"
  cd subfolder/1/2/3

  assertEquals "%K{002} %F{000}V%f %F{000}UP %k%F{002}%f " "$(__p9k_build_left_prompt)"
}

function testVagrantSegmentWithChangedString() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(vagrant)
  local vagrantId="xxx234"
  mockVagrantFolder "${vagrantId}"

  local P9K_VAGRANT_DOWN_STRING="Nope"
  assertEquals "%K{001} %F{000}V%f %F{000}Nope %k%F{001}%f " "$(__p9k_build_left_prompt)"

  mockVBoxManage "${vagrantId}"
  local P9K_VAGRANT_UP_STRING="Yep"
  assertEquals "%K{002} %F{000}V%f %F{000}Yep %k%F{002}%f " "$(__p9k_build_left_prompt)"
}

source shunit2/shunit2

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

function testDetectVirtSegmentPrintsNothingIfSystemdIsNotAvailable() {
    alias systemd-detect-virt="novirt"

    POWERLEVEL9K_CUSTOM_WORLD='echo world'

    prompt_custom "left" "2" "world" "false"
    prompt_detect_virt "left" "1" "false"
    p9k_build_prompt_from_cache

    assertEquals "%K{white} %F{black}world %k%F{white}%f " "${PROMPT}"

    unset POWERLEVEL9K_CUSTOM_WORLD
    unalias systemd-detect-virt
}

function testDetectVirtSegmentIfSystemdReturnsPlainName() {
    alias systemd-detect-virt="echo 'xxx'"

    prompt_detect_virt "left" "1" "false"
    p9k_build_prompt_from_cache

    assertEquals "%K{yellow} %F{black}xxx %k%F{yellow}%f " "${PROMPT}"

    unalias systemd-detect-virt
}

function testDetectVirtSegmentIfRootFsIsOnExpectedInode() {
    # Well. This is a weak test, as it fixates the implementation,
    # but it is necessary, as the implementation relys on the root
    # directory having the inode number "2"..
    alias systemd-detect-virt="echo 'none'"

    # The original command in the implementation is "ls -di / | grep -o 2",
    # which translates to: Show the inode number of "/" and test if it is "2".
    alias ls="echo '2'"

    prompt_detect_virt "left" "1" "false"
    p9k_build_prompt_from_cache

    assertEquals "%K{yellow} %F{black}none %k%F{yellow}%f " "${PROMPT}"

    unalias ls
    unalias systemd-detect-virt
}

function testDetectVirtSegmentIfRootFsIsNotOnExpectedInode() {
    # Well. This is a weak test, as it fixates the implementation,
    # but it is necessary, as the implementation relys on the root
    # directory having the inode number "2"..
    alias systemd-detect-virt="echo 'none'"

    # The original command in the implementation is "ls -di / | grep -o 2",
    # which translates to: Show the inode number of "/" and test if it is "2".
    alias ls="echo '3'"

    prompt_detect_virt "left" "1" "false"
    p9k_build_prompt_from_cache

    assertEquals "%K{yellow} %F{black}chroot %k%F{yellow}%f " "${PROMPT}"

    unalias ls
    unalias systemd-detect-virt
}

source shunit2/source/2.1/src/shunit2

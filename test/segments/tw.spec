#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUp() {
    export TERM="xterm-256color"
    # Load Powerlevel9k
    source powerlevel9k.zsh-theme
    # Set tw segment for all tests
    POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(tw)

    # Init var for task results
    DUETODAY=0
    OVERDUE=0
    PENDING=0
}

function tearDown() {
    unset POWERLEVEL9K_LEFT_PROMPT_ELEMENTS
    unset OVERDUE
    unset DUETODAY
    unset PENDING
}

function mockTask() {
    case "$1" in
    '+OVERDUE')
        echo $OVERDUE
        ;;
    '+DUETODAY')
        echo $DUETODAY
        ;;
    '+PENDING')
        echo $PENDING
        ;;
    esac
}

function mockHash() {
    exit 0
}

function mockHashError() {
    exit 1
}

function testBasic() {
    alias task=mockTask
    alias hash=mockHash
    OVERDUE=0
    DUETODAY=1
    PENDING=2
    assertEquals "%K{white} %F{black%}☑ %f%F{black}1 tasks for today and 1 coming up %k%F{white}%f " "$(build_left_prompt)"
    unalias task
    unalias hash
}

function testChangeIcon() {
    alias task=mockTask
    alias hash=mockHash
    POWERLEVEL9K_TODO_ICON=""
    OVERDUE=3
    DUETODAY=2
    PENDING=5
    assertEquals "%K{yellow} %F{black%} %f%F{black}3 tasks late %k%F{yellow}%f " "$(build_left_prompt)"
    unset POWERLEVEL9K_TODO_ICON
    unalias task
    unalias hash
}

function testNoPendingTasks() {
    alias task=mockTask
    alias hash=mockHash
    OVERDUE=0
    DUETODAY=0
    PENDING=0
    assertEquals "%K{green} %F{black%}☑ %f%F{black}No pending tasks! %k%F{green}%f " "$(build_left_prompt)"
    unalias task
    unalias hash
}

function testTWNotAvailable() {
    alias hash=mockHashError
    assertEquals "%k%F{NONE}%f " "$(build_left_prompt)"
    unalias hash
}

function testBasicRight() {
    POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(tw)
    alias task=mockTask
    alias hash=mockHash
    OVERDUE=9
    DUETODAY=8
    PENDING=17
    assertEquals "%F{yellow}%f%K{yellow}%F{black} 9 tasks late%F{black%} ☑%f%E" "$(build_right_prompt)"
    unalias task
    unalias hash
    unset POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS
}

function testNoPendingTasksRight() {
    POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(tw)
    alias task=mockTask
    alias hash=mockHash
    OVERDUE=0
    DUETODAY=0
    PENDING=0
    assertEquals "%F{green}%f%K{green}%F{black} No pending tasks!%F{black%} ☑%f%E" "$(build_right_prompt)"
    unalias task
    unalias hash
    unset POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS
}

function testTWNotAvailableRight() {
    POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(tw)
    alias hash=mockHashError
    assertEquals "%E" "$(build_right_prompt)"
    unalias hash
    unset POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS
}

source shunit2/source/2.1/src/shunit2

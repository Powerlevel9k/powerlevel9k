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
    exit 1
}

function testBasic() {
    alias task=mockTask
    OVERDUE=0
    DUETODAY=1
    PENDING=2
    assertEquals "%K{244} %F{black%}☑ %f%F{black}Overdue:0 Today:1 Pending:2 %k%F{244}%f " "$(build_left_prompt)"
    unalias task
}

function testChangeIcon() {
    alias task=mockTask
    POWERLEVEL9K_TODO_ICON=""
    OVERDUE=3
    DUETODAY=2
    PENDING=5
    assertEquals "%K{244} %F{black%} %f%F{black}Overdue:3 Today:2 Pending:5 %k%F{244}%f " "$(build_left_prompt)"
    unset POWERLEVEL9K_TODO_ICON
    unalias task
}

function testNoPendingTasks() {
    alias task=mockTask
    OVERDUE=0
    DUETODAY=0
    PENDING=0
    assertEquals "%K{244} %F{black%}☑ %f%F{black}No pending tasks! %k%F{244}%f " "$(build_left_prompt)"
    unalias task
}

function testTWNotAvailable() {
    alias hash=mockHash
    assertEquals "%k%F{NONE}%f " "$(build_left_prompt)"
    unalias hash
}

function testBasicRight() {
    POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(tw)
    alias task=mockTask
    OVERDUE=9
    DUETODAY=8
    PENDING=17
    assertEquals "%F{244}%f%K{244}%F{black} Overdue:9 Today:8 Pending:17%F{black%} ☑%f%E" "$(build_right_prompt)"
    unalias task
    unset POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS
}

function testNoPendingTasksRight() {
    POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(tw)
    alias task=mockTask
    OVERDUE=0
    DUETODAY=0
    PENDING=0
    assertEquals "%F{244}%f%K{244}%F{black} No pending tasks!%F{black%} ☑%f%E" "$(build_right_prompt)"
    unalias task
    unset POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS
}

function testTWNotAvailableRight() {
    POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(tw)
    alias hash=mockHash
    assertEquals "%E" "$(build_right_prompt)"
    unalias hash
    unset POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS
}

source shunit2/source/2.1/src/shunit2

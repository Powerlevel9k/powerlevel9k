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
    RESULT=""
    DATE=""
}

function tearDown() {
    unset POWERLEVEL9K_LEFT_PROMPT_ELEMENTS
    unset RESULT
    unset DATE
}

function mockTask() {
    echo "$RESULT"
}

function mockDate() {
    echo "$DATE"
}

function mockHash() {
    exit 0
}

function mockHashError() {
    exit 1
}

function testChangeIcon() {
    alias task=mockTask
    alias date=mockDate
    alias hash=mockHash
    POWERLEVEL9K_TODO_ICON=""
    DATE="1332923198"
    RESULT=$'[
{"id":2,"description":"Recurring task","due":"20180730T030000Z","entry":"20180723T183011Z","imask":47,"modified":"20180721T045150Z","parent":"7c144112-bcc4-4253-a9c2-1d54742a6283","project":"project","recur":"weekly","status":"pending","uuid":"36a30eb7","urgency":9.84444},
{"id":3,"description":"Create some tests","due":"20180729T025959Z","entry":"20180724T123412Z","modified":"20180724T123412Z","project":"another.project","status":"pending","uuid":"29e0c602","urgency":10.2961},
{"id":5,"description":"Make things better","due":"20180726T000000Z","entry":"20180726T051440Z","modified":"20180726T054500Z","project":"Test","status":"pending","uuid":"29488de6","urgency":11.7137}
{"id":4,"description":"Create docs","due":"20180729T025959Z","entry":"20180724T123825Z","modified":"20180724T123825Z","project":"Awesome.project","status":"pending","uuid":"aeee8a0c","urgency":10.2961},
]'
    assertEquals "%K{green} %F{black%} %f%F{black}4 tasks coming up %k%F{green}%f " "$(build_left_prompt)"
    unset POWERLEVEL9K_TODO_ICON
    unalias task
    unalias date
    unalias hash
}

function testFinished() {
    # state: finished
    alias task=mockTask
    alias date=mockDate
    alias hash=mockHash
    DATE="1432923198"
    RESULT=$'[ ]'
    assertEquals "%K{green} %F{black%}☑ %f%F{black}No pending tasks! %k%F{green}%f " "$(build_left_prompt)"
    unalias task
    unalias date
    unalias hash
}

function testFinishedToday() {
    # state: finishedtoday
    alias task=mockTask
    alias date=mockDate
    alias hash=mockHash
    DATE="1332923198"
    RESULT=$'[
{"id":2,"description":"Recurring task","due":"20180730T030000Z","entry":"20180723T183011Z","imask":47,"modified":"20180721T045150Z","parent":"7c144112-bcc4-4253-a9c2-1d54742a6283","project":"project","recur":"weekly","status":"pending","uuid":"36a30eb7","urgency":9.84444},
{"id":3,"description":"Create some tests","due":"20180729T025959Z","entry":"20180724T123412Z","modified":"20180724T123412Z","project":"another.project","status":"pending","uuid":"29e0c602","urgency":10.2961},
{"id":5,"description":"Make things better","due":"20180726T000000Z","entry":"20180726T051440Z","modified":"20180726T054500Z","project":"Test","status":"pending","uuid":"29488de6","urgency":11.7137}
{"id":4,"description":"Create docs","due":"20180729T025959Z","entry":"20180724T123825Z","modified":"20180724T123825Z","project":"Awesome.project","status":"pending","uuid":"aeee8a0c","urgency":10.2961},
]'
    assertEquals "%K{green} %F{black%}☑ %f%F{black}4 tasks coming up %k%F{green}%f " "$(build_left_prompt)"
    unalias task
    unalias date
    unalias hash
}

function testOverdue() {
    # state: late
    alias task=mockTask
    alias date=mockDate
    alias hash=mockHash
    DATE="1532923198"
    RESULT=$'[
{"id":2,"description":"Recurring task","due":"20180730T030000Z","entry":"20180723T183011Z","imask":47,"modified":"20180721T045150Z","parent":"7c144112-bcc4-4253-a9c2-1d54742a6283","project":"project","recur":"weekly","status":"pending","uuid":"36a30eb7","urgency":9.84444},
{"id":3,"description":"Create some tests","due":"20180729T025959Z","entry":"20180724T123412Z","modified":"20180724T123412Z","project":"another.project","status":"pending","uuid":"29e0c602","urgency":10.2961},
{"id":5,"description":"Make things better","due":"20180726T000000Z","entry":"20180726T051440Z","modified":"20180726T054500Z","project":"Test","status":"pending","uuid":"29488de6","urgency":11.7137}
{"id":4,"description":"Create docs","due":"20180729T025959Z","entry":"20180724T123825Z","modified":"20180724T123825Z","project":"Awesome.project","status":"pending","uuid":"aeee8a0c","urgency":10.2961},
]'
    assertEquals "%K{yellow} %F{black%}☑ %f%F{black}3 tasks late %k%F{yellow}%f " "$(build_left_prompt)"

    unalias task
    unalias date
    unalias hash
}

function testWorking() {
    # state: working
    alias task=mockTask
    alias date=mockDate
    alias hash=mockHash
    DATE="1532926820"
    RESULT=$'[
{"id":2,"description":"Recurring task","due":"20180730T040000Z","entry":"20180723T183011Z","imask":47,"modified":"20180721T045150Z","parent":"7c144112-bcc4-4253-a9c2-1d54742a6283","project":"project","recur":"weekly","status":"pending","uuid":"36a30eb7","urgency":9.84444},
{"id":3,"description":"Create some tests","due":"20180730T040000Z","entry":"20180724T123412Z","modified":"20180724T123412Z","project":"another.project","status":"pending","uuid":"29e0c602","urgency":10.2961},
{"id":5,"description":"Make things better","due":"20180730T040000Z","entry":"20180726T051440Z","modified":"20180726T054500Z","project":"Test","status":"pending","uuid":"29488de6","urgency":11.7137}
{"id":4,"description":"Create docs","due":"20180730T040000Z","entry":"20180724T123825Z","modified":"20180724T123825Z","project":"Awesome.project","status":"pending","uuid":"aeee8a0c","urgency":10.2961},
]'
    assertEquals "%K{white} %F{black%}☑ %f%F{black}4 tasks for today %k%F{white}%f " "$(build_left_prompt)"
    unalias task
    unalias date
    unalias hash
}

function testWorkingPending() {
    # state: workingpending
    alias task=mockTask
    alias date=mockDate
    alias hash=mockHash
    DATE="1532926820"
    RESULT=$'[
{"id":2,"description":"Recurring task","due":"20180730T040000Z","entry":"20180723T183011Z","imask":47,"modified":"20180721T045150Z","parent":"7c144112-bcc4-4253-a9c2-1d54742a6283","project":"project","recur":"weekly","status":"pending","uuid":"36a30eb7","urgency":9.84444},
{"id":3,"description":"Create some tests","due":"20180730T040000Z","entry":"20180724T123412Z","modified":"20180724T123412Z","project":"another.project","status":"pending","uuid":"29e0c602","urgency":10.2961},
{"id":5,"description":"Make things better","due":"20180803T040000Z","entry":"20180726T051440Z","modified":"20180726T054500Z","project":"Test","status":"pending","uuid":"29488de6","urgency":11.7137}
{"id":4,"description":"Create docs","due":"20180803T040000Z","entry":"20180724T123825Z","modified":"20180724T123825Z","project":"Awesome.project","status":"pending","uuid":"aeee8a0c","urgency":10.2961},
]'
    assertEquals "%K{white} %F{black%}☑ %f%F{black}2 tasks for today and 2 coming up %k%F{white}%f " "$(build_left_prompt)"
    unalias task
    unalias date
    unalias hash
}

function testTWNotAvailable() {
    alias hash=mockHashError
    assertEquals "%k%F{NONE}%f " "$(build_left_prompt)"
    unalias hash
}

source shunit2/source/2.1/src/shunit2

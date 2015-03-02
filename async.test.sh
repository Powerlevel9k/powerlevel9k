#!/usr/bin/env zsh

. ./async.zsh

simple_echo() {
	echo hi
}

git_status() {
	git status --porcelain
}

result() {
	print
	print -l -r -- "Compelted job: '$1'" "Return code: $2" "Duration: $4 seconds" "Output: '${3//$'\n'/\n}'"
}


async_init

# Test a simple echo...
async_start_worker async
async_job async simple_echo
sleep 0.1
async_process_results async result

# Test uniqueness
async_start_worker async2 unique
# Only the first one will run!
# The second cannot run due to unique constraint.
async_job async2 git_status
async_job async2 git_status
sleep 0.2
# Only results for first git status
async_process_results async2 result

# Cleanup
async_stop_worker async async2 || echo "ERROR: Could not clean up workers"
async_stop_worker nonexistent && echo "ERROR: Sucess cleaning up nonexistent worker"

#!/usr/bin/env zsh

# Internal use only!
# _async_job is a job wrapper for the async worker, outputs results with execution time
_async_job() {
	local out
	# store the job identifier
	local job=$1
	# reset the identifier
	1=""
	# store start time
	local start=$EPOCHREALTIME

	# run the command
	out=$($job $@ 2>&1)
	local ret=$?

	# Grab mutex lock
	read -ep >/dev/null

	# return output
	print -r -N -n -- $job $ret $out $(( $EPOCHREALTIME - $start ))$'\0'

	# Unlock mutex
	print -p "t"
}

# Internal use only!
# The background worker does some processing for us without locking up the terminal
_async_worker() {
	local opt=$1
	local -A storage

	# Create a mutex for writing to the terminal through coproc
	coproc cat
	# Insert token into coproc
	print -p "t"

	while read -r cmd; do
		# Separate on spaces into an array
		cmd=(${=cmd})
		local job=$cmd[1]

		[[ $job == "_killjobs" ]] && {
			kill ${${(v)jobstates##*:*:}%=*} &>/dev/null
			continue
		}

		# If worker should perform unique jobs
		[[ $opt == "unique" ]] && {
			# Check if a previous job is still running, if yes, let it finnish
			for pid in ${${(v)jobstates##*:*:}%=*}; do
				[[ "${storage[$job]}" == "$pid" ]] && {
					continue 2
				}
			done
		}

		# run task in background
		_async_job $cmd &
		# store pid because zsh job manager is extremely unflexible (show jobname as non-unique '$job')...
		storage[$job]=$!
	done
}

# Get results from finnished jobs and feed the to callback function
# usage:
# 	async_process_results [worker_name] [callback_function]
#
# callback_function is called with the following parameters:
# 	$1 = job name, e.g. the function passed to async_job
# 	$2 = return code
# 	$3 = resulting output from execution
# 	$4 = execution time, floating point e.g. 2.05 seconds
async_process_results() {
	integer count=0
	local -a items
	local IFS=$'\0'

	typeset -A ASYNC_PROCESS_BUFFER
	# Read output from zpty and parse it if available
	while zpty -r $1 line; do
		# Remove unwanted \r from output
		ASYNC_PROCESS_BUFFER[$1]+=${line//$'\r'$'\n'/$'\n'}
		# Split buffer on null characters, preserve empty elements
		items=("${(@)=ASYNC_PROCESS_BUFFER[$1]}")
		# Remove last element since it's due to the return string separator structure
		items=("${(@)items[1,${#items}-1]}")

		# Continue until we receive all information
		(( ${#items} % 4 )) && continue

		# Work through all results
		while ((${#items} > 0)); do
			eval '$2 "${(@)=items[1,4]}"'
			shift 4 items
			count+=1
		done

		# Empty the buffer
		ASYNC_PROCESS_BUFFER[$1]=""
	done

	# If we processed any results, return success
	(( $count )) && return 0

	# No results were processed
	return 1
}

# Start a new asynchronous job, start the worker if it isn't running
# usage:
# 	async_job [worker_name] [my_function [params]]
async_job() {
	local worker=$1
	1=""
	async_start_worker $worker
	zpty -w $worker $@
}

async_flush_jobs() {
	# Send kill command to worker
	zpty -w $1 "_killjobs"

	# Clear all output buffers
	while zpty -r $1 line; do done

	# Clear any partial buffers
	typeset -A ASYNC_PROCESS_BUFFER
	ASYNC_PROCESS_BUFFER[$1]=""
}

# Start a new asynchronous worker
# usage:
# 	async_start_worker [worker_name] [unique]
async_start_worker() {
	zpty -t $1 &>/dev/null || zpty -b $1 _async_worker $2 || async_stop_worker $1
}

# Stop a worker that is running
# usage:
# 	async_stop_worker [worker_name_1] [worker_name_2]
async_stop_worker() {
	local ret=0
	for worker in $@; do
		zpty -d $worker 2>/dev/null || ret=$?
	done

	return $ret
}

async_init() {
	zmodload zsh/zpty
	zmodload zsh/datetime
}

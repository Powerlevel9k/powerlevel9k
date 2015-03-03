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

	# return output
	print -r -N -n -- $job $ret $out $(( $EPOCHREALTIME - $start )) ""
}

# Internal use only!
# The background worker does some processing for us without locking up the terminal
_async_worker() {
	local opt=$1
	local -A storage

	while read -r cmd; do
		[[ $cmd == "killjobs" ]] && {
			kill ${${(v)jobstates##*:*:}%=*} &>/dev/null
			continue
		}
		# Separate on spaces into an array
		cmd=(${=cmd})
		local job=$cmd[1]

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
	integer index=1
	local -a params
	local newlines=0

	# Read output from zpty and parse it if available
	while zpty -r $1 line; do
		# Our data is separated by NULLs
		IFS=$'\0' read -r -A line <<< $line

		# Check every item in array
		for item in $line; do
			item=${item/$'\r'/$'\n'}

			# Check if the output is incomplete, e.g. newlines in output
			if ((${#line} == 1)); then
				index+=-1
				newlines=1
			elif (($newlines)); then
				index+=-1
				newlines=0
			fi

			# Set parameter
			params[$index]+=$item
			index+=1

			# If we have received 4 items, our result is complete
			if (($index > 4)); then
				local job=$params[1]
				local ret=$params[2]
				local result=$params[3]
				local exec_time=${params[4]%$'\r'}

				# Execute callback
				eval '$2 $job $ret $result $exec_time'

				# Reset env
				index=1
				params=()
				count+=1
			fi
		done
	done

	# If we processed any results, return success
	(($count > 0)) && return 0

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

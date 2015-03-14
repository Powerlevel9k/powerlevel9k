# zsh-async

	Because your terminal should be able to perform tasks asynchronously
	without external tools!

## Overview

`zsh-async` is a small library for running asynchornous tasks in zsh without
requiring any external tools. It utilizes `zsh/zpty` to launch a pseudo-terminal
in which all commands get executed without blocking any other processes.
Checking for completed tasks can be done manually, by polling, or better yet,
automatically whenever a process has finnished executing by notifying through a
`SIGWINCH` kill-signal.

This library bridges the gap between spawning child processes and disowning
them. Child proccesses launched by normal means clutter the terminal with
output about their state, and disowned proccesses become separate entities, no
long under control of the parent. Now you can have both!

## Usage

The `zsh-async` library has a bunch of functions that need to be used to
perform async actions:

### `async_init`

Initializes the async library (not required if using async from `$fpath` with
autoload.)

### `async_start_worker <worker_name> [-u] [-n] [-p <pid>]`

Start a new async worker with optional parameters, a worker can be told to only
run unique tasks and to notify a process when tasks are complete.

* `-u` unique. Only unique job names can run, e.g. the command `git status`
will have `git` as the unique job name identifier
* `-n` notify through SIGWINCH signal. Needs to be caught with a
`trap '' WINCH` in the process defined by `-p`
* `-p` pid to notify (defaults to current pid)

### `async_stop_worker <worker_name_1> [<worker_name_2>]`

Simply stops a worker and all active jobs will be terminated immediately.

### `async_job <worker_name> <my_function> [<function_params>]`

Start a new asynchronous job on specified worker, assumes the worker is
running.

### `async_process_results <worker_name> <callback_function>`

Get results from finnished jobs and pass it to the to callback function. This
is the only way to reliably return the job name, return code, output and
execution time and with minimal effort.

The `callback_function` is called with the following parameters:

* `$1` job name, e.g. the function passed to async_job
* `$2` return code
* `$3` resulting (stdout) output from job execution
* `$4` execution time, floating point e.g. 0.30631208419799805 seconds

### `async_flush_jobs <worker_name>`

Flush all current jobs running on a worker. This will terminate any and
all running processes under the worker, use with caution.

## Example code

```zsh
#!/usr/bin/env zsh
source ./async.zsh
async_init

# Initialize a new worker (with notify option)
async_start_worker my_worker -n

# Create a callback function to process results
COMPLETED=0
completed_callback() {
	COMPLETED=$(( COMPLETED + 1 ))
	print $@
}

# Trap the completion signal from worker, check for results
trap 'async_process_results my_worker completed_callback' WINCH

# Give the worker some tasks to perform
async_job my_worker print hello
async_job my_worker sleep 0.3

# Wait for the two tasks to be completed
while (( COMPLETED < 2 )); do
	print "Waiting..."
	sleep 0.1
done

print "Completed $COMPLETED tasks!"

# Output:
#	Waiting...
#	print 0 hello 0.001583099365234375
#	Waiting...
#	Waiting...
#	sleep 0 0.30631208419799805
#	Completed 2 tasks!
```

## Testing

The test cases are really basic at this moment, making the more advanced is on
the TODO list.

```zsh
./async.test.sh
```

## Limitations

* Currently you cannot pass a job like `"sleep 1 && echo hi"`, it needs to be a
single command
* Tell me? :)

## Recommendations

If you do not with to use the `notify` feature, you can couple `zsh-async` with
`zsh/sched` or the zsh `periodic` function for scheduling the worker results to
be processed.

## Todo

* ~~Implement optional method of notifying main process through kill-signals
when work is complete~~
* Write more tests
* Better zsh module structure
* ~~Improve the error handling, it is detectable~~

## Why did I make this?

I found a great theme for zsh, [Pure](https://github.com/sindresorhus/pure) by
Sindre Sorhus. After using it for a while I noticed some graphical glitches
du to the terminal being updated by a disowned process. Hes work, however,
inspired me to get my hands dirty and find a solution. I tried many thing,
coprocesses were one, but they confused me and I didn't like them. I also
ventured down the rabbit-hole of sending and trapping kill-signals, but I
could not manage to fix the deadlock issues related to it. Finally I came up
with this and thought, hey, why not make it a library.

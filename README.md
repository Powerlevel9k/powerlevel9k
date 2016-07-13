# zsh-async

```
Because your terminal should be able to perform tasks asynchronously without external tools!
```

## Intro (TL;DR)

With `zsh-async` you can run multiple asynchronous jobs, enforce unique jobs (multiple instances of the same job will not run), flush all currently running jobs and create multiple workers (each with their own jobs). For each worker you can register a callback-function through which you will be notified about the job results (job name, return code, output and execution time).

## Overview

`zsh-async` is a small library for running asynchronous tasks in zsh without requiring any external tools. It utilizes `zsh/zpty` to launch a pseudo-terminal in which all commands get executed without blocking any other processes. Checking for completed tasks can be done manually, by polling, or better yet, automatically whenever a process has finished executing by notifying through a `SIGWINCH` kill-signal.

This library bridges the gap between spawning child processes and disowning them. Child processes launched by normal means clutter the terminal with output about their state, and disowned processes become separate entities, no longer under control of the parent. Now you can have both!

## Usage

### Installation

You can either source the `async.zsh` script directly or insert under your `$fpath` as async and autoload it through `autoload -Uz async && async`.

### Functions

The `zsh-async` library has a bunch of functions that need to be used to perform async actions:

#### `async_init`

Initializes the async library (not required if using async from `$fpath` with autoload.)

#### `async_start_worker <worker_name> [-u] [-n] [-p <pid>]`

Start a new async worker with optional parameters, a worker can be told to only run unique tasks and to notify a process when tasks are complete.

* `-u` unique. Only unique job names can run, e.g. the command `git status` will have `git` as the unique job name identifier

* `-n` notify through `SIGWINCH` signal. Needs to be caught with a `trap '' WINCH` in the process defined by `-p`

  **NOTE:** Since zsh version `5.1` (assuming an interactive shell) this option is no longer needed and has no effect. Signaling through `SIGWINCH` has been replaced by a ZLE watcher that is triggered on output from the `zpty` instance (still requires a callback function through `async_register_callback` though).

* `-p` pid to notify (defaults to current pid)

#### `async_stop_worker <worker_name_1> [<worker_name_2>]`

Simply stops a worker and all active jobs will be terminated immediately.

#### `async_job <worker_name> <my_function> [<function_params>]`

Start a new asynchronous job on specified worker, assumes the worker is running.

#### `async_process_results <worker_name> <callback_function>`

Get results from finished jobs and pass it to the to callback function. This is the only way to reliably return the job name, return code, output and execution time and with minimal effort.

The `callback_function` is called with the following parameters:

* `$1` job name, e.g. the function passed to async_job
* `$2` return code
  * Returns `-1` if return code is missing, this should never happen, if it does, you have likely run into a bug. Please open a new [issue](https://github.com/mafredri/zsh-async/issues/new) with a detailed description of what you were doing.
* `$3` resulting (stdout) output from job execution
* `$4` execution time, floating point e.g. 0.0076138973 seconds
* `$5` resulting (stderr) error output from job execution

#### `async_register_callback <worker_name> <callback_function>`

Register a callback for completed jobs. As soon as a job is finished, `async_process_results` will be called with the specified callback function. This requires that a worker is initialized with the -n (notify) option.

#### `async_unregister_callback <worker_name>`

Unregister the callback for a specific worker.

#### `async_flush_jobs <worker_name>`

Flush all current jobs running on a worker. This will terminate any and all running processes under the worker by sending a `SIGTERM` to the entire process group, use with caution.

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

# Register callback function for the workers completed jobs
async_register_callback my_worker completed_callback

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

The test cases are really basic at this moment, making the more advanced is on the TODO list.

```zsh
./async.test.sh
```

## Limitations

* Since null (`$'\0'`) characters are used to separate output from the async worker, any nulls will be stripped from the output to prevent corruption.
* ~~Currently you cannot pass a job like `"sleep 1 && echo hi"`, it needs to be a single command~~. Fixed in [this commit](https://github.com/mafredri/zsh-async/commit/e6d70e0eea0a80b1624f407f60795cfb1a4524e1).
* Tell me? :)

## Recommendations

If you do not with to use the `notify` feature, you can couple `zsh-async` with `zsh/sched` or the zsh `periodic` function for scheduling the worker results to be processed.

## Todo

* ~~Implement optional method of notifying main process through kill-signals when work is complete~~
* Write more tests
* Better zsh module structure
* ~~Improve the error handling, it is detectable~~

## Why did I make this?

I found a great theme for zsh, [Pure](https://github.com/sindresorhus/pure) by Sindre Sorhus. After using it for a while I noticed some graphical glitches due to the terminal being updated by a disowned process. Thus, I became inspired to get my hands dirty and find a solution. I tried many things, coprocesses (seemed too limited by themselves), different combinations of trapping kill-signals, etc. I also had problems with the zsh process ending up in a deadlock due to some zsh bug. After working out the kinks, I ended up with this and thought, hey, why not make it a library.

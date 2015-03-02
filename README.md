# Async for ZSH

	Because your terminal should be able to perform tasks asynchronously
	without external tools!

## Overview

`zsh-async` is a small toolkit for running asynchornous tasks in zsh without
requiring any external tools. It utilizes `zsh/zpty` to launch a pseudo-terminal
in which all commands get executed without blocking any other processes.

This is the bridge between children and disowned children. Regular children
clutter the terminal with output about their state, and disowned children take
their rights into their own hands and you lose control. Now you can have both!

## Usage

```zsh
source ./async.zsh.sh

my_function() {
	echo hello
}

my_other_function() {
	echo world
}

my_callback_function() {
	echo $@
}

# Initialize a new worker
async_start_worker my_worker

# Give the worker some commands
async_job my_worker my_function
async_job my_worker my_other_function

# Wait for the worker to finnish its job
sleep 1

# Get results from worker by passing them to callback
async_process_results my_worker my_callback_function

# Oops?
async_job my_worker my_cpu_burn_function
# Better correct that:
async_job my_worker killjobs
# PS. the 'killjobs' parameter will probably change.
```

## Testing

```zsh
./async.test.sh
```

## Limitations

At this moment only custom functions can be passed to the worker. Trying to run
the following command will result in an error (command git not found):

```zsh
async_job my_worker git status
```

This problems are hard to debug because it isn't instantly obvious where the
problem originates from. Errors in functions will also be hard to debug.

## Recommendations

Couple zsh-async with `zsh/sched` or the zsh `periodic` function for scheduling
the worker results to be processed.

## Todo

* Implement optional method of notifying main process through kill-signals when
work is complete
* Write more tests
* Better zsh module structure
* Improve the error handling, it is detectable.

## Why did I make this?

I found a great theme for zsh, [Pure](https://github.com/sindresorhus/pure) by
Sindre Sorhus. After using it for a while I noticed some graphical glitches
du to the terminal being updated by a disowned process. Hes work, however,
inspired me to get my hands dirty and find a solution. I tried many thing,
coprocesses were one, but they confused me and I didn't like them. I also
ventured down the rabbit-hole of sending and trapping kill-signals, but I
could not manage to fix the deadlock issues related to it. Finally I came up
with this and thought, hey, why not make it a library.

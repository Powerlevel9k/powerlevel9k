# Structure

Our unit-tests do not follow exactly the file structure of powerlevel9k itself.

# Preparation

To execute the tests you need `shUnit2`. You can install it with:
```zsh
git submodule init
git submodule update
```

# Executing tests

To execute a test, just execute the file from the root directory (like `./test/functions/colors.spec`).

# Automatically run tests on commit

The tests are executed on our CI system Travis on every pushed commit. To control which tests should be executed, travis looks into `.travis.yml`.

## Writing 

Yes please! It would be nice, if you add tests to your segment. There are some things you should do in your test file:

1. source shUnit (usually at the end of the file)
2. source powerlevel9k (in the `setUp` function)
3. disable traps (Our code is async, but in order to test it, you'll need to call it synchronously)
4. after the test cleanup (usually call `p9k_clear_cache` in `tearDown`)

Have a look at the various tests.

## Core tests

Core functionality is tested in `test/core` and utility functions in `test/functions`.

## Segment Tests

These Tests tend to be more complex in setup than the basic tests. To avoid ending
up in a huge single file, there is one file per segment in `test/segments`.

# Manual tests

If unit tests are not sufficient (e.g. you have an issue with your prompt that
occurs only in a specific ZSH framework), then you could use our Test-VMs!
Currently there are two test VMs. `test-vm` is an Ubuntu machine with several
pre-installed ZSH frameworks. And there is `test-bsd-vm` which is a FreeBSD!
For how to run the machines see [here](test-vm/README.md).

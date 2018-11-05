# Tests

There are four different ways to test P9K:

1. Most obvious: You could change settings in your Shell, and directly test
   them in your shell with your environment; Like you use it.
2. Old way: With [vagrant and virtualbox](#vagrant). This starts a whole
   operating system in a virtual machine. This is still the way to go, if
   you want to test on BSD. Downside: There is just one ZSH version
   available per VM..
3. New way: With [test-in-docker](#docker). This way starts a docker
   container with the ZSH version and ZSH Framework you want. This is the
   way to go, if you want to test something on a specific ZSH version.
   Because this is more flexible, you should use this method if you want to
   test in a different (more limited) environment. This is especially
   helpful if you want a similar environment like Travis.
4. [Automatic way](#automated-tests): We have a lot of test scripts that
   test specific parts of P9K everytime somebody pushes a commit. The
   tests are executed by Travis, an external Service that we connected with
   this Repo. You could execute these tests on your machine locally as well,
   we added shUnit as git submodule. After you installed the submodules, it
   is possible to simply execute the test scripts (see test/ folder).

So, option 1-3 are for manual testing, but it is possible to execute the test
scripts in that environments as well.

## Automated Tests

The Unit-Tests do not follow exactly the file structure of Powerlevel9k itself,
but we try to reflect the structure as much as possible. All tests are located
under `test/`. Segment specific tests under `test/segments/` (one file per
segment).

### Installation

In order to execute the tests you need to install `shunit2`, which is a
submodule. To install the submodule, you can execute 
`git submodule init && git submodule update`.

### Executing tests

The tests are shell scripts on their own. So you can execute them right away.
To execute all tests you could just execute `./test/suite.spec`.

### General Test Structure

The tests usually have a `setUp()` function which is executed before every
test function. Speaking of, test functions must be prefixed with `test`. In
the tests, you can do [different Assertions](https://github.com/kward/shunit2#-asserts).
It is always a good idea to mock the program you want to test (just have a
look at other tests), so that the testrunner does not have to have all
programs installed.

### Travis

We use [Travis](https://travis-ci.org/) for Continuous Integration. This
service executes our tests after every push. For now, we need to tell travis
where to find the tests, which is what happens in the `.travis.yml` file.

## Manual Testing

If unit tests are not sufficient (e.g. you have an issue with your prompt that
occurs only in a specific ZSH framework) then you can use either Docker or
or our Vagrant.

### Docker

This is the easiest to use _if_ you have Docker already installed and running.

The command `./test-in-docker` should make it fairly easy to get into a running
container with the framework of your choice.

Examples:

``` zsh
# Test Antigen with the oldest version of ZSH
$ ./test-in-docker antigen
```

``` zsh
# Test Prezto with ZSH version 5.2
$ ./test-in-docker --zsh 5.2 prezto
```

You can get Docker at <https://www.docker.com/community-edition>.

**Note:** Not all frameworks work with all versions of ZSH (or the underlying OS).

### Vagrant

Currently there are two test VMs. `test-vm` is an Ubuntu machine with several
pre-installed ZSH frameworks. And there is `test-bsd-vm` which is a FreeBSD!
For how to run the machines see [here](test-vm/README.md).

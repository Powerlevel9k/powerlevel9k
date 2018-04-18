#!/usr/bin/env zsh
#
# zsh-async test runner.
# Checks for test files named *_test.zsh or *_test.sh and runs all functions
# named test_*.
#
emulate -R zsh

zmodload zsh/datetime
zmodload zsh/parameter
zmodload zsh/zutil
zmodload zsh/system
zmodload zsh/zselect

TEST_GLOB=.
TEST_RUN=
TEST_VERBOSE=0
TEST_TRACE=1
TEST_CODE_SKIP=100
TEST_CODE_ERROR=101
TEST_CODE_TIMEOUT=102

show_help() {
	print "usage: ./test.zsh [-v] [-x] [-run pattern] [search pattern]"
}

parse_opts() {
	local -a verbose debug trace help run

	local out
	zparseopts -E -D \
		v=verbose verbose=verbose -verbose=verbose \
		d=debug debug=debug -debug=debug \
		x=trace trace=trace -trace=trace \
		h=help -help=help \
		\?=help \
		run:=run -run:=run

	(( $? )) || (( $+help[1] )) && show_help && exit 0

	if (( $#@ > 1 )); then
		print -- "unknown arguments: $@"
		show_help
		exit 1
	fi

	[[ -n $1 ]] && TEST_GLOB=$1
	TEST_VERBOSE=$+verbose[1]
	TEST_TRACE=$+trace[1]
	ZTEST_DEBUG=$+debug[1]
	(( $+run[2] )) && TEST_RUN=$run[2]
}

t_runner_init() {
	emulate -L zsh

	zmodload zsh/parameter

	# _t_runner is the main loop that waits for tests,
	# used to abort test execution by exec.
	_t_runner() {
		local -a _test_defer_funcs
		integer _test_errors=0
		while read -r; do
			eval "$REPLY"
		done
	}

	_t_log() {
		local trace=$1; shift
		local -a lines indent
		lines=("${(@f)@}")
		indent=($'\t\t'${^lines[2,$#lines]})
		print -u7 -lr - $'\t'"$trace: $lines[1]" ${(F)indent}
	}

	# t_log is for printing log output, visible in verbose (-v) mode.
	t_log() {
		local line=$funcfiletrace[1]
		[[ ${line%:[0-9]*} = "" ]] && line=ztest:$functrace[1]  # Not from a file.
		_t_log $line "$*"
	}

	# t_skip is for skipping a test.
	t_skip() {
		_t_log $funcfiletrace[1] "$*"
		() { return 100 }
		t_done
	}

	# t_error logs the error and fails the test without aborting.
	t_error() {
		(( _test_errors++ ))
		_t_log $funcfiletrace[1] "$*"
	}

	# t_fatal fails the test and halts execution immediately.
	t_fatal() {
		_t_log $funcfiletrace[1] "$*"
		() { return 101 }
		t_done
	}

	# t_defer takes a function (and optionally, arguments)
	# to be executed after the test has completed.
	t_defer() {
		_test_defer_funcs+=("$*")
	}

	# t_done completes the test execution, called automatically after a test.
	# Can also be called manually when the test is done.
	t_done() {
		local ret=$? w=${1:-1}
		(( _test_errors )) && ret=101

		(( w )) && wait    # Wait for test children to exit.
		for d in $_test_defer_funcs; do
			eval "$d"
		done
		print -n -u8 $ret  # Send exit code to ztest.
		exec _t_runner     # Replace shell, wait for new test.
	}

	source $1  # Load the test module.

	# Send available test functions to main process.
	print -u7 ${(R)${(okM)functions:#test_*}:#test_main}

	# Run test_main.
	if [[ -n $functions[test_main] ]]; then
		test_main
	fi

	exec _t_runner  # Wait for commands.
}

# run_test_module runs all the tests from a test module (asynchronously).
run_test_module() {
	local module=$1
	local -a tests
	float start module_time

	# Create fd's for communication with test runner.
	integer run_pid cmdoutfd cmdinfd outfd infd doneoutfd doneinfd

	coproc cat; exec {cmdoutfd}>&p; exec {cmdinfd}<&p
	coproc cat; exec {outfd}>&p; exec {infd}<&p
	coproc cat; exec {doneoutfd}>&p; exec {doneinfd}<&p

	# No need to keep coproc (&p) open since we
	# have redirected the outputs and inputs.
	coproc exit

	# Launch a new interactive zsh test runner. We don't capture stdout
	typeset -a run_args
	(( TEST_TRACE )) && run_args+=('-x')
	zsh -s $run_args <&$cmdinfd 7>&$outfd 8>&$doneoutfd &
	run_pid=$!

	# Initialize by sending function body from t_runner_init
	# and immediately execute it as an anonymous function.
	syswrite -o $cmdoutfd "() { ${functions[t_runner_init]} } $module"$'\n'
	sysread -i $infd
	tests=(${(@)=REPLY})
	[[ -n $TEST_RUN ]] && tests=(${(M)tests:#*$TEST_RUN*})

	integer mod_exit=0
	float mod_start mod_time

	mod_start=$EPOCHREALTIME  # Store the module start time.

	# Run all tests.
	local test_out
	float test_start test_time
	integer text_exit

	for test in $tests; do
		(( TEST_VERBOSE )) && print "=== RUN   $test"

		test_start=$EPOCHREALTIME  # Store the test start time.

		# Start the test.
		syswrite -o $cmdoutfd "$test; t_done"$'\n'

		test_out=
		test_exit=-1
		while (( test_exit == -1 )); do
			# Block until there is data to be read.
			zselect -r $doneinfd -r $infd

			if [[ $reply[2] = $doneinfd ]]; then
				sysread -i $doneinfd
				test_exit=$REPLY  # Store reply from sysread
				# Store the test execution time.
				test_time=$(( EPOCHREALTIME - test_start ))
			fi

			# Read all output from the test output channel.
			while sysread -i $infd -t 0; do
				test_out+=$REPLY
				unset REPLY
			done
		done

		case $test_exit in
			(0|1) state=PASS;;
			(100) state=SKIP;;
			(101|102) state=FAIL; mod_exit=1;;
			*) state="????";;
		esac

		if [[ $state = FAIL ]] || (( TEST_VERBOSE )); then
			printf -- "--- $state: $test (%.2fs)\n" $test_time
			print -n $test_out
		fi
	done

	# Store module execution time.
	mod_time=$(( EPOCHREALTIME - mod_start ))

	# Perform cleanup.
	kill -HUP $run_pid
	exec {outfd}>&-
	exec {infd}<&-
	exec {cmdinfd}>&-
	exec {cmdoutfd}<&-
	exec {doneinfd}<&-
	exec {doneoutfd}>&-

	if (( mod_exit )); then
		print "FAIL"
		(( TEST_VERBOSE )) && print "exit code $mod_exit"
		printf "FAIL\t$module\t%.3fs\n" $mod_time
	else
		(( TEST_VERBOSE )) && print "PASS"
		printf "ok\t$module\t%.3fs\n" $mod_time
	fi

	return $mod_exit
}

cleanup() {
	trap - HUP
	kill -HUP $$ 2>/dev/null
	kill -HUP -$$ 2>/dev/null
}

trap cleanup EXIT INT HUP QUIT TERM USR1

# Parse command arguments.
parse_opts $@

(( ZTEST_DEBUG )) && setopt xtrace

# Execute tests modules.
failed=0
for tf in ${~TEST_GLOB}/*_test.(zsh|sh); do
	run_test_module $tf &
	wait $!
	(( $? )) && failed=1
done

exit $failed

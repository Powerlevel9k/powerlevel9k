#!/usr/bin/env zsh
# vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

export SHUNIT_COLOR="always"

local failed=false
local P9K_IGNORE_VAR_WARNING=true

export LIBPERF_ENABLED=true

if ( "$LIBPERF_ENABLED" ); then
  rm -f ./test/performance/perf_log.csv
fi

# Allows you to run `./test/suite.spec segments` to only run tests in the segment folder.
if [[ -n "$1" ]]; then
  for test in test/$1/*.spec; do
    echo
    echo "••• Now executing ${test} •••"
    # skip suite spec
    if [[ "${test}" == "test/suite.spec" ]]; then
      continue;
    fi
    ./${test} || failed=true
  done
else
  for test in **/*.spec; do
    echo
    echo "••• Now executing ${test} •••"
    # skip suite spec
    if [[ "${test}" == "test/suite.spec" ]]; then
      continue;
    fi
    ./${test} || failed=true
  done
fi

if [[ "${failed}" == "true" ]]; then
  exit 1
fi

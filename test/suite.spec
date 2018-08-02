#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

typeset -AH test_results


# check for command line arguments and deal with them.
typeset -ah commandline_args
commandline_args=("$@")
commandline_count=$#

# show usage information
show_help() {
  echo "Usage: suite.spec [OPTION]"
  echo
  echo "-b, --break-on-fail   stop testing if a test fails"
  echo "-c, --use-color       use colored output"
  echo "-s, --show-summary    show a summary of passes/failures at the end"
  echo "-h, --help            display this help text and exit"
  echo
  unset commandline_args commandline_count
  exit 0
}

# show the summary of the tests
show_test_summary() {
  echo
  [[ ${use_color} == true ]] \
      && echo "\x1b[38;5;33mTest Results:\x1b[0m" \
      || echo "Test Results:"
  for k in "${(ok)test_results[@]}"; do
    if [[ ${test_results[$k]} == true ]]; then
      [[ ${use_color} == true ]] \
          && echo " \x1b[38;5;28m pass\x1b[0m: ${k}" \
          || echo "  + pass: ${k}"
    else
      [[ ${use_color} == true ]] \
          && echo " \x1b[38;5;124m fail\x1b[0m: ${k}" \
          || echo "  - fail: ${k}"
    fi
  done
}

# execute the tests
run_tests() {
  local test_failed=false break_on_fail=false use_color=false show_summary=false pass
  local P9K_IGNORE_VAR_WARNING=true

  # check for command line parameters
  if (( ${commandline_count} > 0 )); then
    for arg in "${commandline_args[@]}"; do
      case "${arg}" in
        "-b" | "--break-on-fail" ) break_on_fail=true ;;
        "-c" | "--use-color" ) use_color=true ;;
        "-s" | "--show-summary" ) show_summary=true ;;
        "-h" | "--help" ) show_help ;;
        *) echo "Unknown parameter\n"; show_help ;;
      esac
    done
  fi
  unset commandline_args commandline_count

  # run the tests
  for test in **/*.spec; do
    if [[ "${test}" == "test/suite.spec" ]]; then
      continue;
    fi
    echo
    [[ ${use_color} == true ]] \
        && echo "\x1b[38;5;33m••• Now executing ${test} •••\x1b[0m" \
        || echo "••• Now executing ${test} •••"
    pass=true
    ./${test} || pass=false
    test_results[${test}]=${pass}
    if [[ ${pass} == false ]]; then
       test_failed=true
       [[ ${use_color} == true ]] \
           && echo "\x1b[38;5;124m^^^^^^^^^^^^^^^^^^^\x1b[0m" \
           || echo "^^^^^^^^^^^^^^^^^^^"
    fi
    if [[ ${break_on_fail} == true && ${test_failed} == true ]]; then
      break;
    fi
  done

  if [[ ${show_summary} == true ]]; then
    show_test_summary
  fi

  # clean up our variables
  unset test_results

  # if a test failed, exit with an error of 1
  if [[ ${test_failed} == true ]]; then
    exit 1
  fi
}

run_tests

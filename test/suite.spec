#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

local failed; failed=false
local break_on_fail; break_on_fail=false
local show_summary; show_summary=false
local pass
local P9K_IGNORE_VAR_WARNING=true
typeset -AH testResults

[[ $1 == "-b" || $2 == "-b" ]] && break_on_fail=true
[[ $1 == "-s" || $2 == "-s" ]] && show_summary=true

for test in **/*.spec; do
  if [[ "${test}" == "test/suite.spec" ]]; then
    continue;
  fi
  echo
  [[ ${break_on_fail} == true || ${show_summary} == true ]] && echo "\x1b[38;5;33mNow executing ${test}...\x1b[0m"
  pass=true
  ./${test} || pass=false
  testResults[${test}]=${pass}
  [[ ${pass} == false ]] && failed=true
  [[ ${break_on_fail} == true && ${failed} == true ]] && break;
done

if [[ ${show_summary} == true ]]; then
  echo
  echo "testResults:"
  for k in "${(ok)testResults[@]}"; do
    [[ ${testResults[$k]} == true ]] && echo " \x1b[38;5;28m pass \x1b[0m${k}" || echo " \x1b[38;5;124m fail \x1b[0m${k}"
  done
fi

unset testResults
[[ ${failed} == true ]] && exit 1

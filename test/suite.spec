#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

local failed=false break_on_fail=false show_summary=false pass
local P9K_IGNORE_VAR_WARNING=true
typeset -AH results

[[ $1 == "-b" || $2 == "-b" ]] && break_on_fail=true
[[ $1 == "-s" || $2 == "-s" ]] && show_summary=true

for test in **/*.spec; do
    if [[ "${test}" == "test/suite.spec" ]]; then
        continue;
    fi
    echo
    [[ $break_on_fail || $show_summary ]] && echo "\x1b[38;5;33mNow executing ${test}...\x1b[0m"
    pass=true
    ./${test} || pass=false
    results[${test}]=${pass}
    [[ ${pass} == false ]] && failed=true
    [[ ${break_on_fail} == true && ${failed} == true ]] && break;
done

if [[ ${show_summary} == true ]]; then
    echo
    echo "Results:"
    for k in "${(ok)results[@]}"; do
      [[ ${results[$k]} == true ]] && echo -n " \x1b[38;5;28m pass \x1b[0m" || echo -n " \x1b[38;5;124m fail \x1b[0m"
      echo "$k"
    done
fi

[[ ${failed} == true ]] && exit 1

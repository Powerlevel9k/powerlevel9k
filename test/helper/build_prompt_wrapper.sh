#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

function __p9k_build_left_prompt() {
    __p9k_build_segment_cache "left"

    # Remove Resets from our output here, to avoid
    # having to touch all tests. Before, we just
    # tested the output of __p9k_build_left_prompt,
    # which printed the prompt without these resets.
    echo "${__p9k_unsafe[left]#\%f\%b\%k}"
}

function __p9k_make_prepare_segment_print() {
    local alignment="${1}"
    local index="${2}"
    typeset -gAH __p9k_unsafe
    local cache_key="${alignment}::${index}"
    # Redeclare the original p9K::prepare_segment function and
    # prefix it with an underscore. That way we can define a
    # new function, that calls the old one, but instead of just
    # filling a cache, it prints the output.
    eval "`declare -f p9k::prepare_segment | sed '1s/.*/_&/'`"

    function p9k::prepare_segment() {
        __p9k_unsafe[${alignment}]=""
        # setopt xtrace
        _p9k::prepare_segment "$@"

        local -a segment_meta=("${(@s:·|·:)__P9K_DATA[SEGMENT_RESULT]}")
        [[ "${segment_meta[7]}" == "false" ]] && return # Segment should not be printed

        local alignment="${segment_meta[2]}"
        __p9k_${alignment}_prompt_segment "${segment_meta[1]}" "${segment_meta[3]}" "${segment_meta[4]}" "${segment_meta[5]}" "${segment_meta[6]}"

        echo "${__p9k_unsafe[${alignment}]#\%f\%b\%k}"
        # unsetopt xtrace
    }
}

function __p9k_reset_prepare_segment() {
    eval "`declare -f _p9k::prepare_segment | sed '1s/^_//'`"
}
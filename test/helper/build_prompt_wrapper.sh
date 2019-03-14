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

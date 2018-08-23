# powerlevel9k Support File - Test Statistics


### Source(s)

[powerlevel9k](https://github.com/bhilburn/powerlevel9k)

### File Description

*This file contains supplemental Test Statistics functions for the rspec_stats.p9k and symfony_tests segments. *

## Table of Contents

- [build_test_stats](#build_test_stats)

## build_test_stats
*Show a ratio of tests vs code. *

#### Arguments

- **$1** (string) of the calling segment
- **$2** (string) Alignment - left | right
- **$3** (integer) Index
- **$4** (bool) Whether the segment should be joined
- **$5** (string) Code Amount
- **$6** (string) Tests Amount
- **$7** (string) Headline
- **$8** (string) Icon


#### Notes

*This function is called by prompt segments to display the information required. *


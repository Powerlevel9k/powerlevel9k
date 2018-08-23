# powerlevel9k Utility Functions


### Source(s)

[powerlevel9k](https://github.com/bhilburn/powerlevel9k)

### File Description

*This file contains some utility-functions for the powerlevel9k ZSH theme. *

## Table of Contents

- [__p9k_update_environment_vars](#__p9k_update_environment_vars)
- [p9k::defined](#p9kdefined)
- [p9k::set_default](#p9kset_default)
- [p9k::print_size_human_readable](#p9kprint_size_human_readable)
- [p9k::get_relevant_item](#p9kget_relevant_item)
- [p9k::segment_in_use](#p9ksegment_in_use)
- [__p9k_print_deprecation_warning](#__p9k_print_deprecation_warning)
- [__p9k_print_deprecation_var_warning](#__p9k_print_deprecation_var_warning)

## __p9k_update_environment_vars
*This function determines if POWERLEVEL9K_ variables have been previously defined and changes them to P9K_ variables. *

#### Arguments

- *Function has no arguments.*


## p9k::defined
*This function determines if a variable has been previously defined, even if empty. *

#### Arguments

- **$1** (string) The name of the variable that should be checked.


#### Returns

- 0 if the variable has been defined (even when empty).


## p9k::set_default
*This function determine if a variable has been previously defined, and only sets the value to the specified default if it hasn't. *

#### Arguments

- **$1** (string) The name of the variable that should be checked.
- **$2** (string) The default value


#### Returns

- Nothing.


#### Notes

*Typeset cannot set the value for an array, so this will only work for scalar values. *

## p9k::print_size_human_readable
*Converts large memory values into a human-readable unit (e.g., bytes --> GB) *

#### Arguments

- **$1** (integer) Size - The number which should be prettified.
- **$2** (string) Base - The base of the number (default Bytes).


#### Notes

*The base can be any of the following: B, K, M, G, T, P, E, Z, Y. *

## p9k::get_relevant_item
*Gets the first value out of a list of items that is not empty. The items are examined by a callback-function. *

#### Arguments

- **$1** (array) A list of items.
- **$2** (string) A callback function to examine if the item is worthy.


#### Notes

*The callback function has access to the inner variable $item. *

## p9k::segment_in_use
*Determine if the passed segment is used in either the LEFT or RIGHT prompt arrays. *

#### Arguments

- **$1** (string) The segment to be tested.


## __p9k_print_deprecation_warning
*Print a deprecation warning if an old segment is in use. *

#### Arguments

- **$1** (associative-array) An associative array that contains the
- deprecated segments as keys, and the new segment names as values.


## __p9k_print_deprecation_var_warning
*Print a deprecation warning if an old variable is in use. *

#### Arguments

- **$1** (associative-array) An associative array that contains
- the deprecated variables as keys, and the new variable
- names as values.



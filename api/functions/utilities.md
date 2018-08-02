# powerlevel9k Utility Functions


### Source(s)

[https://github.com/bhilburn/powerlevel9k](#https://github.com/bhilburn/powerlevel9k)


### File Description

*This file contains some utility-functions for the powerlevel9k ZSH theme. *

## Table of Contents

- [__p9k_update_environment_vars](#__p9k_update_environment_vars)
- [defined](#defined)
- [p9k::set_default](#p9k::set_default)
- [p9k::print_size_human_readable](#p9k::print_size_human_readable)
- [p9k::get_relevant_item](#p9k::get_relevant_item)
- [p9k::segment_in_use](#p9k::segment_in_use)
- [__p9k_print_deprecation_warning](#__p9k_print_deprecation_warning)
- [__p9k_update_var_name](#__p9k_update_var_name)
- [__p9k_print_deprecation_var_warning](#__p9k_print_deprecation_var_warning)
- [__p9k_segment_should_be_Joined](#__p9k_segment_should_be_Joined)
- [__p9k_segment_should_be_Printed](#__p9k_segment_should_be_Printed)
- [__p9k_truncate_path](#__p9k_truncate_path)
- [__p9k_truncate_pathFromRight](#__p9k_truncate_pathFromRight)
- [__p9k_upsearch](#__p9k_upsearch)

## __p9k_update_environment_vars
*This function determines if POWERLEVEL9K_ variables have been previously defined and changes them to P9K_ variables. *

#### Arguments

- *Function has no arguments.*


## defined
*This function determines if a variable has been previously defined, even if empty. *

#### Arguments

- **$1** (string) The name of the variable that should be checked.


#### Returns

- 0 if the variable has been defined.


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


## __p9k_update_var_name
*This function determines if older variable namess have been previously defined and changes them to newer variable names. *

#### Arguments

- **$1** (string) Old variable name
- **$2** (string) New variable name


#### Returns

- 0 if variable was renamed
- 1 if variable could not be renamed


## __p9k_print_deprecation_var_warning
*Print a deprecation warning if an old variable is in use. *

#### Arguments

- **$1** (associative-array) An associative array that contains
- the deprecated variables as keys, and the new variable
- names as values.


## __p9k_segment_should_be_Joined
*A helper function to determine if a segment should be joined or promoted to a full one. *

## __p9k_segment_should_be_Printed
*A helper function to determine if a segment should be printed or not. *

*Conditions have three layers: 1. No segment should print if they provide no content (default condition). 2. Segments can define a default condition on their own, overriding the previous one. 3. Users can set a condition for each segment. This is the trump card, and has highest precedence. *

#### Arguments

- **$1** (string) The stateful name of the segment
- **$2** (string) The user condition that gets evaluated
- **$3** (string) Content of the segment (for default condition)


## __p9k_truncate_path
*Given a directory path, truncate it according to the settings. *

#### Arguments

- **$1** (string) The directory path to be truncated.
- **$2** (integer) Length to truncate to.
- **$3** (string) Delimiter to use.
- **$4** (string) Where to truncate from - "right" | "middle" | "left". If omited, assumes right.


## __p9k_truncate_pathFromRight
*Given a directory path, truncate it according to the settings for `truncate_from_right`. *

#### Arguments

- **$1** (string) Directory path.


#### Notes

*Deprecated. Use `__p9k_truncate_path` instead. *

## __p9k_upsearch
*Search recursively in parent folders for given file. *

#### Arguments

- **$1** (string) Filename to search for.



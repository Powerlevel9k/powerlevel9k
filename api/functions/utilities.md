# powerlevel9k Utility Functions


### Source(s)

[https://github.com/bhilburn/powerlevel9k](#https://github.com/bhilburn/powerlevel9k)


### Author(s)

- Ben Hilburn (bhilburn)
- Dominik Ritter (dritter)


### File Description

*This file contains some utility-functions for the powerlevel9k ZSH theme. *

## Table of Contents

- [defined](#defined)
- [setDefault](#setDefault)
- [printSizeHumanReadable](#printSizeHumanReadable)
- [getRelevantItem](#getRelevantItem)
- [segmentInUse](#segmentInUse)
- [printDeprecationWarning](#printDeprecationWarning)
- [segmentShouldBeJoined](#segmentShouldBeJoined)
- [truncatePath](#truncatePath)
- [truncatePathFromRight](#truncatePathFromRight)
- [upsearch](#upsearch)

## defined
*This function determine if a variable has been previously defined, even if empty. *

#### Arguments

- **$1** (string) The name of the variable that should be checked.


#### Returns

- 0 if the variable has been defined.


## setDefault
*This function determine if a variable has been previously defined, and only sets the value to the specified default if it hasn't. *

#### Arguments

- **$1** (string) The name of the variable that should be checked.
- **$2** (string) The default value


#### Returns

- Nothing.


#### Notes

*Typeset cannot set the value for an array, so this will only work for scalar values. *

## printSizeHumanReadable
*Converts large memory values into a human-readable unit (e.g., bytes --> GB) *

#### Arguments

- **$1** (integer) Size - The number which should be prettified.
- **$2** (string) Base - The base of the number (default Bytes).


#### Notes

*The base can be any of the following: B, K, M, G, T, P, E, Z, Y. *

## getRelevantItem
*Gets the first value out of a list of items that is not empty. The items are examined by a callback-function. *

#### Arguments

- **$1** (array) A list of items.
- **$2** (string) A callback function to examine if the item is worthy.


#### Notes

*The callback function has access to the inner variable $item. *

## segmentInUse
*Determine if the passed segment is used in either the LEFT or RIGHT prompt arrays. *

#### Arguments

- **$1** (string) The segment to be tested.


## printDeprecationWarning
*Print a deprecation warning if an old segment is in use. *

#### Arguments

- **$1** (associative-array) An associative array that contains the
- deprecated segments as keys, and the new segment names as values.


## segmentShouldBeJoined
*A helper function to determine if a segment should be joined or promoted to a full one. *

## truncatePath
*Given a directory path, truncate it according to the settings. *

#### Arguments

- **$1** (string) The directory path to be truncated.
- **$2** (integer) Length to truncate to.
- **$3** (string) Delimiter to use.
- **$4** (string) Where to truncate from - "right" | "middle". If omited, assumes right.


## truncatePathFromRight
*Given a directory path, truncate it according to the settings for `truncate_from_right`. *

#### Arguments

- **$1** (string) Directory path.


#### Notes

*Deprecated. Use `truncatePath` instead. *

## upsearch
*Search recursively in parent folders for given file. *

#### Arguments

- **$1** (string) Filename to search for.


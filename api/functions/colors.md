# powerlevel9k Color Functions


### Source(s)

[https://github.com/bhilburn/powerlevel9k](#https://github.com/bhilburn/powerlevel9k)


### Author(s)

- Ben Hilburn (bhilburn)
- Dominik Ritter (dritter)


### File Description

*This file contains some color-functions for powerlevel9k. *

## Table of Contents

- [termColors](#termColors)
- [getColor](#getColor)
- [backgroundColor](#backgroundColor)
- [foregroundColor](#foregroundColor)
- [getColorCode](#getColorCode)
- [isSameColor](#isSameColor)

## termColors
*This function checks if the terminal supports 256 colors. If it doesn't, an error message is displayed. *

#### Arguments

- *Function has no arguments.*


#### Notes

*You can bypass this check by setting `P9K_IGNORE_TERM_COLORS=true`. *

## getColor
*This function gets the proper color code if it does not exist as a name. *

#### Arguments

- **$1** (misc) Color to check (as a number or string)


## backgroundColor
*Function to set the background color. *

#### Arguments

- **$1** (misc) The background color.


#### Returns

- An escape code string for (re)setting the background color.


#### Notes

*An empty paramenter resets (stops) background color. *

## foregroundColor
*Function to set the foreground color. *

#### Arguments

- **$1** (misc) The foreground color.


#### Returns

- An escape code string for (re)setting the foreground color.


#### Notes

*An empty paramenter resets (stops) foreground color. *

## getColorCode
*Function to get numerical color codes. That way we translate ANSI codes into ZSH-Style color codes. *

#### Arguments

- **$1** (misc) Number or string of color.


## isSameColor
*Check if two colors are equal, even if one is specified as ANSI code. *

#### Arguments

- **$1** (misc) First color (number or string)
- **$2** (misc) Second color (number or string)



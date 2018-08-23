# powerlevel9k Color Functions


### Source(s)

[powerlevel9k](https://github.com/bhilburn/powerlevel9k)

### File Description

*This file contains some color-functions for powerlevel9k. *

## Table of Contents

- [__p9k_term_colors](#__p9k_term_colors)
- [p9k::get_color](#p9kget_color)
- [p9k::background_color](#p9kbackground_color)
- [p9k::foreground_color](#p9kforeground_color)
- [p9k::get_color_code](#p9kget_color_code)
- [p9k::is_same_color](#p9kis_same_color)

## __p9k_term_colors
*This function checks if the terminal supports 256 colors. If it doesn't, an error message is displayed. *

#### Arguments

- *Function has no arguments.*


#### Notes

*You can bypass this check by setting `P9K_IGNORE_TERM_COLORS=true`. *

## p9k::get_color
*This function gets the proper color code if it does not exist as a name. *

#### Arguments

- **$1** (misc) Color to check (as a number or string)


## p9k::background_color
*Function to set the background color. *

#### Arguments

- **$1** (misc) The background color.


#### Returns

- An escape code string for (re)setting the background color.


#### Notes

*An empty paramenter resets (stops) background color. *

## p9k::foreground_color
*Function to set the foreground color. *

#### Arguments

- **$1** (misc) The foreground color.


#### Returns

- An escape code string for (re)setting the foreground color.


#### Notes

*An empty paramenter resets (stops) foreground color. *

## p9k::get_color_code
*Function to get numerical color codes. That way we translate ANSI codes into ZSH-Style color codes. *

#### Arguments

- **$1** (misc) Number or string of color.


## p9k::is_same_color
*Check if two colors are equal, even if one is specified as ANSI code. *

#### Arguments

- **$1** (misc) First color (number or string)
- **$2** (misc) Second color (number or string)



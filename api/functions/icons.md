# powerlevel9k Icon Functions


### Source(s)

[powerlevel9k](https://github.com/bhilburn/powerlevel9k)

### File Description

*This file contains the core icon definitions and icon-functions. *

*These characters require the Powerline fonts to work properly. If you see boxes or bizarre characters below, your fonts are not correctly installed. If you do not want to install a special font, you can set `P9K_MODE` to `compatible`. This shows all icons in regular symbols. *

*For specific fonts configurations, please refer to: - [Awesome-Patched Font](https://github.com/gabrielelana/awesome-terminal-fonts/tree/patching-strategy/patched) - [fontconfig with awesome-font](https://github.com/gabrielelana/awesome-terminal-fonts) - [mapped fontconfig with awesome-font](https://github.com/gabrielelana/awesome-terminal-fonts) and don't forget to source the font maps in your startup script - [nerd-font patched (complete)](https://github.com/ryanoasis/nerd-fonts) and the [cheat sheet](http://nerdfonts.com/#cheat-sheet) - [Powerline-Patched Font](https://github.com/Lokaltog/powerline-fonts) *

## Table of Contents

- [p9k::register_icon](#p9kregister_icon)
- [p9k::register_segment](#p9kregister_segment)
- [p9k::print_icon](#p9kprint_icon)
- [show_defined_icons](#show_defined_icons)

## p9k::register_icon
*This function allows the core code to register the icons that it requires. It will check for icons overriden by the user first, and, if found, will use those instead of the ones defined by the core code. *

#### Arguments

- **$1** (string) Icon name
- **$2** (string) Generic icon
- **$3** (string) Flat / Awesome Patched icon
- **$4** (string) Awesome FontConfig icon
- **$5** (string) Awesome Mapped FontConfig icon
- **$6** (string) NerdFont Complete / FontConfig icon


#### Notes

*You can specify a string, unicode string or codepoint string (for Mapped fonts only). *

#### Usage

```sh
p9k::register_icon "name_of_icon" 'Gen' $'\uXXX' $'\uXXX' '\u'${CODEPOINT_OF_AWESOME_xxx} '\uXXX'

```

#### Example

```sh
p9k::register_icon "LOCK_ICON"  $'\uE0A2'  $'\uE138'  $'\uF023'  '\u'${CODEPOINT_OF_AWESOME_LOCK}  $'\uF023'

```

## p9k::register_segment
*This function allows a segment to register the colors and icons that it requires. It will check for user icon / color overrides first and, if found, will use those instead of the ones defined by the segment. *

#### Arguments

- **$1** (string) Segment name
- **$2** (string) State name or ""
- **$3** (misc) Default background color
- **$4** (misc) Default foreground color
- **$5** (string) Generic icon
- **$6** (string) Flat / Awesome Patched icon
- **$7** (string) Awesome FontConfig icon
- **$8** (string) Awesome Mapped FontConfig icon
- **$9** (string) NerdFont Complete / FontConfig icon


#### Notes

*You can specify a string, unicode string or codepoint string (for Mapped fonts only). *

#### Usage

```sh
p9k::register_segment "segmentName" "stateNameOrEmpty" "p9k::background_color" "p9k::foreground_color" 'Gen' $'\uXXX' $'\uXXX' '\u'${CODEPOINT_OF_AWESOME_xxx} '\uXXX'

```

#### Example

```sh
p9k::register_segment "DIR_WRITABLE" "" "red" "yellow1"  $'\uE0A2'  $'\uE138'  $'\uF023'  '\u'${CODEPOINT_OF_AWESOME_LOCK}  $'\uF023'

```

## p9k::print_icon
*Prints the requested icon. *

#### Arguments

- **$1** (string) Name of icon


## show_defined_icons
*Print all the configured icons alphabetically as KEY -> VALUE pairs. *

#### Arguments

- *Function has no arguments.*



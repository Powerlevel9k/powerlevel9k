# powerlevel9k Icon Functions


### Source(s)

[https://github.com/bhilburn/powerlevel9k](#https://github.com/bhilburn/powerlevel9k)


### Author(s)

- Ben Hilburn (bhilburn)
- Dominik Ritter (dritter)


### File Description

*This file contains some the core icon definitions and icon-functions. *

*These characters require the Powerline fonts to work properly. If you see boxes or bizarre characters below, your fonts are not correctly installed. If you do not want to install a special font, you can set `P9K_MODE` to `compatible`. This shows all icons in regular symbols. *

## Table of Contents

- [registerIcon](#registerIcon)
- [printIcon](#printIcon)

## registerIcon
*This function allows a segment to register the icons that it requires. These icons may be overriden by the user later. Arguments may be a direct call or an array. *

#### Arguments

- **$1** (string) Name of icon
- **$2** (string) Generic icon
- **$3** (string) Flat / Awesome Patched icon
- **$4** (string) Awesome FontConfig icon
- **$5** (string) Awesome Mapped FontConfig icon
- **$6** (string) NerdFont Complete / FontConfig icon


#### Notes

*You can specify a string, unicode string or codepoint string (for Mapped fonts only). *

#### Usage

```sh
registerIcon "name_of_icon" 'Gen' $'\uXXX' $'\uXXX' '\u'$CODEPOINT_OF_AWESOME_xxx '\uXXX'

```

#### Example

```sh
registerIcon "LOCK_ICON"  $'\UE0A2'  $'\UE138'  $'\UF023'  '\u'$CODEPOINT_OF_AWESOME_LOCK  $'\UF023'

```

## printIcon
*Safety function for printing icons. Prints the named icon, or if that icon is undefined, the string name. *

#### Arguments

- **$1** (string) Name of icon



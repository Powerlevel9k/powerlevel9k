#!/usr/bin/env zsh
# vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8
################################################################
# @title powerlevel9k Color Functions
# @source [powerlevel9k](https://github.com/bhilburn/powerlevel9k)
##
# @info
#   This file contains some color-functions for powerlevel9k.
##

################################################################
# @description
#   This function checks if the terminal supports 256 colors.
#   If it doesn't, an error message is displayed.
##
# @noargs
##
# @note
#   You can bypass this check by setting `P9K_IGNORE_TERM_COLORS=true`.
##
function termColors() {
  [[ $P9K_IGNORE_TERM_COLORS == true ]] && return

  local term_colors

  if which tput &>/dev/null; then
	term_colors=$(tput colors)
  else
	term_colors=$(echotc Co)
  fi
  if (( ! $? && ${term_colors:-0} < 256 )); then
    print -P "%F{red}WARNING!%f Your terminal appears to support fewer than 256 colors!"
    print -P "If your terminal supports 256 colors, please export the appropriate environment variable"
    print -P "_before_ loading this theme in your \~\/.zshrc. In most terminal emulators, putting"
    print -P "%F{blue}export TERM=\"xterm-256color\"%f at the top of your \~\/.zshrc is sufficient."
  fi
}

################################################################
# @description
#   This function gets the proper color code if it does not exist as a name.
##
# @args
#   $1 misc Color to check (as a number or string)
##
function getColor() {
  # no need to check numerical values
  if [[ "$1" = <-> ]]; then
    if [[ "$1" = <8-15> ]]; then
      1=$(($1 - 8))
    fi
  else
    # named color added to parameter expansion print -P to test if the name exists in terminal
    local named="%K{$1}"
    # https://misc.flogisoft.com/bash/tip_colors_and_formatting
    local default="$'\033'\[49m"
    # http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
    local quoted=$(printf "%q" $(print -P "$named"))
    if [[ $quoted = "$'\033'\[49m" && $1 != "black" ]]; then
        # color not found, so try to get the code
        1=$(getColorCode $1)
    fi
  fi
  echo -n "$1"
}

################################################################
# @description
#   Function to set the background color.
##
# @args
#   $1 misc The background color.
##
# @returns
#   An escape code string for (re)setting the background color.
##
# @note
#   An empty paramenter resets (stops) background color.
##
function backgroundColor() {
  if [[ -n $1 ]]; then
    echo -n "%K{$(getColor $1)}"
  else
    echo -n "%k"
  fi
}

################################################################
# @description
#   Function to set the foreground color.
##
# @args
#   $1 misc The foreground color.
##
# @returns
#   An escape code string for (re)setting the foreground color.
##
# @note
#   An empty paramenter resets (stops) foreground color.
##
function foregroundColor() {
  if [[ -n $1 ]]; then
    echo -n "%F{$(getColor $1)}"
  else
    echo -n "%f"
  fi
}

################################################################
# @description
#   Function to get numerical color codes. That way we translate
#   ANSI codes into ZSH-Style color codes.
##
# @args
#   $1 misc Number or string of color.
##
function getColorCode() {
  # Check if given value is already numerical
  if [[ "$1" == <-> ]]; then
    # ANSI color codes distinguish between "foreground"
    # and "background" colors. We don't need to do that,
    # as ZSH uses a 256 color space anyway.
    if [[ "$1" == <8-15> ]]; then
      echo -n $(($1 - 8))
    else
      echo -n "$1"
    fi
  # Check if value is none with any case.
  elif [[ "${(L)1}" == "none" ]]; then
    echo -n 'none'
  else
    typeset -A codes
    # https://jonasjacek.github.io/colors/
    # use color names by default to allow dark/light themes to adjust colors based on names
    codes[black]=0
    codes[red]=1
    codes[maroon]=1 # alt name
    codes[green]=2
    codes[yellow]=3
    codes[olive]=3 # alt name
    codes[blue]=4
    codes[navy]=4 # alt name
    codes[magenta]=5
    codes[cyan]=6
    codes[teal]=6 # alt name
    codes[lightgrey]=7
    codes[silver]=7 # alt name
    codes[darkgrey]=8
    codes[grey]=8 # alt name
    codes[lightred]=9
    codes[lightgreen]=10
    codes[lime]=10 # alt name
    codes[lightyellow]=11
    codes[lightblue]=12
    codes[lightmagenta]=13
    codes[fuchsia]=13 # alt name
    codes[lightcyan]=14
    codes[aqua]=14 # alt name
    codes[white]=15
    codes[grey0]=16
    codes[navyblue]=17
    codes[darkblue]=18
    codes[blue3]=19
    codes[blue3a]=20
    codes[blue1]=21
    codes[darkgreen]=22
    codes[deepskyblue4]=23
    codes[deepskyblue4a]=24
    codes[deepskyblue4b]=25
    codes[dodgerblue3]=26
    codes[dodgerblue2]=27
    codes[green4]=28
    codes[springgreen4]=29
    codes[turquoise4]=30
    codes[deepskyblue3]=31
    codes[deepskyblue3a]=32
    codes[dodgerblue1]=33
    codes[green3]=34
    codes[springgreen3]=35
    codes[darkcyan]=36
    codes[lightseagreen]=37
    codes[deepskyblue2]=38
    codes[deepskyblue1]=39
    codes[green3a]=40
    codes[springgreen3a]=41
    codes[springgreen2]=42
    codes[cyan3]=43
    codes[darkturquoise]=44
    codes[turquoise2]=45
    codes[green1]=46
    codes[springgreen2a]=47
    codes[springgreen1]=48
    codes[mediumspringgreen]=49
    codes[cyan2]=50
    codes[cyan1]=51
    codes[darkred]=52
    codes[deeppink4]=53
    codes[purple4]=54
    codes[purple4a]=55
    codes[purple3]=56
    codes[blueviolet]=57
    codes[orange4]=58
    codes[grey37]=59
    codes[mediumpurple4]=60
    codes[slateblue3]=61
    codes[slateblue3a]=62
    codes[royalblue1]=63
    codes[chartreuse4]=64
    codes[darkseagreen4]=65
    codes[paleturquoise4]=66
    codes[steelblue]=67
    codes[steelblue3]=68
    codes[cornflowerblue]=69
    codes[chartreuse3]=70
    codes[darkseagreen4a]=71
    codes[cadetblue]=72
    codes[cadetbluea]=73
    codes[skyblue3]=74
    codes[steelblue1]=75
    codes[chartreuse3a]=76
    codes[palegreen3]=77
    codes[seagreen3]=78
    codes[aquamarine3]=79
    codes[mediumturquoise]=80
    codes[steelblue1a]=81
    codes[chartreuse2a]=82
    codes[seagreen2]=83
    codes[seagreen1]=84
    codes[seagreen1a]=85
    codes[aquamarine1]=86
    codes[darkslategray2]=87
    codes[darkreda]=88
    codes[deeppink4a]=89
    codes[darkmagenta]=90
    codes[darkmagentaa]=91
    codes[darkviolet]=92
    codes[purple]=93
    codes[orange4a]=94
    codes[lightpink4]=95
    codes[plum4]=96
    codes[mediumpurple3]=97
    codes[mediumpurple3a]=98
    codes[slateblue1]=99
    codes[yellow4]=100
    codes[wheat4]=101
    codes[grey53]=102
    codes[lightslategrey]=103
    codes[mediumpurple]=104
    codes[lightslateblue]=105
    codes[yellow4a]=106
    codes[darkolivegreen3]=107
    codes[darkseagreen]=108
    codes[lightskyblue3]=109
    codes[lightskyblue3a]=110
    codes[skyblue2]=111
    codes[chartreuse2]=112
    codes[darkolivegreen3a]=113
    codes[palegreen3a]=114
    codes[darkseagreen3]=115
    codes[darkslategray3]=116
    codes[skyblue1]=117
    codes[chartreuse1]=118
    codes[lightgreena]=119
    codes[lightgreenb]=120
    codes[palegreen1]=121
    codes[aquamarine1a]=122
    codes[darkslategray1]=123
    codes[red3]=124
    codes[deeppink4b]=125
    codes[mediumvioletred]=126
    codes[magenta3]=127
    codes[darkvioleta]=128
    codes[purplea]=129
    codes[darkorange3]=130
    codes[indianred]=131
    codes[hotpink3]=132
    codes[mediumorchid3]=133
    codes[mediumorchid]=134
    codes[mediumpurple2]=135
    codes[darkgoldenrod]=136
    codes[lightsalmon3]=137
    codes[rosybrown]=138
    codes[grey63]=139
    codes[mediumpurple2a]=140
    codes[mediumpurple1]=141
    codes[gold3]=142
    codes[darkkhaki]=143
    codes[navajowhite3]=144
    codes[grey69]=145
    codes[lightsteelblue3]=146
    codes[lightsteelblue]=147
    codes[yellow3]=148
    codes[darkolivegreen3b]=149
    codes[darkseagreen3a]=150
    codes[darkseagreen2]=151
    codes[lightcyan3]=152
    codes[lightskyblue1]=153
    codes[greenyellow]=154
    codes[darkolivegreen2]=155
    codes[palegreen1a]=156
    codes[darkseagreen2a]=157
    codes[darkseagreen1]=158
    codes[paleturquoise1]=159
    codes[red3a]=160
    codes[deeppink3]=161
    codes[deeppink3a]=162
    codes[magenta3a]=163
    codes[magenta3b]=164
    codes[magenta2]=165
    codes[darkorange3a]=166
    codes[indianreda]=167
    codes[hotpink3a]=168
    codes[hotpink2]=169
    codes[orchid]=170
    codes[mediumorchid1]=171
    codes[orange3]=172
    codes[lightsalmon3a]=173
    codes[lightpink3]=174
    codes[pink3]=175
    codes[plum3]=176
    codes[violet]=177
    codes[gold3a]=178
    codes[lightgoldenrod3]=179
    codes[tan]=180
    codes[mistyrose3]=181
    codes[thistle3]=182
    codes[plum2]=183
    codes[yellow3a]=184
    codes[khaki3]=185
    codes[lightgoldenrod2]=186
    codes[lightyellow3]=187
    codes[grey84]=188
    codes[lightsteelblue1]=189
    codes[yellow2]=190
    codes[darkolivegreen1]=191
    codes[darkolivegreen1a]=192
    codes[darkseagreen1a]=193
    codes[honeydew2]=194
    codes[lightcyan1]=195
    codes[red1]=196
    codes[deeppink2]=197
    codes[deeppink1]=198
    codes[deeppink1a]=199
    codes[magenta2a]=200
    codes[magenta1]=201
    codes[orangered1]=202
    codes[indianred1]=203
    codes[indianred1a]=204
    codes[hotpink]=205
    codes[hotpinka]=206
    codes[mediumorchid1a]=207
    codes[darkorange]=208
    codes[salmon1]=209
    codes[lightcoral]=210
    codes[palevioletred1]=211
    codes[orchid2]=212
    codes[orchid1]=213
    codes[orange1]=214
    codes[sandybrown]=215
    codes[lightsalmon1]=216
    codes[lightpink1]=217
    codes[pink1]=218
    codes[plum1]=219
    codes[gold1]=220
    codes[lightgoldenrod2a]=221
    codes[lightgoldenrod2b]=222
    codes[navajowhite1]=223
    codes[mistyrose1]=224
    codes[thistle1]=225
    codes[yellow1]=226
    codes[lightgoldenrod1]=227
    codes[khaki1]=228
    codes[wheat1]=229
    codes[cornsilk1]=230
    codes[grey100]=231
    codes[grey3]=232
    codes[grey7]=233
    codes[grey11]=234
    codes[grey15]=235
    codes[grey19]=236
    codes[grey23]=237
    codes[grey27]=238
    codes[grey30]=239
    codes[grey35]=240
    codes[grey39]=241
    codes[grey42]=242
    codes[grey46]=243
    codes[grey50]=244
    codes[grey54]=245
    codes[grey58]=246
    codes[grey62]=247
    codes[grey66]=248
    codes[grey70]=249
    codes[grey74]=250
    codes[grey78]=251
    codes[grey82]=252
    codes[grey85]=253
    codes[grey89]=254
    codes[grey93]=255

    # for testing purposes in terminal
    if [[ "$1" == "foreground"  ]]; then
        # call via `getColorCode foreground`
        for i in "${(k@)codes}"; do
            print -P "$(foregroundColor $i)$(getColor $i) - $i$(foregroundColor)"
        done
    elif [[ "$1" == "background"  ]]; then
        # call via `getColorCode background`
        for i in "${(k@)codes}"; do
            print -P "$(backgroundColor $i)$(getColor $i) - $i$(backgroundColor)"
        done
    else
        #[[ -n "$1" ]] bg="%K{$1}" || bg="%k"
        # Strip eventual "bg-" prefixes
        1=${1#bg-}
        # Strip eventual "fg-" prefixes
        1=${1#fg-}
        # Strip eventual "br" prefixes ("bright" colors)
        1=${1#br}
        echo -n $codes[$1]
    fi
  fi
}

################################################################
# @description
#   Check if two colors are equal, even if one is specified as ANSI code.
##
# @args
#   $1 misc First color (number or string)
#   $2 misc Second color (number or string)
##
function isSameColor() {
  if [[ "$1" == "NONE" || "$2" == "NONE" ]]; then
    return 1
  fi

  local color1=$(getColorCode "$1")
  local color2=$(getColorCode "$2")

  return $(( color1 != color2 ))
}

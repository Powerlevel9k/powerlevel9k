#!/usr/bin/env zsh
# vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8
################################################################
# @title powerlevel9k Color Functions
# @source [powerlevel9k](https://github.com/bhilburn/powerlevel9k)
##
# @info
#   This file contains some color-functions for powerlevel9k.
##

typeset -gAh __P9K_COLORS
# https://jonasjacek.github.io/colors/
# use color names by default to allow dark/light themes to adjust colors based on names
# http://plumbum.readthedocs.io/en/latest/colors.html
# alternate color names assigned where there are duplicates.
__P9K_COLORS=(
  black 000
  red 001
  maroon 001 # alt name
  green 002
  yellow 003
  olive 003 # alt name
  blue 004
  navy 004 # alt name
  magenta 005
  cyan 006
  teal 006 # alt name
  lightgrey 007
  silver 007 # alt name
  darkgrey 008
  grey 008 # alt name
  lightred 009
  lightgreen 010
  lime 010 # alt name
  lightyellow 011
  lightblue 012
  lightmagenta 013
  fuchsia 013 # alt name
  lightcyan 014
  aqua 014 # alt name
  white 015
  grey0 016
  navyblue 017
  darkblue 018
  blue3 019
  blue3a 020
  blue1 021
  darkgreen 022
  deepskyblue4 023
  deepskyblue4a 024
  deepskyblue4b 025
  dodgerblue3 026
  dodgerblue2 027
  green4 028
  springgreen4 029
  turquoise4 030
  deepskyblue3 031
  deepskyblue3a 032
  dodgerblue1 033
  green3 034
  springgreen3 035
  darkcyan 036
  lightseagreen 037
  deepskyblue2 038
  deepskyblue1 039
  green3a 040
  springgreen3a 041
  springgreen2 042
  cyan3 043
  darkturquoise 044
  turquoise2 045
  green1 046
  springgreen2a 047
  springgreen1 048
  mediumspringgreen 049
  cyan2 050
  cyan1 051
  darkred 052
  deeppink4 053
  purple4 054
  purple4a 055
  purple3 056
  blueviolet 057
  orange4 058
  grey37 059
  mediumpurple4 060
  slateblue3 061
  slateblue3a 062
  royalblue1 063
  chartreuse4 064
  darkseagreen4 065
  paleturquoise4 066
  steelblue 067
  steelblue3 068
  cornflowerblue 069
  chartreuse3 070
  darkseagreen4a 071
  cadetblue 072
  cadetbluea 073
  skyblue3 074
  steelblue1 075
  chartreuse3a 076
  palegreen3 077
  seagreen3 078
  aquamarine3 079
  mediumturquoise 080
  steelblue1a 081
  chartreuse2a 082
  seagreen2 083
  seagreen1 084
  seagreen1a 085
  aquamarine1 086
  darkslategray2 087
  darkreda 088
  deeppink4a 089
  darkmagenta 090
  darkmagentaa 091
  darkviolet 092
  purple 093
  orange4a 094
  lightpink4 095
  plum4 096
  mediumpurple3 097
  mediumpurple3a 098
  slateblue1 099
  yellow4 100
  wheat4 101
  grey53 102
  lightslategrey 103
  mediumpurple 104
  lightslateblue 105
  yellow4a 106
  darkolivegreen3 107
  darkseagreen 108
  lightskyblue3 109
  lightskyblue3a 110
  skyblue2 111
  chartreuse2 112
  darkolivegreen3a 113
  palegreen3a 114
  darkseagreen3 115
  darkslategray3 116
  skyblue1 117
  chartreuse1 118
  lightgreena 119
  lightgreenb 120
  palegreen1 121
  aquamarine1a 122
  darkslategray1 123
  red3 124
  deeppink4b 125
  mediumvioletred 126
  magenta3 127
  darkvioleta 128
  purplea 129
  darkorange3 130
  indianred 131
  hotpink3 132
  mediumorchid3 133
  mediumorchid 134
  mediumpurple2 135
  darkgoldenrod 136
  lightsalmon3 137
  rosybrown 138
  grey63 139
  mediumpurple2a 140
  mediumpurple1 141
  gold3 142
  darkkhaki 143
  navajowhite3 144
  grey69 145
  lightsteelblue3 146
  lightsteelblue 147
  yellow3 148
  darkolivegreen3b 149
  darkseagreen3a 150
  darkseagreen2 151
  lightcyan3 152
  lightskyblue1 153
  greenyellow 154
  darkolivegreen2 155
  palegreen1a 156
  darkseagreen2a 157
  darkseagreen1 158
  paleturquoise1 159
  red3a 160
  deeppink3 161
  deeppink3a 162
  magenta3a 163
  magenta3b 164
  magenta2 165
  darkorange3a 166
  indianreda 167
  hotpink3a 168
  hotpink2 169
  orchid 170
  mediumorchid1 171
  orange3 172
  lightsalmon3a 173
  lightpink3 174
  pink3 175
  plum3 176
  violet 177
  gold3a 178
  lightgoldenrod3 179
  tan 180
  mistyrose3 181
  thistle3 182
  plum2 183
  yellow3a 184
  khaki3 185
  lightgoldenrod2 186
  lightyellow3 187
  grey84 188
  lightsteelblue1 189
  yellow2 190
  darkolivegreen1 191
  darkolivegreen1a 192
  darkseagreen1a 193
  honeydew2 194
  lightcyan1 195
  red1 196
  deeppink2 197
  deeppink1 198
  deeppink1a 199
  magenta2a 200
  magenta1 201
  orangered1 202
  indianred1 203
  indianred1a 204
  hotpink 205
  hotpinka 206
  mediumorchid1a 207
  darkorange 208
  salmon1 209
  lightcoral 210
  palevioletred1 211
  orchid2 212
  orchid1 213
  orange1 214
  sandybrown 215
  lightsalmon1 216
  lightpink1 217
  pink1 218
  plum1 219
  gold1 220
  lightgoldenrod2a 221
  lightgoldenrod2b 222
  navajowhite1 223
  mistyrose1 224
  thistle1 225
  yellow1 226
  lightgoldenrod1 227
  khaki1 228
  wheat1 229
  cornsilk1 230
  grey100 231
  grey3 232
  grey7 233
  grey11 234
  grey15 235
  grey19 236
  grey23 237
  grey27 238
  grey30 239
  grey35 240
  grey39 241
  grey42 242
  grey46 243
  grey50 244
  grey54 245
  grey58 246
  grey62 247
  grey66 248
  grey70 249
  grey74 250
  grey78 251
  grey82 252
  grey85 253
  grey89 254
  grey93 255
)

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
__p9k_term_colors() {
  [[ $P9K_IGNORE_TERM_COLORS == true ]] && return

  local __p9k_term_colors

  if which tput &>/dev/null; then
	__p9k_term_colors=$(tput colors)
  else
	__p9k_term_colors=$(echotc Co)
  fi
  if (( ! $? && ${__p9k_term_colors:-0} < 256 )); then
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
p9k::get_color() {
  # no need to check numerical values
  [[ "$1" != <-> ]] && 1=$(p9k::get_color_code $1)
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
p9k::background_color() {
  [[ -n $1 ]] && echo -n "%K{$(p9k::get_color $1)}" || echo -n "%k"
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
p9k::foreground_color() {
  [[ -n $1 ]] && echo -n "%F{$(p9k::get_color $1)}" || echo -n "%f"
}

################################################################
# @description
#   Function to get numerical color codes. That way we translate
#   ANSI codes into ZSH-Style color codes.
##
# @args
#   $1 misc Number or string of color.
##
p9k::get_color_code() {
  # Exit early: Check if given value is already numerical
  if [[ "$1" = <-> ]]; then
    # Pad color with zeroes
    echo -n "${(l:3::0:)1}"
    return
  else
    # for testing purposes in terminal
    if [[ "$1" == "foreground"  ]]; then
      # call via `p9k::get_color_code foreground`
      for i in "${(ok@)__P9K_COLORS}"; do
        print -P "$(p9k::foreground_color $i)$(p9k::get_color $i) - $i$(p9k::foreground_color)"
      done
    elif [[ "$1" == "background"  ]]; then
      # call via `p9k::get_color_code background`
      for i in "${(ok@)__P9K_COLORS}"; do
        print -P "$(p9k::background_color $i)$(p9k::get_color $i) - $i$(p9k::background_color)"
      done
    else
      # Strip eventual "bg-" prefixes
      1=${1#bg-}
      # Strip eventual "fg-" prefixes
      1=${1#fg-}
      # Strip eventual "br" prefixes ("bright" colors)
      1=${1#br}
      local color_code=${__P9K_COLORS[$1]}
      [[ "${color_code}" != "" ]] && echo -n "${color_code}" || echo -n -1
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
p9k::is_same_color() {
  if [[ "$1" == "NONE" || "$2" == "NONE" ]]; then
    return 1
  fi

  local color1=$(p9k::get_color_code "$1")
  local color2=$(p9k::get_color_code "$2")

  return $(( color1 != color2 ))
}

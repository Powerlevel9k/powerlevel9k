# Stylizing

You can configure the look and feel of your prompt easily with some built-in
options. This includes changing foreground and background colors, replacing
icons and separators, adding newlines...
**Please be aware that styling options should always be set before loading/sourcing P9K!
Not every option can be changed at runtime.**

## General Stylizing Options

|Option|Default|Effect|
|------|-------|------|
|`P9K_PROMPT_ON_NEWLINE`|`false`|Display the prompt on the next line. Also checkout the sgement `newline`.|
|`P9K_RPROMPT_ON_NEWLINE`|`false`|Display `RPROMPT` on the same line as `PROMPT` if `P9K_PROMPT_ON_NEWLINE=true`|
|`P9K_MULTILINE_FIRST_PROMPT_PREFIX_ICON`|`?`|If the prompt is more than one line, this will be the prefix for the first line.|
|`P9K_MULTILINE_NEWLINE_PROMPT_PREFIX_ICON`|`?`|If the prompt is at least tree lines, this will be the prefix for all lines that are neither the first nor the last.|
|`P9K_MULTILINE_LAST_PROMPT_PREFIX_ICON`|`?`|If the prompt is more than one line, this will be the prefix for the last line.|
|`P9K_PROMPT_ADD_NEWLINE`|`false`|Adds a newline before displaying the prompt|
|`P9K_PROMPT_ADD_NEWLINE_COUNT`|`1`|Change the amound of newlines added if `P9K_PROMPT_ADD_NEWLINE=true`.|
|`P9K_DISABLE_RPROMPT`|`false`|Disables `RPROMPT`.|
|`P9K_COLOR_SCHEME`|unset|Set to `light` to invert default background and foreground color.|
|`P9K_{LEFT,RIGHT}_SEGMENT_SEPARATOR_ICON`|`?`|This is the separator between two segments of different color.|
|`P9K_{LEFT,RIGHT}_SUBSEGMENT_SEPARATOR_ICON`|`?`|This is the separator between two segments of the same color.|
|`P9K_WHITESPACE_BETWEEN_{LEFT,RIGHT}_SEGMENTS`|` `|How much space there is between segment text and segment separator.|
|``|``||

## Per Segment Stylizing

There are two kinds of segments stateless and stateful ones.
This short expression describes how the variable naming scheme works:  
Prefix `P9K_` + segment name + optionally segment state name + what you want to change:
`P9K_<segment>[_<state>]_[BACKGROUND|FOREGROUND|BOLD|ICON[_BOLD|_COLOR]]`

Detailed explanation:
|Option|Explanation|Example|
|------|-----------|-------|
|`P9K_${segment}_BACKGROUND="$color"`|color for background of stateless segment|`P9K_TIME_BACKGROUND=001`|
|`P9K_${segment}_${state}_BACKGROUND="$color"`|color for background of stateful segment|`P9K_DIR_ETC_BACKGROUND=001`|
|`P9K_${segment}_FOREGROUND="$color"`|color for foreground of stateless segment|`P9K_TIME_BACFOREGND=2`|
|`P9K_${segment}_${state}_FOREGROUND="$color"`|color for foreground of stateful segment|`P9K_DIR_ETC_FOREGROUND=2`|
|`P9K_${segment}_BOLD=true`|set stateless segment to bold|`P9K_TIME_BOLD=true`|
|`P9K_${segment}_${state}_BOLD=true`|set stateful segment to bold|`P9K_DIR_ETC_BOLD="true"`|
|`P9K_${segment}_ICON="$icon"`|set icon/glyph for set stateless segment|`P9K_TIME_ICON="It's"`|
|`P9K_${segment}_${state}_ICON="$icon"`|icon/glyph for set stateful segment|`P9K_DIR_ETC_ICON=$'\u2699'`|
|`P9K_${segment}_ICON_BOLD=true`|icon/glyph/text to bold for stateless segment if font supports it|`P9K_TIME_ICON_BOLD=true`|
|`P9K_${segment}_${state}_ICON_BOLD=true`|set icon/glyph/text to bold for stateful segment if font supports it|`P9K_DIR_ETC_ICON_BOLD="true"`|
|`P9K_${segment}_ICON_COLOR="$color"`|color for icon of stateless segment|`P9K_TIME_ICON=blue`|
|`P9K_${segment}_${state}_ICON_COLOR="$color"`|color for icon of stateful segment|`P9K_DIR_ETC_ICON="#fff8e7"`|

List of stateful segments with their states. Please see segment documentation for detailed
descriptions.:
| Segment        | State                                                      |
|----------------|------------------------------------------------------------|
| `BATTERY`      | `CHARGED`, `CHARGING`, `DISCONNECTED`, `LOW`               |
| `CONTEXT`      | `DEFAULT`, `REMOTE`, `REMOTE_SUDO`, `ROOT`, `SUDO`         |
| `DIR`          | `DEFAULT`, `ETC`, `HOME`, `HOME_SUBFOLDER`, `NOT_WRITABLE` |
| `DIR_WRITABLE` | `FORBIDDEN`                                                |
| `DISK_USAGE`   | `CRITICAL`, `NORMAL`, `WARNING`                            |
| `GITSTATUS`    | `CLEAN`, `MODIFIED`, `UNTRACKED`                           |
| `HOST`         | `LOCAL`, `REMOTE`                                          |
| `LOAD`         | `CRITICAL`, `NORMAL`, `WARNING`                            |
| `STATUS`       | `ERROR`, `ERROR_CR`, `OK`                                  |
| `TEST_STATS`   | `AVG`, `BAD`, `GOOD`                                       |
| `USER`         | `DEFAULT`, `REMOTE`, `REMOTE_SUDO`, `ROOT`, `SUDO`         |
| `VAGRANT`      | `DOWN`, `UP`                                               |
| `VCS`          | `CLEAN`, `CLOBBERED`, `MODIFIED`, `UNTRACKED`              |
| `VI_MODE`      | `INSERT`, `NORMAL`, `SEARCH`, `VISUAL`                     |

## Usable Colors

You can set colors in three different way:
- <colorstring> : For example "red" (get a full list with `p9k::get_color foreground` or `p9k::get_color background`)
- 0-255 : A decimal number (Be aware that 0-16 are dynamic and might get changed by your terminal theme)
- "#000000"-"#ffffff" : A hexadecimal number. This is only available in zsh version >=5.7
  and if your terminal emulator supports truecolor/24bit colors. We also recommend
  to add this to your `.zshrc` in case your terminal does not support truecolor:
  ```zsh
  [[ $COLORTERM = *(24bit|truecolor)* ]] || zmodload zsh/nearcolor
  ```

For a full list of supported colors, run this little code in your terminal:

```zsh
for code ({000..255}) print -P -- "$code: %F{$code}This is how your text would look like%f"
```
Please note that the values 1-16 are dynamic color used by themes and might
vary. You can also reference this color chart:

![](https://user-images.githubusercontent.com/704406/43988708-64c0fa52-9d4c-11e8-8cf9-c4d4b97a5200.png)

## Glue Segments Together

It is possible to display two segments as one, by adding `_joined` to your segment definition. The segments are always joined with their predecessor, so be sure that this is always visible. Otherwise you may get unwanted results. For example, if you want to join `status` and `background_jobs` in your right prompt together, set:
```zsh
P9K_RIGHT_PROMPT_ELEMENTS=(status background_jobs_joined)
```
This works with every segment, even with custom ones and with conditional ones.

## Icon Customization

Please refer to the segment documentation for icon customization of segment specific icons.
For general icon changes check out [Per Segment Stylizing](#per-segment-stylizing).

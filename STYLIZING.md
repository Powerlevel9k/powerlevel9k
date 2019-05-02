# Stylizing

You can configure the look and feel of your prompt easily with some built-in
options. This includes changing foreground and background colors, replacing
icons and separators, adding newlines...
**Please be away that styling options should be set before loading/sourcing
P9K and can not always be changed at runtime!**

## Double-Lined Prompt

By default, `powerlevel9k` is a single-lined prompt. If you would like to have
the segments display on one line, and print the command prompt below it, simply
define `P9K_PROMPT_ON_NEWLINE` in your `~/.zshrc`:
```zsh
P9K_PROMPT_ON_NEWLINE=true
```

If you want the right prompt to appear on the newline as well, simply
define `P9K_RPROMPT_ON_NEWLINE` as well in your `~/.zshrc`:
```zsh
P9K_PROMPT_ON_NEWLINE=true
P9K_RPROMPT_ON_NEWLINE=true
```
Here is an example of a double-lined prompt where the `RPROMPT` is drawn on the newline:

![](http://bhilburn.org/content/images/2015/03/double-line.png)

If you want to split your segments up between two lines, make use of the `newline` segment in segment list. For example:
```zsh
P9K_LEFT_PROMPT_ELEMENTS=(dir newline vcs)
```

Will give you this left-side prompt:

![](https://user-images.githubusercontent.com/569571/32179732-89335734-bd66-11e7-9e21-80d345e6827c.png)

You can customize the icons used to draw the multi-line prompt by setting the
following variables in your `~/.zshrc`:
```zsh
P9K_MULTILINE_FIRST_PROMPT_PREFIX_ICON=$'\u21B1'
P9K_MULTILINE_NEWLINE_PROMPT_PREFIX_ICON="|"       # if you use extra `newline`
P9K_MULTILINE_LAST_PROMPT_PREFIX_ICON=$'\u21B3'
```

## Adding Newline Before Each Prompt

If you would like to add a newline before each prompt / print loop, like
what's shown in the picture below:

![](https://cloud.githubusercontent.com/assets/13166286/23095963/5b3d05da-f64e-11e6-8334-58e9cb1da3ab.png)

Then just set the following in your `~/.zshrc`:
```zsh
P9K_PROMPT_ADD_NEWLINE=true
```

You can configure how many `newlines` are inserted by setting the variable
`P9K_PROMPT_ADD_NEWLINE_COUNT` (defaults to `1`).

## Disable Right Prompt

If you do not want a right prompt, you can completely disable it by setting:
```zsh
P9K_DISABLE_RPROMPT=true
```

## Light Color Theme

If you prefer to use "light" colors, simply set `P9K_COLOR_SCHEME`
to `light` in your `~/.zshrc`, and you're all set!
```zsh
P9K_COLOR_SCHEME='light'
```
The 'light' color scheme works well for ['Solarized
Light'](https://github.com/altercation/solarized) users. Check it out:

![](http://bhilburn.org/content/images/2015/03/solarized-light.png)

## Segment Color Customization

For each segment in your prompt, you can specify a foreground and background
color by setting them in your `~/.zshrc`. Use the segment names from the
[Available Prompt Segments](https://github.com/bhilburn/powerlevel9k/blob/master/README.md#available-prompt-segments)
section of the `README.md`. For example, to change the appearance of
the `time` segment, you would use:
```zsh
P9K_TIME_FOREGROUND='red'
P9K_TIME_BACKGROUND='blue'
```
Note that you can also use a colorcode value. Example:
```zsh
P9K_TIME_FOREGROUND='021' # Dark blue
```

**Some segments are not that easy to color and have stateful names.** Please
refer to section [Special Segment Colors](#special-segment-colors) and
the documentation for the segement you want to change colors.

## Special Segment Colors

Some segments have state. For example, if you become root, or modify a file in your version
control system, segments try to reflect this fact by changing the color.
For these segments you still can modify the color to your needs by setting a variable like 
`P9K_<name-of-segment>_<state>_[BACKGROUND|FOREGROUND]`.

Segments with state are:

| Segment          | States                                              |
|------------------|-----------------------------------------------------|
| `battery`        | `LOW`, `CHARGING`, `CHARGED`, `DISCONNECTED`        |
| `context`        | `DEFAULT`, `ROOT`, `SUDO`, `REMOTE`, `REMOTE_SUDO`  |
| `dir`            | `HOME`, `HOME_SUBFOLDER`, `DEFAULT`, `ETC`          |
| `dir_writable`   | `FORBIDDEN`                                         |
| `disk_usage`     | `NORMAL`, `WARNING`, `CRITICAL`                     |
| `host`           | `LOCAL`, `REMOTE`                                   |
| `load`           | `CRITICAL`, `WARNING`, `NORMAL`                     |
| `rspec_stats`    | `STATS_GOOD`, `STATS_AVG`, `STATS_BAD`              |
| `status`         | `ERROR`, `OK` (note: only, if verbose is not false) |
| `symfony2_tests` | `TESTS_GOOD`, `TESTS_AVG`, `TESTS_BAD`              |
| `user`           | `DEFAULT`, `SUDO`, `ROOT`                           |
| `vcs`            | `CLEAN`, `UNTRACKED`, `MODIFIED`                    |
| `vi_mode`        | `NORMAL`, `INSERT`                                  |

Example:
```zsh
# `vcs` color customization
P9K_VCS_CLEAN_FOREGROUND='blue'
P9K_VCS_CLEAN_BACKGROUND='black'
P9K_VCS_UNTRACKED_FOREGROUND='yellow'
P9K_VCS_UNTRACKED_BACKGROUND='black'
P9K_VCS_MODIFIED_FOREGROUND='red'
P9K_VCS_MODIFIED_BACKGROUND='black'

# `vi_mode` color customization
P9K_VI_MODE_INSERT_FOREGROUND='teal'
```

## Test Terminal Colors

For a full list of supported colors, run this little code in your terminal:

```zsh
for code ({000..255}) print -P -- "$code: %F{$code}This is how your text would look like%f"
```
Please note that the values 1-16 are dynamic color used by themes and might
vary. You can also reference this color chart:

![](https://user-images.githubusercontent.com/704406/43988708-64c0fa52-9d4c-11e8-8cf9-c4d4b97a5200.png)

Some terminal emulators allow you to customize the colors used by the terminal.
P9K provides two commands that you can use to print out the colors &
color-codes in use by your emulator to aid you in customization.

```zsh
p9k::get_color foreground
p9k::get_color background
```

Some terminals also allow for 24bit colors/truecolor. You can use this by setting the color
value in hex for example like this: `P9K_VCS_MODIFIED_BACKGROUND='#fff8e7'`. This only works
in zsh version >=5.7 and we highly recommend adding this to your `.zshrc` if you use truecolor:
```zsh
[[ $COLORTERM = *(24bit|truecolor)* ]] || zmodload zsh/nearcolor
```

## Changing the Prompt

```zsh
P9K_{LEFT,RIGHT}_SEGMENT_SEPARATOR_ICON
P9K_{LEFT,RIGHT}_SUBSEGMENT_SEPARATOR_ICON
P9K_WHITESPACE_BETWEEN_{LEFT,RIGHT}_SEGMENTS
```

## Icons of Segments

Most segment have a icon which is an font glyph or string that serves as a "logo" for the segment. This identifier is displayed on the left side for left configured segments and on the right for right configured segments.

There are two kinds of segments: stateless and stateful. Let's assume you have configured the `load` segment. This segment can have different states (`CRITICAL`, `WARNING` and `NORMAL`). Now, we want to display the segment in black and white and colorize only the icon but change it to the string "CRIT" in the state "critical".

```zsh
# Segment in black and white
P9K_LOAD_CRITICAL_FOREGROUND="white"
P9K_LOAD_WARNING_FOREGROUND="white"
P9K_LOAD_NORMAL_FOREGROUND="white"
typeset -g P9K_LOAD_{NORMAL,WARNING,CRITICAL}_BACKGROUND="black"
# Colorize only the visual identifier
P9K_LOAD_CRITICAL_ICON="CRIT"
P9K_LOAD_CRITICAL_ICON_COLOR="red"
P9K_LOAD_WARNING_ICON_COLOR="yellow"
P9K_LOAD_NORMAL_ICON_COLOR="green"
```

If the segment is stateless like e.g. `time` or `date` you can simply set the icon (color) like this:
```zsh
P9K_TIME_ICON="It's"
```

## Icon Customization

Each icon in your prompt can be customized by specifying an appropriately named variable. 

Simply prefix the (stateful) name of the segment with `P9K_` and suffix it with `_ICON` to set the icon/glyph, i.e. `P9K_<segement>_ICON="icon"`, e.g. `P9K_TIME_ICON="time"` or `P9K_VCS_COMMIT_ICON=`.

You can use this same approach to add or remove spacing in your prompt. For example, if you would like to remove the space after the "branch" icon in the `vcs` segment, you can simply add a space after the codepoint for that icon:

```
P9K_VCS_BRANCH_ICON=$'\uF126 '
```

If you are using `git` and would like to customize the icon, please note that the icon is selected as follows:

| Version    | Icon to override         |
|------------|--------------------------|
| Github     | `VCS_GIT_GITHUB_ICON`    |
| BitBucket  | `VCS_GIT_BITBUCKET_ICON` |
| GitLab     | `VCS_GIT_GITLAB_ICON`    |
| All others | `VCS_GIT_ICON`           |

We provide a function that will print every icon name in the theme. To get a full list of icons just type `get_icon_names` in your terminal.

## Glue Segments Together

It is possible to display two segments as one, by adding `_joined` to your segment definition. The segments are always joined with their predecessor, so be sure that this is always visible. Otherwise you may get unwanted results. For example, if you want to join `status` and `background_jobs` in your right prompt together, set:
```zsh
P9K_RIGHT_PROMPT_ELEMENTS=(status background_jobs_joined)
```
This works with every segment, even with custom ones and with conditional ones.

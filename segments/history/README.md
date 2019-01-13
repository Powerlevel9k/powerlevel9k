# History

![](segment.png)

## Installation

To use this segment, you need to activate it by adding `history` to your
`P9K_LEFT_PROMPT_ELEMENTS` or `P9K_RIGHT_PROMPT_ELEMENTS` array, depending
where you want to show this segment.

## Description

This segment shows the history number of the command that was executed. You
can re-run this command by entering `!<history_id>`. So if you entered a couple
of commands, you can re-run the second command with `!2`.

## Configuration

### Color Customization

You can change the foreground and background color of this segment by setting
```
P9K_HISTORY_FOREGROUND='red'
P9K_HISTORY_BACKGROUND='blue'
```

### Customize Icon

The main Icon can be changed by setting `P9K_HISTORY_ICON="my_icon"`. To change the
icon color only, set `P9K_HISTORY_ICON_COLOR="red"`.
# Variable

## Installation

To use this segment, you need to activate it by adding `variable` to your
`P9K_LEFT_PROMPT_ELEMENTS` or `P9K_RIGHT_PROMPT_ELEMENTS` array, depending
where you want to show this segment.

## Configuration

| Variable | Default Value | Description |
|----------|---------------|-------------|
|`P9K_VARIABLE_NAME`|`LANG`|Change this to set the variable to read from|
|`P9K_VARIABLE_SHOW_NAME`|`false`|Set to true if you wish to show the name of the variable|

### Color Customization

You can change the foreground and background color of this segment by setting
```
P9K_VARIABLE_FOREGROUND='red'
P9K_VARIABLE_BACKGROUND='blue'
```

### Customize Icon

The main Icon can be changed by setting `P9K_VARIABLE_ICON="my_icon"`. To change the
icon color only, set `P9K_VARIABLE_ICON_COLOR="red"`.

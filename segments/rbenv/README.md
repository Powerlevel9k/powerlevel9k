# Rbenv

![](segment.png)

## Installation

To use this segment, you need to activate it by adding `rbenv` to your
`P9K_LEFT_PROMPT_ELEMENTS` or `P9K_RIGHT_PROMPT_ELEMENTS` array, depending
where you want to show this segment.

## Configuration

This segment shows the version of Ruby being used when using `rbenv` to change your current Ruby stack.

It figures out the version being used by taking the output of the `rbenv version-name` command.

* If `rbenv` is not in $PATH, nothing will be shown.
* By default, if the current local Ruby version is the same as the global Ruby version, nothing will be shown. See the configuration variable, below, to modify this behavior.

| Variable | Default Value | Description |
|----------|---------------|-------------|
|`P9K_RBENV_PROMPT_ALWAYS_SHOW`|`false`|Set to true if you wish to show the rbenv segment even if the current Ruby version is the same as the global Ruby version|

### Color Customization

You can change the foreground and background color of this segment by setting
```
P9K_RBENV_FOREGROUND='red'
P9K_RBENV_BACKGROUND='blue'
```

### Customize Icon

The main Icon can be changed by setting `P9K_RBENV_ICON="my_icon"`. To change the
icon color only, set `P9K_RBENV_ICON_COLOR="red"`.
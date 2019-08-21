# Pyver

![](segment.png)

## Installation

To use this segment, you need to activate it by adding `pyver` to your
`P9K_LEFT_PROMPT_ELEMENTS` or `P9K_RIGHT_PROMPT_ELEMENTS` array, depending
where you want to show this segment.

## Configuration

Similar to the `pyenv` segment, this segment shows the version of Python being currently used when calling `python`, without the use of any external python module

* If the current Python version is the same as the global Python version, nothing will be shown.

| Variable | Default Value | Description |
|----------|---------------|-------------|
|`P9K_PYVER_PROMPT_ALWAYS_SHOW`|`false`|Set to true if you wish to show the pyenv segment even if the current Python version is the same as the global Python version|

### Color Customization

You can change the foreground and background color of this segment by setting
```
P9K_PYVER_FOREGROUND='red'
P9K_PYVER_BACKGROUND='blue'
```

### Customize Icon

The main Icon can be changed by setting `P9K_PYVER_ICON="my_icon"`. To change the
icon color only, set `P9K_PYVER_ICON_COLOR="red"`.

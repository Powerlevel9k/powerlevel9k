# Dir writable

## Installation

To use this segment, you need to activate it by adding `dir_writable` to your
`P9K_LEFT_PROMPT_ELEMENTS` or `P9K_RIGHT_PROMPT_ELEMENTS` array, depending
where you want to show this segment.

## Configuration

### Color Customization

You can change the foreground and background color of this segment by setting
```
P9K_DIR_WRITABLE_FORBIDDEN_FOREGROUND='red'
P9K_DIR_WRITABLE_FORBIDDEN_BACKGROUND='blue'
```

### Customize Icon

The main Icon of this segment depends on its state.
It can be changed by setting:
```
P9K_DIR_WRITABLE_FORBIDDEN_ICON="my_icon"
```

The Icon color accordingly:
```
P9K_DIR_WRITABLE_FORBIDDEN_ICON_COLOR="red"
```
# Vagrant

![](segment.png)

## Installation

To use this segment, you need to activate it by adding `vagrant` to your
`P9K_LEFT_PROMPT_ELEMENTS` or `P9K_RIGHT_PROMPT_ELEMENTS` array, depending
where you want to show this segment.

## States

This segment can have different states. You can customize the different states
as you wish. Here is a quick overview:

![](states.png)

## Configuration

This segment detects if you are in a folder with a running/stopped VM. If so,
it displays `UP`, when VM is running or `DOWN` when VM is stopped.

You can customize these strings with:

| Variable                  | Default Value | Description   |
|---------------------------|---------------|---------------|
| `P9K_VAGRANT_UP_STRING`   | `UP`          | VM is running |
| `P9K_VAGRANT_DOWN_STRING` | `DOWN`        | VM is stopped |

### Color Customization

You can change the foreground and background color of this segment by setting
```
# VM is running
P9K_VAGRANT_DOWN_FOREGROUND='green'
P9K_VAGRANT_DOWN_BACKGROUND='magenta'

# VM is turned off
P9K_VAGRANT_DOWN_FOREGROUND='red'
P9K_VAGRANT_DOWN_BACKGROUND='blue'
```

### Customize Icon

The main Icon of this segment depends on its state.
It can be changed by setting:
```
P9K_VAGRANT_UP_ICON="my_icon"
P9K_VAGRANT_DOWN_ICON="my_icon"
```

The Icon color accordingly:
```
P9K_VAGRANT_UP_ICON_COLOR="red"
P9K_VAGRANT_DOWN_ICON_COLOR="red"
```
# Vagrant

## Installation

To use this segment, you need to activate it by adding `vagrant` to your
`P9K_LEFT_PROMPT_ELEMENTS` or `P9K_RIGHT_PROMPT_ELEMENTS` array, depending
where you want to show this segment.

## Configuration

This segment detects if you are in a folder with a running/stopped VM. If so,
it displays `UP`, when VM is running or `DOWN` when VM is stopped.

You can customize these strings with:

| Variable           | Default Value | Description   |
|--------------------|---------------|---------------|
| `P9K_VAGRANT_UP`   | `UP`          | VM is running |
| `P9K_VAGRANT_DOWN` | `DOWN`        | VM is stopped |

### Color Customization

You can change the foreground and background color of this segment by setting
```
P9K_VAGRANT_FOREGROUND='red'
P9K_VAGRANT_BACKGROUND='blue'
```
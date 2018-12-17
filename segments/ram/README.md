# RAM

## Installation

To use this segment, you need to activate it by adding `ram` to your
`P9K_LEFT_PROMPT_ELEMENTS` or `P9K_RIGHT_PROMPT_ELEMENTS` array, depending
where you want to show this segment.

## Configuration

| Variable | Default Value | Description |
|----------|---------------|-------------|
|`P9K_RAM_ELEMENTS`|Both|Specify `ram_free` or `swap_used` to only show one or the other rather than both.|

### Color Customization

You can change the foreground and background color of this segment by setting
```
P9K_RAM_FOREGROUND='red'
P9K_RAM_BACKGROUND='blue'
```
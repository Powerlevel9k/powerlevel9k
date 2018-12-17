# Date

## Installation

To use this segment, you need to activate it by adding `date` to your
`P9K_LEFT_PROMPT_ELEMENTS` or `P9K_RIGHT_PROMPT_ELEMENTS` array, depending
where you want to show this segment.

## Configuration

The `date` segment shows the current system date.

| Variable | Default Value | Description |
|----------|---------------|-------------|
|`P9K_DATE_FORMAT`|`%D{%d.%m.%y}`|[ZSH time format](http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Date-and-time) to use in this segment.|

### Color Customization

You can change the foreground and background color of this segment by setting
```
P9K_DATE_FOREGROUND='red'
P9K_DATE_BACKGROUND='blue'
```
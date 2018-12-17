# Time

## Installation

To use this segment, you need to activate it by adding `time` to your
`P9K_LEFT_PROMPT_ELEMENTS` or `P9K_RIGHT_PROMPT_ELEMENTS` array, depending
where you want to show this segment.

## Configuration

| Variable | Default Value | Description |
|----------|---------------|-------------|
|`P9K_TIME_FORMAT`|`'H:M:S'`|ZSH time format to use in this segment.|

As an example, if you wanted a reversed time format, you would use this:
```zsh
# Reversed time format
P9K_TIME_FORMAT='%D{%S:%M:%H}'
```
If you are using an "Awesome Powerline Font", you can add a time symbol to this
segment, as well:
```zsh
# Output time, date, and a symbol from the "Awesome Powerline Font" set
P9K_TIME_FORMAT="%D{%H:%M:%S \uE868  %d.%m.%y}"
```

### Color Customization

You can change the foreground and background color of this segment by setting
```
P9K_TIME_FOREGROUND='red'
P9K_TIME_BACKGROUND='blue'
```
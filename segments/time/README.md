# Time

![](segment.png)

## Installation

To use this segment, you need to activate it by adding `time` to your
`P9K_LEFT_PROMPT_ELEMENTS` or `P9K_RIGHT_PROMPT_ELEMENTS` array, depending
where you want to show this segment.

## Configuration

| Variable | Default Value | Description |
|----------|---------------|-------------|
|`P9K_TIME_FORMAT`|`'H:M:S'`|ZSH time format to use in this segment.|
|`P9K_TIME_REALTIME`|`false`|Enabling this option will update your prompt every `P9K_TIME_REALTIME_DELAY` seconds to display the current time. Note: This will trigger a `.reset-prompt` and can lead to side effects like history getting "stuck" or suggestions disappearing. |
|`P9K_TIME_REALTIME_DELAY`|`60`|This only takes effect if `P9K_TIME_REALTIME` is `true` and is used to set the delay between updates.|
|`P9K_TIME_RESET_ON_EXEC`|`false`|This will resulting in the time segment displaying the time the command was executed. Note: This is done by rebinding the `enter` key to redraw your prompt.|

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

### Customize Icon

The main Icon can be changed by setting `P9K_TIME_ICON="my_icon"`. To change the
icon color only, set `P9K_TIME_ICON_COLOR="red"`.

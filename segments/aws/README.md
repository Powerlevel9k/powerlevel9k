# AWS

## Installation

To use this segment, you need to activate it by adding `aws` to your
`P9K_LEFT_PROMPT_ELEMENTS` or `P9K_RIGHT_PROMPT_ELEMENTS` array, depending
where you want to show this segment.

## Configuration

If you would like to display the [current AWS
profile](http://docs.aws.amazon.com/cli/latest/userguide/installing.html), add
the `aws` segment to one of the prompts, and define `AWS_DEFAULT_PROFILE` in
your `~/.zshrc`:

| Variable | Default Value | Description |
|----------|---------------|-------------|
|`AWS_DEFAULT_PROFILE`|None|Your AWS profile name|

### Color Customization

You can change the foreground and background color of this segment by setting
```
P9K_AWS_FOREGROUND='red'
P9K_AWS_BACKGROUND='blue'
```

### Customize Icon

The main Icon can be changed by setting `P9K_AWS_ICON="my_icon"`. To change the
icon color only, set `P9K_AWS_ICON_COLOR="red"`.
# AWS

![](segment.png)

## Installation

To use this segment, you need to activate it by adding `aws` to your
`P9K_LEFT_PROMPT_ELEMENTS` or `P9K_RIGHT_PROMPT_ELEMENTS` array, depending
where you want to show this segment.

## Configuration

If you would like to display the [current AWS
profile and region](http://docs.aws.amazon.com/cli/latest/userguide/installing.html), add
the `aws` segment to one of the prompts, and define `P9K_AWS_DEFAULT_PROFILE` 
(and optionally `AWS_DEFAULT_REGION`) in your `~/.zshrc`:

| Variable | Default Value | Description |
|----------|---------------|-------------|
|`P9K_AWS_DEFAULT_PROFILE`|None|Your AWS profile name|
|`AWS_DEFAULT_REGION`|None|Your AWS region|
|`P9K_AWS_INCLUDE_PROFILE`|None|Show the current profile even if unset (`default`).|
|`P9K_AWS_INCLUDE_REGION`|None|Show the current region, either from environment variable or awscli.|
|`P9K_AWS_DELIMITER`|`\|`|Delimiter to use between the AWS profile and region. This can be any string you choose, including an empty string if you wish to have no delimiter.|

### Color Customization

You can change the foreground and background color of this segment by setting
```
P9K_AWS_FOREGROUND='red'
P9K_AWS_BACKGROUND='blue'
```

### Customize Icon

The main Icon can be changed by setting `P9K_AWS_ICON="my_icon"`. To change the
icon color only, set `P9K_AWS_ICON_COLOR="red"`.
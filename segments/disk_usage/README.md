# Disk Usage

![](segment.png)

## Installation

To use this segment, you need to activate it by adding `disk_usage` to your
`P9K_LEFT_PROMPT_ELEMENTS` or `P9K_RIGHT_PROMPT_ELEMENTS` array, depending
where you want to show this segment.

## States

This segment can have different states. You can customize the different states
as you wish. Here is a quick overview:

![](states.png)

## Configuration

The `disk_usage` segment will show the usage level of the partition that your current working directory (or a directory of your choice) resides in. It can be configured with the following variables.

| Variable | Default Value | Description |
|----------|---------------|-------------|
|`P9K_DISK_USAGE_ONLY_WARNING`|false|Hide the segment except when usage levels have hit warning or critical levels.|
|`P9K_DISK_USAGE_WARNING_LEVEL`|90|The usage level that triggers a warning state.|
|`P9K_DISK_USAGE_CRITICAL_LEVEL`|95|The usage level that triggers a critical state.|
|`P9K_DISK_USAGE_PATH`|`.` (working directory)|Set a path to use a fixed directory instead of the working

### Color Customization

You can change the foreground and background color of this segment by setting
```
# Normal Disk Usage
P9K_DISK_USAGE_NORMAL_FOREGROUND='red'
P9K_DISK_USAGE_NORMAL_BACKGROUND='blue'

# Disk Usage: Almost Full
P9K_DISK_USAGE_WARNING_FOREGROUND='red'
P9K_DISK_USAGE_WARNING_BACKGROUND='blue'

# Disk Usage: Critically Full
P9K_DISK_USAGE_CRITICAL_FOREGROUND='red'
P9K_DISK_USAGE_CRITICAL_BACKGROUND='blue'
```

### Customize Icon

The main Icon of this segment depends on its state.
It can be changed by setting:
```
P9K_DISK_USAGE_NORMAL_ICON="my_icon"
P9K_DISK_USAGE_WARNING_ICON="my_icon"
P9K_DISK_USAGE_CRITICAL_ICON="my_icon"
```

The Icon color accordingly:
```
P9K_DISK_USAGE_NORMAL_ICON_COLOR="red"
P9K_DISK_USAGE_WARNING_ICON_COLOR="red"
P9K_DISK_USAGE_CRITICAL_ICON_COLOR="red"
```
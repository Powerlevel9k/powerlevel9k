# Load

## Installation

To use this segment, you need to activate it by adding `load` to your
`P9K_LEFT_PROMPT_ELEMENTS` or `P9K_RIGHT_PROMPT_ELEMENTS` array, depending
where you want to show this segment.

## Configuration

Displays one of your load averages with appropriate state coloring. The thresholds are:
- `0.7 * NUM_CORES <`: critical
- `0.5 * NUM_CORES <`: warning
- `less`: normal

| Variable | Default Value | Description |
|----------|---------------|-------------|
|`P9K_LOAD_WHICH`|5|Which average to show. Possible values: 1, 5 or 15|

### Color Customization

You can change the foreground and background color of this segment by setting
```
# Normal Load
P9K_LOAD_NORMAL_FOREGROUND='red'
P9K_LOAD_NORMAL_BACKGROUND='blue'

# High Load
P9K_LOAD_WARNING_FOREGROUND='red'
P9K_LOAD_WARNING_BACKGROUND='blue'

# Critical Load
P9K_LOAD_CRITICAL_FOREGROUND='red'
P9K_LOAD_CRITICAL_BACKGROUND='blue'
```

### Customize Icon

The main Icon of this segment depends on its state.
It can be changed by setting:
```
P9K_LOAD_NORMAL_ICON="my_icon"
P9K_LOAD_WARNING_ICON="my_icon"
P9K_LOAD_CRITICAL_ICON="my_icon"
```

The Icon color accordingly:
```
P9K_LOAD_NORMAL_ICON_COLOR="red"
P9K_LOAD_WARNING_ICON_COLOR="red"
P9K_LOAD_CRITICAL_ICON_COLOR="red"
```
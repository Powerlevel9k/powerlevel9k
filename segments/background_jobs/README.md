# Background Jobs

![](segment.png)

## Installation

To use this segment, you need to activate it by adding `background_jobs` to your
`P9K_LEFT_PROMPT_ELEMENTS` or `P9K_RIGHT_PROMPT_ELEMENTS` array, depending
where you want to show this segment.

## Configuration

| Variable | Default Value | Description |
|----------|---------------|-------------|
|`P9K_BACKGROUND_JOBS_VERBOSE`|`true`|If there is more than one background job, this segment will show the number of jobs. Set this to `false` to turn this feature off.|
`P9K_BACKGROUND_JOBS_VERBOSE_ALWAYS`|`false`|Always show the jobs count (even if it's zero).|

### Color Customization

You can change the foreground and background color of this segment by setting
```
P9K_BACKGROUND_JOBS_FOREGROUND='red'
P9K_BACKGROUND_JOBS_BACKGROUND='blue'
```

### Customize Icon

The main Icon can be changed by setting `P9K_BACKGROUND_JOBS_ICON="my_icon"`. To change the
icon color only, set `P9K_BACKGROUND_JOBS_ICON_COLOR="red"`.
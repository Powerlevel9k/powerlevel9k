# Battery

## Installation

To use this segment, you need to activate it by adding `battery` to your
`P9K_LEFT_PROMPT_ELEMENTS` or `P9K_RIGHT_PROMPT_ELEMENTS` array, depending
where you want to show this segment.

## Configuration

The default settings for this segment will display your current battery status (fails gracefully on
systems without a battery). It is supported on both OSX and Linux (note that it requires `acpi` on Linux).

| Variable | Default Value | Description |
|----------|---------------|-------------|
|`P9K_BATTERY_CHARGING`|`"yellow"`|Color to indicate a charging battery.|
|`P9K_BATTERY_CHARGED`|`"green"`|Color to indicate a charged battery.|
|`P9K_BATTERY_DISCONNECTED`|`$DEFAULT_COLOR`|Color to indicate absence of battery.|
|`P9K_BATTERY_LOW_THRESHOLD`|`10`|Threshold to consider battery level critical.|
|`P9K_BATTERY_LOW_COLOR`|`"red"`|Color to indicate critically low charge level.|
|`P9K_BATTERY_VERBOSE`|`true`|Display time remaining next to battery level.|

Note that you can [modify the `_FOREGROUND`
color](https://github.com/bhilburn/powerlevel9k/wiki/Stylizing-Your-Prompt#segment-color-customization)
without affecting the icon color.

You can also change the battery icon automatically depending on the battery
level. This will override the default battery icon. In order to do this, you
need to define the `P9k_BATTERY_STAGES` variable.


| Variable                      | Default Value | Description                                                   |
|-------------------------------|---------------|---------------------------------------------------------------|
| `P9K_BATTERY_STAGES` | Unset         | A string or array, which each index indicates a charge level. |

Powerlevel9k will use each index of the string or array as a stage to indicate battery
charge level, progressing from left to right. You can provide any number of
stages. The setting below, for example, provides 8 stages for Powerlevel9k to use.
```zsh
P9K_BATTERY_STAGES="▁▂▃▄▅▆▇█"
```

If you require extra spacing after the icon, you will have to set it as an array,
since spaces in the string will be used as one of the stages and you will get a
missing icon. To do this, declare the variable as follows:
```zsh
P9K_BATTERY_STAGES=($'\u2581 ' $'\u2582 ' $'\u2583 ' $'\u2584 ' $'\u2585 ' $'\u2586 ' $'\u2587 ' $'\u2588 ')
```

Using the array syntax, you can create stages comprised of multiple characters.
The below setting provides 40 battery stages.
```zsh
P9K_BATTERY_STAGES=(
   $'▏    ▏' $'▎    ▏' $'▍    ▏' $'▌    ▏' $'▋    ▏' $'▊    ▏' $'▉    ▏' $'█    ▏'
   $'█▏   ▏' $'█▎   ▏' $'█▍   ▏' $'█▌   ▏' $'█▋   ▏' $'█▊   ▏' $'█▉   ▏' $'██   ▏'
   $'██   ▏' $'██▎  ▏' $'██▍  ▏' $'██▌  ▏' $'██▋  ▏' $'██▊  ▏' $'██▉  ▏' $'███  ▏'
   $'███  ▏' $'███▎ ▏' $'███▍ ▏' $'███▌ ▏' $'███▋ ▏' $'███▊ ▏' $'███▉ ▏' $'████ ▏'
   $'████ ▏' $'████▎▏' $'████▍▏' $'████▌▏' $'████▋▏' $'████▊▏' $'████▉▏' $'█████▏' )
```

You can also change the background of the segment automatically depending on the
battery level. This will override the following variables:
`P9K_BATTERY_CHARGING`, `P9K_BATTERY_CHARGED`,
`P9K_BATTERY_DISCONNECTED`, and `P9K_BATTERY_LOW_COLOR`. In
order to do this, define a color array, from low to high, as shown below:
```zsh
P9K_BATTERY_LEVEL_BACKGROUND=(red1 orangered1 darkorange orange1 gold1 yellow1 yellow2 greenyellow chartreuse1 chartreuse2 green1)
```

As with the battery stages, you can use any number of colors and Powerlevel9k
will automatically use all of them appropriately.

Some example settings:

| Brightness     | Possible Array                                                                                                |
|----------------|---------------------------------------------------------------------------------------------------------------|
| Bright Colors  | `(red1 orangered1 darkorange orange1 gold1 yellow1 yellow2 greenyellow chartreuse1 chartreuse2 green1)`       |
| Normal Colors  | `(red3 darkorange3 darkgoldenrod gold3 yellow3 chartreuse2 mediumspringgreen green3 green3 green4 darkgreen)` |
| Subdued Colors | `(darkred orange4 yellow4 yellow4 chartreuse3 green3 green4 darkgreen)`                                       |

### Color Customization

You can change the foreground and background color of this segment by setting
```
# Battery Low
P9K_BATTERY_LOW_FOREGROUND='red'
P9K_BATTERY_LOW_BACKGROUND='blue'

# Battery Charging
P9K_BATTERY_CHARGING_FOREGROUND='red'
P9K_BATTERY_CHARGING_BACKGROUND='blue'

# Battery Charged
P9K_BATTERY_CHARGED_FOREGROUND='red'
P9K_BATTERY_CHARGED_BACKGROUND='blue'

# Battery Disconnected
P9K_BATTERY_DISCONNECTED_FOREGROUND='red'
P9K_BATTERY_DISCONNECTED_BACKGROUND='blue'
```

### Customize Icon

The main Icon of this segment depends on its state.
It can be changed by setting:
```
P9K_BATTERY_LOW_ICON="my_icon"
P9K_BATTERY_CHARGING_ICON="my_icon"
P9K_BATTERY_CHARGED_ICON="my_icon"
P9K_BATTERY_DISCONNECTED_ICON="my_icon"
```

The Icon color accordingly:
```
P9K_BATTERY_LOW_ICON_COLOR="red"
P9K_BATTERY_CHARGING_ICON_COLOR="red"
P9K_BATTERY_CHARGED_ICON_COLOR="red"
P9K_BATTERY_DISCONNECTED_ICON_COLOR="red"
```
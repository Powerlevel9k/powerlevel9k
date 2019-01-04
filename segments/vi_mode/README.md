# Vi Mode

![](segment.png)

## Installation

To use this segment, you need to activate it by adding `vi_mode` to your
`P9K_LEFT_PROMPT_ELEMENTS` or `P9K_RIGHT_PROMPT_ELEMENTS` array, depending
where you want to show this segment.

## States

This segment can have different states. You can customize the different states
as you wish. Here is a quick overview:

![](states.png)

## Configuration

This segment shows ZSH's current input mode. Note that this is only useful if
you are using the [ZSH Line Editor](http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html)
(VI mode).  You can enable this either by `.zshrc` configuration or using a plugin, like
[Oh-My-Zsh's vi-mode plugin](https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/vi-mode/vi-mode.plugin.zsh).

| Variable | Default Value | Description |
|----------|---------------|-------------|
|`P9K_VI_MODE_INSERT_STRING`|`"INSERT"`|String to display while in 'Insert' mode.|
|`P9K_VI_MODE_COMMAND_STRING`|`"NORMAL"`|String to display while in 'Command' mode.|
|`P9K_VI_MODE_SEARCH_STRING`|`"SEARCH"`|String to display while in 'Search' mode (requires the [vim-mode](https://github.com/softmoth/zsh-vim-mode) plugin).|
|`P9K_VI_MODE_VISUAL_STRING`|`"VISUAL"`|String to display while in 'Visual' mode.|

To hide the segment entirely when in `INSERT` mode, set `P9K_VI_MODE_INSERT_STRING=''`

### Color Customization

You can change the foreground and background color of this segment by setting
```
# VI Mode Normal
P9K_VI_MODE_NORMAL_FOREGROUND='red'
P9K_VI_MODE_NORMAL_BACKGROUND='blue'

# VI Mode Insert
P9K_VI_MODE_INSERT_FOREGROUND='red'
P9K_VI_MODE_INSERT_BACKGROUND='blue'
```

### Customize Icon

The main Icon of this segment depends on its state.
It can be changed by setting:
```
P9K_VI_MODE_NORMAL_ICON="my_icon"
P9K_VI_MODE_INSERT_ICON="my_icon"
```

The Icon color accordingly:
```
P9K_VI_MODE_NORMAL_ICON_COLOR="red"
P9K_VI_MODE_INSERT_ICON_COLOR="red"
```
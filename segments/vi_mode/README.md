# Vi Mode

## Installation

To use this segment, you need to activate it by adding `vi_mode` to your
`P9K_LEFT_PROMPT_ELEMENTS` or `P9K_RIGHT_PROMPT_ELEMENTS` array, depending
where you want to show this segment.

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

To hide the segment entirely when in `INSERT` mode, set `P9K_VI_MODE_INSERT_STRING=''`

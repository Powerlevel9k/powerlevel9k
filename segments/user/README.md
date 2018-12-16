# User

## Installation

To use this segment, you need to activate it by adding `user` to your
`P9K_LEFT_PROMPT_ELEMENTS` or `P9K_RIGHT_PROMPT_ELEMENTS` array, depending
where you want to show this segment.

## Configuration

The `user` segment will print the username.

You can also override the icons by setting:

```
P9K_USER_DEFAULT_ICON="\uF415" # 
P9K_USER_ROOT_ICON="#"
P9K_USER_SUDO_ICON=$'\uF09C' # 
```

| Variable | Default Value | Description |
|----------|---------------|-------------|
|`DEFAULT_USER`|None|Username to consider a "default context".|
|`P9K_CONTEXT_ALWAYS_SHOW_USER`|`false`|Always print this segment.|
|`P9K_USER_TEMPLATE`|`%n`|Default username prompt. Refer to the [ZSH Documentation](http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html) for all possible expansions|

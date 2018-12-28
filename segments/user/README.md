# User

![](segment.png)

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
|`P9K_USER_ALWAYS_SHOW`|`false`|Always print this segment.|
|`P9K_USER_ALWAYS_SHOW_USER`|`false`|Always print the username.|
|`P9K_USER_TEMPLATE`|`%n`|Default username prompt. Refer to the [ZSH Documentation](http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html) for all possible expansions|

### Color Customization

You can change the foreground and background color of this segment by setting
```
# Default User
P9K_USER_DEFAULT_FOREGROUND='red'
P9K_USER_DEFAULT_BACKGROUND='blue'

# Root User
P9K_USER_ROOT_FOREGROUND='red'
P9K_USER_ROOT_BACKGROUND='blue'

# Sudo User
P9K_USER_SUDO_FOREGROUND='red'
P9K_USER_SUDO_BACKGROUND='blue'

# Remote User
P9K_USER_REMOTE_FOREGROUND='red'
P9K_USER_REMOTE_BACKGROUND='blue'

# Remote Sudo User
P9K_USER_REMOTE_SUDO_FOREGROUND='red'
P9K_USER_REMOTE_SUDO_BACKGROUND='blue'
```

### Customize Icon

The main Icon of this segment depends on its state.
It can be changed by setting:
```
P9K_USER_DEFAULT_ICON="my_icon"
P9K_USER_ROOT_ICON="my_icon"
P9K_USER_SUDO_ICON="my_icon"
P9K_USER_REMOTE_ICON="my_icon"
P9K_USER_REMOTE_SUDO_ICON="my_icon"
```

The Icon color accordingly:
```
P9K_USER_DEFAULT_ICON_COLOR="red"
P9K_USER_ROOT_ICON_COLOR="red"
P9K_USER_SUDO_ICON_COLOR="red"
P9K_USER_REMOTE_ICON_COLOR="red"
P9K_USER_REMOTE_SUDO_ICON_COLOR="red"
```
# Host

## Installation

To use this segment, you need to activate it by adding it to your
`P9K_LEFT_PROMPT_ELEMENTS` or `P9K_RIGHT_PROMPT_ELEMENTS` array, depending
where you want to show this segment.

## Configuration

The `host` segment will print the hostname.

You can set the `P9K_HOST_TEMPLATE` variable to change how the hostname
is displayed. See (ZSH Manual)[http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Login-information]
for details. The default is set to `%m` which will show the hostname up to the
first `.`. You can set it to `%{N}m` where N is an integer to show that many
segments of system hostname. Setting `N` to a negative integer will show that many
segments from the end of the hostname.

```
P9K_HOST_TEMPLATE="%2m"
```

By default, LOCAL hosts will show the host icon and remote hosts will show the SSH icon. You can override them by setting
```
P9K_HOST_ICON="\uF109 "
P9K_SSH_ICON="\uF489 "
```

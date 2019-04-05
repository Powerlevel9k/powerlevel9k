# Go Version

![](segment.png)

## Installation

To use this segment, you need to activate it by adding `go_version` to your
`P9K_LEFT_PROMPT_ELEMENTS` or `P9K_RIGHT_PROMPT_ELEMENTS` array, depending
where you want to show this segment.

## Configuration

This segment shows the version of Go installed.

It figures out the version being used by taking the output of the `go version` command.

* If `go` is not in $PATH, nothing will be shown.
* By default, if the current Go version is only shown while inside your GOPATH. See the configuration variable, below, to modify this behavior.

| Variable | Default Value | Description |
|----------|---------------|-------------|
|`P9K_GO_VERSION_PROMPT_ALWAYS_SHOW` |`false`|Set to true if you wish to show the go_version segment even if you're not inside your GOPATH.                                  |


### Color Customization

You can change the foreground and background color of this segment by setting
```
P9K_GO_VERSION_FOREGROUND='red'
P9K_GO_VERSION_BACKGROUND='blue'
```

### Customize Icon

The main Icon can be changed by setting `P9K_GO_VERSION_ICON="my_icon"`. To change the
icon color only, set `P9K_GO_VERSION_ICON_COLOR="red"`.

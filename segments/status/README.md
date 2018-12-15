# Status

## Installation

To use this segment, you need to activate it by adding it to your
`P9K_LEFT_PROMPT_ELEMENTS` or `P9K_RIGHT_PROMPT_ELEMENTS` array, depending
where you want to show this segment.

## Configuration

This segment shows the return code of the last command.

| Variable | Default Value | Description |
|----------|---------------|-------------|
|`P9K_STATUS_CROSS`|`false`|Set to true if you wish not to show the error code when the last command returned an error and optionally hide this segment when the last command completed successfully by setting `P9K_STATUS_OK` to false.|
|`P9K_STATUS_OK`|`true`|Set to true if you wish to show this segment when the last command completed successfully, false to hide it.|
|`P9K_STATUS_SHOW_PIPESTATUS`|`true`|Set to true if you wish to show the exit status for all piped commands.|
|`P9K_STATUS_HIDE_SIGNAME`|`false`|Set to true return the raw exit code (`1-255`).  When set to false, values over 128 are shown as `SIGNAME(-n)` (e.g. `KILL(-9)`)|

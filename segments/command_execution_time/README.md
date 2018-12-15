# Command Execution Time

## Installation

To use this segment, you need to activate it by adding `command_execution_time` to your
`P9K_LEFT_PROMPT_ELEMENTS` or `P9K_RIGHT_PROMPT_ELEMENTS` array, depending
where you want to show this segment.

## Configuration

Display the time the previous command took to execute if the time is above
`P9K_COMMAND_EXECUTION_TIME_THRESHOLD`. The time is formatted to be
"human readable", and so scales the units based on the length of execution time.
If you want more precision, just set the
`P9K_COMMAND_EXECUTION_TIME_PRECISION` field.

| Variable | Default Value | Description |
|----------|---------------|-------------|
|`P9K_COMMAND_EXECUTION_TIME_THRESHOLD`|3|Threshold above which to print this segment. Can be set to `0` to always print.|
|`P9K_COMMAND_EXECUTION_TIME_PRECISION`|2|Number of digits to use in the fractional part of the time value.|

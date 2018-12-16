# Disk Usage

## Installation

To use this segment, you need to activate it by adding `disk_usage` to your
`P9K_LEFT_PROMPT_ELEMENTS` or `P9K_RIGHT_PROMPT_ELEMENTS` array, depending
where you want to show this segment.

## Configuration

The `disk_usage` segment will show the usage level of the partition that your current working directory (or a directory of your choice) resides in. It can be configured with the following variables.

| Variable | Default Value | Description |
|----------|---------------|-------------|
|P9K_DISK_USAGE_ONLY_WARNING|false|Hide the segment except when usage levels have hit warning or critical levels.|
|P9K_DISK_USAGE_WARNING_LEVEL|90|The usage level that triggers a warning state.|
|P9K_DISK_USAGE_CRITICAL_LEVEL|95|The usage level that triggers a critical state.|
|P9K_DISK_USAGE_PATH|`.` (working directory)|Set a path to use a fixed directory instead of the working

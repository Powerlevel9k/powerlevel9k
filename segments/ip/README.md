# IP

## Installation

To use this segment, you need to activate it by adding `ip` to your
`P9K_LEFT_PROMPT_ELEMENTS` or `P9K_RIGHT_PROMPT_ELEMENTS` array, depending
where you want to show this segment.

## Configuration

This segment tries to examine all currently used network interfaces and prints
the first address it finds.  In the case that this is not the right NIC, you can
specify the correct network interface by setting:

| Variable | Default Value | Description |
|----------|---------------|-------------|
|`P9K_IP_INTERFACE`|None|The NIC for which you wish to display the IP address. Example: `eth0`.|

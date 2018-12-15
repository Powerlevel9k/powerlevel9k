# VPN IP

## Installation

To use this segment, you need to activate it by adding it to your
`P9K_LEFT_PROMPT_ELEMENTS` or `P9K_RIGHT_PROMPT_ELEMENTS` array, depending
where you want to show this segment.

## Configuration

This segment tries to extract the VPN related IP addresses from nmcli, based on the NIC type:

| Variable | Default Value | Description |
|----------|---------------|-------------|
|`P9K_VPN_IP_INTERFACE`|`tun`|The VPN interface.|

# VPN IP

## Installation

To use this segment, you need to activate it by adding `vpn_ip` to your
`P9K_LEFT_PROMPT_ELEMENTS` or `P9K_RIGHT_PROMPT_ELEMENTS` array, depending
where you want to show this segment.

## Configuration

This segment tries to extract the VPN related IP addresses from nmcli, based on the NIC type:

| Variable | Default Value | Description |
|----------|---------------|-------------|
|`P9K_VPN_IP_INTERFACE`|`tun`|The VPN interface.|

### Color Customization

You can change the foreground and background color of this segment by setting
```
P9K_VPN_IP_FOREGROUND='red'
P9K_VPN_IP_BACKGROUND='blue'
```

### Customize Icon

The main Icon can be changed by setting `P9K_VPN_IP_ICON="my_icon"`. To change the
icon color only, set `P9K_VPN_IP_ICON_COLOR="red"`.
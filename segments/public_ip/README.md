# Public IP

![](segment.png)

## Installation

To use this segment, you need to activate it by adding `public_ip` to your
`P9K_LEFT_PROMPT_ELEMENTS` or `P9K_RIGHT_PROMPT_ELEMENTS` array, depending
where you want to show this segment.

## Configuration

This segment will display your public IP address. There are several methods of obtaining this
information and by default it will try all of them starting with the most efficient. You can
also specify which method you would like it to use. The methods available are dig using opendns,
curl, or wget. The host used for wget and curl is http://ident.me by default but can be set to
another host if you prefer.

If you activate a VPN, the icon for this segment will change to the defined VPN icon.

The public_ip segment will attempt to update your public IP address every 5 minutes by default(also
configurable by the user). If you lose connection your cached IP address will be displayed until
your timeout expires at which point every time your prompt is generated a new attempt will be made.
Until an IP is successfully pulled the value of $P9K_PUBLIC_IP_NONE will be displayed for
this segment. If this value is empty(the default)and $P9K_PUBLIC_IP_FILE is empty the
segment will not be displayed.

| Variable | Default Value | Description |
|----------|---------------|-------------|
|`P9K_PUBLIC_IP_FILE`|'/tmp/p9k_public_ip'|This is the file your public IP is cached in.|
|`P9K_PUBLIC_IP_HOST`|'http://ident.me'|This is the default host to get your public IP.|
|`P9K_PUBLIC_IP_TIMEOUT`|300|The amount of time in seconds between refreshing your cached IP.|
|`P9K_PUBLIC_IP_METHODS`|(dig curl wget)| These methods in that order are used to refresh your IP.|
|`P9K_PUBLIC_IP_NONE`|None|The string displayed when an IP was not obtained|

### Color Customization

You can change the foreground and background color of this segment by setting
```
P9K_PUBLIC_IP_FOREGROUND='red'
P9K_PUBLIC_IP_BACKGROUND='blue'
```

### Customize Icon

The main Icon can be changed by setting `P9K_PUBLIC_IP_ICON="my_icon"`. To change the
icon color only, set `P9K_PUBLIC_IP_ICON_COLOR="red"`.
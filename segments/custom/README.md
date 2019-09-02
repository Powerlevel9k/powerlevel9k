# Custom_*

## Installation

This is not an ordinary segment that can just be installed. This is the
documentation for the mechanism that is used to create your own custom segments
that can display the output of arbitrary commands. In this documentation we
will create a custom segment – `custom_wifi_signal` – to display the current
signal strength. You can replace this code with your own if you want to
achieve something different. You have to preserve the prefixes though.
This means `P9K_CUSTOM_*` for variables and `custom_*` when putting the
custom segment into your `P9K_LEFT_PROMPT_ELEMENTS` or
`P9K_RIGHT_PROMPT_ELEMENTS`.

## Configuration

### Command as Segment

```zsh
P9K_CUSTOM_WIFI_SIGNAL="echo signal: \$(nmcli device wifi | grep yes | awk '{print \$8}')"
P9K_CUSTOM_WIFI_SIGNAL_BACKGROUND="blue"
P9K_CUSTOM_WIFI_SIGNAL_FOREGROUND="yellow"
P9K_LEFT_PROMPT_ELEMENTS=(context time battery dir vcs virtualenv custom_wifi_signal)
```

### Function as Segment

If you prefer, you can also define the function in your `.zshrc` rather than
putting it in-line with the variable export, as shown above. Just don't forget
to invoke your function from your segment! Example code that achieves the same
result as the above, with the added benefit of different foreground colors
depending on the signal strength:

```zsh 
zsh_wifi_signal(){
    local signal=$(nmcli device wifi | grep yes | awk '{print $8}')
    local color='%F{yellow}'
    [[ $signal -gt 75 ]] && color='%F{green}'
    [[ $signal -lt 50 ]] && color='%F{red}'
    echo -n "%{$color%}\uf230  $signal%{%f%}" # \uf230 is 
}   
P9K_CUSTOM_WIFI_SIGNAL="zsh_wifi_signal"
P9K_LEFT_PROMPT_ELEMENTS=(context time battery dir vcs virtualenv custom_wifi_signal)
```

The command, above, gives you the wireless signal segment shown below:

![Signal_Strength](https://user-images.githubusercontent.com/1544760/64135201-3234bd00-cde6-11e9-8e05-cd2939486bf2.png)

You can define as many custom segments as you wish. If you think you have
a segment that others would find useful, please consider upstreaming it to the
main theme for distribution so that everyone can use it!

### Color Customization

You can change the foreground and background color of this segment by setting
```zsh
P9K_CUSTOM_WIFI_SIGNAL_FOREGROUND='red'
P9K_CUSTOM_WIFI_SIGNAL_BACKGROUND='blue'
```

### Customize Icon

The icon can be changed by setting:
```zsh
P9K_CUSTOM_WIFI_SIGNAL_ICON="my_icon"
```

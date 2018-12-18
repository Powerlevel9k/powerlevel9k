# Kubernetes Context

## Installation

To use this segment, you need to activate it by adding `kubecontext` to your
`P9K_LEFT_PROMPT_ELEMENTS` or `P9K_RIGHT_PROMPT_ELEMENTS` array, depending
where you want to show this segment.

## Configuration

### Color Customization

You can change the foreground and background color of this segment by setting
```
P9K_KUBECONTEXT_FOREGROUND='red'
P9K_KUBECONTEXT_BACKGROUND='blue'
```

### Customize Icon

The main Icon can be changed by setting `P9K_KUBECONTEXT_ICON="my_icon"`. To change the
icon color only, set `P9K_KUBECONTEXT_ICON_COLOR="red"`.
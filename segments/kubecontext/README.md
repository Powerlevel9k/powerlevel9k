# Kubernetes Context

![](segment.png)

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

### Strip Cluster and Namespace from AWS ARN (If using EKS)

You may extract the clutser name and namespace from the AWS ARN that is supplied when you use an EKS cluster. This is useful when you really just want to see the cluster name and do not want the full ARN.
```
P9K_KUBECONTEXT_STRIPEKS=true
```
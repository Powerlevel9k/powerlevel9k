# Terraform Workspace

Displays the currently selected workspace within your state file. Works by inspecting your .terraform/environment file.

![](segment.png)

## Installation

To use this segment, you need to activate it by adding `terraform` to your
`P9K_LEFT_PROMPT_ELEMENTS` or `P9K_RIGHT_PROMPT_ELEMENTS` array, depending
where you want to show this segment.

## Configuration

### Color Customization

You can change the foreground and background color of this segment by setting.
```
P9K_TERRAFORM_FOREGROUND='red'
P9K_TERRAFORM_BACKGROUND='blue'
```

### Customize Icon

The main Icon can be changed by setting `P9K_TERRAFORM_ICON="my_icon"`. To change the
icon color only, set `P9K_TERRAFORM_ICON_COLOR="red"`. Using a globe for now until a 
terraform specific icon is included in font packages.

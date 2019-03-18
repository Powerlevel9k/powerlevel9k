# Node Version

![](segment.png)

## Installation

To use this segment, you need to activate it by adding `node_version` to your
`P9K_LEFT_PROMPT_ELEMENTS` or `P9K_RIGHT_PROMPT_ELEMENTS` array, depending
where you want to show this segment.

## Configuration

### Segment Display

By default, this segment is always shown. You can also choose to have it 
displayed only when inside of a Node project by setting
```
P9K_NODE_VERSION_PROJECT_ONLY=true
```
The current directory and its ancestors will be searched for a `project.json` 
file, and the segment will only be displayed if one is located before `/`.

### Color Customization

You can change the foreground and background color of this segment by setting
```
P9K_NODE_VERSION_FOREGROUND='red'
P9K_NODE_VERSION_BACKGROUND='blue'
```

### Customize Icon

The main Icon can be changed by setting `P9K_NODE_VERSION_ICON="my_icon"`. To change the
icon color only, set `P9K_NODE_VERSION_ICON_COLOR="red"`.
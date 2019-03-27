# Gitstatus

![](segment.png)

This segment is very similar to the [`vcs`](../vcs/README.md) segment. The major difference
is performance and the focus on `git`. It might not support all feature (like clobber
detection), but the most.

## Installation

To use this segment, you need to activate it by adding `gitstatus` to your
`P9K_LEFT_PROMPT_ELEMENTS` or `P9K_RIGHT_PROMPT_ELEMENTS` array, depending
where you want to show this segment.

Additionally, you need to install [gitstatus](https://github.com/romkatv/gitstatus) on your own, and point
`P9K_GITSTATUS_DIR` to the directory where `gitstatus.plugin.zsh` file lies.

## States

This segment can have different states. You can customize the different states
as you wish. Here is a quick overview:

![](states.png)

## Configuration

The `gitstatus` segment will shows the status of your git repo. For customization,
you could set the following variables:

| Variable | Default Value | Description |
|----------|---------------|-------------|
|`P9K_GITSTATUS_MAX_SYNC_LATENCY_SECONDS`|`5`|Set to a higher value, if the gitstatus segment does not show up in your repo.|
|`P9K_GITSTATUS_HIDE_BRANCH_ICON`|`false`|Set to `true` to hide the branch icon from the segment.|
|`P9K_GITSTATUS_SHOW_CHANGESET`|`false`|Set to `true` to display the hash / changeset in the segment.|
|`P9K_GITSTATUS_CHANGESET_HASH_LENGTH`|`8`|How many characters of the hash / changeset to display in the segment.|
|`P9K_GITSTATUS_ACTIONFORMAT_FOREGROUND`|`red`|The color of the foreground font during actions (e.g., `REBASE`).|
|`P9K_GITSTATUS_ALWAYS_SHOW_REMOTE_BRANCH`|`false`|Set to true If you would to always see the remote branch.|

### Gitstatus symbols

The `gitstatus` segment uses various symbols to tell you the state of your repository.
These symbols depend on your installed font and selected `P9K_MODE`
from the [Installation](../../README.md#Installation) section.

| `Compatible` | `Powerline` | `Awesome Powerline` | Explanation
|--------------|---------------------|-------------------|--------------------------
| `↑4`         | `↑4`                | ![icon_outgoing](https://cloud.githubusercontent.com/assets/1544760/7976089/b5904d6e-0a76-11e5-8147-5e873ac52d79.gif)4  | Number of commits your repository is ahead of your remote branch
| `↓5`         | `↓5`                | ![icon_incoming](https://cloud.githubusercontent.com/assets/1544760/7976091/b5909c9c-0a76-11e5-9cad-9bf0a28a897c.gif)5  | Number of commits your repository is behind of your remote branch
| `⍟3`         | `⍟3`                | ![icon_stash](https://cloud.githubusercontent.com/assets/1544760/7976094/b5ae9346-0a76-11e5-8cc7-e98b81824118.gif)3 | Number of stashes, here 3.
| `●`          | `●`                 | ![icon_unstaged](https://cloud.githubusercontent.com/assets/1544760/7976096/b5aefa98-0a76-11e5-9408-985440471215.gif) | There are unstaged changes in your working copy
| `✚`          | `✚`                 | ![icon_staged](https://cloud.githubusercontent.com/assets/1544760/7976095/b5aecc8a-0a76-11e5-8988-221afc6e8982.gif) | There are staged changes in your working copy
| `?`          | `?`                 | ![icon_untracked](https://cloud.githubusercontent.com/assets/1544760/7976098/b5c7a2e6-0a76-11e5-8c5b-315b595b2bc4.gif)  | There are files in your working copy, that are unknown to your repository
| `→`          | `→`                 | ![icon_remote_tracking_branch](https://cloud.githubusercontent.com/assets/1544760/7976093/b5ad2c0e-0a76-11e5-9cd3-62a077b1b0c7.gif) | The name of your branch differs from its tracking branch.
| `@`         | ![icon_branch_powerline](https://cloud.githubusercontent.com/assets/1544760/8000852/e7e8d8a0-0b5f-11e5-9834-de9b25c92284.gif) | ![](https://cloud.githubusercontent.com/assets/1544760/7976087/b58bbe3e-0a76-11e5-8d0d-7a5c1bc7f730.gif) | Branch Icon
| None         |  None               | ![icon_commit](https://cloud.githubusercontent.com/assets/1544760/7976088/b58f4e50-0a76-11e5-9e70-86450d937030.gif)2c3705 | The current commit hash. Here "2c3705"
| None         |  None               | ![icon_git](https://cloud.githubusercontent.com/assets/1544760/7976092/b5909f80-0a76-11e5-9950-1438b9d72465.gif) | Repository is a git repository

You can get a full list of icons used in your terminal by calling
`show_defined_icons`. It prints out a list of variables you can
set to overwrite every icon.

### Color Customization

You can change the foreground and background color of this segment by setting
```
# Checkout Clean
P9K_GITSTATUS_CLEAN_FOREGROUND='red'
P9K_GITSTATUS_CLEAN_BACKGROUND='blue'

# Checkout Contains Untracked Files
P9K_GITSTATUS_UNTRACKED_FOREGROUND='red'
P9K_GITSTATUS_UNTRACKED_BACKGROUND='blue'

# Checkout Contains (Tracked) Modified Files
P9K_GITSTATUS_MODIFIED_FOREGROUND='red'
P9K_GITSTATUS_MODIFIED_BACKGROUND='blue'
```

### Customize Icon

The main Icon of this segment depends on its state.
It can be changed by setting:
```
P9K_GITSTATUS_CLEAN_ICON="my_icon"
P9K_GITSTATUS_UNTRACKED_ICON="my_icon"
P9K_GITSTATUS_MODIFIED_ICON="my_icon"
```

The Icon color accordingly:
```
P9K_GITSTATUS_CLEAN_ICON_COLOR="red"
P9K_GITSTATUS_UNTRACKED_ICON_COLOR="red"
P9K_GITSTATUS_MODIFIED_ICON_COLOR="red"
```
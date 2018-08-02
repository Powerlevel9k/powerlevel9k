## General Wiki Code Style

Keeping an open wiki that everyone can edit is important to the project, and spirit of the project. However, some constancy in markdown formatting goes a long way to make the wiki look as good as it is informative.

Following these guidelines while making the readme for your plugin/theme would be recommended as well, but is not required.

---

## Headers

| GFM Element | HTML Header Tag Equivalent |                                      Use                                       |
| ----------- | -------------------------- | ------------------------------------------------------------------------------ |
| #           | `<h1>`                     | This will not be used, as Github wiki pages uses the filename as h1             |
| ##          | `<h2>`                     | Main section divider (as in this page _Headers_, _Syntax Highlighting_, etc are) |
| ### - ####  | `<h3>` - `<h4>`            | For use in subsections                                                         |
| #####       | `<h5>`                     | Please try to use this just for labeling _Example_ in fenced code blocks       |
| ######      | `<h6>`                     | For descriptors in example fenced code blocks                                  |

Below is an example of how to use each header (and will be the only use of ##/h2 in abnormal circumstances).

___

## This is a main subject (h2)
### This subject has several important sub-subjects (h3)
#### Some sub-subjects are so vast, they require their own sub-subjects (h4)
##### _Example:_ (h5)
###### _Quick explanation of example:_ (h6)

___

## Tables

Tables are pretty and easy to read; please use them whenever possible for listing aliases, functions, and anything else that could possibly be made into a table.

## Syntax Highlighting

We use _shell_ to highlight code blocks. GitHub-Flavor Markdown (GFM) does support highlighting `zsh` defined code blocks. However, some text editors do not, so this just makes the experience more consistent across the board.

## Line Wrapping

Do not hard wrap lines.

## Italics

Use underscores, not askerisks, to define italics. (This makes it easier to differentiate them from bold words/characters at glance in when editing.)

## Bold

Use double asterisks, not double underscores, to define bold characters or words. (This makes it easier to differentiate them from bold words/characters at glance in when editing.)

## Unnumbered lists

Use hyphens `-` for defining unnumbered lists and sublists, as opposed to asterisks.

## Images

Use Markdown formatting for images, **not HTML**.

###### _Example:_
```markdown
![image description](url to image)
```

## Line Endings

Please use Unix line ending codes and not Windows (Mac OS X uses Unix by default).

### EOF

Please leave a blank newline at the end of the file.

## Miscellaneous

Page breaks such as `---`, `___`, and `===` don't have to be used, but if so, there are no strict guidelines on using them, just don't _over use_ them.

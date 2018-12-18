#### Developers' Guide

#### Branches

Our stable branch is `master`, and our development branch is `next`. The general rule of thumb is that bug fixes can be submitted against `master`, but that all new development should be submitted to `next`. 

If you are ever uncertain, submitting your PR against `next` is the safe bet!

##### Basic Knowledge

Our main entry point are the `PROMPT` and `RPROMPT` variables, which are 
interpreted by zsh itself. All that this (and any other) theme does is
filling these two variables with control instructions (like defining 
colors, etc.) and ready-to-use data. So within this theme we collect a
whole bunch of information to put in that variables. You can find 
`PROMPT` and `RPROMPT` at the very end of the `powerlevel9k.zsh-theme`.

This simple diagram may explain the invoking order better:

```
# Once on ZSH-Startup
           +-----+
           | Zsh |
           +-----+
              |
              v
+-----------------------------+
| prompt_powerlevel9k_setup() |
+-----------------------------+
              |
              v
    +---------------------+    +------------+  +---------------------+
    | build_left_prompt() |--->| prompt_*() |->| $1_prompt_segment() |
    +---------------------+    +------------+  +---------------------+
               ^                                         |
               |                                         v
 +--------------------------------+                 +---------+     +-----------------+
 | powerlevel9k_prepare_prompts() |                 | $PROMPT |<····| Zsh (Rendering) |
 +--------------------------------+                 +---------+     +-----------------+
                 ^
                 |
              +-----+
              | Zsh | # On every Render
              +-----+
```

##### Adding Segments

Feel free to add your own segments. Every segment gets called with an
orientation as first parameter (`left` or `right`), so we can figure
out on which side we should draw the segment. This information is 
used at the time we call the actual segment-drawing function:
`$1_prompt_segment`. To make the magic color-overwrite mechanism to
work, we have to pass our function name as first argument. Usually
this is just `$0`. Second parameter is the array index of the current
segment. This is an internal value, to correctly determine if we need
to glue segments together. This index is already given as second 
parameter to your function (from `build_left_prompt` or 
`build_right_prompt`). Third parameter is a default background color,
fourth the default foreground color. Fifth parameter is our content.
And finally we pass an "visual identifier" (here just a hash; but it
could be a unicode codepoint, string, etc.). The visual identifier is,
for left segments, displayed at the beginning, for right segments it
is displayed at the end.
So our function could look somewhat like this:

```zsh
prompt_echo() {
    local content='Hello World!'
    $1_prompt_segment "$0" "$2" "blue" "red" "$content" "#"
}
```

At this point we can overwrite our blue-on-red segment by putting 
    
    P9K_ECHO_FOREGROUND="200"
    P9K_ECHO_BACKGROUND="040"

in our `~/.zshrc`. We now have a pink-on-green segment. Yay!



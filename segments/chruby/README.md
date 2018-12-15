# Chruby

## Installation

To use this segment, you need to activate it by adding `chruby` to your
`P9K_LEFT_PROMPT_ELEMENTS` or `P9K_RIGHT_PROMPT_ELEMENTS` array, depending
where you want to show this segment.

## Configuration

This segment shows the version of Ruby being used when using `chruby` to change your current Ruby stack.

It uses `$RUBY_ENGINE` and `$RUBY_VERSION` as set by `chruby`.

| Variable | Default Value | Description |
|----------|---------------|-------------|
|`P9K_CHRUBY_SHOW_ENGINE`|true|Show the currently selected Ruby engine (e.g. `ruby`, `jruby`, `rbx`, etc)
|`P9K_CHRUBY_SHOW_VERSION`|true|Shows the currently selected engine's version (e.g. `2.5.1`)

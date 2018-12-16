# Newline

## Installation

To use this segment, you need to activate it by adding `newline` to your
`P9K_LEFT_PROMPT_ELEMENTS` or `P9K_RIGHT_PROMPT_ELEMENTS` array, depending
where you want to show this segment.

## Configuration

Puts a newline in your prompt so you can continue using segments on the next
line. This allows you to use segments on both lines, unlike
`P9K_PROMPT_ON_NEWLINE`, which simply separates segments from the
prompt itself.

This only works on the left side.  On the right side it does nothing.

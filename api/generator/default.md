# powerlevel9k Default Engine


### Source(s)

[https://github.com/bhilburn/powerlevel9k](#https://github.com/bhilburn/powerlevel9k)


### Author(s)

- Ben Hilburn (bhilburn)
- Dominic Ritter (dritter)


### File Description

*This file contains an default generator for the powerlevel9k project. *

## Table of Contents

- [left_prompt_segment()](#left_prompt_segment)
- [left_prompt_end()](#left_prompt_end)
- [right_prompt_segment()](#right_prompt_segment)
- [serialize_segment()](#serialize_segment)
- [prompt_custom()](#prompt_custom)
- [build_left_prompt()](#build_left_prompt)
- [build_right_prompt()](#build_right_prompt)
- [powerlevel9k_preexec()](#powerlevel9k_preexec)
- [powerlevel9k_prepare_prompts()](#powerlevel9k_prepare_prompts)
- [p9k_chpwd()](#p9k_chpwd)
- [prompt_powerlevel9k_setup()](#prompt_powerlevel9k_setup)
- [prompt_powerlevel9k_teardown()](#prompt_powerlevel9k_teardown)

## left_prompt_segment()
*Construct a left prompt segment *

#### Arguments

- **$1** (string) Name of the function that was originally invoked (mandatory).
- **$2** (integer) Index of the segment
- **$3** (string) Background color
- **$4** (string) Foreground color
- **$5** (bool) Whether the segment should be bold
- **$6** (string) Content of the segment
- **$7** (string) Visual identifier (must be a key of the icons array)


## left_prompt_end()
*End the left prompt, closes the final segment *

#### Arguments

- *Function has no arguments.*


## right_prompt_segment()
*Construct a right prompt segment *

#### Arguments

- **$1** (string) Name of the function that was originally invoked (mandatory).
- **$2** (integer) Index of the segment
- **$3** (string) Background color
- **$4** (string) Foreground color
- **$5** (bool) Whether the segment should be bold
- **$6** (string) Content of the segment
- **$7** (string) Visual identifier (must be a key of the icons array)


## serialize_segment()
*This function wraps `left_prompt_segment` and `right_prompt_segment` (for compatibility with the async generator). *

#### Arguments

- **$1** (string) Name of the function that was originally invoked (mandatory).
- **$2** (string) State of the segment.
- **$3** (string) Alignment (left|right).
- **$4** (integer) Index of the segment.
- **$5** (bool) Whether the segment should be joined.
- **$6** (string) Background color.
- **$7** (string) Foreground color.
- **$8** (string) Content of the segment.
- **$9** (string) Visual identifier (must be a key of the icons array).
- **$10** (string) The condition - if the segment should be shown (gets evaluated).


## prompt_custom()
*The `custom` prompt provides a way for users to invoke commands and display the output in a segment. *

#### Arguments

- **$1** (string) Left|Right
- **$2** (integer) Segment index
- **$3** (boolean) Whether the segment should be joined
- **$4** (string) Custom segment name


## build_left_prompt()
*This function loops through the left prompt elements and calls the related segment functions. *

#### Arguments

- *Function has no arguments.*


## build_right_prompt()
*This function loops through the right prompt elements and calls the related segment functions. *

#### Arguments

- *Function has no arguments.*


## powerlevel9k_preexec()
*This function is a hook that runs before the command runs. It sets the start timer. *

#### Arguments

- *Function has no arguments.*


## powerlevel9k_prepare_prompts()
*This function is a hook that is run before the prompts are created. If sets all the required variables for the prompts and then calls the prompt segment building functions. *

#### Arguments

- *Function has no arguments.*


## p9k_chpwd()
*This function is a hook into chpwd to add bindkey support. *

#### Arguments

- *Function has no arguments.*


## prompt_powerlevel9k_setup()
*This is the main function. It does the necessary checks, loads the required resources and sets the required hooks. *

#### Arguments

- *Function has no arguments.*


## prompt_powerlevel9k_teardown()
*This function removed PowerLevel9k hooks and resets the prompts. *

#### Arguments

- *Function has no arguments.*



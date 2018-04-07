# powerlevel9k Default Engine


### Source(s)

[https://github.com/bhilburn/powerlevel9k](#https://github.com/bhilburn/powerlevel9k)


### Author(s)

- Ben Hilburn (bhilburn)
- Dominik Ritter (dritter)


### File Description

*This file contains an default generator for the powerlevel9k project. *

## Table of Contents

- [leftPromptSegment()](#leftPromptSegment)
- [leftPromptEnd()](#leftPromptEnd)
- [rightPromptSegment()](#rightPromptSegment)
- [serializeSegment()](#serializeSegment)
- [prompt_custom()](#prompt_custom)
- [buildLeftPrompt()](#buildLeftPrompt)
- [buildRightPrompt()](#buildRightPrompt)
- [p9k_preexec()](#p9k_preexec)
- [p9kPreparePrompts()](#p9kPreparePrompts)
- [p9kChPwd()](#p9kChPwd)
- [prompt_powerlevel9k_setup()](#prompt_powerlevel9k_setup)
- [prompt_p9k_teardown()](#prompt_p9k_teardown)

## leftPromptSegment()
*Construct a left prompt segment *

#### Arguments

- **$1** (string) Name of the function that was originally invoked (mandatory).
- **$2** (integer) Index of the segment
- **$3** (string) Background color
- **$4** (string) Foreground color
- **$5** (bool) Whether the segment should be bold
- **$6** (string) Content of the segment
- **$7** (string) Visual identifier (must be a key of the icons array)


## leftPromptEnd()
*End the left prompt, closes the final segment *

#### Arguments

- *Function has no arguments.*


## rightPromptSegment()
*Construct a right prompt segment *

#### Arguments

- **$1** (string) Name of the function that was originally invoked (mandatory).
- **$2** (integer) Index of the segment
- **$3** (string) Background color
- **$4** (string) Foreground color
- **$5** (bool) Whether the segment should be bold
- **$6** (string) Content of the segment
- **$7** (string) Visual identifier (must be a key of the icons array)


## serializeSegment()
*This function wraps `leftPromptSegment` and `rightPromptSegment` (for compatibility with the async generator). *

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


## buildLeftPrompt()
*This function loops through the left prompt elements and calls the related segment functions. *

#### Arguments

- *Function has no arguments.*


## buildRightPrompt()
*This function loops through the right prompt elements and calls the related segment functions. *

#### Arguments

- *Function has no arguments.*


## p9k_preexec()
*This function is a hook that runs before the command runs. It sets the start timer. *

#### Arguments

- *Function has no arguments.*


## p9kPreparePrompts()
*This function is a hook that is run before the prompts are created. If sets all the required variables for the prompts and then calls the prompt segment building functions. *

#### Arguments

- *Function has no arguments.*


## p9kChPwd()
*This function is a hook into chpwd to add bindkey support. *

#### Arguments

- *Function has no arguments.*


## prompt_powerlevel9k_setup()
*This is the main function. It does the necessary checks, loads the required resources and sets the required hooks. *

#### Arguments

- *Function has no arguments.*


## prompt_p9k_teardown()
*This function removed PowerLevel9k hooks and resets the prompts. *

#### Arguments

- *Function has no arguments.*



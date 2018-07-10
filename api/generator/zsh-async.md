# powerlevel9k ZSH-Async Engine


### Source(s)

[https://github.com/bhilburn/powerlevel9k](#https://github.com/bhilburn/powerlevel9k)


### Author(s)

- Ben Hilburn (bhilburn)
- Dominik Ritter (dritter)
- Christo Kotze (onaforeignshore)


### Dependencies

- [zsh-async](https://github.com/mafredri/zsh-async)


### File Description

*This file contains an async generator for the powerlevel9k project. It makes use of zsh-async in order to build the prompts asynchronously. *

*Please note that this is A WORK IN PROGRESS, so use at your own risk! *

## Table of Contents

- [leftPromptSegment](#leftPromptSegment)
- [rightPromptSegment](#rightPromptSegment)
- [p9kAsyncCallback](#p9kAsyncCallback)
- [p9kPrepareSegment](#p9kPrepareSegment)
- [prompt_custom](#prompt_custom)
- [buildLeftPrompt](#buildLeftPrompt)
- [buildRightPrompt](#buildRightPrompt)
- [p9k_preexec](#p9k_preexec)
- [p9kPreparePrompts](#p9kPreparePrompts)
- [p9kChPwd](#p9kChPwd)
- [prompt_powerlevel9k_setup](#prompt_powerlevel9k_setup)
- [prompt_p9k_teardown](#prompt_p9k_teardown)

## leftPromptSegment
*Print a left prompt segment *

#### Arguments

- **$1** (string) Name - The stateful name of the function that was originally invoked (mandatory).
- **$2** (integer) Index - Segment array index
- **$3** (boolean) Joined - If user wants segment to be joined with previous one
- **$4** (string) Content - Segment content
- **$5** (string) Visual Identifier - Segment icon
- **$6** (string) Background - Background of previous segment


## rightPromptSegment
*Print a right prompt segment No ending for the right prompt segment is needed (unlike the left prompt, above). *

#### Arguments

- **$1** (string) - Name of the function that was originally invoked (mandatory).
- Necessary, to make the dynamic color-overwrite mechanism work.
- **$2** (integer) - The array index of the current segment
- **$3** (boolean) - If the segment should be joined or not
- **$4** (string) - The segment content
- **$5** (string) - An identifying icon (must be a key of the icons array)
- **$6** (string) - Previous segments background color


## p9kAsyncCallback
*This function is the heart of the async engine. Whenever a subshell is completed, this function is called to deal with the generated output. *

#### Arguments

- **$1** (string) Job - The name of the calling function or job
- **$2** (number) Code - Return code (If the value is -1, then it is likely that there is a bug)
- **$3** (string) Output - Resulting (stdout) output from the job
- **$4** (number) Exec_Time - Execution time, floating point (in seconds)
- **$5** (string) Err - Resulting (stderr) output from the job


## p9kPrepareSegment
*This function processes the segment code in a subshell. When done, the resulting data is sent to `p9kAsyncCallback`. *

#### Arguments

- **$1** (string) Name of the function that was originally invoked (mandatory)
- **$2** (string) State of the segment
- **$3** (string) Alignment (left|right)
- **$4** (integer) Index of the segment
- **$5** (bool) Whether the segment should be joined
- **$6** (string) Content of the segment
- **$7** (string) The condition - if the segment should be shown (gets evaluated)
- **$8** (string) Visual identifier overide
- **$9** (string) Background overide
- **$10** (string) Foreground overide


## prompt_custom
*The `custom` prompt provides a way for users to invoke commands and display the output in a segment. *

#### Arguments

- **$1** (string) Left|Right
- **$2** (integer) Segment index
- **$3** (boolean) Whether the segment should be joined
- **$4** (string) Custom segment name


## buildLeftPrompt
*This function loops through the left prompt elements and calls the related segment functions. *

#### Arguments

- *Function has no arguments.*


## buildRightPrompt
*This function loops through the right prompt elements and calls the related segment functions. *

#### Arguments

- *Function has no arguments.*


## p9k_preexec
*This function is a hook that runs before the command runs. It sets the start timer. *

#### Arguments

- *Function has no arguments.*


## p9kPreparePrompts
*This function is a hook that is run before the prompts are created. If sets all the required variables for the prompts and then calls the prompt segment building functions. *

#### Arguments

- *Function has no arguments.*


## p9kChPwd
*This function is a hook into chpwd to add bindkey support. *

#### Arguments

- *Function has no arguments.*


## prompt_powerlevel9k_setup
*This is the main function. It does the necessary checks, loads the required resources and sets the required hooks. *

#### Arguments

- *Function has no arguments.*


## prompt_p9k_teardown
*This function removed PowerLevel9k hooks and resets the prompts. *

#### Arguments

- *Function has no arguments.*



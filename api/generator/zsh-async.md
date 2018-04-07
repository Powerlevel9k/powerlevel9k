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

- [leftPromptSegment()](#leftPromptSegment)
- [rightPromptSegment()](#rightPromptSegment)
- [lastLeftBg()](#lastLeftBg)
- [lastRightBg()](#lastRightBg)
- [updateLeftPrompt()](#updateLeftPrompt)
- [updateRightPrompt()](#updateRightPrompt)
- [p9kAsyncCallback()](#p9kAsyncCallback)
- [p9kSerializeSegment()](#p9kSerializeSegment)
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
*Spawn a subshell to convert the data into a left prompt segment *

#### Arguments

- **$1** (string) Name - The stateful name of the function that was originally invoked (mandatory).
- **$2** (integer) Index - Segment array index
- **$3** (string) Background - Segment background color
- **$4** (string) Foreground - Segment foreground color
- **$5** (boolean) Bold - Whether the segment should be bold
- **$6** (string) Content - Segment content
- **$7** (string) Visual Identifier - Segment icon


## rightPromptSegment()
*Spawn a subshell to convert the data into a right prompt segment *

#### Arguments

- **$1** (string) Name - The stateful name of the function that was originally invoked (mandatory).
- **$2** (integer) Index - Segment array index
- **$3** (string) Background - Segment background color
- **$4** (string) Foreground - Segment foreground color
- **$5** (boolean) Bold - Whether the segment should be bold
- **$6** (string) Content - Segment content
- **$7** (string) Visual Identifier - Segment icon


## lastLeftBg()
*This function determines the background of the previous VISIBLE segment in the left prompt. *

#### Arguments

- **$1** (integer) Index - Left prompt source segment index


## lastRightBg()
*This function determines the background of the previous VISIBLE segment in the right prompt. *

#### Arguments

- **$1** (integer) Index - Right prompt source segment index


## updateLeftPrompt()
*This function walks through the Left Prompt segment array and rebuilds the left prompt every time a subshell returns. *

#### Arguments

- *Function has no arguments.*


## updateRightPrompt()
*This function walks through the Right Prompt segment array and rebuilds the right prompt every time a subshell returns. *

#### Arguments

- *Function has no arguments.*


## p9kAsyncCallback()
*This function is the heart of the async engine. Whenever a subshell is completed, this function is called to deal with the generated output. *

#### Arguments

- **$1** (string) Job - The name of the calling function or job
- **$2** (number) Code - Return code (If the value is -1, then it is likely that there is a bug)
- **$3** (string) Output - Resulting (stdout) output from the job
- **$4** (number) Exec_Time - Execution time, floating point (in seconds)
- **$5** (string) Err - Resulting (stderr) output from the job


## p9kSerializeSegment()
*This function processes the segment code in a subshell. When done, the resulting data is sent to `p9kAsyncCallback`. *

#### Arguments

- **$1** (string) Name - Segment name
- **$2** (string) State - Segment state
- **$3** (string) Alignment - left|right
- **$4** (integer) Index - Segment array index
- **$5** (boolean) Joined - If the segment should be joined
- **$6** (string) Background - Segment background color
- **$7** (string) Foreground - Segment foreground color
- **$8** (string) Content - Segment content
- **$9** (string) Visual identifier - Segment icon
- **$10** (string) Condition - The condition, if the segment should be printed (gets evaluated)


## serializeSegment()
*This function is a wrapper function that starts off the async process and passes the parameters from the segment code to the subshells. *

#### Arguments

- **...** (misc) The parameters passed from the segment code


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



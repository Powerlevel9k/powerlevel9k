# powerlevel9k Default Engine


### Source(s)

[powerlevel9k](https://github.com/bhilburn/powerlevel9k)

### Author(s)

- Ben Hilburn - [@bhilburn](https://github.com/bhilburn)
- Dominik Ritter - [@dritter](https://github.com/dritter)
- Christo Kotze - [@onaforeignshore](https://github.com/onaforeignshore)


### File Description

*This file contains the default generator for the powerlevel9k project. *

## Table of Contents

- [__p9k_left_prompt_segment](#__p9k_left_prompt_segment)
- [__p9k_left_prompt_end](#__p9k_left_prompt_end)
- [__p9k_right_prompt_segment](#__p9k_right_prompt_segment)
- [p9k::prepare_segment](#p9kprepare_segment)
- [__p9k_prompt_custom](#__p9k_prompt_custom)
- [__p9k_build_left_prompt](#__p9k_build_left_prompt)
- [__p9k_build_right_prompt](#__p9k_build_right_prompt)
- [__p9k_preexec](#__p9k_preexec)
- [__p9k_prepare_prompts](#__p9k_prepare_prompts)
- [__p9k_ch_pwd](#__p9k_ch_pwd)
- [prompt_powerlevel9k_setup](#prompt_powerlevel9k_setup)
- [prompt_powerlevel9k_teardown](#prompt_powerlevel9k_teardown)

## __p9k_left_prompt_segment
*Construct a left prompt segment *

#### Arguments

- **$1** (string) Stateful name of the function that was originally invoked (mandatory).
- **$2** (integer) Index of the segment
- **$3** (boolean) Whether the segment should be joined
- **$4** (string) Content of the segment
- **$5** (string) Visual identifier (must be a key of the icons array)


## __p9k_left_prompt_end
*End the left prompt, closes the final segment *

#### Arguments

- *Function has no arguments.*


## __p9k_right_prompt_segment
*Construct a right prompt segment *

#### Arguments

- **$1** (string) Stateful name of the function that was originally invoked (mandatory).
- **$2** (integer) Index of the segment
- **$3** (boolean) Whether the segment should be joined
- **$4** (string) Content of the segment
- **$5** (string) Visual identifier (must be a key of the icons array)


#### Notes

*No ending for the right prompt segment is needed (unlike the left prompt, above). *

## p9k::prepare_segment
*This function wraps `__p9k_left_prompt_segment` and `__p9k_right_prompt_segment` (for compatibility with the async generator). *

#### Arguments

- **$1** (string) Name of the function that was originally invoked (mandatory)
- **$2** (string) State of the segment
- **$3** (string) Alignment (left|right)
- **$4** (integer) Index of the segment
- **$5** (bool) Whether the segment should be joined
- **$6** (string) Content of the segment
- **$7** (string) The condition - if the segment should be shown (gets evaluated)
- **$8** (string) Visual identifier overide - *must* be a named icon string
- **$9** (string) Background overide
- **$10** (string) Foreground overide


## __p9k_prompt_custom
*The `custom` prompt provides a way for users to invoke commands and display the output in a segment. *

#### Arguments

- **$1** (string) Left|Right
- **$2** (integer) Segment index
- **$3** (boolean) Whether the segment should be joined
- **$4** (string) Custom segment name


## __p9k_build_left_prompt
*This function loops through the left prompt elements and calls the related segment functions. *

#### Arguments

- *Function has no arguments.*


## __p9k_build_right_prompt
*This function loops through the right prompt elements and calls the related segment functions. *

#### Arguments

- *Function has no arguments.*


## __p9k_preexec
*This function is a hook that runs before the command runs. It sets the start timer. *

#### Arguments

- *Function has no arguments.*


## __p9k_prepare_prompts
*This function is a hook that is run before the prompts are created. If sets all the required variables for the prompts and then calls the prompt segment building functions. *

#### Arguments

- *Function has no arguments.*


## __p9k_ch_pwd
*This function is a hook into chpwd to add bindkey support. *

#### Arguments

- *Function has no arguments.*


## prompt_powerlevel9k_setup
*This is the main function. It does the necessary checks, loads the required resources and sets the required hooks. *

#### Arguments

- *Function has no arguments.*


## prompt_powerlevel9k_teardown
*This function removed PowerLevel9k hooks and resets the prompts. *

#### Arguments

- *Function has no arguments.*



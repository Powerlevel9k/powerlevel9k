There are two steps to start using this theme:

1. [Install the Powerlevel9k Theme](#step-1-install-powerlevel9k)
    1. [Arch Linux](#arch-linux)
    2. [NixOS](#nixos)
    3. [macOS with homebrew](#macos-with-homebrew)
    4. [Vanilla ZSH Install](#option-1-install-for-vanilla-zsh)
    5. [Oh-My-ZSH Install](#option-2-install-for-oh-my-zsh)
    6. [Prezto Install](#option-3-install-for-prezto)
    7. [Antigen Install](#option-4-install-for-antigen)
    8. [Zplug Install](#option-5-install-for-zplug)
    9. [Zgen Install](#option-6-install-for-zgen)
    10. [Antibody Install](#option-7-install-for-antibody)
    11. [ZPM Install](#option-8-install-for-zpm)
    12. [ZIM Install](#option-9-install-for-zim)
2. [Install a Powerline Font](#step-2-install-a-powerline-font)
    1. [Option 1: Install Powerline Fonts](#option-1-install-powerline-fonts)
    2. [Option 2: Use a Programmer Font](#option-2-use-a-programmer-font)
    3. [Option 3: Install Awesome Powerline Fonts](#option-3-install-awesome-powerline-fonts)
    4. [Option 4: Install Nerd-Fonts](#option-4-install-nerd-fonts)

To get the most out of Powerlevel9k, you need to install both the theme as well
as Powerline-patched fonts, if you don't have them installed already. If you
cannot install Powerline-patched fonts for some reason, follow the instructions
below for a `compatible` install.

No configuration is necessary post-installation if you like the default
settings, but there is plenty of segment configuration available if you are
interested.

## Step 1: Install Powerlevel9k
There are several ways to install and use the Powerlevel9k theme: vanilla ZSH,
Oh-My-Zsh, Prezto, Antigen, Zgen, Antibody, ZPM and ZIM. Some Distributions like Arch Linux also provides a package. Do **one** of the following, depending on how you use ZSH.

### Arch Linux

`sudo pacman -S zsh-theme-powerlevel9k`

To enable Powerlevel9k theme for your user type:

`echo 'source /usr/share/zsh-theme-powerlevel9k/powerlevel9k.zsh-theme' >> ~/.zshrc`

### NixOS

Add this line to your `configuration.nix`

`programs.zsh.promptInit = "source ${pkgs.zsh-powerlevel9k}/share/zsh-powerlevel9k/powerlevel9k.zsh-theme";`

### macOS with homebrew

First get the homebrew tap 

`brew tap sambadevi/powerlevel9k`

Then install `powerlevel9k` via brew

`brew install powerlevel9k`

As an alternative you can also install a specific version (0.6.3 as an example)

`brew install powerlevel9k@0.6.3`

Further steps, how to integrate p9k into your `.zshrc`, will be shown after installation:
```
$ brew install powerlevel9k@0.6.3
...
If you want to load powerlevel9k in your zsh simply add the following line to your .zshrc:

  source /usr/local/opt/powerlevel9k@0.6.3/powerlevel9k.zsh-theme

Alternatively you can run this command to append the line to your .zshrc

  echo "source /usr/local/opt/powerlevel9k@0.6.3/powerlevel9k.zsh-theme" >> ~/.zshrc
```

### Option 1: Install for Vanilla ZSH

If you just use a vanilla ZSH install, simply clone this repository and
reference it in your `~/.zshrc`:

    $ git clone https://github.com/bhilburn/powerlevel9k.git ~/powerlevel9k
    $ echo 'source  ~/powerlevel9k/powerlevel9k.zsh-theme' >> ~/.zshrc

### Option 2: Install for Oh-My-ZSH

To install this theme for use in
[Oh-My-Zsh](https://github.com/robbyrussell/oh-my-zsh), clone this repository
into your OMZ `custom/themes` directory.

    $ git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k

You then need to select this theme in your `~/.zshrc`:

    ZSH_THEME="powerlevel9k/powerlevel9k"

### Option 3: Install for Prezto

To install this theme for use in Prezto, clone this repository into your
[Prezto](https://github.com/sorin-ionescu/prezto) `prompt/external` directory.

    $ git clone https://github.com/bhilburn/powerlevel9k.git  ~/.zprezto/modules/prompt/external/powerlevel9k
    $ ln -s ~/.zprezto/modules/prompt/external/powerlevel9k/powerlevel9k.zsh-theme ~/.zprezto/modules/prompt/functions/prompt_P9K_setup

You then need to select this theme in your `~/.zpreztorc`:

    zstyle ':prezto:module:prompt' theme 'powerlevel9k'

Please note if you plan to set a `P9K_MODE` to use a specific font, [as described in this section of the Wiki](https://github.com/bhilburn/powerlevel9k/wiki/Install-Instructions#option-2-install-awesome-powerline-fonts), you must set the `MODE` **before** `prezto` is loaded.

### Option 4: Install for antigen

To install this theme for use in [antigen](https://github.com/zsh-users/antigen), just add this at the beginning
of your `~/.zshrc`:

    P9K_INSTALLATION_PATH=$ANTIGEN_BUNDLES/bhilburn/powerlevel9k

And this anywhere after:

    antigen theme bhilburn/powerlevel9k powerlevel9k
    antigen apply

Note that you should define any customizations at the top of your `.zshrc` (i.e. setting the `P9K_*` variables) in your `.zshrc`.

You may need to do a `rm -rf ~/.antigen` to force a reinstall of all the antigen bundles. Also, remember to restart your terminal emulator after this step.

### Option 5: Install for Zplug

To install this theme for use in [Zplug](https://github.com/b4b4r07/zplug), just add this 
in your `~/.zshrc`:

    zplug "bhilburn/powerlevel9k", use:powerlevel9k.zsh-theme

Note that you should define any customizations at the top of your `.zshrc`
(i.e. setting the `P9K_*` variables) in your `.zshrc`.

### Option 6: Install for Zgen

To install this theme for use in [zgen](https://github.com/tarjoilija/zgen), just add this 
in your `~/.zshrc`:

    zgen load bhilburn/powerlevel9k powerlevel9k

Note that you should define any customizations at the top of your .zshrc
(i.e. setting the `P9K_*` variables) in your `.zshrc`.

### Option 7: Install for Antibody

To install this theme for use in [Antibody](https://github.com/caarlos0/antibody), just add this 
in your `~/.zshrc`:

    antibody bundle bhilburn/powerlevel9k

Note that you should define any customizations at the top of your `.zshrc`
(i.e. setting the `P9K_*` variables) in your `.zshrc`.

### Option 8: Install for ZPM

To install this theme for use in [ZPM](https://github.com/horosgrisa/ZPM), just add this 
in your `~/.zshrc`:

    Plug bhilburn/powerlevel9k
    source ~/.local/share/zpm/plugins/powerlevel9k/powerlevel9k.zsh-theme

Note that you should define any customizations at the top of your `.zshrc`
(i.e. setting the `P9K_*` variables) in your `.zshrc`.

### Option 9: Install for ZIM

To install this theme for use in ZIM, clone this repository into your
[ZIM](https://github.com/Eriner/zim) `prompt/external-themes` directory.

    $ git clone https://github.com/bhilburn/powerlevel9k.git ~/.zim/modules/prompt/external-themes/powerlevel9k
    $ ln -s ~/.zim/modules/prompt/external-themes/powerlevel9k/powerlevel9k.zsh-theme ~/.zim/modules/prompt/functions/prompt_P9K_setup

Add this at the beginning of your `~/.zshrc`:

    P9K_INSTALLATION_PATH=~/.zim/modules/prompt/external-themes/powerlevel9k/powerlevel9k.zsh-theme

You then need to select this theme in your `~/.zimrc`:

    zprompt_theme='powerlevel9k'

Note that you should define any customizations at the top of your `.zshrc` just below `P9K_INSTALLATION_PATH`
(i.e. setting the `P9K_*` variables) in your `.zshrc`.

## Step 2: Install a Powerline Font
In order for the theme to render properly, you need a font that has the "Powerline" glyphs. These are used at the start & end of the segments to produce the "powerline" appearance. Additionally, if your font includes any of the expanded glyph set, Powerlevel9k is capable of making use of those to produce a very nice prompt.

Dealing with fonts can be really confusing, and you have multiple options for installing fonts. You can find more details about how fonts, and the various forms of installation described below, work on [the 'About Fonts' page of the Wiki](https://github.com/bhilburn/powerlevel9k/wiki/About-Fonts).

**N.B.:** If Powerlevel9k is not working properly, it is almost always the case that the fonts were not properly installed, or you have not configured your terminal to use a Powerline-patched font - ([you must change it](https://github.com/powerline/fonts/issues/185))!

There are four ways you can get a Powerline font:

### Option 1: Install Powerline Fonts

You can find the [installation instructions for Powerline Fonts here](https://powerline.readthedocs.org/en/latest/installation/linux.html#fonts-installation).
You can also find the raw font files [in this Github
repository](https://github.com/powerline/fonts) if you want to manually install
them for your OS.

After you have installed Powerline fonts, make the default font in your terminal
emulator the Powerline font you want to use.

This is the default mode for `Powerlevel9k`, and no further configuration is
necessary.

### Option 2: Use a Programmer Font

There are now some fonts, meant specifically for software programmers, that not only provide the necessary powerline glyphs but may also have some of the additional glyphs from [Font Awesome](http://fontawesome.io/). The most well-known are [Adobe Source Code Pro](https://github.com/adobe-fonts/source-code-pro) and [Source Code Pro](https://github.com/powerline/fonts/tree/master/SourceCodePro), which are usually available from your OS's package manager.

**NOTE:** The default "programmer" fonts have *some* of the glyphs, like the segment separators, but are missing many others. If you plan to use anything more than the basic glyphs, you'll need a patched version of those fonts, like those you would find in Options 3 and 4, below.

Once you have installed the font, configure your terminal to use that font. Powerlevel9k should then work immediately, with no additional configuration.

These fonts usually also have some of the icons from the 'Awesome Font' special character set. If you wish to take advantage of the additional glyphs, put the following in your `~/.zshrc` **before you specify the powerlevel9k theme**:

    P9K_MODE='awesome-fontconfig'

### Option 3: Install Awesome-Powerline Fonts

Alternatively, you can install [Awesome-Terminal
Fonts](https://github.com/gabrielelana/awesome-terminal-fonts), which provide
a number of additional glyphs.

You then need to indicate that you wish to use the additional glyphs by defining
**one** of the following in your `~/.zshrc` **before you specify the powerlevel9k theme**:

If you use `fontconfig` to install them:

    P9K_MODE='awesome-fontconfig'

If you use [pre-patched fonts](https://github.com/gabrielelana/awesome-terminal-fonts/tree/patching-strategy/patched):

    P9K_MODE='awesome-patched'

### Option 4: Install Nerd-Fonts

The [Nerd-Fonts](https://github.com/ryanoasis/nerd-fonts) project is an effort to create fonts truly tricked out with as many glyphs as possible. After installing `nerd-fonts` and configuring your terminal emulator to use one, configure Powerlevel9k by putting the following in your `~/.zshrc`:

    P9K_MODE='nerdfont-complete'
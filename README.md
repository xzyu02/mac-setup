# Macbook Setup

Setup for my new Mac.
Special Thanks to https://github.com/danvega/new-macbook-setup/tree/master/2021

## Get Started

### Install Apps in App Store

- Wechat
- Xcode
- runcat-plugins-manager
- GlobalProtect (for school VPN)

```sh
xcode-select --install
```
### [Homebrew](https://brew.sh/) and Others

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

**Productivity**
```sh
brew install git \
    tree \
    mysql \
    htop \
    wget \
    tmux \
    vim \
    
brew install --cask anaconda \
    google-chrome \
    visual-studio-code \
    docker \
    notion \
    adobe-creative-cloud \
    raycast \
    cyberduck \
    clashx \
    iina \
    rstudio \
    google-drive \
    microsoft-office \
    figma \
    tempbox \
    mongodb-compass \
    

# other cast apps that might be useful
dropzone
alt-tab
monitorcontrol
```

**Conda Setup ZSH**
It is wired that anaconda install does not finish export to $PATH, an easiler way to solve this on m2pro chip is use anaconda navigator to open base environment, and do `conda init zsh`. Then every terminal will automatically loads conda.

**Social**
```sh
brew install --cask zoom \
    slack \
    discord \
    telegram
```

**Others**
```sh
brew install --cask youdaodict \
    eudic \
    transocks \
    deepl \
    grammarly \
    xmind \
    logi-options-plus \
    neteasemusic \
    mendeley 
```

### Git Config
```sh
git config --global user.email "yuxizheng@outlook.com"
git config --global user.name "Xizheng Yu"
```
Next, https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh

### Node & NPM
- [Node Version Manager (NVM)](https://github.com/nvm-sh/nvm)
```sh
nvm install stable
```

### SDKs - Use [SDKMAN](https://sdkman.io/install) could easily manage different SDKs
- Full list of SDKs [https://sdkman.io/sdks](https://sdkman.io/sdks)
- Java - use `sdk install java` to install stable version Java

### Raycast Extensions
- cheatsheet
- search books
- word search
- ocr
- google translate
- myip
- slack
- notion
- ......

### Install from Internet
- Matlab
- 东方财富

### Clean Up Cache
```sh
brew cleanup --prune=all
```

### Oh My zsh
- `plugins=(git brew macos docker node npm nvm httpie python tmux virtualenv)`
- Add support for conda env, [Reference](https://gist.github.com/Samyak2/6676c608371e915e3c066dbbdcc25622)
    - Add the virtualenv plugin to `~/.zshrc` and make sure these lines are in `~/.oh-my-zsh/plugins/virtualenv/virtualenv.plugin.zsh`
        ```sh
        # disables prompt mangling in virtual_env/bin/activate
        export VIRTUAL_ENV_DISABLE_PROMPT=1

        #Disable conda prompt changes
        #https://conda.io/docs/user-guide/configuration/use-condarc.html#change-command-prompt-changeps1
        #changeps1: False
        `conda config --set changeps1 false`
        ```
    - Add these helper function to `~/.oh-my-zsh/themes/*.zsh-theme`, in my case, my default theme is `robbyrussell.zsh-theme`
        ```sh
        function conda_info {
            if [[ -n "$CONDA_DEFAULT_ENV" ]]; then
                echo "%{$fg[green]%}(${CONDA_DEFAULT_ENV})%{$reset_color%}"
            fi
        }

        PROMPT="$(conda_info) %(?:%{$fg_bold[green]%}➜:%{$fg_bold[red]%}➜ ) %{$fg[cyan]%}%c%{$reset_color%}"
        PROMPT+=' $(git_prompt_info)'

        ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
        ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
        ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
        ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
        ```
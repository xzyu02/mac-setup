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

### SDKs
- Java

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


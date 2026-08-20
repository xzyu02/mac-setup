# Oh My Zsh Setup

This setup keeps Oh My Zsh while avoiding expensive runtime-manager work every
time a terminal opens. Node.js comes from Homebrew, Miniforge is loaded only
when `conda` or `mamba` is first used, and SDKMAN is loaded only when `sdk` is
first used.

## Install Oh My Zsh

Install [Oh My Zsh](https://ohmyz.sh/) after Homebrew and the standard packages:

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Review an existing `~/.zshrc` before allowing the installer to replace it.

## Recommended `.zprofile`

Keep login-shell setup small. Homebrew provides the system-level Node.js used by
terminal and GUI applications, so NVM is intentionally not loaded.

```sh
if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

typeset -U path PATH
path=("$HOME/.local/bin" $path)
```

## Recommended `.zshrc`

```sh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git brew macos tmux)
source "$ZSH/oh-my-zsh.sh"

typeset -U path PATH
path=(
    "$HOME/.local/bin"
    "$HOME/.detaspace/bin"
    "/Library/TeX/texbin"
    $path
)

# Keep the SDKMAN-managed Java available without initializing SDKMAN eagerly.
export SDKMAN_DIR="$HOME/.sdkman"
if [[ -d "$SDKMAN_DIR/candidates/java/current" ]]; then
    export JAVA_HOME="$SDKMAN_DIR/candidates/java/current"
    path=("$JAVA_HOME/bin" $path)
fi

if [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]]; then
    sdk() {
        unfunction sdk
        source "$SDKMAN_DIR/bin/sdkman-init.sh"
        sdk "$@"
    }
fi

# Load Miniforge only when a conda-family command is first used.
if [[ -d "$HOME/miniforge3" ]]; then
    export CONDA_ROOT="$HOME/miniforge3"

    _load_conda() {
        unfunction conda mamba _load_conda 2>/dev/null
        export PATH="$CONDA_ROOT/bin:$PATH"
        source "$CONDA_ROOT/etc/profile.d/conda.sh"
    }

    conda() {
        _load_conda
        conda "$@"
    }

    mamba() {
        _load_conda
        mamba "$@"
    }
fi

alias mygpt='conda activate openwebui && open-webui serve'
```

Remove the Conda loader and `mygpt` alias if Conda environments are not needed.
The `openwebui` environment must be recreated after migrating from Anaconda to
Miniforge.

## Avoid slow startup patterns

- Do not source `~/.bash_profile` from `~/.zshrc`; keep bash and zsh
  initialization separate.
- Do not enable the Oh My Zsh `nvm` plugin when Node comes from Homebrew.
- Enable command-specific plugins such as `docker` only when the command is
  installed and their aliases or completions are useful.
- Do not run `conda init zsh` when using the lazy-loading functions above. It
  adds an eager Conda hook back to `.zshrc`.
- Keep API keys and other secrets out of shell files tracked by Git.

## Measure startup time

Compare a normal login shell with a shell that skips user configuration:

```sh
for run_number in 1 2 3; do
    /usr/bin/time -p zsh -lic exit
done

/usr/bin/time -p zsh -dfi -c exit
```

For function-level profiling, temporarily add `zmodload zsh/zprof` before the
Oh My Zsh source line, open a new shell, run `zprof`, and then remove the
profiling line.

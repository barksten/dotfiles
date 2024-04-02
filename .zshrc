export XDG_CONFIG_HOME="$HOME"/.config
export XDG_DATA_HOME="$HOME"/.local/share
export XDG_CACHE_HOME="$HOME"/.cache

# export PATH="$HOME/Library/Python/3.11/bin:/opt/homebrew/bin:$PATH"

export PATH="/opt/homebrew/bin:$PATH"
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup

export PIP_REQUIRE_VIRTUALENV=true

if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

  autoload -Uz compinit
  compinit
fi

source "/opt/homebrew/opt/spaceship/spaceship.zsh"
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=4"

export PATH="/opt/homebrew/sbin:$PATH"
export MODULAR_HOME="$XDG_CONFIG_HOME/modular"
export PATH="$XDG_CONFIG_HOME/modular/pkg/packages.modular.com_mojo/bin:$PATH"

export CLICOLOR=1
alias ls="ls -G"
alias ll="ls -lG"
alias imgcat="wezterm imgcat"
alias vim="nvim"
export PATH=$PATH:$(go env GOPATH)/bin


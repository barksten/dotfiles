# My dotfiles

This directory contains the dotfiles for my system

## Requirements

Ensure you have the following installed on your system\

### Homebrew

```/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"```

### Git

```brew install git```

### Stow

```brew install stow```

## Installation

First, checkout the dotfiles repo in your $HOME directory using git

```
$ git clone git@github.com:barksten/dotfiles.git
$ cd dotfiles
```
then use GNU stow to create symlinks
```
$ stow .
```
# Brew bunde

Install homebrew packages
```
$ brew bundle```



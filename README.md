# fzf-git

## Table of Contents

- [fzf-git](#fzf-git)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Installation](#installation)
    - [Download fzf-git to your home directory](#download-fzf-git-to-your-home-directory)
    - [Using key bindings](#using-key-bindings)
  - [Usage](#usage)
  - [License](#license)

## Overview

This is a shell plugin that allows you to execute [`ghq`](https://github.com/x-motemen/ghq) and [`git fuzzy`](https://github.com/bigH/git-fuzzy) commands using keyboard shortcuts utilizing [`junegunn/fzf`](https://github.com/junegunn/fzf), [`x-motemen/ghq`](https://github.com/x-motemen/ghq), and [`bigH/git-fuzzy`](https://github.com/bigH/git-fuzzy).

The following additional features are implemented in the [`ghq`](https://github.com/x-motemen/ghq) command:

- Search and open the directory in Finder
- Search and open the directory in Cursor
- Search and open the directory in Visual Studio Code
- Search and open the directory in Sourcetree

## Installation

### Download [fzf-git](https://github.com/gumob/fzf-git) to your home directory

```shell
wget -O ~/.fzfxcodes https://raw.githubusercontent.com/gumob/fzf-git/main/fzf-git.sh
```

### Using key bindings

Source `fzf` and `fzf-git` in your run command shell.
By default, no key bindings are set. If you want to set the key binding to `Ctrl+G`, please configure it as follows:

```shell
cat <<EOL >> ~/.zshrc
export FZF_GIT_KEY_BINDING="^G"
source ~/.fzfxcodes
EOL
```

`~/.zshrc` should be like this.

```shell
source <(fzf --zsh)
export FZF_GIT_KEY_BINDING='^G'
source ~/.fzfxcodes
```

Source run command

```shell
source ~/.zshrc
```

## Usage

Using the shortcut key set in `FZF_GIT_KEY_BINDING`, you can execute `fzf-git`, which will display a list of `xcodes` commands.

To run `fzf-git` without using the keyboard shortcut, enter the following command in the shell:

```shell
fzf-git
```

## License

This project is licensed under the MIT License. The MIT License is a permissive free software license that allows for the reuse, modification, distribution, and sale of the software. It requires that the original copyright notice and license text be included in all copies or substantial portions of the software. The software is provided "as is", without warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose, and noninfringement.

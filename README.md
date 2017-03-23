# PseudoVim

PseudoVim is a "language" for Vim.
It provides syntax highlighting of basic keywords (such as `begin` and `end`)
which are used when writing pseudo code.
Furthermore, it also provides "smart" indentation.

## Installation

Note, I have not tested these, so use at your own risk (except for Pathogen).
But I would assume that they work.

### [Vundle](https://github.com/gmarik/Vundle.vim)

Add the following to your `~/.vimrc` file and run `PluginInstall` in Vim.

Plugin 'Miista/PseudoVim'

### [vim-plug](https://github.com/junegunn/vim-plug)

Add the following to your `~/.vimrc` file and run `PlugInstall` in Vim.

Plug 'Miista/PseudoVim'

### [Pathogen](https://github.com/tpope/vim-pathogen)

cd ~/.vim/bundle
git clone https://github.com/Miista/PseudoVim.git

### Manual

0. `mkdir -p ~/.vim/{syntax,indent,ftdetect}`
1. `cp syntax/pseudo.vim ~/.vim/syntax/pseudo.vim`
2. `cp indent/pseudo.vim ~/.vim/indent/pseudo.vim`
3. `cp ftdetect/pseudo.vim ~/.vim/ftdetect/pseudo.vim`
4. Restart Vim

# dotfiles

macOS configs: zsh (Starship prompt), git, VS Code.

## Restore on a new machine

```sh
git clone https://github.com/okomarov/dotfiles.git ~/Documents/repos/dotfiles
cd ~/Documents/repos/dotfiles
ln -sf "$PWD"/zsh/.zshrc "$PWD"/zsh/.zshenv "$PWD"/zsh/.zprofile ~/
ln -sf "$PWD"/git/.gitconfig "$PWD"/git/.gitignore_global ~/
```

Dependencies:

```sh
brew install starship fnm uv eza bat zsh-autosuggestions zsh-syntax-highlighting
brew install --cask font-sauce-code-pro-nerd-font
uv python install --default
```

Home files are symlinks into this repo, so edits are picked up by git
automatically (`git config --global` writes through the symlink).

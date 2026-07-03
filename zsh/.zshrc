# Homebrew's zsh compiles an fpath entry pinned to the base version dir
# (.../Cellar/zsh/5.9/...), which disappears on upgrade, breaking autoloads.
# Prepend the stable symlinked functions dir so they resolve across upgrades.
fpath=(/opt/homebrew/share/zsh/functions /opt/homebrew/share/zsh/site-functions $fpath)

# Completions (previously handled by oh-my-zsh)
autoload -Uz compinit && compinit

# History (previously handled by oh-my-zsh)
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt share_history hist_ignore_all_dups hist_ignore_space

# Prompt
eval "$(starship init zsh)"

# Node (fnm)
eval "$(fnm env --use-on-cd)"

export PATH="$HOME/.local/bin:$PATH"

# Claude Code
cc() {
  echo -ne "\033]0;${1:-Claude Code}\007"
  claude
}

# Modern ls/cat (icons need the Nerd Font selected in iTerm2)
alias ls="eza --icons=auto"
alias ll="eza -l --git --icons=auto"
alias la="eza -la --git --icons=auto"
alias lt="eza --tree --icons=auto"
alias cat="bat --paging=never"

# Plugins (syntax highlighting must stay sourced last)
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

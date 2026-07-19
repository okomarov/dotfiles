# Homebrew's zsh compiles an fpath entry pinned to the base version dir
# (.../Cellar/zsh/5.9/...), which disappears on upgrade, breaking autoloads.
# Prepend the stable symlinked functions dir so they resolve across upgrades.
fpath=(/opt/homebrew/share/zsh/functions /opt/homebrew/share/zsh/site-functions $fpath)

# Completions (previously handled by oh-my-zsh)
autoload -Uz compinit && compinit
# Double-Tab opens an interactive menu navigable with arrow keys
zstyle ':completion:*' menu select

# Keybindings (previously handled by oh-my-zsh)
# Up/Down search history for commands starting with what's already typed
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search   # Up
bindkey '^[OA' up-line-or-beginning-search   # Up (application mode)
bindkey '^[[B' down-line-or-beginning-search # Down
bindkey '^[OB' down-line-or-beginning-search # Down (application mode)

# cd into any repo by name from anywhere: `cd planning-applications`,
# or with auto_cd just `planning-applications` (Tab-completes too)
cdpath=(~/Documents/repos)
setopt auto_cd

# History (previously handled by oh-my-zsh)
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt share_history hist_ignore_all_dups hist_ignore_space

# Prompt
eval "$(starship init zsh)"

# Node (fnm)
eval "$(fnm env --use-on-cd)"

# Fuzzy directory jumping: `z <partial-name>` ranks by frecency
eval "$(zoxide init zsh)"

export PATH="$HOME/.local/bin:$PATH"

# Claude Code
cc() {
  echo -ne "\033]0;${1:-Claude Code}\007"
  claude --dangerously-skip-permissions
}

# Modern ls/cat (icons need a Nerd Font; --hyperlink makes filenames
# cmd+clickable in Ghostty via OSC 8 links)
alias ls="eza --icons=auto --hyperlink"
alias ll="eza -l --git --icons=auto --hyperlink"
alias la="eza -la --git --icons=auto --hyperlink"
alias lt="eza --tree --icons=auto --hyperlink"
alias cat="bat --paging=never"

# Markdown side-by-side in nvim: source left, live markview preview right,
# scroll-synced. Quit with :qa
mdp() { nvim "+Markview splitOpen" "$@" }

# Switch Ghostty's theme: `ghostty-theme Solarized Dark` (spaces need no quotes;
# Tab-completes installed names). Rewrites the theme line in the real config
# (resolves the symlink so the dotfiles file is edited, not clobbered). Reload
# Ghostty with ⌘⇧, afterwards.
ghostty-theme() {
  local theme="$*"
  local cfg; cfg="$(realpath "$HOME/.config/ghostty/config" 2>/dev/null)"
  local themes="/Applications/Ghostty.app/Contents/Resources/ghostty/themes"
  [[ -n "$theme" ]] || { print -u2 "usage: ghostty-theme <name>   (browse: ghostty +list-themes)"; return 1 }
  [[ -f "$cfg" ]] || { print -u2 "ghostty-theme: config not found via ~/.config/ghostty/config"; return 1 }
  if [[ -d "$themes" && ! -e "$themes/$theme" && ! -e "$HOME/.config/ghostty/themes/$theme" ]]; then
    print -u2 "ghostty-theme: theme '$theme' not found   (browse: ghostty +list-themes)"; return 1
  fi
  if grep -qE '^[[:space:]]*theme[[:space:]]*=' "$cfg"; then
    local tmp; tmp="$(mktemp)"
    awk -v t="theme = $theme" '/^[[:space:]]*theme[[:space:]]*=/{print t; next} {print}' "$cfg" > "$tmp" && mv "$tmp" "$cfg"
  else
    print "theme = $theme" >> "$cfg"
  fi
  print "Ghostty theme → $theme   (press ⌘⇧, to reload)"
}
compdef '_files -W /Applications/Ghostty.app/Contents/Resources/ghostty/themes' ghostty-theme 2>/dev/null

# Plugins (syntax highlighting must stay sourced last)
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


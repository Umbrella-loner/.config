# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# Completion
autoload -Uz compinit
compinit

# Aliases
alias nrs="sudo nixos-rebuild switch"
alias nrb="sudo nixos-rebuild boot"
alias nrt="sudo nixos-rebuild test"
alias nconf="sudo nvim /etc/nixos/configuration.nix"
alias nflake="sudo nvim /etc/nixos/flake.nix"
alias aria="aria2c -x16 -s16"

# Enable emacs mode
bindkey -v
KEYTIMEOUT=1




# Load plugins
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null || true
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null || true

# Keybindings
bindkey '^ ' autosuggest-accept


# -------- VI MODE INDICATOR (ADD THIS BLOCK) --------
function zle-keymap-select {
  if [[ $KEYMAP == vicmd ]]; then
    MODE="-- NORMAL --"
    echo -ne '\e[2 q'   # block cursor
  else
    MODE="-- INSERT --"
    echo -ne '\e[6 q'   # beam cursor
  fi
  zle reset-prompt
}

zle -N zle-keymap-select

# Ensure correct mode on shell start
function zle-line-init {
  MODE="-- INSERT --"
  echo -ne '\e[6 q'
}

zle -N zle-line-init
# Path
path+=("$HOME/.local/bin")
export PATH

# Prompt (UPDATED)
PROMPT='[%n@%m %~] '


export EDITOR='nvim'
export VISUAL='nvim'
alias vid="yt-dlp --cookies-from-browser chrome"


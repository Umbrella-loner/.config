# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# Completion
autoload -Uz compinit
compinit

# Aliases
alias aria="aria2c -x16 -s16"

# Enable emacs mode
bindkey -e





# Load plugins
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null || true
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null || true

# Keybindings
bindkey '^ ' autosuggest-accept


# Path
path+=("$HOME/.local/bin")
export PATH

# Prompt (UPDATED)
PROMPT='[%n@%m %~] '


export EDITOR='nvim'
export VISUAL='nvim'
alias vid="yt-dlp --cookies-from-browser chrome"


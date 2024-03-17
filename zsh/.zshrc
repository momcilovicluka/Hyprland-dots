# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=/home/sk/.cargo/bin:$PATH

# evals
eval "$(oh-my-posh init zsh --config /home/luka/git/momcilovicluka/powershell/luka.omp.json)"
#eval "$(thefuck --alias)"
fuck() {
    eval "$(thefuck --alias)"
    fuck "$@"
}

#eval "$(navi widget zsh)"

export FZF_DEFAULT_COMMAND='find .'

export ZSH="$HOME/.config/zsh/oh-my-zsh"

ZSH_THEME="mikeh"

plugins=( 
    fzf
    git
    archlinux
    zsh-autocomplete
    zsh-autosuggestions
    #zsh-interactive-cd
    zsh-syntax-highlighting
)

# Download Znap, if it's not there yet.
[[ -r ~/Repos/znap/znap.zsh ]] ||
    git clone --depth 1 -- \
        https://github.com/marlonrichert/zsh-snap.git ~/Repos/znap
source ~/Repos/znap/znap.zsh  # Start Znap
znap source marlonrichert/zsh-autocomplete

zstyle ':autocomplete:history-search-backward:*' list-lines 1024

bindkey '\t' menu-select "$terminfo[kcbt]" menu-select
bindkey -M menuselect '\t' menu-complete "$terminfo[kcbt]" reverse-menu-complete
source $ZSH/oh-my-zsh.sh
() {
   local -a prefix=( '\e'{\[,O} )
   local -a up=( ${^prefix}A ) down=( ${^prefix}B )
   local key=
   for key in $up[@]; do
      bindkey "$key" up-line-or-history
   done
   for key in $down[@]; do
      bindkey "$key" down-line-or-history
   done
}

HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=$HISTSIZE
setopt hist_ignore_all_dups

# Import colorscheme from 'wal' asynchronously
# &   # Run the process in the background.
# ( ) # Hide shell job control messages.
# Not supported in the "fish" shell.
(cat ~/.cache/wal/sequences &)

# Import the colors.
. "${HOME}/.cache/wal/colors.sh"

# Create the alias.
alias dmen='dmenu_run -nb "$color0" -nf "$color15" -sb "$color1" -sf "$color15"'
alias vi=nvim
alias vim=nvim
alias neovim=nvim

alias icat='kitten icat'
alias cat=bat

alias lg=lazygit
alias gf='git fetch'
alias gp='git pull'
alias gP='git push'
alias pushimiga='git push'
alias gs='git status'

# Changing "ls" to "exa"
alias als='exa --icons --color=always --group-directories-first'
alias all='exa -alF --icons --color=always --group-directories-first'
alias ala='exa -a --icons --color=always --group-directories-first'
alias al='exa -F --icons --color=always --group-directories-first'
alias al.='exa -a | egrep "^\."'
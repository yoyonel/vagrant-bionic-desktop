export TERM="xterm-256color"
export EDITOR="vim"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

source $HOME/.powerlevel9k
ZSH_THEME="powerlevel9k/powerlevel9k"

# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/emoji
# https://github.com/jamespeapen/forgit
plugins=(
  command-not-found
  emoji
  forgit
  fzf
  git
  git-extras
  git-flow
  ssh-agent
  zsh-autosuggestions
  zsh-completions
  zsh-syntax-highlighting
)

# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/ssh-agent#settings
zstyle :omz:plugins:ssh-agent agent-forwarding on

# https://github.com/zsh-users/zsh-completions/issues/541
zstyle ':completion:*:make:*:targets' call-command true # outputs all possible results for make targets
zstyle ':completion:*:make:*' tag-order targets
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%B%d%b'
# https://github.com/zsh-users/zsh-completions#using-zsh-frameworks
autoload -U compinit && compinit

source $ZSH/oh-my-zsh.sh

#
export PATH="$PATH:$HOME/.local/bin"

# LSD
alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

# Autojump
. /usr/share/autojump/autojump.sh

# Pyenv
export PATH="$HOME/.pyenv/bin:$PATH"
export PYENV_ROOT="$HOME/.pyenv" 
export PATH="$PYENV_ROOT/bin:$PATH" 
eval "$(pyenv init --path)" >/dev/null 2>&1
eval "$(pyenv init -)" >/dev/null 2>&1

# pipx
export PATH=$HOME/.local/bin:$PATH
autoload -U bashcompinit
bashcompinit
eval "$(register-python-argcomplete pipx)"

# DELTA-DIFF
unset DELTA_PAGER
unset BAT_PAGER
unset PAGER

# XCLIP
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'

# FZF
export FZF_DEFAULT_OPTS='--preview "bat --style=numbers --color=always --line-range :500 {}"'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# GRC
# https://github.com/garabik/grc#zsh
[[ -s "/etc/grc.zsh" ]] && source /etc/grc.zsh
for cmd in g++ gas head make ld ping6 tail traceroute6 $(ls /usr/share/grc/); do
  cmd="${cmd##*conf.}"
  #   type "${cmd}" >/dev/null 2>&1 && echo alias "${cmd}"="$( which grc ) --colour=auto ${cmd}"
  type "${cmd}" >/dev/null 2>&1
done
# FIX: remove coloration on 'make' to keep autocompletion capatibility
alias make='make'

# PyWal
# https://github.com/dylanaraps/pywal/wiki/Getting-Started#applying-the-theme-to-new-terminals
[ -f ~/.cache/wal/sequences ] && (cat ~/.cache/wal/sequences &)
# -R restores the last colorscheme that was in use.
wal -q -n -R >/dev/null

# GITA
source $HOME/.config/gita/.gita-completion.zsh

# hotkeys
bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line

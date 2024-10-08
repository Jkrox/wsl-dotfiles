# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Load optionrc if it exists
[ -f "${ZDOTDIR}/optionrc" ] && source "${ZDOTDIR}optionrc"

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=110000
SAVEHIST=10000
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/jkrox/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
source "$ZDOTDIR"plugins/powerlevel10k/powerlevel10k.zsh-theme
source "$ZDOTDIR"plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source "$ZDOTDIR"plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source "$ZDOTDIR"plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
source "$ZDOTDIR"plugins/zsh-you-should-use/you-should-use.plugin.zsh
export PATH="$PATH:/opt/nvim/"
export PATH="$PATH:/home/jkrox/.local/globalpyenv/bin/:/home/jkrox/.local/.cargo/bin"

# ------------------------------------------------------------------------

# zsh-shift-select https://stackoverflow.com/a/30899296
r-delregion() {
  if ((REGION_ACTIVE)) then
     zle kill-region
  else
    local widget_name=$1
    shift
    zle $widget_name -- $@
  fi
}
r-deselect() {
  ((REGION_ACTIVE = 0))
  local widget_name=$1
  shift
  zle $widget_name -- $@
}
r-select() {
  ((REGION_ACTIVE)) || zle set-mark-command
  local widget_name=$1
  shift
  zle $widget_name -- $@
}
for key     kcap   seq        mode   widget (
    sleft   kLFT   $'\e[1;2D' select   backward-char
    sright  kRIT   $'\e[1;2C' select   forward-char
    sup     kri    $'\e[1;2A' select   up-line-or-history
    sdown   kind   $'\e[1;2B' select   down-line-or-history
    send    kEND   $'\E[1;2F' select   end-of-line
    send2   x      $'\E[4;2~' select   end-of-line
    shome   kHOM   $'\E[1;2H' select   beginning-of-line
    shome2  x      $'\E[1;2~' select   beginning-of-line
    left    kcub1  $'\EOD'    deselect backward-char
    right   kcuf1  $'\EOC'    deselect forward-char
    end     kend   $'\EOF'    deselect end-of-line
    end2    x      $'\E4~'    deselect end-of-line
    home    khome  $'\EOH'    deselect beginning-of-line
    home2   x      $'\E1~'    deselect beginning-of-line
    csleft  x      $'\E[1;6D' select   backward-word
    csright x      $'\E[1;6C' select   forward-word
    csend   x      $'\E[1;6F' select   end-of-line
    cshome  x      $'\E[1;6H' select   beginning-of-line
    cleft   x      $'\E[1;5D' deselect backward-word
    cright  x      $'\E[1;5C' deselect forward-word
    del     kdch1   $'\E[3~'  delregion delete-char
    bs      x       $'^?'     delregion backward-delete-char
  ) {
  eval "key-$key() {
    r-$mode $widget \$@
  }"
  zle -N key-$key
  bindkey ${terminfo[$kcap]-$seq} key-$key
}
# Fix zsh-autosuggestions https://stackoverflow.com/a/30899296
export ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(
  key-right
)
# ctrl+x,c,v https://unix.stackexchange.com/a/634916/424080
function zle-clipboard-cut {
  if ((REGION_ACTIVE)); then
    zle copy-region-as-kill
    print -rn -- $CUTBUFFER | clip.exe
    zle kill-region
  fi
}
zle -N zle-clipboard-cut
function zle-clipboard-copy {
  if ((REGION_ACTIVE)); then
    zle copy-region-as-kill
    print -rn -- $CUTBUFFER | clip.exe
  else
    zle send-break
  fi
}
zle -N zle-clipboard-copy
function zle-clipboard-paste {
  if ((REGION_ACTIVE)); then
    zle kill-region
  fi
  LBUFFER+="$(cat clip.exe)"
}
zle -N zle-clipboard-paste
function zle-pre-cmd {
  stty intr "^@" <$TTY >$TTY
}
precmd_functions=("zle-pre-cmd" ${precmd_functions[@]})
function zle-pre-exec {
  stty intr "^C" <$TTY >$TTY
}
preexec_functions=("zle-pre-exec" ${preexec_functions[@]})
for key     kcap    seq           widget              arg (
    cx      _       $'^X'         zle-clipboard-cut   _
    cc      _       $'^C'         zle-clipboard-copy  _
    cv      _       $'^V'         zle-clipboard-paste _
) {
  if [ "${arg}" = "_" ]; then
    eval "key-$key() {
      zle $widget
    }"
  else
    eval "key-$key() {
      zle-$widget $arg \$@
    }"
  fi
  zle -N key-$key
  bindkey ${terminfo[$kcap]-$seq} key-$key
}
# ctrl+a https://stackoverflow.com/a/68987551/13658418
function widget::select-all() {
  local buflen=$(echo -n "$BUFFER" | wc -m | bc)
  CURSOR=$buflen  
  zle set-mark-command
  while [[ $CURSOR > 0 ]]; do
    zle beginning-of-line
  done
}
zle -N widget::select-all
bindkey '^a' widget::select-all
# ctrl+z
bindkey "^Z" undo

# ------------------------------------------------------------------------

# History substring search options
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

# Personalized alias
alias nano="nano -x -O"
alias ll='lsd -lh --group-dirs=first'
alias la='lsd -a --group-dirs=first'
alias l='lsd --group-dirs=first'
alias lla='lsd -lha --group-dirs=first'
alias ls='lsd --group-dirs=first'
alias lt='lsd --tree --depth 2'
alias lt1='lsd --tree --depth 1'
alias lt2='lsd --tree --depth 3'
alias lt3='lsd --tree --depth 4'
alias cat='/bin/bat'
alias catn='cat'
alias catnl='batcat'
alias df='df -h'
alias gs='git status'
alias vim='nvim'
alias buscar='fzf --preview "bat --color=always --style=numbers --line-range=:500 {}"'
alias nerdfetch='curl -fsSL https://raw.githubusercontent.com/ThatOneCalculator/NerdFetch/main/nerdfetch | sh'
alias python="python3"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

  
function extractPorts(){
  ports="$(cat $1 | grep -oP '\d{1,5}/open' | awk '{print $1}' FS='/' | xargs | tr ' ' ',')"
  ip_address="$(cat $1 | grep -oP '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' | sort -u | head -n 1)"
  echo -e "\n[*] Extracting information..\n" > extractPorts.tmp
  echo -e "\t[*] IP Address: $ip_address" >> extractPorts.tmp
  echo -e "\t[*] Open Ports: $ports\n" >> extractPorts.tmp
  echo $ports | tr -d '\n' | xclip -sel clip
  echo -e "[*] Ports copied to clipboard\n" >> extractPorts.tmp
  bat extractPorts.tmp
  rm extractPorts.tmp
}

function mkt(){
  mkdir {nmap,content,scripts}
}

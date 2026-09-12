eval "$(/opt/homebrew/bin/brew shellenv)"

setopt EXTENDED_GLOB AUTO_CD INTERACTIVE_COMMENTS

# EXTENDED_GLOB turns on zsh's extra pattern operators:
# ^ for negation, # for repetition, ~ for exclusion, and the glob qualifiers written (#q...).
#
# ls ^*.md          # everything except markdown
# ls **/*.java~*Test.java   # all java files except tests

# AUTO_CD lets a bare directory path act as cd.
#
# ~/work/gitlab/application     # same as cd ~/work/gitlab/application
# ..                            # up one

# INTERACTIVE_COMMENTS allows # comments on the interactive command line. Without it, zsh treats # as a literal argument and the command fails.
#
# mvn -pl core test   # smoke test after restore

# --- history ---------------------------------------------------------------
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt EXTENDED_HISTORY HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
alias history='fc -il 1'

# --- completion ------------------------------------------------------------
[ -d "$HOMEBREW_PREFIX/share/zsh-completions" ] && fpath=("$HOMEBREW_PREFIX/share/zsh-completions" $fpath)
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then compinit; else compinit -C; fi
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zmodload zsh/complist
bindkey -M menuselect '^[[Z' reverse-menu-complete
# sdk completion (was oh-my-zsh's sdk plugin); needs compdef, so it must come after compinit
[ -f "$HOME/.config/zsh/sdk-completion.zsh" ] && source "$HOME/.config/zsh/sdk-completion.zsh"

# --- keys ------------------------------------------------------------------
bindkey -e
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward
bindkey '^[[1;3D' backward-word
bindkey '^[[1;3C' forward-word
# Ctrl-X Ctrl-E: open the current command line in $EDITOR, save and quit to run it
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# --- prompt ----------------------------------------------------------------
if command -v starship >/dev/null; then
  eval "$(starship init zsh)"
else                                   # robbyrussell-ish fallback, no dependencies
  autoload -Uz vcs_info
  zstyle ':vcs_info:git:*' formats ' %F{cyan}git:(%f%F{red}%b%f%F{cyan})%f'
  precmd() { vcs_info }
  setopt PROMPT_SUBST
  PROMPT='%F{green}➜%f %F{cyan}%1~%f${vcs_info_msg_0_} '
fi

# --- plugins ---------------------------------------------------------------
[ -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] \
  && source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
command -v fzf    >/dev/null && source <(fzf --zsh)

# --- tools -----------------------------------------------------------------
export PATH="$HOME/.local/bin:$PATH"          # jdtls wrapper, uv, anything hand-installed

# node: put the nvm default version straight on PATH instead of sourcing nvm.sh (0.6s per tab).
export NVM_DIR="$HOME/.nvm"
_nvm_default="$NVM_DIR/versions/node/$(cat "$NVM_DIR/alias/default" 2>/dev/null)/bin"
[ -d "$_nvm_default" ] && export PATH="$_nvm_default:$PATH"
unset _nvm_default
nvm() { unset -f nvm; . "$NVM_DIR/nvm.sh"; nvm "$@"; }   # real nvm on first use


rgf() {
  local type_args=()
  local pattern="${2:-}"
  [[ -n "$1" ]] && type_args=(-t "$1")
  local result
  result=$(rg --line-number --no-heading "${type_args[@]}" "$pattern" | fzf \
    --delimiter=: \
    --preview "bat --color=always {1} --highlight-line {2}" \
    --preview-window "right:60%:wrap")
  [[ -n "$result" ]] && nvim +"$(echo "$result" | cut -d: -f2)" "$(echo "$result" | cut -d: -f1)"
}


bf() {
    local log; log=$(mktemp)
    betcore-functional "$@" 2>&1 | tee "$log"
    local rc=${PIPESTATUS[0]}
    printf '\n=== Failed  ===\n' "$log"
    sed -n '/Failed scenarios:/,/scenarios (/p' "$log" \
      | grep -oE '# file:///[^[:space:]]+\.feature:[0-9]+' \
      | sed 's/^# //'
    return $rc
}

. "$HOME/.local/bin/env"

# jdtls wrapper (per-session Eclipse workspaces) must shadow /opt/homebrew/bin/jdtls
export PATH="$HOME/.local/bin:$PATH"

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
# Docker CLI completions (Docker Desktop re-appends its own block at the end of this
# file on update; delete that and keep this line instead).
[ -d "$HOME/.docker/completions" ] && fpath=("$HOME/.docker/completions" $fpath)
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
export PATH="$HOME/.local/bin:$PATH"          # jdtls wrapper, anything hand-installed

# java/mvnd: put the current SDKMAN candidates on PATH instead of sourcing sdkman-init.sh (0.44s per tab).
export SDKMAN_DIR="$HOME/.sdkman"
export JAVA_HOME="$SDKMAN_DIR/candidates/java/current"
for _c in "$SDKMAN_DIR"/candidates/*/current/bin(N); do PATH="$_c:$PATH"; done
unset _c
export PATH
sdk() { unset -f sdk; . "$SDKMAN_DIR/bin/sdkman-init.sh"; sdk "$@"; }   # real sdk on first use

# node: put the nvm default version straight on PATH instead of sourcing nvm.sh (0.6s per tab).
export NVM_DIR="$HOME/.nvm"
if [ -r "$NVM_DIR/alias/default" ]; then                 # $(<file) is a zsh builtin read, no fork
  _nvm_v="$(<"$NVM_DIR/alias/default")"          # tolerate the alias being stored with or without the leading v
  _nvm_default="$NVM_DIR/versions/node/v${_nvm_v#v}/bin"
  [ -d "$_nvm_default" ] && export PATH="$_nvm_default:$PATH"
  unset _nvm_v _nvm_default
fi
nvm() {
  unset -f nvm
  . "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
  nvm "$@"
}

# --- work layer (~/.dotfiles-work) -----------------------------------------
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

# syntax highlighting must come last
[ -f "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] \
  && source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

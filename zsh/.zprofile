# The following lines were added by Docker Desktop to add commands to your PATH.
export PATH="$PATH:/Users/ddoko/.docker/bin"
# End of Docker Desktop section.

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Machine-local settings that must never be in git: tokens, per-machine overrides.
# The file is optional; nothing breaks when it is absent.
[ -f "$HOME/.profile.local" ] && source "$HOME/.profile.local"


export ZSH="$HOME/.oh-my-zsh"

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

export JAVA_HOME="$HOME/.sdkman/candidates/java/current/"

# Source local secrets and machine-specific settings
if [ -f $HOME/.profile.local ]; then
  source $HOME/.profile.local
fi

export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"


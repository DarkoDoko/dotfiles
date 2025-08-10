# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

export JAVA_HOME=".sdkman/candidates/java/current/"

export SDKMAN_DIR="/Users/ddoko/.sdkman"
[[ -s "/Users/ddoko/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/ddoko/.sdkman/bin/sdkman-init.sh"


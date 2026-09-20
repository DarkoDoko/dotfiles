# Brewfile — everything this repo's configs assume is installed.
#
#   brew bundle --file=~/dev/dotfiles/Brewfile
#
# Deliberately NOT covered here, because each has an ordering constraint or a
# version manager that Homebrew would fight with:
#   - JDKs and Gradle  -> SDKMAN  (see README, bootstrap step 6)
#   - Node             -> nvm     (see README, bootstrap step 6)
#   - JDK Mission Control -> manual download from Adoptium; no reliable cask
#
# `stow` and `bash` also appear in bootstrap step 1: they are needed before
# this file can be cloned and run. Listing them again here is harmless and
# keeps the declared set complete.

tap "felixkratz/formulae"
tap "nikitabobko/tap"

# --- dotfiles machinery ---
brew "stow"
brew "bash"                       # macOS ships 3.2; the SDKMAN installer needs 4+

# --- shell ---
brew "starship"
brew "zsh-autosuggestions"
brew "zsh-syntax-highlighting"
brew "fzf"
brew "ripgrep"                    # required by the rgf zsh function
brew "fd"                         # required by the ff zsh function
brew "bat"
brew "jq"

# --- git and editor ---
brew "git"
brew "gh"                         # also used by the per-machine SSH key setup
brew "git-delta"
brew "lazygit"
brew "neovim"
brew "tmux"

# --- JVM support tooling ---
# (JDKs themselves come from SDKMAN — see the header note.)

# --- Kafka ---
brew "kcat"                       # topic/message inspection

# --- window management / bar ---
brew "felixkratz/formulae/sketchybar"   # needs: brew services start felixkratz/formulae/sketchybar

# --- casks ---
cask "ghostty"
cask "docker-desktop"             # cask renamed from "docker"; the "docker" FORMULA is CLI-only
cask "nikitabobko/tap/aerospace"  # needs Accessibility permission on first launch
cask "font-hack-nerd-font"        # quarantine flag must be cleared — see README gotchas
cask "font-sketchybar-app-font"   # same

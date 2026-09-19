# My Dotfiles

Personal machine config, managed with [GNU Stow](https://www.gnu.org/software/stow/).
Each top-level directory is a "package" whose contents mirror `$HOME` — stowing
a package symlinks its files into place.

Packages: `aerospace`, `ghostty`, `git`, `nvim`, `sketchybar`, `ssh`, `starship`, `zsh`.

## Bootstrap on a new machine

```sh
# 1. Prerequisites (Xcode CLT + Homebrew)
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install stow

# 2. Clone
mkdir -p ~/dev && cd ~/dev
gh repo clone DarkoDoko/dotfiles   # or: git clone git@github.com:DarkoDoko/dotfiles.git

# 3. Back up anything that already exists and would conflict
#    (fresh installs typically pre-seed ~/.gitconfig or ~/.zprofile)
#    mv ~/.gitconfig ~/.gitconfig.bak   # etc., only if `stow -n` below reports a conflict

# 4. Stow everything (dry run first)
cd ~/dev/dotfiles
for pkg in */; do stow -n -v "${pkg%/}"; done   # review for conflicts
for pkg in */; do stow -v "${pkg%/}"; done      # apply

# 5. Install the apps/tools the configs assume are present
brew install neovim starship fzf zsh-autosuggestions zsh-syntax-highlighting
brew install --cask nikitabobko/tap/aerospace
brew install felixkratz/formulae/sketchybar
brew install --cask font-hack-nerd-font font-sketchybar-app-font

# Cask-installed fonts land with com.apple.quarantine set, which silently
# blocks macOS's font registry from activating them — SketchyBar's icon
# glyphs render as "?" until this is cleared (see gotcha below).
xattr -d com.apple.quarantine ~/Library/Fonts/HackNerdFont*.ttf ~/Library/Fonts/sketchybar-app-font.ttf

brew services start felixkratz/formulae/sketchybar
open -a AeroSpace   # first launch; grant Accessibility permission when macOS prompts

# 6. Language runtimes the zshrc has lazy-load wiring for (Java via SDKMAN,
#    Node via nvm). Both installers detect the existing SDKMAN_DIR/NVM_DIR
#    lines already in zsh/.zshrc and skip appending their own init block —
#    verify with `git -C ~/dev/dotfiles diff` after each, just in case.
brew install bash   # macOS ships Bash 3.2; SDKMAN's installer requires Bash 4+
export SDKMAN_AUTO_ANSWER=true
curl -s "https://get.sdkman.io" | /opt/homebrew/bin/bash
source ~/.sdkman/bin/sdkman-init.sh && sdk install java   # installs current default/recommended LTS

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.7/install.sh | /opt/homebrew/bin/bash
export NVM_DIR="$HOME/.nvm" && source "$NVM_DIR/nvm.sh"
nvm install --lts
nvm alias default "$(nvm current | sed 's/^v//')"   # see gotcha below — must NOT be left as "lts/*"
```

Where `stow <pkg>` without flags would normally target the *parent* of the repo
(wrong now that this lives at `~/dev/dotfiles` instead of `~/dotfiles`), the
`.stowrc` file in this repo pins `--target=~` so plain `stow`/`stow -D` always
resolve to `$HOME` regardless of where the repo is checked out.

## Decisions and why

- **Repo location: `~/dev/dotfiles`, not `~/dotfiles`.** Kept alongside other
  projects rather than cluttering `$HOME` directly. Handled via `.stowrc`
  (see above) so it doesn't matter where it's cloned as long as `.stowrc`
  ships with it.
- **Git identity:** `Darko Doko <darko.doko1@gmail.com>`, personal GitHub
  account `DarkoDoko`. The `includeIf "gitdir:~/work/"` block is a hook for a
  future work overlay (`~/.gitconfig-work`) — harmless no-op until that file
  exists.
- **Commit signing: SSH-based (`gpg.format = ssh`), not GPG.** Reuses the
  GitHub auth key instead of a separate GPG key/tooling. Signing key lives at
  `~/.ssh/id_ed25519_github.pub`; verification uses
  `~/.ssh/allowed_signers` (not tracked in this repo — machine-local,
  regenerated from the pubkey on each machine, see below).
- **SSH key naming:** `~/.ssh/id_ed25519_github` (plain `github.com` host),
  *not* the `id_ed25519_personal_github` / `github.com-personal` alias
  convention seen in `ssh/.ssh/add_config`. That file is a leftover from
  machines that juggled both a work and a personal GitHub identity via SSH
  config `Host` aliases + `Include`. This machine is personal-only, so it
  wasn't worth the extra indirection — `add_config` is stowed but currently
  unused. If a second identity is ever needed here, wire it in via
  `Include ~/.ssh/add_config` at the top of `~/.ssh/config` and rename the
  key to match.
- **`~/.ssh/config` itself is not tracked in this repo** — it's created
  per-machine (currently just a `Host github.com` block with
  `UseKeychain yes`). Machine-specific and holds no secrets, but keeping it
  untracked avoids merge friction between machines with different identity
  setups.
- **Companion apps aren't declared anywhere machine-readable** (no
  `Brewfile` yet) — the bootstrap commands above are the closest thing to
  one. Worth turning into an actual `Brewfile` if a third machine happens.

## Known gotchas

- **SketchyBar icons render as `?` after a fresh font install.** Fonts
  installed via `brew install --cask` (e.g. `font-hack-nerd-font`,
  `font-sketchybar-app-font`) land in `~/Library/Fonts` with
  `com.apple.quarantine` set. That flag silently stops macOS's font
  registry from activating them — the font *file* is there, but CoreText
  can't resolve the family name, so SketchyBar falls back to a font with no
  glyph for the icon codepoints. Symptom: `system_profiler SPFontsDataType`
  won't list the font at all, even though `ls ~/Library/Fonts` shows it.
  Fix: `xattr -d com.apple.quarantine <font files>`, then
  `brew services restart felixkratz/formulae/sketchybar`. If that alone
  doesn't clear it, log out/in (or reboot) — SIP blocks force-restarting the
  font daemon (`com.apple.FontWorker`) directly, so that's the only way to
  make CoreText fully re-scan.
- **`node`/`npm` not found in a fresh shell after `nvm install --lts`,
  even though `nvm current` shows the right version.** `nvm install --lts`
  sets `~/.nvm/alias/default` to the *symbolic* tag `lts/*`, not a literal
  version. The zshrc's PATH pre-seed (`for _c in ... alias/default ...`,
  see comment "put the nvm default version straight on PATH instead of
  sourcing nvm.sh") reads that file's contents directly and builds
  `$NVM_DIR/versions/node/v<contents>/bin` — which only exists for a literal
  version string, not `lts/*`. Fix: `nvm alias default <literal version>`
  (e.g. `nvm alias default 24.21.0`) after install, so the alias file holds
  a real version number. Same trap doesn't apply to SDKMAN — `sdk install`
  already points `candidates/java/current` at a real directory, not a
  symbolic tag.

## Per-machine setup (not tracked here)

These are recreated fresh on each machine, not stowed:

- `~/.ssh/id_ed25519_github{,.pub}` — generated via `ssh-keygen -t ed25519`,
  passphrase stored in macOS Keychain (`ssh-add --apple-use-keychain`), added
  to GitHub via `gh ssh-key add ... --type authentication` and
  `--type signing`.
- `~/.ssh/config` — `Host github.com` block pointing at the key above.
- `~/.ssh/allowed_signers` — one line:
  `<email> <contents of id_ed25519_github.pub>`.
- `~/.ssh/known_hosts` entry for `github.com` — verify against
  `gh api meta --jq '.ssh_keys[]'` before trusting, don't blindly accept.
- `~/.sdkman` and `~/.nvm` — installed per the "language runtimes" bootstrap
  step above. Python and Go are intentionally not set up yet (no version
  manager convention established for either in this repo).

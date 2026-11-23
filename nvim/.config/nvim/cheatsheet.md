# nvim cheat sheet                                  (q or Esc closes this popup)

Space = leader. `Space ?` opens this sheet. `:Cheatsheet` does the same.

## Built-in help (already there, no need to memorise this file)
Space, then wait      which-key popup: every key that can follow
Space s k             search ALL keymaps (type what you want to do)
Space s h             search the help pages
:Tutor                30 minute interactive tutorial

## Modes
i / a        insert before / after cursor        Esc     back to normal
I / A        insert at line start / end          v       select characters
o / O        new line below / above              V       select lines
:            command line                        C-v     select a block

## Save and quit
:w           save                    :q      close window
:wq          save and close          :q!     close, throw changes away
:qa          quit everything         u / C-r undo / redo

## Move
h j k l      left down up right      w / b       next / previous word
0 / $        line start / end        gg / G      file start / end
C-d / C-u    half page down / up     42G         go to line 42
%            matching bracket        C-o / C-i   jump back / forward
/text        search, n / N next / previous       Esc   clear the highlight
*            search the word under the cursor

## Edit (operator + motion: d = delete, c = change, y = copy)
dd / yy      delete / copy line      p / P       paste after / before
dw / cw      delete / change word    ciw         change the whole word
ci" / ci(    change inside quotes / brackets     .   repeat last edit
>> / <<      indent / unindent       gcc / gc    comment line / selection
x            delete character        J           join next line
Copy and paste use the macOS clipboard (y then Cmd+V elsewhere works).

## Surround (mini.surround)
saiw)        add ( ) around the word
sd'          delete the ' ' around the cursor
sr)'         replace ( ) with ' '

## Find things (Telescope)
Space s f        files by name           Space s g    grep in the project
Space Space      open buffers            Space s w    grep word under cursor
Space s .        recent files            Space /      fuzzy find in this file
Space s d        diagnostics             Space s r    reopen the last search
Space s n        nvim config files       Space s /    grep in open files
Inside a picker: C-n / C-p move, Enter open, C-v open in a split, Esc Esc close,
C-/ lists all picker keys.

## Code (needs a language server for the file type)
grd / grD    go to definition / declaration      C-t   jump back
grr          references              gri         implementations
grt          type definition         K           hover docs
grn          rename                  gra         code action
gO / gW      symbols in file / in workspace
Space f      format file             Space t h   toggle inlay hints
]d / [d      next / previous diagnostic          Space q   diagnostics list

## Completion (popup while typing)
C-n / C-p    next / previous item    C-y         accept
C-Space      open menu or docs       C-e         close menu
Tab / S-Tab  next / previous snippet field

## Windows and buffers
:vsplit / :split     split side by side / stacked
C-h C-j C-k C-l      move between windows
C-w q                close window            C-w =   make windows equal size
:bd                  close the buffer (file)

## Terminal inside nvim
:terminal    open a shell            Esc Esc     leave terminal typing mode

## Housekeeping
:Lazy        plugins (U updates)     :Mason      language servers and tools
:checkhealth diagnose the setup      :help X     help for X

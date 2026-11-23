-- Cheat sheet popup: <leader>? or :Cheatsheet. The nvim twin of tmux `prefix h`.
-- Content lives in cheatsheet.md at the root of this config; edit that file.

local function open()
  local path = vim.api.nvim_get_runtime_file('cheatsheet.md', false)[1]
  if not path then
    vim.notify('cheatsheet.md not found on the runtimepath', vim.log.levels.WARN)
    return
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.fn.readfile(path))
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = 'wipe'
  vim.bo[buf].filetype = 'markdown'

  local width = math.min(90, vim.o.columns - 4)
  local height = math.floor((vim.o.lines - 2) * 0.9)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2) - 1,
    style = 'minimal',
    border = 'rounded',
    title = ' cheat sheet ',
    title_pos = 'center',
  })
  vim.wo[win].wrap = false
  vim.wo[win].conceallevel = 0

  for _, key in ipairs { 'q', '<Esc>' } do
    vim.keymap.set('n', key, '<cmd>close<CR>', { buffer = buf, nowait = true, desc = 'Close cheat sheet' })
  end
end

vim.keymap.set('n', '<leader>?', open, { desc = 'Cheat sheet' })
vim.api.nvim_create_user_command('Cheatsheet', open, { desc = 'Open the cheat sheet' })

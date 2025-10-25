local frontmatter = require('obsidian-helpers.frontmatter')
local note_creation = require('obsidian-helpers.note-creation')

-- Auto-add frontmatter to new notes created via ObsidianSearch or daily notes
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*/obsidian-2025/*.md",
    callback = function()
        vim.defer_fn(function()
            if not frontmatter.has_frontmatter() then
                local title = frontmatter.extract_title_from_buffer()
                local content = frontmatter.generate_template(title)
                local lines = vim.split(content, "\n")

                if lines[#lines] == "" then
                    table.remove(lines)
                end

                vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
                vim.api.nvim_win_set_cursor(0, {9, #lines[9]})
                vim.cmd('write')
            end
        end, 50)
    end,
})

-- Override ObsidianNew command to use timestamp ID
vim.api.nvim_create_user_command('ObsidianNew', function(opts)
    local title = opts.args
    if not title or title == "" then
        vim.ui.input({ prompt = 'Note title: ' }, function(input_title)
            if input_title and input_title ~= "" then
                title = input_title
            else
                return
            end
        end)
        if not title then return end
    end
    note_creation.create_note_with_frontmatter(title)
end, { nargs = '?', desc = 'Create new note with timestamp ID', force = true })

-- Obsidian keybindings
vim.keymap.set('n', '<leader>os', ':ObsidianSearch<CR>', { desc = 'Search notes' })
vim.keymap.set('n', '<leader>od', ':ObsidianToday<CR>', { desc = "Today's daily note" })
vim.keymap.set('n', '<leader>ot', ':ObsidianTomorrow<CR>', { desc = "Tomorrow's note" })
vim.keymap.set('n', '<leader>oy', ':ObsidianYesterday<CR>', { desc = "Yesterday's note" })
vim.keymap.set('n', '<leader>ob', ':ObsidianBacklinks<CR>', { desc = 'Show backlinks' })

vim.keymap.set('n', '<leader>on', function()
    vim.ui.input({ prompt = 'Note title: ' }, function(input_title)
        if input_title and input_title ~= '' then
            note_creation.create_note_with_frontmatter(input_title)
        end
    end)
end, { desc = 'New Zettelkasten note' })

vim.keymap.set('n', '<leader>oh', function()
    vim.ui.input({ prompt = 'Note title: ' }, function(input_title)
        if input_title and input_title ~= '' then
            note_creation.create_note_with_frontmatter(input_title)
        end
    end)
end, { desc = 'Quick new note (timestamp ID)' })

vim.keymap.set('n', 'gf', function()
    if require('obsidian').util.cursor_on_markdown_link() then
        return '<cmd>ObsidianFollowLink<CR>'
    else
        return 'gf'
    end
end, { noremap = false, expr = true, desc = 'Follow link or use default gf' })

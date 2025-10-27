-- Obsidian.nvim configuration
require("obsidian").setup({
    workspaces = {
        {
            name = "personal",
            path = "~/obsidian-2025",
        }
    },

    -- Disable obsidian.nvim's frontmatter management (we handle it ourselves)
    disable_frontmatter = true,

    -- Daily notes configuration
    daily_notes = {
        folder = "",
        date_format = "%Y-%m-%d",
        alias_format = "%B %d, %Y",
    },

    -- Templates configuration
    templates = {
        folder = "_ignore/Templates",
    },

    -- Where to create new notes
    new_notes_location = "notes_subdir",
    notes_subdir = "",

    -- Note ID and path configuration
    note_id_func = function(title)
        -- Always use timestamp ID with seconds (YYYYMMDDHHmmss)
        return tostring(os.date("%Y%m%d%H%M%S"))
    end,

    note_path_func = function(spec)
        -- Save to the configured directory (vault root via notes_subdir = "")
        local path = spec.dir / tostring(spec.id)
        return path:with_suffix(".md")
    end,

    -- Completion configuration
    completion = {
        nvim_cmp = true,
        min_chars = 2,
    },

    -- UI configuration
    ui = {
        enable = true,
        checkboxes = {
            [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
            ["x"] = { char = "", hl_group = "ObsidianDone" },
        },
    },

    -- Attachments configuration
    attachments = {
        img_folder = "_ignore/Attachments",
    },

    -- Follow links with gf
    follow_url_func = function(url)
        vim.fn.jobstart({"xdg-open", url})
    end,

    -- Picker configuration - change keybinding for new note to Ctrl-s
    picker = {
        name = "telescope.nvim",
        note_mappings = {
            new = "<C-s>",
            insert_link = "<C-l>",
        },
        mappings = {
            new = "<C-s>",
            insert_link = "<C-l>",
        },
    },
})

if vim.g.neovide then
  vim.api.nvim_set_keymap(
    "n",
    "<C-+>",
    ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>",
    { silent = true }
  )
  vim.api.nvim_set_keymap(
    "n",
    "<C-_>",
    ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>",
    { silent = true }
  )
  vim.api.nvim_set_keymap("n", "<C-0>", ":lua vim.g.neovide_scale_factor = 1<CR>", { silent = true })

  -- vim.g.neovide_cursor_vfx_mode = "sonicboom"
  -- vim.g.neovide_cursor_vfx_mode = "ripple"
  vim.g.neovide_cursor_vfx_mode = "pixiedust"
  vim.g.neovide_scroll_animation_length = 0.1
  vim.g.neovide_cursor_trail_size = 0.3
  vim.g.neovide_cursor_animation_length = 0.25

  -- vim.cmd 'set guifont=Hack\ NF:h10'
  -- vim.o.guifont='Consolas:h10'
  -- vim.o.guifont='FiraCode NF:h14'
  vim.o.guifont = "FiraCode Nerd Font Mono:h14"
  vim.g.neovide_fullscreen = false
  vim.keymap.set(
    "n",
    "<F11>",
    function() vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen end,
    { silent = true, desc = "Toggle fullscreen" }
  )
end

if vim.fn.exists "g:os" == 0 then
  local is_windows = vim.fn.has "win64" == 1 or vim.fn.has "win32" == 1 or vim.fn.has "win16" == 1
  if is_windows then
    vim.g.os = "Windows"
  else
    local uname_output = vim.fn.system "uname"
    vim.g.os = string.gsub(uname_output, "\n", "")
  end
end

if vim.g.os == "Windows" then
  vim.opt.shell = "powershell.exe"
  vim.opt.shellcmdflag = "-NoLogo -NoProfile -NonInteractive -ExecutionPolicy RemoteSigned -Command"
  vim.opt.shellquote = '\\"'
  vim.opt.shellxquote = ""
  vim.opt.shellpipe = "|"
  vim.opt.shellredir = "| Out-Host"
  -- vim.g.loaded_man = 1
end

vim.api.nvim_create_user_command("TypstPin", function()
  local tinymist_id = nil
  for _, client in pairs(vim.lsp.get_clients()) do
    if client.name == "tinymist" then
      tinymist_id = client.id
      break
    end
  end

  if not tinymist_id then
    vim.notify("tinymist not running!", vim.log.levels.ERROR)
    return
  end

  local client = vim.lsp.get_client_by_id(tinymist_id)
  if client then
    client.request("workspace/executeCommand", {
      command = "tinymist.pinMain",
      arguments = { vim.api.nvim_buf_get_name(0) },
    }, function(err)
      if err then
        vim.notify("error pinning: " .. err, vim.log.levels.ERROR)
      else
        vim.notify("succesfully pinned", vim.log.levels.INFO)
      end
    end, 0)
  end
end, {})

---@type LazySpec
return {
  {
    "chomosuke/typst-preview.nvim",
    -- the pack points at a `tinymist` on PATH, which vim.uv.spawn can't run on Windows (only a .cmd shim exists);
    -- unset it so the plugin uses the tinymist.exe it downloads itself
    opts = function(_, opts) opts.dependencies_bin.tinymist = nil end,
  },
  {
    "goolord/alpha-nvim",
    opts = function(_, opts)
      vim.api.nvim_set_hl(0, "NeovimDashboardLogo1", { fg = "#DA4939" })
      vim.api.nvim_set_hl(0, "NeovimDashboardLogo2", { fg = "#FF875F" })
      vim.api.nvim_set_hl(0, "NeovimDashboardLogo3", { fg = "#FFC66D" })
      vim.api.nvim_set_hl(0, "NeovimDashboardLogo4", { fg = "#00FF03" })
      vim.api.nvim_set_hl(0, "NeovimDashboardLogo5", { fg = "#00AFFF" })
      vim.api.nvim_set_hl(0, "NeovimDashboardLogo6", { fg = "#8800FF" })

      opts.section.header.type = "group"
      opts.section.header.val = {
        {
          type = "text",
          val = "   ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
          opts = { hl = "NeovimDashboardLogo1", shrink_margin = false, position = "center" },
        },
        {
          type = "text",
          val = "   ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
          opts = { hl = "NeovimDashboardLogo2", shrink_margin = false, position = "center" },
        },
        {
          type = "text",
          val = "   ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
          opts = { hl = "NeovimDashboardLogo3", shrink_margin = false, position = "center" },
        },
        {
          type = "text",
          val = "   ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
          opts = { hl = "NeovimDashboardLogo4", shrink_margin = false, position = "center" },
        },
        {
          type = "text",
          val = "   ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
          opts = { hl = "NeovimDashboardLogo5", shrink_margin = false, position = "center" },
        },
        {
          type = "text",
          val = "   ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
          opts = { hl = "NeovimDashboardLogo6", shrink_margin = false, position = "center" },
        },
      }
      return opts
    end,
  },

  {
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.luasnip" (plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom luasnip configuration such as filetype extend or custom snippets
      local luasnip = require "luasnip"
      luasnip.filetype_extend("javascript", { "javascriptreact" })
    end,
  },

  {
    "windwp/nvim-autopairs",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.nvim-autopairs" (plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom autopairs configuration such as custom rules
      local npairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"
      npairs.add_rules(
        {
          Rule("$", "$", { "tex", "latex" })
          -- don't add a pair if the next character is %
              :with_pair(cond.not_after_regex "%%")
          -- don't add a pair if  the previous character is xxx
              :with_pair(
                cond.not_before_regex("xxx", 3)
              )
          -- don't move right when repeat character
              :with_move(cond.none())
          -- don't delete if the next character is xx
              :with_del(cond.not_after_regex "xx")
          -- disable adding a newline when you press <cr>
              :with_del(cond.not_after_regex "xx")
          -- disable adding a newline when you press <cr>
              :with_cr(cond.none()),
        },
        -- disable for .vim files, but it work for another filetypes
        Rule("a", "a", "-vim")
      )
    end,
  },

  {
    "2kabhishek/co-author.nvim",
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-telescope/telescope.nvim",
    },
    cmd = { "CoAuthor" },
  },

  {
    "ranjithshegde/ccls.nvim",
    lazy = false,
  },

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    -- npm rewrites the tracked app/yarn.lock, which makes lazy refuse to update; restore it
    build = "cd app && npm install && git checkout -- yarn.lock",
    init = function()
      -- mkdp_markdown_css replaces the default markdown.css, so append our override to a copy of it.
      -- The 900px cap lives on #page-ctn in page.css; widen it here (value is configurable).
      local width = "95%"
      local default_css = vim.fn.stdpath "data" .. "/lazy/markdown-preview.nvim/app/_static/markdown.css"
      local out = vim.fn.stdpath "cache" .. "/mkdp-wide.css"
      if vim.fn.filereadable(default_css) == 1 then
        local lines = vim.fn.readfile(default_css)
        table.insert(lines, "#page-ctn { max-width: " .. width .. " !important; }")
        vim.fn.writefile(lines, out)
        vim.g.mkdp_markdown_css = out
      end
    end,
  },

  {
    "hat0uma/csvview.nvim",
    ---@module "csvview"
    ---@type CsvView.Options
    opts = {
      parser = {
        comments = { "#", "//" },
        -- The default maps ft=csv to "," which overrides auto-detection; drop it so ";" files work.
        -- A user-provided `ft` table replaces the default one instead of merging.
        delimiter = { ft = { tsv = "\t" } },
      },
      keymaps = {
        -- Text objects for selecting fields
        textobject_field_inner = { "if", mode = { "o", "x" } },
        textobject_field_outer = { "af", mode = { "o", "x" } },
        -- Excel-like navigation (<S-Tab>/<S-Enter> may need CSI-u mode in the terminal)
        jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
        jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
        jump_next_row = { "<Enter>", mode = { "n", "v" } },
        jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
      },
    },
    cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
  },

  {
    "akinsho/toggleterm.nvim",
    opts = function(_, opts)
      opts.direction = "float"
      return opts
    end,
  },
}

return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },

  config = function()
    local harpoon = require("harpoon")

    harpoon:setup()

    local wk = require("which-key")
    -- register harpoon list append to leader a
    wk.register({
      ["<leader>"] = {
        a = {
          function()
            harpoon:list():append()
          end,
          "Append to Harpoon list",
        },
      },
    })

    vim.keymap.set("n", "<C-A-M>", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end)

    vim.keymap.set("n", "<C-A-Q>", function()
      harpoon:list():select(1)
    end)
    vim.keymap.set("n", "<C-A-W>", function()
      harpoon:list():select(2)
    end)
    vim.keymap.set("n", "<C-A-E>", function()
      harpoon:list():select(3)
    end)
    vim.keymap.set("n", "<C-A-R>", function()
      harpoon:list():select(4)
    end)

    vim.keymap.set("n", "<C-A-P>", function()
      harpoon:list():prev()
    end)
    vim.keymap.set("n", "<C-A-N>", function()
      harpoon:list():next()
    end)

    -- basic telescope configuration
    local conf = require("telescope.config").values
    local function toggle_telescope(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end

      require("telescope.pickers")
        .new({}, {
          prompt_title = "Harpoon",
          finder = require("telescope.finders").new_table({
            results = file_paths,
          }),
          previewer = conf.file_previewer({}),
          sorter = conf.generic_sorter({}),
        })
        :find()
    end

    vim.keymap.set("n", "<C-A-T>", function()
      toggle_telescope(harpoon:list())
    end, {
      desc = "Open harpoon window",
    })
  end,
}

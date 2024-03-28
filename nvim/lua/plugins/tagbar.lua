return {
  "preservim/tagbar",

  config = function()
    local wk = require("which-key")
    wk.register({
      ["<leader>"] = {
        c = {
          t = {
            function()
              vim.cmd("TagbarToggle")
            end,
            "Toggle Tagbar",
          },
        },
      },
    })
  end,
}

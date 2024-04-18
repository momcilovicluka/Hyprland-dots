return {
    {
        "hrsh7th/nvim-cmp",
        opts = function(_, opts)
            local cmp = require("cmp")
            opts.mapping = vim.tbl_deep_extend("force", opts.mapping, {
                ["<CR>"] = cmp.mapping(function(fallback)
                    cmp.close()
                    fallback()
                end, { "i" }),
                ["<Down>"] = cmp.mapping(function(fallback)
                    cmp.close()
                    fallback()
                end, { "i" }),
                ["<Up>"] = cmp.mapping(function(fallback)
                    cmp.close()
                    fallback()
                end, { "i" }),
            })
            -- opts.preselect = cmp.PreselectMode.None
            --opts.completion = {
            --   completeopt = "menu,menuone,noinsert,noselect",
            --}
        end,
    },
}

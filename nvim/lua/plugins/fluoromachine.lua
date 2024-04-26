return {
    "maxmx03/fluoromachine.nvim",
    config = function()
        local fm = require("fluoromachine")

        fm.setup({
            glow = true,
            brightness = 0.05,
            theme = "fluoromachine", --fluoromachine, retrowave, delta
            transparent = true,
        })
    end,
}

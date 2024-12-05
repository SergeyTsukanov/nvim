return {
	"supermaven-inc/supermaven-nvim",
	config = function()
		require("supermaven-nvim").setup({
			color = {
				suggestion_color = "#a7fcc9",
				cterm = 244,
			},
			disable_inline_completion = true,
		})
	end,
}

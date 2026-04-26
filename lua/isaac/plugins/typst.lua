return {
	{
		"chomosuke/typst-preview.nvim",
		ft = "typst",
		version = "1.*",
		opts = {
			-- open_cmd = "firefox %s -P typst-preview --class typst-preview",
			-- open_cmd = "open -a Safari %s",
			open_cmd = "open -a firefox %s",
			port = "7777",
			dependencies_bin = {
				["tinymist"] = "/Users/isaacleong/.local/bin/tinymist",
				["websocat"] = nil,
			},
		},
	},
}

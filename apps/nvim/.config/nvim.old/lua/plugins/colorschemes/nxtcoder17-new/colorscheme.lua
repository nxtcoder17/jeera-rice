local colors_name = "nxtcoder17"
vim.g.colors_name = colors_name -- Required when defining a colorscheme

local lush = require("lush")
local hsluv = lush.hsluv -- Human-friendly hsl
local util = require("zenbones.util")

local bg = vim.o.background

local colors = require("nxtcoder17.colors")

-- Define a palette. Use `palette_extend` to fill unspecified colors
-- Based on https://github.com/gruvbox-community/gruvbox#palette
local palette_colors = {
	["light"] = {
		-- bg = hsluv("#ffffff"),
		bg = hsluv(39, 12, 94), -- sand
		fg = hsluv(230, 30, 22), -- stone

		-- fg = hsluv(colors.gel_pen_variants["blue-black"]),
	},
	["dark"] = {},
}

local palette = util.palette_extend(palette_colors[bg], bg)

-- Generate the lush specs using the generator util
local generator = require("zenbones.specs")
local base_specs = generator.generate(palette, bg, generator.get_global_config(colors_name, bg))

-- Optionally extend specs using Lush
local specs = lush.extends({ base_specs }).with(function()
	return {
		Statement({ base_specs.Statement, fg = palette.rose }),
		Special({ fg = palette.water }),
		Type({ fg = palette.sky, gui = "italic" }),
	}
end)

-- Pass the specs to lush to apply
lush(specs)

-- Optionally set term colors
require("zenbones.term").apply_colors(palette)

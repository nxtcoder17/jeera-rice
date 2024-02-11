local wezterm = require("wezterm")

local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- config.font = wezterm.font_with_fallback({
--   -- {
--   --   family = "Monaspace Radon",
--   --   weight = "Light",
--   --   -- stretch = "Normal",
--   --   -- style = "Normal",
--   --   harfbuzz_features = { "ss01", "ss02", "ss03", "ss04", "ss05", "ss06", "ss07", "ss08", "calt", "dlig" },
--   -- },
-- })

config.font = wezterm.font_with_fallback({
  { family = "Comic Code Ligatures", weight = "DemiBold", stretch = "Normal", style = "Normal" },
  -- { family = "OperatorMono Nerd Font", weight = "Book",     stretch = "Normal", style = "Normal" },
  { family = "Fira",                 weight = "Book",     stretch = "Normal", style = "Normal" },
  { family = "Operator Mono Lig",    weight = "Book",     stretch = "Normal", style = "Normal" },
  -- { family = "FiraCode Nerd Font Mono", weight = "Regular",     stretch = "Normal", style = "Normal" },
  -- { family = "ComicCodeLigatures Nerd Font", weight = "Medium",   stretch = "Normal", style = "Normal" },
  -- { family = "Operator Mono Lig",            weight = "Book",     stretch = "Normal", style = "Normal" },
})

config.font_size = 10
config.cell_width = 1
config.line_height = 1.0

config.font_rules = {
  {
    italic = true,
    -- font = wezterm.font("Operator Mono Lig", { italic = true, weight = "Medium" }),
    font = wezterm.font("Monaspace Radon", { italic = false, weight = "Medium" }),
  },
  {
    italic = true,
    intensity = "Bold",
    font = wezterm.font("Monaspace Radon", {
      italic = true,
      weight = "Bold",
    }),
  },
}

config.default_prog = { "fish", "-l" }

-- For example, changing the color scheme:
config.color_scheme = "nightfox"
-- config.color_scheme = "Kanagawa (Gogh)"
-- config.color_scheme = "Tokyo Night Moon"
-- and finally, return the configuration to wezterm

config.hide_tab_bar_if_only_one_tab = true
config.text_background_opacity = 0.9

-- config.window_background_image = "/var/home/nxtcoder17/me/jeera-rice/wallpapers/dark-notebook.jpg"
-- config.window_background_image = "/var/home/nxtcoder17/Downloads/notebook_background_with_black_overlay.png"
-- config.window_background_image = "/var/home/nxtcoder17/Downloads/notebook_background_final_3840x2160.png"
config.window_background_image = "/var/home/nxtcoder17/me/jeera-rice/wallpapers/night-fog.jpg"
config.window_background_image_hsb = {
  -- Darken the background image by reducing it to 1/3rd
  brightness = 0.7,

  -- You can adjust the hue by scaling its value.
  -- a multiplier of 1.0 leaves the value unchanged.
  hue = 1.0,

  -- You can adjust the saturation also.
  saturation = 1.0,
}

config.window_padding = {
  left = 2,
  right = 2,
  top = 17,
  bottom = 0,
}

return config

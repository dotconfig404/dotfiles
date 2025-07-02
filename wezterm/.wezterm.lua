-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

config.font_size = 13
config.color_scheme = 'Mar (Gogh)'
config.enable_scroll_bar = true


-- Finally, return the configuration to wezterm:
return config


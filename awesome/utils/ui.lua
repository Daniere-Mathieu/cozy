
-- █░█ █    █░█ ▀█▀ █ █░░ █▀ 
-- █▄█ █    █▄█ ░█░ █ █▄▄ ▄█ 

local wibox = require("wibox")
local gshape = require("gears.shape")
local beautiful = require("beautiful")
local xresources  = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local _ui = {}

--- For people with different screen resolutions, I hope this might be a solution.
-- There will be a config option one day and this will return dpi * scalar.
function _ui.dpi(px)
  return dpi(px)
end

function _ui.colorize(text, color)
  color = color or "#FF000000"
  return "<span foreground='" .. color .. "'>" .. text .. "</span>"
end

--- Create textbox with my preferred defaults.
function _ui.textbox(args)
  return wibox.widget({
    markup = args.markup or _ui.colorize(args.text or "Default text", args.color or beautiful.fg_0),
    valign = args.valign or "center",
    align  = args.align  or "center",
    font   = args.font   or beautiful.font_reg_s,
    widget = wibox.widget.textbox,
  })
end

--- Horizontal padding.
function _ui.hpad(width)
	return wibox.widget({
		forced_width = width,
		layout = wibox.layout.fixed.horizontal,
	})
end

--- Vertical padding.
function _ui.vpad(height)
	return wibox.widget({
		forced_height = height,
		layout = wibox.layout.fixed.vertical,
	})
end

function _ui.place(content, args)
  args = args or {}
  return wibox.widget({
    {
      content,
      widget = wibox.container.place,
    },
    widget  = wibox.container.margin,
    margins = args.margins or dpi(5)
  })
end

--- Create rounded rectangle.
function _ui.rrect(radius)
  radius = radius or beautiful.ui_border_radius
	return function(cr, width, height)
		gshape.rounded_rect(cr, width, height, radius)
	end
end

--- (Dashboard) Put a box around a widget.
function _ui.dashbox(content, width, height, bg)
	return wibox.widget({
		{
			{
				content,
        margins = dpi(15),
				widget  = wibox.container.margin,
			},
      forced_height = height or nil,
      forced_width  = width or nil,
      bg     = bg,
      shape  = gshape.rounded_rect,
			widget = wibox.container.background,
		},
		margins = dpi(10),
		color   = "#FF000000",
		widget  = wibox.container.margin,
	})
end

return _ui

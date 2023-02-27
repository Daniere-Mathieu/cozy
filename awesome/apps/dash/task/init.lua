
-- ▀█▀ ▄▀█ █▀ █▄▀ █░█░█ ▄▀█ █▀█ █▀█ █ █▀█ █▀█ 
-- ░█░ █▀█ ▄█ █░█ ▀▄▀▄▀ █▀█ █▀▄ █▀▄ █ █▄█ █▀▄ 

-- Frontend for Taskwarrior.

local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local task = require("core.system.task")
local keynav = require("modules.keynav")
local ui = require("helpers.ui")

local tag_list, nav_tags = require(... .. ".tags")()
local projects, nav_projects = require(... .. ".projects")()
local tasklist, nav_tasklist = require(... .. ".tasklist")()
local header = require(... .. ".header")
local prompt = require(... .. ".prompt")
local details = require(... .. ".details")

local nav_tasks = keynav.area({
  name = "tasks",
  children = {
    nav_tags,
    nav_projects,
    nav_tasklist,
  },
  keys = {
    ["z"] = function() task:emit_signal("details::toggle") end,
    ["W"] = function() task:emit_signal("toggle_show_waiting") end,
  },
})

task:connect_signal("tasklist::switch_index", function(_, index)
  nav_tasklist:set_curr_item(index)
  nav_tasks.nav:set_area("tasklist")
end)

----------

local sidebar = wibox.widget({
  {
    markup = ui.colorize("Taskwarrior", beautiful.fg_0),
    font   = beautiful.font_med_l,
    align  = "center",
    valign = "center",
    widget = wibox.widget.textbox,
  },
  tag_list,
  projects,
  inner_fill_strategy = "justify",
  forced_height = dpi(1000),
  forced_width = dpi(310),
  layout       = wibox.layout.ratio.vertical,
})
sidebar:adjust_ratio(2, 0.1, 0.47, 0.43)

local main_contents = wibox.widget({
  {
    {
      header,
      ui.vpad(dpi(15)),
      tasklist,
      layout = wibox.layout.fixed.vertical,
    },
    top     = dpi(15),
    bottom  = dpi(20),
    left    = dpi(25),
    right   = dpi(25),
    widget  = wibox.container.margin,
  },
  forced_width = dpi(1000),
  bg     = beautiful.dash_widget_bg,
  shape  = gears.shape.rounded_rect,
  widget = wibox.container.background,
})

local tasks_dashboard = wibox.widget({
  {
    { -- Needs its own layout box to prevent some weird layout issues
      sidebar,
      layout = wibox.layout.fixed.vertical,
    },
    {
      main_contents,
      details,
      prompt,
      layout = wibox.layout.fixed.vertical,
    },
    spacing = dpi(10),
    layout  = wibox.layout.fixed.horizontal,
  },
  top    = dpi(10),
  right  = dpi(10),
  widget = wibox.container.margin,
})

return function()
  return tasks_dashboard, nav_tasks
end


-- █▀▄ ▄▀█ █▀ █░█ ▀    ▄▀█ █▀▀ █▀▀ █▄░█ █▀▄ ▄▀█ 
-- █▄▀ █▀█ ▄█ █▀█ ▄    █▀█ █▄█ ██▄ █░▀█ █▄▀ █▀█ 

local wibox = require("wibox")
local xresources = require("beautiful.xresources")
local dpi   = xresources.apply_dpi
local area  = require("modules.keynav.area")
local dash  = require("core.cozy.dash")

local header, nav_viewselect = require(... .. ".header")()
local weekview, nav_weekview = require(... .. ".weekview")()
local overview, nav_overview = require(... .. ".overview")()

local OVERVIEW = 1
local WEEKVIEW = 2
local tab_content = { overview, weekview }
local tab_nav     = { nav_overview, nav_weekview }
local tab_names   = { "nav_overview", "nav_weekview" }
local current_tab = "overview"

local main_contents = wibox.widget({
  {
    header,
    overview,
    spacing = dpi(12),
    layout = wibox.layout.fixed.vertical,
  },
  widget = wibox.container.place,
  -------
  set_tab = function(self, tab_idx)
    self.children[1]:remove(2)
    self.children[1]:add(tab_content[tab_idx])
  end
})

local nav_agenda = area({
  name = "nav_agenda",
  children = {
    nav_viewselect,
    nav_overview,
  },
})

local function set_nav(tab_idx)
  nav_agenda:remove_item(nav_agenda.items[2])
  nav_agenda:append(tab_nav[tab_idx])
end

dash:connect_signal("agenda::view_selected", function(_, view)
  if view == current_tab then return end
  current_tab = view
  if view == "overview" then
    main_contents:set_tab(OVERVIEW)
    set_nav(OVERVIEW)
  else
    main_contents:set_tab(WEEKVIEW)
    set_nav(WEEKVIEW)
  end
end)

return function()
  return main_contents, nav_agenda
end

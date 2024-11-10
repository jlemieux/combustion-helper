local addonName, ns = ...;

function ns.events.registerEvents()
  ns.AceConsole.Print(ns.CHC, 'events.lua - registerEvents...')
  ns.CHC:RegisterEvent("ZONE_CHANGED")
  ns.AceConsole.Print(ns.CHC, 'events.lua - registerEvents finished!')
end

function ns.CHC:ZONE_CHANGED()
  local msg = ns.db.profile.message
  if ns.db.profile.showOnScreen then
    UIErrorsFrame:AddMessage(msg, 1, 1, 1)
  end
  ns.AceConsole.Print(ns.CHC, msg)
end

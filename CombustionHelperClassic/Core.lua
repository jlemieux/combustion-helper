local addonName, ns = ...;

function ns.CHC:OnInitialize()
  ns.AceConsole.Print(ns.CHC, 'Core.lua - Addon initialized!')
end

function ns.CHC:OnEnable()
  ns.AceConsole.Print(ns.CHC, 'Core.lua - Addon enabled!')
  ns.config.initConfig()
  ns.events.registerEvents()
  ns.ui.initUI()
end

function ns.CHC:OnDisable()
  ns.AceConsole.Print(ns.CHC, 'Core.lua - Addon disabled!')
end

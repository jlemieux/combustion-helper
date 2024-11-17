local addonName, ns = ...;

function ns.CHC:OnInitialize()
  ns.AceConsole.Print(ns.CHC, 'core.lua - Addon initialized!')
end

function ns.CHC:OnEnable()
  ns.AceConsole.Print(ns.CHC, 'core.lua - Addon enabled!')
  ns.config.initConfig()
  ns.events.registerEvents()
  ns.ui.initUI()

  -- ns.tests.runTests()
end

function ns.CHC:OnDisable()
  ns.AceConsole.Print(ns.CHC, 'core.lua - Addon disabled!')
end

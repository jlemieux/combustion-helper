local addonName, ns = ...;

ns.CombustionHelperClassic = LibStub("AceAddon-3.0"):NewAddon(addonName, "AceEvent-3.0")
ns.CHC = ns.CombustionHelperClassic

function ns.CHC:OnInitialize()
  ns.initConfig()
end

function ns.CHC:OnEnable()
	self:RegisterEvent("ZONE_CHANGED")
end

function ns.CHC:ZONE_CHANGED()
  local msg = ns.db.profile.message
  if ns.db.profile.showOnScreen then
    UIErrorsFrame:AddMessage(msg, 1, 1, 1)
  end
  ns.AceConsole.Print(ns.CHC, msg)
end

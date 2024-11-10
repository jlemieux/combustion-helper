local addonName, ns = ...;

ns.AceConfig = LibStub("AceConfig-3.0")
ns.AceConfigDialog = LibStub("AceConfigDialog-3.0")
ns.AceConsole = LibStub("AceConsole-3.0")
ns.AceGUI = LibStub("AceGUI-3.0")

ns.CombustionHelperClassic = LibStub("AceAddon-3.0"):NewAddon(addonName, "AceEvent-3.0")
ns.CHC = ns.CombustionHelperClassic

ns.config = {}
ns.events = {}
ns.ui = {}

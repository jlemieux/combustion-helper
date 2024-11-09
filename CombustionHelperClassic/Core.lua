CombustionHelperClassic = LibStub("AceAddon-3.0"):NewAddon("CombustionHelperClassic", "AceConsole-3.0", "AceEvent-3.0")
local AC = LibStub("AceConfig-3.0")
local ACD = LibStub("AceConfigDialog-3.0")

local defaults = {
	profile = {
		message = "Welcome Home!",
		showOnScreen = true,
	},
}

local options = {
	name = "CombustionHelperClassic",
	handler = CombustionHelperClassic,
	type = "group",
	args = {
		msg = {
			type = "input",
			name = "Message",
			desc = "The message to be displayed when you get home.",
			usage = "<Your message>",
			get = "GetMessage",
			set = "SetMessage",
		},
		showOnScreen = {
			type = "toggle",
			name = "Show on Screen",
			desc = "Toggles the display of the message on the screen.",
			get = "IsShowOnScreen",
			set = "ToggleShowOnScreen"
		},
	},
}

function CombustionHelperClassic:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("CombustionHelperClassicDB", defaults, true)
	AC:RegisterOptionsTable("CombustionHelperClassic_options", options)
	self.optionsFrame = ACD:AddToBlizOptions("CombustionHelperClassic_options", "CombustionHelperClassic")

	local profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	AC:RegisterOptionsTable("CombustionHelperClassic_Profiles", profiles)
	ACD:AddToBlizOptions("CombustionHelperClassic_Profiles", "Profiles", "CombustionHelperClassic")

	self:RegisterChatCommand("chc", "SlashCommand")
	self:RegisterChatCommand("CombustionHelperClassic", "SlashCommand")
end

function CombustionHelperClassic:OnEnable()
	self:RegisterEvent("ZONE_CHANGED")
end

function CombustionHelperClassic:ZONE_CHANGED()
  -- UIErrorsFrame:AddMessage(self.db.profile.message, 1, 1, 1)
	-- if GetBindLocation() == GetSubZoneText() then
  if self.db.profile.showOnScreen then
    UIErrorsFrame:AddMessage(self.db.profile.message, 1, 1, 1)
  else
    self:Print(self.db.profile.message)
  end
	-- end
end

function CombustionHelperClassic:SlashCommand(msg)
	if not msg or msg:trim() == "" then
    Settings.OpenToCategory(self.optionsFrame.name)
	else
		self:Print("hello there!")
	end
end

function CombustionHelperClassic:GetMessage(info)
	return self.db.profile.message
end

function CombustionHelperClassic:SetMessage(info, value)
	self.db.profile.message = value
end

function CombustionHelperClassic:IsShowOnScreen(info)
	return self.db.profile.showOnScreen
end

function CombustionHelperClassic:ToggleShowOnScreen(info, value)
	self.db.profile.showOnScreen = value
end
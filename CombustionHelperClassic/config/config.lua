local addonName, ns = ...;

local dbDefaults = {
	profile = {
		message = "Welcome Home!",
		showOnScreen = true,
	},
}

local interfaceOptions = {
	name = addonName,
	type = "group",
	args = {
		message = {
			type = "input",
			name = "Message",
			desc = "The message to be displayed when you get home.",
			usage = "<Your message>",
			get = function(info)
        return ns.db.profile.message
      end,
			set = function(info, value)
        ns.db.profile.message = value
      end,
		},
		showOnScreen = {
			type = "toggle",
			name = "Show on Screen",
			desc = "Toggles the display of the message on the screen.",
			get = function(info)
        return ns.db.profile.showOnScreen
      end,
			set = function(info, value)
        ns.db.profile.showOnScreen = value
      end,
		},
	},
}

function ns.config.initConfig()
  ns.AceConsole.Print(ns.CHC, 'config.lua - initConfig...')
  -- set up db
  ns.db = LibStub("AceDB-3.0"):New(addonName.."DB", dbDefaults, true)
  -- set up profiles using the db
	local profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(ns.db)

  -- register AceConfig options
	ns.AceConfig:RegisterOptionsTable(addonName.."_options", interfaceOptions)
  ns.AceConfig:RegisterOptionsTable(addonName.."_Profiles", profiles)

  -- add top level options frame to interface
	local interfaceOptionsFrame = ns.AceConfigDialog:AddToBlizOptions(addonName.."_options", addonName)
	-- add child 'Profiles' under top level options
	ns.AceConfigDialog:AddToBlizOptions(addonName.."_Profiles", "Profiles", addonName)


  -- register chat commands
  local function OpenInterfaceOptions()
    Settings.OpenToCategory(interfaceOptionsFrame.name)
  end
  ns.AceConsole:RegisterChatCommand("chc", OpenInterfaceOptions)
	ns.AceConsole:RegisterChatCommand(addonName, OpenInterfaceOptions)
  ns.AceConsole.Print(ns.CHC, 'config.lua - initConfig finished!')
end

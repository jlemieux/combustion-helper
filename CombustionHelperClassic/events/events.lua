local addonName, ns = ...;

function ns.events.registerEvents()
  ns.AceConsole.Print(ns.CHC, 'Registering events...')
  ns.CHC:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

function ns.CHC:COMBAT_LOG_EVENT_UNFILTERED()
  -- ns.AceConsole.Print(ns.CHC, 'hi', CombatLogGetCurrentEventInfo())
  -- ns.AceConsole.Print(ns.CHC, 'hi2', somethingElse)
  -- ns.AceConsole.Print(ns.CHC, 'hi3', self)
  local timestamp,
    subevent,
    hideCaster,
    sourceGUID,
    sourceName,
    sourceFlags,
    sourceRaidFlags,
    destGUID,
    destName,
    destFlags,
    destRaidFlags,
    --
    spellId,
    spellName,
    spellSchool,
    --
    amount, -- or missType for misses, failedType for failed casts, auraType, extraSpellId..
    overkill,
    school,
    resisted,
    blocked,
    absorbed,
    critical,
    glancing,
    crushing,
    isOffHand = CombatLogGetCurrentEventInfo()

    local playerName = UnitName("player")
    if (sourceName ~= playerName) then
      return
    end

    local spellHasDestination = destGUID and destName and destGUID ~= ''
    if (not spellHasDestination) then
      -- impact, cast starts, cast success
      return
    end

    if (not amount and not destName) then
      ns.AceConsole.Print(ns.CHC, '----------------------------------------------')
      ns.AceConsole.Print(ns.CHC, 'timestamp: ', timestamp)
      ns.AceConsole.Print(ns.CHC, 'subevent: ', subevent)
      ns.AceConsole.Print(ns.CHC, 'hideCaster: ', hideCaster)
      ns.AceConsole.Print(ns.CHC, 'sourceGUID: ', sourceGUID)
      ns.AceConsole.Print(ns.CHC, 'sourceName: ', sourceName)
      ns.AceConsole.Print(ns.CHC, 'sourceFlags: ', sourceFlags)
      ns.AceConsole.Print(ns.CHC, 'sourceRaidFlags: ', sourceRaidFlags)
      ns.AceConsole.Print(ns.CHC, 'destGUID: ', destGUID)
      ns.AceConsole.Print(ns.CHC, 'destName: ', destName)
      ns.AceConsole.Print(ns.CHC, 'destFlags: ', destFlags)
      ns.AceConsole.Print(ns.CHC, 'destRaidFlags: ', destRaidFlags)
      ns.AceConsole.Print(ns.CHC, 'spellId: ', spellId)
      ns.AceConsole.Print(ns.CHC, 'spellName: ', spellName)
      ns.AceConsole.Print(ns.CHC, 'spellSchool: ', spellSchool)
      ns.AceConsole.Print(ns.CHC, 'amount: ', amount)
      ns.AceConsole.Print(ns.CHC, 'overkill: ', overkill)
      ns.AceConsole.Print(ns.CHC, 'school: ', school)
      ns.AceConsole.Print(ns.CHC, 'resisted: ', resisted)
      ns.AceConsole.Print(ns.CHC, 'blocked: ', blocked)
      ns.AceConsole.Print(ns.CHC, 'absorbed: ', absorbed)
      ns.AceConsole.Print(ns.CHC, 'critical: ', critical)
      ns.AceConsole.Print(ns.CHC, 'glancing: ', glancing)
      ns.AceConsole.Print(ns.CHC, 'crushing: ', crushing)
      ns.AceConsole.Print(ns.CHC, 'isOffHand: ', isOffHand)
      ns.AceConsole.Print(ns.CHC, '----------------------------------------------')
      -- ns.AceConsole.Print(ns.CHC, subevent..', something is wrong with this one', CombatLogGetCurrentEventInfo())
    end

    -- ns.AceConsole.Print(ns.CHC, subevent..': '..(amount or '?')..'! target = '..(destName or '?'))

  -- local _, subevent, _, sourceGUID, _, _, _, _, destName = CombatLogGetCurrentEventInfo()
	-- local spellId, amount, critical

	-- if subevent == "SWING_DAMAGE" then
	-- 	amount, _, _, _, _, _, critical = select(12, CombatLogGetCurrentEventInfo())
	-- elseif subevent == "SPELL_DAMAGE" then
	-- 	spellId, _, _, amount, _, _, _, _, _, critical = select(12, CombatLogGetCurrentEventInfo())
	-- end

	-- if critical and sourceGUID == playerGUID then
	-- 	-- get the link of the spell or the MELEE globalstring
	-- 	local action = spellId and GetSpellLink(spellId) or MELEE
	-- 	print(MSG_CRITICAL_HIT:format(action, destName, amount))
	-- end
  -- -- local msg = ns.db.profile.message
  -- -- if ns.db.profile.showOnScreen then
  -- --   UIErrorsFrame:AddMessage(msg, 1, 1, 1)
  -- -- end
end

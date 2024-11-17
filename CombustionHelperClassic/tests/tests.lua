local addonName, ns = ...;

local epsilon = 1.1

------------------------------------------------
--- BEGIN Late Withdrawl Tests
------------------------------------------------
local lateWithdrawlScenario1 = {
  {"11/16/2024 03:02:12.373-5","SPELL_DAMAGE",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,2948,"Scorch",0x4,2638,2637,4,0,0,0,1,nil,nil,nil},
  {"11/16/2024 03:02:12.373-5","SPELL_AURA_APPLIED",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,413841,"Ignite",0x4,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil},
  {"11/16/2024 03:02:13.784-5","SPELL_DAMAGE",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,2948,"Scorch",0x4,2661,2660,4,0,0,0,1,nil,nil,nil},
  {"11/16/2024 03:02:13.786-5","SPELL_AURA_REFRESH",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,413841,"Ignite",0x4,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil},
  {"11/16/2024 03:02:14.335-5","SPELL_DAMAGE",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,413843,"Ignite",0x4,707,706,4,0,0,0,nil,nil,nil,nil},
  {"11/16/2024 03:02:15.305-5","SPELL_DAMAGE",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,2948,"Scorch",0x4,2527,2526,4,0,0,0,1,nil,nil,nil},
  {"11/16/2024 03:02:15.305-5","SPELL_AURA_REFRESH",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,413841,"Ignite",0x4,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil},
  {"11/16/2024 03:02:16.358-5","SPELL_DAMAGE",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,413843,"Ignite",0x4,808,807,4,0,0,0,nil,nil,nil,nil},
  {"11/16/2024 03:02:18.394-5","SPELL_DAMAGE",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,413843,"Ignite",0x4,808,807,4,0,0,0,nil,nil,nil,nil},
  {"11/16/2024 03:02:18.497-5","SPELL_DAMAGE",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,2948,"Scorch",0x4,2558,2557,4,0,0,0,1,nil,nil,nil},
  {"11/16/2024 03:02:18.497-5","SPELL_AURA_REFRESH",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,413841,"Ignite",0x4,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil},
  {"11/16/2024 03:02:19.896-5","SPELL_DAMAGE",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,2948,"Scorch",0x4,2519,2518,4,0,0,0,1,nil,nil,nil},
  {"11/16/2024 03:02:19.999-5","SPELL_AURA_REFRESH",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,413841,"Ignite",0x4,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil},
  {"11/16/2024 03:02:20.399-5","SPELL_DAMAGE",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,413843,"Ignite",0x4,946,945,4,0,0,0,nil,nil,nil,nil},
  {"11/16/2024 03:02:21.417-5","SPELL_DAMAGE",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,2948,"Scorch",0x4,2525,2524,4,0,0,0,1,nil,nil,nil},
  {"11/16/2024 03:02:21.417-5","SPELL_AURA_REFRESH",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,413841,"Ignite",0x4,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil},
  {"11/16/2024 03:02:21.950-5","SPELL_DAMAGE",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,92315,"Pyroblast!",0x4,6705,6704,4,0,0,0,1,nil,nil,nil},
  {"11/16/2024 03:02:21.950-5","SPELL_AURA_REFRESH",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,413841,"Ignite",0x4,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil},
  {"11/16/2024 03:02:22.392-5","SPELL_DAMAGE",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,413843,"Ignite",0x4,1862,1861,4,0,0,0,nil,nil,nil,nil},
  {"11/16/2024 03:02:24.397-5","SPELL_DAMAGE",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,413843,"Ignite",0x4,1862,1861,4,0,0,0,nil,nil,nil,nil},
  {"11/16/2024 03:02:24.579-5","SPELL_DAMAGE",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,2948,"Scorch",0x4,2620,2619,4,0,0,0,1,nil,nil,nil},
  {"11/16/2024 03:02:24.580-5","SPELL_AURA_REFRESH",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,413841,"Ignite",0x4,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil},
  {"11/16/2024 03:02:26.051-5","SPELL_DAMAGE",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,2948,"Scorch",0x4,1305,1304,4,0,0,0,nil,nil,nil,nil},
  {"11/16/2024 03:02:26.354-5","SPELL_DAMAGE",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,413843,"Ignite",0x4,969,968,4,0,0,0,nil,nil,nil,nil},
  {"11/16/2024 03:02:28.401-5","SPELL_DAMAGE",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,413843,"Ignite",0x4,970,969,4,0,0,0,nil,nil,nil,nil},
  {"11/16/2024 03:02:29.456-5","SPELL_DAMAGE",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,2948,"Scorch",0x4,2591,2590,4,0,0,0,1,nil,nil,nil},
  {"11/16/2024 03:02:29.456-5","SPELL_AURA_REFRESH",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,413841,"Ignite",0x4,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil},
  {"11/16/2024 03:02:30.394-5","SPELL_DAMAGE",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,413843,"Ignite",0x4,669,668,4,0,0,0,nil,nil,nil,nil},
  {"11/16/2024 03:02:30.879-5","SPELL_DAMAGE",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,2948,"Scorch",0x4,1281,1280,4,0,0,0,nil,nil,nil,nil},
  {"11/16/2024 03:02:32.382-5","SPELL_DAMAGE",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,2948,"Scorch",0x4,2512,2511,4,0,0,0,1,nil,nil,nil},
  {"11/16/2024 03:02:32.383-5","SPELL_AURA_REFRESH",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,413841,"Ignite",0x4,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil},
  {"11/16/2024 03:02:32.391-5","SPELL_DAMAGE",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,413843,"Ignite",0x4,668,667,4,0,0,0,nil,nil,nil,nil},
  {"11/16/2024 03:02:33.787-5","SPELL_DAMAGE",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,2948,"Scorch",0x4,1297,1296,4,0,0,0,nil,nil,nil,nil},
  {"11/16/2024 03:02:34.394-5","SPELL_DAMAGE",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,413843,"Ignite",0x4,558,557,4,0,0,0,nil,nil,nil,nil},
  {"11/16/2024 03:02:36.399-5","SPELL_DAMAGE",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,413843,"Ignite",0x4,558,557,4,0,0,0,nil,nil,nil,nil},
  {"11/16/2024 03:02:38.409-5","SPELL_AURA_REMOVED",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,413841,"Ignite",0x4,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil},
  {"11/16/2024 03:02:38.410-5","SPELL_DAMAGE",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,413843,"Ignite",0x4,558,557,4,0,0,0,nil,nil,nil,nil},
}

local lateWithdrawlScenario2 = {
  {"11/16/2024 03:37:13.958-5","SPELL_DAMAGE",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,2948,"Scorch",0x4,2689,1347,4,0,0,0,1,nil,nil,nil},
  {"11/16/2024 03:37:14.056-5","SPELL_AURA_APPLIED",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,413841,"Ignite",0x4,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil},
  {"11/16/2024 03:37:15.497-5","SPELL_DAMAGE",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,2948,"Scorch",0x4,1308,1307,4,0,0,0,nil,nil,nil,nil},
  {"11/16/2024 03:37:15.981-5","SPELL_DAMAGE",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,92315,"Pyroblast!",0x4,6739,3377,4,0,0,0,1,nil,nil,nil},
  {"11/16/2024 03:37:16.083-5","SPELL_DAMAGE",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,413843,"Ignite",0x4,538,537,4,0,0,0,nil,nil,nil,nil},
  {"11/16/2024 03:37:16.083-5","SPELL_AURA_REFRESH",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,413841,"Ignite",0x4,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil},
  {"11/16/2024 03:37:18.018-5","SPELL_DAMAGE",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,413843,"Ignite",0x4,1078,1077,4,0,0,0,nil,nil,nil,nil},
  {"11/16/2024 03:37:20.047-5","SPELL_DAMAGE",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,413843,"Ignite",0x4,1078,1077,4,0,0,0,nil,nil,nil,nil},
  {"11/16/2024 03:37:22.087-5","SPELL_AURA_REMOVED",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,413841,"Ignite",0x4,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil},
  {"11/16/2024 03:37:22.089-5","SPELL_DAMAGE",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,413843,"Ignite",0x4,1078,1077,4,0,0,0,nil,nil,nil,nil},
}

local function testLateWithdrawl1()
  ns.AceConsole.Print(ns.CHC, 'start: testLateWithdrawl1')
  local targetGUID = "Creature-0-4389-1-25-32667-0000B4C2A0"
  for i,combatEvent in ipairs(lateWithdrawlScenario1) do
    if i == 2 then
      local expectedBalance = 0.4 * select(15, unpack(lateWithdrawlScenario1[1]))
      local expectedWithdrawlsLeft = 2
      local expectedWithdrawlAmount = expectedBalance / expectedWithdrawlsLeft
      assert(
        math.abs(ns.igniteBank[targetGUID].balance - expectedBalance) <= epsilon,
        'Expected first balance to be ~'..expectedBalance
      )
      assert(
        math.abs(ns.igniteBank[targetGUID].expectedWithdrawlAmount - expectedWithdrawlAmount) <= epsilon,
        'Expected first withdrawl amount to be ~'..expectedWithdrawlAmount
      )
    end

    -- 32nd event is the withdrawl that will need to be reconciled, due to the 30th event (scorch crit for 2512)
    if i == 32 then
      local expectedBalance = 2341.4
      local expectedWithdrawlAmount = 780.467
      local expectedWithdrawlsLeft = 3
      assert(
        math.abs(ns.igniteBank[targetGUID].balance - expectedBalance) <= epsilon,
        'Expected balance to incorrectly be ~'..expectedBalance
      )
      assert(
        math.abs(ns.igniteBank[targetGUID].expectedWithdrawlAmount - expectedWithdrawlAmount) <= epsilon,
        'Expected expectedWithdrawlAmount to incorrectly be ~'..expectedWithdrawlAmount
      )
      assert(
        math.abs(ns.igniteBank[targetGUID].expectedWithdrawlAmount - select(15, unpack(combatEvent))) > epsilon,
        'Expected amounts to not match'
      )
      assert(
        ns.igniteBank[targetGUID].expectedWithdrawlsLeft == expectedWithdrawlsLeft,
        'Expected expectedWithdrawlsLeft to incorrectly be '..expectedWithdrawlsLeft
      )

    end
    -- by the 33rd event, we should be reconciled
    if i == 33 then
      local expectedBalance = 1673.4
      local expectedWithdrawlsLeft = 3
      local expectedWithdrawlAmount = expectedBalance / expectedWithdrawlsLeft
      assert(
        math.abs(ns.igniteBank[targetGUID].balance - expectedBalance) <= epsilon,
        'Expected balance to be ~'..expectedBalance
      )
      assert(
        math.abs(ns.igniteBank[targetGUID].expectedWithdrawlAmount - expectedWithdrawlAmount) <= epsilon,
        'Expected expectedWithdrawlAmount to be ~'..expectedWithdrawlAmount
      )
      assert(
        ns.igniteBank[targetGUID].expectedWithdrawlsLeft == expectedWithdrawlsLeft,
        'Expected expectedWithdrawlsLeft to be '..expectedWithdrawlsLeft
      )
    end
    if i == #lateWithdrawlScenario1 then
      -- before last event, verify before destroy
      local expectedBalance = 558
      local expectedWithdrawlAmount = 558
      local expectedWithdrawlsLeft = 1
      assert(
        math.abs(ns.igniteBank[targetGUID].balance - expectedBalance) <= epsilon,
        'Expected last balance to be ~'..expectedBalance
      )
      assert(
        math.abs(ns.igniteBank[targetGUID].expectedWithdrawlAmount - expectedWithdrawlAmount) <= epsilon,
        'Expected last expectedWithdrawlAmount to be ~'..expectedWithdrawlAmount
      )
      assert(
        ns.igniteBank[targetGUID].expectedWithdrawlsLeft == expectedWithdrawlsLeft,
        'Expected last expectedWithdrawlsLeft to be '..expectedWithdrawlsLeft
      )
    end

    CombatLogGetCurrentEventInfo = function() return unpack(combatEvent) end
    ns.CHC:COMBAT_LOG_EVENT_UNFILTERED()

    if i == #lateWithdrawlScenario1 then
      -- after last event, verify destroy
      assert(
        not ns.igniteBank[targetGUID],
        'Bank account should be destroyed!'
      )
    end
  end
  ns.AceConsole.Print(ns.CHC, 'finish: testLateWithdrawl1')
end

local function testLateWithdrawl2()
  ns.AceConsole.Print(ns.CHC, 'start: testLateWithdrawl2')
  local targetGUID = "Creature-0-4389-1-25-32667-0000B4C2A0"
  for i,combatEvent in ipairs(lateWithdrawlScenario2) do
    if i == 2 then
      local expectedBalance = 0.4 * select(15, unpack(lateWithdrawlScenario2[1]))
      local expectedWithdrawlsLeft = 2
      local expectedWithdrawlAmount = expectedBalance / expectedWithdrawlsLeft
      assert(
        math.abs(ns.igniteBank[targetGUID].balance - expectedBalance) <= epsilon,
        'Expected first balance to be ~'..expectedBalance
      )
      assert(
        math.abs(ns.igniteBank[targetGUID].expectedWithdrawlAmount - expectedWithdrawlAmount) <= epsilon,
        'Expected first withdrawl amount to be ~'..expectedWithdrawlAmount
      )
    end

    -- 5th event is the withdrawl that will need to be reconciled, due to the 4th event (pyro crit for 6739)
    if i == 5 then
      local expectedBalance = 3771.2
      local expectedWithdrawlsLeft = 3
      local expectedWithdrawlAmount = expectedBalance / expectedWithdrawlsLeft
      assert(
        math.abs(ns.igniteBank[targetGUID].balance - expectedBalance) <= epsilon,
        'Expected balance to incorrectly be ~'..expectedBalance
      )
      assert(
        math.abs(ns.igniteBank[targetGUID].expectedWithdrawlAmount - expectedWithdrawlAmount) <= epsilon,
        'Expected expectedWithdrawlAmount to incorrectly be ~'..expectedWithdrawlAmount
      )
      assert(
        math.abs(ns.igniteBank[targetGUID].expectedWithdrawlAmount - select(15, unpack(combatEvent))) > epsilon,
        'Expected amounts to not match'
      )
      assert(
        ns.igniteBank[targetGUID].expectedWithdrawlsLeft == expectedWithdrawlsLeft,
        'Expected expectedWithdrawlsLeft to incorrectly be '..expectedWithdrawlsLeft
      )

    end
    -- by the 6th event, we should be reconciled
    if i == 6 then
      local expectedBalance = 3233.2
      local expectedWithdrawlsLeft = 3
      local expectedWithdrawlAmount = expectedBalance / expectedWithdrawlsLeft
      assert(
        math.abs(ns.igniteBank[targetGUID].balance - expectedBalance) <= epsilon,
        'Expected balance to be ~'..expectedBalance
      )
      assert(
        math.abs(ns.igniteBank[targetGUID].expectedWithdrawlAmount - expectedWithdrawlAmount) <= epsilon,
        'Expected expectedWithdrawlAmount to be ~'..expectedWithdrawlAmount
      )
      assert(
        ns.igniteBank[targetGUID].expectedWithdrawlsLeft == expectedWithdrawlsLeft,
        'Expected expectedWithdrawlsLeft to be '..expectedWithdrawlsLeft
      )
    end
    if i == #lateWithdrawlScenario2 then
      -- before last event, verify before destroy
      local expectedBalance = 1077.7
      local expectedWithdrawlAmount = 1077.7
      local expectedWithdrawlsLeft = 1
      assert(
        math.abs(ns.igniteBank[targetGUID].balance - expectedBalance) <= epsilon,
        'Expected last balance to be ~'..expectedBalance
      )
      assert(
        math.abs(ns.igniteBank[targetGUID].expectedWithdrawlAmount - expectedWithdrawlAmount) <= epsilon,
        'Expected last expectedWithdrawlAmount to be ~'..expectedWithdrawlAmount
      )
      assert(
        ns.igniteBank[targetGUID].expectedWithdrawlsLeft == expectedWithdrawlsLeft,
        'Expected last expectedWithdrawlsLeft to be '..expectedWithdrawlsLeft
      )
    end

    CombatLogGetCurrentEventInfo = function() return unpack(combatEvent) end
    ns.CHC:COMBAT_LOG_EVENT_UNFILTERED()

    if i == #lateWithdrawlScenario2 then
      -- after last event, verify destroy
      assert(
        not ns.igniteBank[targetGUID],
        'Bank account should be destroyed!'
      )
    end
  end
  ns.AceConsole.Print(ns.CHC, 'finish: testLateWithdrawl2')
end
------------------------------------------------
--- END Late Withdrawl Tests
------------------------------------------------

------------------------------------------------
--- BEGIN Rounding Error Tests
------------------------------------------------
local roundingErrorScenario1 = {
  {"11/16/2024 17:54:32.643-5","SPELL_DAMAGE",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,133,"Fireball",0x4,2401,2400,4,0,0,0,nil,nil,nil,nil},
  {"11/16/2024 17:54:38.089-5","SPELL_DAMAGE",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,2948,"Scorch",0x4,1343,1342,4,0,0,0,nil,nil,nil,nil},
  {"11/16/2024 17:54:40.107-5","SPELL_DAMAGE",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,2948,"Scorch",0x4,2527,2526,4,0,0,0,1,nil,nil,nil},
  {"11/16/2024 17:54:40.197-5","SPELL_AURA_APPLIED",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,413841,"Ignite",0x4,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil},
  {"11/16/2024 17:54:42.171-5","SPELL_DAMAGE",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,413843,"Ignite",0x4,505,504,4,0,0,0,nil,nil,nil,nil},
  {"11/16/2024 17:54:42.335-5","SPELL_DAMAGE",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,92315,"Pyroblast!",0x4,6438,6437,4,0,0,0,1,nil,nil,nil},
  {"11/16/2024 17:54:42.335-5","SPELL_AURA_APPLIED",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,92315,"Pyroblast!",0x4,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil},
  {"11/16/2024 17:54:42.335-5","SPELL_AURA_REFRESH",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,413841,"Ignite",0x4,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil},
  {"11/16/2024 17:54:44.183-5","SPELL_DAMAGE",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,2136,"Fire Blast",0x4,1426,1425,4,0,0,0,nil,nil,nil,nil},
  {"11/16/2024 17:54:44.187-5","SPELL_DAMAGE",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,413843,"Ignite",0x4,1026,1025,4,0,0,0,nil,nil,nil,nil},
  {"11/16/2024 17:54:46.194-5","SPELL_DAMAGE",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,413843,"Ignite",0x4,1026,1025,4,0,0,0,nil,nil,nil,nil},
  {"11/16/2024 17:54:48.193-5","SPELL_AURA_REMOVED",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,413841,"Ignite",0x4,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil},
  {"11/16/2024 17:54:48.193-5","SPELL_DAMAGE",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,413843,"Ignite",0x4,1027,1026,4,0,0,0,nil,nil,nil,nil},
  {"11/16/2024 17:54:54.045-5","SPELL_AURA_REMOVED",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,92315,"Pyroblast!",0x4,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil},
}

local function testRoundingError1()
  ns.AceConsole.Print(ns.CHC, 'start: testRoundingError1')
  local targetGUID = "Creature-0-4389-1-25-32667-0000B4C2A0"
  local firstScorchCritIdx = 3
  local firstIgniteWithdraw = 5
  local pyroCrit = 6
  local thirdToLastIgniteWithdraw = 10
  local secondToLastIgniteWithdraw = 11
  local lastIgniteWithdraw = 13

  for i,combatEvent in ipairs(roundingErrorScenario1) do
    if i == 4 then
      local expectedBalance = 0.4 * select(15, unpack(roundingErrorScenario1[firstScorchCritIdx]))
      local expectedWithdrawlsLeft = 2
      local expectedWithdrawlAmount = expectedBalance / expectedWithdrawlsLeft
      assert(
        math.abs(ns.igniteBank[targetGUID].balance - expectedBalance) <= epsilon,
        'Expected first balance to be ~'..expectedBalance
      )
      assert(
        math.abs(ns.igniteBank[targetGUID].expectedWithdrawlAmount - expectedWithdrawlAmount) <= epsilon,
        'Expected first withdrawl amount to be ~'..expectedWithdrawlAmount
      )
    end

    if i == 6 then
      local expectedBalance = 505.8
      local expectedWithdrawlsLeft = 1
      local expectedWithdrawlAmount = expectedBalance / expectedWithdrawlsLeft
      assert(
        math.abs(ns.igniteBank[targetGUID].balance - expectedBalance) <= epsilon,
        'Expected balance after first withdrawl to be ~'..expectedBalance
      )
      assert(
        math.abs(ns.igniteBank[targetGUID].expectedWithdrawlAmount - expectedWithdrawlAmount) <= epsilon,
        'Expected last withdrawl amount to be ~'..expectedWithdrawlAmount
      )
    end

    if i == 7 then
      local expectedBalance = 3081
      local expectedWithdrawlsLeft = 3
      local expectedWithdrawlAmount = expectedBalance / expectedWithdrawlsLeft
      assert(
        math.abs(ns.igniteBank[targetGUID].balance - expectedBalance) <= epsilon,
        'Expected balance after pyro crit to be ~'..expectedBalance
      )
      assert(
        math.abs(ns.igniteBank[targetGUID].expectedWithdrawlAmount - expectedWithdrawlAmount) <= epsilon,
        'Expected withdrawl amount after pyro crit to be ~'..expectedWithdrawlAmount
      )
    end

    if i == 11 then
      local expectedBalance = 2055
      local expectedWithdrawlsLeft = 2
      local expectedWithdrawlAmount = 1027
      assert(
        math.abs(ns.igniteBank[targetGUID].balance - expectedBalance) <= epsilon,
        'Expected balance after problem withdrawl to be ~'..expectedBalance
      )
      assert(
        math.abs(ns.igniteBank[targetGUID].expectedWithdrawlAmount - expectedWithdrawlAmount) <= epsilon,
        'Expected withdrawl amount after problem withdrawl to still be ~'..expectedWithdrawlAmount
      )
    end

    CombatLogGetCurrentEventInfo = function() return unpack(combatEvent) end
    ns.CHC:COMBAT_LOG_EVENT_UNFILTERED()

    if i == #roundingErrorScenario1 then
      -- after last event, verify destroy
      assert(
        not ns.igniteBank[targetGUID],
        'Bank account should be destroyed!'
      )
    end
  end
  ns.AceConsole.Print(ns.CHC, 'finish: testRoundingError1')
end
------------------------------------------------
--- END Rounding Error Tests
------------------------------------------------


------------------------------------------------
--- BEGIN Consolidated Tick Tests
------------------------------------------------
local consolidatedTickScenario1 = {
  {"11/16/2024 20:14:02.514-5","SPELL_DAMAGE",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,2948,"Scorch",0x4,2622,2621,4,0,0,0,1,nil,nil,nil},
  {"11/16/2024 20:14:02.514-5","SPELL_AURA_APPLIED",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,413841,"Ignite",0x4,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil},
  {"11/16/2024 20:14:04.555-5","SPELL_DAMAGE",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,413843,"Ignite",0x4,524,523,4,0,0,0,nil,nil,nil,nil},
  {"11/16/2024 20:14:05.270-5","SPELL_DAMAGE",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,133,"Fireball",0x4,2496,2495,4,0,0,0,nil,nil,nil,nil},
  {"11/16/2024 20:14:06.488-5","SPELL_DAMAGE",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,2948,"Scorch",0x4,2573,2572,4,0,0,0,1,nil,nil,nil},
  {"11/16/2024 20:14:06.488-5","SPELL_AURA_REMOVED",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,413841,"Ignite",0x4,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil},
  {"11/16/2024 20:14:06.488-5","SPELL_AURA_APPLIED",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,413841,"Ignite",0x4,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil},
  {"11/16/2024 20:14:06.589-5","SPELL_DAMAGE",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,413843,"Ignite",0x4,1553,1552,4,0,0,0,nil,nil,nil,nil},
  {"11/16/2024 20:14:08.105-5","SPELL_DAMAGE",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,2948,"Scorch",0x4,1325,1324,4,0,0,0,nil,nil,nil,nil},
  {"11/16/2024 20:14:10.522-5","SPELL_AURA_REMOVED",nil,"Player-4408-05446737","Drinkingfast-Faerlina-US",0x511,0x0,"Creature-0-4389-1-25-32667-0000B4C2A0","Training Dummy",0x10a28,0x0,413841,"Ignite",0x4,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil},
}

local function testConsolidatedTick1()
  ns.AceConsole.Print(ns.CHC, 'start: testConsolidatedTick1')
  local targetGUID = "Creature-0-4389-1-25-32667-0000B4C2A0"
  local firstScorchCrit = 1
  local firstIgniteWithdraw = 3
  local secondScorchCrit = 5
  local lastIgniteWithdraw = 8

  for i,combatEvent in ipairs(consolidatedTickScenario1) do
    if i == 2 then
      local expectedBalance = 0.4 * select(15, unpack(consolidatedTickScenario1[firstScorchCrit]))
      local expectedWithdrawlsLeft = 2
      local expectedWithdrawlAmount = expectedBalance / expectedWithdrawlsLeft
      assert(
        math.abs(ns.igniteBank[targetGUID].balance - expectedBalance) <= epsilon,
        'Expected first balance to be ~'..expectedBalance
      )
      assert(
        math.abs(ns.igniteBank[targetGUID].expectedWithdrawlAmount - expectedWithdrawlAmount) <= epsilon,
        'Expected first withdrawl amount to be ~'..expectedWithdrawlAmount
      )
    end

    if i == 4 then
      local expectedBalance = 524.8
      local expectedWithdrawlsLeft = 1
      local expectedWithdrawlAmount = expectedBalance / expectedWithdrawlsLeft
      assert(
        math.abs(ns.igniteBank[targetGUID].balance - expectedBalance) <= epsilon,
        'Expected balance after first withdrawl to be ~'..expectedBalance
      )
      assert(
        math.abs(ns.igniteBank[targetGUID].expectedWithdrawlAmount - expectedWithdrawlAmount) <= epsilon,
        'Expected last withdrawl amount to be ~'..expectedWithdrawlAmount
      )
    end

    if i == 6 then
      local expectedBalance = 1554
      local expectedWithdrawlsLeft = 3
      local expectedWithdrawlAmount = expectedBalance / expectedWithdrawlsLeft
      assert(
        math.abs(ns.igniteBank[targetGUID].balance - expectedBalance) <= epsilon,
        'Expected balance after second scorch crit to be ~'..expectedBalance
      )
      assert(
        math.abs(ns.igniteBank[targetGUID].expectedWithdrawlAmount - expectedWithdrawlAmount) <= epsilon,
        'Expected withdrawl amount after second scorch crit to be ~'..expectedWithdrawlAmount
      )
    end

    if i == 9 then
      assert(
        not ns.igniteBank[targetGUID],
        'Ignite loan paid in advance! Bank account should be destroyed!'
      )
    end

    CombatLogGetCurrentEventInfo = function() return unpack(combatEvent) end
    ns.CHC:COMBAT_LOG_EVENT_UNFILTERED()

  end
  ns.AceConsole.Print(ns.CHC, 'finish: testConsolidatedTick1')
end
------------------------------------------------
--- END Consolidated Tick Tests
------------------------------------------------

function ns.tests.runTests()
  ns.AceConsole.Print(ns.CHC, 'Unregister all events for testing!')
  ns.CHC:UnregisterAllEvents()

  ns.AceConsole.Print(ns.CHC, 'Starting test suites...')
  testLateWithdrawl1()

  testLateWithdrawl2()

  testRoundingError1()

  testConsolidatedTick1()
  ns.AceConsole.Print(ns.CHC, 'Finished all test suites!')
end

local addonName, ns = ...;

local playerGUID = UnitGUID("player")
local SPELLS = ns.constants.SPELLS
local CAUSES_IGNITE = ns.constants.CAUSES_IGNITE

function ns.events.registerEvents()
  ns.AceConsole.Print(ns.CHC, 'Registering events...')
  ns.CHC:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

ns.igniteBank = {}
local igniteBank = ns.igniteBank


local function getMasteryCoeff()
  return 1 + ((2.8 * GetMastery()) / 100)
end

local function serializeTransaction(transaction)
  return 'damage=<'..transaction.damage..'>, '..
    transaction.kind..'=<'..transaction.amount..'>, '..
    'balance=<'..string.format("%.3f", transaction.balance)..'>, '..
    'tickAmount=<'..string.format("%.3f", transaction.expectedWithdrawlAmount)..'>, '..
    'ticksLeft=<'..transaction.expectedWithdrawlsLeft..'>'
end

local function printTransactions(guid)
  ns.AceConsole.Print(ns.CHC, 'Printing account for: <'..guid..'>')
  for i, transaction in ipairs(igniteBank[guid].transactions) do
    ns.AceConsole.Print(ns.CHC, serializeTransaction(transaction))
  end
end

local function printAllAccountsTransactions()
  ns.AceConsole.Print(ns.CHC, 'Printing all accounts...')
  for guid, bank in pairs(igniteBank) do
    printTransactions(guid)
  end
  ns.AceConsole.Print(ns.CHC, 'Done printing accounts!')
end

-- transactions are a copy of the bank state after the deposit/withdrawl has completed.
-- so the balance, expectedWithdrawlAmount and expectedWithdrawlsLeft will be post-transaction.
-- kind, amount, and damage are what caused the change to result in that state.
local function createTransaction(bank, kind, damage, amount)
  return {
    kind = kind,
    amount = amount,
    damage = damage,
    balance = bank.balance,
    expectedWithdrawlAmount = bank.expectedWithdrawlAmount,
    expectedWithdrawlsLeft = bank.expectedWithdrawlsLeft,
  }
end

local function destroyBankAccount(bank)
  local guid = bank.guid
  -- printTransactions(guid)
  assert(
    igniteBank[guid].expectedWithdrawlsLeft == 0,
    'Accounts should have fulfilled all their withdrawls before being closed!'
  )
  -- igniteBank[guid].transactions = nil -- is this needed for proper GC?
  igniteBank[guid] = nil
end

local function applyDeposit(bank, damage, amount, ticks)
  local total = bank.balance + amount
  bank.balance = total
  bank.expectedWithdrawlAmount = total / ticks
  bank.expectedWithdrawlsLeft = ticks

  table.insert(bank.transactions, createTransaction(bank, 'deposit', damage, amount))
end

local function depositIgniteDamage(guid, damage)
  local ticks = igniteBank[guid] and 3 or 2
  igniteBank[guid] = igniteBank[guid] or {
    guid = guid,
    transactions = {}, -- [+100, -50, -50], [+100, -50, +100, -50, -50, -50], [+100, +100, -66.67, -66.67, -66.67]
    balance = 0,
    expectedWithdrawlAmount = nil,
    expectedWithdrawlsLeft = nil,
  }
  local bank = igniteBank[guid]

  local amount = 0.4 * damage * getMasteryCoeff()
  applyDeposit(bank, damage, amount, ticks)
end

local function withdrawlAmountMatchesExpectation(expected, actual)
  -- NOTE: tried using 1 as epsilon amount, but due to rounding compounded with floating point math, we need 1.1
  local epsilon = 1.1
  local ok = math.abs(expected - actual) <= epsilon
  if not ok then
    ns.AceConsole.Print(
      ns.CHC,
      'Withdrawl amount deviated from expectation by more than '..epsilon..'! '..
        'Expected=<'..expected..'>, Actual=<'..actual..'> '
    )
  end
  return ok
end

local function withdrawIsValid(bank, damage)
  assert(bank.expectedWithdrawlsLeft > 0, 'This bank does not expect another withdrawl, it should already be destroyed!')

  return withdrawlAmountMatchesExpectation(bank.expectedWithdrawlAmount, damage)
end

local function applyWithdrawl(bank, damage)
  bank.balance = bank.balance - damage
  bank.expectedWithdrawlsLeft = bank.expectedWithdrawlsLeft - 1
  table.insert(bank.transactions, createTransaction(bank, 'withdrawl', damage, damage))
end

local function rollbackLastTransaction(bank)
  local secondToLastTransaction = assert(
    bank.transactions[#bank.transactions-1],
    'When rolling back, there should be another transaction state to roll back to!'
  )

  bank.balance = secondToLastTransaction.balance
  bank.expectedWithdrawlAmount = secondToLastTransaction.expectedWithdrawlAmount
  bank.expectedWithdrawlsLeft = secondToLastTransaction.expectedWithdrawlsLeft
  return table.remove(bank.transactions, #bank.transactions)
end



local function reconcileIgniteWithdrawl(bank, damage)
  ns.AceConsole.Print(ns.CHC, 'Attempting to reconcile the withdrawl...')

  -- CONSOLIDATED 3 TICK WITHDRAWL SCENARIO
  if (
    bank.expectedWithdrawlsLeft == 3 and
    withdrawlAmountMatchesExpectation(bank.balance, damage) and
    withdrawIsValid(bank, (damage / 3))
  ) then
    bank.expectedWithdrawlsLeft = 1
    -- todo: should I leave this amount as the smaller amount, to better match the aura duration?
    -- bank.expectedWithdrawlAmount = damage
    applyWithdrawl(bank, damage)
    destroyBankAccount(bank)
    ns.AceConsole.Print(ns.CHC, 'Reconciled consolidated withdrawl successfully!')
    return
  end



  -- LATE WITHDRAWL SCENARIO
  local lastTransaction = rollbackLastTransaction(bank)
  assert(
    lastTransaction.kind == 'deposit' or printAllAccountsTransactions(),
    'Could not reconcile withdrawl! '..
      'Current understanding of this bug assumes untimely deposits are the only cause!'
  )
  -- apply rejected withdrawl
  assert(
    withdrawIsValid(bank, damage) or printAllAccountsTransactions(),
    'Could not reconcile withdrawl! '..
      'Some other edge case has happened'
  )
  applyWithdrawl(bank, damage)
  -- reapply rolled back deposit
  applyDeposit(bank, lastTransaction.damage, lastTransaction.amount, 3)
  -- todo: can we make this faster, such as getting to the end state we want,
  -- without rolling back and reapplying?
  ns.AceConsole.Print(ns.CHC, 'Reconciled late withdrawl successfully!')
end



local function withdrawIgniteDamage(guid, damage)
  local bank = assert(igniteBank[guid], 'Bank does not exist, cannot withdraw!')

  if not withdrawIsValid(bank, damage) then
    reconcileIgniteWithdrawl(bank, damage)
    return
  end

  applyWithdrawl(bank, damage)

  if bank.expectedWithdrawlsLeft == 0 then
    destroyBankAccount(bank)
  end
end

local totalDeposits = 0
local totalWithdrawls = 0

function ns.CHC:COMBAT_LOG_EVENT_UNFILTERED()
  local timestamp,
    subEvent,
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

  if sourceGUID ~= playerGUID then
    return
  end

  if subEvent == "SPELL_DAMAGE" then
    assert(amount > 0, 'Not expecting negative damage!')

    if CAUSES_IGNITE[spellId] and critical then
      depositIgniteDamage(destGUID, amount)
      totalDeposits = totalDeposits + 1
    elseif spellId == SPELLS.IgniteDamage then
      withdrawIgniteDamage(destGUID, amount)
      totalWithdrawls = totalWithdrawls + 1
    end
  elseif subEvent == "SPELL_CAST_SUCCESS" and spellId == SPELLS.SlowFall then
    printAllAccountsTransactions()
    ns.AceConsole.Print(ns.CHC, 'Total Deposits: '..totalDeposits)
    ns.AceConsole.Print(ns.CHC, 'Total Withdrawls: '..totalWithdrawls)
  end

  -- end

  -- -- targeted event
  -- if (destGUID == targetGUID) then
  --   if (subevent == "SPELL_DAMAGE") then
  --     targetedSpellDamageEvent(timestamp, subevent, destGUID, spellId, amount, isCritical)
  --   end
  -- end

  -- if (false) then
  --   ns.AceConsole.Print(ns.CHC, '----------------------------------------------')
  --   ns.AceConsole.Print(ns.CHC, 'timestamp: ', timestamp)
  --   ns.AceConsole.Print(ns.CHC, 'subevent: ', subevent)
  --   ns.AceConsole.Print(ns.CHC, 'hideCaster: ', hideCaster)
  --   ns.AceConsole.Print(ns.CHC, 'sourceGUID: ', sourceGUID)
  --   ns.AceConsole.Print(ns.CHC, 'sourceName: ', sourceName)
  --   ns.AceConsole.Print(ns.CHC, 'sourceFlags: ', sourceFlags)
  --   ns.AceConsole.Print(ns.CHC, 'sourceRaidFlags: ', sourceRaidFlags)
  --   ns.AceConsole.Print(ns.CHC, 'destGUID: ', destGUID)
  --   ns.AceConsole.Print(ns.CHC, 'destName: ', destName)
  --   ns.AceConsole.Print(ns.CHC, 'destFlags: ', destFlags)
  --   ns.AceConsole.Print(ns.CHC, 'destRaidFlags: ', destRaidFlags)
  --   ns.AceConsole.Print(ns.CHC, 'spellId: ', spellId)
  --   ns.AceConsole.Print(ns.CHC, 'spellName: ', spellName)
  --   ns.AceConsole.Print(ns.CHC, 'spellSchool: ', spellSchool)
  --   ns.AceConsole.Print(ns.CHC, 'amount: ', amount)
  --   ns.AceConsole.Print(ns.CHC, 'overkill: ', overkill)
  --   ns.AceConsole.Print(ns.CHC, 'school: ', school)
  --   ns.AceConsole.Print(ns.CHC, 'resisted: ', resisted)
  --   ns.AceConsole.Print(ns.CHC, 'blocked: ', blocked)
  --   ns.AceConsole.Print(ns.CHC, 'absorbed: ', absorbed)
  --   ns.AceConsole.Print(ns.CHC, 'critical: ', critical)
  --   ns.AceConsole.Print(ns.CHC, 'glancing: ', glancing)
  --   ns.AceConsole.Print(ns.CHC, 'crushing: ', crushing)
  --   ns.AceConsole.Print(ns.CHC, 'isOffHand: ', isOffHand)
  --   ns.AceConsole.Print(ns.CHC, '----------------------------------------------')
  -- end

  -- -- spells without a destination will have `destName == nil` and `destGUID == ''`
  -- local spellHasDestination = destGUID and destName and destGUID ~= ''
  -- -- if (not spellHasDestination) then
  -- --   -- impact, cast starts, cast success
  -- --   return
  -- -- end

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

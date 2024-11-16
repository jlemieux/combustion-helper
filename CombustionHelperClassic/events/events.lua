local addonName, ns = ...;

local playerGUID = UnitGUID("player")
local SPELLS = ns.constants.SPELLS
local CAUSES_IGNITE = ns.constants.CAUSES_IGNITE

function ns.events.registerEvents()
  ns.AceConsole.Print(ns.CHC, 'Registering events...')
  ns.CHC:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

local igniteBank = {}


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

local function destroyBankAccount(guid)
  printTransactions(guid)
  -- igniteBank[guid].transactions = nil -- is this needed for proper GC?
  igniteBank[guid] = nil
end

local function depositIgniteDamage(guid, damage)
  local ticks = igniteBank[guid] and 3 or 2
  igniteBank[guid] = igniteBank[guid] or {
    transactions = {}, -- [+100, -50, -50], [+100, -50, +100, -50, -50, -50], [+100, +100, -66.67, -66.67, -66.67]
    balance = 0,
    expectedWithdrawlAmount = nil,
    expectedWithdrawlsLeft = nil,
    -- lastExpectedWithdrawlAmount = nil,
    -- lastExpectedWithdrawlsLeft = nil,
  }
  local bank = igniteBank[guid]

  -- bank.lastExpectedWithdrawlAmount = bank.expectedWithdrawlAmount
  -- bank.lastExpectedWithdrawlsLeft = bank.expectedWithdrawlsLeft

  local amount = 0.4 * damage * getMasteryCoeff()
  local total = bank.balance + amount
  bank.balance = total
  bank.expectedWithdrawlAmount = total / ticks
  bank.expectedWithdrawlsLeft = ticks

  table.insert(bank.transactions, createTransaction(bank, 'deposit', damage, amount))
end

local function withdrawlAmountMatchesExpectation(expected, actual)
  local ok = math.abs(expected - actual) <= 1
  if not ok then
    ns.AceConsole.Print(
      ns.CHC,
      'Withdrawl amount deviated from expectation by more than 1! '..
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

local function reconcileLateIgniteWithdrawl(bank, damage)
  ns.AceConsole.Print(ns.CHC, 'Attempting to reconcile the late withdrawl...')

  local lastTransaction = rollbackLastTransaction(bank)
  assert(
    lastTransaction.kind == 'deposit',
    'Could not reconcile withdrawl!'..
      'Current understanding of this bug assumes untimely deposits are the only cause!'
  )

  -- apply late withdrawl
  assert(
    withdrawIsValid(bank, damage),
    'Could not reconcile withdrawl!'..
      'Some other edge case has happened'
  )
  applyWithdrawl(bank, damage)

  -- reapply rolled back deposit
  -- .... do it here....

  -- todo: is there a faster way to get to the end state we want,
  -- without rolling back, and reapplying?

end



local function withdrawIgniteDamage(guid, damage)
  local bank = assert(igniteBank[guid], 'Bank does not exist, cannot withdraw!')

  if not withdrawIsValid(bank, damage) then
    reconcileLateIgniteWithdrawl(bank, damage)
  end

  applyWithdrawl(bank, damage)

  if bank.expectedWithdrawlsLeft == 0 then
    destroyBankAccount(guid)
  end
end


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
    elseif spellId == SPELLS.IgniteDamage then
      withdrawIgniteDamage(destGUID, amount)
    elseif spellId == SPELLS.IceLance then
      printAllAccountsTransactions()
    end

  end

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

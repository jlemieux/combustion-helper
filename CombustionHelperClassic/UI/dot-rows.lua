local addonName, ns = ...;

local function createDOTContainer(parent)
  local frame = CreateFrame("Frame", nil, parent)
  frame:SetPoint("TOPLEFT", parent)
  frame:SetSize(parent:GetWidth(),0.6*parent:GetHeight())
  return frame
end

local function createRow(parent, point, relativeTo, relativePoint, text, shortText, xOffset, yOffset)
  local label = parent:CreateFontString(nil, "BACKGROUND", "ChatFontNormal")
  label:SetPoint(point, relativeTo, relativePoint, xOffset or 5, yOffset or -5)
  label:SetText(text)
  label:SetJustifyH("RIGHT")
  label:SetWidth(0.6 * parent:GetWidth())

  local indicator = parent:CreateTexture(nil, "BACKGROUND")
  indicator:SetTexture('Interface\\AddOns\\CombustionHelperClassic\\Images\\red_circle')
  indicator:SetPoint("LEFT", label, "RIGHT")

  local shortLabel = parent:CreateFontString(nil, "BACKGROUND", "ChatFontNormal")
  shortLabel:SetPoint("LEFT", indicator, "RIGHT")
  shortLabel:SetText(shortText)
  shortLabel:SetJustifyH("LEFT")
  shortLabel:SetWidth((0.4 * parent:GetWidth()) - indicator:GetWidth())

  return label
end

function ns._ui.createDOTRows(parent)
  local dotContainer = createDOTContainer(parent)
  local livingBombRowLabel = createRow(dotContainer, "TOPLEFT", dotContainer, "TOPLEFT", "Living Bomb", "LB", 5, -5)
  local igniteRowLabel = createRow(dotContainer, "TOP", livingBombRowLabel, "BOTTOM", "Ignite", "Ign", 0, 0)
  local pyroblastRowLabel = createRow(dotContainer, "TOP", igniteRowLabel, "BOTTOM", "Pyroblast", "Pyro", 0, 0)
  return dotContainer
end

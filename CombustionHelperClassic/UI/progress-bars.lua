local addonName, ns = ...;

local function createProgressBarsContainer(parent, relativeTo)
  local frame = CreateFrame("Frame", nil, parent)
  frame:SetPoint("TOP", relativeTo, "BOTTOM")
  frame:SetSize(parent:GetWidth(),0.45*parent:GetHeight())
  return frame
end

local function createRow(parent, point, relativeTo, relativePoint, text, xOffset, yOffset)
  local paddingX = 5
  local barWidth = parent:GetWidth() - (paddingX * 2)

  local bar = CreateFrame("StatusBar", nil, parent)

  local label = bar:CreateFontString(nil, "ARTWORK", "ChatFontNormal")
  label:SetPoint(point, relativeTo, relativePoint, xOffset, yOffset)
  label:SetText(text)
  label:SetJustifyH("LEFT")
  label:SetWidth(barWidth)

  local timerLabel = bar:CreateFontString(nil, "ARTWORK", "ChatFontNormal")
  timerLabel:SetPoint(point, relativeTo, relativePoint, xOffset, yOffset)
  timerLabel:SetText('0.0')
  timerLabel:SetJustifyH("RIGHT")
  timerLabel:SetWidth(barWidth)

  bar:SetStatusBarTexture('Interface\\AddOns\\CombustionHelperClassic\\Images\\black_and_white_bar_texture')
  bar:SetPoint("TOPLEFT", label, "TOPLEFT")
  bar:SetSize(barWidth, label:GetHeight())
  bar:SetMinMaxValues(0, barWidth)
  bar:SetValue(barWidth*random())
  bar:SetStatusBarColor(0, 0.5, 0.8, 1) -- blue

  return label
end

function ns._ui.createProgressBarRows(parent, dotRowsSiblingContainer)
  local progressBarsContainer = createProgressBarsContainer(parent, dotRowsSiblingContainer)
  local impactProgressLabel = createRow(progressBarsContainer, "TOPLEFT", progressBarsContainer, "TOPLEFT", "Impact", 5, -5)
  local criticalMassProgressLabel = createRow(progressBarsContainer, "TOP", impactProgressLabel, "BOTTOM", "Critical Mass", 0, -3)
  return progressBarsContainer
end

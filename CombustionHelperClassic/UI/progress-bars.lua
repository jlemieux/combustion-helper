local addonName, ns = ...;

local function createProgressBarsContainer(parent, relativeTo)
  local frame = CreateFrame("Frame", nil, parent)
  frame:SetPoint("TOP", relativeTo, "BOTTOM")
  frame:SetSize(parent:GetWidth(),0.4*parent:GetHeight())
  return frame
end

local function createRow(parent, point, relativeTo, relativePoint, text, xOffset, yOffset)
  local label = parent:CreateFontString(nil, "BACKGROUND", "ChatFontNormal")
  label:SetPoint(point, relativeTo, relativePoint, xOffset or 5, yOffset or -5)
  label:SetText(text)
  label:SetJustifyH("LEFT")
  label:SetWidth(parent:GetWidth())
  return label
end

function ns._ui.createProgressBarRows(parent, dotRowsSiblingContainer)
  local progressBarsContainer = createProgressBarsContainer(parent, dotRowsSiblingContainer)
  local impactProgressLabel = createRow(progressBarsContainer, "TOPLEFT", progressBarsContainer, "TOPLEFT", "Impact", 5, -5)
  local criticalMassProgressLabel = createRow(progressBarsContainer, "TOP", impactProgressLabel, "BOTTOM", "Critical Mass", 0, 0)
  return progressBarsContainer
end

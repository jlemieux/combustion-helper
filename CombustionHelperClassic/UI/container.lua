local addonName, ns = ...;

function ns._ui.createMainContainer()
  local frame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
  frame:EnableMouse(true)
  frame:SetMovable(true)
  frame:SetBackdrop({
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 16,
    insets = { left = 5, right = 5, top = 5, bottom = 5 }
  })
  frame:SetBackdropColor(0.25, 0.25, 0.25)
  frame:SetBackdropBorderColor(0.67, 0.67, 0.67)
  frame:SetSize(150,100)
  frame:SetPoint("CENTER")
  frame:SetScript("OnMouseDown", function(self, button)
    self:StartMoving()
  end)
  frame:SetScript("OnMouseUp", function(self, button)
    self:StopMovingOrSizing()
  end)
  return frame
end

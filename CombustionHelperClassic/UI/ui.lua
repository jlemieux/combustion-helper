local addonName, ns = ...;

function ns.ui.initUI()
  ns._ui.container = ns._ui.createContainerFrame()

  local frame = CreateFrame("Frame", nil, ns._ui.container)
	local label = frame:CreateFontString(nil, "BACKGROUND", "ChatFontNormal")
  label:SetText("Hi there!")
  label:SetPoint("CENTER")
  -- label:SetSize(100,100)
  -- label:SetFontObject("ChatFontNormal")
  frame:SetPoint("CENTER")
  frame:SetSize(100,100)
	-- local image = frame:CreateTexture(nil, "BACKGROUND")

  -- local editbox = ns.AceGUI:Create("EditBox")
  -- editbox:SetLabel("Insert text:")
  -- editbox:SetWidth(200)
  -- ns.ui.container:AddChild(editbox)
  -- more stuff here...
end

local addonName, ns = ...;

function ns.ui.initUI()
  -- ns._ui.mainContainer = ns._ui.createContainerFrame()
  local mainContainer = ns._ui.createMainContainer()
  local dotRowsContainer = ns._ui.createDOTRows(mainContainer)
  local progressBarRowsContainer = ns._ui.createProgressBarRows(mainContainer, dotRowsContainer)
  -- local frame = CreateFrame("Frame", nil, ns._ui.container)
  -- frame:SetPoint("TOPLEFT", ns._ui.container)
  -- frame:SetSize(100,100)

	-- local label = frame:CreateFontString(nil, "BACKGROUND", "ChatFontNormal")
  -- label:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -5, -5)
  -- label:SetText("Living Bomb")
  -- -- label:SetSize(100,100)
  -- -- label:SetFontObject("ChatFontNormal")

	-- -- local image = frame:CreateTexture(nil, "BACKGROUND")

  -- -- local editbox = ns.AceGUI:Create("EditBox")
  -- -- editbox:SetLabel("Insert text:")
  -- -- editbox:SetWidth(200)
  -- -- ns.ui.container:AddChild(editbox)
  -- -- more stuff here...
end

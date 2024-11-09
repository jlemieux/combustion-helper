CombuCaut_UpdateInterval = 1; -- How often the OnUpdate code will run (in seconds)

function CombuCaut_OnLoad(Frame) 
                                               
    if select(2, UnitClass("player")) ~= "MAGE" then CombuCautFrame:Hide() return end
        
	Frame:RegisterForDrag("LeftButton")
 	Frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	Frame:RegisterEvent("PLAYER_ALIVE")
	Frame:RegisterEvent("PLAYER_LOGIN")
	Frame:RegisterEvent("PLAYER_TALENT_UPDATE")
    
    if (CombuCautenablevar == nil) then CombuCautenablevar = true end
    if (CombuCautscalevar == nil) then CombuCautscalevar = 1 end
    if (CombuCautlevelvar == nil) then CombuCautlevelvar = 10 end
    if (CombuCautalphavar == nil) then CombuCautalphavar = 1 end
    if (CombuCautlockvar == nil) then CombuCautlockvar = false end
    if (CombuCautTimevar == nil) then CombuCautTimevar = true end
    if (CombuCauthidevar == nil) then CombuCauthidevar = false end
    if (CombuCautChatRaidvar == nil) then CombuCautChatRaidvar = true end
    if (CombuCautChatSayvar == nil) then CombuCautChatSayvar = true end
    if (CombuCautChatYellvar == nil) then CombuCautChatYellvar = false end
    if (CombuCautChatAltvar == nil) then CombuCautChatAltvar = false end
    if (CombuCautChatAlonevar == nil) then CombuCautChatAlonevar = true end
    if (CombuCautAnnouncevar == nil) then CombuCautAnnouncevar = "Cauterizing. Heal me up, please !!" end
    if (CombuCautAnnounceAltvar == nil) then CombuCautAnnounceAltvar = "Cauterizing but got Ice Block ready, don't worry." end

    CombuCautCD = 0
          
end

-------------------------------
-- helper function for option panel setup
function CombuCautOptions_OnLoad(panel)
	panel.name = "Cauterize options"
	panel.parent = "CombustionHelper"
	InterfaceOptions_AddCategory(panel);
end

-------------------------------
-- lock function for option panel
function CombuCautlock()

	if CombuCautlockButton:GetChecked(true) then CombuCautlockvar = true 
                                 CombuCautFrame:EnableMouse(false)
                                 CombuCautlockButton:SetChecked(true)
	else CombuCautlockvar = false 
         CombuCautFrame:EnableMouse(true)
         CombuCautlockButton:SetChecked(false)
	end
end

-------------------------------
-- enable function for option panel
function CombuCautEnable()

	if CombuCautEnableButton:GetChecked(true) then 
		CombuCautenablevar = true 
        CombuCautEnableButton:SetChecked(true)
        CombuCautFrame:Show()
 		CombuCautFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		CombuCautFrame:RegisterEvent("PLAYER_TALENT_UPDATE")

	else CombuCautenablevar = false 
         CombuCautEnableButton:SetChecked(false)
         CombuCautFrame:Hide()
 		 CombuCautFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		 CombuCautFrame:UnregisterEvent("PLAYER_TALENT_UPDATE")
	end
end


-------------------------------
-- hide function for option panel
function CombuCautHide()

	if CombuCautHideButton:GetChecked(true) then CombuCauthidevar = true 
                                 CombuCautHideButton:SetChecked(true)
	else CombuCauthidevar = false 
         CombuCautHideButton:SetChecked(false)
        if CombuCautenablevar == true then
            CombuCautFrame:Show()
        end
	end
end

-------------------------------
-- Timer function for option panel
function CombuCautTimer()

	if CombuCautTimerButton:GetChecked(true) then CombuCautTimevar = true 
                                 CombuCautTimerButton:SetChecked(true)
	else CombuCautTimevar = false 
         CombuCautTimerButton:SetChecked(false)
	end
end


-------------------------------
-- party/raid chat function for option panel
function CombuCautChatRaid()

	if CombuCautAnnounceRaidButton:GetChecked(true) then CombuCautChatRaidvar = true 
                                 CombuCautAnnounceRaidButton:SetChecked(true)
	else CombuCautChatRaidvar = false 
         CombuCautAnnounceRaidButton:SetChecked(false)
	end
end

-------------------------------
-- vicinity chat function for option panel
function CombuCautChatSay()

	if CombuCautAnnounceSayButton:GetChecked(true) then CombuCautChatSayvar = true 
                                 CombuCautAnnounceSayButton:SetChecked(true)
	else CombuCautChatSayvar = false 
         CombuCautAnnounceSayButton:SetChecked(false)
	end
end

-------------------------------
-- yell chat function for option panel
function CombuCautChatYell()

	if CombuCautAnnounceYellButton:GetChecked(true) then CombuCautChatYellvar = true 
                                 CombuCautAnnounceYellButton:SetChecked(true)
	else CombuCautChatYellvar = false 
         CombuCautAnnounceYellButton:SetChecked(false)
	end
end

-------------------------------
-- Alt chat function for option panel
function CombuCautChatAlt()

	if CombuCautAnnounceAltButton:GetChecked(true) then CombuCautChatAltvar = true 
                                 CombuCautAnnounceAltButton:SetChecked(true)
	else CombuCautChatAltvar = false 
         CombuCautAnnounceAltButton:SetChecked(false)
	end
end

-------------------------------
-- Alone chat function for option panel
function CombuCautChatAlone()

	if CombuCautChatAloneButton:GetChecked(true) then CombuCautChatAlonevar = true 
                                 CombuCautChatAloneButton:SetChecked(true)
	else CombuCautChatAlonevar = false 
         CombuCautChatAloneButton:SetChecked(false)
	end
end

-------------------------------
-- Frame resize function
function CombuCautFrameResize()

    CombuCautFrame:SetScale(CombuCautscalevar)
    CombuCautFrame:SetAlpha(CombuCautalphavar)
    CombuCautFrame:SetFrameLevel(CombuCautlevelvar)
    CombuCautTimerText:SetFont("Fonts\\FRIZQT__.TTF", 25*CombuCautFrame:GetScale())
        
end

-------------------------------
-- Reset savedvariables function
function CombuCautreset()

    CombuCautenablevar = true
    CombuCautlockvar = false
    CombuCautlockButton:SetChecked(false)
    CombuCautalphavar = 1
    CombuCautscalevar = 1 
    CombuCautlevelvar = 10
    CombuCauthidevar = false
    CombuCautTimevar = true
    CombuCautChatRaidvar = true
    CombuCautChatSayvar = true
    CombuCautChatYellvar = false
    CombuCautChatAlonevar = true
    CombuCautAnnouncevar = "Cauterizing. Heal me up, please !!"
	CombuCautAnnounceAltvar = "Cauterizing but got Ice Block ready, don't worry."
	CombuCautChatAltvar = false
    CombuCautFrameResize()
    CombuCautFrame:ClearAllPoints() 
    CombuCautFrame:SetPoint("CENTER",UIParent,"CENTER",0,0)
    CombuCautFrame:Show()
    CombuCautlock()
    
end

-------------------------------------------------------------------------------------------------------	
-------------------------------------------------------------------------------------------------------	
-------------------------------- ON_EVENT FUNCTION ----------------------------------------------------

function CombuCaut_OnEvent(self, event, ...)
        
    if (event == "PLAYER_LOGIN") then
        
     	if CombuCautenablevar == true then
            CombuCautFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
        else CombuCautFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
        end
        
        CombuCautFrameResize()

        if (CombuCautlockvar == true) then 
            CombuCautFrame:EnableMouse(false)
        else CombuCautFrame:EnableMouse(true)
        end
        
        CreateFrame("Cooldown","CombuCautCooldown",CombuCautFrame)
		CombuCautCooldown:SetAllPoints(CombuCautFrame)
        CombuCautCooldown.noCooldownCount = true
        CombuCautTextFrame:SetFrameLevel(CombuCautCooldown:GetFrameLevel() + 1)
                   
    end
    
    if (event == "PLAYER_ALIVE") or (event == "PLAYER_TALENT_UPDATE") then
        if (GetPrimaryTalentTree() == 2) and select(5,GetTalentInfo(2,8)) ~= 0 and CombuCautenablevar == true then
            CombuCautFrame:Show()
        else CombuCautFrame:Hide()
        end
        
        if CombuCautCD > 0 then
            CombuCautCooldown:SetCooldown(GetTime() - (60 - CombuCautCD), 60)
        end
        
     end
    
    if (event == "COMBAT_LOG_EVENT_UNFILTERED") then

    	local timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical = select(1, ...)    
        
        if (sourceName == UnitName("player")) and (spellId == 87023) and (event == "SPELL_AURA_APPLIED") then -- cauterize cooldown 
            CombuCautFrame:Show()
            CombuCautCooldown:SetCooldown(GetTime(),60)
            CombuCautCD = 60
            
            if CombuCautChatAlonevar == true and GetNumPartyMembers() == 0 then
        	
        	else 
        		
        		if CombuCautChatAltvar == true and select(2,GetSpellCooldown(45438)) == 0 then
				
					if CombuCautChatRaidvar == true then 
						if GetNumRaidMembers() ~= 0 then 
							SendChatMessage(CombuCautAnnounceAltvar, "RAID")
						elseif GetNumPartyMembers() ~= 0 then 
							SendChatMessage(CombuCautAnnounceAltvar, "PARTY")
						end
					end
					if CombuCautChatSayvar == true then 
						SendChatMessage(CombuCautAnnounceAltvar, "SAY")
					end
					if CombuCautChatYellvar == true then 
						SendChatMessage(CombuCautAnnounceAltvar, "YELL")
					end
					
				else
				
					if CombuCautChatRaidvar == true then 
						if GetNumRaidMembers() ~= 0 then 
							SendChatMessage(CombuCautAnnouncevar, "RAID")
						elseif GetNumPartyMembers() ~= 0 then 
							SendChatMessage(CombuCautAnnouncevar, "PARTY")
						end
					end
					if CombuCautChatSayvar == true then 
						SendChatMessage(CombuCautAnnouncevar, "SAY")
					end
					if CombuCautChatYellvar == true then 
						SendChatMessage(CombuCautAnnouncevar, "YELL")
					end
					
				end
				
			end
			
        end
	end
    
end

-------------------------------------------------------------------------------------------------------	
-------------------------------------------------------------------------------------------------------	
-------------------------------- ON_Update FUNCTION ----------------------------------------------------

function CombuCaut_OnUpdate(self, elapsed)
    self.CombuCautTimeSinceLastUpdate = (self.CombuCautTimeSinceLastUpdate or 0) + elapsed;
    
		if (self.CombuCautTimeSinceLastUpdate > CombuCaut_UpdateInterval) then
        
            if CombuCautCD > 0 then
                
                CombuCautCD = CombuCautCD - 1
                
                if CombuCautTimevar == true then
                	CombuCautTimerText:SetText(format("|cffffff00%.0f|r",CombuCautCD)) 
                else CombuCautTimerText:SetText("")
                end
                
            else CombuCautCD = 0 
            
                CombuCautTimerText:SetText("")
                
                if CombuCauthidevar == true then
                    CombuCautFrame:Hide()
                elseif CombuCautenablevar == true and CombuCautFrame:IsShown() ~= 1 then
                    CombuCautFrame:Show()
                end
                
            end
        
        self.CombuCautTimeSinceLastUpdate = 0

        end
end


--~ SLASH_CombuCautCONFIG1 = "/cauterize"

--~ SlashCmdList["CombuCautCONFIG"] = function(msg)

--~ 	if msg == "" or  msg == "help" or  msg == "?" or msg == "config" then
--~ 		 InterfaceOptionsFrame_OpenToCategory("Cauterize Options")
--~ 	else
--~ 		 InterfaceOptionsFrame_OpenToCategory("Cauterize Options")
--~ 	end

--~ end


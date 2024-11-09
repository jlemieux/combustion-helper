-- start CombuTickManager
-- local function CombuTickManager(event, spellId, spellName)
    
--     if event then
        
--         if event == "SPELL_AURA_APPLIED" then -- adding and remove haste buffs from list depending on events
            
--             if (combuhasteprocs[spellId])[3] == "flat" then
--                 table.insert(combucurrenthasteprocs,1,{spellId,spellName}) -- add flat haste rating to the top of the table
--             else table.insert(combucurrenthasteprocs,{spellId,spellName}) -- add % haste to the bottom of the table
--             end
            
--         elseif event == "SPELL_AURA_REMOVED" then
            
--             for i = 1,#combucurrenthasteprocs do
--                 if (combucurrenthasteprocs[i])[1] == spellId then
                    
--                     _G["CombuProcHasteBlock"..#combucurrenthasteprocs]:Hide()
                                        
--                     table.remove(combucurrenthasteprocs,i)
--                     break
--                 end
--             end
            
--         end
--     end
    
--     combuprevhaste = combucurrenthaste
--     combucurrenthaste = ceil(UnitSpellHaste("player") * 128.05701)
--     combubasehaste = GetCombatRating(20)
--     combuflathastevalue = GetCombatRating(20)+12805.701
    
--     if combuprevhaste ~= combucurrenthaste or event == "SPELL_AURA_APPLIED" then
        
--         if #combucurrenthasteprocs > 0 then
--             for i = 1,#combucurrenthasteprocs do -- assigning info to blocks
                
--                 if not _G["CombuProcHasteBlock"..i] then --print("createblock")
--                     CreateFrame("frame", "CombuProcHasteBlock"..i, CombuTickLayer, "CombuHasteBlockTemplate")
--                     _G["CombuProcHasteBlock"..i]:SetHeight(CombuTickLayerBase:GetHeight())
--                 else _G["CombuProcHasteBlock"..i]:Show()
--                 end
                
--                 if (combuhasteprocs[(combucurrenthasteprocs[i])[1]])[3] == "flat" then
                
--                 --    print(combubasehaste,"1")
--                     combuhasteprocvalue = (combuhasteprocs[(combucurrenthasteprocs[i])[1]])[4]
--                     combubasehaste = combubasehaste - combuhasteprocvalue
--                 --    print(combubasehaste , combuhasteprocvalue)
                    
--                 else combuhasteprocvalue = ceil((combuflathastevalue*(1+((combuhasteprocs[(combucurrenthasteprocs[i])[1]])[4]/100))) - combuflathastevalue)
--                      combuflathastevalue = combuflathastevalue + combuhasteprocvalue
--                 end
                
--                 table.insert(combucurrenthasteprocs[i], combuhasteprocvalue)
                
--              --   print(i,combubasehaste,(combucurrenthasteprocs[i])[2], combuhasteprocvalue)
                
--                 combucurrenthastewidthproc = ceil(CombuTickGlobalBar:GetWidth()*(combuhasteprocvalue/(select(2,CombuTickGlobalBar:GetMinMaxValues()))))
                                
--                 _G["CombuProcHasteBlock"..i]:SetWidth(combucurrenthastewidthproc-1)
--                 _G["CombuProcHasteBlock"..i.."Text1"]:SetWidth(combucurrenthastewidthproc-3)
--                 _G["CombuProcHasteBlock"..i.."Text2"]:SetWidth(combucurrenthastewidthproc-3)
--                 _G["CombuProcHasteBlock"..i.."Text1"]:SetText((combucurrenthasteprocs[i])[2])
--                 _G["CombuProcHasteBlock"..i.."Text2"]:SetText(format("%.0f" ,combuhasteprocvalue))
--                 _G["CombuProcHasteBlock"..i.."Bg"]:SetWidth(combucurrenthastewidthproc-1)
--                 _G["CombuProcHasteBlock"..i.."Bg"]:SetTexture(select(3,GetSpellInfo((combucurrenthasteprocs[i])[1])))
                
--                 if i == 1 then -- stick the block to the previous block
--                     _G["CombuProcHasteBlock"..i]:ClearAllPoints()
--                     _G["CombuProcHasteBlock"..i]:SetPoint("LEFT",CombuTickLayerBase,"RIGHT",1,0)
--                 else _G["CombuProcHasteBlock"..i]:ClearAllPoints()
--                      _G["CombuProcHasteBlock"..i]:SetPoint("LEFT",_G["CombuProcHasteBlock"..i-1],"RIGHT",1,0)
--                 end
                
--             end
--         end
        
--         combubasewidth = CombuTickGlobalBar:GetWidth()*(combubasehaste/(select(2,CombuTickGlobalBar:GetMinMaxValues())))
        
--         CombuTickLayerBaseText1:SetText("Base")
--         CombuTickLayerBaseText2:SetText(combubasehaste)
--         CombuTickLayerBaseText1:SetWidth(combubasewidth-3)
--         CombuTickLayerBaseText2:SetWidth(combubasewidth-3)
--         CombuTickLayerBase:SetWidth(combubasewidth)
--         CombuTickLayerBaseBg:SetWidth(combubasewidth)
        
--         CombuTickGlobalBar:SetValue(combucurrenthaste)
        
--     end
    
--     if #combucurrenthasteprocs > 0 then
        
--         for i = 1,#combucurrenthasteprocs do 
            
--             if select(7,UnitAura("player",(combucurrenthasteprocs[i])[2])) and (combucurrenthasteprocs[i])[3] then 
                
--                 combuhasteproctimer = format("%.1f",(-1*(GetTime() - select(7,UnitAura("player",(combucurrenthasteprocs[i])[2])))))
                
--                 _G["CombuProcHasteBlock"..i.."Text2"]:SetText(format("%.0f - %.1f",(combucurrenthasteprocs[i])[3],combuhasteproctimer))
                
--             end
--         end
--     end

--    -- print(ceil(UnitSpellHaste("player") * 128.05701))
    
-- end -- end CombuTickManager
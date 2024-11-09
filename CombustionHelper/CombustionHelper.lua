CombustionHelper = {} 

LibTransition = LibStub("LibTransition-1.0"); 
CombuLSM = LibStub("LibSharedMedia-3.0") 

Combustion_UpdateInterval = 0.1; -- How often the OnUpdate code will run (in seconds)

local lvb, ffb, ignite, pyro1, pyro2, comb, impact, CritMass, ShadowMast, combulbtimer, combuffbtimer, combupyrotimer, combucrittimer, combupyrocast, combuclientVersion, combucritpredict, combucrittarget
local LBTime,FFBTime, IgnTime, PyroTime, CombustionUp, ffbglyph, combufadeout, ImpactUp, ffbheight, critheight, combucritwidth, lbraidcheck, lbtablerefresh, combuimpacttimer
local combulbrefresh, lbraidcheck, lbtablerefresh, lbgroupsuffix, lbtargetsuffix, lbgroupnumber, lbtrackerheight, combupyrogain, combupyrorefresh, combucolorinstance
local combuignitebank, combuigniteapplied, combuignitevalue, combuignitetemp, combuignitemunched, combuigndamage, combuignitecount
local timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical, combucombustiontimestamp, combucombustiondmg, combucombustionprevdmg, combuticks, combuprevticks, combutickdmg, combutickprevdmg, combuprevtargets, combutargets
local combufirepower, combucriticalmass, combupyrodps, combulbdps, combuhastetick, combucurrenthaste, combucurrentcrit, combuexpecteddmg, combuexpectedtickdmg
local combubasewidth, combunumhasteprocs, combucurrenthasteproc, combucurrenthasteproctimer, combuflathastevalue
function Combustion_OnLoad(Frame) 
                                               
    if select(2, UnitClass("player")) ~= "MAGE" then CombustionFrame:Hide() return end
        
	Frame:RegisterForDrag("LeftButton")
	Frame:RegisterEvent("PLAYER_LOGIN")
	Frame:RegisterEvent("PLAYER_TALENT_UPDATE")
	Frame:RegisterEvent("GLYPH_ADDED")
	Frame:RegisterEvent("GLYPH_REMOVED")
	Frame:RegisterEvent("PLAYER_REGEN_DISABLED")
	Frame:RegisterEvent("PLAYER_REGEN_ENABLED")
 	Frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
 	CombuLSM.RegisterCallback(CombustionHelper , "LibSharedMedia_Registered", "SharedMedia_Registered") 

	CombuLSM:Register("background","Blizzard Tooltip","Interface\\Tooltips\\UI-Tooltip-Background")
	CombuLSM:Register("border","Blizzard Tooltip","Interface\\Tooltips\\UI-Tooltip-Border")
	CombuLSM:Register("border","ElvUI Border","Interface\\AddOns\\CombustionHelper\\Images\\ElvUIBorder")
	CombuLSM:Register("statusbar","CombuBar","Interface\\AddOns\\CombustionHelper\\Images\\combubarblack")
	CombuLSM:Register("sound","CH Volcano","Interface\\AddOns\\CombustionHelper\\Sound\\Volcano.ogg")

    lvb = GetSpellInfo(44457) 
    ffb = GetSpellInfo(44614) 
    ignite = GetSpellInfo(12654) 
    pyro1 = GetSpellInfo(11366) 
    pyro2 = GetSpellInfo(92315) 
    comb = GetSpellInfo(11129)   
    impact = GetSpellInfo(64343)
    CritMass = GetSpellInfo(22959)
    ShadowMast = GetSpellInfo(17800)
    combudot = GetSpellInfo(83853)
    
    LibTransition:Attach(Frame)
    
    CombuLanguageCheck()
	CombuTableCopy()
	CombustionVarReset()
    	
end

local LBtrackertable = {}

local combuhasteplateau = {{0,10},
                            {639,11},
                            {1922,12},
                            {3212,13},
                            {4488,14},
                            {5767,15},
                            {7033,16},
                            {8309,17},
                            {9602,18},
                            {10887,19},
                            {12182,20}}

local combuLBplateau = {{0,4},
                        {1602,5},
                        {4805,6},
                        {8000,7},
                        {11198,8},
                        {14412,9},
                        {17600,10}}                        

local combuhasteprocs = {[109844] = {78477,"haste","flat",2175,60,10}, -- problem with staff wielder buff and people buff
                            [107804] = {77190,"haste","flat",1928,60,10},-- problem with staff wielder buff and people buff
                            [109842] = {78486,"haste","flat",1707,60,10},-- problem with staff wielder buff and people buff
                            [109789] = {77991,"haste","flat",3278,100,20},
                            [107982] = {77203,"haste","flat",2904,100,20},
                            [109787] = {77971,"haste","flat",2573,100,20},
                            [109804] = {77989,"haste","flat",3278,100,20},
                            [90887] = {56320,"haste","flat",1710,75,15},
                            [90885] = {55787,"haste","flat",918,75,15},
                            [59626] = {3790,"haste","flat",250,35,10},
                            [74221] = {4083,"haste","flat",450,45,12},
                            [80353] = {0000,"haste","percent",30,600,40}, --time warp
                            [2825] = {0000,"haste","percent",30,600,40}, --bloodlust                            
                            [32182] = {0000,"haste","percent",30,600,40}, --heroism
                            [44403] = {0000,"haste","percent",3}} --netherwind presence rank 3                            
                            
local combucurrenthasteprocs = {}
                            
combudefaultsettingstable = {["combulock"] = false,
							["combuffb"] = true,
							["combuautohide"] = 1,
							["combuimpact"] = true,
							["combuscale"] = 1,
							["combubeforefade"] = 15,
							["combuafterfade"] = 15,
							["combufadeoutspeed"] = 2,
							["combufadeinspeed"] = 2,
							["combuwaitfade"] = 86,
							["combufadealpha"] = 0,
							["combubartimers"] = false,
							["combucrit"] = true,
							["comburefreshmode"] = true,
							["combureport"] = true,
							["combureportvalue"] = 0,
							["combureportthreshold"] = false,
							["combureportpyro"] = true,
							["combutrack"] = true,
							["combuchat"] = true,
							["combulbtracker"] = true,
							["combubarwidth"] = 24,
							["combulbup"] = true,
							["combulbdown"] = false,
							["combulbright"] = false,
							["combulbleft"] = false,
							["combulbtarget"] = true,
							["combutimervalue"] = 2,
							["combuignitereport"] = true,
							["combuignitedelta"] = 0,
							["combuignitepredict"] = true,
							["combureportmunching"] = true,
							["combuflamestrike"] = true,
							["combutexturename"] = "CombuBar",
							["combufontname"] = "Friz Quadrata TT",
							["combusoundname"] = "CombustionHelper Volcano",
							["barcolornormal"] = {0,0.5,0.8,1},
							["barcolorwarning"] = {1,0,0,1},
							["textcolornormal"] = {1,1,1,1},
							["textcolorwarning"] = {1,0,0,1},
							["textcolorvalid"] = {0,1,0,1},
							["buttontexturewarning"] = "Interface\AddOns\CombustionHelper\Images\Combustionoff",
							["buttontexturevalid"] = "Interface\AddOns\CombustionHelper\Images\Combustionon",
							["bgcolornormal"] = {0.25,0.25,0.25,1},
							["bgcolorimpact"] = {1,0.82,0,0.5},
							["bgcolorcombustion"] = {0,0.7,0,0.5},
							["edgecolornormal"] = {0.67,0.67,0.67,1},
							["bgFile"] = "Blizzard Tooltip",
                        	["tileSize"] = 16,
                        	["edgeFile"] = "Blizzard Tooltip",
                        	["tile"] = true,
                        	["edgeSize"] = 16,
                        	["insets"] = 5,
                            ["language"] = "Default",
                            ["thresholdalert"] = true,
                            ["combuticktexturename"] = "CombuBar",
                            ["combutickpredict"] = true,
}
function CombuLanguageCheck()

    if combusettingstable then 
    
        if combusettingstable["language"] == "Francais" or combusettingstable["language"] == "Default" and GetLocale() == "frFR" then

            CombuLoc = CombuLocFR
            combuoptioninfotable = combuoptioninfotableFR
            CombuOptLoc = CombuOptLocFR
            CombuLBposition = CombuLBpositionFR
            CombuAutohideList = CombuAutohideListFR
            CombuLabel = CombuLabelFR
                
        elseif combusettingstable["language"] == "Deutsch" or combusettingstable["language"] == "Default" and GetLocale() == "deDE" then
            
            CombuLoc = CombuLocDE
            combuoptioninfotable = combuoptioninfotableDE
            CombuOptLoc = CombuOptLocDE
            CombuLBposition = CombuLBpositionDE
            CombuAutohideList = CombuAutohideListDE
            CombuLabel = CombuLabelDE
            
        elseif combusettingstable["language"] == "Chinese" or combusettingstable["language"] == "Default" and GetLocale() == "zhTW" then
            
            CombuLoc = CombuLocTW
            combuoptioninfotable = combuoptioninfotableTW
            CombuOptLoc = CombuOptLocTW
            CombuLBposition = CombuLBpositionTW
            CombuAutohideList = CombuAutohideListTW
            CombuLabel = CombuLabelTW

        else CombuLoc = CombuLocEN
            combuoptioninfotable = combuoptioninfotableEN
            CombuOptLoc = CombuOptLocEN
            CombuLBposition = CombuLBpositionEN
            CombuAutohideList = CombuAutohideListEN
            CombuLabel = CombuLabelEN

        end
    else CombuLoc = CombuLocEN
        combuoptioninfotable = combuoptioninfotableEN
        CombuOptLoc = CombuOptLocEN
        CombuLBposition = CombuLBpositionEN
        CombuAutohideList = CombuAutohideListEN
        CombuLabel = CombuLabelEN
        
   end

end

function CombuTableCopy()

	combusettingstable = {}
	
	for k,v in pairs(combudefaultsettingstable) do 
		if type(v) == "table" then
			combusettingstable[k] = {}
			for i = 1,#v do
				table.insert(combusettingstable[k],v[i])
			end
		else combusettingstable[k] = v 
		end
	end
    
end

function CombuTableNewSettingsCheck()
	    
 	for k,v in pairs(combudefaultsettingstable) do 
         
         if combusettingstable[k] == nil then print(k) combuprut = 1
        
            if type(v) == "table" then

                combusettingstable[k] = {}
                for i = 1,#v do
                    table.insert(combusettingstable[k],v[i])
                end
            else combusettingstable[k] = v   

            end
        end
	end
end

----------------------------------
-- Helper function to reset some variables
function CombustionVarReset()

	combupyrogain = 0 -- variables related to post fight report
   	combupyrorefresh = 0
   	combupyrocast = 0
   	combulbrefresh = 0
   	
   	combuignitebank = 0 -- variables related to ignite
    combuigniteapplied = 0
    combuignitevalue = 0
    combuignitetemp = 0
    combuignitemunched = 0
    combuigndamage = 0
    combuignitecount = 0
    
end

--------------------------------
-- Helper function for Sharemedia support
function CombustionHelper:SharedMedia_Registered()
--	print("prut")
    -- do whatever needs to be done to repaint / refont
end

-------------------------------
-- helper function for option panel setup
function CombustionHelperOptions_OnLoad(panel)
    CombuLanguageCheck()
	panel.name = "CombustionHelper"
	InterfaceOptions_AddCategory(panel);
end

-------------------------------
-- helper function for customisation option panel setup
function CombustionHelperCustomOptions_OnLoad(panel)
    CombuLanguageCheck()
	panel.name = CombuLoc["interfaceGraph"]
	panel.parent = "CombustionHelper"
	InterfaceOptions_AddCategory(panel);
end

-------------------------------
-- helper function for tick option panel setup
function CombustionHelperTickOptions_OnLoad(panel)
    CombuLanguageCheck()
	panel.name = "tick bar" --CombuLoc["interfaceGraph"]
	panel.parent = "CombustionHelper"
	InterfaceOptions_AddCategory(panel);
end

-------------------------------
-- lock function for option panel
function Combustionlock()

	if CombulockButton:GetChecked(true) then combusettingstable["combulock"] = true 
                                 CombustionFrame:EnableMouse(false)
                                 CombulockButton:SetChecked(true)
                                 if (combusettingstable["combuchat"]==true) then ChatFrame1:AddMessage(CombuLoc["lockon"]) end
	else combusettingstable["combulock"] = false 
         CombustionFrame:EnableMouse(true)
         CombulockButton:SetChecked(false)
         if (combusettingstable["combuchat"]==true) then ChatFrame1:AddMessage(CombuLoc["lockoff"]) end
	end
end

-------------------------------
-- chat function for option panel
function Combustionchat()

	if CombuchatButton:GetChecked(true) then combusettingstable["combuchat"] = true 
                                 CombuchatButton:SetChecked(true)
                                 ChatFrame1:AddMessage(CombuLoc["reporton"])
	else combusettingstable["combuchat"] = false 
         CombuchatButton:SetChecked(false)
	end
end

-------------------------------
-- threshold sound function for option panel
function CombustionThresholdSound()

	if CombuThresholdSoundButton:GetChecked(true) then combusettingstable["thresholdalert"] = true 
                                 CombuThresholdSoundButton:SetChecked(true)
	else combusettingstable["thresholdalert"] = false 
         CombuThresholdSoundButton:SetChecked(false)
	end
end

-------------------------------
-- threshold function for option panel
function Combustionthreshold()

	if Combureportthreshold:GetChecked(true) then combusettingstable["combureportthreshold"] = true 
                                 Combureportthreshold:SetChecked(true)
	else combusettingstable["combureportthreshold"] = false 
         Combureportthreshold:SetChecked(false)
	end
end

-------------------------------
-- threshold function for option panel
function CombustionTickPredict()

	if CombuTickPredictButton:GetChecked(true) then combusettingstable["combutickpredict"] = true 
                                 CombuTickPredictButton:SetChecked(true)
	else combusettingstable["combutickpredict"] = false 
         CombuTickPredictButton:SetChecked(false)
	end
end

-------------------------------
-- ffb function for option panel
function Combustionffb()

	if CombuffbButton:GetChecked(true) then combusettingstable["combuffb"] = true 
                                 CombuffbButton:SetChecked(true)
                                 if (combusettingstable["combuchat"]==true) then ChatFrame1:AddMessage(CombuLoc["ffbon"]) end
	else combusettingstable["combuffb"] = false 
         CombuffbButton:SetChecked(false)
         if (combusettingstable["combuchat"]==true) then ChatFrame1:AddMessage(CombuLoc["ffboff"]) end
	end
    CombustionFrameresize()
end

-------------------------------
-- DPS Report function for option panel
function Combustionreport()

	if CombureportButton:GetChecked(true) then combusettingstable["combureport"] = true 
                                             CombureportButton:SetChecked(true)
                                             if (combusettingstable["combuchat"]==true) then ChatFrame1:AddMessage(CombuLoc["dmgreporton"]) end
	else combusettingstable["combureport"] = false 
         CombureportButton:SetChecked(false)
         if (combusettingstable["combuchat"]==true) then ChatFrame1:AddMessage(CombuLoc["dmgreportoff"]) end
	end
end

-------------------------------
-- combustion dot tracker function for option panel
function Combustiontracker()

	if CombutrackerButton:GetChecked(true) then combusettingstable["combutrack"] = true 
                                             CombutrackerButton:SetChecked(true)
                                             if (combusettingstable["combuchat"]==true) then ChatFrame1:AddMessage(CombuLoc["doton"]) end
	else combusettingstable["combutrack"] = false 
         CombutrackerButton:SetChecked(false)
         if (combusettingstable["combuchat"]==true) then ChatFrame1:AddMessage(CombuLoc["dotoff"]) end
	end
end

-------------------------------
-- lb refresh function for option panel
function Combustionrefresh()

	if ComburefreshButton:GetChecked(true) then combusettingstable["comburefreshmode"] = true 
                                                ComburefreshButton:SetChecked(true)
                                                if (combusettingstable["combuchat"]==true) then ChatFrame1:AddMessage(CombuLoc["lbon"]) end
	else combusettingstable["comburefreshmode"] = false 
         ComburefreshButton:SetChecked(false)
         if (combusettingstable["combuchat"]==true) then ChatFrame1:AddMessage(CombuLoc["lboff"]) end
	end
end

-------------------------------
-- pyro refresh function for option panel
function CombustionrefreshPyro()

	if ComburefreshpyroButton:GetChecked(true) then combusettingstable["combureportpyro"] = true 
                                                ComburefreshpyroButton:SetChecked(true)
                                                if (combusettingstable["combuchat"]==true) then ChatFrame1:AddMessage(CombuLoc["pyroon"]) end
	else combusettingstable["combureportpyro"] = false 
         ComburefreshpyroButton:SetChecked(false)
         if (combusettingstable["combuchat"]==true) then ChatFrame1:AddMessage(CombuLoc["pyrooff"]) end
	end
end

-------------------------------
-- impact function for option panel
function Combustionimpact()

	if CombuimpactButton:GetChecked(true) then combusettingstable["combuimpact"] = true 
                                               CombuimpactButton:SetChecked(true)
                                               if (combusettingstable["combuchat"]==true) then ChatFrame1:AddMessage(CombuLoc["impacton"]) end
	else combusettingstable["combuimpact"] = false 
         CombuimpactButton:SetChecked(false)
         if (combusettingstable["combuchat"]==true) then ChatFrame1:AddMessage(CombuLoc["impactoff"]) end
	end
end

-------------------------------
-- Scale function for option panel
function CombustionScale (scale)

	CombustionFrame:SetScale(scale)
	combusettingstable["combuscale"] = scale
end

-------------------------------
-- Bar timer function for option panel
function Combustionbar()

	if CombuBarButton:GetChecked(true) then combusettingstable["combubartimers"] = true 
                                            CombuBarButton:SetChecked(true)
                                            if (combusettingstable["combuchat"]==true) then ChatFrame1:AddMessage(CombuLoc["baron"]) end
	else combusettingstable["combubartimers"] = false 
         CombuBarButton:SetChecked(false)
         if (combusettingstable["combuchat"]==true) then ChatFrame1:AddMessage(CombuLoc["baroff"]) end
	end
    CombustionFrameresize()
end

-------------------------------
-- Critical Mass function for option panel
function Combustioncrit()

	if CombucritButton:GetChecked(true) then combusettingstable["combucrit"] = true 
                                             CombucritButton:SetChecked(true)
                                             if (combusettingstable["combuchat"]==true) then ChatFrame1:AddMessage(CombuLoc["criton"]) end
	else combusettingstable["combucrit"] = false 
         CombucritButton:SetChecked(false)
         if (combusettingstable["combuchat"]==true) then ChatFrame1:AddMessage(CombuLoc["critoff"]) end
	end
    CombustionFrameresize()
end

-------------------------------
-- Ignite beta predicter function for option panel
function CombustionIgnitePredict()

	if CombuIgnitePredictButton:GetChecked(true) then combusettingstable["combuignitepredict"] = true 
                                             CombuIgnitePredictButton:SetChecked(true)
                                             if (combusettingstable["combuchat"]==true) then ChatFrame1:AddMessage(CombuLoc["ignpredon"]) end
	else combusettingstable["combuignitepredict"] = false 
         CombuIgnitePredictButton:SetChecked(false)
         if (combusettingstable["combuchat"]==true) then ChatFrame1:AddMessage(CombuLoc["ignpredoff"]) end
	end
end

-------------------------------
-- living bomb tracker target mode function for option panel
function CombustionFlamestrike()

	if CombuFlamestrikeButton:GetChecked(true) then combusettingstable["combuflamestrike"] = true 
                                                 	CombuFlamestrikeButton:SetChecked(true)
                                             		if (combusettingstable["combuchat"]==true) then ChatFrame1:AddMessage(CombuLoc["fson"]) end
	else combusettingstable["combuflamestrike"] = false 
         CombuFlamestrikeButton:SetChecked(false)
         if (combusettingstable["combuchat"]==true) then ChatFrame1:AddMessage(CombuLoc["fsoff"]) end
	end
end

-------------------------------
-- living bomb tracker target mode function for option panel
function CombustionMunching()

	if CombuMunchingButton:GetChecked(true) then combusettingstable["combureportmunching"] = true 
                                                 CombuMunchingButton:SetChecked(true)
                                             	 if (combusettingstable["combuchat"]==true) then ChatFrame1:AddMessage(CombuLoc["munchon"]) end
	else combusettingstable["combureportmunching"] = false 
         CombuMunchingButton:SetChecked(false)
         if (combusettingstable["combuchat"]==true) then ChatFrame1:AddMessage(CombuLoc["munchoff"]) end
	end
end

-------------------------------
-- living bomb tracker target mode function for option panel
function CombustionLBtargettracker()

	if CombuLBtargetButton:GetChecked(true) then combusettingstable["combulbtarget"] = true 
                                                 CombuLBtargetButton:SetChecked(true)
	else combusettingstable["combulbtarget"] = false 
         CombuLBtargetButton:SetChecked(false)
	end
end

-------------------------------
-- Multiple Living Bomb tracker function for option panel
function CombustionLBtracker()

	if CombuLBtrackerButton:GetChecked(true) then combusettingstable["combulbtracker"] = true 
                                             CombuLBtrackerButton:SetChecked(true)
                                             if (combusettingstable["combuchat"]==true) then ChatFrame1:AddMessage(CombuLoc["lbtrackon"]) end
	else combusettingstable["combulbtracker"] = false 
         CombuLBtrackerButton:SetChecked(false)
         table.wipe(LBtrackertable)
         if (combusettingstable["combuchat"]==true) then ChatFrame1:AddMessage(CombuLoc["lbtrackoff"]) end
	end
    CombustionFrameresize()
end

local combuwidgetlist = {
	
	bars = {"LBtrack1Bar","LBtrack2Bar","LBtrack3Bar","LBtrack4Bar","LBtrack5Bar","FFBbar","Pyrobar","Ignbar","LBbar","Combubar","Critbar"},
	text = {"LBtrack1","LBtrack1Timer","LBtrack2","LBtrack2Timer","LBtrack3","LBtrack3Timer","LBtrack4","LBtrack4Timer","LBtrack5","LBtrack5Timer",
			"LBLabel","IgniteLabel","PyroLabel","FFBLabel","LBTextFrameLabel","IgnTextFrameLabel","PyroTextFrameLabel","FFBTextFrameLabel",
			"StatusTextFrameLabel","CritTypeFrameLabel","CritTextFrameLabel"},
}

function CombuBackdropBuild ()

	if not CombuBackdrop then
	
		CombuBackdrop = {bgFile="Interface\\Tooltips\\UI-Tooltip-Background",
                        tileSize=16,
                        edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",
                        tile=true,
                        edgeSize=16,
                        insets={
                          top=5,
                          right=5,
                          left=5,
                          bottom=5}}
    end

    if combusettingstable then
        CombuBackdrop["bgFile"] = CombuLSM:Fetch("background",combusettingstable["bgFile"])
        CombuBackdrop["tileSize"] = combusettingstable["tileSize"]
        CombuBackdrop["edgeFile"] = CombuLSM:Fetch("border",combusettingstable["edgeFile"])
        CombuBackdrop["tile"] = combusettingstable["tile"]
        CombuBackdrop["edgeSize"] = combusettingstable["edgeSize"];
        (CombuBackdrop["insets"])["top"] = combusettingstable["insets"];
        (CombuBackdrop["insets"])["right"] = combusettingstable["insets"];
        (CombuBackdrop["insets"])["left"] = combusettingstable["insets"];
        (CombuBackdrop["insets"])["bottom"] = combusettingstable["insets"]
    end
    
    CombustionFrame:SetBackdrop(CombuBackdrop)
    CombustionFrame:SetBackdropColor(unpack(combusettingstable["bgcolornormal"]))
    CombustionFrame:SetBackdropBorderColor(unpack(combusettingstable["edgecolornormal"]))
    LBtrackFrame:SetBackdrop(CombuBackdrop)
    LBtrackFrame:SetBackdropColor(unpack(combusettingstable["bgcolornormal"]))
    LBtrackFrame:SetBackdropBorderColor(unpack(combusettingstable["edgecolornormal"]))

end
			
-------------------------------
-- Helper function for frame resizing
function CombustionFrameresize()
	
    if (combusettingstable["combuffb"] == true) and (ffbglyph == true) then 
    	FFBButton:Show()
        FFBTextFrameLabel:Show()
        FFBLabel:Show()
        StatusTextFrameLabel:SetPoint("TOPLEFT",FFBLabel,"BOTTOMLEFT",0,0)
        ffbheight = 9
    else FFBButton:Hide()
         FFBTextFrameLabel:Hide()
         FFBLabel:Hide()
         StatusTextFrameLabel:SetPoint("TOPLEFT",PyroLabel,"BOTTOMLEFT",0,0)
         ffbheight = 0	
    end

    if (combusettingstable["combucrit"] == true) then 
    	CritTypeFrameLabel:Show()
        CritTypeFrameLabel:SetPoint("TOPLEFT",StatusTextFrameLabel,"BOTTOMLEFT",0,0)
        CritTextFrameLabel:Show()
        CritTextFrameLabel:SetPoint("TOPLEFT",StatusTextFrameLabel,"BOTTOMLEFT",0,0)
        critheight = 9
    else CritTypeFrameLabel:Hide()
         CritTypeFrameLabel:SetPoint("TOPLEFT",StatusTextFrameLabel,"BOTTOMLEFT",0,0)
         CritTextFrameLabel:Hide()
         CritTextFrameLabel:SetPoint("TOPLEFT",StatusTextFrameLabel,"BOTTOMLEFT",0,0)
         Critbar:Hide()
         critheight = 0
    end    
    
    CombustionFrame:SetHeight(48+ffbheight+critheight)

	if (combusettingstable["combubartimers"] == true) 
	then CombustionFrame:SetWidth(98+combusettingstable["combubarwidth"]+6)
		 CombustionTextFrame:SetWidth(98+combusettingstable["combubarwidth"]+6)
		 FFBTextFrameLabel:SetWidth(28+combusettingstable["combubarwidth"]+2)
		 FFBTextFrameLabel:SetJustifyH("RIGHT")
		 LBTextFrameLabel:SetWidth(28+combusettingstable["combubarwidth"]+2)
		 LBTextFrameLabel:SetJustifyH("RIGHT")
		 PyroTextFrameLabel:SetWidth(28+combusettingstable["combubarwidth"]+2)
		 PyroTextFrameLabel:SetJustifyH("RIGHT")
		 IgnTextFrameLabel:SetWidth(28+combusettingstable["combubarwidth"]+2)
		 IgnTextFrameLabel:SetJustifyH("RIGHT")
		 CritTextFrameLabel:SetWidth(91+combusettingstable["combubarwidth"]+2)
         combucritwidth = combusettingstable["combubarwidth"]
	else combucritwidth = (-7)
         CombustionFrame:SetWidth(98)
         CombustionTextFrame:SetWidth(98)
		 FFBTextFrameLabel:SetWidth(28)
		 FFBbar:Hide()
		 FFBTextFrameLabel:SetJustifyH("LEFT")
		 LBTextFrameLabel:SetWidth(28)
		 LBbar:Hide()
		 LBTextFrameLabel:SetJustifyH("LEFT")
		 PyroTextFrameLabel:SetWidth(28)
		 Pyrobar:Hide()
		 PyroTextFrameLabel:SetJustifyH("LEFT")
		 Ignbar:Hide()
		 IgnTextFrameLabel:SetWidth(28)
		 IgnTextFrameLabel:SetJustifyH("LEFT")
		 CritTextFrameLabel:SetWidth(86)
	end
	
	Critbar:SetMinMaxValues(0,92+combucritwidth)
	Critbar:SetWidth(92+combucritwidth)
	Combubar:SetMinMaxValues(0,92+combucritwidth)
	Combubar:SetWidth(92+combucritwidth)
	LBbar:SetMinMaxValues(0,28+combusettingstable["combubarwidth"])
	LBbar:SetWidth(28+combusettingstable["combubarwidth"])
	Ignbar:SetMinMaxValues(0,28+combusettingstable["combubarwidth"])
	Ignbar:SetWidth(28+combusettingstable["combubarwidth"])
	Pyrobar:SetMinMaxValues(0,28+combusettingstable["combubarwidth"])
	Pyrobar:SetWidth(28+combusettingstable["combubarwidth"])
	FFBbar:SetMinMaxValues(0,28+combusettingstable["combubarwidth"])
	FFBbar:SetWidth(28+combusettingstable["combubarwidth"])
	
	if (combusettingstable["combulbtracker"] == true) then 
		
		LBtrackFrame:Show()
        LBtrackFrame:SetFrameLevel((CombustionFrame:GetFrameLevel())-1)
        LBtrackFrame:ClearAllPoints()

        if (combusettingstable["combulbup"] == true)
            then LBtrackFrame:SetPoint("BOTTOM",CombustionFrame,"TOP",0,-6)
                 LBtrackFrame:SetWidth((CombustionFrame:GetWidth())-10)
        elseif (combusettingstable["combulbdown"] == true)
            then LBtrackFrame:SetPoint("TOP",CombustionFrame,"BOTTOM",0,6)
                 LBtrackFrame:SetWidth((CombustionFrame:GetWidth())-10)
        elseif (combusettingstable["combulbright"] == true)
            then LBtrackFrame:SetWidth(88)
                 LBtrackFrame:SetPoint("TOPLEFT",CombustionFrame,"TOPRIGHT",-6,0)
        elseif (combusettingstable["combulbleft"] == true)
            then LBtrackFrame:SetWidth(88)
                 LBtrackFrame:SetPoint("TOPRIGHT",CombustionFrame,"TOPLEFT",6,0)
        end
        
        LBtrackFrameText:SetWidth(LBtrackFrame:GetWidth())
        LBtrackFrameText:SetPoint("TOPLEFT",LBtrackFrame,"TOPLEFT",0,0)
        
    else LBtrackFrame:Hide()
	end
    
    for i = 1,5 do _G["LBtrack"..i]:SetWidth(LBtrackFrame:GetWidth()-41) end
    for i = 1,5 do _G["LBtrack"..i.."Bar"]:SetWidth(LBtrackFrame:GetWidth()-12) end
    for i = 1,5 do _G["LBtrack"..i.."Bar"]:SetMinMaxValues(0,LBtrackFrame:GetWidth()-12) end
    for i = 1,#combuwidgetlist["bars"] do _G[(combuwidgetlist["bars"])[i]]:SetStatusBarTexture(CombuLSM:Fetch("statusbar",combusettingstable["combutexturename"])) end
    for i = 1,#combuwidgetlist["text"] do 	_G[(combuwidgetlist["text"])[i]]:SetFont(CombuLSM:Fetch("font",combusettingstable["combufontname"]),select(2,_G[(combuwidgetlist["text"])[i]]:GetFont())) 
    end   

	CombuBackdropBuild ()

    --------------------------------------------
    --part for tick manager
    
    --CombuTickGlobalBar:SetStatusBarTexture(CombuLSM:Fetch("statusbar",combusettingstable["combuticktexturename"]))
    
end

function Combustionreset ()

        table.wipe(LibTransition.tQueue) table.wipe(LibTransition.cQueue)
		CombustionFrame:FadeIn(combusettingstable["combufadeinspeed"])
        CombustionFrame:ClearAllPoints()
        CombustionFrame:SetPoint("CENTER", UIParent, "CENTER" ,0,0)
        CombustionFrame:SetScale(1)
        
        CombuTableCopy()
		
        ChatFrame1:AddMessage(CombuLoc["reset"])
        CombustionFrameresize()
        Combustionlock ()

end
	
function CombuColorPicker(value, changedCallback)

local r, g, b, a = unpack(value)

 ColorPickerFrame:SetColorRGB(r,g,b);
 ColorPickerFrame.hasOpacity, ColorPickerFrame.opacity = (a ~= nil), a;
 ColorPickerFrame.previousValues = {r,g,b,a};
 ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc = 
  changedCallback, changedCallback, changedCallback;
 ColorPickerFrame:Hide(); -- Need to run the OnShow handler.
 ColorPickerFrame:Show();
end

function CombuColorCallback(restore)
 local newR, newG, newB, newA;
 if restore then
  newR, newG, newB, newA = unpack(restore);
 else
  newA, newR, newG, newB = OpacitySliderFrame:GetValue(), ColorPickerFrame:GetColorRGB();
 end
 
 (combusettingstable[combucolorinstance])[1], (combusettingstable[combucolorinstance])[2], (combusettingstable[combucolorinstance])[3], (combusettingstable[combucolorinstance])[4] = newR, newG, newB, newA;
 _G["Combu"..combucolorinstance.."SwatchTexture"]:SetVertexColor(unpack(combusettingstable[combucolorinstance]))
end

function CombuSavedVariablesConvert ()

    if combuffb then combusettingstable["combuffb"] = combuffb end
    if combuautohide then combusettingstable["combuautohide"] = combuautohide end
    if combuimpact then combusettingstable["combuimpact"] = combuimpact end
    if combuscale then combusettingstable["combuscale"] = combuscale end
    if combubeforefade then combusettingstable["combubeforefade"] = combubeforefade end
    if combuafterfade then combusettingstable["combuafterfade"] = combuafterfade end
    if combufadeoutspeed then combusettingstable["combufadeoutspeed"] = combufadeoutspeed end
    if combufadeinspeed then combusettingstable["combufadeinspeed"] = combufadeinspeed end
    if combuwaitfade then combusettingstable["combuwaitfade"] = combuwaitfade end
    if combufadealpha then combusettingstable["combufadealpha"] = combufadealpha end
    if combubartimers then combusettingstable["combubartimers"] = combubartimers end
	if combubarwidth then combusettingstable["combubarwidth"] = combubarwidth end
	if combucrit then combusettingstable["combucrit"] = combucrit end
	if comburefreshmode then combusettingstable["comburefreshmode"] = comburefreshmode end
    if combureport then combusettingstable["combureport"] = combureport end
    if combureportvalue then combusettingstable["combureportvalue"] = combureportvalue end
    if combureportthreshold then combusettingstable["combureportthreshold"] = combureportthreshold end
    if combureportpyro then combusettingstable["combureportpyro"] = combureportpyro end
    if combutrack then combusettingstable["combutrack"] = combutrack end
    if combuchat then combusettingstable["combuchat"] = combuchat end
    if combulbtracker then combusettingstable["combulbtracker"] = combulbtracker end
    if combulbtarget then combusettingstable["combulbtarget"] = combulbtarget end
    if combulbup then combusettingstable["combulbup"] = combulbup end
    if combulbdown then combusettingstable["combulbdown"] = combulbdown end
    if combulbright then combusettingstable["combulbright"] = combulbup end
    if combulbleft then combusettingstable["combulbleft"] = combulbleft end
    if combutimervalue then combusettingstable["combutimervalue"] = combutimervalue end
    if combuignitereport then combusettingstable["combuignitereport"] = combuignitereport end
    if combuignitedelta then combusettingstable["combuignitedelta"] = combuignitedelta end
    if combuignitepredict then combusettingstable["combuignitepredict"] = combuignitepredict end
    if combureportmunching then combusettingstable["combureportmunching"] = combureportmunching end
    if combuflamestrike then combusettingstable["combuflamestrike"] = combuflamestrike end
    if combutexturename then combusettingstable["combutexturename"] = combutexturename end
    if combufontname then combusettingstable["combufontname"] = combufontname end
		
	for k,v in pairs(combudefaultsettingstable) do -- fill the combusettingstable with missing info from default table
		if combusettingstable[k] == nil then 
			if type(v) == "table" then
				combusettingstable[k] = {}
				for i = 1,#v do
					table.insert(combusettingstable[k],v[i])
				end
			else combusettingstable[k] = v 
			end
		end
	end

	
	
end

local function Combuffbglyphcheck ()

        local enabled1,_,_,id1 = GetGlyphSocketInfo(7)
        local enabled4,_,_,id4 = GetGlyphSocketInfo(8)
        local enabled6,_,_,id6 = GetGlyphSocketInfo(9)
         
	            if (id1 == 61205) and (ffbglyph == false) and (combutalent == true) 
	            then ffbglyph = true
                     combusettingstable["combuffb"] = true
    	       		 CombustionFrameresize()
	                 if (combusettingstable["combuchat"]==true) then ChatFrame1:AddMessage(CombuLoc["ffbglyphon"]) end
	            
	            elseif (id4 == 61205) and (ffbglyph == false) and (combutalent == true) 
	            then ffbglyph = true
                     combusettingstable["combuffb"] = true
    	       		 CombustionFrameresize()
	                 if (combusettingstable["combuchat"]==true) then ChatFrame1:AddMessage(CombuLoc["ffbglyphon"]) end
	            
	            elseif (id6 == 61205) and (ffbglyph == false) and (combutalent == true) 
	            then ffbglyph = true
                     combusettingstable["combuffb"] = true
    	       		 CombustionFrameresize()
	                 if (combusettingstable["combuchat"]==true) then ChatFrame1:AddMessage(CombuLoc["ffbglyphon"]) end
				
				elseif (id1 ~= 61205) and (id4 ~= 61205) and (id6 ~= 61205) and (ffbglyph == true) and (combutalent == true)
				then ffbglyph = false
					 CombustionFrameresize()
	                 if (combusettingstable["combuchat"]==true) then ChatFrame1:AddMessage(CombuLoc["ffbglyphoff"]) end
	            
                elseif (id1 ~= 61205) and (id4 ~= 61205) and (id6 ~= 61205) and (combusettingstable["combuffb"] == true) 
				then ffbglyph = false
					 CombustionFrameresize()
	                 if (combusettingstable["combuchat"]==true) then ChatFrame1:AddMessage(CombuLoc["ffbglyphoff"]) end

                elseif (ffbglyph == false)
	            then CombustionFrameresize()

            	end 
end

local CombuCritMeta = {
	34220, -- burning crusade
	41285, -- wrath of the lich king
	52291, -- cataclysm
    68780
};

function CombuCreateTextureList(dropdown, settings)

    combutexturesettings = settings
    combutexturedropdown = dropdown
    
    CombuTextureList = {} for k in pairs(CombuLSM:HashTable("statusbar")) do tinsert(CombuTextureList,k) end
    
    CombuTextureBorderFrame:Show()
    CombuTextureBorderFrame:ClearAllPoints()
    CombuTextureFrame:SetHeight(#CombuTextureList*20)
    CombuTextureBorderFrame:SetPoint("CENTER",dropdown,"CENTER",0,0-(CombuTextureFrame:GetHeight()/4))
    CombuTextureBorderFrame:SetParent(dropdown)
    CombuTextureBorderFrame:SetFrameLevel(_G[dropdown:GetName().."Button"]:GetFrameLevel()+1)
    CombuTextureBorderFrame:SetScale(1.3)
    
    for i = 1,#CombuTextureList do
    
        CreateFrame("button", "CombuTexture"..i, CombuTextureFrame, "CombuTextureTemplate")
        
        if i == 1 then
            CombuTexture1:ClearAllPoints()
            CombuTexture1:SetPoint("TOP",CombuTextureFrame,"TOP",0,0)
        else _G["CombuTexture"..i]:ClearAllPoints()
             _G["CombuTexture"..i]:SetPoint("TOP",_G["CombuTexture"..i-1],"BOTTOM",0,0)
        end
        
        _G["CombuTexture"..i.."Bar"]:SetTexture(CombuLSM:Fetch("statusbar",CombuTextureList[i]))
        _G["CombuTexture"..i.."Bar"]:SetVertexColor(unpack(combusettingstable["barcolornormal"]))
        _G["CombuTexture"..i.."Text"]:SetText(CombuTextureList[i])
        
        if (CombuTextureList[i]) == combusettingstable[settings] then
            _G["CombuTexture"..i.."Text"]:SetTextColor(1,0.8,0.2,1)
        else _G["CombuTexture"..i.."Text"]:SetTextColor(1,1,1,1)
        end
    
    end
    
end
            
function CombuCreateFontList()

    CombuFontList = {} for k in pairs(CombuLSM:HashTable("font")) do tinsert(CombuFontList,k) end
    
    CombuFontBorderFrame:Show()
    CombuFontBorderFrame:ClearAllPoints()
    CombuFontFrame:SetHeight(#CombuFontList*15)
    CombuFontBorderFrame:SetPoint("CENTER",CombuFontDropDown,"CENTER",0,0-(CombuFontFrame:GetHeight()/4))
    CombuFontBorderFrame:SetParent(CombuFontDropDown)
    CombuFontBorderFrame:SetFrameLevel(CombuFontDropDownButton:GetFrameLevel()+1)
    CombuFontBorderFrame:SetScale(1.3)
 
    for i = 1,#CombuFontList do
    
        CreateFrame("button", "CombuFont"..i, CombuFontFrame, "CombuFontTemplate")
        
        if i == 1 then
            CombuFont1:ClearAllPoints()
            CombuFont1:SetPoint("TOP",CombuFontFrame,"TOP",0,0)
        else _G["CombuFont"..i]:ClearAllPoints()
             _G["CombuFont"..i]:SetPoint("TOP",_G["CombuFont"..i-1],"BOTTOM",0,0)
        end
        
        _G["CombuFont"..i.."Bar"]:SetTexture(CombuLSM:Fetch("statusbar",combusettingstable["combutexturename"]))
        _G["CombuFont"..i.."Bar"]:SetVertexColor(unpack(combusettingstable["barcolornormal"]))
        _G["CombuFont"..i.."Text"]:SetText(CombuFontList[i])
        _G["CombuFont"..i.."Text"]:SetFont(CombuLSM:Fetch("font",CombuFontList[i]),9)
        
        if CombuFontList[i] == combusettingstable["combufontname"] then
            _G["CombuFont"..i.."Text"]:SetTextColor(1,0.8,0.2,1)
        else _G["CombuFont"..i.."Text"]:SetTextColor(1,1,1,1)
        end
    
    end
    
end

function CombuCreateSoundList()

    CombuSoundList = {} for k in pairs(CombuLSM:HashTable("sound")) do tinsert(CombuSoundList,k) end
    
    CombuSoundBorderFrame:Show()
    CombuSoundBorderFrame:ClearAllPoints()
    CombuSoundFrame:SetHeight(#CombuSoundList*15)
    CombuSoundBorderFrame:SetPoint("CENTER",CombuSoundDropDown,"CENTER",0,0-(CombuSoundFrame:GetHeight()/4))
    CombuSoundBorderFrame:SetParent(CombuSoundDropDown)
    CombuSoundBorderFrame:SetFrameLevel(CombuSoundDropDownButton:GetFrameLevel()+1)
    CombuSoundBorderFrame:SetScale(1.3)
 
    for i = 1,#CombuSoundList do
    
        CreateFrame("button", "CombuSound"..i, CombuSoundFrame, "CombuSoundTemplate")
        _G["CombuSound"..i]:SetID(i)
        
        if i == 1 then
            CombuSound1:ClearAllPoints()
            CombuSound1:SetPoint("TOP",CombuSoundFrame,"TOP",0,0)
        else _G["CombuSound"..i]:ClearAllPoints()
             _G["CombuSound"..i]:SetPoint("TOP",_G["CombuSound"..i-1],"BOTTOM",0,0)
        end
        
        _G["CombuSound"..i.."Text"]:SetText(CombuSoundList[i])
        
        if CombuSoundList[i] == combusettingstable["combusoundname"] then
            _G["CombuSound"..i.."Text"]:SetTextColor(1,0.8,0.2,1)
        else _G["CombuSound"..i.."Text"]:SetTextColor(1,1,1,1)
        end
    
    end
    
end

function CombuCreateBorderList()

    CombuBorderList = {} for k in pairs(CombuLSM:HashTable("border")) do tinsert(CombuBorderList,k) end
       
    CombuEdgeBorderFrame:Show()
    CombuEdgeBorderFrame:ClearAllPoints()
    CombuEdgeFrame:SetHeight(#CombuBorderList*32)
    CombuEdgeBorderFrame:SetPoint("CENTER",CombuBorderDropDown,"CENTER",0,0-(CombuEdgeFrame:GetHeight()/4))
    CombuEdgeBorderFrame:SetParent(CombuBorderDropDown)
    CombuEdgeBorderFrame:SetFrameLevel(CombuBorderDropDownButton:GetFrameLevel()+1)
    CombuEdgeBorderFrame:SetScale(1.3)
    
    for i = 1,#CombuBorderList do
    
        CreateFrame("button", "CombuBorder"..i, CombuEdgeFrame, "CombuEdgeTemplate")
        
        if i == 1 then
            CombuBorder1:ClearAllPoints()
            CombuBorder1:SetPoint("TOP",CombuEdgeFrame,"TOP",0,0)
        else _G["CombuBorder"..i]:ClearAllPoints()
             _G["CombuBorder"..i]:SetPoint("TOP",_G["CombuBorder"..i-1],"BOTTOM",0,0)
        end
        
        _G["CombuBorder"..i.."Bar"]:SetTexture(CombuLSM:Fetch("border",CombuBorderList[i]))
        _G["CombuBorder"..i.."Bar"]:SetVertexColor(unpack(combusettingstable["edgecolornormal"]))
        _G["CombuBorder"..i.."Text"]:SetText(CombuBorderList[i])
        
        if CombuBorderList[i] == combuBorder then
            _G["CombuBorder"..i.."Text"]:SetTextColor(1,0.8,0.2,1)
        else _G["CombuBorder"..i.."Text"]:SetTextColor(1,1,1,1)
        end
    
    end
    
end

function CombuCreateBackgroundList()

    CombuBackgroundList = {} for k in pairs(CombuLSM:HashTable("background")) do tinsert(CombuBackgroundList,k) end
     
    CombuBgBorderFrame:Show()
    CombuBgBorderFrame:ClearAllPoints()
    CombuBgFrame:SetHeight(#CombuBackgroundList*30)
    CombuBgBorderFrame:SetPoint("CENTER",CombuBackgroundDropDown,"CENTER",0,0-(CombuBgFrame:GetHeight()/4))
    CombuBgBorderFrame:SetParent(CombuBackgroundDropDown)
    CombuBgBorderFrame:SetFrameLevel(CombuBackgroundDropDownButton:GetFrameLevel()+1)
    CombuBgBorderFrame:SetScale(1.3)
    
    for i = 1,#CombuBackgroundList do
    
        CreateFrame("button", "CombuBackground"..i, CombuBgFrame, "CombuBgTemplate")
        
        if i == 1 then
            CombuBackground1:ClearAllPoints()
            CombuBackground1:SetPoint("TOP",CombuBgFrame,"TOP",0,0)
        else _G["CombuBackground"..i]:ClearAllPoints()
             _G["CombuBackground"..i]:SetPoint("TOP",_G["CombuBackground"..i-1],"BOTTOM",0,0)
        end
        
        _G["CombuBackground"..i.."Bar"]:SetTexture(CombuLSM:Fetch("background",CombuBackgroundList[i]))
        _G["CombuBackground"..i.."Text"]:SetText(CombuBackgroundList[i])
        
        if CombuBackgroundList[i] == combuBackground then
            _G["CombuBackground"..i.."Text"]:SetTextColor(1,0.8,0.2,1)
        else _G["CombuBackground"..i.."Text"]:SetTextColor(1,1,1,1)
        end
    
    end
    
end

-------------------------------
--Helper function for living bomb tracking expiration time collecting
local function CombuLBauratracker(targetguid, targetname, eventgettime)

	lbraidcheck = 0
	lbtablerefresh = 0
    lbgroupsuffix = nil
    lbtargetsuffix = nil
    
    if (GetNumRaidMembers() ~= 0) 
        then lbgroupsuffix = "raid"
             lbgroupnumber = GetNumRaidMembers()
    elseif (GetNumPartyMembers() ~= 0)
        then lbgroupsuffix = "party"
             lbgroupnumber = GetNumPartyMembers()
    end
    
    if (UnitGUID("target") == targetguid)
        then lbtargetsuffix = "target"
    elseif (UnitGUID("mouseover") == targetguid)
        then lbtargetsuffix = "mouseover"
    elseif (UnitGUID("focus") == targetguid)
        then lbtargetsuffix = "focus"
    end
        
    if combuimpacttimer and ((combuimpacttimer + 1) >= GetTime())
        then local a12,b12,c12,d12,e12,f12,g12,h12,i12,j12,k12 = UnitAura("target", lvb, nil, "PLAYER HARMFUL")
             for z = 1, #LBtrackertable do
             
                if ((LBtrackertable[z])[1] == targetguid) 
                    then (LBtrackertable[z])[3] = g12;
                         (LBtrackertable[z])[4] = f12;
                         (LBtrackertable[z])[5] = nil
                         lbtablerefresh = 1
                         break
                end 
             end
             
             if (lbtablerefresh == 1) then
             else table.insert(LBtrackertable, {targetguid, targetname, g12, f12})
             end
             
             lbraidcheck = 1
        
	elseif lbtargetsuffix and (UnitGUID(lbtargetsuffix) == targetguid)
        then local a12,b12,c12,d12,e12,f12,g12,h12,i12,j12,k12 = UnitAura(lbtargetsuffix, lvb, nil, "PLAYER HARMFUL")
             for z = 1, #LBtrackertable do
             
                if ((LBtrackertable[z])[1] == targetguid) 
                    then (LBtrackertable[z])[3] = g12;
                         (LBtrackertable[z])[4] = f12;
                         (LBtrackertable[z])[5] = GetRaidTargetIndex(lbtargetsuffix)
                         lbtablerefresh = 1
                         break
                end 
             end
             
             if (lbtablerefresh == 1) then
             else table.insert(LBtrackertable, {targetguid, targetname, g12, f12, GetRaidTargetIndex(lbtargetsuffix)})
             end
             
             lbraidcheck = 1
        
    elseif lbgroupsuffix then
        for i = 1, lbgroupnumber do -- first we check if a raid or party members target the LB's target to have an accurate expiration time with UnitAura
            
            if (UnitGUID(lbgroupsuffix..i.."-target") == targetguid) 
                then local a12,b12,c12,d12,e12,f12,g12,h12,i12,j12,k12 = UnitAura(lbgroupsuffix..i.."-target", lvb, nil, "PLAYER HARMFUL")
                     
                     for z = 1, #LBtrackertable do
                     
                        if ((LBtrackertable[z])[1] == targetguid) 
                            then (LBtrackertable[z])[3] = g12;
                                 (LBtrackertable[z])[4] = f12;
                                 (LBtrackertable[z])[5] = GetRaidTargetIndex(lbgroupsuffix..i.."-target")
                                 lbtablerefresh = 1
                                 break
                        end 
                     end
                     
                     if (lbtablerefresh == 1) then
                     else table.insert(LBtrackertable, {targetguid, targetname, g12, f12, GetRaidTargetIndex(lbgroupsuffix..i.."-target")})
                     end
                     
                     lbraidcheck = 1
                
            end
        end
    end
 	
 	if (lbraidcheck == 0) -- info with UnitAura have been collected, skipping this part.
        then for z = 1, #LBtrackertable do -- no raid members targetting the LB's target so using GetTime from event fired and 12 secs as duration
                 
                if ((LBtrackertable[z])[1] == targetguid) 
                    then (LBtrackertable[z])[3] = (eventgettime + 12);
                         (LBtrackertable[z])[4] = 12;
                         (LBtrackertable[z])[5] = nil
                         lbtablerefresh = 1
                         break
                end 
             end
                     
             if (lbtablerefresh == 1) then
             else table.insert(LBtrackertable, {targetguid, targetname, (eventgettime + 12), 12, nil})
             end
	end
	
	for i = 6,1,-1 do
    	if LBtrackertable[i] and (((LBtrackertable[i])[1] == 2120) or ((LBtrackertable[i])[1] == 88148)) then 
    		table.insert(LBtrackertable,{(LBtrackertable[i])[1],(LBtrackertable[i])[2],(LBtrackertable[i])[3],(LBtrackertable[i])[4]});
    		table.remove(LBtrackertable,i);
    	end
    end
    
end

local function CombuLBtrackerUpdate()

    lbtrackerheight = 0
    
    for i = 5,1,-1 do 
    
    	if LBtrackertable[i] and (LBtrackertable[i])[3] and ((LBtrackertable[i])[3] + 2) <= GetTime() 
    		then table.remove(LBtrackertable,i)
    	end
    
        if (#LBtrackertable == 0) 
            then _G["LBtrack"..i]:SetText("")
                 _G["LBtrack"..i.."Timer"]:SetText("")
                 _G["LBtrack"..i.."Bar"]:Hide()
                 _G["LBtrack"..i.."Target"]:SetTexture("")
                 _G["LBtrack"..i.."Symbol"]:SetTexture("")
                 LBtrackFrame:Hide()
        elseif (#LBtrackertable == 1) and (UnitGUID("target") == (LBtrackertable[1])[1]) and (combusettingstable["combulbtarget"] == false)
            then _G["LBtrack"..i]:SetText("")
                 _G["LBtrack"..i.."Timer"]:SetText("")
                 _G["LBtrack"..i.."Bar"]:Hide()
                 _G["LBtrack"..i.."Target"]:Hide()
                 _G["LBtrack"..i.."Symbol"]:Hide()
                 LBtrackFrame:Hide()
        elseif LBtrackertable[i] and (LBtrackertable[i])[3]
            then LBtrackFrame:Show()
                 _G["LBtrack"..i]:SetText((LBtrackertable[i])[2])
                 combulbtimer = (-1*(GetTime()-(LBtrackertable[i])[3]))

                 if (LBtrackertable[i])[4] and (combulbtimer >= combusettingstable["combutimervalue"]) then -- condition when timer is with more than 2 seconds left
                     _G["LBtrack"..i.."Timer"]:SetText(format("|cff00ff00%.1f|r",combulbtimer))
                     _G["LBtrack"..i.."Bar"]:Show()
                     _G["LBtrack"..i.."Bar"]:SetValue((LBtrackFrame:GetWidth()-12)*(combulbtimer/(LBtrackertable[i])[4]))
                     _G["LBtrack"..i.."Bar"]:SetStatusBarColor((combusettingstable["barcolornormal"])[1],(combusettingstable["barcolornormal"])[2],(combusettingstable["barcolornormal"])[3],(combusettingstable["barcolornormal"])[4])
                 elseif (LBtrackertable[i])[4] and (combulbtimer <= combusettingstable["combutimervalue"]) and (combulbtimer >= 0) then -- condition when timer is with less than 2 seconds left
                     _G["LBtrack"..i.."Timer"]:SetText(format("|cffff0000%.1f|r",combulbtimer))
                     _G["LBtrack"..i.."Bar"]:Show()
                     _G["LBtrack"..i.."Bar"]:SetValue((LBtrackFrame:GetWidth()-12)*(combulbtimer/(LBtrackertable[i])[4]))
                     _G["LBtrack"..i.."Bar"]:SetStatusBarColor(unpack(combusettingstable["barcolorwarning"]))
                 elseif (combulbtimer <= 0) then
                     table.remove(LBtrackertable,i)
                 end
                 
                 if LBtrackertable[i] and (LBtrackertable[i])[5] then 
                 	_G["LBtrack"..i.."Symbol"]:SetTexture("Interface\\TARGETINGFRAME\\UI-RaidTargetingIcon_"..(LBtrackertable[i])[5])
                 else _G["LBtrack"..i.."Symbol"]:SetTexture("")
                 end
                 
                 if LBtrackertable[i] and (UnitGUID("target") == (LBtrackertable[i])[1]) then
                    _G["LBtrack"..i.."Target"]:SetTexture("Interface\\AddOns\\CombustionHelper\\Images\\Combustion_target")
                 else _G["LBtrack"..i.."Target"]:SetTexture("")
                 end
                 
                 lbtrackerheight = lbtrackerheight + 9
                 
        else 
             _G["LBtrack"..i]:SetText("")
             _G["LBtrack"..i.."Timer"]:SetText("")
             _G["LBtrack"..i.."Bar"]:Hide()
             _G["LBtrack"..i.."Target"]:SetTexture("")
             _G["LBtrack"..i.."Symbol"]:SetTexture("")
        end
    end
    
    LBtrackFrame:SetHeight(lbtrackerheight + 11)
    
end
 
-------------------------------------
-- Autohide function
function CombustionAutohide()

	local combucombat = UnitAffectingCombat("player")
    local a5,b5,c5 = GetSpellCooldown(comb)
	
 	if (a5 == nil) then
	elseif combusettingstable["combuautohide"] == 1 and combufaded == true then -- condition when autohide is disabled
		combufaded = false
        table.wipe(LibTransition.tQueue) table.wipe(LibTransition.cQueue) -- stop the Libtransition queue
		CombustionFrame:FadeIn(combusettingstable["combufadeinspeed"])
	elseif combucombat == nil and combufaded == false and ((combusettingstable["combuautohide"] == 2) or (combusettingstable["combuautohide"] == 3)) then -- condition when not in combat and CH is visible
		combufaded = true
		CombustionFrame:FadeOut(combusettingstable["combufadeoutspeed"])
	elseif combusettingstable["combuautohide"] == 2 and combucombat == 1 and combufaded == true then -- condition when in combat
		combufaded = false
        table.wipe(LibTransition.tQueue) table.wipe(LibTransition.cQueue)
		CombustionFrame:FadeIn(combusettingstable["combufadeinspeed"])
	elseif combusettingstable["combuautohide"] == 3 and combucombat == 1 and combufaded == true and ((a5 + b5 - GetTime()) <= (combusettingstable["combuafterfade"] + combusettingstable["combufadeinspeed"])) then -- condition when in combat and CB is up
		combufaded = false
        table.wipe(LibTransition.tQueue) table.wipe(LibTransition.cQueue)
		CombustionFrame:FadeIn(combusettingstable["combufadeinspeed"])
	elseif combusettingstable["combuautohide"] == 3 and combucombat == 1 and combufaded == false and ((a5 + b5 - GetTime()) >= (combusettingstable["combuafterfade"] + combusettingstable["combufadeinspeed"])) and ((a5 + b5 - GetTime()) <= (b5 - combusettingstable["combubeforefade"])) then -- condition when in combat and CB is in cd
		combufaded = true
		CombustionFrame:FadeOut(combusettingstable["combufadeoutspeed"],combusettingstable["combufadealpha"])
        CombustionFrame:Wait((a5 + b5 - GetTime())-combusettingstable["combufadeinspeed"]-combusettingstable["combuafterfade"])
        CombustionFrame:FadeIn(combusettingstable["combufadeinspeed"])
		StatusTextFrameLabel:SetText(CombuLabel["autohide"])
        if (combusettingstable["combuchat"]==true) then ChatFrame1:AddMessage(format(CombuLoc["autohidemess"], (a5 + b5 - GetTime())-combusettingstable["combufadeinspeed"]-combusettingstable["combuafterfade"]))
        end
    end
    
end

-----------------------------------
-- Ignite managing function
local function CombustionIgnite(event, spellId, spellSchool, amount, critical, destGUID)

	local a2,b2,c2,d2,e2,f2,g2,h2,i2,j2,k2 = UnitAura("target", ignite, nil, "PLAYER HARMFUL")
		
	if (k2==12654) then 
	combuignitetimer = (-1*(GetTime()-g2))
	else combuignitetimer = 0
	end
	
	if ((critical == 1) and (event == "SPELL_DAMAGE")) and ((spellSchool == 4) or (spellSchool == 20)) and (spellId ~= 83853) and (spellId ~= 89091) and (spellId ~= 44461) and (spellId ~= 2120) and (spellId ~= 88148) and (spellId ~= 82739) and (spellId ~= 83619) and (spellId ~= 99062) and (spellId ~= 34913) and (spellId ~= 84721) and (spellId ~= 95969) then

        combuigniteamount = ceil(amount * 0.4 * (((GetMastery()*2.8)/100)+1))
		combuignitevalue = combuignitevalue + combuigniteamount
                            
	    if (combuignitetimer >= 4.5 + combusettingstable["combuignitedelta"]) then
	        combuignitemunched = combuignitemunched + combuigniteamount
	    elseif (combuignitetimer >= 1.7 - combusettingstable["combuignitedelta"]) and (combuignitetimer <= 2.5 + combusettingstable["combuignitedelta"]) then
	        combuignitetemp = combuignitetemp + combuigniteamount
	    elseif (combuignitetimer <= 0.5 + combusettingstable["combuignitedelta"]) and (combuignitetimer ~= 0) then
	        combuignitetemp = combuignitetemp + combuigniteamount
	    elseif (combuignitetimer >= 3.8 - combusettingstable["combuignitedelta"]) then
	        combuignitetemp = combuignitetemp + combuigniteamount
	    elseif (combuignitetimer >= 0.5 + combusettingstable["combuignitedelta"]) then
	        combuignitecount = 3
	        combuignitebank = combuignitebank + combuigniteamount
	    else combuignitecount = 2
	         combuignitebank = combuignitebank + combuigniteamount 
	    end
	    
	    if combuignitetemp ~= 0 and combuignitetimer == 0 then
	        combuignitecount = 3
	        combuignitebank = combuignitebank + combuignitetemp
	        combuignitetemp = 0
	    end
		
		if (combusettingstable["combuignitepredict"] == true) then 
            combuigndamage = ceil(combuignitebank / combuignitecount)
            IgniteLabel:SetText(format(CombuLabel["ignwhite0"], combuigndamage))
        end

        combucrittarget = destGUID

	elseif (event == "SPELL_PERIODIC_DAMAGE") and (spellId == 12654) then
                            
	    combuigniteapplied = combuigniteapplied + amount
	    combuignitebank = (combuignitecount - 1) * amount + combuignitetemp
	    combuignitecount = combuignitecount - 1
	    if (combuignitetemp ~= 0) and (combuignitetimer ~= 0) then
	        combuignitecount = 3
	    end
	    
   	    if (combusettingstable["combuignitepredict"] == true) then -- color ignite text depending of accuracy of predicter
         	if (tonumber(abs(combuigndamage-amount)) <= 3) then
 				IgniteLabel:SetText(format(CombuLabel["dmggreen0"], amount))
 			else IgniteLabel:SetText(format(CombuLabel["dmgred0"], amount))
 			end
 		elseif (combusettingstable["combureport"] == true) then 
 			IgniteLabel:SetText(format(CombuLabel["dmgwhite0"], amount))
 		end
		
		combuigndamage = amount
	    combuignitetemp = 0
                            
	elseif (combucrittarget ~= UnitGUID("target")) or (UnitGUID("target") == nil) or ((event == "SPELL_AURA_REMOVED") and (spellId == 12654)) then
		IgniteLabel:SetText(format(CombuLabel["ignite"]))
		combuigndamage = 0
	end
	
	if (combuignitetimer >= combusettingstable["combutimervalue"]) and (combuignitetimer ~= 0) then -- condition when timer is with more than 2 seconds left
		IgnTextFrameLabel:SetText(format("|cff00ff00%.1f|r",combuignitetimer))
		IgniteButton:SetTexture("Interface\\AddOns\\CombustionHelper\\Images\\Combustionon")
		IgnTime = 1
	elseif (combuignitetimer <= combusettingstable["combutimervalue"]) and (combuignitetimer ~= 0) then -- condition when timer is with less than 2 seconds left
		IgnTextFrameLabel:SetText(format("|cffff0000%.1f|r",combuignitetimer))
		IgniteButton:SetTexture("Interface\\AddOns\\CombustionHelper\\Images\\Combustionon")
		IgnTime = 0
	else IgnTextFrameLabel:SetText(format(CombuLabel["ignshort"]))
		IgniteButton:SetTexture("Interface\\AddOns\\CombustionHelper\\Images\\Combustionoff") -- Text in red
		IgnTime = 0
	end
		
	if (combusettingstable["combubartimers"] == true) then
		if (k2==12654) and (combuignitetimer <= combusettingstable["combutimervalue"]) then 
			Ignbar:Show()
			Ignbar:SetValue((28+combusettingstable["combubarwidth"])*((g2-GetTime())/f2))
			Ignbar:SetStatusBarColor(unpack(combusettingstable["barcolorwarning"]))
		elseif (k2==12654) then 
			Ignbar:Show()
			Ignbar:SetValue((28+combusettingstable["combubarwidth"])*((g2-GetTime())/f2))
			Ignbar:SetStatusBarColor(unpack(combusettingstable["barcolornormal"]))
		else Ignbar:Hide()
		end
	end
		
end

local function CombuTickManager(event, spellId, spellName)
    
    if event then
        
        if event == "SPELL_AURA_APPLIED" then -- adding and remove haste buffs from list depending on events
            
            if (combuhasteprocs[spellId])[3] == "flat" then
                table.insert(combucurrenthasteprocs,1,{spellId,spellName}) -- add flat haste rating to the top of the table
            else table.insert(combucurrenthasteprocs,{spellId,spellName}) -- add % haste to the bottom of the table
            end
            
        elseif event == "SPELL_AURA_REMOVED" then
            
            for i = 1,#combucurrenthasteprocs do
                if (combucurrenthasteprocs[i])[1] == spellId then
                    
                    _G["CombuProcHasteBlock"..#combucurrenthasteprocs]:Hide()
                                        
                    table.remove(combucurrenthasteprocs,i)
                    break
                end
            end
            
        end
    end
    
    combuprevhaste = combucurrenthaste
    combucurrenthaste = ceil(UnitSpellHaste("player") * 128.05701)
    combubasehaste = GetCombatRating(20)
    combuflathastevalue = GetCombatRating(20)+12805.701
    
    if combuprevhaste ~= combucurrenthaste or event == "SPELL_AURA_APPLIED" then
        
        if #combucurrenthasteprocs > 0 then
            for i = 1,#combucurrenthasteprocs do -- assigning info to blocks
                
                if not _G["CombuProcHasteBlock"..i] then --print("createblock")
                    CreateFrame("frame", "CombuProcHasteBlock"..i, CombuTickLayer, "CombuHasteBlockTemplate")
                    _G["CombuProcHasteBlock"..i]:SetHeight(CombuTickLayerBase:GetHeight())
                else _G["CombuProcHasteBlock"..i]:Show()
                end
                
                if (combuhasteprocs[(combucurrenthasteprocs[i])[1]])[3] == "flat" then
                
                --    print(combubasehaste,"1")
                    combuhasteprocvalue = (combuhasteprocs[(combucurrenthasteprocs[i])[1]])[4]
                    combubasehaste = combubasehaste - combuhasteprocvalue
                --    print(combubasehaste , combuhasteprocvalue)
                    
                else combuhasteprocvalue = ceil((combuflathastevalue*(1+((combuhasteprocs[(combucurrenthasteprocs[i])[1]])[4]/100))) - combuflathastevalue)
                     combuflathastevalue = combuflathastevalue + combuhasteprocvalue
                end
                
                table.insert(combucurrenthasteprocs[i], combuhasteprocvalue)
                
             --   print(i,combubasehaste,(combucurrenthasteprocs[i])[2], combuhasteprocvalue)
                
                combucurrenthastewidthproc = ceil(CombuTickGlobalBar:GetWidth()*(combuhasteprocvalue/(select(2,CombuTickGlobalBar:GetMinMaxValues()))))
                                
                _G["CombuProcHasteBlock"..i]:SetWidth(combucurrenthastewidthproc-1)
                _G["CombuProcHasteBlock"..i.."Text1"]:SetWidth(combucurrenthastewidthproc-3)
                _G["CombuProcHasteBlock"..i.."Text2"]:SetWidth(combucurrenthastewidthproc-3)
                _G["CombuProcHasteBlock"..i.."Text1"]:SetText((combucurrenthasteprocs[i])[2])
                _G["CombuProcHasteBlock"..i.."Text2"]:SetText(format("%.0f" ,combuhasteprocvalue))
                _G["CombuProcHasteBlock"..i.."Bg"]:SetWidth(combucurrenthastewidthproc-1)
                _G["CombuProcHasteBlock"..i.."Bg"]:SetTexture(select(3,GetSpellInfo((combucurrenthasteprocs[i])[1])))
                
                if i == 1 then -- stick the block to the previous block
                    _G["CombuProcHasteBlock"..i]:ClearAllPoints()
                    _G["CombuProcHasteBlock"..i]:SetPoint("LEFT",CombuTickLayerBase,"RIGHT",1,0)
                else _G["CombuProcHasteBlock"..i]:ClearAllPoints()
                     _G["CombuProcHasteBlock"..i]:SetPoint("LEFT",_G["CombuProcHasteBlock"..i-1],"RIGHT",1,0)
                end
                
            end
        end
        
        combubasewidth = CombuTickGlobalBar:GetWidth()*(combubasehaste/(select(2,CombuTickGlobalBar:GetMinMaxValues())))
        
        CombuTickLayerBaseText1:SetText("Base")
        CombuTickLayerBaseText2:SetText(combubasehaste)
        CombuTickLayerBaseText1:SetWidth(combubasewidth-3)
        CombuTickLayerBaseText2:SetWidth(combubasewidth-3)
        CombuTickLayerBase:SetWidth(combubasewidth)
        CombuTickLayerBaseBg:SetWidth(combubasewidth)
        
        CombuTickGlobalBar:SetValue(combucurrenthaste)
        
    end
    
    if #combucurrenthasteprocs > 0 then
        
        for i = 1,#combucurrenthasteprocs do 
            
            if select(7,UnitAura("player",(combucurrenthasteprocs[i])[2])) and (combucurrenthasteprocs[i])[3] then 
                
                combuhasteproctimer = format("%.1f",(-1*(GetTime() - select(7,UnitAura("player",(combucurrenthasteprocs[i])[2])))))
                
                _G["CombuProcHasteBlock"..i.."Text2"]:SetText(format("%.0f - %.1f",(combucurrenthasteprocs[i])[3],combuhasteproctimer))
                
            end
        end
    end

   -- print(ceil(UnitSpellHaste("player") * 128.05701))
    
end

local function CombuDamagePredicter ()

	if select(1,UnitAura("target",pyro1,nil,"HARMFUL")) or select(1,UnitAura("target",pyro2,nil,"HARMFUL")) then
		combupyrodps = (164 + (0.180*GetSpellBonusDamage(3)))*(combufirepower)*(1.25)*((0.00015618*GetCombatRating(26)) + 1.224)
	else combupyrodps = 0
	end
	
	if select(1,UnitAura("target","Living Bomb",nil,"HARMFUL")) then
		combulbdps = (234 + (0.258*GetSpellBonusDamage(3)))*(combufirepower)*(1.25)*(combucriticalmass)*((0.00015618*GetCombatRating(26)) + 1.224)
	else combulbdps = 0
	end
	
    combucurrenthaste = UnitSpellHaste("player") * 128.05701
	combucurrentcrit = GetSpellCritChance(3)
	
	for i = 2,#combuhasteplateau do
		
		if combucurrenthaste < (combuhasteplateau[i])[1] then
			combuhastetick = (combuhasteplateau[i-1])[2]
			break
		end
	end
	
	combuexpectedtickdmg = ceil(combupyrodps/3 + combulbdps/3 + combuigndamage/2)
	combuextectedfrontdmg = ceil((955+((1131-955)/2))+(GetSpellBonusDamage(3)*0.58238))
	combuexpecteddmg = ceil(((combuexpectedtickdmg*combuhastetick)*(1+(combucurrentcrit/100))) + (combuextectedfrontdmg*(1+(combucurrentcrit/100))) + (combuextectedfrontdmg*(combucurrentcrit/100)*0.4))
	
	return format("Tick : %.0f x %0.f",combuexpectedtickdmg,combuhastetick)
--	print("Estimated combustion dmg :",combuexpecteddmg)

end


-------------------------------------------------------------------------------------------------------	
-------------------------------------------------------------------------------------------------------	
-------------------------------- ON_EVENT FUNCTION ----------------------------------------------------

function Combustion_OnEvent(self, event, ...)

    if (event == "PLAYER_LOGIN") then
    	
    	CombuSavedVariablesConvert ()
        
    --    CombuTickGlobalBar:SetMinMaxValues(0,12182)
    --    CombuTickManager("startup")
        
    --	CombuTableNewSettingsCheck()
        
	    if (CombustionFrame:GetFrameLevel() == 0) then
	        CombustionFrame:SetFrameLevel(1) -- fix when frame is at FrameLevel 0
	    end
	    
	    if (combusettingstable["combuchat"]==true) then ChatFrame1:AddMessage(CombuLoc["startup"]) end
    
-------------------------------
--Combustion spell check on startup    
        local a6 = IsSpellKnown(11129) -- check if combustion is in the spellbook
                
        if (a6 == false) 
	        then combufaded = true
	        	 CombustionFrame:FadeOut(combusettingstable["combufadeoutspeed"],combusettingstable["combufadealpha"])
	             combutalent = false
        elseif (a6 == true) 
	        then combufaded = false
	        	 CombustionFrame:FadeIn(combusettingstable["combufadeinspeed"])
	             combutalent = true
        end
        
-------------------------------
--frostfirebolt glyph check on startup
        local enabled1,_,_,id1 = GetGlyphSocketInfo(7)
        local enabled4,_,_,id4 = GetGlyphSocketInfo(8)
        local enabled6,_,_,id6 = GetGlyphSocketInfo(9)
         
	    if (id1 == 61205) or (id4 == 61205) or (id6 == 61205)
	    	then ffbglyph = true
	    else ffbglyph = false
             combusettingstable["combuffb"] = false
        end 
                
-------------------------------
--Frame lock check on startup
        if (combusettingstable["combulock"] == false) 
	 		then CombustionFrame:EnableMouse(true)
        elseif (combusettingstable["combulock"] == true) 
	    	then CombustionFrame:EnableMouse(false)
        end	
        
        CombuLanguageCheck()
	    CombustionScale (combusettingstable["combuscale"]) -- Scale check on startup
	    CombustionFrameresize() -- Combustion Frame size check on startup    

    end
	
-------------------------------
--Combustion spell check      
    if (event == "PLAYER_TALENT_UPDATE") then
      
        local a6 = IsSpellKnown(11129) -- check if combustion is in the spellbook
            
        if (a6 == false) and (combutalent == true) then
        		combufaded = true
                CombustionFrame:FadeOut(combusettingstable["combufadeoutspeed"],combusettingstable["combufadealpha"])
                combutalent = false
                if (combusettingstable["combuchat"]==true) then ChatFrame1:AddMessage(CombuLoc["combuon"]) end
        elseif (a6 == true) and (combutalent == false) then
        		combufaded = false
                CombustionFrame:FadeIn(combusettingstable["combufadeinspeed"])
                combutalent = true
                if (combusettingstable["combuchat"]==true) then ChatFrame1:AddMessage(CombuLoc["combuoff"]) end
                CombustionFrameresize()
        end
        
        combufirepower = 1 + (select(5,GetTalentInfo(2,5))/100)
        combucriticalmass = 1 + ((select(5,GetTalentInfo(2,20))*5)/100)
        
--~         if select(5,GetTalentInfo(1,3)) > 0 then -- talent check for haste tick manager
--~             CombuTickManager("SPELL_AURA_REMOVED",44403);
--~             (combuhasteprocs[44403])[4] = select(5,GetTalentInfo(1,3))
--~             CombuTickManager("SPELL_AURA_APPLIED",44403,select(1,GetTalentInfo(1,3)))
--~         else CombuTickManager("SPELL_AURA_REMOVED",44403)
--~         end
    end
    
-------------------------------
--frostfirebolt glyph check
    if (event == "GLYPH_ADDED") or (event == "GLYPH_REMOVED")
        then Combuffbglyphcheck ()
             
    end
    
-------------------------------
--Combat log events checks
    if (event=="COMBAT_LOG_EVENT_UNFILTERED") then

    	timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical = select(1, ...)
            
            if (sourceName == UnitName("player")) then --print(spellId,event)
            
---------------------------------
-- Ignite prediction part                
                if (destGUID == UnitGUID("target")) then --print(timestamp,event,sourceName,spellName,destName,amount)
                    CombustionIgnite( event, spellId, spellSchool, amount, critical, destGUID)
                end

-------------------------------------------
-- report event check 
				if (combusettingstable["combureport"] == true) and (destGUID == UnitGUID("target")) then
					if (spellId == 44457) and (event == "SPELL_PERIODIC_DAMAGE") then -- LB damage
						if (critical == 1) and (combumeta == true) then 
							combulbdamage = amount/2,03
						elseif (critical == 1) and (combumeta == false) then 
							combulbdamage = amount/2
						else combulbdamage = amount
						end
						LBLabel:SetText(format(CombuLabel["dmgwhite0"], combulbdamage))
					elseif ((spellId == 11366) and (event == "SPELL_PERIODIC_DAMAGE")) or ((spellId == 92315) and (event == "SPELL_PERIODIC_DAMAGE")) then -- pyroblast damage
						if (critical == 1) and (combumeta == true) then 
							combupyrodamage = amount/2,03
						elseif (critical == 1) and (combumeta == false) then 
							combupyrodamage = amount/2
						else combupyrodamage = amount
						end
						PyroLabel:SetText(format(CombuLabel["dmgwhite0"], combupyrodamage))
					elseif (spellId == 44614) and (event == "SPELL_PERIODIC_DAMAGE") then -- FFB damage
						if (critical == 1) and (combumeta == true) then 
							combuffbdamage = amount/2,03
						elseif (critical == 1) and (combumeta == false) then 
							combuffbdamage = amount/2
						else combuffbdamage = amount
						end
						FFBLabel:SetText(format(CombuLabel["dmgwhite0"], combuffbdamage))
					end
				end
                
-------------------------------------------
-- Living Bomb early refresh 
                if (combusettingstable["comburefreshmode"] == true) and (spellId == 44457) then
                    if (event == "SPELL_AURA_REFRESH")
                        then combulbrefresh = combulbrefresh + 1
                             print(format(CombuLoc["lbrefresh"],destName))
                    elseif (event == "SPELL_MISSED") 
                        then PlaySoundFile("Sound\\Spells\\SimonGame_Visual_BadPress.wav")
                             print(format(CombuLoc["lbmiss"],destName))
                    end
                end

-------------------------------------------
-- Living Bomb tracking 
                if (combusettingstable["combulbtracker"] == true) and (spellId == 44457) then 
                	if (event == "SPELL_AURA_APPLIED") or (event == "SPELL_AURA_REFRESH") 
                		then CombuLBauratracker(destGUID, destName, GetTime())
                	elseif (event == "SPELL_AURA_REMOVED") 
                		then for i = 1,#LBtrackertable do
                 
								if LBtrackertable[i] and ((LBtrackertable[i])[1] == destGUID) 
                 					then table.remove(LBtrackertable,i)
                                         break
                 			 	end
                 			 end
                	end
                end
                
                -- Impact manager for LB tracking
                if (spellId == 2136) and (event == "SPELL_CAST_SUCCESS") -- successful impact cast
                    then combuimpacttimer = GetTime()
                elseif (spellId == 2136) and (event == "SPELL_MISSED")
                    then combuimpacttimer = nil
                end

-------------------------------------------
-- FlameStrike tracking 
			    if  (combusettingstable["combuflamestrike"] == true) or (spellId == 2120) and (spellId == 88148) then 
			    	if (event == "SPELL_DAMAGE") or (event == "SPELL_CAST_SUCCESS")
						then lbtablerefresh = 0
							 for z = 1, #LBtrackertable do
			               
					    		 if ((LBtrackertable[z])[1] == spellId) 
					            	then (LBtrackertable[z])[3] = (GetTime() + 8);
					                     (LBtrackertable[z])[4] = 8;
					                     (LBtrackertable[z])[5] = nil
					                     lbtablerefresh = 1
					                     break
					             end 
					         end
			                   
					         if (lbtablerefresh == 1) then
					         elseif (spellId == 2120) 
					         	then table.insert(LBtrackertable, {spellId, CombuLabel["flamestrike"], (GetTime() + 8), 8, nil})
					         elseif (spellId == 88148) 
					         	then table.insert(LBtrackertable, {spellId, CombuLabel["blastwave"], (GetTime() + 8), 8, nil})
					         end
					end
				end
						
-------------------------------------------
-- Pyroblast buff report 
                if (combusettingstable["combureportpyro"] == true) then
                	if (spellId == 48108) and (event == "SPELL_AURA_APPLIED")
	                    then combupyrogain = combupyrogain + 1
	                elseif (spellId == 48108) and (event == "SPELL_AURA_REFRESH")
	                    then combupyrorefresh = combupyrorefresh + 1
	                    	print(format(CombuLoc["pyrorefresh"]))
					elseif ((spellId == 11366) and (event == "SPELL_CAST_SUCCESS")) or ((spellId == 92315) and (event == "SPELL_CAST_SUCCESS"))  
	                    then combupyrocast = combupyrocast + 1
	                end
	            end
	            
-------------------------------------------
-- Combustion damage report
	
				if spellId == 83853 then
					if event == "SPELL_PERIODIC_DAMAGE" then 
						combucombustiondmg = combucombustiondmg + amount
                        combuticks = combuticks + 1
                        if not critical then 
                            combutickdmg = amount
                        end
					end
                    if not combutargetstable[destGUID] then
                        combutargetstable[destGUID] = 1
                        combutargets = combutargets + 1
                    end
				elseif spellId == 11129 then
					if event == "SPELL_CAST_SUCCESS" then
						combucombustionprevdmg = combucombustiondmg
						combucombustiondmg = 0
						combutimestamp = GetTime()
                        combuprevticks = combuticks
                        combuticks = 0
                        combutickprevdmg = combutickdmg
                        combutickdmg = 0
                        combuprevtargets = combutargets
                        combutargets = 0
                        combutargetstable = {}
                                                
                    elseif event == "SPELL_DAMAGE" then 
						combucombustiondmg = combucombustiondmg + amount
					end
				end
	            
	            
            end
            
--            if combuhasteprocs[spellId] and destName == UnitName("player") then print(event, spellId, spellName)
--
--                CombuTickManager(event, spellId, spellName)
--            
--            end
    end
                
-------------------------------------------
-- Start and End of fight events 
    if (event == "PLAYER_REGEN_DISABLED") then 
    	
    	local gem1, gem2, gem3 = GetInventoryItemGems(1)
        
		if CombuCritMeta[gem1] or CombuCritMeta[gem2] or CombuCritMeta[gem3] 
			then combumeta = true
		else combumeta = false
		end  
		
        CombustionVarReset()
        CombustionAutohide()
        
		combucombustiondmg = 0
		combuticks = 0
		combutickdmg = 0
		combutargets = 0
		combutargetstable = {}
		    
    elseif (event == "PLAYER_REGEN_ENABLED") then 
    
    	if (combusettingstable["combureportmunching"] == true) and (combuignitevalue ~= 0) and select(5,GetTalentInfo(2,4)) ~= 0 then 
            print(format(CombuLoc["ignrep"],combuignitevalue,combuigniteapplied,format("%.0f / %.0f%%",combuignitevalue-combuigniteapplied,(combuignitevalue-combuigniteapplied)/combuignitevalue*100)))
        end
    	    
    	if (combulbrefresh >= 1) then
        	print(format(CombuLoc["lbreport"],combulbrefresh))
        	combulbrefresh = 0
        end
    
        if (combusettingstable["combureportpyro"] == true) and (combupyrogain ~= 0) then
            print(format(CombuLoc["pyroreport"],combupyrogain + combupyrorefresh, combupyrocast, (100*(combupyrocast/(combupyrogain + combupyrorefresh)))))
        end

		CombustionVarReset()
		        
        table.wipe(LBtrackertable) -- cleaning multiple LB tracker table when leaving combat
		IgniteLabel:SetText(format(CombuLabel["ignite"]))
        
    end

end
	




	
-------------------------------------------------------------------------------------------------------	
-------------------------------------------------------------------------------------------------------	
-------------------------------- ON_UPDATE FUNCTION ----------------------------------------------------

function Combustion_OnUpdate(self, elapsed)
    self.TimeSinceLastUpdate = (self.TimeSinceLastUpdate or 0) + elapsed;
 
		if (self.TimeSinceLastUpdate > Combustion_UpdateInterval) then
            local time = GetTime()   
            
-------------------------------
--Living Bomb part
		local a,b,c,d,e,f,g,h,i,j,k = UnitAura("target", lvb, nil, "PLAYER HARMFUL")		
		
		if (k==44457) then 
			combulbtimer = (-1*(time-g))
		else combulbtimer = 0
			combulbdamage = 0
		end
		
		if (combulbtimer >= combusettingstable["combutimervalue"]) and (combulbtimer ~= 0) then -- condition when timer is with more than 2 seconds left
			LBTextFrameLabel:SetText(format("|cff00ff00%.1f|r",combulbtimer))
			LBButton:SetTexture("Interface\\AddOns\\CombustionHelper\\Images\\Combustionon")
			LBTime = 1
		elseif (combulbtimer <= combusettingstable["combutimervalue"]) and (combulbtimer ~= 0) then -- condition when timer is with less than 2 seconds left
			LBTextFrameLabel:SetText(format("|cffff0000%.1f|r",combulbtimer))
			LBButton:SetTexture("Interface\\AddOns\\CombustionHelper\\Images\\Combustionon")
			LBTime = 0
		else LBTextFrameLabel:SetText(format(CombuLabel["lbshort"])) 
			LBButton:SetTexture("Interface\\AddOns\\CombustionHelper\\Images\\Combustionoff") -- Text in red
			LBLabel:SetText(CombuLabel["lb"])
			LBTime = 0
		end
			
		if (combusettingstable["combubartimers"] == true) and (k==44457) and (combulbtimer <= combusettingstable["combutimervalue"]) then
			LBbar:Show()
			LBbar:SetValue((28+combusettingstable["combubarwidth"])*((g-GetTime())/f))
			LBbar:SetStatusBarColor(unpack(combusettingstable["barcolorwarning"]))
		elseif (combusettingstable["combubartimers"] == true) and (k==44457) then 
			LBbar:Show()
			LBbar:SetValue((28+combusettingstable["combubarwidth"])*((g-GetTime())/f))
			LBbar:SetStatusBarColor(unpack(combusettingstable["barcolornormal"]))
		else LBbar:Hide()
		end
			
--------------------------------
--FrostfireBolt part
		local a1,b1,c1,d1,e1,f1,g1,h1,i1,j1,k1 = UnitAura("target", ffb, nil, "PLAYER HARMFUL")		
		
		if (k1==44614) then 
			combuffbtimer = (-1*(time-g1))
		else combuffbtimer = 0
			combuffbdamage = 0
		end

 		if (ffbglyph == false) or (combusettingstable["combuffb"] == false) then 
			FFBTime = 1
			FFBTextFrameLabel:SetText(format(CombuLabel["ffbglyph"]))
		elseif (combuffbtimer >= combusettingstable["combutimervalue"]) and (combuffbtimer ~= 0) then -- condition when timer is with more than 2 seconds left
			FFBTextFrameLabel:SetText(format("|cff00ff00%.1f/%d|r",combuffbtimer,(d1)))
			FFBButton:SetTexture("Interface\\AddOns\\CombustionHelper\\Images\\Combustionon")
			FFBTime = 1
		elseif (combuffbtimer <= combusettingstable["combutimervalue"]) and (combuffbtimer ~= 0) then -- condition when timer is with less than 2 seconds left
			FFBTextFrameLabel:SetText(format("|cffff0000%.1f/%d|r",combuffbtimer,(d1)))
			FFBButton:SetTexture("Interface\\AddOns\\CombustionHelper\\Images\\Combustionon")
			FFBTime = 0
		else FFBTextFrameLabel:SetText(format(CombuLabel["ffbshort"]))
			FFBButton:SetTexture("Interface\\AddOns\\CombustionHelper\\Images\\Combustionoff") -- Text in red
			FFBLabel:SetText(CombuLabel["frostfire"])
			FFBTime = 0
		end
			
		if (combusettingstable["combubartimers"] == true) and (k1==44614) and (combuffbtimer <= combusettingstable["combutimervalue"]) then 
			FFBbar:Show()
			FFBbar:SetValue((28+combusettingstable["combubarwidth"])*((g1-GetTime())/f1))
			FFBbar:SetStatusBarColor(unpack(combusettingstable["barcolorwarning"]))
		elseif (combusettingstable["combubartimers"] == true) and (k1==44614) then 
			FFBbar:Show()
			FFBbar:SetValue((28+combusettingstable["combubarwidth"])*((g1-GetTime())/f1))
			FFBbar:SetStatusBarColor(unpack(combusettingstable["barcolornormal"]))
		else FFBbar:Hide()
		end
			
--------------------------------
--Ignite part

    CombustionIgnite()
			
--------------------------------
--Pyroblast part
		local a3,b3,c3,d3,e3,f3,g3,h3,i3,j3,k3 = UnitAura("target", pyro1, nil, "PLAYER HARMFUL")		
		local a4,b4,c4,d4,e4,f4,g4,h4,i4,j4,k4 = UnitAura("target", pyro2, nil, "PLAYER HARMFUL")		
		
		if (k3==11366) then 
			combupyrotimer = (-1*(time-g3))
		elseif (k4==92315) then 
			combupyrotimer = (-1*(time-g4))
		else combupyrotimer = 0
			combupyrodamage = 0
		end
		
		if (combupyrotimer >= combusettingstable["combutimervalue"]) and (combupyrotimer ~= 0) then -- condition when timer is with more than 2 seconds left
			PyroTextFrameLabel:SetText(format("|cff00ff00%.1f|r",combupyrotimer))
			PyroButton:SetTexture("Interface\\AddOns\\CombustionHelper\\Images\\Combustionon")
			PyroTime = 1
		elseif (combupyrotimer <= combusettingstable["combutimervalue"]) and (combupyrotimer ~= 0) then -- condition when timer is with less than 2 seconds left
			PyroTextFrameLabel:SetText(format("|cffff0000%.1f|r",combupyrotimer))
			PyroButton:SetTexture("Interface\\AddOns\\CombustionHelper\\Images\\Combustionon")
			PyroTime = 0
		else PyroTextFrameLabel:SetText(format(CombuLabel["pyroshort"]))
			PyroButton:SetTexture("Interface\\AddOns\\CombustionHelper\\Images\\Combustionoff") -- Text in red
			PyroLabel:SetText(format(CombuLabel["pyroblast"]))
			PyroTime = 0
		end
            			
		if (combusettingstable["combubartimers"] == true) and (k3==11366) and (combupyrotimer <= combusettingstable["combutimervalue"]) then 
			Pyrobar:Show()
			Pyrobar:SetValue((28+combusettingstable["combubarwidth"])*((g3-GetTime())/f3))
			Pyrobar:SetStatusBarColor(unpack(combusettingstable["barcolorwarning"]))
		elseif (combusettingstable["combubartimers"] == true) and (k3==11366) then 
			Pyrobar:Show()
			Pyrobar:SetValue((28+combusettingstable["combubarwidth"])*((g3-GetTime())/f3))
			Pyrobar:SetStatusBarColor(unpack(combusettingstable["barcolornormal"]))
		elseif (combusettingstable["combubartimers"] == true) and (k4==92315) and (combupyrotimer <= combusettingstable["combutimervalue"]) then 
			Pyrobar:Show()
			Pyrobar:SetValue((28+combusettingstable["combubarwidth"])*((g4-GetTime())/f4))
			Pyrobar:SetStatusBarColor(unpack(combusettingstable["barcolorwarning"]))
		elseif (combusettingstable["combubartimers"] == true) and (k4==92315) then 
			Pyrobar:Show()
			Pyrobar:SetValue((28+combusettingstable["combubarwidth"])*((g4-GetTime())/f4))
			Pyrobar:SetStatusBarColor(unpack(combusettingstable["barcolornormal"]))
		else Pyrobar:Hide()
		end
		
--------------------------------
--Combustion/impact part
        local a5,b5,c5 = GetSpellCooldown(comb)
        local a7,b7,c7,d7,e7,f7,g7,h7,i7,j7,k7 = UnitAura("player", impact)
                
        if (b5 == nil) then
        elseif (InCombatLockdown() == 1) and (b5<=2) and combusettingstable["combutickpredict"] == true then -- Combustion damage predicter
        	StatusTextFrameLabel:SetText(CombuDamagePredicter())
        elseif (b5<=2) and (combusettingstable["combureport"] == true) and (InCombatLockdown() == 1) then 
            CombustionUp = 1
            ImpactUp = 0
            combufadeout = false
            combuchatautohide = 0 
            if (combusettingstable["combureportvalue"] <= combuigndamage) and combusettingstable["combureportthreshold"] then
                StatusTextFrameLabel:SetText(format(CombuLabel["ignCBgreen"], combuigndamage))
            else StatusTextFrameLabel:SetText(format(CombuLabel["ignCBred"], combuigndamage))
            end
        elseif (b5<=2) then -- condition when combustion cd is up, taking gcd in account
            StatusTextFrameLabel:SetText(CombuLabel["combup"])
            CombustionUp = 1
            ImpactUp = 0
            combufadeout = false
            combuchatautohide = 0
        elseif (b5>=2) and (k7 == 64343) and (combusettingstable["combuimpact"] == true) then -- condition when impact is up and combustion in cd
            StatusTextFrameLabel:SetText(format(CombuLabel["impactup"],-1*(time-g7)))
            CombustionUp = 0
            ImpactUp = 1
            combufadeout = false
        elseif ((a5 + b5 - time)>=60) and (combufadeout == false) and (k7 == nil) then -- timer for combustion in minutes
            StatusTextFrameLabel:SetText(format(CombuLabel["combmin"],(a5 + b5 - time) / 60,(a5 + b5 - time) % 60 ))  
            CombustionUp = 0
            ImpactUp = 0
        elseif ((a5 + b5 - time)<=60) and (k7 == nil) then 
            StatusTextFrameLabel:SetText(format(CombuLabel["combsec"],(a5 + b5 - time)))  -- timer for combustion in seconds
            CombustionUp = 0	
            ImpactUp = 0
        end
            
--------------------------------
-- Critical Mass/shadow mastery tracking
    if (combusettingstable["combucrit"]==true) then
            
        local a9,b9,c9,d9,e9,f9,g9,h9,i9,j9,k9 = UnitAura("target", CritMass, nil, "HARMFUL")
        local a10,b10,c10,d10,e10,f10,g10,h10,i10,j10,k10 = UnitAura("target", ShadowMast, nil, "HARMFUL")

        if (k9==22959) then combucrittimer = (-1*(time-g9))
        elseif (k10==17800) then combucrittimer = (-1*(time-g10))
        else combucrittimer = 0
        end

        if (combucrittimer >= combusettingstable["combutimervalue"]) and (combucrittimer ~= 0) -- condition when timer is with more than 2 seconds left
                then CritTextFrameLabel:SetText(format("|cff00ff00%.1f|r",combucrittimer))
                     CritTextFrameLabel:SetJustifyH("RIGHT")
                     CritTypeFrameLabel:SetText(format(CombuLabel["critmasswhite"]))
        elseif (combucrittimer <= combusettingstable["combutimervalue"]) and (combucrittimer ~= 0) -- condition when timer is with less than 2 seconds left
                then CritTextFrameLabel:SetText(format("|cffff0000%.1f|r",combucrittimer))
                     CritTextFrameLabel:SetJustifyH("RIGHT")
                     CritTypeFrameLabel:SetText(format(CombuLabel["critmasswhite"]))
        else CritTextFrameLabel:SetText(format(CombuLabel["critmassred"]))
             CritTextFrameLabel:SetJustifyH("LEFT")
             CritTypeFrameLabel:SetText("")
        end
                    
        if (k9==22959) and (combucrittimer <= combusettingstable["combutimervalue"])
            then Critbar:Show()
             Critbar:SetValue((92+combucritwidth)*((g9-GetTime())/f9))
             Critbar:SetStatusBarColor(unpack(combusettingstable["barcolorwarning"]))
        elseif (k9==22959)
            then Critbar:Show()
             Critbar:SetValue((92+combucritwidth)*((g9-GetTime())/f9))
             Critbar:SetStatusBarColor(unpack(combusettingstable["barcolornormal"]))
        elseif (k10==17800) and (combucrittimer <= combusettingstable["combutimervalue"]) 
            then Critbar:Show()
             Critbar:SetValue((92+combucritwidth)*((g10-GetTime())/f10))
             Critbar:SetStatusBarColor(unpack(combusettingstable["barcolorwarning"]))
        elseif (k10==17800) 
            then Critbar:Show()
             Critbar:SetValue((92+combucritwidth)*((g10-GetTime())/f10))
             Critbar:SetStatusBarColor(unpack(combusettingstable["barcolornormal"]))
        else Critbar:Hide()
        end
    end
            
--------------------------------
-- Combustion on target tracking
    if (combusettingstable["combutrack"]==true) then
            
            local a11,b11,c11,d11,e11,f11,g11,h11,i11,j11,k11 = UnitAura("target", combudot, nil, "PLAYER HARMFUL")

			if (k11==83853) then combudottimer = (-1*(time-g11))
			else combudottimer = 0
			end

			if (k11==83853) and (combudottimer <= combusettingstable["combutimervalue"])
				then Combubar:Show()
                 Combubar:SetValue((92+combucritwidth)*((g11-GetTime())/f11))
                 Combubar:SetStatusBarColor(unpack(combusettingstable["barcolorwarning"]))
			elseif (k11==83853)
				then Combubar:Show()
                 Combubar:SetValue((92+combucritwidth)*((g11-GetTime())/f11))
                 Combubar:SetStatusBarColor(unpack(combusettingstable["barcolornormal"]))
            else Combubar:Hide()
			end
			
			if combutimestamp and GetTime() >= (combutimestamp + 13) then
				if combucombustionprevdmg == 0 then
					print(format(CombuLoc["combureport1"],combucombustiondmg,combuticks,combutickdmg,combutargets))
					combutimestamp = nil
				else print(format(CombuLoc["combureport1"],combucombustiondmg,combuticks,combutickdmg,combutargets))
                    print(format(CombuLoc["combureport2"],combucombustionprevdmg,combuprevticks,combutickprevdmg,combuprevtargets))
					combutimestamp = nil
				end
			end
    end
    
--------------------------------
-- Background/border colors settings
    if (combusettingstable["combureportthreshold"] == true) then
    	
    	if (CombustionUp == 1) and (combusettingstable["combureportvalue"] <= combuigndamage) and (combusettingstable["combureportvalue"] ~= 0) 
        	then CombustionFrame:SetBackdropColor(unpack(combusettingstable["bgcolorcombustion"])) --Green background for frame when threshold is met and combustion are up
            	 CombustionFrame:SetBackdropBorderColor(unpack(combusettingstable["bgcolorcombustion"]))
                 if combusettingstable["thresholdalert"] == true then
                    PlaySoundFile(CombuLSM:Fetch("sound",combusettingstable["combusoundname"]))
                 end
        elseif (CombustionUp == 0) and (ImpactUp == 1) and (combusettingstable["combureportvalue"] <= combuigndamage) 
        	then CombustionFrame:SetBackdropColor(unpack(combusettingstable["bgcolorimpact"])) --yellow bg frame when threshold is met and impact are up
            	 CombustionFrame:SetBackdropBorderColor(unpack(combusettingstable["bgcolorimpact"]))
        else CombustionFrame:SetBackdropColor(unpack(combusettingstable["bgcolornormal"]))
         	 CombustionFrame:SetBackdropBorderColor(unpack(combusettingstable["edgecolornormal"]))
        end
        
    elseif (LBTime == 1) --Green background for frame when dots and combustion are up
        and (FFBTime == 1) 
        and (IgnTime == 1) 
        and (PyroTime == 1) 
        and (CombustionUp == 1)
        and (combusettingstable["combureportthreshold"] == false) 
        then CombustionFrame:SetBackdropColor(unpack(combusettingstable["bgcolorcombustion"])) --Green bg for frame when dots and combustion are up
             CombustionFrame:SetBackdropBorderColor(unpack(combusettingstable["bgcolorcombustion"]))
    elseif (LBTime == 1) --Yellow background for frame when dots and Impact are up
        and (FFBTime == 1) 
        and (IgnTime == 1) 
        and (PyroTime == 1) 
        and (ImpactUp == 1)
        and (CombustionUp == 0) 
        and (combusettingstable["combureportthreshold"] == false) 
        then CombustionFrame:SetBackdropColor(unpack(combusettingstable["bgcolorimpact"]))
             CombustionFrame:SetBackdropBorderColor(unpack(combusettingstable["bgcolorimpact"]))
    else CombustionFrame:SetBackdropColor(unpack(combusettingstable["bgcolornormal"]))
         CombustionFrame:SetBackdropBorderColor(unpack(combusettingstable["edgecolornormal"]))
    end
    
    if (k7 == 64343) and (ImpactUp == 1) -- yellow border when impact is up
        then CombustionFrame:SetBackdropBorderColor(unpack(combusettingstable["bgcolorimpact"]))
    end
    
--------------------------------
 -- autohide part 
 
    CombustionAutohide()
    
--------------------------------
-- multiple Living Bomb tracking
    if (combusettingstable["combulbtracker"] == true) or (combusettingstable["combuflamestrike"] == true)
        then CombuLBtrackerUpdate()
    end

--------------------------------
-- Combustion Damage predicter
	
	CombuDamagePredicter ()
	
--------------------------------
-- Tick Manager 
    
    --CombuTickManager()    

--------------------------------
    self.TimeSinceLastUpdate = 0

    end    
end


SLASH_COMBUCONFIG1 = "/combustionhelper"

SlashCmdList["COMBUCONFIG"] = function(msg)

	if msg == "" or  msg == "help" or  msg == "?" or msg == "config" then
		 InterfaceOptionsFrame_OpenToCategory("CombustionHelper")
		 if (combusettingstable["combuchat"]==true) then print(format(CombuLoc["slashcomm"])) end
	else
		 InterfaceOptionsFrame_OpenToCategory("CombustionHelper")
		 if (combusettingstable["combuchat"]==true) then print(format(CombuLoc["slashcomm"])) end
	end

end
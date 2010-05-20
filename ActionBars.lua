-- Config start
local micromenuscale = 0.5
local bagscale = 0.9
local size = 28
local spacing = 3
local frame_positions = {
	[1]  =  { a = "BOTTOM",         x = 0,    y = 12   },  -- MainBar
	[2]  =  { a = "BOTTOM",         x = 0,    y = 74   },  -- MultiBarBottomLeftBar
	[3]  =  { a = "BOTTOM",         x = 0,    y = 43   },  -- MultiBarBottomRightBar
	[4]  =  { a = "RIGHT",          x = -43,  y = -150 },  -- MultiBarLeftBar
	[5]  =  { a = "RIGHT",          x = -12,  y = -150 },  -- MultiBarRightBar
	[6]  =  { a = "BOTTOM",         x = 0,    y = 105  },  -- PetBar
	[7]  =  { a = "BOTTOM",         x = 280,  y = 175  },  -- ShapeShiftBar
	[8]  =  { a = "BOTTOMRIGHT",    x = 5,    y = -5   },  -- BagBar
	[9]  =  { a = "TOPRIGHT",       x = -15,  y = -265 },  -- MicroMenuBar
	[10] =  { a = "LEFT",           x = 251,  y = -6   },  -- VehicleBar
}
-- Config end


local dummy = function() end

local CreateBarFrame = function(name, pos)
	local bar = CreateFrame("Frame", name, UIParent)
	bar:SetPoint(pos.a, pos.x, pos.y)
	return bar
end

local Move = function(bar, button, num, orient, parent)
	for i = 1, num do
		_G[button..i]:ClearAllPoints()
		_G[button..i]:SetWidth(size)
		_G[button..i]:SetHeight(size)
		if i == 1 then
			_G[button..i]:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, 0)
		else
			if orient == "H" then
				_G[button..i]:SetPoint("TOPLEFT", _G[button..(i-1)], "TOPRIGHT", spacing, 0)
			else
				_G[button..i]:SetPoint("TOPLEFT", _G[button..(i-1)], "BOTTOMLEFT", 0, -spacing)
			end
		end
		_G[button..i].SetPoint = dummy
	end
	if orient == "H" then
		bar:SetWidth(size*num + spacing*(num-1))
		bar:SetHeight(size)
	else
		bar:SetWidth(size)
		bar:SetHeight(size*num + spacing*(num-1))
	end
end


local mainbar = CreateBarFrame("mod_MainBar", frame_positions[1])
local bottomleftbar = CreateBarFrame("mod_MultiBarBottomLeftBar", frame_positions[2])
local bottomrightbar = CreateBarFrame("mod_MultiBarBottomRightBar", frame_positions[3])
local leftbar = CreateBarFrame("mod_MultiBarLeftBar", frame_positions[4])
local rightbar = CreateBarFrame("mod_MultiBarRightBar", frame_positions[5])
local petbar = CreateBarFrame("mod_PetBar", frame_positions[6])
local shapeshiftbar = CreateBarFrame("mod_ShapeShiftBar", frame_positions[7])

local bagbar = CreateBarFrame("mod_BagBar", frame_positions[8])
bagbar:SetWidth(220)
bagbar:SetHeight(60)

local micromenubar = CreateBarFrame("mod_MicroMenuBar", frame_positions[9])
micromenubar:SetWidth(263)
micromenubar:SetHeight(60)

local vehiclebar = CreateBarFrame("mod_VehicleBar", frame_positions[10])
vehiclebar:SetWidth(70)
vehiclebar:SetHeight(70) 


for i=1, NUM_ACTIONBAR_BUTTONS do
	_G["ActionButton"..i]:SetParent(mainbar)
end
BonusActionBarFrame:SetParent(mainbar)
BonusActionBarFrame:SetWidth(0.01)
MultiBarBottomLeft:SetParent(bottomleftbar)
MultiBarBottomRight:SetParent(bottomrightbar)
MultiBarLeft:SetParent(leftbar)
MultiBarRight:SetParent(rightbar)
ShapeshiftBarFrame:SetParent(shapeshiftbar)
PetActionBarFrame:SetParent(petbar)
Move(mainbar, "ActionButton", NUM_ACTIONBAR_BUTTONS, "H")
Move(mainbar, "BonusActionButton", NUM_ACTIONBAR_BUTTONS, "H")
Move(bottomleftbar, "MultiBarBottomLeftButton", NUM_ACTIONBAR_BUTTONS, "H")
Move(bottomrightbar, "MultiBarBottomRightButton", NUM_ACTIONBAR_BUTTONS, "H")
Move(leftbar, "MultiBarLeftButton", NUM_ACTIONBAR_BUTTONS, "V")
Move(rightbar, "MultiBarRightButton", NUM_ACTIONBAR_BUTTONS, "V")
Move(shapeshiftbar, "ShapeshiftButton", NUM_SHAPESHIFT_SLOTS, "H")
Move(shapeshiftbar, "PossessButton", NUM_POSSESS_SLOTS, "H")
Move(petbar, "PetActionButton", NUM_PET_ACTION_SLOTS, "H")

MainMenuBarVehicleLeaveButton:SetScript("OnLoad", nil)
MainMenuBarVehicleLeaveButton:SetScript("OnEvent", nil)
MainMenuBarVehicleLeaveButton:SetParent(vehiclebar)
MainMenuBarVehicleLeaveButton:ClearAllPoints()
MainMenuBarVehicleLeaveButton:SetPoint("CENTER", 0, 0)
MainMenuBarVehicleLeaveButton:RegisterEvent("UNIT_ENTERED_VEHICLE")
MainMenuBarVehicleLeaveButton:RegisterEvent("UNIT_EXITED_VEHICLE")
MainMenuBarVehicleLeaveButton:SetScript("OnEvent", function(self, event, ...)
	if CanExitVehicle() then
		self:Show()
	else
		self:Hide()
	end
end)


local FramesToHide = {
	MainMenuBar,
	VehicleMenuBar,
	BonusActionBarTexture0,
	BonusActionBarTexture1,
}

for _, v in pairs(FramesToHide) do
	if(v:GetObjectType() == 'Texture') then
		v:SetTexture(nil)
	else
		v:Hide()
		v.Show = dummy
	end
end

--bags
local BagButtons = {
	MainMenuBarBackpackButton,
	CharacterBag0Slot,
	CharacterBag1Slot,
	CharacterBag2Slot,
	CharacterBag3Slot,
	KeyRingButton,
}
for _, f in pairs(BagButtons) do
	f:SetParent(bagbar)
end
MainMenuBarBackpackButton:ClearAllPoints()
MainMenuBarBackpackButton:SetPoint("BOTTOMRIGHT", -15, 15)
bagbar:Hide()

--mircro menu
local MicroButtons = {
	CharacterMicroButton,
	SpellbookMicroButton,
	TalentMicroButton,
	AchievementMicroButton,
	QuestLogMicroButton,
	SocialsMicroButton,
	PVPMicroButton,
	LFDMicroButton,
	MainMenuMicroButton,
	HelpMicroButton,
}
local function MoveMicroButtons(skinName)
	for _, f in pairs(MicroButtons) do
		f:SetParent(micromenubar)
	end
	CharacterMicroButton:ClearAllPoints()
	CharacterMicroButton:SetPoint("BOTTOMLEFT", 5, 5)
	SocialsMicroButton:ClearAllPoints()
	SocialsMicroButton:SetPoint("LEFT", QuestLogMicroButton, "RIGHT", -3, 0)
	--UpdateTalentButton()
end
hooksecurefunc("VehicleMenuBar_MoveMicroButtons", MoveMicroButtons)
MoveMicroButtons()



-- hide actionbuttons when the bonusbar is visible (rogue stealth and such)
local function showhideactionbuttons(alpha)
	local f = "ActionButton"
	for i=1, 12 do
		_G[f..i]:SetAlpha(alpha)
	end
end
BonusActionBarFrame:HookScript("OnShow", function(self) showhideactionbuttons(0) end)
BonusActionBarFrame:HookScript("OnHide", function(self) showhideactionbuttons(1) end)
if BonusActionBarFrame:IsShown() then
	showhideactionbuttons(0)
end


micromenubar:SetScale(micromenuscale)
bagbar:SetScale(bagscale)

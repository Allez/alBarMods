
-- Config start
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
local vehiclebar = CreateBarFrame("mod_VehicleBar", frame_positions[10])
vehiclebar:SetWidth(70)
vehiclebar:SetHeight(70) 

Move(mainbar, "ActionButton", NUM_ACTIONBAR_BUTTONS, "H")
Move(mainbar, "BonusActionButton", NUM_BONUS_ACTION_SLOTS, "H")
Move(bottomleftbar, "MultiBarBottomLeftButton", NUM_MULTIBAR_BUTTONS, "H")
Move(bottomrightbar, "MultiBarBottomRightButton", NUM_MULTIBAR_BUTTONS, "H")
Move(leftbar, "MultiBarLeftButton", NUM_MULTIBAR_BUTTONS, "V")
Move(rightbar, "MultiBarRightButton", NUM_MULTIBAR_BUTTONS, "V")
Move(shapeshiftbar, "PossessButton", NUM_POSSESS_SLOTS, "H")
Move(shapeshiftbar, "ShapeshiftButton", NUM_SHAPESHIFT_SLOTS, "H")
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
	VehicleMenuBar,
	BonusActionBarTexture0,
	BonusActionBarTexture1,
	ReputationWatchBarTexture0,
	ReputationWatchBarTexture1,
	ReputationWatchBarTexture2,
	ReputationWatchBarTexture3,
	ReputationXPBarTexture0,
	ReputationXPBarTexture1,
	ReputationXPBarTexture2,
	ReputationXPBarTexture3,
	MainMenuXPBarTexture0,
	MainMenuXPBarTexture1,
	MainMenuXPBarTexture2,
	MainMenuXPBarTexture3,
	MainMenuMaxLevelBar0,
	MainMenuMaxLevelBar1,
	MainMenuMaxLevelBar2,
	MainMenuMaxLevelBar3,
	MainMenuBarTexture0,
	MainMenuBarTexture1,
	MainMenuBarTexture2,
	MainMenuBarTexture3,
	MainMenuBarBackpackButton,
	CharacterBag0Slot,
	CharacterBag1Slot,
	CharacterBag2Slot,
	CharacterBag3Slot,
	KeyRingButton,
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

for _, v in pairs(FramesToHide) do
	if v:GetObjectType() == 'Texture' then
		v:SetTexture(nil)
	else
		v:Hide()
		v.Show = dummy
	end
end

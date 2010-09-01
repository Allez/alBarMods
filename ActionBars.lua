-- Config start
local size = 27
local spacing = 3
local frame_positions = {
	[1]  =  { a = "BOTTOM",         x = 0,    y = 12   },  -- MainBar
	[2]  =  { a = "BOTTOM",         x = 0,    y = 72   },  -- MultiBarBottomLeftBar
	[3]  =  { a = "BOTTOM",         x = 0,    y = 42   },  -- MultiBarBottomRightBar
	[4]  =  { a = "RIGHT",          x = -42,  y = 0    },  -- MultiBarLeftBar
	[5]  =  { a = "RIGHT",          x = -12,  y = 0    },  -- MultiBarRightBar
	[6]  =  { a = "BOTTOM",         x = 0,    y = 102  },  -- PetBar
	[7]  =  { a = "BOTTOMLEFT",     x = 12,   y = 200  },  -- ShapeShiftBar
	[8]  =  { a = "LEFT",           x = 251,  y = -6   },  -- VehicleBar
}
-- Config end


local dummy = function() end

local Move = function(bar, button, num, orient, pos)
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
	end
	if orient == "H" then
		bar:SetWidth(size*num + spacing*(num-1))
		bar:SetHeight(size)
	else
		bar:SetWidth(size)
		bar:SetHeight(size*num + spacing*(num-1))
	end
	if pos then
		bar:SetPoint(pos.a, pos.x, pos.y)
	end
end

local vehiclebar = CreateFrame("Frame", "mod_VehicleBar", UIParent)

local VehicleLeaveButton = CreateFrame("Button", "mod_VehicleLeaveButton", vehiclebar)
VehicleLeaveButton:SetNormalTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Up")
VehicleLeaveButton:SetPushedTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Down")
VehicleLeaveButton:SetHighlightTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Down")
VehicleLeaveButton:RegisterEvent("UNIT_ENTERED_VEHICLE")
VehicleLeaveButton:RegisterEvent("UNIT_EXITED_VEHICLE")
VehicleLeaveButton:SetScript("OnClick", function(self) 
	VehicleExit()
end)
VehicleLeaveButton:SetScript("OnEvent", function(self)
	if CanExitVehicle() then
		self:Show()
	else
		self:Hide()
	end
end)
VehicleLeaveButton:Hide()

Move(MainMenuBar, "ActionButton", NUM_ACTIONBAR_BUTTONS, "H", frame_positions[1])
Move(MainMenuBar, "BonusActionButton", NUM_BONUS_ACTION_SLOTS, "H")
Move(MultiBarBottomLeft, "MultiBarBottomLeftButton", NUM_MULTIBAR_BUTTONS, "H", frame_positions[2])
Move(MultiBarBottomRight, "MultiBarBottomRightButton", NUM_MULTIBAR_BUTTONS, "H", frame_positions[3])
Move(MultiBarLeft, "MultiBarLeftButton", NUM_MULTIBAR_BUTTONS, "V", frame_positions[4])
Move(MultiBarRight, "MultiBarRightButton", NUM_MULTIBAR_BUTTONS, "V", frame_positions[5])
Move(ShapeshiftBarFrame, "PossessButton", NUM_POSSESS_SLOTS, "H")
Move(ShapeshiftBarFrame, "ShapeshiftButton", NUM_SHAPESHIFT_SLOTS, "H", frame_positions[7])
Move(PetActionBarFrame, "PetActionButton", NUM_PET_ACTION_SLOTS, "H")
Move(vehiclebar, "mod_VehicleLeaveButton", 1, "H", frame_positions[8])

local FramesToHide = {
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
	SlidingActionBarTexture0,	
	SlidingActionBarTexture1,
	BonusActionBarTexture0,
	BonusActionBarTexture1,

	ShapeshiftBarLeft,			
	ShapeshiftBarMiddle,
	ShapeshiftBarRight,			
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
	MainMenuBarBackpackButton,
	CharacterBag0Slot,
	CharacterBag1Slot,
	CharacterBag2Slot,
	CharacterBag3Slot,
	MainMenuBarPageNumber,
	MainMenuBarPerformanceBarFrame,
	ActionBarUpButton,
	ActionBarDownButton,
	KeyRingButton,
	MainMenuBarLeftEndCap,
	MainMenuBarRightEndCap,
	ReputationWatchBar,
	MainMenuExpBar,
	ExhaustionTick,
}

for _, v in pairs(FramesToHide) do
	if v:GetObjectType() == 'Texture' then
		v:SetTexture(nil)
		v.SetTexture = dummy
	else
		v:Hide()
		v.Show = dummy
	end
end

local bars = {
	MainMenuBar,
	MultiBarBottomLeft,
	MultiBarBottomRight,
	MultiBarLeft,
	MultiBarRight,
	PetActionBarFrame,
	BonusActionBarFrame,
	ShapeshiftBarFrame,
	PossessBarFrame,
}

for _, v in pairs(bars) do
	UIPARENT_MANAGED_FRAME_POSITIONS[v] = nil
end

AchievementMicroButton_Update = dummy
-- Config start
local size = 27
local spacing = 3
local frame_positions = {
	[1]  =  { a = "BOTTOM",     x = 0,    y = 12  },  -- MainBar
	[2]  =  { a = "BOTTOM",     x = 0,    y = 72  },  -- MultiBarBottomLeftBar
	[3]  =  { a = "BOTTOM",     x = 0,    y = 42  },  -- MultiBarBottomRightBar
	[4]  =  { a = "RIGHT",      x = -42,  y = 0   },  -- MultiBarLeftBar
	[5]  =  { a = "RIGHT",      x = -12,  y = 0   },  -- MultiBarRightBar
	[6]  =  { a = "BOTTOM",     x = 0,    y = 102 },  -- PetBar
	[7]  =  { a = "BOTTOMLEFT", x = 12,   y = 200 },  -- ShapeShiftBar
	[8]  =  { a = "LEFT",       x = 251,  y = -6  },  -- VehicleBar
}
-- Config end


local CreateBarFrame = function(name, pos)
	local bar = CreateFrame("Frame", name, UIParent)
	bar:SetPoint(pos.a, pos.x, pos.y)
	return bar
end

local Move = function(bar, button, num, orient, bsize)
	local size = bsize or size
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
end

local bar1 = CreateBarFrame("mod_MainBar", frame_positions[1])
local bar2 = CreateBarFrame("mod_MultiBarBottomLeftBar", frame_positions[2])
local bar3 = CreateBarFrame("mod_MultiBarBottomRightBar", frame_positions[3])
local bar4 = CreateBarFrame("mod_MultiBarLeftBar", frame_positions[4])
local bar5 = CreateBarFrame("mod_MultiBarRightBar", frame_positions[5])
local bar6 = CreateBarFrame("mod_PetBar", frame_positions[6])
local bar7 = CreateBarFrame("mod_ShapeShiftBar", frame_positions[7])
local bar8 = CreateBarFrame("mod_VehicleBar", frame_positions[8])

local VehicleLeaveButton = CreateFrame("Button", "VehicleLeaveButton1", UIParent)
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

for i = 1, 12 do
	_G["ActionButton"..i]:SetParent(UIParent)
end
BonusActionBarFrame:SetParent(UIParent)
MultiBarBottomLeft:SetParent(UIParent)
MultiBarBottomRight:SetParent(UIParent)
MultiBarLeft:SetParent(UIParent)
MultiBarRight:SetParent(UIParent)
PetActionBarFrame:SetParent(UIParent)
ShapeshiftBarFrame:SetParent(UIParent)
PossessBarFrame:SetParent(UIParent)

Move(bar1, "ActionButton", NUM_ACTIONBAR_BUTTONS, "H")
Move(bar1, "BonusActionButton", NUM_BONUS_ACTION_SLOTS, "H")
Move(bar2, "MultiBarBottomLeftButton", NUM_MULTIBAR_BUTTONS, "H")
Move(bar3, "MultiBarBottomRightButton", NUM_MULTIBAR_BUTTONS, "H")
Move(bar4, "MultiBarLeftButton", NUM_MULTIBAR_BUTTONS, "V")
Move(bar5, "MultiBarRightButton", NUM_MULTIBAR_BUTTONS, "V")
Move(bar7, "PossessButton", NUM_POSSESS_SLOTS, "H")
Move(bar6, "PetActionButton", NUM_PET_ACTION_SLOTS, "H")
Move(bar8, "VehicleLeaveButton", 1, "H", 50)
hooksecurefunc("ShapeshiftBar_Update", function()
	Move(bar7, "ShapeshiftButton", NUM_SHAPESHIFT_SLOTS, "H")
end)

for _, obj in pairs({
	SlidingActionBarTexture0,
	SlidingActionBarTexture1,
	BonusActionBarTexture0,
	BonusActionBarTexture1,
	ShapeshiftBarLeft,
	ShapeshiftBarRight,
	ShapeshiftBarMiddle,
	MainMenuBar,
	VehicleMenuBar,
}) do
	if obj:GetObjectType() == 'Texture' then
		obj:SetTexture(nil)
	else
		obj:SetScale(0.001)
		obj:SetAlpha(0)
	end
end

AchievementMicroButton_Update = function() end
VehicleMenuBar_MoveMicroButtons = function() end

BonusActionBarFrame:HookScript("OnShow", function(self)
	for i = 1, 12 do
		_G["ActionButton"..i]:SetAlpha(0)
	end
end)
BonusActionBarFrame:HookScript("OnHide", function(self)
	for i = 1, 12 do
		_G["ActionButton"..i]:SetAlpha(1)
	end
end)

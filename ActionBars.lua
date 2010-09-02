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
vehiclebar:SetWidth(50)
vehiclebar:SetHeight(50)

for i = 1, 12 do
	_G["ActionButton"..i]:SetParent(bar1)
end
BonusActionBarFrame:SetParent(bar1)
MultiBarBottomLeft:SetParent(bar2)
MultiBarBottomRight:SetParent(bar3)
MultiBarLeft:SetParent(bar4)
MultiBarRight:SetParent(bar5)
PetActionBarFrame:SetParent(bar6)
ShapeshiftBarFrame:SetParent(bar7)
PossessBarFrame:SetParent(bar7)

Move(bar1, "ActionButton", NUM_ACTIONBAR_BUTTONS, "H")
Move(bar1, "BonusActionButton", NUM_BONUS_ACTION_SLOTS, "H")
Move(bar2, "MultiBarBottomLeftButton", NUM_MULTIBAR_BUTTONS, "H")
Move(bar3, "MultiBarBottomRightButton", NUM_MULTIBAR_BUTTONS, "H")
Move(bar4, "MultiBarLeftButton", NUM_MULTIBAR_BUTTONS, "V")
Move(bar5, "MultiBarRightButton", NUM_MULTIBAR_BUTTONS, "V")
Move(bar7, "PossessButton", NUM_POSSESS_SLOTS, "H")
Move(bar7, "ShapeshiftButton", NUM_SHAPESHIFT_SLOTS, "H")
Move(bar6, "PetActionButton", NUM_PET_ACTION_SLOTS, "H")

local VehicleLeaveButton = CreateFrame("Button", "mod_VehicleLeaveButton", vehiclebar)
VehicleLeaveButton:SetNormalTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Up")
VehicleLeaveButton:SetPushedTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Down")
VehicleLeaveButton:SetHighlightTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Down")
VehicleLeaveButton:SetAllPoints()
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

for _, obj in pairs({
	SlidingActionBarTexture0,
	SlidingActionBarTexture1,
	ShapeshiftBarLeft,
	ShapeshiftBarRight,
	ShapeshiftBarMiddle,
	MainMenuBar,
	VehicleMenuBar,
}) do
	if obj:GetObjectType() == 'Texture' then
		obj:SetTexture(nil)
	else
		obj:Hide()
		obj.Show = function() end
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

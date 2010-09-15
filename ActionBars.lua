-- Config start
local size = 27
local spacing = 3
local frame_positions = {
	["modMainBar"]          =  { a = "BOTTOM",     x = 0,    y = 12  },  -- MainBar
	["MultiBarBottomLeft"]  =  { a = "BOTTOM",     x = 0,    y = 72  },  -- MultiBarBottomLeftBar
	["MultiBarBottomRight"] =  { a = "BOTTOM",     x = 0,    y = 42  },  -- MultiBarBottomRightBar
	["MultiBarLeft"]        =  { a = "RIGHT",      x = -42,  y = 0   },  -- MultiBarLeftBar
	["MultiBarRight"]       =  { a = "RIGHT",      x = -12,  y = 0   },  -- MultiBarRightBar
	["PetActionBarFrame"]   =  { a = "BOTTOM",     x = 0,    y = 102 },  -- PetBar
	["ShapeshiftBarFrame"]  =  { a = "BOTTOMLEFT", x = 12,   y = 200 },  -- ShapeShiftBar
	["modVehicleBar"]       =  { a = "LEFT",       x = 251,  y = -6  },  -- VehicleBar
}
-- Config end


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

local mainBar = CreateFrame("Frame", "modMainBar", UIParent)
local vehicleBar = CreateFrame("Frame", "modVehicleBar", UIParent)

local VehicleLeaveButton = CreateFrame("Button", "VehicleLeaveButton1", vehicleBar)
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
	_G["ActionButton"..i]:SetParent(mainBar)
end
BonusActionBarFrame:SetParent(UIParent)
MultiBarBottomLeft:SetParent(UIParent)
MultiBarBottomRight:SetParent(UIParent)
MultiBarLeft:SetParent(UIParent)
MultiBarRight:SetParent(UIParent)
PetActionBarFrame:SetParent(UIParent)
ShapeshiftBarFrame:SetParent(UIParent)
PossessBarFrame:SetParent(UIParent)

for bar, pos in pairs(frame_positions) do
	_G[bar]:ClearAllPoints()
	_G[bar]:SetPoint(pos.a, pos.x, pos.y)
end

Move(mainBar, "ActionButton", NUM_ACTIONBAR_BUTTONS, "H")
Move(mainBar, "BonusActionButton", NUM_BONUS_ACTION_SLOTS, "H")
Move(MultiBarBottomLeft, "MultiBarBottomLeftButton", NUM_MULTIBAR_BUTTONS, "H")
Move(MultiBarBottomRight, "MultiBarBottomRightButton", NUM_MULTIBAR_BUTTONS, "H")
Move(MultiBarLeft, "MultiBarLeftButton", NUM_MULTIBAR_BUTTONS, "V")
Move(MultiBarRight, "MultiBarRightButton", NUM_MULTIBAR_BUTTONS, "V")
Move(ShapeshiftBarFrame, "PossessButton", NUM_POSSESS_SLOTS, "H")
Move(PetActionBarFrame, "PetActionButton", NUM_PET_ACTION_SLOTS, "H")
Move(vehicleBar, "VehicleLeaveButton", 1, "H", 50)
hooksecurefunc("ShapeshiftBar_Update", function()
	Move(ShapeshiftBarFrame, "ShapeshiftButton", NUM_SHAPESHIFT_SLOTS, "H")
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

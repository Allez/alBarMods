-- Config start
local size = 23
local spacing = 7
local showgrid = true
local frame_positions = {
	[1]	=	{ a = "BOTTOM",     x = 0,   y = 11  },	-- MainBar
	[2]	=	{ a = "BOTTOM",     x = 0,   y = 71  },	-- MultiBarBottomLeft
	[3]	=	{ a = "BOTTOM",     x = 0,	 y = 41  },	-- MultiBarBottomRight
	[4]	=	{ a = "RIGHT",      x = -41, y = 0   },	-- MultiBarLeft
	[5]	=	{ a = "RIGHT",      x = -11, y = 0   },	-- MultiBarRight
	[6]	=	{ a = "BOTTOM",     x = 0,   y = 101 },	-- PetBar
	[7]	=	{ a = "BOTTOMLEFT", x = 12,  y = 210 },	-- ShapeShiftBar
	[8]	=	{ a = "LEFT",       x = 251, y = -6  },	-- VehicleBar
	[9]	=	{ a = "BOTTOMLEFT", x = 12,  y = 210 }, -- TotemBar
}
-- Config end

local config = {
	["Button size"] = size,
	["Spacing"] = spacing,
	["Show grid"] = showgrid,
}
if UIConfig then
	UIConfig["Action bars"] = config
end

local bars = {}
local move = false

local CreateBarFrame = function(name, pos)
	local bar = CreateFrame("Frame", name, UIParent, "SecureHandlerStateTemplate")
	bar:SetPoint(pos.a, pos.x, pos.y)
	bar:SetMovable(true)
	bar:SetUserPlaced(true)
	bar:SetBackdrop({
		bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
		insets = {top = 0, left = 0, bottom = 0, right = 0},
	})
	bar:SetBackdropColor(0, 0, 0, 0)
	bar.label = bar:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
	bar.label:SetPoint("CENTER")
	bar.label:SetText(name)
	bar.label:Hide()
	tinsert(bars, bar)
	if UIMovableFrames then tinsert(UIMovableFrames, bar) end
	return bar
end

local SetButtons = function(bar, button, num, orient, bsize)
	local size = bsize or config["Button size"]
	local spacing = config["Spacing"]
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
local bar9 = CreateBarFrame("mod_TotemBar", frame_positions[9])

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

for _, v in pairs({
	MultiBarBottomLeft,
	MultiBarBottomRight,
	MultiBarLeft,
	MultiBarRight,
	PetActionBarFrame,
	ShapeshiftBarFrame,
}) do
	v:SetParent(UIParent)
	v:SetWidth(0.01)
end

hooksecurefunc("ShapeshiftBar_Update", function()
	if GetNumShapeshiftForms() == 1 and not InCombatLockdown() then
		ShapeshiftButton1:SetPoint("BOTTOMLEFT", bar7, "BOTTOMLEFT", 0, 0)
	end
end)

for _, obj in pairs({
	SlidingActionBarTexture0,
	SlidingActionBarTexture1,
	BonusActionBarFrameTexture0,
	BonusActionBarFrameTexture1,
	BonusActionBarFrame,
	ShapeshiftBarLeft,
	ShapeshiftBarRight,
	ShapeshiftBarMiddle,
	MainMenuBar,
	VehicleMenuBar,
	PossessBarFrame,
}) do
	if obj:GetObjectType() == 'Texture' then
		obj:SetTexture("")
	else
		obj:SetScale(0.001)
		obj:SetAlpha(0)
	end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent(event)
	if config["Show grid"] then
		ActionButton_HideGrid = function() end
		for i = 1, 12 do
			_G["ActionButton"..i]:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(_G["ActionButton"..i])
			_G["BonusActionButton"..i]:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(_G["BonusActionButton"..i])
			_G["MultiBarRightButton"..i]:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(_G["MultiBarRightButton"..i])
			_G["MultiBarLeftButton"..i]:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(_G["MultiBarLeftButton"..i])
			_G["MultiBarBottomRightButton"..i]:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(_G["MultiBarBottomRightButton"..i])
			_G["MultiBarBottomLeftButton"..i]:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(_G["MultiBarBottomLeftButton"..i])
		end
	end
	SetButtons(bar1, "ActionButton", NUM_ACTIONBAR_BUTTONS, "H")
	SetButtons(bar2, "MultiBarBottomLeftButton", NUM_MULTIBAR_BUTTONS, "H")
	SetButtons(bar3, "MultiBarBottomRightButton", NUM_MULTIBAR_BUTTONS, "H")
	SetButtons(bar4, "MultiBarLeftButton", NUM_MULTIBAR_BUTTONS, "V")
	SetButtons(bar5, "MultiBarRightButton", NUM_MULTIBAR_BUTTONS, "V")
	SetButtons(bar6, "PetActionButton", NUM_PET_ACTION_SLOTS, "H")
	SetButtons(bar7, "ShapeshiftButton", NUM_SHAPESHIFT_SLOTS, "H")
	SetButtons(bar8, "VehicleLeaveButton", 1, "H", 45)
	if MultiCastActionBarFrame then
		MultiCastActionBarFrame:SetScript("OnUpdate", nil)
		MultiCastActionBarFrame:SetScript("OnShow", nil)
		MultiCastActionBarFrame:SetScript("OnHide", nil)
		MultiCastActionBarFrame:SetParent(bar9)
		MultiCastActionBarFrame:ClearAllPoints()
		MultiCastActionBarFrame:SetPoint("BOTTOMLEFT", bar9, 0, 0)
		for i = 1, 4 do
			local b = _G["MultiCastSlotButton"..i]
			local b2 = _G["MultiCastActionButton"..i]
			b:ClearAllPoints()
			b:SetAllPoints(b2)
		end
		MultiCastActionBarFrame.SetParent = function() end
		MultiCastActionBarFrame.SetPoint = function() end
		MultiCastRecallSpellButton.SetPoint = function() end
	end
end)

----------------------------------------------------------------------------------------
--	Setup Main Action Bar by Tukz
----------------------------------------------------------------------------------------

--[[ 
	Bonus bar classes id

	DRUID: Caster: 0, Cat: 1, Tree of Life: 2, Bear: 3, Moonkin: 4
	WARRIOR: Battle Stance: 1, Defensive Stance: 2, Berserker Stance: 3 
	ROGUE: Normal: 0, Stealthed: 1
	PRIEST: Normal: 0, Shadowform: 1
	
	When Possessing a Target: 5
]]--

local Page = {
	["DRUID"] = "[bonusbar:1,nostealth] 7; [bonusbar:1,stealth] 8; [bonusbar:2] 8; [bonusbar:3] 9; [bonusbar:4] 10;",
	["WARRIOR"] = "[bonusbar:1] 7; [bonusbar:2] 8; [bonusbar:3] 9;",
	["PRIEST"] = "[bonusbar:1] 7;",
	["ROGUE"] = "[bonusbar:1] 7; [form:3] 10;",
	["WARLOCK"] = "[form:2] 10;",
	["DEFAULT"] = "[bonusbar:5] 11; [bar:2] 2; [bar:3] 3; [bar:4] 4; [bar:5] 5; [bar:6] 6;",
}

local GetBar = function()
	local condition = Page["DEFAULT"]
	local class = select(2, UnitClass('player'))
	local page = Page[class]
	if page then
		condition = condition.." "..page
	end
	condition = condition.." 1"
	return condition
end

bar1:RegisterEvent("PLAYER_LOGIN")
bar1:RegisterEvent("PLAYER_ENTERING_WORLD")
bar1:RegisterEvent("PLAYER_TALENT_UPDATE")
bar1:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
bar1:RegisterEvent("KNOWN_CURRENCY_TYPES_UPDATE")
bar1:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
bar1:RegisterEvent("BAG_UPDATE")
bar1:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		local button
		for i = 1, NUM_ACTIONBAR_BUTTONS do
			button = _G["ActionButton"..i]
			self:SetFrameRef("ActionButton"..i, button)
		end	
		self:Execute([[
			buttons = table.new()
			for i = 1, 12 do
				table.insert(buttons, self:GetFrameRef("ActionButton"..i))
			end
		]])
		self:SetAttribute("_onstate-page", [[ 
			for i, button in ipairs(buttons) do
				button:SetAttribute("actionpage", tonumber(newstate))
			end
		]])
		RegisterStateDriver(self, "page", GetBar())
	elseif event == "PLAYER_ENTERING_WORLD" then
		MainMenuBar_UpdateKeyRing()
		for i = 1, NUM_ACTIONBAR_BUTTONS do
			_G["ActionButton"..i]:SetParent(UIParent)
		end
	elseif event == "PLAYER_TALENT_UPDATE" or event == "ACTIVE_TALENT_GROUP_CHANGED" then
		if not InCombatLockdown() then
			RegisterStateDriver(self, "page", GetBar())
		end
	else
		MainMenuBar_OnEvent(self, event, ...)
	end
end)

SlashCmdList["alBars"] = function(msg)
	if not move then
		for _, bar in pairs(bars) do
			bar.strata = bar:GetFrameStrata()
			bar:SetFrameStrata("TOOLTIP")
			bar:SetBackdropColor(0, 0.9, 0, 0.4)
			bar.label:Show()
			bar:EnableMouse(true)
			bar:RegisterForDrag("LeftButton")
			bar:SetScript("OnDragStart", function(self, button)
				self:StartMoving()
			end)
			bar:SetScript("OnDragStop", function(self, button)
				self:StopMovingOrSizing()
			end)
		end
		move = true
	else
		for _, bar in pairs(bars) do
			bar:RegisterForDrag(nil)
			bar:EnableMouse(false)
			bar:SetFrameStrata(bar.strata)
			bar:SetBackdropColor(0, 0, 0, 0)
			bar.label:Hide()
			bar:SetScript("OnDragStart", nil)
			bar:SetScript("OnDragStop", nil)
		end
		move = false
	end
end
SLASH_alBars1 = "/ab"
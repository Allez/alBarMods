-- Config start
local button_font = "Fonts\\FRIZQT__.TTF"
local hide_hotkey = 1
local update_timer = 0.1
-- Config end


local backdrop = {
	bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
	edgeFile = [=[Interface\ChatFrame\ChatFrameBackground]=], edgeSize = 1,
	insets = {top = 0, left = 0, bottom = 0, right = 0},
}

local modSetBorderColor = function(button)
	if not button.bd then return end
	if button.pushed then
		button.bd:SetBackdropBorderColor(1, 1, 1)
	elseif button.hover then
		button.bd:SetBackdropBorderColor(144, 255, 0)
	elseif button.checked then
		button.bd:SetBackdropBorderColor(0, 144, 255)
	elseif button.equipped then
		button.bd:SetBackdropBorderColor(0, 0.5, 0)
	else
		button.bd:SetBackdropBorderColor(0, 0, 0)
	end
end

local setStyle = function(bname)
	local button = _G[bname]

	local icon   = _G[bname.."Icon"]
	local flash  = _G[bname.."Flash"]
	local count  = _G[bname.."Count"]
	local border = _G[bname.."Border"]
	local hotkey = _G[bname.."HotKey"]
	local macro  = _G[bname.."Name"]

	flash:SetTexture("")
	button:SetHighlightTexture("")
	button:SetPushedTexture("")
	button:SetCheckedTexture("")
	button:SetNormalTexture("")

	if button.bd then return end
	if border then
		border:Hide()
		border.Show = function() end
	end

	if macro then 
		macro:Hide()
		macro:SetFont(button_font, 10, "OUTLINE")
	end

	if hotkey and hide_hotkey == 1 then
		hotkey:SetFont(button_font, 13, "OUTLINE")
		hotkey:Hide()
		hotkey.Show = function() end
	end

	if count then
		count:SetFont(button_font, 14, "OUTLINE")
	end

	local bd = CreateFrame("Frame", nil, button)
	bd:SetPoint("TOPLEFT", 0, 0)
	bd:SetPoint("BOTTOMRIGHT", 0, 0)
	bd:SetFrameStrata("BACKGROUND")
	bd:SetBackdrop(backdrop)
	bd:SetBackdropColor(0, 0, 0, 0.4)
	bd:SetBackdropBorderColor(0, 0, 0, 1)
	button.bd = bd

	button:HookScript("OnEnter", function(self)
		self.hover = true
		modSetBorderColor(self)
	end)
	button:HookScript("OnLeave", function(self)
		self.hover = false
		modSetBorderColor(self)
	end)
	
	icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	icon:SetPoint("TOPLEFT", button, "TOPLEFT", 1, -1)
	icon:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -1, 1)
end

local modActionButtonDown = function(id)
	local button
	if BonusActionBarFrame:IsShown() then
		button = _G["BonusActionButton"..id]
	else
		button = _G["ActionButton"..id]
	end
	button.pushed = true
	modSetBorderColor(button)
end
  
local modActionButtonUp = function(id)
	local button;
	if BonusActionBarFrame:IsShown() then
		button = _G["BonusActionButton"..id]
	else
		button = _G["ActionButton"..id]
	end
	button.pushed = false
	modSetBorderColor(button)
end

local modMultiActionButtonDown = function(bar, id)
	local button = _G[bar.."Button"..id]
	button.pushed = true
	modSetBorderColor(button)
end
  
local modMultiActionButtonUp = function(bar, id)
	local button = _G[bar.."Button"..id]
	button.pushed = false
	modSetBorderColor(button)
end

local modActionButton_UpdateState = function(button)
	local action = button.action
	if not button.bd then return end
	if IsCurrentAction(action) or IsAutoRepeatAction(action) then
		button.checked = true
	else
		button.checked = false
	end
	modSetBorderColor(button)
end
  
local modActionButton_Update = function(self)
	local action = self.action
	local name = self:GetName()

	setStyle(name)
	if IsEquippedAction(action) then
		self.equipped = true
	else
		self.equipped = false
	end
	modSetBorderColor(self)
end
  
local modPetActionBar_Update = function()
	for i=1, NUM_PET_ACTION_SLOTS do
		local name = "PetActionButton"..i
		local button  = _G[name]

		setStyle(name)
		local name, subtext, texture, isToken, isActive, autoCastAllowed, autoCastEnabled = GetPetActionInfo(i)
		if isActive then
			button.checked = true
		else
			button.checked = false
		end
		modSetBorderColor(button)
	end  
end
  
local modShapeshiftBar_UpdateState = function()    
	for i=1, NUM_SHAPESHIFT_SLOTS do
		local name = "ShapeshiftButton"..i
		local button  = _G[name]
  
		setStyle(name)
		local texture, name, isActive, isCastable = GetShapeshiftFormInfo(i)
		if isActive then
			button.checked = true
		else
			button.checked = false
		end
		modSetBorderColor(button)
	end    
end

local modActionButton_UpdateUsable = function(self)
	local name = self:GetName()
	local action = self.action
	local icon = _G[name.."Icon"]
	local isUsable, notEnoughMana = IsUsableAction(action)
	if ActionHasRange(action) and IsActionInRange(action) == 0 then
		icon:SetVertexColor(0.8, 0.1, 0.1, 1)
		return
	elseif notEnoughMana then
		icon:SetVertexColor(0.1, 0.3, 1, 1)
		return
	elseif isUsable then
		icon:SetVertexColor(1, 1, 1, 1)
		return
	else
		icon:SetVertexColor(0.4, 0.4, 0.4, 1)
		return
	end
end

local modActionButton_OnUpdate = function(self, elapsed)
	local t = self.mod_range
	if not t then
		self.mod_range = 0
		return
	end
	t = t + elapsed
	if t < update_timer then
		self.mod_range = t
		return
	else
		self.mod_range = 0
		modActionButton_UpdateUsable(self)
	end
end

hooksecurefunc("ActionButton_Update",   modActionButton_Update)
hooksecurefunc("ActionButton_UpdateUsable",   modActionButton_UpdateUsable)
hooksecurefunc("ActionButton_UpdateState",   modActionButton_UpdateState)
hooksecurefunc("ActionButtonDown", modActionButtonDown)
hooksecurefunc("ActionButtonUp", modActionButtonUp)
hooksecurefunc("MultiActionButtonDown", modMultiActionButtonDown)
hooksecurefunc("MultiActionButtonUp", modMultiActionButtonUp)
  
ActionButton_OnUpdate = modActionButton_OnUpdate
hooksecurefunc("ShapeshiftBar_OnLoad",   modShapeshiftBar_UpdateState)
hooksecurefunc("ShapeshiftBar_UpdateState",   modShapeshiftBar_UpdateState)
hooksecurefunc("PetActionBar_Update",   modPetActionBar_Update)
local _, ns = ...
local oUF = ns.oUF
local Private = oUF.Private

local unitSelectionType = Private.unitSelectionType

local function UpdateColor(self, event, unit)
	if(not unit or self.unit ~= unit) then return end
	local element = self.Health

	local color
	if(element.colorDisconnected and not UnitIsConnected(unit)) then
		color = self.colors.disconnected
	elseif(element.colorTapping and not UnitPlayerControlled(unit) and UnitIsTapDenied(unit)) then
		color = self.colors.tapped
	elseif(element.colorThreat and not UnitPlayerControlled(unit) and UnitThreatSituation('player', unit)) then
		color =  self.colors.threat[UnitThreatSituation('player', unit)]
	elseif(element.colorClass and (UnitIsPlayer(unit) or UnitInPartyIsAI(unit)))
		or (element.colorClassNPC and not (UnitIsPlayer(unit) or UnitInPartyIsAI(unit)))
		or (element.colorClassPet and UnitPlayerControlled(unit) and not UnitIsPlayer(unit)) then
		local _, class = UnitClass(unit)
		color = self.colors.class[class]
	elseif(element.colorSelection and unitSelectionType(unit, element.considerSelectionInCombatHostile)) then
		color = self.colors.selection[unitSelectionType(unit, element.considerSelectionInCombatHostile)]
	elseif(element.colorReaction and UnitReaction(unit, 'player')) then
		color = self.colors.reaction[UnitReaction(unit, 'player')]
	elseif(element.colorSmooth and self.colors.health:GetCurve()) then
		color = element.values:EvaluateCurrentHealthPercent(self.colors.health:GetCurve())
	elseif(element.colorHealth) then
		color = self.colors.health
	end

	if(color) then
		element:SetStatusBarColor(color:GetRGB())
	end

	--[[ Callback: Health:PostUpdateColor(unit, color)
	Called after the element color has been updated.

	* self  - the Health element
	* unit  - the unit for which the update has been triggered (string)
	* color - the used ColorMixin-based object (table?)
	--]]
	if(element.PostUpdateColor) then
		element:PostUpdateColor(unit, color)
	end
end

local function ColorPath(self, ...)
	--[[ Override: Health.UpdateColor(self, event, unit)
	Used to completely override the internal function for updating the widgets' colors.

	* self  - the parent object
	* event - the event triggering the update (string)
	* unit  - the unit accompanying the event (string)
	--]]
	(self.Health.UpdateColor or UpdateColor) (self, ...)
end

local function Update(self, event, unit)
	if(not unit or self.unit ~= unit) then return end
	local element = self.Health

	--[[ Callback: Health:PreUpdate(unit)
	Called before the element has been updated.

	* self - the Health element
	* unit - the unit for which the update has been triggered (string)
	--]]
	if(element.PreUpdate) then
		element:PreUpdate(unit)
	end

	UnitGetDetailedHealPrediction(unit, 'player', element.values)

	local max = element.values:GetMaximumHealth()
	element:SetMinMaxValues(0, max)

	local cur = element.values:GetCurrentHealth()
	if(UnitIsConnected(unit)) then
		element:SetValue(cur, element.smoothing)
	else
		element:SetValue(max, element.smoothing)
	end

	element.cur = cur -- DEPRECATED: use element.values
	element.max = max -- DEPRECATED: use element.values

	if(element.HealingAll or element.HealingPlayer or element.HealingOther or element.OverHealIndicator) then
		local allHeal, playerHeal, otherHeal, healClamped = element.values:GetIncomingHeals()
		if(element.HealingAll) then
			element.HealingAll:SetMinMaxValues(0, max)
			element.HealingAll:SetValue(allHeal)
		end
		if(element.HealingPlayer) then
			element.HealingPlayer:SetMinMaxValues(0, max)
			element.HealingPlayer:SetValue(playerHeal)
		end
		if(element.HealingOther) then
			element.HealingOther:SetMinMaxValues(0, max)
			element.HealingOther:SetValue(otherHeal)
		end
		if(element.OverHealIndicator) then
			element.OverHealIndicator:SetAlphaFromBoolean(healClamped, 1, 0)
		end
	end

	if(element.DamageAbsorb or element.OverDamageAbsorbIndicator) then
		local damageAbsorbAmount, damageAbsorbClamped = element.values:GetDamageAbsorbs()
		if(element.DamageAbsorb) then
			element.DamageAbsorb:SetMinMaxValues(0, max)
			element.DamageAbsorb:SetValue(damageAbsorbAmount)
		end
		if(element.OverDamageAbsorbIndicator) then
			element.OverDamageAbsorbIndicator:SetAlphaFromBoolean(damageAbsorbClamped, 1, 0)
		end
	end

	if(element.HealAbsorb or element.OverHealAbsorbIndicator) then
		local healAbsorbAmount, healAbsorbClamped = element.values:GetHealAbsorbs()
		if(element.HealAbsorb) then
			element.HealAbsorb:SetMinMaxValues(0, max)
			element.HealAbsorb:SetValue(healAbsorbAmount)
		end
		if(element.OverHealAbsorbIndicator) then
			element.OverHealAbsorbIndicator:SetAlphaFromBoolean(healAbsorbClamped, 1, 0)
		end
	end

	local lossPerc = 0
	if(element.TempLoss) then
		lossPerc = GetUnitTotalModifiedMaxHealthPercent(unit)
		element.TempLoss:SetValue(lossPerc, element.smoothing)
	end

	--[[ Callback: Health:PostUpdate(unit, cur, max, lossPerc)
	Called after the element has been updated.

	* self     - the Health element
	* unit     - the unit for which the update has been triggered (string)
	* cur      - the unit's current health value (number)
	* max      - the unit's maximum possible health value (number)
	* lossPerc - the percent by which the unit's max health has been temporarily reduced (number)
	--]]
	if(element.PostUpdate) then
		element:PostUpdate(unit, cur, max, lossPerc)
	end
end

local function UpdatePredictionSize(self, event, unit)
	local element = self.Health

	if(element.HealingAll) then
		element.HealingAll[element.__isHoriz and 'SetWidth' or 'SetHeight'](element.HealingAll, element.__size)
	end

	if(element.HealingPlayer) then
		element.HealingPlayer[element.__isHoriz and 'SetWidth' or 'SetHeight'](element.HealingPlayer, element.__size)
	end

	if(element.HealingOther) then
		element.HealingOther[element.__isHoriz and 'SetWidth' or 'SetHeight'](element.HealingOther, element.__size)
	end

	if(element.DamageAbsorb) then
		element.DamageAbsorb[element.__isHoriz and 'SetWidth' or 'SetHeight'](element.DamageAbsorb, element.__size)
	end

	if(element.HealAbsorb) then
		element.HealAbsorb[element.__isHoriz and 'SetWidth' or 'SetHeight'](element.HealAbsorb, element.__size)
	end
end

local function shouldUpdatePredictionSize(self)
	local element = self.Health

	local isHoriz = element:GetOrientation() == 'HORIZONTAL'
	local newSize = element[isHoriz and 'GetWidth' or 'GetHeight'](element)
	if(isHoriz ~= element.__isHoriz or newSize ~= element.__size) then
		element.__isHoriz = isHoriz
		element.__size = newSize

		return true
	end
end

local function Path(self, ...)
	--[[ Override: Health.UpdatePredictionSize(self, event, unit, ...)
	Used to completely override the internal function for updating the healing prediction sub-widgets' size.

	* self  - the parent object
	* event - the event triggering the update (string)
	* unit  - the unit accompanying the event (string)
	* ...   - the arguments accompanying the event
	--]]
	if(shouldUpdatePredictionSize(self)) then
		(self.Health.UpdatePredictionSize or UpdatePredictionSize) (self, ...)
	end

	--[[ Override: Health.Override(self, event, unit)
	Used to completely override the internal update function.

	* self  - the parent object
	* event - the event triggering the update (string)
	* unit  - the unit accompanying the event (string)
	--]]
	do
		(self.Health.Override or Update) (self, ...)
	end

	ColorPath(self, ...)
end

local function ForceUpdate(element)
	element.__isHoriz = nil
	element.__size = nil

	Path(element.__owner, 'ForceUpdate', element.__owner.unit)
end

--[[ Health:SetColorDisconnected(state, isForced)
Used to toggle coloring if the unit is offline.

* self     - the Health element
* state    - the desired state (boolean)
* isForced - forces the event update even if the state wasn't changed (boolean)
--]]
local function SetColorDisconnected(element, state, isForced) -- DEPRECATED
	if(element.colorDisconnected ~= state or isForced) then
		element.colorDisconnected = state
	end
end

--[[ Health:SetColorSelection(state, isForced)
Used to toggle coloring by the unit's selection.

* self     - the Health element
* state    - the desired state (boolean)
* isForced - forces the event update even if the state wasn't changed (boolean)
--]]
local function SetColorSelection(element, state, isForced)
	if(element.colorSelection ~= state or isForced) then
		element.colorSelection = state
		if(state) then
			element.__owner:RegisterEvent('UNIT_FLAGS', ColorPath)
		else
			element.__owner:UnregisterEvent('UNIT_FLAGS', ColorPath)
		end
	end
end

--[[ Health:SetColorTapping(state, isForced)
Used to toggle coloring if the unit isn't tapped by the player.

* self     - the Health element
* state    - the desired state (boolean)
* isForced - forces the event update even if the state wasn't changed (boolean)
--]]
local function SetColorTapping(element, state, isForced)
	if(element.colorTapping ~= state or isForced) then
		element.colorTapping = state
		if(state) then
			element.__owner:RegisterEvent('UNIT_FACTION', ColorPath)
		elseif(not element.colorReaction) then
			element.__owner:UnregisterEvent('UNIT_FACTION', ColorPath)
		end
	end
end

--[[ Health:SetColorReaction(state, isForced)
Used to toggle coloring by the unit's reaction.

* self     - the Health element
* state    - the desired state (boolean)
* isForced - forces the event update even if the state wasn't changed (boolean)
--]]
local function SetColorReaction(element, state, isForced)
	if(element.colorReaction ~= state or isForced) then
		element.colorReaction = state
		if(state) then
			element.__owner:RegisterEvent('UNIT_FACTION', ColorPath)
		elseif(not element.colorTapping) then
			element.__owner:UnregisterEvent('UNIT_FACTION', ColorPath)
		end
	end
end

--[[ Health:SetColorThreat(state, isForced)
Used to toggle coloring by the unit's threat status.

* self     - the Health element
* state    - the desired state (boolean)
* isForced - forces the event update even if the state wasn't changed (boolean)
--]]
local function SetColorThreat(element, state, isForced)
	if(element.colorThreat ~= state or isForced) then
		element.colorThreat = state
		if(state) then
			element.__owner:RegisterEvent('UNIT_THREAT_LIST_UPDATE', ColorPath)
		else
			element.__owner:UnregisterEvent('UNIT_THREAT_LIST_UPDATE', ColorPath)
		end
	end
end

local function Enable(self, unit)
	local element = self.Health
	if(element) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate
		element.SetColorDisconnected = SetColorDisconnected
		element.SetColorSelection = SetColorSelection
		element.SetColorTapping = SetColorTapping
		element.SetColorReaction = SetColorReaction
		element.SetColorThreat = SetColorThreat

		if(element.values) then
			element.values:ResetPredictedValues()
		else
			element.values = CreateUnitHealPredictionCalculator()
		end

		if(not element.smoothing) then
			element.smoothing = Enum.StatusBarInterpolation.Immediate
		end

		if(element.maximumHealthClampMode) then
			element.values:SetMaximumHealthMode(element.maximumHealthClampMode)
		end

		if(element.damageAbsorbClampMode) then
			element.values:SetDamageAbsorbClampMode(element.damageAbsorbClampMode)
		end

		if(element.healAbsorbClampMode) then
			element.values:SetHealAbsorbClampMode(element.healAbsorbClampMode)
		end

		if(element.healAbsorbMode) then
			element.values:SetHealAbsorbMode(element.healAbsorbMode)
		end

		if(element.incomingHealClampMode) then
			element.values:SetIncomingHealClampMode(element.incomingHealClampMode)
		end

		if(element.incomingHealOverflow) then
			element.values:SetIncomingHealOverflowPercent(element.incomingHealOverflow)
		end

		self:RegisterEvent('UNIT_HEALTH', Path)
		self:RegisterEvent('UNIT_MAXHEALTH', Path)
		self:RegisterEvent('UNIT_CONNECTION', Path)

		if(unit == 'party' or unit == 'raid') then
			self:RegisterEvent('PARTY_MEMBER_ENABLE', Path)
			self:RegisterEvent('PARTY_MEMBER_DISABLE', Path)
		end

		if(element.colorSelection) then
			self:RegisterEvent('UNIT_FLAGS', ColorPath)
		end

		if(element.colorTapping or element.colorReaction) then
			self:RegisterEvent('UNIT_FACTION', ColorPath)
		end

		if(element.colorThreat) then
			self:RegisterEvent('UNIT_THREAT_LIST_UPDATE', ColorPath)
		end

		if(element.HealingAll or element.HealingPlayer or element.HealingOther or element.OverHealIndicator) then
			self:RegisterEvent('UNIT_HEAL_PREDICTION', Path)
		end

		if(element.DamageAbsorb or element.OverDamageAbsorbIndicator) then
			self:RegisterEvent('UNIT_ABSORB_AMOUNT_CHANGED', Path)
		end

		if(element.HealAbsorb or element.OverHealAbsorbIndicator) then
			self:RegisterEvent('UNIT_HEAL_ABSORB_AMOUNT_CHANGED', Path)
		end

		if(element.TempLoss) then
			self:RegisterEvent('UNIT_MAX_HEALTH_MODIFIERS_CHANGED', Path)
		end

		if(element:IsObjectType('StatusBar') and not element:GetStatusBarTexture()) then
			element:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]])
		end

		if(element.HealingAll) then
			if(element.HealingAll:IsObjectType('StatusBar') and not element.HealingAll:GetStatusBarTexture()) then
				element.HealingAll:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]])
			end
		end

		if(element.HealingPlayer) then
			if(element.HealingPlayer:IsObjectType('StatusBar') and not element.HealingPlayer:GetStatusBarTexture()) then
				element.HealingPlayer:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]])
			end
		end

		if(element.HealingOther) then
			if(element.HealingOther:IsObjectType('StatusBar') and not element.HealingOther:GetStatusBarTexture()) then
				element.HealingOther:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]])
			end
		end

		if(element.OverHealIndicator) then
			if(element.OverHealIndicator:IsObjectType('Texture') and not element.OverHealIndicator:GetTexture()) then
				element.OverHealIndicator:SetTexture([[Interface\RaidFrame\Shield-Overshield]])
				element.OverHealIndicator:SetBlendMode('ADD')
			end
		end

		if(element.DamageAbsorb) then
			if(element.DamageAbsorb:IsObjectType('StatusBar') and not element.DamageAbsorb:GetStatusBarTexture()) then
				element.DamageAbsorb:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]])
			end
		end

		if(element.HealAbsorb) then
			if(element.HealAbsorb:IsObjectType('StatusBar') and not element.HealAbsorb:GetStatusBarTexture()) then
				element.HealAbsorb:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]])
			end
		end

		if(element.OverDamageAbsorbIndicator) then
			if(element.OverDamageAbsorbIndicator:IsObjectType('Texture') and not element.OverDamageAbsorbIndicator:GetTexture()) then
				element.OverDamageAbsorbIndicator:SetTexture([[Interface\RaidFrame\Shield-Overshield]])
				element.OverDamageAbsorbIndicator:SetBlendMode('ADD')
			end
		end

		if(element.OverHealAbsorbIndicator) then
			if(element.OverHealAbsorbIndicator:IsObjectType('Texture') and not element.OverHealAbsorbIndicator:GetTexture()) then
				element.OverHealAbsorbIndicator:SetTexture([[Interface\RaidFrame\Absorb-Overabsorb]])
				element.OverHealAbsorbIndicator:SetBlendMode('ADD')
			end
		end

		element:Show()

		if(element.TempLoss) then
			if(element.TempLoss:IsObjectType('StatusBar')) then
				element.TempLoss:SetMinMaxValues(0, 1)
				element.TempLoss:SetValue(0, element.smoothing)

				if(not element.TempLoss:GetStatusBarTexture()) then
					element.TempLoss:SetStatusBarTexture('UI-HUD-UnitFrame-Target-PortraitOn-Bar-TempHPLoss')
				end
			end

			element.TempLoss:Show()
		end

		return true
	end
end

local function Disable(self)
	local element = self.Health
	if(element) then
		element:Hide()

		if(element.HealingAll) then
			element.HealingAll:Hide()
		end

		if(element.HealingPlayer) then
			element.HealingPlayer:Hide()
		end

		if(element.HealingOther) then
			element.HealingOther:Hide()
		end

		if(element.OverHealIndicator) then
			element.OverHealIndicator:Hide()
		end

		if(element.DamageAbsorb) then
			element.DamageAbsorb:Hide()
		end

		if(element.HealAbsorb) then
			element.HealAbsorb:Hide()
		end

		if(element.OverDamageAbsorbIndicator) then
			element.OverDamageAbsorbIndicator:Hide()
		end

		if(element.OverHealAbsorbIndicator) then
			element.OverHealAbsorbIndicator:Hide()
		end

		self:UnregisterEvent('UNIT_HEALTH', Path)
		self:UnregisterEvent('UNIT_MAXHEALTH', Path)
		self:UnregisterEvent('UNIT_HEAL_PREDICTION', Path)
		self:UnregisterEvent('UNIT_ABSORB_AMOUNT_CHANGED', Path)
		self:UnregisterEvent('UNIT_HEAL_ABSORB_AMOUNT_CHANGED', Path)
		self:UnregisterEvent('UNIT_MAX_HEALTH_MODIFIERS_CHANGED', Path)
		self:UnregisterEvent('UNIT_CONNECTION', Path)
		self:UnregisterEvent('PARTY_MEMBER_ENABLE', Path)
		self:UnregisterEvent('PARTY_MEMBER_DISABLE', Path)
		self:UnregisterEvent('UNIT_FACTION', ColorPath)
		self:UnregisterEvent('UNIT_FLAGS', ColorPath)
		self:UnregisterEvent('UNIT_THREAT_LIST_UPDATE', ColorPath)

		if(element.TempLoss) then
			element.TempLoss:Hide()
		end
	end
end

oUF:AddElement('Health', Path, Enable, Disable)
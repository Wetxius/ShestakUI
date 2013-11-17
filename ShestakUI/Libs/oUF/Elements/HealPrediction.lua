local _, ns = ...
local oUF = ns.oUF

local function UpdateFillBar(frame, previousTexture, bar, amount)
	if amount == 0 then
		bar:Hide()
		return previousTexture
	end

	local totalWidth, totalHeight = frame.Health:GetSize()
	local _, totalMax = frame.Health:GetMinMaxValues()
	local orientation = frame.Health:GetOrientation()

	if orientation == "HORIZONTAL" then
		local barSize = (amount / totalMax) * totalWidth
		bar:SetWidth(barSize)
		bar:SetPoint("TOPLEFT", previousTexture, "TOPRIGHT")
		bar:SetPoint("BOTTOMLEFT", previousTexture, "BOTTOMRIGHT")
	else
		local barSize = (amount / totalMax) * totalHeight
		bar:SetHeight(barSize)
		bar:SetPoint("BOTTOMRIGHT", previousTexture, "TOPRIGHT")
		bar:SetPoint("BOTTOMLEFT", previousTexture, "TOPLEFT")
	end

	bar:Show()

	return bar
end

local function Update(self, event, unit)
	if(self.unit ~= unit) then return end

	local hp = self.HealPrediction
	if(hp.PreUpdate) then hp:PreUpdate(unit) end

	local myIncomingHeal = UnitGetIncomingHeals(unit, 'player') or 0
	local allIncomingHeal = UnitGetIncomingHeals(unit) or 0

	local health, maxHealth = UnitHealth(unit), UnitHealthMax(unit)

	if(health + allIncomingHeal > maxHealth) then
		allIncomingHeal = maxHealth - health
	end

	if(allIncomingHeal < myIncomingHeal) then
		myIncomingHeal = allIncomingHeal
		allIncomingHeal = 0
	else
		allIncomingHeal = allIncomingHeal - myIncomingHeal
	end

	local previousTexture = self.Health:GetStatusBarTexture()

	previousTexture = UpdateFillBar(self, previousTexture, hp.myBar, myIncomingHeal)
	previousTexture = UpdateFillBar(self, previousTexture, hp.otherBar, allIncomingHeal)

	if(hp.PostUpdate) then
		return hp:PostUpdate(unit)
	end
end

local function Path(self, ...)
	return (self.HealPrediction.Override or Update) (self, ...)
end

local ForceUpdate = function(element)
	return Path(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local function Enable(self)
	local hp = self.HealPrediction
	if(hp) then
		hp.__owner = self
		hp.ForceUpdate = ForceUpdate

		self:RegisterEvent('UNIT_HEAL_PREDICTION', Path)
		self:RegisterEvent('UNIT_MAXHEALTH', Path)
		self:RegisterEvent('UNIT_HEALTH_FREQUENT', Path)

		return true
	end
end

local function Disable(self)
	local hp = self.HealPrediction
	if(hp) then
		self:UnregisterEvent('UNIT_HEAL_PREDICTION', Path)
		self:UnregisterEvent('UNIT_MAXHEALTH', Path)
		self:UnregisterEvent('UNIT_HEALTH_FREQUENT', Path)
	end
end

oUF:AddElement('HealPrediction', Path, Enable, Disable)
local _, ns = ...
local oUF = ns.oUF
local Private = oUF.Private

local unitExists = Private.unitExists

local function Update(self, event, unit)
	if(unit ~= self.unit) then return end

	local element = self.ThreatIndicator
	--[[ Callback: ThreatIndicator:PreUpdate(unit)
	Called before the element has been updated.

	* self - the ThreatIndicator element
	* unit - the unit for which the update has been triggered (string)
	--]]
	if(element.PreUpdate) then element:PreUpdate(unit) end

	local feedbackUnit = element.feedbackUnit
	unit = unit or self.unit

	local status
	-- BUG: Non-existent '*target' or '*pet' units cause UnitThreatSituation() errors
	if(unitExists(unit)) then
		if(feedbackUnit and feedbackUnit ~= unit and unitExists(feedbackUnit)) then
			status = UnitThreatSituation(feedbackUnit, unit)
		else
			status = UnitThreatSituation(unit)
		end
	end

	local color
	if(status and status > 0) then
		color = self.colors.threat[status]

		if(element.SetVertexColor and color) then
			element:SetVertexColor(color:GetRGB())
		end

		element:Show()
	else
		element:Hide()
	end

	--[[ Callback: ThreatIndicator:PostUpdate(unit, status, color)
	Called after the element has been updated.

	* self   - the ThreatIndicator element
	* unit   - the unit for which the update has been triggered (string)
	* status - the unit's threat status (see [UnitThreatSituation](https://warcraft.wiki.gg/wiki/API_UnitThreatSituation))
	* color  - the used ColorMixin-based object (table?)
	--]]
	if(element.PostUpdate) then
		return element:PostUpdate(unit, status, color)
	end
end

local function Path(self, ...)
	--[[ Override: ThreatIndicator.Override(self, event, ...)
	Used to completely override the internal update function.

	* self  - the parent object
	* event - the event triggering the update (string)
	* ...   - the arguments accompanying the event
	--]]
	return (self.ThreatIndicator.Override or Update) (self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local function Enable(self)
	local element = self.ThreatIndicator
	if(element) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		self:RegisterEvent('UNIT_THREAT_SITUATION_UPDATE', Path)
		self:RegisterEvent('UNIT_THREAT_LIST_UPDATE', Path)

		if(element:IsObjectType('Texture') and not element:GetTexture()) then
			element:SetTexture([[Interface\RAIDFRAME\UI-RaidFrame-Threat]])
		end

		return true
	end
end

local function Disable(self)
	local element = self.ThreatIndicator
	if(element) then
		element:Hide()

		self:UnregisterEvent('UNIT_THREAT_SITUATION_UPDATE', Path)
		self:UnregisterEvent('UNIT_THREAT_LIST_UPDATE', Path)
	end
end

oUF:AddElement('ThreatIndicator', Path, Enable, Disable)
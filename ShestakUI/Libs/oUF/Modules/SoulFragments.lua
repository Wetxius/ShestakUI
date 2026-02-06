local T, C, L = unpack(ShestakUI)
if C.unitframe.enable ~= true or T.class ~= "DEMONHUNTER" then return end

local _, ns = ...
local oUF = ns.oUF

local SPELL_VOID_METAMORPHOSIS = Constants.UnitPowerSpellIDs.VOID_METAMORPHOSIS_SPELL_ID or 1217607
local SPELL_SILENCE_THE_WHISPERS = Constants.UnitPowerSpellIDs.SILENCE_THE_WHISPERS_SPELL_ID or 1227702
local SPELL_DARK_HEART = Constants.UnitPowerSpellIDs.DARK_HEART_SPELL_ID or 1225789

local function GetSoulFragments()
	if(C_UnitAuras.GetPlayerAuraBySpellID(SPELL_VOID_METAMORPHOSIS)) then
		local auraInfo = C_UnitAuras.GetPlayerAuraBySpellID(SPELL_SILENCE_THE_WHISPERS)
		if(auraInfo) then
			return auraInfo.applications / GetCollapsingStarCost()
		end
	else
		local auraInfo = C_UnitAuras.GetPlayerAuraBySpellID(SPELL_DARK_HEART)
		if(auraInfo) then
			return auraInfo.applications / C_Spell.GetSpellMaxCumulativeAuraApplications(SPELL_DARK_HEART)
		end
	end

	return 0
end

local function Update(self, _, unit)
	if(unit and unit ~= self.unit) then return end

	local element = self.SoulFragments

	if(element.PreUpdate) then
		element:PreUpdate(unit)
	end

	local cur = GetSoulFragments()
	local max = 1

	element:SetMinMaxValues(0, max)
	element:SetValue(cur, element.smoothing)

	element.cur = cur
	element.max = max

	if cur and element.Text then
		element.Text:SetFormattedText("|cffffffff%d%%|r", cur * 100)
	end

	if(element.PostUpdate) then
		return element:PostUpdate(cur)
	end
end

local function Path(self, ...)
	return (self.SoulFragments.Override or Update) (self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, "ForceUpdate", element.__owner.unit)
end

local function Visibility(self)
	local element = self.SoulFragments
	local spec = C_SpecializationInfo.GetSpecialization()

	if spec == SPEC_DEMONHUNTER_DEVOURER then
		element:Show()
		if self.Debuffs then self.Debuffs:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 2, 19) end
		self:RegisterEvent('UNIT_AURA', Path)
	else
		element:Hide()
		if self.Debuffs then self.Debuffs:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 2, 5) end
		self:UnregisterEvent('UNIT_AURA', Path)
	end
end

local function Enable(self, unit)
	local element = self.SoulFragments
	if element and unit == "player" then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		self:RegisterEvent("UNIT_POWER_UPDATE", Path)
		self:RegisterEvent("UNIT_MAXPOWER", Path)
		self:RegisterEvent("UNIT_POWER_POINT_CHARGE", Path)

		element.handler = CreateFrame("Frame", nil, element)
		element.handler:RegisterEvent("PLAYER_TALENT_UPDATE")
		element.handler:RegisterEvent("PLAYER_ENTERING_WORLD")
		element.handler:SetScript("OnEvent", function() Visibility(self) end)

		return true
	end
end

local function Disable(self)
	local element = self.SoulFragments
	if(element) then
		self:UnregisterEvent("UNIT_POWER_UPDATE", Path)
		self:UnregisterEvent("UNIT_MAXPOWER", Path)
		self:UnregisterEvent("UNIT_POWER_POINT_CHARGE", Path)
		self:UnregisterEvent('UNIT_AURA', Path)
		element.handler:UnregisterEvent("PLAYER_TALENT_UPDATE")
		element.handler:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end
end

oUF:AddElement("SoulFragments", Path, Enable, Disable)
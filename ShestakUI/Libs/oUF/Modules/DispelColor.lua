local T, C, L = unpack(ShestakUI)
if C.unitframe.enable ~= true then return end

T.CanDispel = {
	DRUID = {Magic = false, Curse = true, Poison = true},
	EVOKER = {Magic = false, Curse = true, Poison = true, Disease = true},
	MAGE = {Curse = true},
	MONK = {Magic = false, Poison = true, Disease = true},
	PALADIN = {Magic = false, Poison = true, Disease = true},
	PRIEST = {Magic = false, Disease = true},
	SHAMAN = {Magic = false, Curse = true}
}

if C.raidframe.plugins_debuffhighlight ~= true then return end
----------------------------------------------------------------------------------------
--	Show color texture for dispellable debuffs
----------------------------------------------------------------------------------------
local _, ns = ...
local oUF = ns.oUF

local color_magic = CreateColor(0, 0, 0, 0)
local color_curse = CreateColor(0, 0, 0, 0)
local color_disease = CreateColor(0, 0, 0, 0)
local color_poison = CreateColor(0, 0, 0, 0)

if T.class == "DRUID" then
	color_curse = CreateColor(0.6, 0, 1)
	color_poison = CreateColor(0, 0.6, 0)
elseif T.class == "EVOKER" then
	color_curse = CreateColor(0.6, 0, 1)
	color_poison = CreateColor(0, 0.6, 0)
	color_disease = CreateColor(0.6, 0.4, 0)
elseif T.class == "MAGE" then
	color_curse = CreateColor(0.6, 0, 1)
elseif T.class == "MONK" then
	color_poison = CreateColor(0, 0.6, 0)
	color_disease = CreateColor(0.6, 0.4, 0)
elseif T.class == "PALADIN" then
	color_poison = CreateColor(0, 0.6, 0)
	color_disease = CreateColor(0.6, 0.4, 0)
elseif T.class == "PRIEST" then
	color_disease = CreateColor(0.6, 0.4, 0)
elseif T.class == "SHAMAN" then
	color_curse = CreateColor(0.6, 0, 1)
end

local dispelColorCurve = C_CurveUtil.CreateColorCurve()
dispelColorCurve:SetType(Enum.LuaCurveType.Step)

local function CheckSpec()
	local spec = C_SpecializationInfo.GetSpecialization()

	if T.class == "DRUID" then
		if spec == 4 then
			color_magic = CreateColor(0.2, 0.6, 1)
		else
			color_magic = CreateColor(0, 0, 0, 0)
		end
	elseif T.class == "MONK" then
		if spec == 2 then
			color_magic = CreateColor(0.2, 0.6, 1)
		else
			color_magic = CreateColor(0, 0, 0, 0)
		end
	elseif T.class == "PALADIN" then
		if spec == 1 then
			color_magic = CreateColor(0.2, 0.6, 1)
		else
			color_magic = CreateColor(0, 0, 0, 0)
		end
	elseif T.class == "PRIEST" then
		if spec == 3 then
			color_magic = CreateColor(0, 0, 0, 0)
		else
			color_magic = CreateColor(0.2, 0.6, 1)
		end
	elseif T.class == "SHAMAN" then
		if spec == 3 then
			color_magic = CreateColor(0.2, 0.6, 1)
		else
			color_magic = CreateColor(0, 0, 0, 0)
		end
	end

	dispelColorCurve:SetToDefaults()
	dispelColorCurve:ClearPoints()

	local dispelIndex = {
		-- [0] = color_magic,	-- for test
		[1] = color_magic,
		[2] = color_curse,
		[3] = color_disease,
		[4] = color_poison,
		[9] = CreateColor(0, 0, 0, 0),
	}

	for i, color in pairs(dispelIndex) do
		dispelColorCurve:AddPoint(i, color)
	end
end

local function Update(self, event, unit)
	if(self.unit ~= unit) then return end
	local element = self.DispelColor

	if not UnitCanAssist("player", unit) then
		element:Hide()
		return
	end

	-- local aura = C_UnitAuras.GetAuraDataByIndex(unit, 1, "HARMFUL|RAID_PLAYER_DISPELLABLE")	-- BETA should be enable in 12.0.1
	-- local aura = C_UnitAuras.GetAuraDataByIndex(unit, 1, "HARMFUL|RAID")
	local aura = C_UnitAuras.GetAuraDataByIndex(unit, 1, "HARMFUL")
	local auraInstanceID = aura and aura.auraInstanceID or nil

	if auraInstanceID then
		local color = C_UnitAuras.GetAuraDispelTypeColor(unit, auraInstanceID, dispelColorCurve)

		if color then
			element:SetVertexColor(color:GetRGBA())
			element:Show()
		else
			element:Hide()
		end
	else
		element:Hide()
	end
end

local function Path(self, ...)
	return (self.DispelColor.Override or Update) (self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, "ForceUpdate", element.__owner.unit)
end

local function Enable(self)
	local element = self.DispelColor
	if(element) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		self:RegisterEvent("UNIT_AURA", Path)
		self:RegisterEvent("PLAYER_TALENT_UPDATE", CheckSpec, true)

		self:Hide()

		CheckSpec()

		return true
	end
end

local function Disable(self)
	if self.DispelColor then
		self:UnregisterEvent("UNIT_AURA", Path)
		self:UnregisterEvent("PLAYER_TALENT_UPDATE", CheckSpec)
	end
end

oUF:AddElement("DispelColor", Update, Enable, Disable)
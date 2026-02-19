local T, C, L = unpack(ShestakUI)

----------------------------------------------------------------------------------------
--	Number value function
----------------------------------------------------------------------------------------
T.Round = function(number, decimals)
	if not canaccessvalue(number) then return number end
	if not decimals then decimals = 0 end
	if decimals and decimals > 0 then
		local mult = 10 ^ decimals
		return floor(number * mult + 0.5) / mult
	end
	return floor(number + 0.5)
end

do
	local abbreviateConfig = {
		breakpointData = {
			{breakpoint = 1e11, abbreviation = "b", significandDivisor = 1e9, fractionDivisor = 1, abbreviationIsGlobal = false,},	-- 123b
			{breakpoint = 1e10, abbreviation = "b", significandDivisor = 1e8, fractionDivisor = 10, abbreviationIsGlobal = false,},	-- 12.3b
			{breakpoint = 1e9, abbreviation = "b", significandDivisor = 1e7, fractionDivisor = 100, abbreviationIsGlobal = false,},	-- 1.23b
			{breakpoint = 1e8, abbreviation = "m", significandDivisor = 1e6, fractionDivisor = 1, abbreviationIsGlobal = false,},	-- 123m
			{breakpoint = 1e7, abbreviation = "m", significandDivisor = 1e5, fractionDivisor = 10, abbreviationIsGlobal = false,},	-- 12.3m
			{breakpoint = 1e6, abbreviation = "m", significandDivisor = 1e4, fractionDivisor = 100, abbreviationIsGlobal = false,},	-- 1.23m
			{breakpoint = 1e5, abbreviation = "k", significandDivisor = 1e3, fractionDivisor = 1, abbreviationIsGlobal = false,},	-- 123k
			{breakpoint = 1e4, abbreviation = "k", significandDivisor = 100, fractionDivisor = 10, abbreviationIsGlobal = false,},	-- 12.3k
			{breakpoint = 1e3, abbreviation = "k", significandDivisor = 100, fractionDivisor = 10, abbreviationIsGlobal = false,},	-- 1.2k
		},
	}

	T.ShortValue = function(value)
		return AbbreviateNumbers(value, abbreviateConfig)
	end
end

T.RGBToHex = function(r, g, b)
	r = tonumber(r) <= 1 and tonumber(r) >= 0 and tonumber(r) or 0
	g = tonumber(g) <= tonumber(g) and tonumber(g) >= 0 and tonumber(g) or 0
	b = tonumber(b) <= 1 and tonumber(b) >= 0 and tonumber(b) or 0
	return string.format("|cff%02x%02x%02x", r * 255, g * 255, b * 255)
end

----------------------------------------------------------------------------------------
--	Secret value check
----------------------------------------------------------------------------------------
T.IsSecretValue = function(value)
	return issecretvalue(value)
end

T.NotSecretValue = function(value)
	return not issecretvalue(value)
end

T.CheckUnitStatus = function(func, unit)
	local status = func(unit)
	return T.NotSecretValue(status) and status
end

----------------------------------------------------------------------------------------
--	Chat channel check
----------------------------------------------------------------------------------------
T.CheckChat = function(warning)
	if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
		return "INSTANCE_CHAT"
	elseif IsInRaid(LE_PARTY_CATEGORY_HOME) then
		if warning and (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") or IsEveryoneAssistant()) then
			return "RAID_WARNING"
		else
			return "RAID"
		end
	elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
		return "PARTY"
	end
	return "SAY"
end

T.SendChatMessage = function(...)
	if C_ChatInfo.InChatMessagingLockdown() then return end
	return C_ChatInfo.SendChatMessage(...)
end

----------------------------------------------------------------------------------------
--	Player's role check
----------------------------------------------------------------------------------------
local isCaster = {
	DEATHKNIGHT = {nil, nil, nil},
	DEMONHUNTER = {nil, nil, nil},
	DRUID = {true},					-- Balance
	HUNTER = {nil, nil, nil},
	MAGE = {true, true, true},
	MONK = {nil, nil, nil},
	PALADIN = {nil, nil, nil},
	PRIEST = {nil, nil, true},		-- Shadow
	ROGUE = {nil, nil, nil},
	SHAMAN = {true},				-- Elemental
	WARLOCK = {true, true, true},
	WARRIOR = {nil, nil, nil},
	EVOKER = {true}
}

local function CheckRole()
	local spec = C_SpecializationInfo.GetSpecialization()
	local role = spec and GetSpecializationRole(spec)

	T.Spec = spec
	if role == "TANK" then
		T.Role = "Tank"
	elseif role == "HEALER" then
		T.Role = "Healer"
	elseif role == "DAMAGER" then
		if isCaster[T.class][spec] then
			T.Role = "Caster"
		else
			T.Role = "Melee"
		end
	end
end
local RoleUpdater = CreateFrame("Frame")
RoleUpdater:RegisterEvent("PLAYER_ENTERING_WORLD")
RoleUpdater:RegisterEvent("PLAYER_TALENT_UPDATE")
RoleUpdater:SetScript("OnEvent", CheckRole)

T.IsHealerSpec = function()
	local healer = false
	local spec = C_SpecializationInfo.GetSpecialization()

	if (T.class == "EVOKER" and spec == 2) or (T.class == "DRUID" and spec == 4) or (T.class == "MONK" and spec == 2) or
	(T.class == "PALADIN" and spec == 1) or (T.class == "PRIEST" and spec ~= 3) or (T.class == "SHAMAN" and spec == 3) then
		healer = true
	end

	return healer
end

----------------------------------------------------------------------------------------
--	Player's buff check
----------------------------------------------------------------------------------------
T.HasPlayerBuff = function(spell)
	for i = 1, 40 do
		local name
		local auraData = C_UnitAuras.GetAuraDataByIndex("player", i, "HELPFUL")
		if auraData then
			if canaccessvalue(auraData.name) then
				name = auraData.name
			end
		end
		if not name then break end
		if name == spell then
			return true
		end
	end
	return nil
end

----------------------------------------------------------------------------------------
--	Player's level check
----------------------------------------------------------------------------------------
local function CheckLevel(_, _, level)
	T.level = level
end
local LevelUpdater = CreateFrame("Frame")
LevelUpdater:RegisterEvent("PLAYER_LEVEL_UP")
LevelUpdater:SetScript("OnEvent", CheckLevel)

----------------------------------------------------------------------------------------
--	Pet Battle Hider
----------------------------------------------------------------------------------------
T_PetBattleFrameHider = CreateFrame("Frame", "ShestakUI_PetBattleFrameHider", UIParent, "SecureHandlerStateTemplate")
T_PetBattleFrameHider:SetAllPoints()
T_PetBattleFrameHider:SetFrameStrata("LOW")
RegisterStateDriver(T_PetBattleFrameHider, "visibility", "[petbattle] hide; show")

----------------------------------------------------------------------------------------
--	UTF functions
----------------------------------------------------------------------------------------
T.UTF = function(string, i, dots)
	if not string then return end
	if not canaccessvalue(string) then return string end
	local bytes = string:len()
	if bytes <= i then
		return string
	else
		local len, pos = 0, 1
		while (pos <= bytes) do
			len = len + 1
			local c = string:byte(pos)
			if c > 0 and c <= 127 then
				pos = pos + 1
			elseif c >= 192 and c <= 223 then
				pos = pos + 2
			elseif c >= 224 and c <= 239 then
				pos = pos + 3
			elseif c >= 240 and c <= 247 then
				pos = pos + 4
			end
			if len == i then break end
		end
		if len == i and pos <= bytes then
			return string:sub(1, pos - 1)..(dots and "..." or "")
		else
			return string
		end
	end
end

----------------------------------------------------------------------------------------
--	Move functions
----------------------------------------------------------------------------------------
T.CalculateMoverPoints = function(mover)
	local centerX, centerY = UIParent:GetCenter()
	local width = UIParent:GetRight()
	local x, y = mover:GetCenter()

	local point = "BOTTOM"
	if y >= centerY then
		point = "TOP"
		y = -(UIParent:GetTop() - mover:GetTop())
	else
		y = mover:GetBottom()
	end

	if x >= (width * 2 / 3) then
		point = point.."RIGHT"
		x = mover:GetRight() - width
	elseif x <= (width / 3) then
		point = point.."LEFT"
		x = mover:GetLeft()
	else
		x = x - centerX
	end

	return x, y, point
end

T.IsFramePositionedLeft = function(frame)
	local x = frame:GetCenter()
	local screenWidth = GetScreenWidth()
	local positionedLeft = false

	if x and x < (screenWidth / 2) then
		positionedLeft = true
	end

	return positionedLeft
end

T.CurrentProfile = function(reset)
	if not ShestakUIOptionsGlobal then return {} end	-- prevent error when disable ShestakUI_Config
	if ShestakUIOptionsGlobal[T.realm][T.name] then
		if ShestakUIPositionsPerChar == nil then
			ShestakUIPositionsPerChar = ShestakUIPositions
		end
		if not ShestakUIPositionsPerChar then return {} end
		local i = tostring(ShestakUIOptionsGlobal[T.realm]["Current_Profile"][T.name])
		ShestakUIPositionsPerChar[i] = ShestakUIPositionsPerChar[i] or {}
		if reset then
			ShestakUIPositionsPerChar[i] = {}
		else
			return ShestakUIPositionsPerChar[i]
		end
	else
		if not ShestakUIPositions then return {} end
		local i = tostring(ShestakUIOptionsGlobal["Current_Profile"])
		ShestakUIPositions[i] = ShestakUIPositions[i] or {}
		if reset then
			ShestakUIPositions[i] = {}
		else
			return ShestakUIPositions[i]
		end
	end
end
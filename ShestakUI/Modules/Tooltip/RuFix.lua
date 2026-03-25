local T, C, L = unpack(ShestakUI)
if C.tooltip.enable ~= true then return end

----------------------------------------------------------------------------------------
--	Clean ruRU tooltip(snt_rufix by Don Kaban, edited by ALZA)
----------------------------------------------------------------------------------------
ITEM_CREATED_BY = ""	-- No creator name
ITEM_SOCKETABLE = ""	-- No gem info line
EMPTY_SOCKET_RED = "|cffFF4040"..EMPTY_SOCKET_RED.."|r"
EMPTY_SOCKET_YELLOW = "|cffffff40"..EMPTY_SOCKET_YELLOW.."|r"
EMPTY_SOCKET_BLUE = "|cff6060ff"..EMPTY_SOCKET_BLUE.."|r"

if T.client ~= "ruRU" then return end

GUILD_ACHIEVEMENT = "Уведомл. для гильдии"
ADDON_LIST_PERFORMANCE_PEAK_CPU = "Макс. нагрузка ЦП: %s"
-- COOLDOWN_DURATION_HOURS = "%dh" -- causes taint
-- COOLDOWN_DURATION_MIN = "%dm"	-- causes taint

local replace = {
	["красного цвета"] = "|cffFF4040красного цвета|r",
	["синего цвета"] = "|cff6060ffсинего цвета|r",
	["желтого цвета"] = "|cffffff40желтого цвета|r",
	["Требуется хотя бы"] = "Требуется",
}

local replaceclass = {
	["Воин"] = "|cffC79C6EВоин|r",
	["Друид"] = "|cffFF7D0AДруид|r",
	["Жрец"] = "|cffFFFFFFЖрец|r",
	["Маг"] = "|cff69CCF0Маг|r",
	["Монах"] = "|cff00FF96Монах|r",
	["Охотник"] = "|cffABD473Охотник|r",
	["Охотник на демонов"] = "|cffA330C9Охотник на демонов|r",
	["Паладин"] = "|cffF58CBAПаладин|r",
	["Разбойник"] = "|cffFFF569Разбойник|r",
	["Рыцарь смерти"] = "|cffC41F3BРыцарь смерти|r",
	["Чернокнижник"] = "|cff9482C9Чернокнижник|r",
	["Шаман"] = "|cff0070DEШаман|r",
}

local function Translate(text)
	if text then
		for rus, replace in next, replace do
			text = text:gsub(rus, replace)
		end
		return text
	end
end

local function TranslateClass(text)
	if text then
		for rus, replaceclass in next, replaceclass do
			if not (rus == "Охотник" and string.find(text, "Охотник на демонов")) then
				text = text:gsub(rus, replaceclass)
			end
		end
		return text
	end
end

local whiteTooltip = {
	[GameTooltip] = true,
	[ItemRefTooltip] = true,
	[ShoppingTooltip1] = true,
	[ShoppingTooltip2] = true,
}

local function UpdateTooltip(self)
	if whiteTooltip[self] and not self:IsForbidden() then
		if not TooltipUtil.GetDisplayedItem(self) then return end
		local ttext, text
		local tname = self:GetName()
		for i = 3, self:NumLines() do
			-- Check left side text
			ttext = _G[tname.."TextLeft"..i]
			if ttext then
				text = ttext:GetText()
			end
			if text and T.NotSecretValue(text) then
				ttext:SetText(Translate(text))
				local class = string.find(text, "Класс") or string.find(text, "Требуется")
				if class then ttext:SetText(TranslateClass(text)) end
			end

			-- Check right side text
			ttext = _G[tname.."TextRight"..i]
			if ttext then
				text = ttext:GetText()
			end
			if text and T.NotSecretValue(text) then
				ttext:SetText(Translate(text))
			end
		end
	end
end

TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, UpdateTooltip)
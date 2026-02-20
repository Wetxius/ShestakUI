local T, C, L = unpack(ShestakUI)
if C.automation.reputation ~= true then return end

----------------------------------------------------------------------------------------
--	Auto track reputation gain
----------------------------------------------------------------------------------------
local function GetFactionName(msg)
	local faction = msg:match("|3[-–]?%d*%((.-)%)")
	if not faction then
		faction = msg:match("\"(.-)\"")
	end
	if faction then
		faction = faction:gsub("|c[Ff][Ff]%x%x%x%x%x%x", ""):match("^%s*(.-)%s*$")
	end
	return faction
end

local function CheckFaction(msg)
	local factionName
	if canaccessvalue(msg) then
		factionName = GetFactionName(msg)
	end

	if not factionName then return end -- not found
	for i = 1, C_Reputation.GetNumFactions() do
		local data  = C_Reputation.GetFactionDataByIndex(i)
		if data and strlower(factionName) == strlower(data.name) then
			C_Reputation.SetWatchedFactionByID(data.factionID)
			break
		end
	end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("CHAT_MSG_COMBAT_FACTION_CHANGE")
frame:SetScript("OnEvent", function(_, _, msg)
	CheckFaction(msg)
end)
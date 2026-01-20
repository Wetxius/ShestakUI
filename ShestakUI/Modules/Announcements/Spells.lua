local T, C, L = unpack(ShestakUI)
if T.newPatch then return end -- BETA not work
if C.announcements.spells ~= true then return end

----------------------------------------------------------------------------------------
--	Announce some spells
----------------------------------------------------------------------------------------
local frame = CreateFrame("Frame")
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
frame:SetScript("OnEvent", function()
	local _, event, _, sourceGUID, sourceName, _, _, _, destName, _, _, spellID = CombatLogGetCurrentEventInfo()
	if event ~= "SPELL_CAST_SUCCESS" or not T.AnnounceSpells[spellID] then return end
	local _, _, difficultyID = GetInstanceInfo()
	if difficultyID == 0 then return end

	if sourceName then sourceName = sourceName:gsub("%-[^|]+", "") end
	if destName then destName = destName:gsub("%-[^|]+", "") end
	local isPlayerCast = (sourceGUID == UnitGUID("player") and sourceName == T.name)

	if C.announcements.spells_from_all and not isPlayerCast then
		if not sourceName then return end

		if destName then
			C_ChatInfo.SendChatMessage(string.format(L_ANNOUNCE_FP_USE, sourceName, C_Spell.GetSpellLink(spellID).." -> "..destName), T.CheckChat())
		else
			C_ChatInfo.SendChatMessage(string.format(L_ANNOUNCE_FP_USE, sourceName, C_Spell.GetSpellLink(spellID)), T.CheckChat())
		end
	else
		if not isPlayerCast then return end

		if destName then
			C_ChatInfo.SendChatMessage(C_Spell.GetSpellLink(spellID).." -> "..destName, T.CheckChat())
		else
			C_ChatInfo.SendChatMessage(string.format(L_ANNOUNCE_FP_USE, sourceName, C_Spell.GetSpellLink(spellID)), T.CheckChat())
		end
	end
end)
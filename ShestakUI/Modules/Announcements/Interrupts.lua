local T, C, L = unpack(ShestakUI)
if T.Midnight then return end -- BETA not work
if C.announcements.interrupts ~= true then return end

----------------------------------------------------------------------------------------
--	Announce your interrupts(by Elv22)
----------------------------------------------------------------------------------------
local RaidIconMaskToIndex = {
	[Enum.CombatLogObjectTarget.Raidtarget1] = 1,
	[Enum.CombatLogObjectTarget.Raidtarget2] = 2,
	[Enum.CombatLogObjectTarget.Raidtarget3] = 3,
	[Enum.CombatLogObjectTarget.Raidtarget4] = 4,
	[Enum.CombatLogObjectTarget.Raidtarget5] = 5,
	[Enum.CombatLogObjectTarget.Raidtarget6] = 6,
	[Enum.CombatLogObjectTarget.Raidtarget7] = 7,
	[Enum.CombatLogObjectTarget.Raidtarget8] = 8,
}

local function GetRaidIcon(unitFlags)
	local raidTarget = bit.band(unitFlags, Constants.CombatLogObjectTargetMasks.COMBATLOG_OBJECT_RAID_TARGET_MASK)
	if raidTarget == 0 then
		return ""
	end

	return "{rt"..RaidIconMaskToIndex[raidTarget].."}"
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
frame:SetScript("OnEvent", function()
	if not IsInGroup() then return end
	local _, event, _, sourceGUID, _, _, _, _, destName, _, destRaidFlags, _, _, _, spellID = C_CombatLog.GetCurrentEventInfo()
	if not (event == "SPELL_INTERRUPT" and sourceGUID == UnitGUID("player")) then return end

	local destIcon = ""
	if destName then
		destIcon = GetRaidIcon(destRaidFlags)
	end

	T.SendChatMessage(L_ANNOUNCE_INTERRUPTED.." "..destIcon..destName..": "..C_Spell.GetSpellLink(spellID), T.CheckChat())
end)
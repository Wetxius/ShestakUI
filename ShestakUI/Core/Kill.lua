local T, C, L = unpack(ShestakUI)

----------------------------------------------------------------------------------------
--	Kill all stuff on default UI that we don't need
----------------------------------------------------------------------------------------
local function HideFrames()
	CompactRaidFrameManager:UnregisterAllEvents()
	CompactRaidFrameContainer:UnregisterAllEvents()
	CompactRaidFrameManager:SetAlpha(0)
	if not InCombatLockdown() then
		CompactRaidFrameManager:Hide()
		local shown = CompactRaidFrameManager_GetSetting("IsShown")
		if shown and shown ~= "0" then
			CompactRaidFrameManager_SetSetting("IsShown", "0")
		end
	end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, addon)
	if C.unitframe.enable and C.raidframe.layout ~= "BLIZZARD" then
		if CompactRaidFrameManager then
			hooksecurefunc("CompactRaidFrameManager_UpdateShown", HideFrames)
			CompactRaidFrameManager:HookScript("OnShow", HideFrames)
			CompactRaidFrameContainer:HookScript("OnShow", HideFrames)
			HideFrames()
			CompactArenaFrame:HookScript("OnShow", function(self) self:Hide() end)
			UIParent:UnregisterEvent("GROUP_ROSTER_UPDATE") -- Hide/Show party member frames with UpdateRaidAndPartyFrames()
			self:UnregisterAllEvents()
		end
	else
		self:UnregisterAllEvents()
	end
end)

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function()
	if ClassPowerBar then
		ClassPowerBar.OnEvent = T.dummy -- Fix error with druid on logon
	end

	TutorialFrameAlertButton:Kill()
	SetCVarBitfield("closedInfoFrames", LE_FRAME_TUTORIAL_WORLD_MAP_FRAME, true)
	SetCVarBitfield("closedInfoFrames", LE_FRAME_TUTORIAL_PET_JOURNAL, true)
	SetCVarBitfield("closedInfoFrames", LE_FRAME_TUTORIAL_GARRISON_BUILDING, true)
	SetCVarBitfield("closedInfoFrames", LE_FRAME_TUTORIAL_TALENT_CHANGES, true)

	-- Keep it work always
	SetCVar("countdownForCooldowns", 1)

	if C.chat.enable then
		SetCVar("chatStyle", "im")
	end

	if C.minimap.enable then
		SetCVar("minimapTrackingShowAll", 1)
	end

	if C.bag.enable then
		C_Container.SetSortBagsRightToLeft(true)
		C_Container.SetInsertItemsLeftToRight(false)
	end

	SetCVar("timeMgrUseMilitaryTime", 1) -- TODO: delete afterwhile
end)

local function AcknowledgeTips()
	if InCombatLockdown() then return end

	for frame in _G.HelpTip.framePool:EnumerateActive() do
		frame:Acknowledge()
	end
end

AcknowledgeTips()
hooksecurefunc(_G.HelpTip, "Show", AcknowledgeTips)
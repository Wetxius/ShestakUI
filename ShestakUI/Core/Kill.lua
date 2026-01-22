local T, C, L = unpack(ShestakUI)

----------------------------------------------------------------------------------------
--	Kill all stuff on default UI that we don't need
----------------------------------------------------------------------------------------
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function()
	if ClassPowerBar then
		ClassPowerBar.OnEvent = T.dummy -- Fix error with druid on logon
	end

	if C.unitframe.enable and C.raidframe.layout ~= "BLIZZARD" then
		if CompactRaidFrameManager then
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
			hooksecurefunc("CompactRaidFrameManager_UpdateShown", HideFrames)
			CompactRaidFrameManager:HookScript("OnShow", HideFrames)
			CompactRaidFrameContainer:HookScript("OnShow", HideFrames)
			HideFrames()
		end
		CompactArenaFrame:HookScript("OnShow", function(self) self:Hide() end)
		UIParent:UnregisterEvent("GROUP_ROSTER_UPDATE")
	end

	TutorialFrameAlertButton:Kill()
	SetCVarBitfield("closedInfoFrames", LE_FRAME_TUTORIAL_WORLD_MAP_FRAME, true)
	SetCVarBitfield("closedInfoFrames", LE_FRAME_TUTORIAL_PET_JOURNAL, true)
	SetCVarBitfield("closedInfoFrames", LE_FRAME_TUTORIAL_GARRISON_BUILDING, true)
	SetCVarBitfield("closedInfoFrames", LE_FRAME_TUTORIAL_TALENT_CHANGES, true)

	SetCVar("countdownForCooldowns", 0)
	-- SetCVar("countdownForCooldowns", 1) -- BETA

	if C.chat.enable then
		SetCVar("chatStyle", "im")
	end

	if C.unitframe.enable then
		if T.class == "DEATHKNIGHT" and C.unitframe_class_bar.rune ~= true then
			RuneFrame:Kill()
		end
		SetCVar("showPartyBackground", 0)
	end

	if C.nameplate.enable then
		SetCVar("ShowClassColorInNameplate", 1)
	end

	if C.minimap.enable then
		SetCVar("minimapTrackingShowAll", 1)
	end

	if C.bag.enable then
		C_Container.SetSortBagsRightToLeft(true)
		C_Container.SetInsertItemsLeftToRight(false)
	end

	-- BETA not used
	-- if C.combattext.enable then
		-- if C.combattext.incoming then
			-- SetCVar("enableFloatingCombatText", 1)
		-- else
			-- SetCVar("enableFloatingCombatText", 0)
		-- end
	-- end
end)

local function AcknowledgeTips()
	if InCombatLockdown() then return end

	for frame in _G.HelpTip.framePool:EnumerateActive() do
		frame:Acknowledge()
	end
end

AcknowledgeTips()
hooksecurefunc(_G.HelpTip, "Show", AcknowledgeTips)

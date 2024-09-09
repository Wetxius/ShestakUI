local T, C, L = unpack(ShestakUI)
if C.skins.blizzard_frames ~= true then return end

----------------------------------------------------------------------------------------
--	Islands skin
----------------------------------------------------------------------------------------
local function LoadSkin()
	IslandsQueueFrame:StripTextures()
	IslandsQueueFrame:SetTemplate("Transparent")

	IslandsQueueFrame.ArtOverlayFrame:SetAlpha(0)
	IslandsQueueFrame.TitleBanner.Banner:SetAlpha(0)

	IslandsQueueFrame.HelpButton.Ring:Hide()
	IslandsQueueFrame.HelpButton:SetPoint("TOPLEFT", IslandsQueueFrame, "TOPLEFT", -12, 12)

	IslandsQueueFrame.DifficultySelectorFrame.Background:Hide()
	IslandsQueueFrame.DifficultySelectorFrame:SetPoint("BOTTOM", 0, -15)
	IslandsQueueFrame.DifficultySelectorFrame.QueueButton:SkinButton()

	T.SkinCloseButton(IslandsQueueFrameCloseButton)

	-- StatusBar
	IslandsQueueFrame.WeeklyQuest.OverlayFrame:StripTextures()
	IslandsQueueFrame.WeeklyQuest.StatusBar:CreateBackdrop("Overlay")

	local reward = IslandsQueueFrame.WeeklyQuest.QuestReward
	reward:ClearAllPoints()
	reward:SetPoint("LEFT", IslandsQueueFrame.WeeklyQuest.StatusBar, "RIGHT", -3, 0)
	reward.CircleMask:Hide()
	reward:StripTextures()
	reward.Icon:SkinIcon()
	reward.Icon:SetSize(19, 19)

	-- TutorialFrame
	IslandsQueueFrame.TutorialFrame:StripTextures()
	IslandsQueueFrame.TutorialFrame:SetTemplate("Transparent")
	IslandsQueueFrame.TutorialFrame:SetPoint("TOPLEFT", 300, -150)
	IslandsQueueFrame.TutorialFrame:SetPoint("BOTTOMRIGHT", -300, 170)
	IslandsQueueFrame.TutorialFrame.TutorialText:SetTextColor(1, 1, 1)

	local TutorialIcon = IslandsQueueFrame.TutorialFrame:CreateTexture(nil, "BORDER")
	TutorialIcon:SetTexture([[Interface\Icons\INV_Glowing Azerite Spire]])
	TutorialIcon:SetSize(64, 64)
	TutorialIcon:SetPoint("TOP", IslandsQueueFrame.TutorialFrame, "TOP", 0, -10)
	TutorialIcon:SkinIcon(true)
	IslandsQueueFrame.TutorialFrame.Leave:SkinButton()
	T.SkinCloseButton(IslandsQueueFrame.TutorialFrame.CloseButton)
end

T.SkinFuncs["Blizzard_IslandsQueueUI"] = LoadSkin
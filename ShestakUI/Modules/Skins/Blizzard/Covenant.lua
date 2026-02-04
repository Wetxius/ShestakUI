local T, C, L = unpack(ShestakUI)
if C.skins.blizzard_frames ~= true then return end

----------------------------------------------------------------------------------------
--	Covenant Preview skin
----------------------------------------------------------------------------------------
local function LoadSkin()
	local frame = CovenantPreviewFrame

	frame.InfoPanel.Name:SetTextColor(1, 1, 1)
	frame.InfoPanel.Location:SetTextColor(1, 1, 1)
	frame.InfoPanel.Description:SetTextColor(1, 1, 1)
	frame.InfoPanel.AbilitiesFrame.AbilitiesLabel:SetTextColor(1, .8, 0)
	frame.InfoPanel.SoulbindsFrame.SoulbindsLabel:SetTextColor(1, .8, 0)
	frame.InfoPanel.CovenantFeatureFrame.Label:SetTextColor(1, .8, 0)

	hooksecurefunc(frame, "TryShow", function(covenantInfo)
		if covenantInfo and not frame.IsSkinned then
			frame:CreateBackdrop("Transparent")

			frame.ModelSceneContainer.ModelSceneBorder:SetAlpha(0)
			frame.InfoPanel:CreateBackdrop("Overlay")
			frame.InfoPanel.backdrop:SetPoint("TOPLEFT", 0, 1)
			frame.InfoPanel.backdrop:SetPoint("BOTTOMRIGHT", 0, -1)

			frame.ModelSceneContainer:CreateBackdrop("Default")

			frame.Title:DisableDrawLayer("BACKGROUND")
			frame.Title.Text:SetTextColor(1, 0.8, 0)
			frame.Background:SetAlpha(0)
			frame.BorderFrame:SetAlpha(0)
			frame.InfoPanel.Parchment:SetAlpha(0)

			frame.CloseButton.Border:Kill()
			T.SkinCloseButton(frame.CloseButton)
			frame.SelectButton:SkinButton()

			frame.IsSkinned = true
		end
		frame.CloseButton:SetPoint("TOPRIGHT", -4, -4)
	end)

	frame.ModelSceneContainer.Background:SetTexCoord(0.00970873786408, 0.97109826589595, 0.0092807424594, 0.97109826589595)

	T.SkinCheckBox(TransmogAndMountDressupFrame.ShowMountCheckButton)
end

T.SkinFuncs["Blizzard_CovenantPreviewUI"] = LoadSkin

-- Renown skin
local function LoadSkinRenown()
	local frame = CovenantRenownFrame
	frame:CreateBackdrop("Transparent")
	T.SkinCloseButton(frame.CloseButton)
	frame.LevelSkipButton:SkinButton()

	hooksecurefunc(frame, "SetUpCovenantData", function(self)
		self.CloseButton.Border:Hide()
		self:StripTextures()
	end)

	hooksecurefunc(frame, "SetRewards", function(self)
		for reward in self.rewardsPool:EnumerateActive() do
			if not reward.backdrop then
				reward:CreateBackdrop("Overlay")
				reward.backdrop:SetPoint("TOPLEFT", reward, 2, -15)
				reward.backdrop:SetPoint("BOTTOMRIGHT", reward, -2, 15)

				reward.Toast:SetAlpha(0)
				reward.Highlight:SetAlpha(0)
				reward.CircleMask:Hide()
				reward.IconBorder:SetAlpha(0)

				reward.b = CreateFrame("Frame", nil, reward)
				reward.b:SetTemplate("Default")
				reward.b:SetPoint("TOPLEFT", reward.Icon, "TOPLEFT", -2, 2)
				reward.b:SetPoint("BOTTOMRIGHT", reward.Icon, "BOTTOMRIGHT", 2, -2)
				reward.Icon:SetParent(reward.b)
				reward.Icon:SetTexCoord(0.15, 0.85, 0.15, 0.85)
				reward.Check:SetParent(reward.b)
			end
		end
	end)
end

T.SkinFuncs["Blizzard_CovenantRenown"] = LoadSkinRenown

-- Toast skin
local function LoadSkinToast()
	hooksecurefunc(CovenantRenownToast, "PlayBanner", function(self)
		if not self.styled then
			self.RewardIcon:SkinIcon(true)
			self.styled = true
		end
		self.RewardIconRing:Hide()
		self.RewardIconMask:Hide()
	end)
end

-- /run CovenantRenownToast:ShowRenownLevelUpToast(C_Covenants.GetActiveCovenantID(), 40)

T.SkinFuncs["Blizzard_CovenantToasts"] = LoadSkinToast

-- Sanctum skin
local function LoadSkinSanctum()
	local frame = CovenantSanctumFrame

	frame.UpgradesTab.DepositButton:SkinButton()
	frame.LevelFrame.Background:SetAlpha(0)

	frame.UpgradesTab:CreateBackdrop("Overlay")
	frame.UpgradesTab.backdrop:SetPoint("TOPLEFT", frame.UpgradesTab.Background, -2, 2)
	frame.UpgradesTab.backdrop:SetPoint("BOTTOMRIGHT", frame.UpgradesTab.Background, 2, -2)

	local talentsList = frame.UpgradesTab.TalentsList
	talentsList:CreateBackdrop("Overlay")
	talentsList.backdrop:SetPoint("TOPLEFT", 6, 2)
	talentsList.backdrop:SetPoint("BOTTOMRIGHT", 2, -2)
	talentsList.UpgradeButton:SkinButton()
	talentsList.Divider:SetAlpha(0)
	talentsList.BackgroundTile:SetAlpha(0)
	talentsList.IntroBox.Background:Hide()

	local function HandleIconString(self, text)
		if not text then text = self:GetText() end
		if not text or text == '' then return end

		local new, count = gsub(text, '|T([^:]-):[%d+:]+|t', '|T%1:14:14:0:0:64:64:5:59:5:59|t')
		if count > 0 then self:SetFormattedText('%s', new) end
	end

	for frame in frame.UpgradesTab.CurrencyDisplayGroup.currencyFramePool:EnumerateActive() do
		if not frame.IsSkinned then
			HandleIconString(frame.Text)
			hooksecurefunc(frame.Text, "SetText", HandleIconString)

			frame.IsSkinned = true
		end
	end

	hooksecurefunc(talentsList, "Refresh", function(self)
		for frame in self.talentPool:EnumerateActive() do
			if not frame.backdrop then
				frame.Border:SetAlpha(0)
				frame.IconBorder:SetAlpha(0)
				frame.TierBorder:SetAlpha(0)
				frame.Background:SetAlpha(0)

				frame:CreateBackdrop("Overlay")
				frame.backdrop:SetInside()
				frame.backdrop.overlay:SetVertexColor(0.15, 0.15, 0.15, 1)

				frame.Icon:SetPoint("TOPLEFT", 10, -10)
				frame.Icon:SetSize(35, 35)
				frame.Icon:SkinIcon(true)

				frame.Highlight:SetColorTexture(1, 1, 1, 0.3)
				frame.Highlight:SetInside(frame.backdrop)

				HandleIconString(frame.InfoText)
				hooksecurefunc(frame.InfoText, "SetText", HandleIconString)
			end
		end
	end)

	frame:HookScript("OnShow", function()
		if not frame.backdrop then
			frame:CreateBackdrop("Transparent")
			frame.NineSlice:SetAlpha(0)

			frame.CloseButton.Border:SetAlpha(0)
			T.SkinCloseButton(frame.CloseButton)
		end
	end)
end

T.SkinFuncs["Blizzard_CovenantSanctum"] = LoadSkinSanctum
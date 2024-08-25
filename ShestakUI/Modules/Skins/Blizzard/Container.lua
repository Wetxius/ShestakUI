local T, C, L = unpack(ShestakUI)
if C.skins.blizzard_frames ~= true then return end

----------------------------------------------------------------------------------------
--	Bank/Container skin
----------------------------------------------------------------------------------------
local function LoadSkin()
	if C.bag.enable == true or T.anotherBags then return end

	local function SkinBagSlots(button)
		if not button.styled then
			local icon = button.icon

			button:SetNormalTexture(0)
			button:StyleButton()
			button:SetTemplate("Default")

			icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			icon:ClearAllPoints()
			icon:SetPoint("TOPLEFT", 2, -2)
			icon:SetPoint("BOTTOMRIGHT", -2, 2)

			button.Count:SetFont(C.font.bags_font, C.font.bags_font_size, C.font.bags_font_style)
			button.Count:SetShadowOffset(C.font.bags_font_shadow and 1 or 0, C.font.bags_font_shadow and -1 or 0)
			button.Count:SetPoint("BOTTOMRIGHT", 1, 1)

			T.SkinIconBorder(button.IconBorder, button)

			button.IconQuestTexture:SetAlpha(0)
			if button.Background then
				button.Background:SetAlpha(0)
			end

			button.styled = true
		end
	end

	local function SkinItemSlots(self)
		for button in self.itemButtonPool:EnumerateActive() do
			SkinBagSlots(button)
		end
	end

	-- Container Frame
	BagItemSearchBox:StripTextures(true)
	BagItemSearchBox:CreateBackdrop("Overlay")
	BagItemSearchBox.backdrop:SetPoint("TOPLEFT", 13, 0)
	BagItemSearchBox.backdrop:SetPoint("BOTTOMRIGHT", -2, 0)
	BagItemSearchBox:ClearAllPoints()
	BagItemSearchBox:SetPoint("TOPRIGHT", BagItemAutoSortButton, "TOPLEFT", -3, 0)
	BagItemSearchBox.ClearAllPoints = T.dummy
	BagItemSearchBox.SetPoint = T.dummy

	BagItemAutoSortButton:SetSize(18, 18)
	BagItemAutoSortButton:StyleButton()
	BagItemAutoSortButton:SetTemplate("Default")
	BagItemAutoSortButton:GetNormalTexture():SetTexture("Interface\\Icons\\inv_pet_broom")
	BagItemAutoSortButton:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
	BagItemAutoSortButton:GetNormalTexture():ClearAllPoints()
	BagItemAutoSortButton:GetNormalTexture():SetPoint("TOPLEFT", 2, -2)
	BagItemAutoSortButton:GetNormalTexture():SetPoint("BOTTOMRIGHT", -2, 2)

	ContainerFrameCombinedBags:StripTextures(true)
	ContainerFrameCombinedBags:CreateBackdrop("Transparent")
	ContainerFrameCombinedBags.Bg:Hide()
	T.SkinCloseButton(ContainerFrameCombinedBags.CloseButton)

	ContainerFrameCombinedBags:ClearAllPoints()
	ContainerFrameCombinedBags:SetPoint(unpack(C.position.bag))
	ContainerFrameCombinedBags.SetPoint = T.dummy

	ContainerFrameCombinedBags.MoneyFrame.Border:Hide()
	ContainerFrame1MoneyFrame.Border:Hide()

	ContainerFrameCombinedBagsPortrait:SetAlpha(0)
	ContainerFrameCombinedBagsPortraitButton.Highlight:SetAlpha(0)
	ContainerFrameCombinedBagsPortraitButtonTexture = ContainerFrameCombinedBagsPortraitButton:CreateTexture(nil, "OVERLAY")
	ContainerFrameCombinedBagsPortraitButtonTexture:SetSize(30, 30)
	ContainerFrameCombinedBagsPortraitButtonTexture:SetPoint("CENTER", 2, 1)
	ContainerFrameCombinedBagsPortraitButtonTexture:SetTexture("Interface\\Icons\\inv_misc_bag_08")
	ContainerFrameCombinedBagsPortraitButtonTexture:SkinIcon()

	local function updateQuestItems(self)
		for _, button in self:EnumerateValidItems() do
			if button.IconQuestTexture:IsShown() then
				if button.IconQuestTexture:GetTexture() == 368362 then
					button:SetBackdropBorderColor(1, 0.3, 0.3)
				else
					button:SetBackdropBorderColor(1, 1, 0)
				end
			else
				button:SetBackdropBorderColor(unpack(C.media.border_color))
			end
		end
	end

	hooksecurefunc(ContainerFrameCombinedBags, "UpdateItemSlots", SkinItemSlots)
	hooksecurefunc(ContainerFrameCombinedBags, "UpdateItems", updateQuestItems)

	for i = 1, NUM_CONTAINER_FRAMES do
		local frame = _G["ContainerFrame"..i]
		local close = _G["ContainerFrame"..i].CloseButton

		frame:StripTextures(true)
		frame:CreateBackdrop("Transparent")
		frame.backdrop:SetPoint("TOPLEFT", 4, -2)
		frame.backdrop:SetPoint("BOTTOMRIGHT", 0, 2)
		frame.Bg:Hide()

		frame.TitleContainer:SetPoint("TOPLEFT", frame, "TOPLEFT", 40, -1)

		local portrait = _G["ContainerFrame"..i.."Portrait"]
		portrait:SetSize(28, 28)
		portrait:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -8)
		portrait:SetTexCoord(0.2, 0.85, 0.2, 0.85)
		if frame.PortraitContainer.CircleMask then frame.PortraitContainer.CircleMask:Hide() end

		frame.b = CreateFrame("Frame", nil, frame)
		frame.b:SetTemplate("Default")
		frame.b:SetOutside(portrait)

		T.SkinCloseButton(close, frame.backdrop)

		hooksecurefunc(frame, "UpdateItemSlots", SkinItemSlots)
		hooksecurefunc(frame, "UpdateItems", updateQuestItems)
	end

	BackpackTokenFrame:StripTextures(true)
	hooksecurefunc(_G.BackpackTokenFrame, "Update", function (container)
		for _, token in next, container.Tokens do
			if not token.Icon.styled then
				token.Icon:SkinIcon()
				token.Count:ClearAllPoints()
				token.Count:SetPoint("RIGHT", token.Icon, "LEFT", -5, 0)
				token.Icon.styled = true
			end
		end
	end)

	-- Bank Frame
	BankFrame:StripTextures(true)
	BankFrame:CreateBackdrop("Transparent")
	BankFrame.backdrop:SetAllPoints()
	BankFramePortrait:SetAlpha(0)

	BankItemSearchBox:StripTextures(true)
	BankItemSearchBox:CreateBackdrop("Overlay")
	BankItemSearchBox.backdrop:SetPoint("TOPLEFT", 13, 0)
	BankItemSearchBox.backdrop:SetPoint("BOTTOMRIGHT", -2, 0)

	BankItemAutoSortButton:StyleButton()
	BankItemAutoSortButton:SetTemplate("Default")
	BankItemAutoSortButton:SetSize(20, 20)
	BankItemAutoSortButton:SetPoint("TOPLEFT", BankItemSearchBox, "TOPRIGHT", 3, 0)
	BankItemAutoSortButton:GetNormalTexture():SetTexture("Interface\\Icons\\inv_pet_broom")
	BankItemAutoSortButton:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
	BankItemAutoSortButton:GetNormalTexture():ClearAllPoints()
	BankItemAutoSortButton:GetNormalTexture():SetPoint("TOPLEFT", 2, -2)
	BankItemAutoSortButton:GetNormalTexture():SetPoint("BOTTOMRIGHT", -2, 2)

	BankFrameMoneyFrameBorder:Hide()

	BankFramePurchaseButton:SkinButton()
	T.SkinCloseButton(BankFrameCloseButton, BankFrame.backdrop)

	BankSlotsFrame:StripTextures()

	for i = 1, 28 do
		local item = _G["BankFrameItem"..i]
		SkinBagSlots(item)
	end

	for i = 1, 7 do
		local bag = BankSlotsFrame["Bag"..i]
		local icon = bag.icon

		bag.IconBorder:SetAlpha(0)

		bag:StripTextures()
		bag:StyleButton()
		bag:SetTemplate("Default")

		icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		icon:ClearAllPoints()
		icon:SetPoint("TOPLEFT", 2, -2)
		icon:SetPoint("BOTTOMRIGHT", -2, 2)
	end

	-- Tabs
	for i = 1, 3 do
		T.SkinTab(_G["BankFrameTab"..i])
	end

	-- ReagentBank
	ReagentBankFrame:StripTextures()
	ReagentBankFrame:DisableDrawLayer("BACKGROUND")
	ReagentBankFrame:DisableDrawLayer("ARTWORK")

	ReagentBankFrameUnlockInfo:StripTextures()
	ReagentBankFrameUnlockInfo:CreateBackdrop("Overlay")
	ReagentBankFrameUnlockInfo.backdrop:SetPoint("TOPLEFT", 4, -2)
	ReagentBankFrameUnlockInfo.backdrop:SetPoint("BOTTOMRIGHT", -4, 2)
	ReagentBankFrameUnlockInfo.backdrop:SetFrameLevel(ReagentBankFrameUnlockInfo.backdrop:GetFrameLevel() + 1)

	ReagentBankFrameUnlockInfoPurchaseButton:SkinButton()
	ReagentBankFrameUnlockInfoPurchaseButton:SetFrameLevel(ReagentBankFrameUnlockInfo:GetFrameLevel() + 3)
	ReagentBankFrame.DespositButton:SkinButton()

	ReagentBankFrame:HookScript("OnShow", function()
		for i = 1, 98 do
			local item = _G["ReagentBankFrameItem"..i]
			SkinBagSlots(item)
			BankFrameItemButton_Update(item)
		end
	end)

	hooksecurefunc("BankFrameItemButton_Update", function(frame)
		if not frame.isBag and frame.IconQuestTexture:IsShown() then
			if frame.IconQuestTexture:GetTexture() == 368362 then
				frame:SetBackdropBorderColor(1, 0.3, 0.3)
			else
				frame:SetBackdropBorderColor(1, 1, 0)
			end
		end
	end)

	-- Warband
	AccountBankPanel:StripTextures()

	hooksecurefunc(AccountBankPanel, "GenerateItemSlotsForSelectedTab", SkinItemSlots)

	local function SkinBankTab(button)
		if not button.styled then
			button.Border:SetAlpha(0)

			if button.Background then
				button.Background:SetAlpha(0)
			end

			button:SetTemplate("Default")
			button:StyleButton()

			button.SelectedTexture:SetColorTexture(1, 0.82, 0, 0.3)
			button.SelectedTexture:SetPoint("TOPLEFT", 2, -2)
			button.SelectedTexture:SetPoint("BOTTOMRIGHT", -2, 2)

			button.Icon:ClearAllPoints()
			button.Icon:SetPoint("TOPLEFT", 2, -2)
			button.Icon:SetPoint("BOTTOMRIGHT", -2, 2)
			button.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

			button.styled = true
		end
	end

	hooksecurefunc(AccountBankPanel, "RefreshBankTabs", function(self)
		for tab in self.bankTabPool:EnumerateActive() do
			SkinBankTab(tab)
		end
	end)
	SkinBankTab(AccountBankPanel.PurchaseTab)

	AccountBankPanel.ItemDepositFrame.DepositButton:SkinButton()
	T.SkinCheckBox(AccountBankPanel.ItemDepositFrame.IncludeReagentsCheckbox)
	AccountBankPanel.MoneyFrame.Border:Hide()
	AccountBankPanel.MoneyFrame.WithdrawButton:SkinButton()
	AccountBankPanel.MoneyFrame.DepositButton:SkinButton()

	AccountBankPanel.PurchasePrompt:StripTextures()
	AccountBankPanel.PurchasePrompt:CreateBackdrop("Overlay")
	AccountBankPanel.PurchasePrompt.backdrop:SetPoint("TOPLEFT", 4, -2)
	AccountBankPanel.PurchasePrompt.backdrop:SetPoint("BOTTOMRIGHT", -4, 2)
	AccountBankPanel.PurchasePrompt.backdrop:SetFrameLevel(AccountBankPanel.PurchasePrompt.backdrop:GetFrameLevel() + 1)

	AccountBankPanel.PurchasePrompt.TabCostFrame.PurchaseButton:SkinButton()
	AccountBankPanel.PurchasePrompt.TabCostFrame.PurchaseButton:SetFrameLevel(AccountBankPanel.PurchasePrompt:GetFrameLevel() + 3)

	T.SkinIconSelectionFrame(AccountBankPanel.TabSettingsMenu)
end

tinsert(T.SkinFuncs["ShestakUI"], LoadSkin)
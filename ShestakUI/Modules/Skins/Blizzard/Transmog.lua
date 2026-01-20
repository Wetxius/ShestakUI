local T, C, L = unpack(ShestakUI)
if C.skins.blizzard_frames ~= true then return end

----------------------------------------------------------------------------------------
--	Chromie Time skin
----------------------------------------------------------------------------------------
local function LoadSkin()
	local frame = TransmogFrame
	T.SkinFrame(frame)

	frame.HelpPlateButton.Ring:Hide()
	frame.HelpPlateButton:SetPoint("TOPLEFT", frame, "TOPLEFT", -15, 15)

	for _, tab in next, {frame.WardrobeCollection.TabHeaders:GetChildren()} do
		T.SkinTab(tab, true)
		tab.backdrop:SetPoint("TOPLEFT", 2, -5)
		tab.backdrop:SetPoint("BOTTOMRIGHT", -2, 0)
	end

	T.SkinCheckBox(frame.CharacterPreview.HideIgnoredToggle.Checkbox)

	T.SkinModelControl(frame.CharacterPreview.ModelScene)

	for _, f in pairs({frame.WardrobeCollection.TabContent.ItemsFrame, frame.WardrobeCollection.TabContent.SetsFrame}) do
		T.SkinEditBox(f.SearchBox, nil, 18)
		f.SearchBox:ClearAllPoints()
		f.SearchBox:SetPoint("RIGHT", f.FilterButton, "LEFT", -5, 0)
		T.SkinFilter(f.FilterButton, true)

		T.SkinNextPrevButton(f.PagedContent.PagingControls.PrevPageButton)
		T.SkinNextPrevButton(f.PagedContent.PagingControls.NextPageButton)
		f.PagedContent.PagingControls.PageText:SetPoint("LEFT", f.PagedContent.PagingControls, "LEFT", 0, 3)
	end

	T.SkinNextPrevButton(frame.WardrobeCollection.TabContent.CustomSetsFrame.PagedContent.PagingControls.PrevPageButton)
	T.SkinNextPrevButton(frame.WardrobeCollection.TabContent.CustomSetsFrame.PagedContent.PagingControls.NextPageButton)

	T.SkinScrollBar(frame.OutfitCollection.OutfitList.ScrollBar)

	T.SkinCheckBox(frame.WardrobeCollection.TabContent.SituationsFrame.EnabledToggle.Checkbox)

	local buttons = {
		frame.OutfitCollection.SaveOutfitButton,
		frame.OutfitCollection.PurchaseOutfitButton,
		frame.WardrobeCollection.TabContent.SituationsFrame.DefaultsButton,
		frame.WardrobeCollection.TabContent.SituationsFrame.ApplyButton,
		frame.WardrobeCollection.TabContent.CustomSetsFrame.NewCustomSetButton
	}

	for i = 1, #buttons do
		buttons[i]:SkinButton()
	end

	frame.OutfitCollection.PurchaseOutfitButton:SetHeight(28)
	frame.WardrobeCollection.TabContent.SituationsFrame.ApplyButton:SetHeight(26)

	frame.OutfitCollection.OutfitList.DividerTop:Hide()
	frame.OutfitCollection.OutfitList.DividerBottom:Hide()

	local button = frame.OutfitCollection.ShowEquippedGearSpellFrame.Button
	button:CreateBackdrop("Default")
	button.backdrop:SetAllPoints()
	button:StyleButton()
	button.Border:Hide()
	button.Icon:CropIcon()
	local overlay = frame.OutfitCollection.ShowEquippedGearSpellFrame.OverlayFX.OverlayActive
	overlay:SetInside(button.backdrop)
	overlay:SetColorTexture(1, 0.82, 0, 0.3)

	hooksecurefunc(frame.OutfitCollection.OutfitList.ScrollBox, "Update", function(frame)
		for _, frame in next, {frame.ScrollTarget:GetChildren()} do
			local button = frame.OutfitButton
			local iconFrame = frame.OutfitIcon
			if not button.isSkinned then
				button:GetRegions():Hide()
				button.Selected:SetDrawLayer("ARTWORK")
				button.Selected:ClearAllPoints()
				button.Selected:SetPoint("TOPLEFT", 4, -4)
				button.Selected:SetPoint("BOTTOMRIGHT", -4, 4)
				button.Selected:SetColorTexture(1, 0.82, 0, 0.3)
				button.NormalTexture:SetTexture(nil)
				button:CreateBackdrop("Overlay")
				button.backdrop:SetPoint("TOPLEFT", 2, -2)
				button.backdrop:SetPoint("BOTTOMRIGHT", -2, 2)
				button:StyleButton(nil, 4)

				iconFrame:CreateBackdrop("Default")
				iconFrame.backdrop:SetPoint("TOPLEFT", 2, -2)
				iconFrame.backdrop:SetPoint("BOTTOMRIGHT", -2, 2)
				iconFrame:StyleButton(nil, 4)
				iconFrame.Border:Hide()
				iconFrame.OverlayActive:SetInside(iconFrame.backdrop)
				iconFrame.OverlayActive:SetColorTexture(1, 0.82, 0, 0.3)

				iconFrame.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				iconFrame.Icon:ClearAllPoints()
				iconFrame.Icon:SetPoint("BOTTOMRIGHT", button, "BOTTOMLEFT", -3, 4)
				iconFrame.Icon:SetInside(iconFrame.backdrop)

				button.isSkinned = true
			end
		end
	end)

	frame.OutfitCollection.MoneyFrame:StripTextures()

	frame.OutfitCollection:StripTextures()
	frame.WardrobeCollection:StripTextures()

	frame.CharacterPreview.Gradients:Hide()
	frame.CharacterPreview:StripTextures()
	frame.CharacterPreview:CreateBackdrop("Overlay")
	frame.CharacterPreview.backdrop.overlay:SetVertexColor(0.13, 0.13, 0.13, 1)
	frame.CharacterPreview.backdrop:SetPoint("TOPLEFT", 2, -10)
	frame.CharacterPreview.backdrop:SetPoint("BOTTOMRIGHT", -4, 4)

	frame.WardrobeCollection.TabContent:StripTextures()
	frame.WardrobeCollection.TabContent:CreateBackdrop("Overlay")
	frame.WardrobeCollection.TabContent.backdrop.overlay:SetVertexColor(0.13, 0.13, 0.13, 1)
	frame.WardrobeCollection.TabContent.backdrop:SetPoint("TOPLEFT", 2, -10)
	frame.WardrobeCollection.TabContent.backdrop:SetPoint("BOTTOMRIGHT", -4, 2)

	frame.WardrobeCollection.TabContent.SituationsFrame.Situations:StripTextures()

	hooksecurefunc(frame.WardrobeCollection.TabContent.SituationsFrame, "Init", function(self)
		for frame in self.SituationFramePool:EnumerateActive() do
			T.SkinDropDownBox(frame.Dropdown)
		end
	end)

	local function SkinModels(model)
		model.Border:SetAlpha(0)
		model.PendingFrame:SetAlpha(0)
		local bg = CreateFrame("Frame", nil, model)
		bg:CreateBackdrop("Overlay")
		bg.backdrop:SetPoint("TOPLEFT", model, "TOPLEFT", -2, 2)
		bg.backdrop:SetPoint("BOTTOMRIGHT", model, "BOTTOMRIGHT", 3, -2)

		local highlight = model.BorderHighlight
		if highlight then
			highlight:SetColorTexture(1, 1, 1, 0.2)
			highlight:SetBlendMode("ADD")
			highlight:SetInside(bg.backdrop)
		end
		if model.Highlight then
			model.Highlight:SetAlpha(0)
		end

		local stete = model.StateTexture or model.TransmogStateTexture
		if stete then
			stete:SetAlpha(0)
			hooksecurefunc(stete, "SetAtlas", function(_, texture)
				local color
				if texture == "transmog-itemcard-transmogrified-pending" or texture == "transmog-setcard-transmogrified-pending" then
					color = {1, 0.7, 1}
				else
					color = C.media.border_color
				end
				bg.backdrop:SetBackdropBorderColor(unpack(color))
			end)

			hooksecurefunc(stete, "Hide", function()
				bg.backdrop:SetBackdropBorderColor(unpack(C.media.border_color))
			end)
		end
	end

	hooksecurefunc(frame.WardrobeCollection.TabContent.ItemsFrame.PagedContent, "DisplayViewsForCurrentPage", function(self)
		for _, frame in self:EnumerateFrames() do
			if not frame.skinned then
				SkinModels(frame)
				frame.skinned = true
			end
		end
	end)

	hooksecurefunc(frame.WardrobeCollection.TabContent.SetsFrame.PagedContent, "DisplayViewsForCurrentPage", function(self)
		for _, frame in self:EnumerateFrames() do
			if not frame.skinned then
				SkinModels(frame)
				frame.skinned = true
			end
		end
	end)

	hooksecurefunc(frame.WardrobeCollection.TabContent.CustomSetsFrame.PagedContent, "DisplayViewsForCurrentPage", function(self)
		for _, frame in self:EnumerateFrames() do
			if not frame.skinned then
				SkinModels(frame)
				frame.skinned = true
			end
		end
	end)

	local button = frame.CharacterPreview.ClearAllPendingButton
	button:SetSize(28, 28)
	button:CreateBackdrop("Default")
	button.backdrop:SetAllPoints()
	button:StyleButton()
	button.NormalTexture:SetAlpha(0)
	button.Icon:CropIcon()

	T.SkinIconSelectionFrame(TransmogFrame.OutfitPopup)
end

T.SkinFuncs["Blizzard_Transmog"] = LoadSkin
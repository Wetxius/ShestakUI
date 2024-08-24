local T, C, L = unpack(ShestakUI)
if C.skins.blizzard_frames ~= true or C.skins.clique ~= true then return end

----------------------------------------------------------------------------------------
--	Clique skin
----------------------------------------------------------------------------------------
if not C_AddOns.IsAddOnLoaded("Clique") then return end

local isStyled = false
hooksecurefunc(Clique, "ShowBindingConfig", function(self)
	if isStyled then return end
	T.SkinFrame(CliqueUIBindingFrame)

	CliqueConfigUIBrowseScrollBackground.NineSlice:StripTextures()

	hooksecurefunc(_G.CliqueConfigUIScrollFrame, "Update", function(frame)
		for _, button in next, {frame.ScrollTarget:GetChildren()} do
			if not button.isSkinned then
				button.Background:SetAlpha(0)
				button.FrameHighlight:SetAlpha(0)

				button.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				button.DeleteButton:SkinButton()

				button:CreateBackdrop("Overlay")
				button.backdrop:SetInside()
				button:StyleButton(nil, 4)

				button.isSkinned = true
			end
		end
	end)

	CliqueConfigUIBindingFrameBrowsePage.OptionsButton:SkinButton()
	CliqueConfigUIBindingFrameBrowsePage.AddButton:SkinButton()
	CliqueConfigUIBindingFrameBrowsePage.EditButton:SkinButton()
	CliqueConfigUIBindingFrameBrowsePage.QuickbindMode:SkinButton()

	CliqueConfigUIBindingFrameEditPage.changeBinding:SkinButton()
	CliqueConfigUIBindingFrameEditPage.CancelButton:SkinButton()
	CliqueConfigUIBindingFrameEditPage.SaveButton:SkinButton()

	T.SkinScrollBar(CliqueConfigUIScrollBar)

	T.SkinFrame(CliqueConfigUIActionCatalogFrame, true)
	CliqueConfigUIActionCatalogFrame.backdrop:SetPoint("TOPLEFT", 6, 0)
	CliqueConfigUISpellbookFilterButton:SkinButton()
	T.SkinEditBox(CliqueConfigUISpellbookSearch)

	for i = 1, 16 do
		local button = _G["CliqueUICatalogFrameButton"..i]
		if button then
			button:StyleButton()
			button.background:SkinIcon()
		end
	end

	T.SkinNextPrevButton(CliqueConfigUIActionCatalogFrame.prev, true)
	T.SkinNextPrevButton(CliqueConfigUIActionCatalogFrame.next)

	CliqueBindOtherDropdownBackdrop:SetTemplate("Transparent")
	isStyled = true
end)
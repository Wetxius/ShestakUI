local T, C, L = unpack(ShestakUI)
if C.skins.blizzard_frames ~= true then return end

----------------------------------------------------------------------------------------
--	TalentUI skin
----------------------------------------------------------------------------------------
local function LoadSkin()
	local frame = PlayerSpellsFrame
	T.SkinFrame(frame)

	PlayerSpellsFrame.TalentsFrame.BlackBG:SetAlpha(0)
	PlayerSpellsFrame.TalentsFrame.BottomBar:SetAlpha(0)

	PlayerSpellsFrame.TalentsFrame.ApplyButton:SkinButton(true)

	T.SkinDropDownBox(PlayerSpellsFrame.TalentsFrame.LoadSystem.Dropdown, 190)

	T.SkinEditBox(PlayerSpellsFrame.TalentsFrame.SearchBox)
	PlayerSpellsFrame.TalentsFrame.SearchBox.backdrop:SetPoint("TOPLEFT", -4, -4)
	PlayerSpellsFrame.TalentsFrame.SearchBox.backdrop:SetPoint("BOTTOMRIGHT", 0, 5)
	PlayerSpellsFrame.TalentsFrame.SearchPreviewContainer:StripTextures()
	PlayerSpellsFrame.TalentsFrame.SearchPreviewContainer:CreateBackdrop("Transparent")

	PlayerSpellsFrame.TalentsFrame.InspectCopyButton:SkinButton()

	for _, tab in next, {PlayerSpellsFrame.TabSystem:GetChildren()} do
		T.SkinTab(tab)
	end

	-- Profiles
	local function SkinTalentFrameDialog(dialog)
		if not dialog then return end

		dialog:StripTextures()
		dialog:CreateBackdrop("Transparent")

		if dialog.AcceptButton then dialog.AcceptButton:SkinButton() end
		if dialog.CancelButton then dialog.CancelButton:SkinButton() end
		if dialog.DeleteButton then dialog.DeleteButton:SkinButton() end

		T.SkinEditBox(dialog.NameControl.EditBox)
		dialog.NameControl.EditBox.backdrop:SetPoint("TOPLEFT", -5, -10)
		dialog.NameControl.EditBox.backdrop:SetPoint("BOTTOMRIGHT", 5, 10)
	end

	local ImportDialog = _G.ClassTalentLoadoutImportDialog
	if ImportDialog then
		SkinTalentFrameDialog(ImportDialog)
		ImportDialog.ImportControl.InputContainer:StripTextures()
		ImportDialog.ImportControl.InputContainer:CreateBackdrop("Transparent")
	end

	local CreateDialog = _G.ClassTalentLoadoutCreateDialog
	if CreateDialog then
		SkinTalentFrameDialog(CreateDialog)
	end

	local EditDialog = _G.ClassTalentLoadoutEditDialog
	if EditDialog then
		SkinTalentFrameDialog(EditDialog)

		local editbox = EditDialog.LoadoutName
		if editbox then
			T.SkinEditBox(editbox)
			editbox.backdrop:SetPoint("TOPLEFT", -5, -5)
			editbox.backdrop:SetPoint("BOTTOMRIGHT", 5, 5)
		end

		local check = EditDialog.UsesSharedActionBars
		if check then
			T.SkinCheckBox(check.CheckButton)
		end
	end

	for _, frame in pairs{PlayerSpellsFrame.TalentsFrame.HeroTalentsContainer.PreviewContainer, PlayerSpellsFrame.TalentsFrame.HeroTalentsContainer.ExpandedContainer} do
		if frame then
			frame.Background:SetAlpha(0)
			frame:CreateBackdrop("Transparent")
			frame.backdrop:SetInside(heroTalentPreview, 20, 40)
			frame.backdrop:SetBackdropColor(C.media.backdrop_color[1], C.media.backdrop_color[2], C.media.backdrop_color[3], 0.5)
		end
	end

	local TalentsSelect = _G.HeroTalentsSelectionDialog
	if TalentsSelect then
		T.SkinFrame(TalentsSelect)

		hooksecurefunc(TalentsSelect, "ShowDialog", function(frame)
			if not frame then return end

			for specFrame in frame.SpecContentFramePool:EnumerateActive() do
				if specFrame and not specFrame.IsSkinned then
					specFrame.ActivateButton:SkinButton()
					specFrame.ApplyChangesButton:SkinButton()

					specFrame.IsSkinned = true
				end
			end
		end)
	end

	-- PvP
	local pvpTalent = PlayerSpellsFrame.TalentsFrame.PvPTalentList
	pvpTalent:StripTextures()
	pvpTalent:CreateBackdrop("Overlay")
	pvpTalent.backdrop:SetPoint("TOPLEFT", -5, 1)
	pvpTalent.backdrop:SetPoint("BOTTOMRIGHT", -3, 0)
	pvpTalent.backdrop:SetFrameStrata(pvpTalent:GetFrameStrata())
	pvpTalent.backdrop:SetFrameLevel(2000)

	hooksecurefunc(pvpTalent.ScrollBox, "Update", function(frame)
		for _, button in next, {frame.ScrollTarget:GetChildren()} do
			if not button.isSkinned then
				button.Selected:SetTexture(nil)
				button.SelectedOtherCheck:SetTexture(nil)
				button.Border:SetAlpha(0)

				button.Icon:SkinIcon()
				button.Icon:SetSize(30, 30)
				button.Icon:ClearAllPoints()
				button.Icon:SetPoint("LEFT", button, "LEFT", 4, 0)

				button.isSkinned = true
			end
		end
	end)

	-- Spec tab
	PlayerSpellsFrame.SpecFrame:CreateBackdrop("Overlay")
	PlayerSpellsFrame.SpecFrame.backdrop:SetPoint("TOPLEFT", 2, -3)
	PlayerSpellsFrame.SpecFrame.backdrop:SetPoint("BOTTOMRIGHT", -2, 1)
	PlayerSpellsFrame.SpecFrame.backdrop.overlay:SetVertexColor(0.13, 0.13, 0.13, 1)
	PlayerSpellsFrame.SpecFrame.Background:SetAlpha(0)
	PlayerSpellsFrame.SpecFrame.BlackBG:SetAlpha(0)

	hooksecurefunc(PlayerSpellsFrame.SpecFrame, "UpdateSpecFrame", function(frame)
		for specContentFrame in frame.SpecContentFramePool:EnumerateActive() do
			if not specContentFrame.isSkinned then
				specContentFrame.SpecImage.b = CreateFrame("Frame", nil, specContentFrame)
				specContentFrame.SpecImage.b:SetFrameLevel(specContentFrame:GetFrameLevel() - 1)
				specContentFrame.SpecImage.b:SetTemplate("Default")
				specContentFrame.SpecImage.b:SetOutside(specContentFrame.SpecImage)

				specContentFrame.SpecImageBorderOn:SetAlpha(0)
				specContentFrame.SpecImageBorderOff:SetAlpha(0)
				specContentFrame.HoverSpecImageBorder:SetAlpha(0)

				specContentFrame.ActivateButton:SkinButton()

				if specContentFrame.SpellButtonPool then
					for button in specContentFrame.SpellButtonPool:EnumerateActive() do
						if button.Ring then
							button.Ring:Hide()
						end

						if button.spellID then
							local texture = C_Spell.GetSpellTexture(button.spellID)
							if texture then
								button.Icon:SetTexture(texture)
							end
						end

						button.Icon:SkinIcon()
					end
				end

				specContentFrame.isSkinned = true
			end

			if specContentFrame.SpecImageBorderOn:IsShown() then
				specContentFrame.SpecImage.b:SetBackdropBorderColor(1, 1, 0)
			else
				specContentFrame.SpecImage.b:SetBackdropBorderColor(unpack(C.media.border_color))
			end
		end
	end)

	-- SpellBook
	local page = PlayerSpellsFrame.SpellBookFrame
	page.TopBar:SetAlpha(0)

	page.HelpPlateButton.Ring:Hide()
	page.HelpPlateButton:SetPoint("TOPLEFT", page, "TOPLEFT", -10, 37)

	for _, tab in next, {page.CategoryTabSystem:GetChildren()} do
		T.SkinTab(tab, true)
		tab.backdrop:SetPoint("TOPLEFT", 2, -5)
		tab.backdrop:SetPoint("BOTTOMRIGHT", -2, 0)
	end

	T.SkinEditBox(page.SearchBox, 250, 22)
	page.SearchPreviewContainer:StripTextures()
	page.SearchPreviewContainer:CreateBackdrop("Transparent")
	T.SkinCheckBox(page.HidePassivesCheckButton.Button)

	T.SkinMaxMinFrame(PlayerSpellsFrame.MaxMinButtonFrame, PlayerSpellsFrameCloseButton)

	T.SkinNextPrevButton(page.PagedSpellsFrame.PagingControls.PrevPageButton)
	T.SkinNextPrevButton(page.PagedSpellsFrame.PagingControls.NextPageButton)

	page.PagedSpellsFrame.PagingControls.PageText:SetTextColor(0.6, 0.6, 0.6)

	page:DisableDrawLayer("BACKGROUND")
	hooksecurefunc(page.PagedSpellsFrame, "DisplayViewsForCurrentPage", function(self)
		for _, frame in self:EnumerateFrames() do
			if not frame.styled then
				if frame.Button then
					frame.Button.Border:Hide()

					frame.Button.ActionBarHighlight:SetColorTexture(1, 0.82, 0, 0.3)
					frame.Button.ActionBarHighlight:SetPoint("TOPLEFT", 2, -2)
					frame.Button.ActionBarHighlight:SetPoint("BOTTOMRIGHT", -2, 2)
					hooksecurefunc(frame.Button.ActionBarHighlight, "Show", function()
						frame.Button.ActionBarHighlight:SetColorTexture(1, 0.82, 0, 0.3)
						frame.Button.ActionBarHighlight:SetPoint("TOPLEFT", 2, -2)
						frame.Button.ActionBarHighlight:SetPoint("BOTTOMRIGHT", -2, 2)
						if frame.Button.backdrop then
							frame.Button.backdrop:SetBackdropBorderColor(1, 0.82, 0)
						end
					end)

					hooksecurefunc(frame.Button.ActionBarHighlight, "Hide", function()
						if frame.Button.backdrop then
							frame.Button.backdrop:SetBackdropBorderColor(unpack(C.media.border_color))
						end
					end)

					frame.Button.IconMask:Hide()
					hooksecurefunc(frame.Button.IconMask, "Show", function()
						frame.Button.IconMask:Hide()
					end)

					if frame.Button.Cooldown then
						frame.Button.Cooldown:SetPoint("TOPLEFT", 2, -2)
						frame.Button.Cooldown:SetPoint("BOTTOMRIGHT", -2, 2)
					end

					if frame.Button.AutoCastOverlay then
						frame.Button.AutoCastOverlay.Corners:ClearAllPoints()
						frame.Button.AutoCastOverlay.Corners:SetPoint("TOPLEFT", frame.Button.Icon, "TOPLEFT", -3, 3)
						frame.Button.AutoCastOverlay.Corners:SetPoint("BOTTOMRIGHT", frame.Button.Icon, "BOTTOMRIGHT", 3, -3)
						frame.Button.AutoCastOverlay.Corners:SetAtlas("UI-HUD-ActionBar-PetAutoCast-Corners")
					end

					frame.Button.BorderSheen:Hide()
					hooksecurefunc(frame.Button.BorderSheen, "Show", function()
						frame.Button.BorderSheen:Hide()
					end)

					frame.Button.Icon:SkinIcon()
					frame.Button.Icon:StyleButton()

					if frame.Button.ActionBarHighlight:IsShown() then
						frame.Button.backdrop:SetBackdropBorderColor(1, 0.82, 0)
					else
						frame.Button.backdrop:SetBackdropBorderColor(unpack(C.media.border_color))
					end
				end
				if frame.Text then
					frame.Text:SetTextColor(1, 0.8, 0)
				end
				if frame.Name then
					frame.Name:SetTextColor(1, 1, 1)
				end
				if frame.SubName then
					frame.SubName:SetTextColor(0.6, 0.6, 0.6)
				end
				if frame.Backplate then frame.Backplate:Hide() end
				if frame.Border then frame.Border:Hide() end

				frame.styled = true
			end
		end
	end)

	-- Clique skin
	C_Timer.After(0.1, function()
		if CliqueSpellbookTabButton then
			CliqueSpellbookTabButton:GetRegions():SetSize(0.1, 0.1)
			CliqueSpellbookTabButton:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
			CliqueSpellbookTabButton:GetNormalTexture():ClearAllPoints()
			CliqueSpellbookTabButton:GetNormalTexture():SetPoint("TOPLEFT", 2, -2)
			CliqueSpellbookTabButton:GetNormalTexture():SetPoint("BOTTOMRIGHT", -2, 2)
			CliqueSpellbookTabButton:CreateBackdrop("Default")
			CliqueSpellbookTabButton.backdrop:SetAllPoints()
			CliqueSpellbookTabButton:StyleButton(true)
		end
	end)
end

T.SkinFuncs["Blizzard_PlayerSpells"] = LoadSkin
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

	-- Spec tab
	PlayerSpellsFrame.SpecFrame:CreateBackdrop("Overlay")
	PlayerSpellsFrame.SpecFrame.backdrop:SetPoint("TOPLEFT", 4, -4)
	PlayerSpellsFrame.SpecFrame.backdrop:SetPoint("BOTTOMRIGHT", -4, 4)
	PlayerSpellsFrame.SpecFrame.backdrop.overlay:SetVertexColor(0.13, 0.13, 0.13, 1)
	PlayerSpellsFrame.SpecFrame.Background:SetAlpha(0)
	PlayerSpellsFrame.SpecFrame.BlackBG:SetAlpha(0)
	hooksecurefunc(PlayerSpellsFrame.SpecFrame, "UpdateSpecFrame", function(frame)
		for specContentFrame in frame.SpecContentFramePool:EnumerateActive() do
			if not specContentFrame.isSkinned then
				specContentFrame.ActivateButton:SkinButton()

				if specContentFrame.SpellButtonPool then
					for button in specContentFrame.SpellButtonPool:EnumerateActive() do
						if button.Ring then
							button.Ring:Hide()
						end

						if button.spellID then
							local texture = GetSpellTexture(button.spellID)
							if texture then
								button.Icon:SetTexture(texture)
							end
						end

						button.Icon:SkinIcon()
					end
				end

				specContentFrame.isSkinned = true
			end
		end
	end)

	-- PvP
	PlayerSpellsFrame.TalentsFrame.PvPTalentList:StripTextures()
	PlayerSpellsFrame.TalentsFrame.PvPTalentList:CreateBackdrop("Overlay")
	PlayerSpellsFrame.TalentsFrame.PvPTalentList.backdrop:SetFrameStrata(PlayerSpellsFrame.TalentsFrame.PvPTalentList:GetFrameStrata())
	PlayerSpellsFrame.TalentsFrame.PvPTalentList.backdrop:SetFrameLevel(2000)

	-- SpellBook
	PlayerSpellsFrame.SpellBookFrame.TopBar:SetAlpha(0)

	for _, tab in next, {PlayerSpellsFrame.SpellBookFrame.CategoryTabSystem:GetChildren()} do
		T.SkinTab(tab, true)
	end

	T.SkinEditBox(PlayerSpellsFrame.SpellBookFrame.SearchBox, 250, 22)
	T.SkinCheckBox(PlayerSpellsFrame.SpellBookFrame.HidePassivesCheckButton.Button)

	T.SkinMaxMinFrame(PlayerSpellsFrame.MaxMinButtonFrame, PlayerSpellsFrameCloseButton)

	T.SkinNextPrevButton(PlayerSpellsFrame.SpellBookFrame.PagedSpellsFrame.PagingControls.PrevPageButton)
	T.SkinNextPrevButton(PlayerSpellsFrame.SpellBookFrame.PagedSpellsFrame.PagingControls.NextPageButton )

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

local LoadTootlipSkin = CreateFrame("Frame")
LoadTootlipSkin:RegisterEvent("ADDON_LOADED")
LoadTootlipSkin:SetScript("OnEvent", function(self, _, addon)
	if IsAddOnLoaded("Skinner") or IsAddOnLoaded("Aurora")  then
		self:UnregisterEvent("ADDON_LOADED")
		return
	end

	if addon == "Blizzard_PlayerSpells" then
		LoadSkin()
	end
end)
local T, C, L = unpack(ShestakUI)
if C.skins.blizzard_frames ~= true then return end

----------------------------------------------------------------------------------------
--	DressUp skin
----------------------------------------------------------------------------------------
local function LoadSkin()
	DressUpFrame:StripTextures()
	DressUpFrame:SetTemplate("Transparent")
	DressUpFramePortrait:Hide()
	DressUpFrameInset:Hide()

	DressUpFrame.ModelScene:CreateBackdrop("Default")
	DressUpFrame.ModelScene.backdrop:SetPoint("TOPLEFT", -3, 4)
	DressUpFrame.ModelScene.backdrop:SetPoint("BOTTOMRIGHT", 2, 1)
	DressUpFrame.ModelBackground:SetDrawLayer("BACKGROUND", 3)
	T.SkinModelControl(DressUpFrame.ModelScene)

	T.SkinMaxMinFrame(DressUpFrame.MaximizeMinimizeFrame, DressUpFrameCloseButton)

	DressUpFrameCancelButton:SkinButton()
	DressUpFrameResetButton:SkinButton()
	DressUpFrameResetButton:SetPoint("RIGHT", DressUpFrameCancelButton, "LEFT", -2, 0)
	if DressUpFrameUndressButton then
		DressUpFrameUndressButton:SkinButton()
	end

	local SetSelection = DressUpFrame.SetSelectionPanel
	if SetSelection then
		SetSelection:StripTextures()
		SetSelection:CreateBackdrop("Transparent")
		SetSelection.backdrop:SetPoint("TOPLEFT", 8, 0)
		SetSelection.backdrop:SetPoint("BOTTOMRIGHT", 0, 0)
		T.SkinScrollBar(SetSelection.ScrollBar)

		hooksecurefunc(SetSelection.ScrollBox, "Update", function(self)
			self:ForEachFrame(function(button)
				if not button.IsSkinned then
					button.Icon:SkinIcon()
					T.SkinIconBorder(button.IconBorder, button.Icon:GetParent().backdrop)
					button.BackgroundTexture:SetAlpha(0)
					button.SelectedTexture:SetColorTexture(1, 0.82, 0, 0.2)
					button.HighlightTexture:SetColorTexture(1, 1, 1, 0.2)

					button.IsSkinned = true
				end
			end)
		end)
	end

	local button = T.newPatch and DressUpFrame.ToggleCustomSetDetailsButton or DressUpFrame.ToggleOutfitDetailsButton
	button:SetNormalTexture(134331)
	button:SetPushedTexture(134331)
	button:StyleButton(true)
	button:SetTemplate("Default")
	button:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
	button:GetNormalTexture():SetInside()
	button:GetPushedTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
	button:GetPushedTexture():SetInside()

	local panel = T.newPatch and DressUpFrame.CustomSetDetailsPanel or DressUpFrame.OutfitDetailsPanel
	panel:StripTextures()
	panel:CreateBackdrop("Transparent")
	panel.backdrop:SetPoint("TOPLEFT", 10, 0)
	panel.backdrop:SetPoint("BOTTOMRIGHT", 0, 0)

	hooksecurefunc(panel, "Refresh", function(self)
		if self.slotPool then
			for slot in self.slotPool:EnumerateActive() do
				if not slot.skinned then
					slot.Icon:SkinIcon()
					slot.IconBorder:SetAlpha(0)
					slot.skinned = true
				end
				local point, relativeTo, relativePoint, xOfs, yOfs = slot:GetPoint()
				if yOfs == 0 then
					slot:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs - 3)
				end
			end
		end
	end)

	DressUpFrame.LinkButton:SkinButton()
	DressUpFrame.LinkButton:SetPoint("BOTTOMLEFT", 4, 4)

	local dropdown = T.newPatch and DressUpFrameCustomSetDropdown or DressUpFrameOutfitDropdown
	T.SkinDropDownBox(dropdown, 195, 21)
	dropdown.SaveButton:SkinButton()
	dropdown.SaveButton:ClearAllPoints()
	dropdown.SaveButton:SetPoint("RIGHT", dropdown, 91, 0)

	T.SkinCloseButton(DressUpFrameCloseButton, DressUpFrame.backdrop)

	SideDressUpFrame:StripTextures()
	SideDressUpFrame:SetTemplate("Transparent")
	SideDressUpFrame.ResetButton:SkinButton()
	SideDressUpFrame.BGTopLeft:SetPoint("TOPLEFT", 2, -2)
	SideDressUpFrame.BGTopLeft:SetSize(183, 292)
	SideDressUpFrame.BGBottomLeft:SetSize(183, 93)
	T.SkinCloseButton(SideDressUpFrameCloseButton, SideDressUpFrame)

	if not T.newPatch then
		WardrobeOutfitEditFrame:StripTextures(true)
		WardrobeOutfitEditFrame:SetTemplate("Transparent")
		WardrobeOutfitEditFrame.AcceptButton:SkinButton()
		WardrobeOutfitEditFrame.CancelButton:SkinButton()
		WardrobeOutfitEditFrame.DeleteButton:SkinButton()
		T.SkinEditBox(WardrobeOutfitEditFrame.EditBox, 250, 25)
	end
end

tinsert(T.SkinFuncs["ShestakUI"], LoadSkin)
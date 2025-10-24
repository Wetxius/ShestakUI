local T, C, L = unpack(ShestakUI)
if C.skins.blizzard_frames ~= true then return end

----------------------------------------------------------------------------------------
--	WorldMap skin
----------------------------------------------------------------------------------------
local function LoadSkin()
	if C_AddOns.IsAddOnLoaded("Mapster") then return end

	local frame = CreateFrame("Frame")
	frame:RegisterEvent("VARIABLES_LOADED")
	frame:SetScript("OnEvent", function()
		SetCVar("miniWorldMap", 1)
	end)

	WorldMapFrame:StripTextures()
	WorldMapFramePortrait:SetAlpha(0)
	WorldMapFrame:CreateBackdrop("Default")
	WorldMapFrame.backdrop:ClearAllPoints()
	WorldMapFrame.backdrop:SetPoint("TOPLEFT", 1, -66)
	WorldMapFrame.backdrop:SetSize(700, 468)
	WorldMapFrame.Header = CreateFrame("Frame", nil, WorldMapFrame)
	WorldMapFrame.Header:SetSize(WorldMapFrame.backdrop:GetWidth(), 23)
	WorldMapFrame.Header:SetPoint("BOTTOMLEFT", WorldMapFrame.backdrop, "TOPLEFT", 0, 2)
	WorldMapFrame.Header:SetTemplate("Overlay")

	WorldMapFrame.BorderFrame:StripTextures()
	WorldMapFrame.BorderFrame.NineSlice:Hide()
	WorldMapFrame.BorderFrame.Tutorial:Kill()

	QuestMapFrame:StripTextures()
	QuestMapFrame:CreateBackdrop("Overlay")
	QuestMapFrame.backdrop:ClearAllPoints()
	QuestMapFrame.backdrop:SetPoint("LEFT", WorldMapFrame.backdrop, "RIGHT", 2, 0)
	QuestMapFrame.backdrop:SetSize(326, 468)

	QuestScrollFrame.SettingsDropdown:ClearAllPoints()
	QuestScrollFrame.SettingsDropdown:SetPoint("TOPRIGHT", QuestMapFrameBackdrop, "TOPRIGHT", -5, -3)

	QuestScrollFrame:ClearAllPoints()
	QuestScrollFrame:SetPoint("TOPLEFT", QuestMapFrame.backdrop, "TOPLEFT", 0, -3)
	QuestScrollFrame:SetPoint("BOTTOMRIGHT", QuestMapFrame.backdrop, "BOTTOMRIGHT", 4, 0)

	QuestScrollFrame.Contents.Separator.Divider:Hide()
	QuestScrollFrame.Edge:Hide()
	QuestScrollFrame.Background:Hide()

	QuestScrollFrame.SearchBox:DisableDrawLayer("BACKGROUND")

	do
		local frame = QuestScrollFrame.Contents.StoryHeader
		frame:CreateBackdrop("Overlay")
		frame.backdrop:SetPoint("TOPLEFT", 6, -9)
		frame.backdrop:SetPoint("BOTTOMRIGHT", -6, 11)
		frame.HighlightTexture:SetAlpha(0)
		frame.Background:SetAlpha(0)
		frame.Divider:SetAlpha(0)
		frame.backdrop.overlay:SetVertexColor(1, 1, 1, 0.2)
	end

	QuestScrollFrame.ScrollBar:SetPoint("TOPLEFT", QuestScrollFrame, "TOPRIGHT", -21, -18)
	QuestScrollFrame.ScrollBar:SetPoint("BOTTOMLEFT", QuestScrollFrame, "BOTTOMRIGHT", -21, 15)

	T.SkinScrollBar(QuestScrollFrame.ScrollBar)

	local QuestScrollFrameTopBorder = CreateFrame("Frame", "$parentBorder", QuestScrollFrame)
	QuestScrollFrameTopBorder:CreateBackdrop("Overlay")
	QuestScrollFrameTopBorder.backdrop:ClearAllPoints()
	QuestScrollFrameTopBorder.backdrop:SetSize(326, 23)
	QuestScrollFrameTopBorder.backdrop:SetPoint("LEFT", WorldMapFrame.Header, "RIGHT", 2, 0)

	QuestMapFrame.DetailsFrame:ClearAllPoints()
	QuestMapFrame.DetailsFrame:SetPoint("TOPRIGHT", QuestMapFrame, "TOPRIGHT", -12, -1)
	QuestMapDetailsScrollFrame.ScrollBar:SetPoint("TOPLEFT", QuestMapDetailsScrollFrame, "TOPRIGHT", 1, -26)
	QuestMapDetailsScrollFrame.ScrollBar:SetPoint("BOTTOMLEFT", QuestMapDetailsScrollFrame, "BOTTOMLEFT", 13, 27)
	T.SkinScrollBar(QuestMapDetailsScrollFrame.ScrollBar)

	QuestScrollFrame.BorderFrame:StripTextures()

	QuestMapDetailsScrollFrame:SetHeight(340)
	QuestMapDetailsScrollFrame:SetPoint("TOPLEFT", QuestMapFrame.DetailsFrame, "TOPLEFT", 1, -35)

	QuestMapFrame.DetailsFrame:StripTextures()
	QuestMapFrame.DetailsFrame.RewardsFrameContainer.RewardsFrame:StripTextures()
	QuestMapFrame.DetailsFrame.Bg:Hide()

	QuestMapFrame.DetailsFrame.BackFrame:StripTextures()
	QuestMapFrame.DetailsFrame.BackFrame.BackButton:SkinButton()
	QuestMapFrame.DetailsFrame.BackFrame.BackButton:ClearAllPoints()
	QuestMapFrame.DetailsFrame.BackFrame.BackButton:SetPoint("LEFT", WorldMapFrame.Header, "RIGHT", 2, 0)
	QuestMapFrame.DetailsFrame.BackFrame.BackButton:SetSize(326, 23)

	local accountComplete = QuestMapFrame.QuestsFrame.DetailsFrame.BackFrame.AccountCompletedNotice
	accountComplete:ClearAllPoints()
	accountComplete:SetPoint("RIGHT", QuestMapFrame.QuestsFrame.DetailsFrame.BackFrame.BackButton, "RIGHT", -10, 0)
	accountComplete.AccountCompletedIcon:SetSize(28, 28)
	accountComplete.AccountCompletedIcon:ClearAllPoints()
	accountComplete.AccountCompletedIcon:SetPoint("RIGHT", accountComplete.Text, "LEFT", -1, 0)

	local AbandonButton = QuestMapFrame.DetailsFrame.AbandonButton
	AbandonButton:SkinButton()
	AbandonButton:ClearAllPoints()
	AbandonButton:SetPoint("BOTTOMLEFT", QuestMapFrame.backdrop, "BOTTOMLEFT", 4, 4)

	local TrackButton = QuestMapFrame.DetailsFrame.TrackButton
	TrackButton:SkinButton()
	TrackButton:SetSize(90, 22)
	TrackButton:ClearAllPoints()
	TrackButton:SetPoint("BOTTOMRIGHT", QuestMapFrame.backdrop, "BOTTOMRIGHT", -4, 4)

	local ShareButton = QuestMapFrame.DetailsFrame.ShareButton
	ShareButton:SkinButton(true)
	ShareButton:ClearAllPoints()
	ShareButton:SetPoint("LEFT", AbandonButton, "RIGHT", 3, 0)
	ShareButton:SetPoint("RIGHT", TrackButton, "LEFT", -3, 0)

	-- Quests Buttons
	for i = 1, 2 do
		local button = i == 1 and WorldMapFrame.SidePanelToggle.CloseButton or WorldMapFrame.SidePanelToggle.OpenButton
		local texture = i == 1 and "Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up" or "Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up"

		button:ClearAllPoints()
		button:SetPoint("BOTTOMRIGHT", -2, 2)
		button:SetSize(20, 20)
		button:StripTextures()
		button:SetTemplate("Default")
		button:StyleButton()

		button.icon = button:CreateTexture(nil, "BORDER")
		button.icon:SetTexture(texture)
		button.icon:SetTexCoord(0.3, 0.29, 0.3, 0.79, 0.65, 0.29, 0.65, 0.79)
		button.icon:ClearAllPoints()
		button.icon:SetPoint("TOPLEFT", 2, -2)
		button.icon:SetPoint("BOTTOMRIGHT", -2, 2)
	end

	WorldMapFrame.NavBar:Hide()
	WorldMapFrame.BorderFrame.TitleContainer.TitleText:ClearAllPoints()
	WorldMapFrame.BorderFrame.TitleContainer.TitleText:SetPoint("CENTER", WorldMapFrame.Header)

	T.SkinCloseButton(WorldMapFrameCloseButton)
	WorldMapFrameCloseButton:ClearAllPoints()
	WorldMapFrameCloseButton:SetPoint("RIGHT", WorldMapFrame.Header, "RIGHT", -4, 0)
	WorldMapFrameCloseButton:SetSize(15, 15)

	WorldMapFrame.BorderFrame.MaximizeMinimizeFrame.MaximizeButton:Kill()
	WorldMapFrame.BorderFrame.MaximizeMinimizeFrame.MinimizeButton:Kill()

	-- Floor Dropdown
	local function WorldMapFloorNavigationDropDown(frame)
		T.SkinDropDownBox(frame)
		frame:SetPoint("TOPLEFT", 6, -68)
	end

	-- Tracking Button
	local function WorldMapTrackingOptionsButton(button)
		local shadow = button:GetRegions()
		shadow:Hide()

		button.Background:Hide()
		button.Border:Hide()

		T.SkinCloseButton(button.ResetButton, nil, nil, true)
		button.ResetButton:SetSize(15, 15)
		button.ResetButton:ClearAllPoints()
		button.ResetButton:SetPoint("CENTER", button, "TOPRIGHT", -4, -4)

		local tex = button:GetHighlightTexture()
		tex:SetAtlas("Map-Filter-Button")
		tex:SetAllPoints(button.Icon)
	end

	-- Tracking Pin
	local function WorldMapTrackingPinButton(button)
		local shadow = button:GetRegions()
		shadow:Hide()

		button.Background:Hide()
		button.IconOverlay:SetAlpha(0)
		button.Border:Hide()

		local tex = button:GetHighlightTexture()
		tex:SetAtlas("Waypoint-MapPin-Untracked")
		tex:SetAllPoints(button.Icon)
	end

	-- HandyNotes
	local function HandyNotesButton(button)
		local shadow = button:GetRegions()
		shadow:Hide()

		button.Background:Hide()
		if button.IconOverlay then button.IconOverlay:SetAlpha(0) end
		button.Border:Hide()

		local tex = button:GetHighlightTexture()
		tex:SetAtlas(button.Icon:GetTexture())
		tex:SetAllPoints(button.Icon)
	end

	-- Elements
	WorldMapFloorNavigationDropDown(WorldMapFrame.overlayFrames[1])
	WorldMapTrackingOptionsButton(WorldMapFrame.overlayFrames[2])
	WorldMapTrackingPinButton(WorldMapFrame.overlayFrames[3])

	for i = 1, 15 do
		local button = _G["Krowi_WorldMapButtons"..i]
		if button then
			HandyNotesButton(button)
		end
	end

	for i = 3, #WorldMapFrame.overlayFrames do
		local frame = WorldMapFrame.overlayFrames[i]
		if frame.BountyDropdown then
			T.SkinNextPrevButton(frame.BountyDropdown)
			break
		end
	end

	local tabs = {
		QuestMapFrame.QuestsTab,
		QuestMapFrame.MapLegendTab,
		QuestMapFrame.EventsTab,
	}
	for _, tab in pairs(tabs) do
		tab.Background:SetAlpha(0)

		tab:SetSize(34, 44)

		tab:CreateBackdrop("Overlay")
		tab.backdrop:SetPoint("TOPLEFT", 2, -2)
		tab.backdrop:SetPoint("BOTTOMRIGHT", -2, 2)

		tab.SelectedTexture:SetDrawLayer("ARTWORK")
		tab.SelectedTexture:ClearAllPoints()
		tab.SelectedTexture:SetPoint("TOPLEFT", 4, -4)
		tab.SelectedTexture:SetPoint("BOTTOMRIGHT", -4, 4)
		tab.SelectedTexture:SetColorTexture(1, 0.82, 0, 0.3)

		-- Hover texture
		for _, region in next, {tab:GetRegions()} do
			if region:IsObjectType("Texture") then
				if region:GetAtlas() == "QuestLog-Tab-side-Glow-hover" then
					region:SetPoint("TOPLEFT", 4, -4)
					region:SetPoint("BOTTOMRIGHT", -4, 4)
					region:SetColorTexture(1, 1, 1, 0.3)
				end
			end
		end
	end

	QuestMapFrame.QuestsTab:ClearAllPoints()
	QuestMapFrame.QuestsTab:SetPoint("TOPLEFT", QuestMapFrame.backdrop, "TOPRIGHT", 1, 2)

	-- Map Legend frame
	do
		QuestMapFrame.MapLegend.BorderFrame:StripTextures()
		MapLegendScrollFrame.Background:Hide()

		MapLegendScrollFrame:ClearAllPoints()
		MapLegendScrollFrame:SetPoint("TOPLEFT", QuestMapFrame.backdrop, "TOPLEFT", 0, -3)
		MapLegendScrollFrame:SetPoint("BOTTOMRIGHT", QuestMapFrame.backdrop, "BOTTOMRIGHT", 4, 0)

		local MapLegendTopBorder = CreateFrame("Frame", "$parentBorder", QuestMapFrame.MapLegend)
		MapLegendTopBorder:CreateBackdrop("Overlay")
		MapLegendTopBorder.backdrop:ClearAllPoints()
		MapLegendTopBorder.backdrop:SetSize(326, 23)
		MapLegendTopBorder.backdrop:SetPoint("LEFT", WorldMapFrame.Header, "RIGHT", 2, 0)

		QuestMapFrame.MapLegend.TitleText:ClearAllPoints()
		QuestMapFrame.MapLegend.TitleText:SetPoint("CENTER", MapLegendTopBorder.backdrop)

		MapLegendScrollFrame.ScrollBar:SetPoint("TOPLEFT", MapLegendScrollFrame, "TOPRIGHT", -21, -18)
		MapLegendScrollFrame.ScrollBar:SetPoint("BOTTOMLEFT", MapLegendScrollFrame, "BOTTOMRIGHT", -21, 15)

		T.SkinScrollBar(MapLegendScrollFrame.ScrollBar)
	end

	-- Events frame
	do
		QuestMapFrame.EventsFrame.BorderFrame:StripTextures()
		QuestMapFrame.EventsFrame.ScrollBox.Background:SetAlpha(0)

		for _, region in next, {QuestMapFrame.EventsFrame:GetRegions()} do
			if region:IsObjectType("Texture") then
				region:Hide() -- remove yellow texture
				break
			end
		end

		QuestMapFrame.EventsFrame.ScrollBox:ClearAllPoints()
		QuestMapFrame.EventsFrame.ScrollBox:SetPoint("TOPLEFT", QuestMapFrame.backdrop, "TOPLEFT", 0, -3)
		QuestMapFrame.EventsFrame.ScrollBox:SetPoint("BOTTOMRIGHT", QuestMapFrame.backdrop, "BOTTOMRIGHT", 4, 0)

		local EventsFrameTopBorder = CreateFrame("Frame", "$parentBorder", QuestMapFrame.EventsFrame)
		EventsFrameTopBorder:CreateBackdrop("Overlay")
		EventsFrameTopBorder.backdrop:ClearAllPoints()
		EventsFrameTopBorder.backdrop:SetSize(326, 23)
		EventsFrameTopBorder.backdrop:SetPoint("LEFT", WorldMapFrame.Header, "RIGHT", 2, 0)

		QuestMapFrame.EventsFrame.TitleText:ClearAllPoints()
		QuestMapFrame.EventsFrame.TitleText:SetPoint("CENTER", EventsFrameTopBorder.backdrop)

		QuestMapFrame.EventsFrame.ScrollBar:SetPoint("TOPLEFT", QuestMapFrame.EventsFrame.ScrollBox , "TOPRIGHT", -21, -18)
		QuestMapFrame.EventsFrame.ScrollBar:SetPoint("BOTTOMLEFT", QuestMapFrame.EventsFrame.ScrollBox , "BOTTOMRIGHT", -21, 15)

		T.SkinScrollBar(QuestMapFrame.EventsFrame.ScrollBar)

		-- _G.ScrollUtil.AddAcquiredFrameCallback(QuestMapFrame.EventsFrame.EventsFrame.ScrollBox, EventsFrameCallback, QuestMapFrame.EventsFrame, true) -- need to skin elements. FIXME need to test and make skin
	end

	-- C_PlayerInfo.CanPlayerUseEventScheduler = function() return true end -- Test events tab

	-- QuestSessionManagement skin (based on skin from Aurora)
	QuestMapFrame.QuestSessionManagement:StripTextures()

	local ExecuteSessionCommand = QuestMapFrame.QuestSessionManagement.ExecuteSessionCommand
	ExecuteSessionCommand:SetTemplate("Default")
	ExecuteSessionCommand:StyleButton()

	local icon = ExecuteSessionCommand:CreateTexture(nil, "ARTWORK")
	icon:SetPoint("TOPLEFT", 0, 0)
	icon:SetPoint("BOTTOMRIGHT", 0, 0)
	ExecuteSessionCommand.normalIcon = icon

	local sessionCommandToButtonAtlas = { -- Skin from Aurora
		[_G.Enum.QuestSessionCommand.Start] = "QuestSharing-DialogIcon",
		[_G.Enum.QuestSessionCommand.Stop] = "QuestSharing-Stop-DialogIcon"
	}

	hooksecurefunc(QuestMapFrame.QuestSessionManagement, "UpdateExecuteCommandAtlases", function(self, command)
		self.ExecuteSessionCommand:SetNormalTexture(0)
		self.ExecuteSessionCommand:SetPushedTexture(0)
		self.ExecuteSessionCommand:SetDisabledTexture(0)

		local atlas = sessionCommandToButtonAtlas[command]
		if atlas then
			self.ExecuteSessionCommand.normalIcon:SetAtlas(atlas)
		end
	end)

	hooksecurefunc(QuestSessionManager, "NotifyDialogShow", function(_, dialog)
		if not dialog.isSkinned then
			dialog:StripTextures()
			dialog:SetTemplate("Transparent")
			dialog.ButtonContainer.Confirm:SkinButton()
			dialog.ButtonContainer.Decline:SkinButton()
			if dialog.MinimizeButton then
				T.SkinCloseButton(dialog.MinimizeButton, nil, "-")
			end
			dialog.isSkinned = true
		end
	end)
end

tinsert(T.SkinFuncs["ShestakUI"], LoadSkin)
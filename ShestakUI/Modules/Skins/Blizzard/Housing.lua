local T, C, L = unpack(ShestakUI)
if C.skins.blizzard_frames ~= true then return end

----------------------------------------------------------------------------------------
--	Housing skin
----------------------------------------------------------------------------------------
local function LoadSkin()
	local frame = _G.HousingDashboardFrame
	T.SkinFrame(frame)

	frame.HouseInfoContent.DashboardNoHousesFrame.Background:SetInside(frame.HouseInfoContent.DashboardNoHousesFrame)
	frame.HouseInfoContent.DashboardNoHousesFrame.NoHouseButton:SkinButton(nil, "Text")

	local tabs = {
		frame.HouseInfoTabButton,
		frame.CatalogTabButton,
		frame.CollectionTabButton
	}
	for _, tab in pairs(tabs) do
		tab:SetSize(34, 44)

		tab:CreateBackdrop("Overlay")
		tab.backdrop:SetPoint("TOPLEFT", 2, -2)
		tab.backdrop:SetPoint("BOTTOMRIGHT", -2, 2)

		tab.Icon:SetInside(tab.backdrop)
		tab.Icon:SetTexCoord(0.18, 0.76, 0.18, 0.76)

		if tab.Background then
			tab.Background:SetAlpha(0)
		end

		if tab.SelectedTexture then
			tab.SelectedTexture:SetDrawLayer("ARTWORK")
			tab.SelectedTexture:SetColorTexture(1, 0.82, 0, 0.3)
			tab.SelectedTexture:SetInside(tab.backdrop)
		end

		if tab.HighlightTexture then
			tab.HighlightTexture:SetColorTexture(1, 1, 1, 0.3)
			tab.HighlightTexture:SetInside(tab.backdrop)
		end

		if tab.TabGlow then
			tab.TabGlow:SetAlpha(0)
		end

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

	T.SkinDropDownBox(frame.HouseDropdown.Dropdown)

	frame.HouseInfoTabButton:SetPoint("TOPLEFT", frame, "TOPRIGHT", 1, -60)

	local infoContent = frame.HouseInfoContent
	if infoContent then
		infoContent.DashboardNoHousesFrame.NoHouseButton:SkinButton()
		infoContent.HouseFinderButton:SkinButton()

		local contentFrame = infoContent.ContentFrame
		if contentFrame then
			local HouseUpgradeFrame = contentFrame.HouseUpgradeFrame
			if HouseUpgradeFrame then
				HouseUpgradeFrame:StripTextures()
				HouseUpgradeFrame.Background:Hide()
				HouseUpgradeFrame.TrackFrame.Background:Hide()
				T.SkinCheckBox(HouseUpgradeFrame.WatchFavorButton)
			end

			hooksecurefunc(contentFrame, "UpdateTabs", function(frame)
				for _, tab in next, {frame.TabSystem:GetChildren()} do
					T.SkinTab(tab, true)
					tab.backdrop:SetPoint("TOPLEFT", 0, -3)
					tab.backdrop:SetPoint("BOTTOMRIGHT", 0, 3)
				end
			end)

			hooksecurefunc(HouseUpgradeFrame, "SetRewards", function(self)
				-- TODO
				-- for reward in self.rewardPool:EnumerateActive() do
					-- if not reward.styled then
						-- reward:CreateBackdrop("Overlay")
						-- reward.backdrop:SetPoint("TOPLEFT", reward, 18, -8)
						-- reward.backdrop:SetPoint("BOTTOMRIGHT", reward, -18, 8)

						-- reward.RewardCardBG:SetAlpha(0)

						-- reward.b = CreateFrame("Frame", nil, reward)
						-- reward.b:SetTemplate("Default")
						-- reward.b:SetPoint("TOPLEFT", reward.RewardCardIcon, "TOPLEFT", -2, 2)
						-- reward.b:SetPoint("BOTTOMRIGHT", reward.RewardCardIcon, "BOTTOMRIGHT", 2, -2)
						-- reward.RewardCardIcon:SetParent(reward.b)
						-- reward.RewardCardIcon:SetTexCoord(0.15, 0.85, 0.15, 0.85)
						-- reward.styled = true
					-- end
				-- end
			end)
		end

		local initiativesFrame = contentFrame.InitiativesFrame
		if initiativesFrame then
			initiativesFrame.InitiativesArt:Hide()

			local bar = initiativesFrame.InitiativeSetFrame.ProgressBar
			bar.barBackdrop = CreateFrame("Frame", nil, bar)
			bar.barBackdrop:SetFrameLevel(bar:GetFrameLevel())
			bar.barBackdrop:SetOutside(bar)
			bar.barBackdrop:SetTemplate("Overlay")
			bar:SetStatusBarTexture(C.media.texture)
			bar:SetStatusBarColor(0, 0.6, 1)

			-- TODO
			-- hooksecurefunc(MonthlyActivitiesRewardButtonMixin, "SetRewardItem", function(self)
				-- if not self.styled then
					-- self:ClearAllPoints()
					-- self:SetPoint("LEFT", monthlyActivities.ThresholdContainer.ThresholdBar.barBackdrop, "RIGHT", -2, -3)
					-- self.Icon:SkinIcon()
					-- self.CircleMask:Hide()
					-- self.NormalTexture:SetAlpha(0)
					-- self.HighlightTexture:SetAlpha(0)
					-- self.PushedTexture:SetAlpha(0)
					-- self.styled = true
				-- end
			-- end)

			local tasks = initiativesFrame.InitiativeSetFrame.InitiativeTasks
			if tasks then
				tasks:CreateBackdrop("Overlay")
				tasks.backdrop:SetInside()
				tasks.backdrop:SetPoint("TOPLEFT", 2, 5)
				tasks.backdrop:SetPoint("BOTTOMRIGHT", -1, 2)
				tasks.TaskListTitleContainer:StripTextures()
				T.SkinScrollBar(tasks.ScrollBar)

				for _, frame in next, {
					tasks.BG,
					tasks.BorderRight,
					tasks.BorderTop,
					tasks.TitleCornerBR,
					tasks.TitleCornerTR,
					tasks.TaskListTitleContainer.TitleCornerBR,
					tasks.TaskListTitleContainer.TitleFoliage
				} do
					if frame then
						frame:Hide()
					end
				end
			end

			local activity = initiativesFrame.InitiativeSetFrame.InitiativeActivity
			if activity then
				activity:CreateBackdrop("Overlay")
				activity.backdrop:SetPoint("TOPLEFT", 3, 5)
				activity.backdrop:SetPoint("BOTTOMRIGHT", -1, 2)
				activity.ActivityLogTitleContainer:StripTextures()
				T.SkinScrollBar(activity.ScrollBar)

				for _, frame in next, {
					activity.BG,
					activity.BGTexture,
					activity.BorderTop,
					activity.TitleCornerBL,
					activity.TitleCornerTR,
					activity.ActivityLogTitleContainer.TitleCornerBL,
					activity.ActivityLogTitleContainer.TitleFoliage
				} do
					if frame then
						frame:Hide()
					end
				end
			end
		end
	end

	local content = frame.CatalogContent
	content:StripTextures()
	content.PreviewFrame:StripTextures()
	content.Categories:StripTextures()
	content.Categories.Background:SetAlpha(0)

	hooksecurefunc(content.OptionsContainer.ScrollBox, "Update", function(frame)
		for _, button in next, {frame.ScrollTarget:GetChildren()} do
			if not button.isSkinned then
				button:GetRegions():Hide()
				button:CreateBackdrop("Overlay")
				button.backdrop:SetPoint("TOPLEFT", 2, -2)
				button.backdrop:SetPoint("BOTTOMRIGHT", -2, 2)
				button:StyleButton(nil, 4)

				button.HoverBackground:SetAlpha(0)

				button.isSkinned = true
			end
		end
	end)

	T.SkinEditBox(content.SearchBox)
	content.SearchBox.backdrop:SetOutside(nil, 2, -4)
	T.SkinFilter(content.Filters.FilterDropdown, true)

	T.SkinScrollBar(content.OptionsContainer.ScrollBar)
	T.SkinScrollBar(frame.CollectionContent.BlueprintCollection.ScrollBar)

	for i = 1, 5 do
		local button = select(i, content.PreviewFrame.ModelSceneControls:GetChildren())
		if button.NormalTexture then
			button.NormalTexture:SetAlpha(0)
			button.PushedTexture:SetAlpha(0)
		end
	end
end

T.SkinFuncs["Blizzard_HousingDashboard"] = LoadSkin

local function LoadNeighborhoodSkin()
	local frame = _G.HousingCreateNeighborhoodCharterFrame
	T.SkinFrame(frame)

	T.SkinEditBox(frame.NeighborhoodNameEditBox)
	frame.ConfirmButton:SkinButton(nil, "Text")
	frame.CancelButton:SkinButton(nil, "Text")

	-- local ConfirmationFrame = frame.ConfirmationFrame
	-- ConfirmationFrame:StripTextures()
	-- ConfirmationFrame:SetTemplate()
	-- ConfirmationFrame.ConfirmButton:SkinButton()
	-- ConfirmationFrame.CancelButton:SkinButton()
end

T.SkinFuncs["Blizzard_HousingCreateNeighborhood"] = LoadNeighborhoodSkin

local function LoadModelPreviewSkin()
	local frame = _G.HousingModelPreviewFrame
	T.SkinFrame(frame)

	frame.ModelPreview:StripTextures()

	for i = 1, 5 do
		local button = select(i, frame.ModelPreview.ModelSceneControls:GetChildren())
		if button.NormalTexture then
			button.NormalTexture:SetAlpha(0)
			button.PushedTexture:SetAlpha(0)
		end
	end
end

T.SkinFuncs["Blizzard_HousingModelPreview"] = LoadModelPreviewSkin

local function LoadHouseListSkin()
	local frame = _G.HouseListFrame
	T.SkinFrame(frame)

	T.SkinScrollBar(frame.ScrollBar)
end

T.SkinFuncs["Blizzard_HouseList"] = LoadHouseListSkin

local function LoadBulletinBoard()
	local frame = _G.HousingBulletinBoardFrame
	T.SkinFrame(frame)

	frame.Background:SetAlpha(0)

	frame.ResidentsTab:StripTextures()
	frame.RosterTabButton:StripTextures()

	T.SkinScrollBar(frame.ResidentsTab.ScrollBar)
end

T.SkinFuncs["Blizzard_HousingBulletinBoard"] = LoadBulletinBoard

local function LoadHouseFinder()
	local frame = _G.HouseFinderFrame
	T.SkinFrame(frame, true)

	frame.WoodBorderFrame:Hide()

	frame.PlotInfoFrame.VisitHouseButton:SkinButton()

	local neighborList = frame.NeighborhoodListFrame
	if neighborList then
		neighborList:StripTextures()

		T.SkinEditBox(neighborList.BNetFriendSearchBox, nil, 18)
		neighborList.RefreshButton:SkinButton()
		neighborList.RefreshButton:SetSize(24, 24)
		T.SkinScrollBar(neighborList.ScrollFrame.ScrollBar)
	end
end

T.SkinFuncs["Blizzard_HousingHouseFinder"] = LoadHouseFinder

local function LoadCornerstone()
	local frame = _G.HousingCornerstoneVisitorFrame
	T.SkinFrame(frame)

	frame = _G.HousingCornerstoneHouseInfoFrame
	T.SkinFrame(frame)

	frame = _G.HousingCornerstonePurchaseFrame
	T.SkinFrame(frame)
	frame.ForSaleSign:SetPoint("TOP", 0, -3)
	frame.BuyButton:SkinButton()
	frame.MoneyFrameBackdrop.NineSlice:StripTextures()

	frame = _G.MoveHouseConfirmationDialog
	T.SkinFrame(frame)
	frame.ConfirmButton:SkinButton()
	frame.CancelButton:SkinButton()

	frame = _G.BuyHouseConfirmationDialog
	T.SkinFrame(frame)
	frame.AcceptButton:SkinButton()
	frame.CancelButton:SkinButton()
end

T.SkinFuncs["Blizzard_HousingCornerstone"] = LoadCornerstone

local function LoadHouseSettings()
	local frame = _G.HousingHouseSettingsFrame
	T.SkinFrame(frame)

	T.SkinDropDownBox(frame.HouseOwnerDropdown)

	frame.AbandonHouseButton:SkinButton()
	frame.IgnoreListButton:SkinButton()
	frame.SaveButton:SkinButton()


	frame = AbandonHouseConfirmationDialog
	T.SkinFrame(frame)
	frame.ConfirmButton:SkinButton()
	frame.CancelButton:SkinButton()
end

T.SkinFuncs["Blizzard_HousingHouseSettings"] = LoadHouseSettings

local function LoadEditor()
	local storagePanel = HouseEditorFrame.StoragePanel
	T.SkinFrame(storagePanel)

	T.SkinEditBox(storagePanel.SearchBox, nil, 18)

	T.SkinFilter(storagePanel.Filters.FilterDropdown)

	local categories = storagePanel.Categories
	if categories then
		categories.TopBorder:Hide()
		categories.Background:Hide()
	end

	for _, tab in next, {storagePanel.TabSystem:GetChildren()} do
		T.SkinTab(tab)
	end

	T.SkinScrollBar(storagePanel.OptionsContainer.ScrollBar)

	storagePanel.CollapseButton:SetMovePoint(1)
end

T.SkinFuncs["Blizzard_HouseEditor"] = LoadEditor
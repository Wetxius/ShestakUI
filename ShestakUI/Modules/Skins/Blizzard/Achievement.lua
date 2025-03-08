local T, C, L = unpack(ShestakUI)
if C.skins.blizzard_frames ~= true then return end

----------------------------------------------------------------------------------------
--	AchievementUI skin
----------------------------------------------------------------------------------------
local function LoadSkin()
	local frames = {
		"AchievementFrame",
		"AchievementFrameCategories",
		"AchievementFrameSummary",
		"AchievementFrameSummaryCategoriesHeader",
		"AchievementFrameSummaryAchievementsHeader",
		"AchievementFrameStatsBG",
		"AchievementFrameAchievements",
		"AchievementFrameComparison",
		"AchievementFrameComparisonHeader",
	}

	for _, frame in pairs(frames) do
		_G[frame]:StripTextures(true)
	end

	AchievementFrame.Header:StripTextures(true)

	select(3, _G.AchievementFrameAchievements:GetChildren()):Hide()
	_G.AchievementFrameSummary:GetChildren():Hide()

	AchievementFrame:CreateBackdrop("Transparent")
	AchievementFrame.backdrop:SetPoint("TOPLEFT", 0, 7)
	AchievementFrame.backdrop:SetPoint("BOTTOMRIGHT")
	AchievementFrame.Header.Title:ClearAllPoints()
	AchievementFrame.Header.Title:SetPoint("TOPLEFT", AchievementFrame.backdrop, "TOPLEFT", 13, -2)
	AchievementFrame.Header.Points:ClearAllPoints()
	AchievementFrame.Header.Points:SetPoint("LEFT", AchievementFrame.Header.Title, "RIGHT", -2, 0)

	-- Backdrops
	AchievementFrameCategories:CreateBackdrop("Overlay")
	AchievementFrameCategories.backdrop:SetPoint("TOPLEFT", 0, 4)
	AchievementFrameCategories.backdrop:SetPoint("BOTTOMRIGHT", -2, -3)
	AchievementFrameSummary:CreateBackdrop("Overlay")
	AchievementFrameSummary.backdrop:SetPoint("TOPLEFT", -3, 0)
	AchievementFrameSummary.backdrop:SetPoint("BOTTOMRIGHT", -3, -3)
	AchievementFrameStats:CreateBackdrop("Overlay")
	AchievementFrameStats.backdrop:SetPoint("TOPLEFT", 2, 0)
	AchievementFrameStats.backdrop:SetPoint("BOTTOMRIGHT", -2, -3)
	AchievementFrameComparison.StatContainer:CreateBackdrop("Overlay")
	AchievementFrameComparison.StatContainer.backdrop:SetPoint("TOPLEFT", 2, 0)
	AchievementFrameComparison.StatContainer.backdrop:SetPoint("BOTTOMRIGHT", 1, -3)

	T.SkinCloseButton(AchievementFrameCloseButton, AchievementFrame.backdrop)

	T.SkinFilter(AchievementFrameFilterDropdown, true)
	AchievementFrameFilterDropdown:ClearAllPoints()
	AchievementFrameFilterDropdown:SetPoint("TOPLEFT", AchievementFrameAchievements, "TOPLEFT", 5, 21)

	local frame = CreateFrame("Frame")
	frame:RegisterEvent("ADDON_LOADED")
	frame:SetScript("OnEvent", function()
		if not C_AddOns.IsAddOnLoaded("Overachiever") then return end
		AchievementFrameFilterDropdown:ClearAllPoints()
		AchievementFrameFilterDropdown:SetPoint("TOPLEFT", AchievementFrameAchievements, "TOPLEFT", -19, 24)
	end)

	T.SkinEditBox(AchievementFrame.SearchBox)
	AchievementFrame.SearchBox:SetHeight(15)
	AchievementFrame.SearchBox:ClearAllPoints()
	AchievementFrame.SearchBox:SetPoint("TOPRIGHT", AchievementFrame, "TOPRIGHT", -52, 0)

	AchievementFrame.SearchPreviewContainer:StripTextures()
	AchievementFrame.SearchPreviewContainer:CreateBackdrop("Transparent")
	AchievementFrame.SearchPreviewContainer.backdrop:SetPoint("TOPLEFT", -2, 2)
	AchievementFrame.SearchPreviewContainer.backdrop:SetPoint("BOTTOMRIGHT", AchievementFrame.SearchPreviewContainer.ShowAllSearchResults, 2, -2)

	AchievementFrame.SearchResults:StripTextures()
	AchievementFrame.SearchResults:SetTemplate("Transparent")
	T.SkinCloseButton(AchievementFrame.SearchResults.CloseButton)

	-- ScrollBars
	T.SkinScrollBar(AchievementFrameCategories.ScrollBar)
	T.SkinScrollBar(AchievementFrameAchievements.ScrollBar)
	T.SkinScrollBar(AchievementFrameStats.ScrollBar)
	T.SkinScrollBar(AchievementFrameComparison.AchievementContainer.ScrollBar)
	T.SkinScrollBar(AchievementFrameComparison.StatContainer.ScrollBar)
	T.SkinScrollBar(AchievementFrame.SearchResults.ScrollBar)

	AchievementFrameCategories.ScrollBar:SetPoint("TOPLEFT", AchievementFrameCategories, "TOPRIGHT", 8, 0)
	AchievementFrameCategories.ScrollBar:SetPoint("BOTTOMLEFT", AchievementFrameCategories, "BOTTOMRIGHT", 8, -3)

	-- Tabs
	for i = 1, 3 do
		local tab = _G["AchievementFrameTab"..i]
		if tab and not tab.isSkinned then
			T.SkinTab(tab)
			tab:SetFrameLevel(tab:GetFrameLevel() + 2)
			tab.isSkinned = true
		end
	end

	local function SkinStatusBar(bar, comparison)
		bar:StripTextures()
		bar:SetStatusBarTexture(C.media.texture)
		bar:SetStatusBarColor(0, 0.7, 0.1)
		bar:CreateBackdrop("Overlay")

		if comparison then
			local title = bar.Title
			local text = bar.Text

			if title then
				title:SetPoint("LEFT", 4, 0)
			end

			if text then
				text:SetPoint("CENTER")
			end
		else
			local title = _G[bar:GetName().."Title"]
			local label = _G[bar:GetName().."Label"]
			local text = _G[bar:GetName().."Text"]

			if title then
				title:SetPoint("LEFT", 4, 0)
			end

			if label then
				label:SetPoint("LEFT", 4, 0)
			end

			if text then
				text:SetPoint("RIGHT", -4, 0)
			end
		end
	end

	SkinStatusBar(AchievementFrameSummaryCategoriesStatusBar)
	SkinStatusBar(AchievementFrameComparison.Summary.Player.StatusBar, true)
	SkinStatusBar(AchievementFrameComparison.Summary.Friend.StatusBar, true)
	AchievementFrameComparisonHeader:SetPoint("BOTTOMRIGHT", AchievementFrameComparison, "TOPRIGHT", 39, 26)
	AchievementFrameComparisonHeader:CreateBackdrop("Transparent")
	AchievementFrameComparisonHeader.backdrop:SetPoint("TOPLEFT", 20, -20)
	AchievementFrameComparisonHeader.backdrop:SetPoint("BOTTOMRIGHT", -17, 1)

	for i = 1, 12 do
		local frame = _G["AchievementFrameSummaryCategoriesCategory"..i]
		local button = _G["AchievementFrameSummaryCategoriesCategory"..i.."Button"]
		local highlight = _G["AchievementFrameSummaryCategoriesCategory"..i.."ButtonHighlight"]

		SkinStatusBar(frame)
		button:StripTextures()
		highlight:StripTextures()

		frame.Label:SetPoint("LEFT", frame, "LEFT", 4, 0)

		_G[highlight:GetName().."Middle"]:SetColorTexture(1, 1, 1, 0.3)
		_G[highlight:GetName().."Middle"]:SetAllPoints(frame)
	end

	hooksecurefunc(_G.AchievementFrameCategories.ScrollBox, "Update", function(frame)
		for _, child in next, { frame.ScrollTarget:GetChildren() } do
			local button = child.Button
			if button and not button.IsSkinned then
				button:StripTextures()
				button.Background:Hide()
				button:StyleButton()

				button.IsSkinned = true
			end
		end
	end)

	hooksecurefunc(_G.AchievementFrameAchievements.ScrollBox, "Update", function(frame)
		for _, child in next, { frame.ScrollTarget:GetChildren() } do
			if not child.isSkinned then
				child:StripTextures(true)
				child.Background:SetAlpha(0)
				child.Highlight:SetAlpha(0)
				child.Icon.frame:Hide()
				child.Description:SetTextColor(0.6, 0.6, 0.6)
				child.Description.SetTextColor = T.dummy
				child.Description:SetShadowOffset(1, -1)
				child.Description.SetShadowOffset = T.dummy

				child:CreateBackdrop("Overlay")
				child.backdrop:SetPoint("TOPLEFT", 1, -1)
				child.backdrop:SetPoint("BOTTOMRIGHT", 0, 2)
				child.Icon.texture:SkinIcon()

				T.SkinCheckBox(child.Tracked)
				child.Tracked:SetSize(20, 20)
				child.Check:SetAlpha(0)
				child.Tracked:ClearAllPoints()
				child.Tracked:SetPoint("BOTTOMLEFT", child, "BOTTOMLEFT", 7, 2)
				child.Tracked.ClearAllPoints = T.dummy
				child.Tracked.SetPoint = T.dummy

				hooksecurefunc(child, "UpdatePlusMinusTexture", function (button)
					if button.DateCompleted:IsShown() then
						if button.accountWide then
							button.Label:SetTextColor(0.1, 0.6, 0.8)
							button.backdrop:SetBackdropBorderColor(ACHIEVEMENT_BLUE_BORDER_COLOR:GetRGB())
						else
							button.Label:SetTextColor(1, 0.82, 0)
							button.backdrop:SetBackdropBorderColor(unpack(C.media.border_color))
						end
					elseif button.accountWide then
						button.Label:SetTextColor(0.6, 0.6, 0.6)
						button.backdrop:SetBackdropBorderColor(ACHIEVEMENT_BLUE_BORDER_COLOR:GetRGB())
					else
						button.Label:SetTextColor(0.6, 0.6, 0.6)
						button.backdrop:SetBackdropBorderColor(unpack(C.media.border_color))
					end
				end)
				hooksecurefunc(child, "DisplayObjectives", function (frame)
					local objectives = frame:GetObjectiveFrame()
					if objectives and objectives.progressBars then
						for _, bar in next, objectives.progressBars do
							if not bar.isSkinned then
								bar:StripTextures()
								bar:SetStatusBarTexture(C.media.texture)
								bar:SetStatusBarColor(0, 0.7, 0.1)
								bar:CreateBackdrop("Overlay")
								bar.isSkinned = true
							end
						end
					end
				end)

				child.isSkinned = true
			end
		end
	end)

	AchievementFrame:HookScript("OnShow", function()
		for i = 3, 8 do
			local tab = _G["AchievementFrameTab"..i]
			if tab and not tab.isSkinned then
				T.SkinTab(tab)
				tab.isSkinned = true
			end
		end
		AchievementFrameTab1:SetPoint("TOPLEFT", AchievementFrame, "BOTTOMLEFT", 17, 2)
	end)

	hooksecurefunc("AchievementFrameSummary_UpdateAchievements", function()
		for i = 1, ACHIEVEMENTUI_MAX_SUMMARY_ACHIEVEMENTS do
			local frame = _G["AchievementFrameSummaryAchievement"..i]
			frame:StripTextures()
			frame.Highlight:SetAlpha(0)

			frame.Description:SetTextColor(0.6, 0.6, 0.6)
			frame.Description:SetShadowOffset(1, -1)

			if not frame.backdrop then
				frame:CreateBackdrop("Overlay")
				frame.backdrop:SetPoint("TOPLEFT", 2, -2)
				frame.backdrop:SetPoint("BOTTOMRIGHT", -2, 2)

				frame.TitleBar:Hide()
				frame.Glow:Hide()
				frame.Icon.frame:Hide()

				frame.Icon:SetTemplate("Default")
				frame.Icon:SetHeight(frame.Icon:GetHeight() - 14)
				frame.Icon:SetWidth(frame.Icon:GetWidth() - 14)
				frame.Icon:ClearAllPoints()
				frame.Icon:SetPoint("LEFT", 6, 0)
				frame.Icon.texture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				frame.Icon.texture:ClearAllPoints()
				frame.Icon.texture:SetPoint("TOPLEFT", 2, -2)
				frame.Icon.texture:SetPoint("BOTTOMRIGHT", -2, 2)
			end

			if frame.accountWide then
				frame.backdrop:SetBackdropBorderColor(ACHIEVEMENT_BLUE_BORDER_COLOR:GetRGB())
			else
				frame.backdrop:SetBackdropBorderColor(unpack(C.media.border_color))
			end
		end
	end)

	hooksecurefunc("AchievementObjectives_DisplayCriteria", function(objectivesFrame, id)
		local numCriteria = GetAchievementNumCriteria(id)
		local textStrings, metas, criteria, object = 0, 0
		for i = 1, numCriteria do
			local _, criteriaType, completed, _, _, _, _, assetID = GetAchievementCriteriaInfo(id, i)
			if assetID and criteriaType == _G.CRITERIA_TYPE_ACHIEVEMENT then
				metas = metas + 1
				criteria, object = objectivesFrame:GetMeta(metas), "Label"
			elseif criteriaType ~= 1 then
				textStrings = textStrings + 1
				criteria, object = objectivesFrame:GetCriteria(textStrings), "Name"
			end

			local text = criteria and criteria[object]
			if text then
				local r, g, b, x, y
				if completed then
					if objectivesFrame.completed then
						r, g, b, x, y = 1, 1, 1, 0, 0
					else
						r, g, b, x, y = 0, 1, 0, 1, -1
					end
				else
					r, g, b, x, y = .6, .6, .6, 1, -1
				end

				text:SetTextColor(r, g, b)
				text:SetShadowOffset(x, y)
			end
		end
	end)

	-- Comparison
	local Comparison = _G.AchievementFrameComparison
	Comparison:StripTextures()
	select(5, Comparison:GetChildren()):Hide()
	Comparison.Summary.Player:StripTextures()
	Comparison.Summary.Friend:StripTextures()

	local function HandleCompareCategory(button)
		button:StripTextures()
		button.Background:Hide()
		button:CreateBackdrop("Overlay")
		button.backdrop:SetInside(button, 2, 2)

		button.TitleBar:Hide()
		button.Glow:Hide()
		button.Icon.frame:Hide()

		button.Icon:SetTemplate("Default")
		button.Icon:SetHeight(button.Icon:GetHeight() - 14)
		button.Icon:SetWidth(button.Icon:GetWidth() - 14)
		button.Icon:ClearAllPoints()
		button.Icon:SetPoint("LEFT", 6, 0)
		button.Icon.texture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		button.Icon.texture:ClearAllPoints()
		button.Icon.texture:SetPoint("TOPLEFT", 2, -2)
		button.Icon.texture:SetPoint("BOTTOMRIGHT", -2, 2)
	end

	hooksecurefunc(Comparison.AchievementContainer.ScrollBox, "Update", function(frame)
		for _, child in next, { frame.ScrollTarget:GetChildren() } do
			if not child.isSkinned then
				HandleCompareCategory(child.Player)
				child.Player.Description:SetTextColor(0.6, 0.6, 0.6)
				child.Player.Description.SetTextColor = T.dummy
				HandleCompareCategory(child.Friend)

				child.isSkinned = true
			end
		end
	end)

	hooksecurefunc(Comparison.StatContainer.ScrollBox, "Update", function(frame)
		for _, child in next, { frame.ScrollTarget:GetChildren() } do
			if not child.isSkinned then
				child:StyleButton()
				child.Background:SetColorTexture(1, 1, 1, 0.15)

				child.Left:Kill()
				child.Middle:Kill()
				child.Right:Kill()

				child.Left2:Kill()
				child.Middle2:Kill()
				child.Right2:Kill()

				child.IsSkinned = true
			end
		end
	end)

	-- Stats
	select(4, _G.AchievementFrameStats:GetChildren()):Hide()
	hooksecurefunc(_G.AchievementFrameStats.ScrollBox, "Update", function(frame)
		for _, child in next, { frame.ScrollTarget:GetChildren() } do
			if not child.IsSkinned then
				child:StyleButton()
				child.Background:SetColorTexture(1, 1, 1, 0.2)

				child.Left:Kill()
				child.Middle:Kill()
				child.Right:Kill()

				child.IsSkinned = true
			end
		end
	end)

	----------------------------------------------------------------------------------------
	--	Krowi_AchievementFilter skin
	----------------------------------------------------------------------------------------
	if not C_AddOns.IsAddOnLoaded("Krowi_AchievementFilter") then return end

	T.SkinNextPrevButton(KrowiAF_AchievementFrameBrowsingHistoryPrevAchievementButton)
	T.SkinNextPrevButton(KrowiAF_AchievementFrameBrowsingHistoryNextAchievementButton)
	T.SkinFilter(KrowiAF_AchievementFrameFilterButton)
	T.SkinEditBox(KrowiAF_SearchBoxFrame)
	KrowiAF_AchievementFrameFilterButton:ClearAllPoints()
	KrowiAF_AchievementFrameFilterButton:SetPoint("TOPLEFT", AchievementFrameAchievements, "TOPLEFT", 35, 21)
	KrowiAF_AchievementFrameBrowsingHistoryPrevAchievementButton:ClearPoint("RIGHT")
	KrowiAF_AchievementFrameBrowsingHistoryNextAchievementButton:ClearPoint("RIGHT")
	KrowiAF_AchievementFrameBrowsingHistoryPrevAchievementButton:SetPoint("LEFT", KrowiAF_AchievementFrameFilterButton, "RIGHT", 3, 0)
	KrowiAF_AchievementFrameBrowsingHistoryNextAchievementButton:SetPoint("LEFT", KrowiAF_AchievementFrameBrowsingHistoryPrevAchievementButton, "RIGHT", 3, 0)
	AchievementFrameFilterDropdown:ClearAllPoints()
	AchievementFrameFilterDropdown:SetPoint("TOPLEFT", AchievementFrameAchievements, "TOPLEFT", 35, 21)

	-- [[ Categories ]]
	local function SkinCategoryButton(_, button)
		button:StripTextures(true)
		button:StyleButton()

		button:SetHighlightTexture(C.media.texture)
		local hl = button:GetHighlightTexture()
		hl:SetVertexColor(0.8, 0.8, 0.8, 0.25)
		hl:SetInside(button.backdrop)
	end

	local function SkinCategoriesFrame(frame)
		-- Scrollbar
		T.SkinScrollBar(frame.ScrollBar)

		-- Frame
		frame:StripTextures()
		frame:CreateBackdrop("Overlay")
		frame.backdrop:SetPoint("TOPLEFT", 0, 0)
		frame.backdrop:SetPoint("BOTTOMRIGHT", 2, -3)

		-- Buttons
		KrowiAF_CategoriesFrame.ScrollView:RegisterCallback(ScrollBoxListViewMixin.Event.OnAcquiredFrame, SkinCategoryButton, KrowiAF_CategoriesFrame);
	end
	SkinCategoriesFrame(KrowiAF_CategoriesFrame)

	local function SkinGameTooltipProgressBar(progressBar)
		progressBar:StripTextures()
		local fills = progressBar.Fill
		for _, fill in next, fills do
			fill:SetTexture(C.media.texture)
		end
		progressBar:CreateBackdrop()
		progressBar.backdrop:SetPoint("TOPLEFT", 5, -4)
		progressBar.backdrop:SetPoint("BOTTOMRIGHT", -4, 4)
		progressBar:SetColors({R = 0, G = 0.5, B = 0}, {R = 0.8, G = 0, B = 0})
	end
	SkinGameTooltipProgressBar(LibStub("Krowi_GameTooltipWithProgressBar-2.0").ProgressBar)

	-- [[ Achievements ]]
	local function SkinAchievementButton(button)
		button:SetFrameLevel(button:GetFrameLevel() + 2)
		button:StripTextures(true)
		button:CreateBackdrop("Transparent")
		button.backdrop:SetPoint("TOPLEFT", 1, -1)
		button.backdrop:SetPoint("BOTTOMRIGHT", 0, 2)
		button.Icon:CreateBackdrop()
		button.Icon:SetSize(button.Compact and 31 or 54, button.Compact and 31 or 54)
		button.Icon:ClearAllPoints()
		button.Icon:SetPoint("TOPLEFT", button.Compact and 8 or 10, button.Compact and -8 or -10)
		button.Icon.Border:Kill()
		button.Icon.Texture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		button.Icon.Texture:SetInside(button.Icon.backdrop)

		if button.Highlight then
			button.Highlight:StripTextures()
			button:HookScript("OnEnter", function(self) self.backdrop:SetBackdropBorderColor(1, 1, 0) end)
			button:HookScript("OnLeave", function(self) self.backdrop:SetBackdropBorderColor(unpack(C.media.border_color)) end)
		end

		if button.Header then
			button.Header:SetTextColor(1, 1, 1)
		end

		if button.Description then
			button.Description:SetTextColor(.6, .6, .6)
			hooksecurefunc(button.Description, "SetTextColor", function(self, r, g, b)
				if r == 0 and g == 0 and b == 0 then
					self:SetTextColor(.6, .6, .6)
				end
			end)
		end

		if button.HiddenDescription then
			button.HiddenDescription:SetTextColor(1, 1, 1)
		end

		if button.Tracked then
			for _, region in next, {button.Tracked:GetRegions()} do
				if region.SetTextColor then
					region:SetTextColor(1, 1, 1)
				end
			end
			T.SkinCheckBox(button.Tracked)
			button.Tracked:SetSize(18, 18)
			button.Tracked:ClearAllPoints()
			button.Tracked:SetPoint("TOPLEFT", button.Icon, "BOTTOMLEFT", 0, -2)
		end
	end

	local blueAchievement = { r = 0.1, g = 0.2, b = 0.3, a = 0.8 }
	local function BlueBackdrop(self)
		self:SetBackdropColor(blueAchievement.r, blueAchievement.g, blueAchievement.b, blueAchievement.a)
	end

	local redAchievement = { r = 0.3, g = 0, b = 0, a = 0.8 }
	local function RedBackdrop(self)
		self:SetBackdropColor(redAchievement.r, redAchievement.g, redAchievement.b, redAchievement.a)
	end

	local yellowAchievement = { r = 0.3, g = 0.3, b = 0, a = 0.8 }
	local function YellowBackdrop(self)
		self:SetBackdropColor(yellowAchievement.r, yellowAchievement.g, yellowAchievement.b, yellowAchievement.a)
	end

	local greenAchievement = { r = 0, g = 0.3, b = 0, a = 0.8 }
	local function GreenBackdrop(self)
		self:SetBackdropColor(greenAchievement.r, greenAchievement.g, greenAchievement.b, greenAchievement.a)
	end

	local function SetAchievementButtonColor(button)
		if not button or not button.backdrop or not button.Achievement then
			return
		end
		local achievement = button.Achievement
		local state = achievement:GetObtainableState()
		local backdropColorFunc
		if state and (state == false or state == "Past") then
			backdropColorFunc = RedBackdrop
		elseif state and state == "Current" then
			backdropColorFunc = GreenBackdrop
		elseif state and state == "Future" then
			backdropColorFunc = YellowBackdrop
		else
			if button.accountWide then
				backdropColorFunc = BlueBackdrop
			else
				backdropColorFunc = nil
				button.backdrop.callbackBackdropColor = nil
				button.backdrop:SetBackdropColor(0.1, 0.1, 0.1, 1)
			end
		end

		if backdropColorFunc then
			button.backdrop.callbackBackdropColor = backdropColorFunc
			backdropColorFunc(button.backdrop)
		end
	end

	local function SkinAchievementsFrame(frame)
		-- Buttons
		hooksecurefunc(frame.ScrollBox, "Update", function()
			for _, button in next, {frame.ScrollBox.ScrollTarget:GetChildren()} do
				if button then
					if button:IsShown() then
						SetAchievementButtonColor(button)
					end
					if not button.IsSkinned then
						SkinAchievementButton(button)
						button.IsSkinned = true
					end
				end
			end
		end)

		-- Objectives
		hooksecurefunc(KrowiAF_AchievementsObjectives, "DisplayCriteria", function(self, id)
			local numCriteria = GetAchievementNumCriteria(id)
			local textStrings, metas = 0, 0
			local criteria, object
			for i = 1, numCriteria do
				local _, criteriaType, completed, _, _, _, _, assetID = GetAchievementCriteriaInfo(id, i)
				if assetID and criteriaType == _G.CRITERIA_TYPE_ACHIEVEMENT then
					metas = metas + 1
					criteria, object = self:GetMeta(metas), "Label"
				elseif criteriaType ~= 1 then
					textStrings = textStrings + 1
					criteria, object = self:GetTextCriteria(textStrings), "Label"
				end

				local text = criteria and criteria[object]
				if text then
					local r, g, b, x, y
					if completed then
						if self.Completed then
							r, g, b, x, y = 1, 1, 1, 0, 0
						else
							r, g, b, x, y = 0, 1, 0, 1, -1
						end
					else
						r, g, b, x, y = .6, .6, .6, 1, -1
					end
					text:SetTextColor(r, g, b)
					text:SetShadowOffset(x, y)
				end
			end
		end)

		-- Scrollbar
		T.SkinScrollBar(frame.ScrollBar)

		-- Frame
		frame:StripTextures()
	end
	SkinAchievementsFrame(KrowiAF_AchievementsFrame)

	local function SkinAchievementsFrameLight(frame)
		-- Buttons
		hooksecurefunc(frame.ScrollBox, "Update", function()
			for _, button in next, { frame.ScrollBox.ScrollTarget:GetChildren() } do
				if button then
					if button:IsShown() then
						SetAchievementButtonColor(button)
					end
					if not button.IsSkinned then
						SkinAchievementButton(button)
						button.IsSkinned = true
					end
				end
			end
		end)

		 -- Scrollbar
		T.SkinScrollBar(frame.ScrollBar)

		-- Frame
		frame:StripTextures()
	end

	-- [[ Summary ]]
	local function SkinStatusBar(statusBar)
		statusBar:SetFrameLevel(statusBar:GetFrameLevel() + 1)
		statusBar:StripTextures()
		local fills = statusBar.Fill
		for _, fill in next, fills do
			fill:SetTexture(C.media.texture)
		end
		statusBar:AdjustOffsets(8, 8)
		statusBar:CreateBackdrop("Overlay")
		statusBar.backdrop:SetPoint("TOPLEFT", 12, -12)
		statusBar.backdrop:SetPoint("BOTTOMRIGHT", -12, 12)
		statusBar:SetColors({R = 0, G = 0.5, B = 0}, {R = 0.8, G = 0, B = 0})
		if statusBar.Button then
			local button = statusBar.Button

			local htex = button:CreateTexture()
			htex:SetColorTexture(1, 1, 1, 0.3)
			htex:SetInside(statusBar.backdrop)
			button:SetHighlightTexture(htex)

			button:SetScript("OnLeave", function(self)
			end)
			button:SetScript("OnEnter", function(self)
			end)
		end
	end

	local function SkinAchievementSummary()
		-- Headers
		KrowiAF_SummaryFrame.Achievements.Header.Texture:SetVertexColor(1, 1, 1, 0.25)
		KrowiAF_SummaryFrame.Achievements.Header:StripTextures(true)
		KrowiAF_SummaryFrame.Categories.Header.Texture:SetVertexColor(1, 1, 1, 0.25)
		KrowiAF_SummaryFrame.Categories.Header:StripTextures(true)

		-- Achievements
		SkinAchievementsFrameLight(KrowiAF_SummaryFrame.AchievementsFrame)

		-- StatusBars
		SkinStatusBar(KrowiAF_SummaryFrame.TotalStatusBar)
		local preHookFunction = KrowiAF_SummaryFrame.GetStatusBar
		KrowiAF_SummaryFrame.GetStatusBar = function(self, index)
			local statusBar = preHookFunction(self, index)
			if not statusBar.IsSkinned then
				SkinStatusBar(statusBar)
				statusBar.IsSkinned = true
			end
			return statusBar
		end

		-- Frame
		KrowiAF_SummaryFrame:StripTextures()
		KrowiAF_SummaryFrame:GetChildren():Hide()
		KrowiAF_SummaryFrame:CreateBackdrop("Overlay")
		KrowiAF_SummaryFrame.backdrop:SetPoint("TOPLEFT", 7, 0)
		KrowiAF_SummaryFrame.backdrop:SetPoint("BOTTOMRIGHT", -3, -3)
	end
	SkinAchievementSummary()

	-- [[ Search ]]
	local function SkinSearchOptionsButton()
		KrowiAF_SearchBoxFrame.OptionsMenuButton:SkinButton()
		KrowiAF_SearchBoxFrame.OptionsMenuButton:SetSize(21, 21)

		local highlightTex = KrowiAF_SearchBoxFrame.OptionsMenuButton.GetHighlightTexture and KrowiAF_SearchBoxFrame.OptionsMenuButton:GetHighlightTexture()
		if highlightTex then
			highlightTex:SetTexture()
		else
			KrowiAF_SearchBoxFrame.OptionsMenuButton:StripTextures()
		end

		KrowiAF_SearchBoxFrame.OptionsMenuButton:ClearAllPoints()
		KrowiAF_SearchBoxFrame.OptionsMenuButton:SetPoint("RIGHT", KrowiAF_SearchBoxFrame, "LEFT", 0, 0)
	end

	local function SkinSearchBoxFrame(frame)
		T.SkinEditBox(frame)
		frame.backdrop:SetPoint("TOPLEFT", frame, "TOPLEFT", 3, -2)
		frame.backdrop:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 3)
		frame:ClearAllPoints()
		frame:SetPoint("TOPRIGHT", AchievementFrame, -30, 5)
		frame:SetSize(114, 26)
	end

	local function SkinSearchPreviewButton(button, frame)
		button:StripTextures()

		if button.Icon then
			button.Icon:SkinIcon(true)
		end

		if frame then
			button:CreateBackdrop("Overlay")
		end
		button:SetHighlightTexture(C.media.texture)

		local hl = button:GetHighlightTexture()
		hl:SetVertexColor(1, 1, 1, 0.3)
		-- hl:SetPoint("TOPLEFT", 1, -1)
		-- hl:SetPoint("BOTTOMRIGHT", -1, 1)
	end

	local function SkinSearchPreviewFrame()
		KrowiAF_SearchBoxFrame.PreviewContainer:StripTextures()
		KrowiAF_SearchBoxFrame.PreviewContainer:ClearAllPoints()
		KrowiAF_SearchBoxFrame.PreviewContainer:SetPoint("TOPLEFT", KrowiAF_AchievementsFrame, "TOPRIGHT", 25, 25)
		KrowiAF_SearchBoxFrame.PreviewContainer:CreateBackdrop("Overlay")
		KrowiAF_SearchBoxFrame.PreviewContainer.backdrop:SetPoint("TOPLEFT", KrowiAF_SearchBoxFrame.PreviewContainer, "TOPLEFT", -2, 1)
		KrowiAF_SearchBoxFrame.PreviewContainer.backdrop:SetPoint("BOTTOMRIGHT", KrowiAF_SearchBoxFrame.PreviewContainer.ShowFullSearchResultsButton, "BOTTOMRIGHT", 6, -6)

		for _, button in next, KrowiAF_SearchBoxFrame.PreviewContainer.Buttons do
			SkinSearchPreviewButton(button)
		end
		SkinSearchPreviewButton(KrowiAF_SearchBoxFrame.PreviewContainer.ShowFullSearchResultsButton, true)
	end

	local function SkinSearchResultsButton(_, button)
		button:SetNormalTexture("")
		button:SetPushedTexture("")
		button:GetRegions():Hide()

		button.ResultType:SetTextColor(1, 1, 1)
		button.Path:SetTextColor(1, 1, 1)
	end

	local function SkinSearchResultsFrame()
		KrowiAF_SearchBoxFrame.ResultsFrame:StripTextures()
		KrowiAF_SearchBoxFrame.ResultsFrame:CreateBackdrop("Transparent")

		KrowiAF_SearchBoxFrame.ResultsFrame.ScrollView:RegisterCallback(ScrollBoxListViewMixin.Event.OnAcquiredFrame, SkinSearchResultsButton, KrowiAF_SearchBoxFrame.ResultsFrame)

		T.SkinCloseButton(KrowiAF_SearchBoxFrame.ResultsFrame.closeButton)
		T.SkinScrollBar(KrowiAF_SearchBoxFrame.ResultsFrame.ScrollBar)
	end

	SkinSearchOptionsButton()
	SkinSearchBoxFrame(KrowiAF_SearchBoxFrame)
	SkinSearchPreviewFrame()
	SkinSearchResultsFrame()

	-- [[ Calendar ]]
	local function SkinCalendarButton()
		KrowiAF_AchievementFrameCalendarButton:SkinButton()
		KrowiAF_AchievementFrameCalendarButton:ClearAllPoints()
		KrowiAF_AchievementFrameCalendarButton:SetPoint("TOPRIGHT", KrowiAF_SearchBoxFrame, "TOPLEFT", -24, -2)
		KrowiAF_AchievementFrameCalendarButton:SetSize(21, 21)
		local fs = KrowiAF_AchievementFrameCalendarButton:CreateFontString(nil, nil, "GameFontHighlightSmall")
		fs:SetPoint("CENTER", 0, 0)
		KrowiAF_AchievementFrameCalendarButton:SetFontString(fs)
		local currentCalendarTime = C_DateAndTime.GetCurrentCalendarTime()
		KrowiAF_AchievementFrameCalendarButton:SetText(currentCalendarTime.monthDay)
	end

	local function SkinCalendarDayButton(button)
		button.DarkFrame:SetAlpha(.5)

		button:SetTemplate(nil, nil, nil, true)
		button:SetBackdropColor(0,0,0,0)
		button:SetHighlightTexture(C.media.texture)
		button:SetFrameLevel(button:GetFrameLevel() + 1)

		local hl = button:GetHighlightTexture()
		hl:SetVertexColor(1, 1, 1, 0.3)
		hl:SetPoint("TOPLEFT", -1, 1)
		hl:SetPoint("BOTTOMRIGHT")
		hl.SetAlpha = T.dummy
	end

	local function SkinCalendarFrame()
		KrowiAF_AchievementCalendarFrame:DisableDrawLayer("BORDER")
		KrowiAF_AchievementCalendarFrame:CreateBackdrop("Transparent")

		local closeButton = KrowiAF_AchievementCalendarFrame.CloseButton
		T.SkinCloseButton(closeButton)
		closeButton:SetPoint("TOPRIGHT", -4, -4)

		for i = 1, 7 do
			KrowiAF_AchievementCalendarFrame.WeekDayBackgrounds[i]:SetAlpha(0)
		end

		KrowiAF_AchievementCalendarFrame.MonthBackground:SetAlpha(0)
		KrowiAF_AchievementCalendarFrame.YearBackground:SetAlpha(0)

		T.SkinNextPrevButton(KrowiAF_AchievementCalendarFrame.PrevMonthButton, nil, nil, true)
		T.SkinNextPrevButton(KrowiAF_AchievementCalendarFrame.NextMonthButton, nil, nil, true)

		for i = 1, 42 do
			SkinCalendarDayButton(KrowiAF_AchievementCalendarFrame.DayButtons[i])
		end

		local weekdaySelectedTexture = KrowiAF_AchievementCalendarFrame.WeekdaySelectedTexture
		weekdaySelectedTexture:SetDesaturated(true)
		weekdaySelectedTexture:SetVertexColor(1, 1, 1, 0.6)

		local todayFrame = KrowiAF_AchievementCalendarFrame.TodayFrame
		todayFrame.Texture:Hide()
		todayFrame.Glow:Hide()

		todayFrame:SetTemplate()
		todayFrame:SetBackdropBorderColor(_G.NORMAL_FONT_COLOR:GetRGB())
		todayFrame:SetBackdropColor(0, 0, 0, 0)
		todayFrame:SetScript("OnUpdate", nil)

		hooksecurefunc(KrowiAF_AchievementCalendarFrame, "SetToday", function()
			todayFrame:SetAllPoints()
		end)

		KrowiAF_AchievementCalendarFrame.MonthAchievementsAndPoints:SetPoint("TOPRIGHT", -40, -13)
	end

	local function SkinCalendarSideFrame()
		KrowiAF_AchievementCalendarFrame.SideFrame:StripTextures(true)
		KrowiAF_AchievementCalendarFrame.SideFrame:SetTemplate("Transparent")
		KrowiAF_AchievementCalendarFrame.SideFrame:SetPoint("TOPLEFT", KrowiAF_AchievementCalendarFrame.SideFrame:GetParent(), "TOPRIGHT", 3, -24)
		KrowiAF_AchievementCalendarFrame.SideFrame.Header:StripTextures()
		T.SkinCloseButton(KrowiAF_AchievementCalendarFrame.SideFrame.CloseButton)

		SkinAchievementsFrameLight(KrowiAF_AchievementCalendarFrame.SideFrame.AchievementsFrame)
	end

	SkinCalendarButton()
	SkinCalendarFrame()
	SkinCalendarSideFrame()

	-- [[ DataManager ]]
	local function SkinDataManager()
		KrowiAF_DataManagerFrame:StripTextures()
		KrowiAF_DataManagerFrame.Inset:StripTextures()
		KrowiAF_DataManagerFrame.CloseButton:SetPoint("TOPRIGHT", 0, 2)
		KrowiAF_DataManagerFrame:CreateBackdrop("Transparent")
		T.SkinCloseButton(KrowiAF_DataManagerFrame.CloseButton)

		T.SkinScrollBar(KrowiAF_DataManagerFrame.CharacterList.ScrollBar)

		local columnDisplay = KrowiAF_DataManagerFrame.CharacterList.ColumnDisplay
		columnDisplay:StripTextures()
		for i = 1, columnDisplay:GetNumChildren() do
			local child = select(i, columnDisplay:GetChildren())
			child:StripTextures()
			child:CreateBackdrop("Overlay")
			child.backdrop:SetPoint("TOPLEFT", 1, -1)
			child.backdrop:SetPoint("BOTTOMRIGHT", -1, 1)
		end

		hooksecurefunc(KrowiAF_DataManagerFrame.CharacterList.ScrollBox, "Update", function()
			for _, button in next, {KrowiAF_DataManagerFrame.CharacterList.ScrollBox.ScrollTarget:GetChildren()} do
				if button and not button.IsSkinned then
					T.SkinCheckBox(button.HeaderTooltip)
					button.HeaderTooltip:SetSize(25, 25)
					button.HeaderTooltip:ClearAllPoints()
					button.HeaderTooltip:SetPoint("LEFT", button.Points, "RIGHT", 19, 0)
					T.SkinCheckBox(button.EarnedByAchievementTooltip)
					button.EarnedByAchievementTooltip:SetSize(25, 25)
					button.EarnedByAchievementTooltip:ClearAllPoints()
					button.EarnedByAchievementTooltip:SetPoint("LEFT", button.HeaderTooltip, "RIGHT", 74, 0)

					T.SkinCheckBox(button.MostProgressAchievementTooltip)
					button.MostProgressAchievementTooltip:SetSize(25, 25)
					button.MostProgressAchievementTooltip:ClearAllPoints()
					button.MostProgressAchievementTooltip:SetPoint("LEFT", button.EarnedByAchievementTooltip, "RIGHT", 74, 0)

					T.SkinCheckBox(button.IgnoreCharacter)
					button.IgnoreCharacter:SetSize(25, 25)
					button.IgnoreCharacter:ClearAllPoints()
					button.IgnoreCharacter:SetPoint("LEFT", button.MostProgressAchievementTooltip, "RIGHT", 73, 0)
					button.IsSkinned = true
				end
			end
		end)

		KrowiAF_DataManagerFrame.Import:SkinButton()
	end
	SkinDataManager()

	-- [[ Alerts and Side Buttons ]]
	local function ForceAlpha(self, alpha, forced)
		if alpha ~= 1 and forced ~= true then
			self:SetAlpha(1, true)
		end
	end

	local function SkinAlertFrameTemplate(frame)
		frame:SetAlpha(1)

		if not frame.hooked then
			hooksecurefunc(frame, "SetAlpha", ForceAlpha)
			frame.hooked = true
		end

		if not frame.backdrop then
			frame:CreateBackdrop("Transparent")
			frame.backdrop:SetPoint("TOPLEFT", frame.Background, "TOPLEFT", -2, -6)
			frame.backdrop:SetPoint("BOTTOMRIGHT", frame.Background, "BOTTOMRIGHT", -2, 6)
		end

		-- Background
		frame.Background:SetTexture()
		frame.glow:Kill()
		frame.shine:Kill()

		-- Text
		frame.Unlocked:SetTextColor(1, 1, 1)

		-- Icon
		frame.Icon.Texture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		frame.Icon.Overlay:Kill()

		frame.Icon.Texture:ClearAllPoints()
		frame.Icon.Texture:SetPoint("LEFT", frame, 7, 0)

		if not frame.Icon.Texture.b then
			frame.Icon.Texture.b = CreateFrame("Frame", nil, frame)
			frame.Icon.Texture.b:SetTemplate()
			frame.Icon.Texture.b:SetOutside(frame.Icon.Texture)
			frame.Icon.Texture:SetParent(frame.Icon.Texture.b)
		end
	end

	local function SkinSideButton(button, prevButton)
		if not button.styled then
			SkinAlertFrameTemplate(button)
		end
		if not prevButton then
			button:ClearAllPoints()
			button:SetPoint("TOPLEFT", AchievementFrame, "TOPRIGHT", 5, 13) -- Make the 2nd button anchor like the 1st one
		else
			button:ClearAllPoints()
			button:SetPoint("TOPLEFT", prevButton, "BOTTOMLEFT", 0, 9) -- Make the 2nd button anchor like the 1st one
		end
		button.styled = true
	end

	local function SkinSideButtons()
		local i = 1
		local button = _G["KrowiAF_AchievementFrameSideButton" .. i]
		local prevButton
		while button do
			SkinSideButton(button, prevButton)
			prevButton = button
			i = i + 1
			button = _G["KrowiAF_AchievementFrameSideButton" .. i]
		end
	end

	AchievementFrame:HookScript("OnShow", function()
		C_Timer.After(0.05, function()
			SkinSideButtons()
			if KrowiAF_AchievementFrameSideButton1 then
				hooksecurefunc(KrowiAF_AchievementFrameSideButton1, "SetPoint", function(_, _, _, _, _, y)
					if y == 0 then
						SkinSideButtons()
					end
				end)
			end
		end)
	end)
end

T.SkinFuncs["Blizzard_AchievementUI"] = LoadSkin
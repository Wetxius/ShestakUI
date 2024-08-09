local T, C, L = unpack(ShestakUI)

----------------------------------------------------------------------------------------
--	Move ObjectiveTrackerFrame and hide background
----------------------------------------------------------------------------------------
local anchor = CreateFrame("Frame", "ObjectiveTrackerAnchor", UIParent)
anchor:SetPoint(C.position.quest[1], C.position.quest[2], C.position.quest[3], C.position.quest[4], C.position.quest[5] - (C.actionbar.micromenu and 27 or 0))
anchor:SetSize(224, 150)

ObjectiveTrackerFrame.IsUserPlaced = function() return true end
ObjectiveTrackerFrame:SetClampedToScreen(false)

hooksecurefunc(ObjectiveTrackerFrame, "SetPoint", function(_, _, parent)
	if parent ~= anchor then
		ObjectiveTrackerFrame:ClearAllPoints()
		ObjectiveTrackerFrame:SetPoint("TOPLEFT", anchor, "TOPLEFT", 20, 3)
	end
end)

local height = T.screenHeight / 1.6
ObjectiveTrackerFrame:SetHeight(height)

hooksecurefunc(ObjectiveTrackerFrame, "SetHeight", function(_, h)
	if h ~= height then
		ObjectiveTrackerFrame:SetHeight(height)
	end
end)

local headers = {
	ScenarioObjectiveTracker,
	BonusObjectiveTracker,
	UIWidgetObjectiveTracker,
	CampaignQuestObjectiveTracker,
	QuestObjectiveTracker,
	AdventureObjectiveTracker,
	AchievementObjectiveTracker,
	MonthlyActivitiesObjectiveTracker,
	ProfessionsRecipeTracker,
	WorldQuestObjectiveTracker,
}

ObjectiveTrackerFrame.Header.Background:SetTexture(nil)

----------------------------------------------------------------------------------------
--	Skin ObjectiveTrackerFrame item buttons
----------------------------------------------------------------------------------------
local function HotkeyShow(self)
	local item = self:GetParent()
	if item.rangeOverlay then item.rangeOverlay:Show() end
end

local function HotkeyHide(self)
	local item = self:GetParent()
	if item.rangeOverlay then item.rangeOverlay:Hide() end
end

local function HotkeyColor(self, r)
	local item = self:GetParent()
	if item.rangeOverlay then
		if r == 1 then
			item.rangeOverlay:Show()
		else
			item.rangeOverlay:Hide()
		end
	end
end

local function SkinQuestIcons(_, block)
	local item = block and block.ItemButton

	if item and not item.skinned then
		item:SetSize(25, 25)
		item:SetTemplate("Default")
		item:StyleButton()

		item:SetNormalTexture(0)

		item.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		item.icon:SetPoint("TOPLEFT", item, 2, -2)
		item.icon:SetPoint("BOTTOMRIGHT", item, -2, 2)

		item.Cooldown:SetAllPoints(item.icon)

		item.Count:ClearAllPoints()
		item.Count:SetPoint("BOTTOMRIGHT", 0, 2)
		item.Count:SetFont(C.font.action_bars_font, C.font.action_bars_font_size, C.font.action_bars_font_style)
		item.Count:SetShadowOffset(C.font.action_bars_font_shadow and 1 or 0, C.font.action_bars_font_shadow and -1 or 0)

		local rangeOverlay = item:CreateTexture(nil, "OVERLAY")
		rangeOverlay:SetTexture(C.media.texture)
		rangeOverlay:SetInside()
		rangeOverlay:SetVertexColor(1, 0.3, 0.1, 0.6)
		item.rangeOverlay = rangeOverlay

		hooksecurefunc(item.HotKey, "Show", HotkeyShow)
		hooksecurefunc(item.HotKey, "Hide", HotkeyHide)
		hooksecurefunc(item.HotKey, "SetVertexColor", HotkeyColor)
		HotkeyColor(item.HotKey, item.HotKey:GetTextColor())
		item.HotKey:SetAlpha(0)

		item.skinned = true
	end

	local finder = block and block.rightEdgeFrame
	if finder and not finder.skinned then
		finder:SetSize(26, 26)
		finder:SetNormalTexture(0)
		finder:SetHighlightTexture(0)
		finder:SetPushedTexture(0)
		finder.b = CreateFrame("Frame", nil, finder)
		finder.b:SetTemplate("Overlay")
		finder.b:SetPoint("TOPLEFT", finder, "TOPLEFT", 2, -3)
		finder.b:SetPoint("BOTTOMRIGHT", finder, "BOTTOMRIGHT", -4, 3)
		finder.b:SetFrameLevel(1)

		finder:HookScript("OnEnter", function(self)
			if self:IsEnabled() then
				self.b:SetBackdropBorderColor(unpack(C.media.classborder_color))
				if self.b.overlay then
					self.b.overlay:SetVertexColor(C.media.classborder_color[1] * 0.3, C.media.classborder_color[2] * 0.3, C.media.classborder_color[3] * 0.3, 1)
				end
			end
		end)

		finder:HookScript("OnLeave", function(self)
			self.b:SetBackdropBorderColor(unpack(C.media.border_color))
			if self.b.overlay then
				self.b.overlay:SetVertexColor(0.1, 0.1, 0.1, 1)
			end
		end)

		hooksecurefunc(finder, "Show", function(self)
			self.b:SetFrameLevel(1)
		end)

		finder.skinned = true
	end
end

-- WorldQuestsList button skin
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function()
	if not IsAddOnLoaded("WorldQuestsList") then return end

	local orig = _G.WorldQuestList.ObjectiveTracker_Update_hook
	local function orig_hook(...)
		orig(...)
		for _, b in pairs(WorldQuestList.LFG_objectiveTrackerButtons) do
			if b and not b.skinned then
				b:SetSize(20, 20)
				b.texture:SetAtlas("socialqueuing-icon-eye")
				b.texture:SetSize(12, 12)
				b:SetHighlightTexture(0)

				local point, anchor, point2, x, y = b:GetPoint()
				if x == -18 then
					b:SetPoint(point, anchor, point2, -13, y)
				end

				b.b = CreateFrame("Frame", nil, b)
				b.b:SetTemplate("Overlay")
				b.b:SetPoint("TOPLEFT", b, "TOPLEFT", 0, 0)
				b.b:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", 0, 0)
				b.b:SetFrameLevel(1)
				b.skinned = true
			end
		end
	end
	_G.WorldQuestList.ObjectiveTracker_Update_hook = orig_hook
end)

----------------------------------------------------------------------------------------
--	Difficulty color for ObjectiveTrackerFrame lines
----------------------------------------------------------------------------------------
hooksecurefunc(QuestObjectiveTracker, "Update", function()
	for i = 1, C_QuestLog.GetNumQuestWatches() do
		local questID = C_QuestLog.GetQuestIDForQuestWatchIndex(i)
		if not questID then
			break
		end
		local col = GetDifficultyColor(C_PlayerInfo.GetContentDifficultyQuestForPlayer(questID))
		local block = QuestObjectiveTracker:GetExistingBlock(questID)
		if block then
			block.HeaderText:SetTextColor(col.r, col.g, col.b)
			block.HeaderText.col = col
		end
	end
end)

hooksecurefunc(QuestObjectiveTracker, "OnBlockHeaderLeave", function(_, block)
	if block.HeaderText.col then
		block.HeaderText:SetTextColor(block.HeaderText.col.r, block.HeaderText.col.g, block.HeaderText.col.b)
	end
end)

----------------------------------------------------------------------------------------
--	Skin ObjectiveTrackerFrame.HeaderMenu.MinimizeButton
----------------------------------------------------------------------------------------
if C.skins.blizzard_frames == true then
	local button = ObjectiveTrackerFrame.Header.MinimizeButton
	button:SetSize(17, 17)
	button:StripTextures()
	button:SetTemplate("Overlay")

	button.minus = button:CreateTexture(nil, "OVERLAY")
	button.minus:SetSize(7, 1)
	button.minus:SetPoint("CENTER")
	button.minus:SetTexture(C.media.blank)

	button.plus = button:CreateTexture(nil, "OVERLAY")
	button.plus:SetSize(1, 7)
	button.plus:SetPoint("CENTER")
	button.plus:SetTexture(C.media.blank)

	button:HookScript("OnEnter", T.SetModifiedBackdrop)
	button:HookScript("OnLeave", T.SetOriginalBackdrop)

	button.plus:Hide()

	hooksecurefunc(ObjectiveTrackerFrame, "SetCollapsed", function(self, collapsed)
		if collapsed then
			button.plus:Show()
			if C.general.minimize_mouseover then
				button:SetAlpha(0)
				button:HookScript("OnEnter", function() button:SetAlpha(1) end)
				button:HookScript("OnLeave", function() button:SetAlpha(0) end)
			end
		else
			button.plus:Hide()
			if C.general.minimize_mouseover then
				button:SetAlpha(1)
				button:HookScript("OnEnter", function() button:SetAlpha(1) end)
				button:HookScript("OnLeave", function() button:SetAlpha(1) end)
			end
		end
		button:SetNormalTexture(0)
		button:SetPushedTexture(0)
	end)
end

----------------------------------------------------------------------------------------
--	Auto collapse Objective Tracker
----------------------------------------------------------------------------------------
-- NOTE: SetCollapsed() cause UseQuestLogSpecialItem() taint
if C.automation.auto_collapse ~= "NONE" then
	local collapse = CreateFrame("Frame")
	collapse:RegisterEvent("PLAYER_ENTERING_WORLD")
	collapse:SetScript("OnEvent", function()
		if C.automation.auto_collapse == "RAID" then
			if IsInInstance() then
				C_Timer.After(0.1, function()
					ObjectiveTrackerFrame:SetCollapsed(true)
				end)
			elseif not InCombatLockdown() then
				if ObjectiveTrackerFrame.isCollapsed then
					ObjectiveTrackerFrame:SetCollapsed(false)
				end
			end
		elseif C.automation.auto_collapse == "SCENARIO" then
			local inInstance, instanceType = IsInInstance()
			if inInstance then
				if instanceType == "party" or instanceType == "scenario" then
					C_Timer.After(0.1, function() -- for some reason it got error after reload in instance
						for i = 3, #headers do
							headers[i]:SetCollapsed(true)
						end
					end)
				else
					C_Timer.After(0.1, function()
						ObjectiveTrackerFrame:SetCollapsed(true)
					end)
				end
			else
				if not InCombatLockdown() then
					for i = 3, #headers do
						if headers[i].isCollapsed then
							headers[i]:SetCollapsed(false)
						end
					end
					if ObjectiveTrackerFrame.isCollapsed then
						ObjectiveTrackerFrame:SetCollapsed(false)
					end
				end
			end
		elseif C.automation.auto_collapse == "RELOAD" then
			C_Timer.After(0.1, function()
				ObjectiveTrackerFrame:SetCollapsed(true)
			end)
		end
	end)
end

----------------------------------------------------------------------------------------
--	Skin quest objective progress bar
----------------------------------------------------------------------------------------
local function SkinProgressBar(tracker, key)
	local progressBar = tracker.usedProgressBars[key]
	local bar = progressBar and progressBar.Bar
	local label = bar and bar.Label
	local icon = bar and bar.Icon

	if not progressBar.styled then
		if bar.BarFrame then bar.BarFrame:Hide() end
		if bar.BarFrame2 then bar.BarFrame2:Hide() end
		if bar.BarFrame3 then bar.BarFrame3:Hide() end
		if bar.BarGlow then bar.BarGlow:Hide() end
		if bar.Sheen then bar.Sheen:Hide() end
		if bar.IconBG then bar.IconBG:SetAlpha(0) end
		if bar.BorderLeft then bar.BorderLeft:SetAlpha(0) end
		if bar.BorderRight then bar.BorderRight:SetAlpha(0) end
		if bar.BorderMid then bar.BorderMid:SetAlpha(0) end
		if progressBar.PlayFlareAnim then progressBar.PlayFlareAnim  = T.dummy end -- hide animation

		bar:SetSize(200, 16)
		bar:SetStatusBarTexture(C.media.texture)
		bar:CreateBackdrop("Transparent")

		label:ClearAllPoints()
		label:SetPoint("CENTER", 0, -1)
		label:SetFont(C.media.pixel_font, C.media.pixel_font_size, C.media.pixel_font_style)
		label:SetDrawLayer("OVERLAY")

		if icon then
			icon:SetPoint("RIGHT", 26, 0)
			icon:SetSize(20, 20)
			icon:SetMask("")

			local border = CreateFrame("Frame", "$parentBorder", bar)
			border:SetAllPoints(icon)
			border:SetTemplate("Transparent")
			border:SetBackdropColor(0, 0, 0, 0)
			bar.newIconBg = border

			hooksecurefunc(bar.AnimIn, "Play", function()
				bar.AnimIn:Stop()
			end)
		end

		progressBar.styled = true
	end

	if bar.newIconBg then bar.newIconBg:SetShown(icon:IsShown()) end
end

----------------------------------------------------------------------------------------
--	Skin Timer bar
----------------------------------------------------------------------------------------
local function SkinTimer(tracker, key)
	local timerBar = tracker.usedTimerBars[key]
	local bar = timerBar and timerBar.Bar

	if not timerBar.styled then
		if bar.BorderLeft then bar.BorderLeft:SetAlpha(0) end
		if bar.BorderRight then bar.BorderRight:SetAlpha(0) end
		if bar.BorderMid then bar.BorderMid:SetAlpha(0) end

		bar:SetStatusBarTexture(C.media.texture)
		bar:CreateBackdrop("Transparent")
		timerBar.styled = true
	end
end

----------------------------------------------------------------------------------------
--	Skin and hook all trackers
----------------------------------------------------------------------------------------
for i = 1, #headers do
	local header = headers[i].Header
	if header then
		header.Background:SetTexture(nil)
	end

	local tracker = headers[i]
	if tracker then
		hooksecurefunc(tracker, "AddBlock", SkinQuestIcons)
		hooksecurefunc(tracker, "GetProgressBar", SkinProgressBar)
		hooksecurefunc(tracker, "GetTimerBar", SkinTimer)

		hooksecurefunc(tracker, "OnBlockHeaderClick", function(_, block)
			if IsControlKeyDown() then
				Menu.GetManager():HandleESC()
				QuestMapQuestOptions_AbandonQuest(block.id)
			elseif IsAltKeyDown() and C_QuestLog.IsPushableQuest(block.id) then
				Menu.GetManager():HandleESC()
				QuestMapQuestOptions_ShareQuest(block.id)
			end
		end)

		hooksecurefunc(tracker, "OnBlockHeaderEnter", function(_, block)
			if T.IsFramePositionedLeft(ObjectiveTrackerFrame) then
				GameTooltip:ClearAllPoints()
				GameTooltip:SetPoint("TOPLEFT", block, "TOPRIGHT", 0, 0)
				GameTooltip:Show()
			end
		end)
	end
end

----------------------------------------------------------------------------------------
--	Set tooltip depending on position
----------------------------------------------------------------------------------------
ScenarioObjectiveTracker.StageBlock:HookScript("OnEnter", function(self)
	if T.IsFramePositionedLeft(ObjectiveTrackerFrame) then
		GameTooltip:ClearAllPoints()
		GameTooltip:SetPoint("TOPLEFT", self, "TOPRIGHT", 50, -3)
	end
end)

----------------------------------------------------------------------------------------
--	Skin ScenarioStageBlock
----------------------------------------------------------------------------------------
hooksecurefunc(ScenarioObjectiveTracker.StageBlock, "UpdateStageBlock", function(block)
	if not block.backdrop then
		block:CreateBackdrop("Overlay")
		block.backdrop:SetPoint("TOPLEFT", block.NormalBG, 3, -3)
		block.backdrop:SetPoint("BOTTOMRIGHT", block.NormalBG, -6, 5)

		block.NormalBG:SetAlpha(0)
		block.FinalBG:SetAlpha(0)
		block.GlowTexture:SetTexture("")
	end
end)

----------------------------------------------------------------------------------------
--	Skin ScenarioStageBlock
----------------------------------------------------------------------------------------
hooksecurefunc(ScenarioObjectiveTracker.ChallengeModeBlock, "Activate", function(block)
	if not block.backdrop then
		block:CreateBackdrop("Overlay")
		block.backdrop:SetPoint("TOPLEFT", block, 3, -3)
		block.backdrop:SetPoint("BOTTOMRIGHT", block, -6, 3)
		block.backdrop.overlay:SetVertexColor(0.12, 0.12, 0.12, 1)

		local bg = select(3, block:GetRegions())
		bg:SetAlpha(0)

		block.TimerBGBack:SetAlpha(0)
		block.TimerBG:SetAlpha(0)

		block.StatusBar:SetStatusBarTexture(C.media.texture)
		block.StatusBar:CreateBackdrop("Overlay")
		block.StatusBar.backdrop:SetFrameLevel(block.backdrop:GetFrameLevel() + 1)
		block.StatusBar:SetStatusBarColor(0, 0.6, 1)
		block.StatusBar:SetFrameLevel(block.StatusBar:GetFrameLevel() + 3)
	end
end)

hooksecurefunc(ScenarioObjectiveTracker.ChallengeModeBlock, "SetUpAffixes", function(self)
	for frame in self.affixPool:EnumerateActive() do
		frame.Border:SetTexture(nil)
		frame.Portrait:SetTexture(nil)
		if not frame.styled then
			frame.Portrait:SkinIcon()
			frame.styled = true
		end

		if frame.info then
			frame.Portrait:SetTexture(CHALLENGE_MODE_EXTRA_AFFIX_INFO[frame.info.key].texture)
		elseif frame.affixID then
			local _, _, filedataid = C_ChallengeMode.GetAffixInfo(frame.affixID)
			frame.Portrait:SetTexture(filedataid)
		end
	end
end)

hooksecurefunc(ScenarioObjectiveTracker.StageBlock, "UpdateWidgetRegistration", function(self)
	local widgetContainer = self.WidgetContainer
	if widgetContainer.widgetFrames then
		for _, widgetFrame in pairs(widgetContainer.widgetFrames) do
			if widgetFrame.Frame then widgetFrame.Frame:SetAlpha(0) end

			local bar = widgetFrame.TimerBar
			if bar and not bar.styled then
				bar:SetStatusBarTexture(C.media.texture)
				bar:CreateBackdrop("Overlay")
				bar:SetStatusBarColor(0, 0.6, 1)
				bar:SetFrameLevel(bar:GetFrameLevel() + 3)
				bar.styled = true
			end

			if widgetFrame.CurrencyContainer then
				for currencyFrame in widgetFrame.currencyPool:EnumerateActive() do
					if not currencyFrame.styled then
						currencyFrame.Icon:SkinIcon()
						currencyFrame.styled = true
					end
				end
			end
		end
	end
end)

----------------------------------------------------------------------------------------
--	Skin MawBuffsBlock
----------------------------------------------------------------------------------------
local Maw = ScenarioObjectiveTracker.MawBuffsBlock.Container
Maw:SkinButton()
Maw:SetPoint("TOPRIGHT", ScenarioObjectiveTracker.MawBuffsBlock, "TOPRIGHT", -23, 0)
Maw.List.button:SetSize(234, 30)
Maw.List:StripTextures()
Maw.List:SetTemplate("Overlay")

Maw.List:HookScript("OnShow", function(self)
	self.button:SetPushedTexture(0)
	self.button:SetHighlightTexture(0)
	self.button:SetWidth(234)
	self.button:SetButtonState("NORMAL")
	self.button:SetPushedTextOffset(0, 0)
	self.button:SetButtonState("PUSHED", true)
end)

Maw.List:HookScript("OnHide", function(self)
	self.button:SetPushedTexture(0)
	self.button:SetHighlightTexture(0)
	self.button:SetWidth(234)
end)

Maw:HookScript("OnClick", function(container)
	container.List:ClearAllPoints()
	if T.IsFramePositionedLeft(ObjectiveTrackerFrame) then
		container.List:SetPoint("TOPLEFT", container, "TOPRIGHT", 30, 1)
	else
		container.List:SetPoint("TOPRIGHT", container, "TOPLEFT", -15, 1)
	end
end)

----------------------------------------------------------------------------------------
--	Ctrl+Click to abandon a quest or Alt+Click to share a quest(by Suicidal Katt)
----------------------------------------------------------------------------------------
hooksecurefunc("QuestMapLogTitleButton_OnClick", function(self)
	if IsControlKeyDown() then
		Menu.GetManager():HandleESC()
		QuestMapQuestOptions_AbandonQuest(self.questID)
	elseif IsAltKeyDown() and C_QuestLog.IsPushableQuest(self.questID) then
		Menu.GetManager():HandleESC()
		QuestMapQuestOptions_ShareQuest(self.questID)
	end
end)
local T, C, L = unpack(ShestakUI)
if C.skins.blizzard_frames ~= true then return end

----------------------------------------------------------------------------------------
--	Cooldown Viewer skin
----------------------------------------------------------------------------------------
local function LoadSkin()
	local frame = _G.CooldownViewerSettings
	T.SkinFrame(frame)

	local tabs = {
		frame.SpellsTab,
		frame.AurasTab
	}
	for _, tab in pairs(tabs) do
		T.SkinFrameTab(tab)
	end

	T.SkinEditBox(frame.SearchBox)
	frame.SearchBox.backdrop:SetOutside(nil, 2, -4)
	T.SkinScrollBar(frame.CooldownScroll.ScrollBar)
	frame.UndoButton:SkinButton()

	local oldAtlas = {
		Options_ListExpand_Right = 1,
		Options_ListExpand_Right_Expanded = 1
	}

	local function updateCollapse(texture, atlas)
		if not atlas or oldAtlas[atlas] then
			if not atlas or atlas == "Options_ListExpand_Right_Expanded" then
				texture:SetAtlas("Soulbinds_Collection_CategoryHeader_Collapse")
			else
				texture:SetAtlas("Soulbinds_Collection_CategoryHeader_Expand")
			end
		end
	end

	local function SkinHeaders(header)
		if header and not header.IsSkinned then
			header:StripTextures()
			header:CreateBackdrop("Overlay")
			header.backdrop:SetPoint("TOPLEFT", 2, 0)
			header.backdrop:SetPoint("BOTTOMRIGHT", -2, -2)
			updateCollapse(header.Right)
			updateCollapse(header.HighlightRight)

			hooksecurefunc(header.Right, "SetAtlas", updateCollapse)
			hooksecurefunc(header.HighlightRight, "SetAtlas", updateCollapse)

			header.IsSkinned = true
		end
	end

	local function SkinSettingItem(item)
		if item.IsSkinned then return end

		local icon = item.Icon
		if icon then
			local highlight = item.Highlight
			if highlight then
				highlight:SetColorTexture(1, 1, 1, 0.3)
				highlight:SetAllPoints(icon)
			end

			icon:SkinIcon()
		end

		local bar = item.Bar
		if bar then
			bar:SetStatusBarTexture(C.media.texture)

			for _, region in next, {bar:GetRegions()} do
				if region:IsObjectType("Texture") then
					local atlas = region:GetAtlas()

					if atlas == "UI-HUD-CoolDownManager-Bar" then
						region:SetPoint("TOPLEFT", 1, 0)
						region:SetPoint("BOTTOMLEFT", -1, 0)
					elseif atlas == "UI-HUD-CoolDownManager-Bar-BG" and not region.backdrop then
						region:SetAlpha(0)
						region:CreateBackdrop("Transparent")
					end
				end
			end
		end

		item.IsSkinned = true
	end

	local function HandleSettingItemPool(self)
		for frame in self:EnumerateActive() do
			SkinSettingItem(frame)
		end
	end

	local hookedItemPools = {}

	local function RefreshLayout()
		local CooldownViewer = _G.CooldownViewerSettings
		if not CooldownViewer or not CooldownViewer.CooldownScroll then return end

		local content = CooldownViewer.CooldownScroll.Content
		if not content then return end

		for _, child in next, {content:GetChildren()} do
			local header = child.Header
			if header and not header.IsSkinned then
				SkinHeaders(child.Header)
			end

			local itemPool = child.itemPool
			if itemPool and not hookedItemPools[itemPool] then
				hookedItemPools[itemPool] = true

				HandleSettingItemPool(itemPool)

				hooksecurefunc(itemPool, "Acquire", HandleSettingItemPool)
			end
		end
	end

	RefreshLayout()
	hooksecurefunc(frame, "RefreshLayout", RefreshLayout)

	-- Tracker
	local function UpdateTextContainer(container)
		local countText = container.Applications and container.Applications.Applications
		if countText then
			countText:SetFont(C.font.cooldown_timers_font, C.font.cooldown_timers_font_size, C.font.cooldown_timers_font_style)
			countText:SetShadowOffset(C.font.cooldown_timers_font_shadow and 1 or 0, C.font.cooldown_timers_font_shadow and -1 or 0)
		end

		local chargeText = container.ChargeCount and container.ChargeCount.Current
		if chargeText then
			chargeText:SetFont(C.font.cooldown_timers_font, C.font.cooldown_timers_font_size, C.font.cooldown_timers_font_style)
			chargeText:SetShadowOffset(C.font.cooldown_timers_font_shadow and 1 or 0, C.font.cooldown_timers_font_shadow and -1 or 0)
		end
	end

	local function UpdateTextBar(bar)
		if bar.Name then
			bar.Name:SetFont(C.font.filger_font, C.font.filger_font_size, C.font.filger_font_style)
			bar.Name:SetShadowOffset(C.font.filger_font_shadow and 1 or 0, C.font.filger_font_shadow and -1 or 0)
		end

		if bar.Duration then
			bar.Duration:SetFont(C.font.filger_font, C.font.filger_font_size, C.font.filger_font_style)
			bar.Duration:SetShadowOffset(C.font.filger_font_shadow and 1 or 0, C.font.filger_font_shadow and -1 or 0)
		end
	end

	local function SkinIcon(container, icon)
		UpdateTextContainer(container)
		icon:SkinIcon()

		for _, region in next, {container:GetRegions()} do
			if region:IsObjectType("Texture") then
				local texture = region:GetTexture()
				local atlas = region:GetAtlas()

				if texture == 6707800 then
					region:SetTexture(C.media.blank)
				elseif atlas == "UI-HUD-CoolDownManager-IconOverlay" then -- 6704514
					region:SetAlpha(0)
				end
			end
		end
	end

	local function SkinBar(frame, bar)
		UpdateTextBar(bar)
		bar:SetStatusBarTexture(C.media.texture)

		if frame.Icon then
			frame.Icon.Icon:ClearAllPoints()
			frame.Icon.Icon:SetPoint("BOTTOMRIGHT", bar, "BOTTOMLEFT", -7, 0)
			frame.Icon.Icon:SetSize(26, 26)
			SkinIcon(frame.Icon, frame.Icon.Icon)
		end

		for _, region in next, {bar:GetRegions()} do
			if region:IsObjectType("Texture") then
				local atlas = region:GetAtlas()

				if atlas == "UI-HUD-CoolDownManager-Bar" then
					region:SetPoint("TOPLEFT", 1, 0)
					region:SetPoint("BOTTOMLEFT", -1, 0)
				elseif atlas == "UI-HUD-CoolDownManager-Bar-BG" and not region.backdrop then
					region:SetAlpha(0)
					region:CreateBackdrop("Transparent")
				end
			end
		end
	end

	local function SetTimerShown(self)
		if self.Cooldown then
			local text = self.Cooldown:GetRegions()
			text:SetFont(C.font.cooldown_timers_font, C.font.cooldown_timers_font_size, C.font.cooldown_timers_font_style)
			text:SetShadowOffset(C.font.cooldown_timers_font_shadow and 1 or 0, C.font.cooldown_timers_font_shadow and -1 or 0)
			text:ClearAllPoints()
			text:SetPoint("LEFT", -2, 0)
			text:SetPoint("RIGHT", 3, 0)
		end
	end

	local hookFunctions = {
		SetTimerShown = SetTimerShown
	}

	local function SkinItemFrame(frame)
		if frame.Cooldown then
			frame.Cooldown:SetSwipeTexture(C.media.blank)

			if not frame.Cooldown.done then

				for key, func in next, hookFunctions do
					if frame[key] then
						hooksecurefunc(frame, key, func)
					end
				end
				frame.Cooldown.done = true
			end
		end

		if frame.Bar then
			SkinBar(frame, frame.Bar)
		elseif frame.Icon then
			SkinIcon(frame, frame.Icon)
		end
	end

	local function AcquireItemFrame(frame)
		SkinItemFrame(frame)
	end

	local function HandleViewer(element)
		hooksecurefunc(element, "OnAcquireItemFrame", AcquireItemFrame)

		for frame in element.itemFramePool:EnumerateActive() do
			SkinItemFrame(frame)
		end
	end

	HandleViewer(_G.UtilityCooldownViewer)
	HandleViewer(_G.BuffBarCooldownViewer)
	HandleViewer(_G.BuffIconCooldownViewer)
	HandleViewer(_G.EssentialCooldownViewer)
end

T.SkinFuncs["Blizzard_CooldownViewer"] = LoadSkin
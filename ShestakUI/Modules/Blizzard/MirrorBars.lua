local T, C, L = unpack(ShestakUI)
if C.unitframe.unit_castbar ~= true or C.unitframe.enable ~= true then return end

----------------------------------------------------------------------------------------
--	Mirror Timers (Underwater Breath, etc.) [from ElvUI]
----------------------------------------------------------------------------------------
local position = {
	BREATH = -96;
	EXHAUSTION = -116;
	FEIGNDEATH = -142;
}

local loadPosition = function(self, timer)
	local y = position[timer] or -96

	return self:SetPoint("TOP", UIParent, "TOP", 0, y)
end

local colors = {
	EXHAUSTION = {1, 0.9, 0};
	BREATH = {0.31, 0.45, 0.63};
	DEATH = {1, 0.7, 0};
	FEIGNDEATH = {0.3, 0.7, 0};
}

local function SetupTimer(container, timer)
	local bar = container:GetAvailableTimer(timer)
	if not bar then return end

	if not bar.atlasHolder then
		bar.atlasHolder = CreateFrame("Frame", nil, bar)
		bar.atlasHolder:SetClipsChildren(true)
		bar.atlasHolder:SetInside()

		bar.StatusBar:SetParent(bar.atlasHolder)
		bar.StatusBar:ClearAllPoints()
		bar.StatusBar:SetSize(281, 16)
		bar.StatusBar:SetPoint("TOP", 0, -2)

		bar.Text:SetFont(C.media.pixel_font, C.media.pixel_font_size, C.media.pixel_font_style)
		bar.Text:SetShadowOffset(0, 0)
		bar.Text:ClearAllPoints()
		bar.Text:SetParent(bar.StatusBar)
		bar.Text:SetPoint("CENTER", bar.StatusBar, 0, 0)

		bar:SetSize(289, 23)
		bar:StripTextures()
		bar:CreateBackdrop("Overlay")
		bar.backdrop:SetPoint("TOPLEFT", 2, -2)
		bar.backdrop:SetPoint("BOTTOMRIGHT", -2, 1)

		bar:ClearAllPoints()
		loadPosition(bar, timer)
	end

	local r, g, b = unpack(colors[timer])
	bar.StatusBar:SetStatusBarTexture(C.media.texture)
	bar.StatusBar:SetStatusBarColor(r, g, b)
end

hooksecurefunc(_G.MirrorTimerContainer, "SetupTimer", SetupTimer)
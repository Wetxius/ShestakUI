local T, C, L = unpack(ShestakUI)
if C.skins.blizzard_frames ~= true then return end

----------------------------------------------------------------------------------------
--	TimeManager skin
----------------------------------------------------------------------------------------
local function LoadSkin()
	TimeManagerFrame:StripTextures()
	TimeManagerFrame:CreateBackdrop("Transparent")
	TimeManagerFrame.backdrop:SetPoint("TOPLEFT", -3, 0)
	TimeManagerFrame.backdrop:SetPoint("BOTTOMRIGHT", -3, 3)
	TimeManagerFrameInset:StripTextures()

	T.SkinCloseButton(TimeManagerFrameCloseButton, TimeManagerFrame.backdrop)

	T.SkinDropDownBox(TimeManagerAlarmTimeFrame.HourDropdown, 79)
	T.SkinDropDownBox(TimeManagerAlarmTimeFrame.MinuteDropdown, 79)
	T.SkinDropDownBox(TimeManagerAlarmTimeFrame.AMPMDropdown, 70)

	T.SkinEditBox(TimeManagerAlarmMessageEditBox)

	T.SkinCheckBox(TimeManagerAlarmEnabledButton)
	T.SkinCheckBox(TimeManagerMilitaryTimeCheck)
	T.SkinCheckBox(TimeManagerLocalTimeCheck)

	TimeManagerStopwatchFrame:StripTextures()
	TimeManagerStopwatchCheck:StyleButton(true)
	TimeManagerStopwatchCheck:SetTemplate("Default")
	TimeManagerStopwatchCheck:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
	TimeManagerStopwatchCheck:GetNormalTexture():ClearAllPoints()
	TimeManagerStopwatchCheck:GetNormalTexture():SetPoint("TOPLEFT", 2, -2)
	TimeManagerStopwatchCheck:GetNormalTexture():SetPoint("BOTTOMRIGHT", -2, 2)

	StopwatchFrame:StripTextures()
	StopwatchFrame:CreateBackdrop("Transparent")
	StopwatchFrame.backdrop:SetPoint("TOPLEFT", 2, -15)
	StopwatchFrame.backdrop:SetPoint("BOTTOMRIGHT", -2, 2)

	StopwatchTabFrame:StripTextures()

	local function skinButton(btn)
		btn:SetTemplate("Overlay")
		btn:SetSize(17, 17)

		btn:GetNormalTexture():SetTexCoord(0.25, 0.72, 0.28, 0.78)
		btn:GetNormalTexture():ClearAllPoints()
		btn:GetNormalTexture():SetPoint("TOPLEFT", 2, -2)
		btn:GetNormalTexture():SetPoint("BOTTOMRIGHT", -2, 2)
		if btn:GetDisabledTexture() then
			btn:GetDisabledTexture():SetAllPoints(btn:GetNormalTexture())
		end
		if btn:GetPushedTexture() then
			btn:GetPushedTexture():SetAllPoints(btn:GetNormalTexture())
		end
		if btn:GetHighlightTexture() then
			btn:GetHighlightTexture():SetColorTexture(1, 1, 1, 0.3)
			btn:GetHighlightTexture():SetAllPoints(btn:GetNormalTexture())
		end
	end

	skinButton(StopwatchPlayPauseButton)
	skinButton(StopwatchResetButton)
	StopwatchResetButton:SetPoint("BOTTOMRIGHT", StopwatchFrame, "BOTTOMRIGHT", -7, 7)
	StopwatchPlayPauseButton:SetPoint("RIGHT", StopwatchResetButton, "LEFT", -4, 0)

	T.SkinCloseButton(StopwatchCloseButton)
	StopwatchCloseButton:ClearAllPoints()
	StopwatchCloseButton:SetPoint("BOTTOMRIGHT", StopwatchFrame.backdrop, "TOPRIGHT", 0, 3)
end

T.SkinFuncs["Blizzard_TimeManager"] = LoadSkin
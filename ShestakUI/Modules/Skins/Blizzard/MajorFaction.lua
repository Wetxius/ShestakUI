local T, C, L = unpack(ShestakUI)
if C.skins.blizzard_frames ~= true then return end

----------------------------------------------------------------------------------------
--	Major Factions skin
----------------------------------------------------------------------------------------
local function LoadSkin()
	if T.newPatch then return end -- BETA not work
	local frame = _G.MajorFactionRenownFrame

	T.SkinFrame(frame)
	MajorFactionRenownFrame.CloseButton.SetPoint = T.dummy
	frame.Background:SetAlpha(0)

	if frame.LevelSkipButton then
		frame.LevelSkipButton:SkinButton()
	end

	hooksecurefunc(frame, "SetUpMajorFactionData", function()
		if frame.Divider then frame.Divider:Hide() end
		if frame.NineSlice then frame.NineSlice:Hide() end
		if frame.Border then frame.Border:Hide() end
		if frame.TopLeftBorderDecoration then frame.TopLeftBorderDecoration:Hide() end
		if frame.TopRightBorderDecoration then frame.TopRightBorderDecoration:Hide() end
		if frame.Background then frame.Background:Hide() end
		if frame.BackgroundShadow then frame.BackgroundShadow:Hide() end
		if frame.CloseButton.Border then frame.CloseButton.Border:Hide() end
	end)
end

T.SkinFuncs["Blizzard_MajorFactions"] = LoadSkin
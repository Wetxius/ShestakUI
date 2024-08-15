local T, C, L = unpack(ShestakUI)
if C.skins.rarescanner ~= true then return end

----------------------------------------------------------------------------------------
--	RareScanner skin
----------------------------------------------------------------------------------------
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function()
	if not C_AddOns.IsAddOnLoaded("RareScanner") then return end
	local button = RARESCANNER_BUTTON or scanner_button
	if not button then return end
	button:StripTextures()
	button:CreateBackdrop("Transparent")

	button.FilterEntityButton:SkinButton()
	button.FilterEntityButton:SetNormalTexture([[Interface\WorldMap\Dash_64Grey]])
	button.FilterEntityButton:ClearAllPoints()
	button.FilterEntityButton:SetPoint("TOPLEFT", 2, -2)
	button.UnfilterEnabledButton:SkinButton()
	button.FilterEnabledTexture:SetTexture([[Interface\WorldMap\Skull_64]])
	button.UnfilterEnabledButton:ClearAllPoints()
	button.UnfilterEnabledButton:SetPoint("TOPLEFT", 2, -2)

	T.SkinCloseButton(button.CloseButton)
	button.CloseButton:ClearAllPoints()
	button.CloseButton:SetPoint("TOPRIGHT", -2, -2)
end)
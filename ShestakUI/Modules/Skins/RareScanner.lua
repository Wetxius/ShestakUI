local T, C, L = unpack(ShestakUI)
if C.skins.rarescanner ~= true then return end

----------------------------------------------------------------------------------------
--	RareScanner skin
----------------------------------------------------------------------------------------
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function()
	if not C_AddOns.IsAddOnLoaded("RareScanner") then return end
	scanner_button:StripTextures()
	scanner_button:CreateBackdrop("Transparent")

	scanner_button.FilterEntityButton:SkinButton()
	scanner_button.FilterEntityButton:SetNormalTexture([[Interface\WorldMap\Dash_64Grey]])
	scanner_button.FilterEntityButton:ClearAllPoints()
	scanner_button.FilterEntityButton:SetPoint("TOPLEFT", 2, -2)
	scanner_button.UnfilterEnabledButton:SkinButton()
	scanner_button.FilterEnabledTexture:SetTexture([[Interface\WorldMap\Skull_64]])
	scanner_button.UnfilterEnabledButton:ClearAllPoints()
	scanner_button.UnfilterEnabledButton:SetPoint("TOPLEFT", 2, -2)

	T.SkinCloseButton(scanner_button.CloseButton)
	scanner_button.CloseButton:ClearAllPoints()
	scanner_button.CloseButton:SetPoint("TOPRIGHT", -2, -2)
end)
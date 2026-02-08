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
	button.FilterEntityButton.tex = button.FilterEntityButton:CreateTexture(nil, "OVERLAY")
	button.FilterEntityButton.tex:SetSize(5, 1)
	button.FilterEntityButton.tex:SetPoint("CENTER")
	button.FilterEntityButton.tex:SetTexture(C.media.blank)

	button.UnFilterEntityButton:SkinButton()
	button.UnFilterEntityButton.minus = button.UnFilterEntityButton:CreateTexture(nil, "OVERLAY")
	button.UnFilterEntityButton.minus:SetSize(5, 1)
	button.UnFilterEntityButton.minus:SetPoint("CENTER")
	button.UnFilterEntityButton.minus:SetTexture(C.media.blank)

	button.UnFilterEntityButton.plus = button.UnFilterEntityButton:CreateTexture(nil, "OVERLAY")
	button.UnFilterEntityButton.plus:SetSize(1, 5)
	button.UnFilterEntityButton.plus:SetPoint("CENTER")
	button.UnFilterEntityButton.plus:SetTexture(C.media.blank)

	button.CloseButton:SkinButton()
	button.CloseButton.text = button.CloseButton:FontString(nil, [[Interface\AddOns\ShestakUI\Media\Fonts\Pixel.ttf]], 8)
	button.CloseButton.text:SetPoint("CENTER", 0, 0)
	button.CloseButton.text:SetText("X")
end)
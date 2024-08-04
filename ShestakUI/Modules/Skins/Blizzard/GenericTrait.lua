local T, C, L = unpack(ShestakUI)
if C.skins.blizzard_frames ~= true then return end

----------------------------------------------------------------------------------------
--	Generic Trait skin
----------------------------------------------------------------------------------------
local function LoadSkin()
	local frame = _G.GenericTraitFrame
	T.SkinFrame(frame)

	frame.Background:SetAlpha(0)
	frame.BorderOverlay:SetAlpha(0)

	T.ReplaceIconString(frame.Currency.UnspentPointsCount)
	hooksecurefunc(frame.Currency.UnspentPointsCount, "SetText", T.ReplaceIconString)
end

T.SkinFuncs["Blizzard_GenericTraitUI"] = LoadSkin
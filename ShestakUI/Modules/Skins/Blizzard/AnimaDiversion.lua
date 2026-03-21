local T, C, L = unpack(ShestakUI)
if C.skins.blizzard_frames ~= true then return end

----------------------------------------------------------------------------------------
--	Anima Diversion skin
----------------------------------------------------------------------------------------
local function LoadSkin()
	local frame = AnimaDiversionFrame
	T.SkinCloseButton(frame.CloseButton)

	frame:StripTextures()
	frame:CreateBackdrop("Transparent")

	frame.AnimaDiversionCurrencyFrame.Background:SetAlpha(0)
	frame.ReinforceInfoFrame.AnimaNodeReinforceButton:SkinButton()

	hooksecurefunc(AnimaDiversionFrame, "SetupCurrencyFrame", function()
		local cur = AnimaDiversionFrame.AnimaDiversionCurrencyFrame.CurrencyFrame.Quantity

		T.ReplaceIconString(cur)
	end)
end

T.SkinFuncs["Blizzard_AnimaDiversionUI"] = LoadSkin
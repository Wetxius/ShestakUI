local T, C, L = unpack(ShestakUI)
if C.skins.blizzard_frames ~= true then return end

----------------------------------------------------------------------------------------
--	ItemInteractionUI skin
----------------------------------------------------------------------------------------
local function LoadSkin()
	T.SkinFrame(ItemInteractionFrame, true)

	ItemInteractionFrame.Background:SetAlpha(0)
	ItemInteractionFrame.ButtonFrame:StripTextures()
	ItemInteractionFrame.ButtonFrame.MoneyFrameEdge:StripTextures()

	local ItemSlot = ItemInteractionFrame.ItemSlot
	ItemSlot:StripTextures()

	ItemSlot:SetSize(58, 58)
	ItemSlot:ClearAllPoints()
	ItemSlot:SetPoint("TOPLEFT", 143, -97)

	ItemSlot.Icon:ClearAllPoints()
	ItemSlot.Icon:SetPoint("TOPLEFT", 1, -1)
	ItemSlot.Icon:SetPoint("BOTTOMRIGHT", -1, 1)
	ItemSlot.Icon:SkinIcon()

	for _, frame in pairs({ItemInteractionFrame.ItemConversionFrame.ItemConversionInputSlot, ItemInteractionFrame.ItemConversionFrame.ItemConversionOutputSlot}) do
		frame.ButtonFrame:SetAlpha(0)
		frame.icon:SkinIcon()
		frame.NormalTexture:SetInside(frame.backdrop)
		if frame.SelectedTexture then
			frame.SelectedTexture:SetColorTexture(1, 0.82, 0, 0.2)
			frame.SelectedTexture:SetInside(frame.backdrop)
		end
		if frame.HighlightTexture then
			frame.HighlightTexture:SetColorTexture(1, 1, 1, 0.2)
			frame.HighlightTexture:SetInside(frame.backdrop)
		end
		if frame.PushedTexture then
			frame.PushedTexture:SetColorTexture(0.9, 0.8, 0.1, 0.3)
			frame.PushedTexture:SetInside(frame.backdrop)
		end
	end

	ItemSlot.GlowOverlay:SetAlpha(0)

	ItemInteractionFrame.CurrencyCost.Currency.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	ItemInteractionFrame.ButtonFrame.Currency.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

	ItemInteractionFrame.ButtonFrame.ActionButton:SkinButton()
end

T.SkinFuncs["Blizzard_ItemInteractionUI"] = LoadSkin
local T, C, L = unpack(ShestakUI)
if C.skins.blizzard_frames ~= true then return end

----------------------------------------------------------------------------------------
--	ScrappingMachine skin
----------------------------------------------------------------------------------------
local function LoadSkin()
	local frame = ScrappingMachineFrame
	T.SkinFrame(frame)

	frame.ScrapButton:SkinButton()

	local ItemSlots = frame.ItemSlots
	ItemSlots:StripTextures()

	for _, button in next, {ItemSlots:GetChildren()} do
		if button.Icon and not button.styled then
			button:SetHighlightTexture(0)
			button.Icon:SkinIcon()
			T.SkinIconBorder(button.IconBorder)

			button.styled = true
		end
	end
end

T.SkinFuncs["Blizzard_ScrappingMachineUI"] = LoadSkin
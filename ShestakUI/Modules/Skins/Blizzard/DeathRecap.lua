local T, C, L = unpack(ShestakUI)
if C.skins.blizzard_frames ~= true then return end

----------------------------------------------------------------------------------------
--	DeathRecap skin
----------------------------------------------------------------------------------------
local function LoadSkin()
	DeathRecapFrame:StripTextures()
	DeathRecapFrame:SetTemplate("Transparent")
	DeathRecapFrame.CloseButton:SkinButton(true)
	T.SkinCloseButton(DeathRecapFrame.CloseXButton)

	T.SkinScrollBar(DeathRecapFrame.ScrollBar)

	local function updateEntry(button)
		local recap = button.SpellInfo
		if not recap or recap.styled then return end

		if recap.Icon then
			recap.Icon:SkinIcon()
			recap.Icon:SetSize(26, 26)
		end
		recap.IconBorder:Hide()

		recap.styled = true
	end

	hooksecurefunc(DeathRecapFrame.ScrollBox, "Update", function(self)
		self:ForEachFrame(updateEntry)
	end)
end

T.SkinFuncs["Blizzard_DeathRecap"] = LoadSkin
local T, C, L = unpack(ShestakUI)
if C.skins.blizzard_frames ~= true then return end

----------------------------------------------------------------------------------------
--	Delves skin
----------------------------------------------------------------------------------------
local function LoadSkin()
	local frame = _G.HousingDashboardFrame
	T.SkinFrame(frame)

	frame.HouseInfoContent.DashboardNoHousesFrame.NoHouseButton:SkinButton()

	local tabs = {
		frame.HouseInfoTabButton,
		frame.CatalogTabButton
	}
	for _, tab in pairs(tabs) do
		tab:SetSize(34, 44)

		tab:CreateBackdrop("Overlay")
		tab.backdrop:SetPoint("TOPLEFT", 2, -2)
		tab.backdrop:SetPoint("BOTTOMRIGHT", -2, 2)

		tab.Icon:SetInside(tab.backdrop)
		tab.Icon:SetTexCoord(0.18, 0.76, 0.18, 0.76)

		-- Hover texture
		for _, region in next, {tab:GetRegions()} do
			if region:IsObjectType("Texture") then
				if region:GetAtlas() == "QuestLog-Tab-side-Glow-hover" then
					region:SetPoint("TOPLEFT", 4, -4)
					region:SetPoint("BOTTOMRIGHT", -4, 4)
					region:SetColorTexture(1, 1, 1, 0.3)
				end
			end
		end
	end

	local content = HousingDashboardFrame.CatalogContent
	content:StripTextures()
	content.PreviewFrame:StripTextures()
	content.Categories:StripTextures()
	content.Categories.Background:SetAlpha(0)

	T.SkinEditBox(content.SearchBox)
	content.SearchBox.backdrop:SetOutside(nil, 2, -4)
	T.SkinFilter(content.Filters.FilterDropdown, true)

	T.SkinScrollBar(content.OptionsContainer.ScrollBar)

	for i = 1, 5 do
		local button = select(i, content.PreviewFrame.ModelSceneControls:GetChildren())
		if button.NormalTexture then
			button.NormalTexture:SetAlpha(0)
			button.PushedTexture:SetAlpha(0)
		end
	end
end

T.SkinFuncs["Blizzard_HousingDashboard"] = LoadSkin
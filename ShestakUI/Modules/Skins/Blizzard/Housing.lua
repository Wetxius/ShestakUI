local T, C, L = unpack(ShestakUI)
if C.skins.blizzard_frames ~= true then return end

----------------------------------------------------------------------------------------
--	Housing skin
----------------------------------------------------------------------------------------
local function LoadSkin()
	local frame = _G.HousingDashboardFrame
	T.SkinFrame(frame)

	frame.HouseInfoContent.DashboardNoHousesFrame.Background:SetInside(frame.HouseInfoContent.DashboardNoHousesFrame)
	frame.HouseInfoContent.DashboardNoHousesFrame.NoHouseButton:SkinButton(nil, "Text")

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

	frame.HouseInfoTabButton:SetPoint("TOPLEFT", frame, "TOPRIGHT", 1, -60)

	local content = frame.CatalogContent
	content:StripTextures()
	content.PreviewFrame:StripTextures()
	content.Categories:StripTextures()
	content.Categories.Background:SetAlpha(0)

	hooksecurefunc(content.OptionsContainer.ScrollBox, "Update", function(frame)
		for _, button in next, {frame.ScrollTarget:GetChildren()} do
			if not button.isSkinned then
				button:GetRegions():Hide()
				button:CreateBackdrop("Overlay")
				button.backdrop:SetPoint("TOPLEFT", 2, -2)
				button.backdrop:SetPoint("BOTTOMRIGHT", -2, 2)
				button:StyleButton(nil, 4)

				button.HoverBackground:SetAlpha(0)

				button.isSkinned = true
			end
		end
	end)

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

local function LoadNeighborhoodSkin()
	local frame = _G.HousingCreateNeighborhoodCharterFrame
	T.SkinFrame(frame)

	T.SkinEditBox(frame.NeighborhoodNameEditBox)
	frame.ConfirmButton:SkinButton(nil, "Text")
	frame.CancelButton:SkinButton(nil, "Text")

	-- local ConfirmationFrame = frame.ConfirmationFrame
	-- ConfirmationFrame:StripTextures()
	-- ConfirmationFrame:SetTemplate()
	-- ConfirmationFrame.ConfirmButton:SkinButton()
	-- ConfirmationFrame.CancelButton:SkinButton()
end

T.SkinFuncs["Blizzard_HousingCreateNeighborhood"] = LoadNeighborhoodSkin

local function LoadModelPreviewSkin()
	local frame = _G.HousingModelPreviewFrame
	T.SkinFrame(frame)
end

T.SkinFuncs["Blizzard_HousingModelPreview"] = LoadModelPreviewSkin
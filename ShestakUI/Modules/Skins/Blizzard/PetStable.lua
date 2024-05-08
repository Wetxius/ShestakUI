local T, C, L = unpack(ShestakUI)
if C.skins.blizzard_frames ~= true then return end

----------------------------------------------------------------------------------------
--	PetStable skin
----------------------------------------------------------------------------------------
local function LoadSkin()
	local frame = StableFrame
	T.SkinFrame(frame)

	local list = StableFrame.StabledPetList
	list:StripTextures()
	list.ListCounter:StripTextures()

	T.SkinEditBox(list.FilterBar.SearchBox, nil, 20)
	list.FilterBar.FilterButton:SkinButton()
	T.SkinCloseButton(list.FilterBar.FilterButton.ResetButton)
	list.FilterBar.FilterButton.ResetButton:ClearAllPoints()
	list.FilterBar.FilterButton.ResetButton:SetPoint("CENTER", list.FilterBar.FilterButton, "TOPRIGHT", 0, 0)
	T.SkinScrollBar(list.ScrollBar)

	hooksecurefunc(StableFrame.PetModelScene.PetInfo.Type, "SetText", T.ReplaceIconString)

	local list = StableFrame.PetModelScene.AbilitiesList
	if list then
		hooksecurefunc(list, "Layout", function(self)
			for frame in self.abilityPool:EnumerateActive() do
				if not frame.styled then
					frame.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
					frame.styled = true
				end
			end
		end)
	end
	T.SkinModelControl(StableFrame.PetModelScene)

	StableFrame.StableTogglePetButton:SkinButton()
	StableFrame.ReleasePetButton:SkinButton()
end

tinsert(T.SkinFuncs["ShestakUI"], LoadSkin)
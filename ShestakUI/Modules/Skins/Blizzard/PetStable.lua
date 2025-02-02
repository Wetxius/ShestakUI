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

	StableFrame.MainHelpButton.Ring:Hide()
	StableFrame.MainHelpButton:SetPoint("TOPLEFT", StableFrame, "TOPLEFT", -10, 15)

	T.SkinEditBox(list.FilterBar.SearchBox, nil, 20)
	T.SkinFilter(list.FilterBar.FilterDropdown, true)
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

	if T.newPatch then
		T.SkinDropDownBox(StableFrame.PetModelScene.PetInfo.Specialization)
	end

	StableFrame.StableTogglePetButton:SkinButton()
	StableFrame.ReleasePetButton:SkinButton()
end

tinsert(T.SkinFuncs["ShestakUI"], LoadSkin)
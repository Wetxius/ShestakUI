local T, C, L = unpack(ShestakUI)
if C.skins.blizzard_frames ~= true then return end

----------------------------------------------------------------------------------------
--	AddonList skin
----------------------------------------------------------------------------------------
local function LoadSkin()
	local buttons = {
		AddonList.EnableAllButton,
		AddonList.DisableAllButton,
		AddonList.CancelButton,
		AddonList.OkayButton
	}

	for i = 1, #buttons do
		local frame = buttons[i]
		if frame then
			frame:SkinButton()
		end
	end

	AddonList.OkayButton:SetWidth(90)

	AddonList:StripTextures()
	AddonList:SetTemplate("Transparent")
	AddonList:SetHeight(AddonList:GetHeight() + 3)

	AddonListInset:StripTextures()
	AddonListInset:SetTemplate("Overlay")
	AddonListInset:SetPoint("BOTTOMRIGHT", -6, 29)

	local function forceSaturation(self, _, force)
		if force then return end
		self:SetVertexColor(0.6, 0.6, 0.6)
		self:SetDesaturated(true, true)
	end

	hooksecurefunc("AddonList_InitAddon", function(child)
		if not child.styled then
			T.SkinCheckBox(child.Enabled)
			child.LoadAddonButton:SkinButton()
			hooksecurefunc(child.Enabled:GetCheckedTexture(), "SetDesaturated", forceSaturation)

			T.ReplaceIconString(child.Title)
			hooksecurefunc(child.Title, "SetText", T.ReplaceIconString)

			child.styled = true
		end
	end)

	T.SkinScrollBar(AddonList.ScrollBar)
	T.SkinCloseButton(AddonListCloseButton)
	T.SkinDropDownBox(AddonList.Dropdown)
	T.SkinCheckBox(AddonList.ForceLoad)
	AddonList.ForceLoad:SetSize(25, 25)
	T.SkinEditBox(AddonList.SearchBox)
end

tinsert(T.SkinFuncs["ShestakUI"], LoadSkin)
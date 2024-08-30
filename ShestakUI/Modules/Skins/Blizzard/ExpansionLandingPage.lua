local T, C, L = unpack(ShestakUI)
if C.skins.blizzard_frames ~= true then return end

----------------------------------------------------------------------------------------
--	Expansion Landing Page skin
----------------------------------------------------------------------------------------
local function LoadSkin(self)
	local overlay = _G.ExpansionLandingPage.Overlay
	if overlay then
		for _, child in next, {overlay:GetChildren()} do
			child:StripTextures()
			child:SetTemplate("Transparent")

			if child.ScrollFadeOverlay then
				child.ScrollFadeOverlay:Hide()
			end

			if child.DragonridingPanel then
				child.DragonridingPanel.SkillsButton:SkinButton()
			end

			if child.CloseButton then
				T.SkinCloseButton(child.CloseButton)
			end
		end

		local landingOverlay = overlay.WarWithinLandingOverlay
		if landingOverlay then
			T.SkinCloseButton(landingOverlay.CloseButton)
		end
	end

	self:UnregisterEvent("ADDON_LOADED")
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self)
	if C_AddOns.IsAddOnLoaded("Skinner") or C_AddOns.IsAddOnLoaded("Aurora") then
		self:UnregisterEvent("ADDON_LOADED")
		return
	end
	if ExpansionLandingPage then
		LoadSkin(self)
	end
end)
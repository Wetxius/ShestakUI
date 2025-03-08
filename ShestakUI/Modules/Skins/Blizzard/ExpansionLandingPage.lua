local T, C, L = unpack(ShestakUI)
if C.skins.blizzard_frames ~= true then return end

----------------------------------------------------------------------------------------
--	Expansion Landing Page skin
----------------------------------------------------------------------------------------
local function LoadSkin()
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

		if overlay.DragonflightLandingOverlay and overlay.DragonflightLandingOverlay.MajorFactionList and overlay.DragonflightLandingOverlay.MajorFactionList.ScrollBar then
			T.SkinScrollBar(overlay.DragonflightLandingOverlay.MajorFactionList.ScrollBar)
		end

		local landingOverlay = overlay.WarWithinLandingOverlay
		if landingOverlay then
			T.SkinCloseButton(landingOverlay.CloseButton)
		end
	end
end

T.SkinFuncs["Blizzard_ExpansionLandingPage"] = LoadSkin
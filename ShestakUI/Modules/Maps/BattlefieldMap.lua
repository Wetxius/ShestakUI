local T, C, L = unpack(ShestakUI)
if C.minimap.bg_map_stylization ~= true or IsAddOnLoaded("Capping") or IsAddOnLoaded("Aurora") or IsAddOnLoaded("EnhanceBattlefieldMinimap") then return end

----------------------------------------------------------------------------------------
--	BattlefieldMap style
----------------------------------------------------------------------------------------
local tinymap = CreateFrame("Frame", "UIZoneMap", UIParent)
tinymap:Hide()

tinymap:RegisterEvent("ADDON_LOADED")
tinymap:SetScript("OnEvent", function(_, _, addon)
	if addon ~= "Blizzard_BattlefieldMap" then return end

	local frame = BattlefieldMapFrame
	frame:SetSize(223, 150)
	frame:CreateBackdrop("ClassColor")
	frame.backdrop:SetBackdropColor(C.media.backdrop_color[1], C.media.backdrop_color[2], C.media.backdrop_color[3], C.media.backdrop_alpha)
	frame.backdrop:SetPoint("TOPLEFT", -2, 4)
	frame.backdrop:SetPoint("BOTTOMRIGHT", 0, 1)

	frame.BorderFrame:DisableDrawLayer("BORDER")
	frame.BorderFrame:DisableDrawLayer("ARTWORK")

	frame.BorderFrame.CloseButton:Hide()

	frame:SetClampedToScreen(true)

	frame:SetScript("OnUpdate", _G.MapCanvasMixin.OnUpdate)
	T.SkinSlider(OpacityFrameSlider)

	frame.ScrollContainer:HookScript("OnMouseUp", function(_, btn)
		if btn == "LeftButton" then
			BattlefieldMapTab:StopMovingOrSizing()
		elseif btn == "RightButton" then
			BattlefieldMapTab:Click("RightButton")
		end
		if OpacityFrame and OpacityFrame:IsShown() then OpacityFrame:Hide() end
	end)

	frame.ScrollContainer:HookScript("OnMouseDown", function(_, btn)
		if btn == "LeftButton" and (BattlefieldMapOptions and not BattlefieldMapOptions.locked) then
			BattlefieldMapTab:StartMoving()
		end
	end)
end)
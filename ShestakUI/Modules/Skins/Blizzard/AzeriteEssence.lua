local T, C, L = unpack(ShestakUI)
if C.skins.blizzard_frames ~= true then return end

----------------------------------------------------------------------------------------
--	AzeriteEssenceUI skin
----------------------------------------------------------------------------------------
local function LoadSkin()
	T.SkinFrame(AzeriteEssenceUI)
	T.SkinScrollBar(AzeriteEssenceUI.EssenceList.ScrollBar)

	AzeriteEssenceUI.PowerLevelBadgeFrame:ClearAllPoints()
	AzeriteEssenceUI.PowerLevelBadgeFrame:SetPoint("TOPLEFT")
	AzeriteEssenceUI.PowerLevelBadgeFrame.Ring:Hide()
	AzeriteEssenceUI.PowerLevelBadgeFrame.BackgroundBlack:Hide()

	hooksecurefunc(AzeriteEssenceUI.EssenceList.ScrollBox, "Update", function(self)
		self:ForEachFrame(function(button)
			if not button.bg then
				button:StyleButton(nil, 3)

				button.bg = CreateFrame("Frame", nil, button)
				button.bg:CreateBackdrop("Overlay")
				button.bg:SetFrameLevel(button:GetFrameLevel() - 1)
				button.bg:SetPoint("TOPLEFT", 3, -3)
				button.bg:SetPoint("BOTTOMRIGHT", -3, 3)

				if button.Icon then
					button:DisableDrawLayer("ARTWORK")
					button.Icon:SkinIcon()
					button.Icon:SetSize(27, 27)
					button.Icon:SetPoint("LEFT", button, "LEFT", 6, 0)
				else
					button:DisableDrawLayer("BACKGROUND")
					button:DisableDrawLayer("BORDER")
				end

				if button.PendingGlow then
					button.PendingGlow:SetColorTexture(0.9, 0.8, 0.1, 0.3)
					button.PendingGlow:SetInside(button.bg.backdrop)
				end
			end
		end)
	end)
end

T.SkinFuncs["Blizzard_AzeriteEssenceUI"] = LoadSkin
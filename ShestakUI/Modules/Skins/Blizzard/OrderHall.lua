local T, C, L = unpack(ShestakUI)
if C.skins.blizzard_frames ~= true then return end

----------------------------------------------------------------------------------------
--	OrderHallUI skin
----------------------------------------------------------------------------------------
local function LoadSkin()
	-- TalentFrame skin from ElvUI
	local function colorBorder(child, backdrop, atlas)
		if child.AlphaIconOverlay:IsShown() then -- isBeingResearched or (talentAvailability and not selected)
			local alpha = child.AlphaIconOverlay:GetAlpha()
			if alpha <= 0.5 then -- talentAvailability
				backdrop:SetBackdropBorderColor(0.5, 0.5, 0.5) -- [border = grey, shadow x2]
				child.darkOverlay:SetColorTexture(0.01, 0.01, 0.01, 0.50)
				child.darkOverlay:Show()
			elseif alpha <= 0.7 then -- isBeingResearched
				backdrop:SetBackdropBorderColor(0, 1, 1) -- [border = teal, shadow x1]
				child.darkOverlay:SetColorTexture(0.01, 0.01, 0.01, 0.25)
				child.darkOverlay:Show()
			end
		elseif atlas:find("green") then
			backdrop:SetBackdropBorderColor(0, 1, 0) -- [border = green, no shadow]
			child.darkOverlay:Hide()
		elseif atlas:find("yellow") then
			backdrop:SetBackdropBorderColor(unpack(C.media.border_color)) -- [border = yellow, no shadow]
			child.darkOverlay:Hide()
		else
			backdrop:SetBackdropBorderColor(0.2, 0.2, 0.2) -- [border = dark grey, shadow x3]
			child.darkOverlay:SetColorTexture(0.01, 0.01, 0.01, 0.75)
			child.darkOverlay:Show()
		end
	end

	T.SkinFrame(OrderHallTalentFrame)
	OrderHallTalentFrame.NineSlice:Hide()
	-- OrderHallTalentFrame.Background:SetAlpha(0)

	hooksecurefunc(OrderHallTalentFrame, "SetUseThemedTextures", function(self)
		self.Background:ClearAllPoints()
		self.Background:SetPoint("TOPLEFT")
		self.Background:SetPoint("BOTTOMRIGHT")
		self.Background:SetDrawLayer("BACKGROUND", 2)
	end)

	OrderHallTalentFrame:HookScript("OnShow", function(self)
		if self.CloseButton.Border then
			self.CloseButton.Border:SetAlpha(0)
		end
		if self.portrait then
			self.portrait:SetAlpha(0)
		end
		if self.skinned then return end
		self.Currency.Icon:SkinIcon()
		self.BackButton:SkinButton()

		for i = 1, self:GetNumChildren() do
			local child = select(i, self:GetChildren())
			if child and child.Icon and child.DoneGlow and not child.backdrop then
				child:StyleButton()
				child:CreateBackdrop()
				child.Border:SetAlpha(0)
				child.Highlight:SetAlpha(0)
				child.AlphaIconOverlay:SetTexture(nil)
				child.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				child.Icon:SetInside(child.backdrop)
				child.hover:SetInside(child.backdrop)
				child.pushed:SetInside(child.backdrop)
				child.backdrop:SetFrameLevel(child.backdrop:GetFrameLevel() + 1)

				child.darkOverlay = child:CreateTexture()
				child.darkOverlay:SetAllPoints(child.Icon)
				child.darkOverlay:SetDrawLayer('OVERLAY')
				child.darkOverlay:Hide()

				colorBorder(child, child.backdrop, child.Border:GetAtlas())

				child.TalentDoneAnim:HookScript("OnFinished", function()
					child.Border:SetAlpha(0) -- clear the yellow glow border again, after it finishes the animation
				end)
			end
		end

		self.choiceTexturePool:ReleaseAll()
		hooksecurefunc(self, "RefreshAllData", function(frame)
			frame.choiceTexturePool:ReleaseAll()
			for i = 1, frame:GetNumChildren() do
				local child = select(i, frame:GetChildren())
				if child and child.Icon and child.Border and child.backdrop then
					colorBorder(child, child.backdrop, child.Border:GetAtlas())
				end
			end
		end)

		self.skinned = true
	end)
end

T.SkinFuncs["Blizzard_OrderHallUI"] = LoadSkin
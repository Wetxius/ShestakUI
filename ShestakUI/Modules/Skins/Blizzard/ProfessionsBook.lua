local T, C, L = unpack(ShestakUI)
if C.skins.blizzard_frames ~= true then return end

----------------------------------------------------------------------------------------
--	ProfessionsBook skin
----------------------------------------------------------------------------------------
local function LoadSkin()
	local frame = _G.ProfessionsBookFrame
	T.SkinFrame(frame)

	ProfessionsBookFrameTutorialButton.Ring:Hide()
	ProfessionsBookFrameTutorialButton:SetPoint("TOPLEFT", ProfessionsBookFrame, "TOPLEFT", -10, 15)

	if not T.newPatch then -- BETA

	PrimaryProfession1Icon:SkinIcon()
	PrimaryProfession2Icon:SkinIcon()
	PrimaryProfession1IconBorder:Hide()
	PrimaryProfession2IconBorder:Hide()

	local headers = {
		"PrimaryProfession1",
		"PrimaryProfession2",
		"SecondaryProfession1",
		"SecondaryProfession2",
		"SecondaryProfession3"
	}

	for _, header in pairs(headers) do
		_G[header.."Missing"]:SetTextColor(1, 0.8, 0)
		_G[header.."Missing"]:SetShadowColor(0, 0, 0)
		_G[header.."Missing"]:SetShadowOffset(1, -1)
		_G[header].missingText:SetTextColor(0.6, 0.6, 0.6)
	end

	local spells = {
		"PrimaryProfession1SpellButtonTop",
		"PrimaryProfession1SpellButtonBottom",
		"PrimaryProfession2SpellButtonTop",
		"PrimaryProfession2SpellButtonBottom",
		"SecondaryProfession1SpellButtonLeft",
		"SecondaryProfession1SpellButtonRight",
		"SecondaryProfession2SpellButtonLeft",
		"SecondaryProfession2SpellButtonRight",
		"SecondaryProfession3SpellButtonLeft",
		"SecondaryProfession3SpellButtonRight"
	}

	local function replaceHighlight(button)
		button.highlightTexture:SetColorTexture(1, 1, 1, 0.3)
		button.highlightTexture:SetPoint("TOPLEFT", button, 4, -4)
		button.highlightTexture:SetPoint("BOTTOMRIGHT", button, -4, 4)
	end

	for _, button in pairs(spells) do
		local icon = _G[button.."IconTexture"]
		local rank = _G[button.."SubSpellName"]
		local button = _G[button]
		button:StripTextures()

		if rank then
			rank:SetTextColor(1, 1, 1)
		end

		button:GetCheckedTexture():SetColorTexture(0, 1, 0, 0.3)
		button:GetCheckedTexture():SetPoint("TOPLEFT", button, 4, -4)
		button:GetCheckedTexture():SetPoint("BOTTOMRIGHT", button, -4, 4)

		button.cooldown:SetPoint("TOPLEFT", button, 4, -4)
		button.cooldown:SetPoint("BOTTOMRIGHT", button, -4, 4)

		if icon then
			icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			icon:ClearAllPoints()
			icon:SetPoint("TOPLEFT", 4, -4)
			icon:SetPoint("BOTTOMRIGHT", -4, 4)

			hooksecurefunc(button, "UpdateButton", replaceHighlight)

			if not button.backdrop then
				-- button:SetFrameLevel(button:GetFrameLevel() + 2)
				button:CreateBackdrop("Default")
				button.backdrop:SetPoint("TOPLEFT", 2, -2)
				button.backdrop:SetPoint("BOTTOMRIGHT", -2, 2)
			end
		end
	end

	local statusBars = {
		"PrimaryProfession1StatusBar",
		"PrimaryProfession2StatusBar",
		"SecondaryProfession1StatusBar",
		"SecondaryProfession2StatusBar",
		"SecondaryProfession3StatusBar"
	}

	for _, statusbar in pairs(statusBars) do
		local statusbar = _G[statusbar]
		statusbar:StripTextures()
		statusbar:SetStatusBarTexture(C.media.texture)
		statusbar:SetStatusBarColor(0, 0.8, 0)
		statusbar:CreateBackdrop("Overlay")

		statusbar.rankText:ClearAllPoints()
		statusbar.rankText:SetPoint("CENTER")
	end

	else

	local headers = {
		frame.ProfessionsContentFrame.PrimaryProfession1,
		frame.ProfessionsContentFrame.PrimaryProfession2,
		frame.ProfessionsContentFrame.SecondaryProfession1,
		frame.ProfessionsContentFrame.SecondaryProfession2,
		ProfessionsBookFrame.ProfessionsContentFrame.SecondaryProfession3
	}

	for i = 1, #headers do
		local frame = headers[i]
		if frame then
			for _, button in next, {frame.SpellButton1, frame.SpellButton2} do
				local icon = button.IconTexture
				local rank = button.SubSpellName
				button:StripTextures()

				if rank then
					rank:SetTextColor(1, 1, 1)
				end

				button:GetCheckedTexture():SetColorTexture(0, 1, 0, 0.2)
				button:GetCheckedTexture():SetPoint("TOPLEFT", button, 4, -4)
				button:GetCheckedTexture():SetPoint("BOTTOMRIGHT", button, -4, 4)

				button.cooldown:SetPoint("TOPLEFT", button, 4, -4)
				button.cooldown:SetPoint("BOTTOMRIGHT", button, -4, 4)

				if icon then
					icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
					icon:ClearAllPoints()
					icon:SetPoint("TOPLEFT", 4, -4)
					icon:SetPoint("BOTTOMRIGHT", -4, 4)

					hooksecurefunc(button, "UpdateButton", function(self)
						self.highlightTexture:SetColorTexture(1, 1, 1, 0.3)
						self.highlightTexture:SetPoint("TOPLEFT", button, 4, -4)
						self.highlightTexture:SetPoint("BOTTOMRIGHT", button, -4, 4)
					end)

					if not button.backdrop then
						button:CreateBackdrop("Default")
						button.backdrop:SetPoint("TOPLEFT", 2, -2)
						button.backdrop:SetPoint("BOTTOMRIGHT", -2, 2)
					end
				end
			end

			if frame.icon then
				frame.icon:SkinIcon()
				frame.IconBorder:Hide()
			end

			frame.missingHeader:SetTextColor(1, 0.8, 0)
			frame.missingHeader:SetShadowColor(0, 0, 0)
			frame.missingHeader:SetShadowOffset(1, -1)
			frame.missingText:SetTextColor(0.6, 0.6, 0.6)

			local statusbar = frame.StatusBar
			statusbar:StripTextures()
			statusbar:SetStatusBarTexture(C.media.texture)
			statusbar:SetStatusBarColor(0, 0.8, 0)
			statusbar:CreateBackdrop("Overlay")

			statusbar.rankText:ClearAllPoints()
			statusbar.rankText:SetPoint("CENTER")
		end
	end

	end
end

T.SkinFuncs["Blizzard_ProfessionsBook"] = LoadSkin
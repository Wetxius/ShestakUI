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
				button:SetFrameLevel(button:GetFrameLevel() + 2)
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
end

T.SkinFuncs["Blizzard_ProfessionsBook"] = LoadSkin
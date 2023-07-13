local T, C, L = unpack(ShestakUI)
if C.actionbar.enable ~= true or C.actionbar.micromenu ~= true then return end

----------------------------------------------------------------------------------------
--	Micro menu(by Elv22)
----------------------------------------------------------------------------------------
local frame = CreateFrame("Frame", "MicroAnchor", T_PetBattleFrameHider)
frame:SetPoint(unpack(C.position.micro_menu))
frame:SetSize(250, 25)

if C.actionbar.micromenu_mouseover then
	frame:SetAlpha(0)
	frame:SetScript("OnEnter", function() frame:SetAlpha(1) end)
	frame:SetScript("OnLeave", function() frame:SetAlpha(0) end)
end

local MICRO_BUTTONS = {
	"CharacterMicroButton",
	"SpellbookMicroButton",
	"TalentMicroButton",
	"AchievementMicroButton",
	"QuestLogMicroButton",
	"GuildMicroButton",
	"LFDMicroButton",
	"EJMicroButton",
	"CollectionsMicroButton",
	"StoreMicroButton",
	"MainMenuMicroButton",
	"HelpMicroButton",
}

for i, button in pairs(MICRO_BUTTONS) do
	local bu = _G[button]
	local normal = bu:GetNormalTexture()
	local pushed = bu:GetPushedTexture()
	local disabled = bu:GetDisabledTexture()
	bu:SetSize(22, 29)

	local point = bu:GetPoint()
	if point then
		bu:ClearAllPoints()
		if i == 1 then
			bu:SetPoint("TOPLEFT", frame, "TOPLEFT", -1, 2)
		else
			bu:SetPoint("TOPLEFT", frame, "TOPLEFT", ((i - 1) * 23) - 1, 2)
		end
	end

	bu:SetParent(frame)
	bu.SetParent = T.dummy

	bu:SetHighlightTexture(0)
	bu.SetHighlightTexture = T.dummy

	local f = CreateFrame("Frame", nil, bu)
	f:SetFrameLevel(1)
	f:SetFrameStrata("BACKGROUND")
	f:SetPoint("BOTTOMLEFT", bu, "BOTTOMLEFT", 1, 2)
	f:SetPoint("TOPRIGHT", bu, "TOPRIGHT", -1, -2)
	f:SetTemplate("Default")
	bu.frame = f

	local flash = bu.FlashBorder
	if flash then
		flash:SetInside(f)
		flash:SetTexture(C.media.blank)
		flash:SetVertexColor(0.6, 0.6, 0.6)
	end
	if bu.FlashContent then bu.FlashContent:SetTexture(nil) end

	local highlight = bu:GetHighlightTexture()
	if highlight then
		highlight:SetAlpha(0)
		highlight:SetTexCoord(0.1, 0.9, 0.12, 0.9)
	end

	if normal then
		normal:SetTexCoord(0.2, 0.80, 0.22, 0.8)
		normal:ClearAllPoints()
		normal:SetPoint("TOPLEFT", f, "TOPLEFT", 2, -2)
		normal:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -2, 2)
	end

	if pushed then
		pushed:SetTexCoord(0.2, 0.80, 0.22, 0.8)
		pushed:ClearAllPoints()
		pushed:SetPoint("TOPLEFT", f, "TOPLEFT", 2, -2)
		pushed:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -2, 2)
	end

	if disabled then
		disabled:SetTexCoord(0.2, 0.80, 0.22, 0.8)
		disabled:ClearAllPoints()
		disabled:SetPoint("TOPLEFT", f, "TOPLEFT", 2, -2)
		disabled:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -2, 2)
	end

	bu:HookScript("OnEnter", function(self)
		self.frame:SetBackdropBorderColor(unpack(C.media.classborder_color))
		if C.actionbar.micromenu_mouseover then
			frame:SetAlpha(1)
		end
	end)
	bu:HookScript("OnLeave", function(self)
		self.frame:SetBackdropBorderColor(unpack(C.media.border_color))
		if C.actionbar.micromenu_mouseover then
			frame:SetAlpha(0)
		end
	end)

	if bu.Background then bu.Background:SetAlpha(0) end
	if bu.PushedShadow then bu.PushedShadow:SetTexture() end
	if bu.Shadow then bu.Shadow:SetTexture() end
	if bu.PushedBackground then bu.PushedBackground:SetAlpha(0) end
	if bu.PortraitMask then bu.PortraitMask:Hide() end
end

-- Fix textures for buttons
MainMenuMicroButton.MainMenuBarPerformanceBar:SetTexture(C.media.texture)
MainMenuMicroButton.MainMenuBarPerformanceBar:SetSize(16, 2)
MainMenuMicroButton.MainMenuBarPerformanceBar:SetPoint("BOTTOM", MainMenuMicroButton, "BOTTOM", 0, 4)

if CharacterMicroButton then
	local function SkinCharacterPortrait(self)
		self.Portrait:SetInside(self, 4, 4)
	end

	hooksecurefunc(CharacterMicroButton, "SetPushed", SkinCharacterPortrait)
	hooksecurefunc(CharacterMicroButton, "SetNormal", SkinCharacterPortrait)
end
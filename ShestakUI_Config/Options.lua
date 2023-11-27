local T, C
local _, ns = ...
local L = ns

----------------------------------------------------------------------------------------
--	GUI for ShestakUI(by Haleth, Solor)
----------------------------------------------------------------------------------------
local realm = GetRealmName()
local name = UnitName("player")

-- Main window
local options = CreateFrame("Frame", "ShestakUIOptionsPanel", UIParent)
options:SetSize(800, 770)
options:SetPoint("CENTER")
options:SetFrameStrata("HIGH")
options:EnableMouse(true)
tinsert(UISpecialFrames, options:GetName())

local CloseButton = CreateFrame("Button", nil, options, "UIPanelButtonTemplate")
CloseButton:SetPoint("TOPRIGHT", options, "BOTTOMRIGHT", -10, 30)
CloseButton:SetSize(100, 23)
CloseButton:SetText(CLOSE)
CloseButton:SetScript("OnClick", function()
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
	options:Hide()
end)

local OkayButton = CreateFrame("Button", "ShestakUIOptionsPanelOkayButton", options, "UIPanelButtonTemplate")
OkayButton:SetPoint("RIGHT", CloseButton, "LEFT", -4, 0)
OkayButton:SetSize(100, 23)
OkayButton:SetText(APPLY)
OkayButton:SetScript("OnClick", function()
	ReloadUI()
end)
OkayButton:Disable()

tinsert(ns.buttons, CloseButton)
tinsert(ns.buttons, OkayButton)

local reloadText = options:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
reloadText:SetPoint("BOTTOM", 0, 11)
reloadText:SetText("|cffff2735"..L_GUI_NEED_RELOAD.."|r")
reloadText:Hide()
options.reloadText = reloadText

StaticPopupDialogs.SHESTAKUI_RESET_PERCHAR = {
	text = L_GUI_RESET_CHAR,
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function()
		local i = tostring(ShestakUIOptionsGlobal[realm]["Current_Profile"][name])
		ShestakUIOptionsPerChar[i] = {}
		C.options = ShestakUIOptionsPerChar[i]
		ReloadUI()
	end,
	whileDead = true,
	hideOnEscape = true,
	showAlert = true,
}

StaticPopupDialogs.SHESTAKUI_RESET = {
	text = L_GUI_RESET_ALL,
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function()
		local i = tostring(ShestakUIOptionsGlobal["Current_Profile"])
		ShestakUIOptions[i] = {}
		C.options = ShestakUIOptions[i]
		ReloadUI()
	end,
	whileDead = true,
	hideOnEscape = true,
	showAlert = true,
}

StaticPopupDialogs.SHESTAKUI_RESET_CATEGORY = {
	text = L_GUI_RESET_CAT,
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function()
		if ShestakUIOptionsPanelgeneral2:IsShown() then
			C.options.media = {}
			C.options.media.profile = C.media.profile
		else
			C.options[C.category] = {}
		end
		ReloadUI()
	end,
	whileDead = true,
	hideOnEscape = true,
}

local ResetButton = CreateFrame("Button", nil, options, "UIPanelButtonTemplate")
ResetButton:SetSize(100, 23)
ResetButton:SetText(DEFAULT)
ResetButton.tooltipText = "|cffFFD100"..L_GUI_RESET_CAT_DESC.."|r"
ResetButton:SetPoint("BOTTOMLEFT", ShestakUIOptionsPanel, "BOTTOMLEFT", 10, 7)
ResetButton:SetScript("OnClick", function()
	if IsModifiedClick() then
		if ShestakUIOptionsGlobal[realm][name] == true then
			StaticPopup_Show("SHESTAKUI_RESET_PERCHAR")
		else
			StaticPopup_Show("SHESTAKUI_RESET")
		end
	else
		StaticPopup_Show("SHESTAKUI_RESET_CATEGORY")
	end
end)
tinsert(ns.buttons, ResetButton)

-- Tables
local FontTable
local LSM = LibStub and LibStub:GetLibrary("LibSharedMedia-3.0", true)
if LSM then
	FontTable = LSM:HashTable("font")
else
	FontTable = {
		"Interface\\AddOns\\ShestakUI\\Media\\Fonts\\Normal.ttf",
		"Interface\\AddOns\\ShestakUI\\Media\\Fonts\\Pixel.ttf",
		STANDARD_TEXT_FONT
	}
end

local FlagsTable = {
	"OUTLINE",
	"MONOCHROMEOUTLINE",
	""
}

local ErrorTable = {
	"BLACKLIST",
	"WHITELIST",
	"COMBAT",
	"NONE"
}

local CollapseTable = {
	"RAID",
	"RELOAD",
	"SCENARIO",
	"NONE"
}

local RaidTable = {
	"HEAL",
	"DPS",
	"AUTO",
	"BLIZZARD"
}

local PortraitTable = {
	"3D",
	"2D",
	"ICONS",
	"OVERLAY"
}

local TextureTable
if LSM then
	TextureTable = LSM:HashTable("statusbar")
else
	TextureTable = {
		"Interface\\AddOns\\ShestakUI\\Media\\Textures\\Texture.tga"
	}
end

local FilgerTable = {
	L.filger_show_buff,
	L.filger_show_proc,
	L.filger_show_debuff,
	L.filger_show_aura_bar,
	L.filger_show_cd,
	IGNORE
}

local FilgerDropDownText = {
	[L.filger_show_buff] = "buff_spells_list",
	[L.filger_show_proc] = "proc_spells_list",
	[L.filger_show_debuff] = "debuff_spells_list",
	[L.filger_show_aura_bar] = "aura_bar_spells_list",
	[L.filger_show_cd] = "cd_spells_list",
	[IGNORE] = "ignore_spells_list",
}

-- Spell list frame
local SpellList = CreateFrame("Frame", "SpellList", ShestakUIOptionsPanel, "ButtonFrameTemplate")
SpellList:SetPoint("TOPLEFT", ShestakUIOptionsPanel, "TOPRIGHT", 22, 0)
SpellList:SetSize(290, 420)
SpellList:Hide()

SpellListPortrait:SetAlpha(0)

SpellList.title = _G["SpellListTitle"] or SpellList:CreateFontString("SpellListTitle", "OVERLAY", "GameFontNormal")
SpellList.title:SetPoint("TOP", _G["SpellList"], "TOP", 0, -5)
SpellList.title:SetText(L_GUI_SPELL_LIST)

local ScrollSpells = CreateFrame("ScrollFrame", "SpellListScrollFrameSpellList", _G["SpellListInset"], "ScrollFrameTemplate")
ScrollSpells:SetPoint("TOPLEFT", _G["SpellListInset"], "TOPLEFT", -10, 19)
ScrollSpells:SetPoint("BOTTOMRIGHT", _G["SpellListInset"], "BOTTOMRIGHT", -30, 40)
ScrollSpells.child = CreateFrame("Frame", "SpellListScrollFrameSpellListChild", ScrollSpells)
ScrollSpells.child:SetSize(270, 290)
ScrollSpells:SetScrollChild(ScrollSpells.child)

local isFilger = false
local doubleInput = false
SpellList.makeSpellsList = function(_, db, double)
	local oldb
	local scroll = SpellListScrollFrameSpellListChild

	local i = 1
	while _G["SpellList"..i.."_cbs"] do
		_G["SpellList"..i.."_fs"]:SetText("")
		_G["SpellList"..i.."_fs2"]:SetText("")
		_G["SpellList"..i.."_texture"]:SetTexture(nil)
		_G["SpellList"..i.."_cbs"]:ClearAllPoints()
		_G["SpellList"..i.."_cbs"]:Hide()
		i = i + 1
	end

	local i = 1
	for k, spell in pairs(db) do
		if spell then
			if not isFilger or isFilger and spell[2] == T.class then
				local sp = (double or ShestakUIOptionsPanelfilger:IsShown()) and spell[1] or spell
				local name, _, icon = GetSpellInfo(sp)
				local bf = _G["SpellList"..i.."_cbs"] or CreateFrame("Button", "SpellList"..i.."_cbs", scroll, "BackdropTemplate")

				if i == 1 then
					bf:SetPoint("TOPLEFT", scroll, "TOPLEFT", 10, -5)
					bf:SetPoint("BOTTOMRIGHT", scroll, "TOPRIGHT", -10, -29)
				else
					bf:SetPoint("TOPLEFT", oldb, "BOTTOMLEFT", 0, -2)
					bf:SetPoint("BOTTOMRIGHT", oldb, "BOTTOMRIGHT", 0, -26)
				end

				bf:EnableMouse(true)

				bf.tex = bf.tex or bf:CreateTexture("SpellList"..i.."_texture", "OVERLAY")
				bf.tex:SetSize(22, 22)
				bf.tex:SetPoint("LEFT")
				bf.tex:SetTexture(icon)
				bf.tex:SetTexCoord(0.1, 0.9, 0.1, 0.9)

				bf.delete = bf.delete or CreateFrame("Button", "SpellList"..i.."_delete", bf)
				bf.delete:SetSize(16, 16)
				bf.delete:SetPoint("RIGHT")
				bf.delete:SetNormalTexture("Interface\\BUTTONS\\UI-GroupLoot-Pass-Up")
				bf.delete:GetNormalTexture():SetVertexColor(0.8, 0, 0)
				bf.delete:SetPushedTexture("Interface\\BUTTONS\\UI-GroupLoot-Pass-Up")
				bf.delete:SetHighlightTexture("Interface\\BUTTONS\\UI-GroupLoot-Pass-Up")
				bf.delete:SetScript("OnClick", function()
					tremove(db, k)
					SpellList:makeSpellsList(db, double)
					ns.setReloadNeeded(true)
				end)

				bf:SetScript("OnEnter", function(self)
					bf.delete:GetNormalTexture():SetVertexColor(1, 0, 0)
					self:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8"})
					self:SetBackdropColor(0.2, 0.2, 0.2, 0.7)
					GameTooltip:SetOwner(bf, "ANCHOR_TOP", 5, 5)
					GameTooltip:SetHyperlink(format("spell:%s", sp))
				end)
				bf:SetScript("OnLeave", function(self)
					bf.delete:GetNormalTexture():SetVertexColor(0.8, 0, 0)
					self:SetBackdrop(nil)
					GameTooltip:Hide()
				end)

				bf.fs = bf.fs or bf:CreateFontString("SpellList"..i.."_fs", "OVERLAY", "GameFontNormal")
				bf.fs:SetText(name)
				bf.fs:SetPoint("RIGHT", bf.delete, "LEFT", -4, 0)
				bf.fs:SetPoint("LEFT", bf.tex, "RIGHT", 5, 0)
				bf.fs:SetWordWrap(false)
				bf.fs:SetJustifyH("RIGHT")

				bf.fs2 = bf.fs2 or bf:CreateFontString("SpellList"..i.."_fs2", "OVERLAY", "GameFontNormal")
				bf.fs2:SetPoint("RIGHT", bf.delete, "LEFT", -4, 0)
				bf.fs2:SetWordWrap(false)
				bf.fs2:SetJustifyH("RIGHT")

				if double and spell[2] and tonumber(spell[2]) > 0 then
					bf.fs2:SetText(format(GARRISON_DURATION_SECONDS, spell[2]))
					bf.fs:SetPoint("RIGHT", bf.fs2, "LEFT", -4, 0)
				end

				bf:Show()
				oldb = bf
				i = i + 1

				-- Remove outdated spells
				if not name then
					tremove(db, k)
					SpellList:makeSpellsList(db, double)
				end
			end
		end
	end
	SpellList:Show()
	if double then
		SpellListTextInput2:Show()
	else
		SpellListTextInput2:Hide()
	end
end

local function onEnterPressed(self)
	local value = tonumber(self:GetText())
	AddSpellButton:Disable()
	if value and value > 0 then
		local name = GetSpellInfo(value)
		if name then
			self:SetText(name)
			self:SetCursorPosition(0)
			self:ClearFocus()
			self.value = value
			if not SpellListTextInput2:IsShown() or SpellListTextInput2:GetText() ~= "" then
				AddSpellButton:Enable()
			end
		else
			self:SetText(UNKNOWN)
			self.value = value
		end
	else
		self.value = ""
	end
end

local InputSpell = CreateFrame("EditBox", SpellList:GetName().."TextInput", SpellList, "InputBoxTemplate")
InputSpell:SetAutoFocus(false)
InputSpell:SetWidth(150)
InputSpell:SetHeight(18)
InputSpell:SetMaxLetters(99)
InputSpell:SetFontObject(GameFontHighlight)

InputSpell:SetPoint("TOPLEFT", SpellList, "BOTTOMLEFT", -2, 37)

InputSpell.value = ""

InputSpell:SetScript("OnEscapePressed", function(self) self:ClearFocus() self:SetText(InputSpell.value) end)
InputSpell:SetScript("OnEnterPressed", onEnterPressed)
InputSpell:SetScript("OnEditFocusGained", function() InputSpell:SetText(InputSpell.value) end)
InputSpell:SetScript("OnEditFocusLost", onEnterPressed)

local label = InputSpell:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
label:SetWidth(440)
label:SetHeight(20)
label:SetJustifyH("LEFT")
label:SetPoint("BOTTOMLEFT", InputSpell, "TOPLEFT", -2, 2)
label:SetText(L_GUI_SPELL_INPUT)

local function onEnterPressed(self)
	local value = tonumber(self:GetText())
	AddSpellButton:Disable()
	if value and value > 0 then
		self:ClearFocus()
		self.value = value
		if InputSpell.value ~= "" then
			AddSpellButton:Enable()
		end
	end
end

local InputArg = CreateFrame("EditBox", SpellList:GetName().."TextInput2", SpellList, "InputBoxTemplate")
InputArg:SetAutoFocus(false)
InputArg:SetWidth(40)
InputArg:SetHeight(18)
InputArg:SetMaxLetters(4)
InputArg:SetFontObject(GameFontHighlight)

InputArg:SetPoint("LEFT", InputSpell, "RIGHT", 10, 0)

InputArg:SetScript("OnEscapePressed", function(self) self:ClearFocus() self:SetText(InputArg.value) end)
InputArg:SetScript("OnEnterPressed", onEnterPressed)
InputArg:SetScript("OnEditFocusGained", function() InputArg.value = InputArg:GetText() end)
InputArg:SetScript("OnEditFocusLost", onEnterPressed)

local label = InputArg:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
label:SetWidth(440)
label:SetHeight(20)
label:SetJustifyH("LEFT")
label:SetPoint("BOTTOMLEFT", InputArg, "TOPLEFT", -2, 2)
label:SetText(L_GUI_TIME_INPUT)

InputArg:Hide()

local curOption
local function BuildSpellList(option, double, hiding)
	if ProfileList:IsVisible() then ProfileList:Hide() end
	if not hiding and SpellList:IsVisible() then SpellList:Hide() return end
	curOption = option
	doubleInput = double
	isFilger = hiding
	SpellList:makeSpellsList(option, double)
end

ns.HideSpellList = function()
	InputSpell:SetText("")
	InputSpell.value = ""
	InputArg:SetText("")
	UIDropDownMenu_SetText(ShestakUIOptionsPanelfilgercategory_listDropDown, "")
	ShestakUIOptionsPanelfilgercategory_listDropDown.selectedValue = nil
	AddSpellButton:Disable()
	SpellList:Hide()
end

local AddSpellButton = CreateFrame("Button", "AddSpellButton", SpellList, "UIPanelButtonTemplate")
AddSpellButton:SetPoint("TOPRIGHT", SpellList, "BOTTOMRIGHT", -10, 40)
AddSpellButton:SetSize(100, 23)
AddSpellButton:SetText(ADD)
AddSpellButton:SetWidth(AddSpellButton.Text:GetWidth() + 15)
AddSpellButton:SetScript("OnClick", function()
	if doubleInput then
		tinsert(curOption, {InputSpell.value, InputArg.value})
	else
		if isFilger then
			tinsert(curOption, {InputSpell.value, T.class})
		else
			tinsert(curOption, InputSpell.value)
		end
	end
	InputSpell:SetText("")
	InputSpell.value = ""
	InputArg:SetText("")
	AddSpellButton:Disable()
	ns.setReloadNeeded(true)
	SpellList:makeSpellsList(curOption, doubleInput)
end)

AddSpellButton:SetScript("OnEnter", function()
	GameTooltip:SetOwner(AddSpellButton, "ANCHOR_RIGHT", 5, 5)
	GameTooltip:SetHyperlink(format("spell:%s", InputSpell.value))
end)

AddSpellButton:SetScript("OnLeave", function()
	GameTooltip:Hide()
end)

AddSpellButton:Disable()
tinsert(ns.buttons, AddSpellButton)

-- Info frame
do
	local frame = CreateFrame("Frame", "ShestakUIInfoFrame", UIParent)
	frame:SetWidth(800)
	frame:SetHeight(770)
	frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	frame:SetFrameStrata("DIALOG")
	tinsert(UISpecialFrames, "ShestakUIInfoFrame")
	frame:Hide()
	frame:EnableMouse(true)

	local title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 26, -26)
	title:SetText("Links:")

	local HelpButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	HelpButton:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -20)
	HelpButton:SetSize(100, 23)
	HelpButton:SetText("Wiki page")
	HelpButton:SetWidth(HelpButton.Text:GetWidth() + 15)
	local url = L_GUI_WIKI_URL
	HelpButton:SetScript("OnClick", function()
		StaticPopup_Show("LINK_URL", _, _, url)
	end)

	local DiscordButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	DiscordButton:SetPoint("LEFT", HelpButton, "RIGHT", 10, 0)
	DiscordButton:SetSize(100, 23)
	DiscordButton:SetText("Discord")
	DiscordButton:SetWidth(DiscordButton.Text:GetWidth() + 15)
	local url = "https://discord.gg/vwHwnTt"
	DiscordButton:SetScript("OnClick", function()
		StaticPopup_Show("LINK_URL", _, _, url)
	end)

	local GithubButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	GithubButton:SetPoint("LEFT", DiscordButton, "RIGHT", 10, 0)
	GithubButton:SetSize(100, 23)
	GithubButton:SetText("Github")
	GithubButton:SetWidth(GithubButton.Text:GetWidth() + 15)
	local url = "https://github.com/Wetxius/ShestakUI"
	GithubButton:SetScript("OnClick", function()
		StaticPopup_Show("LINK_URL", _, _, url)
	end)

	tinsert(ns.buttons, DiscordButton)
	tinsert(ns.buttons, HelpButton)
	tinsert(ns.buttons, GithubButton)

	local title2 = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title2:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -66)
	title2:SetText("Credits:")

	local subtitle2 = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	subtitle2:SetWidth(750)
	subtitle2:SetPoint("TOPLEFT", title2, "BOTTOMLEFT", 0, -8)
	subtitle2:SetJustifyH("LEFT")
	subtitle2:SetText(C_AddOns.GetAddOnMetadata("ShestakUI", "X-Credits"))

	local title3 = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title3:SetPoint("TOPLEFT", subtitle2, "BOTTOMLEFT", 0, -16)
	title3:SetText("Translation:")

	local subtitle3 = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	subtitle3:SetWidth(750)
	subtitle3:SetPoint("TOPLEFT", title3, "BOTTOMLEFT", 0, -8)
	subtitle3:SetJustifyH("LEFT")
	subtitle3:SetText(C_AddOns.GetAddOnMetadata("ShestakUI", "X-Translation"))

	local title4 = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title4:SetPoint("TOPLEFT", subtitle3, "BOTTOMLEFT", 0, -16)
	title4:SetText("Thanks:")

	local subtitle4 = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	subtitle4:SetWidth(750)
	subtitle4:SetPoint("TOPLEFT", title4, "BOTTOMLEFT", 0, -8)
	subtitle4:SetJustifyH("LEFT")
	subtitle4:SetText(C_AddOns.GetAddOnMetadata("ShestakUI", "X-Thanks"))

	local CancelButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	CancelButton:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -10, 10)
	CancelButton:SetSize(100, 23)
	CancelButton:SetText(CLOSE)
	CancelButton:SetWidth(CancelButton.Text:GetWidth() + 15)
	CancelButton:SetScript("OnClick", function()
		frame:Hide()
	end)

	tinsert(ns.buttons, CancelButton)

	StaticPopupDialogs.LINK_URL = {
		text = COMMUNITIES_INVITE_MANAGER_COPY,
		button1 = OKAY,
		timeout = 0,
		whileDead = true,
		hasEditBox = true,
		editBoxWidth = 350,
		OnShow = function(self, text)
			self.editBox:SetMaxLetters(0)
			self.editBox:SetText(text)
			self.editBox:HighlightText()
			selfText = text
		end,
		EditBoxOnEnterPressed = function(self) self:GetParent():Hide() end,
		EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
		EditBoxOnTextChanged = function(self)
			if self:GetText():len() < 1 then
				self:GetParent():Hide()
			else
				self:SetText(selfText)
				self:HighlightText()
			end
		end,
		preferredIndex = 5,
	}
end

-- Expert mode
do
	local frame = CreateFrame("Frame", "ShestakUIProfileFrame", UIParent)
	frame:SetWidth(650)
	frame:SetHeight(520)
	frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	frame:SetFrameStrata("DIALOG")
	tinsert(UISpecialFrames, "ShestakUIProfileFrame")
	frame:Hide()
	frame:EnableMouse(true)

	local editBox = CreateFrame("EditBox", "ShestakUIProfileFrameEditBox", frame)
	editBox:SetMultiLine(true)
	editBox:SetMaxLetters(0)
	editBox:SetAutoFocus(true)
	editBox:SetFontObject(ChatFontNormal)
	editBox:SetWidth(620)
	editBox:SetHeight(500)
	editBox:SetScript("OnEscapePressed", function() frame:Hide() end)

	local scrollArea = CreateFrame("ScrollFrame", "ShestakUIProfileFrameScroll", frame, "ScrollFrameTemplate")
	scrollArea:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -10)
	scrollArea:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -29, 34)
	scrollArea:SetScrollChild(editBox)
	ShestakUIProfileFrameScroll.ScrollBar:SetPoint("TOPLEFT", ShestakUIProfileFrameScroll, "TOPRIGHT", 11, 4)
	ShestakUIProfileFrameScroll.ScrollBar:SetPoint("BOTTOMLEFT", ShestakUIProfileFrameScroll, "BOTTOMRIGHT", 11, -5)

	local CancelButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	CancelButton:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -4, 4)
	CancelButton:SetSize(100, 23)
	CancelButton:SetText(CLOSE)
	CancelButton:SetWidth(CancelButton.Text:GetWidth() + 15)
	CancelButton:SetScript("OnClick", function()
		frame:Hide()
	end)

	tinsert(ns.buttons, CancelButton)

	local SaveButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	SaveButton:SetPoint("BOTTOMRIGHT", CancelButton, "BOTTOMLEFT", -4, 0)
	SaveButton:SetSize(100, 23)
	SaveButton:SetText(SAVE)
	SaveButton:SetWidth(SaveButton.Text:GetWidth() + 15)
	SaveButton:SetScript("OnClick", function()
		local _, output = loadstring(editBox:GetText())
		if output then
			print("|cffFF0000"..output.."|r")
		else
			C.options.media = C.options.media or {}
			C.options.media.profile = editBox:GetText()
			frame:Hide()
			ns.setReloadNeeded(true)
		end
	end)

	tinsert(ns.buttons, SaveButton)

	local WikiPage = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	WikiPage:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 6, 4)
	WikiPage:SetSize(100, 23)
	WikiPage:SetText("Wiki")
	WikiPage:SetWidth(WikiPage.Text:GetWidth() + 15)

	local url = "https://github.com/Wetxius/ShestakUI_Profile/wiki/"
	WikiPage:SetScript("OnClick", function()
		editBox:ClearFocus()
		StaticPopup_Show("LINK_URL", _, _, url)
	end)

	tinsert(ns.buttons, WikiPage)
end

-- Category
ns.addCategory("general", GENERAL_LABEL, L_GUI_GENERAL_SUBTEXT, 2)
ns.addCategory("font", L.font, L.font_subtext, 4)
ns.addCategory("skins", L_GUI_SKINS, L_GUI_SKINS_SUBTEXT)
ns.addCategory("unitframe", UNITFRAME_LABEL, L_GUI_UF_SUBTEXT, 3)
ns.addCategory("unitframe_class_bar", L_GUI_UF_PLUGINS_CLASS_BAR, L_GUI_UF_PLUGINS_CLASS_BAR_SUBTEXT)
ns.addCategory("raidframe", RAID_FRAMES_LABEL, L_GUI_UF_RAIDFRAMES_SUBTEXT, 2)
ns.addCategory("aura", BUFFOPTIONS_LABEL, BUFFOPTIONS_SUBTEXT)
ns.addCategory("actionbar", L_GUI_ACTIONBAR, ACTIONBARS_SUBTEXT, 3)
ns.addCategory("tooltip", L.tooltip, L.tooltip_subtext)
ns.addCategory("chat", SOCIALS, L.chat_subtext)
ns.addCategory("nameplate", UNIT_NAMEPLATES, L_GUI_NAMEPLATE_SUBTEXT, 2)
ns.addCategory("combattext", L_GUI_COMBATTEXT, COMBATTEXT_SUBTEXT.." "..L_GUI_COMBATTEXT_SUBTEXT, 2)
ns.addCategory("bag", L_GUI_BAGS, L_GUI_BAGS_SUBTEXT)
ns.addCategory("minimap", MINIMAP_LABEL, L_GUI_MINIMAP_SUBTEXT)
ns.addCategory("loot", LOOT, L_GUI_LOOT_SUBTEXT)
ns.addCategory("filger", L_GUI_FILGER, L_GUI_FILGER_SUBTEXT)
ns.addCategory("announcements", L_GUI_ANNOUNCEMENTS, L_GUI_ANNOUNCEMENTS_SUBTEXT)
ns.addCategory("automation", L_GUI_AUTOMATION, L_GUI_AUTOMATION_SUBTEXT)
ns.addCategory("reminder", L_GUI_REMINDER, L_GUI_REMINDER_SUBTEXT)
ns.addCategory("raidcooldown", L_GUI_COOLDOWN_RAID, L_GUI_COOLDOWN_RAID_SUBTEXT)
ns.addCategory("enemycooldown", L_GUI_COOLDOWN_ENEMY, L_GUI_COOLDOWN_ENEMY_SUBTEXT)
ns.addCategory("pulsecooldown", L.pulsecooldown, L.pulsecooldown_subtext)
ns.addCategory("threat", L_GUI_THREAT, L_GUI_THREAT_SUBTEXT)
ns.addCategory("toppanel", L_GUI_TOP_PANEL, L_GUI_TOP_PANEL_SUBTEXT)
ns.addCategory("stats", L_GUI_STATS, L_GUI_STATS_SUBTEXT)
ns.addCategory("trade", L_GUI_TRADE, L_GUI_TRADE_SUBTEXT)
ns.addCategory("misc", OTHER, L_GUI_MISC_SUBTEXT)

-- General
do
	local parent = ShestakUIOptionsPanel.general

	local welcome_message = ns.CreateCheckBox(parent, "welcome_message", L_GUI_GENERAL_WELCOME_MESSAGE)
	welcome_message:SetPoint("TOPLEFT", parent.subText, "BOTTOMLEFT", 0, 0)

	local auto_scale = ns.CreateCheckBox(parent, "auto_scale", L_GUI_GENERAL_AUTOSCALE)
	auto_scale:SetPoint("TOPLEFT", welcome_message, "BOTTOMLEFT", 0, 0)

	local uiscale = ns.CreateNumberSlider(parent, "uiscale", nil, nil, 0.4, 1.1, 0.01, true, L_GUI_GENERAL_UISCALE)
	uiscale:SetPoint("TOPLEFT", auto_scale, "BOTTOMLEFT", 0, -20)

	local function toggleUIScaleOptions()
		local shown = not auto_scale:GetChecked()
		uiscale:SetShown(shown)
	end

	auto_scale:HookScript("OnClick", toggleUIScaleOptions)
	uiscale:HookScript("OnShow", toggleUIScaleOptions)

	-- Blizzard UI
	local subheader = ns.addSubCategory(parent, L.general_subheader_blizzard)
	subheader:SetPoint("TOPLEFT", uiscale, "BOTTOMLEFT", 0, -10)

	local error_filter = ns.CreateDropDown(parent, "error_filter", true, nil, ErrorTable)
	error_filter:SetPoint("TOPLEFT", subheader, "BOTTOMLEFT", -16, -10)

	local vehicle_mouseover = ns.CreateCheckBox(parent, "vehicle_mouseover")
	vehicle_mouseover:SetPoint("TOPLEFT", error_filter, "BOTTOMLEFT", 16, 0)

	local move_blizzard = ns.CreateCheckBox(parent, "move_blizzard")
	move_blizzard:SetPoint("TOPLEFT", vehicle_mouseover, "BOTTOMLEFT", 0, 0)

	local color_picker = ns.CreateCheckBox(parent, "color_picker")
	color_picker:SetPoint("TOPLEFT", move_blizzard, "BOTTOMLEFT", 0, 0)

	local minimize_mouseover = ns.CreateCheckBox(parent, "minimize_mouseover")
	minimize_mouseover:SetPoint("TOPLEFT", color_picker, "BOTTOMLEFT", 0, 0)

	local hide_banner = ns.CreateCheckBox(parent, "hide_banner")
	hide_banner:SetPoint("TOPLEFT", minimize_mouseover, "BOTTOMLEFT", 0, 0)

	local hide_talking_head = ns.CreateCheckBox(parent, "hide_talking_head")
	hide_talking_head:SetPoint("TOPLEFT", hide_banner, "BOTTOMLEFT", 0, 0)

	local InfoButton = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
	InfoButton:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -20, 5)
	InfoButton:SetSize(100, 23)
	InfoButton:SetText(L_GUI_INFO)
	InfoButton:SetWidth(InfoButton.Text:GetWidth() + 15)
	InfoButton:SetScript("OnClick", function()
		ShestakUIInfoFrame:Show()
	end)

	tinsert(ns.buttons, InfoButton)

	-- Panel 2
	local parent = ShestakUIOptionsPanel.general2

	local border_color = ns.CreateColourPicker(parent, "border_color", true)
	border_color:SetPoint("TOPLEFT", parent.subText, "BOTTOMLEFT", 4, 0)

	local classborder_color = ns.CreateColourPicker(parent, "classborder_color", true)
	classborder_color:SetPoint("TOPLEFT", border_color, "BOTTOMLEFT", 0, -8)

	local backdrop_color = ns.CreateColourPicker(parent, "backdrop_color", true)
	backdrop_color:SetPoint("TOPLEFT", classborder_color, "BOTTOMLEFT", 0, -8)

	local backdrop_alpha = ns.CreateNumberSlider(parent, "backdrop_alpha", nil, nil, 0, 1, 0.05, true)
	backdrop_alpha:SetPoint("TOPLEFT", backdrop_color, "BOTTOMLEFT", 0, -28)

	local texture = ns.CreateDropDown(parent, "texture", true, nil, TextureTable, LSM and true)
	texture:SetPoint("TOPLEFT", backdrop_alpha, "BOTTOMLEFT", -20, -15)

	local texturePreview = CreateFrame("Frame", nil, parent)
	texturePreview:SetSize(100, 30)
	texturePreview:SetPoint("LEFT", texture.label, "RIGHT", 10, 0)
	texturePreview:Hide()

	texturePreview.tex = texturePreview:CreateTexture(nil, "OVERLAY")
	texturePreview.tex:SetPoint("CENTER")
	texturePreview.tex:SetSize(100, 30)

	hooksecurefunc(texture, "SetValue", function()
		texturePreview:Show()
		texturePreview.tex:SetTexture(C.options.media.texture)
		texturePreview.tex:SetVertexColor(unpack(C.media.classborder_color))
	end)

	-- Normal Font
	local subheader = ns.addSubCategory(parent, L.media_subheader_normal)
	subheader:SetPoint("TOPLEFT", texture, "BOTTOMLEFT", 16, -10)

	local normal_font = ns.CreateDropDown(parent, "normal_font", true, L.font_stats_font, FontTable, LSM and true, true)
	normal_font:SetPoint("TOPLEFT", subheader, "BOTTOMLEFT", -16, -10)

	-- Pixel Font
	local subheader = ns.addSubCategory(parent, L.media_subheader_pixel)
	subheader:SetPoint("TOPLEFT", normal_font, "BOTTOMLEFT", 16, -10)

	local pixel_font = ns.CreateDropDown(parent, "pixel_font", true, L.font_stats_font, FontTable, LSM and true, true)
	pixel_font:SetPoint("TOPLEFT", subheader, "BOTTOMLEFT", -16, -10)

	local pixel_font_style = ns.CreateDropDown(parent, "pixel_font_style", true, L.font_stats_font_style, FlagsTable)
	pixel_font_style:SetPoint("LEFT", pixel_font, "RIGHT", 150, 0)

	local pixel_font_size = ns.CreateNumberSlider(parent, "pixel_font_size", nil, nil, 8, 48, 1, true, FONT_SIZE)
	pixel_font_size:SetPoint("TOPLEFT", pixel_font, "BOTTOMLEFT", 16, -16)

	local LuaButton = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
	LuaButton:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -20, 5)
	LuaButton:SetSize(100, 23)
	LuaButton:SetText(L_GUI_EXPERT_MODE)
	LuaButton:SetWidth(LuaButton.Text:GetWidth() + 15)
	LuaButton:SetScript("OnClick", function()
		ShestakUIProfileFrameEditBox:SetText(C.media.profile)
		C_Timer.After(0, function()
			ShestakUIProfileFrameScroll:SetVerticalScroll(ShestakUIProfileFrameScroll:GetVerticalScrollRange() or 0)
		end)
		ShestakUIProfileFrame:Show()
	end)

	LuaButton:SetScript("OnEnter", function()
		GameTooltip:SetOwner(LuaButton, "ANCHOR_RIGHT", 5, 5)
		GameTooltip:SetText(L_GUI_EXPERT_MODE_DESC, nil, nil, nil, nil, true)
	end)

	LuaButton:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)

	tinsert(ns.buttons, LuaButton)

	-- Profile list frame
	local ProfileList = CreateFrame("Frame", "ProfileList", ShestakUIOptionsPanel, "ButtonFrameTemplate")
	ProfileList:SetPoint("TOPLEFT", ShestakUIOptionsPanel, "TOPRIGHT", 22, 0)
	ProfileList:SetSize(290, 420)
	ProfileList:Hide()
	ProfileListPortrait:SetAlpha(0)

	ProfileList.title = ProfileList:CreateFontString("ProfileListTitle", "OVERLAY", "GameFontNormal")
	ProfileList.title:SetPoint("TOP", _G["ProfileList"], "TOP", 0, -5)
	ProfileList.title:SetText(L.profile_title)

	local ProfileButton = CreateFrame("Button", "ShestakUIOptionsPanelProfileButton", options, "UIPanelButtonTemplate")
	ProfileButton:SetPoint("TOPRIGHT", -10, -8)
	ProfileButton:SetSize(100, 23)
	ProfileButton:SetText(L.profile)
	ProfileButton:SetScript("OnClick", function()
		if SpellList:IsVisible() then SpellList:Hide() end
		if ProfileList:IsVisible() then ProfileList:Hide() return end
		ProfileList:Show()
	end)

	tinsert(ns.buttons, ProfileButton)

	local ProfileListPanel = CreateFrame("Frame", "ProfileListPanel", _G["ProfileListInset"])
	ProfileListPanel:SetPoint("TOPLEFT", _G["ProfileListInset"], "TOPLEFT", -10, 20)
	ProfileListPanel:SetPoint("BOTTOMRIGHT", _G["ProfileListInset"], "BOTTOMRIGHT", -6, -5)

	local ProfileBox = CreateFrame("CheckButton", nil, ProfileList, "InterfaceOptionsCheckButtonTemplate")
	ProfileBox:SetPoint("TOPLEFT", ProfileList, "TOPLEFT", 1, -78)
	ProfileBox.tooltipText = L_GUI_SET_SAVED_SETTTINGS_DESC
	ProfileBox:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 0, 0)
		GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, true)
	end)

	ProfileBox:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)
	options.ProfileBox = ProfileBox

	local label = ProfileBox:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	label:SetText(L_GUI_SET_SAVED_SETTTINGS)
	label:SetTextColor(1, 1, 1)
	label:SetPoint("LEFT", ProfileBox, "RIGHT", 10, 0)
	label:SetWordWrap(false)
	label:SetWidth(230)

	local profileName
	StaticPopupDialogs.SHESTAKUI_RENAME_PROFILE = {
		text = PET_RENAME.." "..strlower(L.profile),
		button1 = ACCEPT,
		button2 = CANCEL,
		hasEditBox = true,
		editBoxWidth = 350,
		OnShow = function(self, text)
			self.editBox:SetMaxLetters(0)
			self.editBox:SetText(text)
			self.editBox:HighlightText()
			profileName = text
		end,
		EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
		EditBoxOnTextChanged = function(self)
			profileName = self:GetText()
		end,
		OnAccept = function()
			if not profileName or profileName == "" then return end
			if ShestakUIOptionsGlobal[realm][name] then
				local i = tostring(ShestakUIOptionsGlobal[realm]["Current_Profile"][name])
				if ShestakUIOptionsPerChar[i] then
					if not ShestakUIOptionsPerChar[i]["general"] then
						ShestakUIOptionsPerChar[i]["general"] = {}
					end
					ShestakUIOptionsPerChar[i]["general"]["profile_name"] = profileName
				end
			else
				local i = tostring(ShestakUIOptionsGlobal["Current_Profile"])
				if ShestakUIOptions[i] then
					if not ShestakUIOptions[i]["general"] then
						ShestakUIOptions[i]["general"] = {}
					end
					ShestakUIOptions[i]["general"]["profile_name"] = profileName
				end
			end
			UIDropDownMenu_SetText(ShestakUIOptionsPanelgeneralchoose_profileDropDown, profileName)
		end,
		whileDead = true,
		hideOnEscape = true,
	}

	local RenameButton = CreateFrame("Button", "ProfileListPaneRenameButton", ProfileList, "UIPanelButtonTemplate")
	RenameButton:SetPoint("TOPLEFT", ProfileBox, "TOPLEFT", 4, -34)
	RenameButton:SetSize(100, 23)
	RenameButton:SetText(PET_RENAME)
	RenameButton:SetWidth(RenameButton.Text:GetWidth() + 15)
	RenameButton:SetScript("OnClick", function()
		if ShestakUIOptionsGlobal then
			if ShestakUIOptionsGlobal[realm][name] then
				local i = tostring(ShestakUIOptionsGlobal[realm]["Current_Profile"][name])
				profileName = ShestakUIOptionsPerChar[i] and ShestakUIOptionsPerChar[i]["general"] and ShestakUIOptionsPerChar[i]["general"]["profile_name"] or i
			else
				local i = tostring(ShestakUIOptionsGlobal["Current_Profile"])
				profileName = ShestakUIOptions[i] and ShestakUIOptions[i]["general"] and ShestakUIOptions[i]["general"]["profile_name"] or i
			end
			StaticPopup_Show("SHESTAKUI_RENAME_PROFILE", _, _, profileName)
		end
	end)
	tinsert(ns.buttons, RenameButton)

	local status = ProfileListPanel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	status:SetPoint("BOTTOM", ProfileListPanel, "BOTTOM", 0, 35)
	status:SetWidth(200)
	status:SetTextColor(0.8, 0.2, 0)

	local selfTextExport
	StaticPopupDialogs.SHESTAKUI_EXPORT_PROFILE = {
		text = L.profile_export,
		button1 = OKAY,
		timeout = 0,
		whileDead = true,
		hasEditBox = true,
		editBoxWidth = 350,
		OnShow = function(self, text)
			self.editBox:SetMaxLetters(0)
			self.editBox:SetText(text)
			self.editBox:HighlightText()
			selfTextExport = text
		end,
		EditBoxOnEnterPressed = function(self) self:GetParent():Hide() end,
		EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
		EditBoxOnTextChanged = function(self)
			if self:GetText():len() < 1 then
				self:GetParent():Hide()
			else
				self:SetText(selfTextExport)
				self:HighlightText()
			end
		end,
		preferredIndex = 5,
	}

	local profileVar = "General"
	local function startExport()
		local Prefix = "ShestakUI:Profile:"
		local LibDeflate = LibStub:GetLibrary("LibDeflate")
		local LibSerialize = LibStub("LibSerialize")

		local Serialized
		if profileVar == "General" then
			local i = tostring(ShestakUIOptionsGlobal["Current_Profile"])
			Serialized = LibSerialize:Serialize(ShestakUIOptions[i])
		elseif profileVar == "Personal" then
			local i = tostring(ShestakUIOptionsGlobal[realm]["Current_Profile"][name])
			Serialized = LibSerialize:Serialize(ShestakUIOptionsPerChar[i])
		elseif profileVar == "Mover" then
			local i = tostring(ShestakUIOptionsGlobal["Current_Profile"])
			Serialized = LibSerialize:Serialize(ShestakUIPositions[i])
		elseif profileVar == "Mover_Personal" then
			local i = tostring(ShestakUIOptionsGlobal[realm]["Current_Profile"][name])
			Serialized = LibSerialize:Serialize(ShestakUIPositionsPerChar[i])
		end

		local Compressed = LibDeflate:CompressDeflate(Serialized)
		local Encoded = LibDeflate:EncodeForPrint(Compressed)
		local Result = Prefix..Encoded
		StaticPopup_Show("SHESTAKUI_EXPORT_PROFILE", _, _, Result)
	end

	local selfTextImport
	local importVar = "General"
	StaticPopupDialogs.SHESTAKUI_IMPORT_PROFILE = {
		text = L.profile_import,
		button1 = ACCEPT,
		button2 = CANCEL,
		timeout = 0,
		whileDead = true,
		hasEditBox = true,
		editBoxWidth = 350,
		EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
		EditBoxOnTextChanged = function(self)
			selfTextImport = self:GetText()
		end,
		OnAccept = function(self)
			local Code = selfTextImport
			local Prefix = "ShestakUI:Profile:"
			local LibDeflate = LibStub:GetLibrary("LibDeflate")
			local LibSerialize = LibStub("LibSerialize")

			local LibCode = string.gsub(Code, Prefix, "")
			local Decoded = LibDeflate:DecodeForPrint(LibCode)

			if Decoded then
				local Decompressed = LibDeflate:DecompressDeflate(Decoded)
				local Success, Table = LibSerialize:Deserialize(Decompressed)
				if Success then
					if profileVar == "General" then
						local i = tostring(ShestakUIOptionsGlobal["Current_Profile"])
						ShestakUIOptions[i] = Table
					elseif profileVar == "Personal" then
						local i = tostring(ShestakUIOptionsGlobal[realm]["Current_Profile"][name])
						ShestakUIOptionsPerChar[i] = Table
					elseif profileVar == "Mover" then
						local i = tostring(ShestakUIOptionsGlobal["Current_Profile"])
						ShestakUIPositions[i] = Table
					elseif profileVar == "Mover_Personal" then
						local i = tostring(ShestakUIOptionsGlobal[realm]["Current_Profile"][name])
						ShestakUIPositionsPerChar[i] = Table
					end
					ReloadUI()
				else
					status:SetText(L.profile_error_code)
				end
			else
				status:SetText(L.profile_error_code)
			end
		end,
		preferredIndex = 5,
	}

	local subheader = ProfileListPanel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	subheader:SetPoint("TOPLEFT", RenameButton, 15, -40)
	subheader:SetText(L.profile_options)
	subheader:SetTextColor(179/255, 211/255, 243/255)

	local ExportButton = CreateFrame("Button", "ProfileListPanelExportButton", ProfileList, "UIPanelButtonTemplate")
	ExportButton:SetPoint("TOPLEFT", subheader, 10, -20)
	ExportButton:SetSize(100, 23)
	ExportButton:SetText(L.profile_export)
	ExportButton:SetScript("OnClick", function()
		profileVar = ShestakUIOptionsGlobal[realm][name] and "Personal" or "General"
		startExport()
	end)

	tinsert(ns.buttons, ExportButton)

	local ImportButton = CreateFrame("Button", "ProfileListPaneImportButton", ProfileList, "UIPanelButtonTemplate")
	ImportButton:SetPoint("LEFT", ExportButton, "RIGHT", 10, 0)
	ImportButton:SetSize(100, 23)
	ImportButton:SetText(L.profile_import)
	ImportButton:SetScript("OnClick", function()
		profileVar = ShestakUIOptionsGlobal[realm][name] and "Personal" or "General"
		StaticPopup_Show("SHESTAKUI_IMPORT_PROFILE")
	end)

	tinsert(ns.buttons, ImportButton)

	local subheader = ProfileListPanel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	subheader:SetPoint("TOPLEFT", ExportButton, -10, -35)
	subheader:SetText(L.profile_movers)
	subheader:SetTextColor(179/255, 211/255, 243/255)

	local ExportMoveButton = CreateFrame("Button", "ProfileListPanelExportMoveButton", ProfileList, "UIPanelButtonTemplate")
	ExportMoveButton:SetPoint("TOPLEFT", subheader, 10, -20)
	ExportMoveButton:SetSize(100, 23)
	ExportMoveButton:SetText(L.profile_export)
	ExportMoveButton:SetScript("OnClick", function()
		profileVar = ShestakUIOptionsGlobal[realm][name] and "Mover_Personal" or "Mover"
		startExport()
	end)

	tinsert(ns.buttons, ExportMoveButton)

	local ImportMoveButton = CreateFrame("Button", "ProfileListPaneImportMoveButton", ProfileList, "UIPanelButtonTemplate")
	ImportMoveButton:SetPoint("LEFT", ExportMoveButton, "RIGHT", 10, 0)
	ImportMoveButton:SetSize(100, 23)
	ImportMoveButton:SetText(L.profile_import)
	ImportMoveButton:SetScript("OnClick", function()
		profileVar = ShestakUIOptionsGlobal[realm][name] and "Mover_Personal" or "Mover"
		StaticPopup_Show("SHESTAKUI_IMPORT_PROFILE")
	end)

	tinsert(ns.buttons, ImportMoveButton)

	C_Timer.After(0.3, function() -- need to grab SavedVariables and loaded libraries
		local LibDeflate = LibStub and LibStub:GetLibrary("LibDeflate", true)
		local LibSerialize = LibStub and LibStub:GetLibrary("LibSerialize", true)
		local LibsExist = LibDeflate and LibSerialize

		if not LibsExist then
			ExportButton:Disable()
			ImportButton:Disable()
			ExportMoveButton:Disable()
			ImportMoveButton:Disable()
			status:SetText(L.profile_error_lib)
		end

		-- Use existing function in Core.lua to create dropdown with name via SavedVariables
		local function SaveValue(f, value)
			if not C.options[f.group] then C.options[f.group] = {} end
			if not C.options[f.group][f.option] then C.options[f.group][f.option] = {} end

			C.options[f.group][f.option] = value -- these are the saved variables
			C[f.group][f.option] = value -- and this is from the lua options
		end

		local old = {}
		local function checkIsReloadNeeded()
			for frame, value in pairs(old) do
				if C[frame.group][frame.option] ~= value then
					ns.setReloadNeeded(true)
					return
				end
			end

			ns.setReloadNeeded(false)
		end

		local function GetProfileName(key)
			if ShestakUIOptionsGlobal[realm][name] then
				local i = tostring(key)
				if ShestakUIOptionsPerChar[i] and ShestakUIOptionsPerChar[i]["general"] and ShestakUIOptionsPerChar[i]["general"]["profile_name"] then
					return ShestakUIOptionsPerChar[i]["general"]["profile_name"]
				end
			else
				local i = tostring(key)
				if ShestakUIOptions[i] and ShestakUIOptions[i]["general"] and ShestakUIOptions[i]["general"]["profile_name"] then
					return ShestakUIOptions[i]["general"]["profile_name"]
				end
			end
		end

		local CreateDropDown = function(parent, option, needsReload, text, tableValue)
			local f = CreateFrame("Frame", parent:GetName()..option.."DropDown", parent, "UIDropDownMenuTemplate")
			UIDropDownMenu_SetWidth(f, 110)

			UIDropDownMenu_Initialize(f, function(self)
				local info = UIDropDownMenu_CreateInfo()
				info.func = self.SetValue
				for key, value in pairs(tableValue) do
					info.text = GetProfileName(key) or value
					info.arg1 = value
					info.arg2 = key
					info.checked = value == f.selectedValue

					if isFont then
						local fObject = CreateFont(info.text)
						fObject:SetFont(value, 12, "")
						info.fontObject = fObject
					end
					UIDropDownMenu_AddButton(info)
				end
			end)

			function f:SetValue(newValue, newkey)
				f.selectedValue = newValue
				local text = GetProfileName(newkey) or newValue
				UIDropDownMenu_SetText(f, text)
				if ShestakUIOptionsGlobal[realm][name] then
					ShestakUIOptionsGlobal[realm]["Current_Profile"][name] = newValue
				else
					ShestakUIOptionsGlobal["Current_Profile"] = newValue
				end
				SaveValue(f, newValue)
				old[f] = f.oldValue
				checkIsReloadNeeded()
				CloseDropDownMenus()
			end

			local label = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
			if text then
				label:SetText(text)
			else
				label:SetText(ns[parent.tag.."_"..option])
			end
			label:SetHeight(20)
			label:SetJustifyH("LEFT")
			label:SetPoint("LEFT", 160, 4)
			f.label = label

			f.tooltipText = ns[parent.tag.."_"..option.."_desc"]
			if f.tooltipText then
				f:SetScript("OnEnter", function()
					GameTooltip:SetOwner(f, "ANCHOR_RIGHT", 0, 0)
					GameTooltip:SetText(f.tooltipText, nil, nil, nil, nil, true)
				end)

				f:SetScript("OnLeave", function()
					GameTooltip:Hide()
				end)
			end

			f.group = parent.tag
			f.option = option

			f.needsReload = needsReload

			parent[option] = f

			return f
		end

		local choose_profile = CreateDropDown(ShestakUIOptionsPanel.general, "choose_profile", true, L.profile_choose, {1, 2, 3})
		choose_profile:SetPoint("TOPLEFT", ProfileList, "TOPLEFT", -15, -46)
		choose_profile:SetParent(ProfileListPanel)

		local value = ShestakUIOptionsGlobal[realm][name] and ShestakUIOptionsGlobal[realm]["Current_Profile"][name] or ShestakUIOptionsGlobal["Current_Profile"]
		choose_profile.selectedValue = value
		choose_profile.oldValue = value

		local text
		if ShestakUIOptionsGlobal[realm][name] then
			local i = tostring(ShestakUIOptionsGlobal[realm]["Current_Profile"][name])
			text = ShestakUIOptionsPerChar[i] and ShestakUIOptionsPerChar[i]["general"] and ShestakUIOptionsPerChar[i]["general"]["profile_name"]
		else
			local i = tostring(ShestakUIOptionsGlobal["Current_Profile"])
			text = ShestakUIOptions[i] and ShestakUIOptions[i]["general"] and ShestakUIOptions[i]["general"]["profile_name"]
		end
		text = text or value
		UIDropDownMenu_SetText(choose_profile, text)
	end)
end

-- Font
do
	local parent = ShestakUIOptionsPanel.font

	local subheader = ns.addSubCategory(parent, L.font_subheader_unit)
	subheader:SetPoint("TOPLEFT", parent.subText, "BOTTOMLEFT", 0, 0)

	local unit_frames_font = ns.CreateDropDown(parent, "unit_frames_font", true, L.font_stats_font, FontTable, LSM and true, true)
	unit_frames_font:SetPoint("TOPLEFT", subheader, "BOTTOMLEFT", -16, -10)

	local unit_frames_font_style = ns.CreateDropDown(parent, "unit_frames_font_style", true, L.font_stats_font_style, FlagsTable)
	unit_frames_font_style:SetPoint("LEFT", unit_frames_font, "RIGHT", 150, 0)

	local unit_frames_font_size = ns.CreateNumberSlider(parent, "unit_frames_font_size", nil, nil, 8, 48, 1, true, FONT_SIZE)
	unit_frames_font_size:SetPoint("TOPLEFT", unit_frames_font, "BOTTOMLEFT", 16, -16)

	local unit_frames_font_shadow = ns.CreateCheckBox(parent, "unit_frames_font_shadow", L.font_stats_font_shadow)
	unit_frames_font_shadow:SetPoint("LEFT", unit_frames_font_size, "RIGHT", 160, 0)

	local subheader = ns.addSubCategory(parent, L.font_subheader_aura)
	subheader:SetPoint("TOPLEFT", unit_frames_font_size, "BOTTOMLEFT", 0, -10)

	local auras_font = ns.CreateDropDown(parent, "auras_font", true, L.font_stats_font, FontTable, LSM and true, true)
	auras_font:SetPoint("TOPLEFT", subheader, "BOTTOMLEFT", -16, -10)

	local auras_font_style = ns.CreateDropDown(parent, "auras_font_style", true, L.font_stats_font_style, FlagsTable)
	auras_font_style:SetPoint("LEFT", auras_font, "RIGHT", 150, 0)

	local auras_font_size = ns.CreateNumberSlider(parent, "auras_font_size", nil, nil, 8, 48, 1, true, FONT_SIZE)
	auras_font_size:SetPoint("TOPLEFT", auras_font, "BOTTOMLEFT", 16, -16)

	local auras_font_shadow = ns.CreateCheckBox(parent, "auras_font_shadow", L.font_stats_font_shadow)
	auras_font_shadow:SetPoint("LEFT", auras_font_size, "RIGHT", 160, 0)

	local subheader = ns.addSubCategory(parent, L.font_subheader_nameplates)
	subheader:SetPoint("TOPLEFT", auras_font_size, "BOTTOMLEFT", 0, -10)

	local nameplates_font = ns.CreateDropDown(parent, "nameplates_font", true, L.font_stats_font, FontTable, LSM and true, true)
	nameplates_font:SetPoint("TOPLEFT", subheader, "BOTTOMLEFT", -16, -10)

	local nameplates_font_style = ns.CreateDropDown(parent, "nameplates_font_style", true, L.font_stats_font_style, FlagsTable)
	nameplates_font_style:SetPoint("LEFT", nameplates_font, "RIGHT", 150, 0)

	local nameplates_font_size = ns.CreateNumberSlider(parent, "nameplates_font_size", nil, nil, 8, 48, 1, true, FONT_SIZE)
	nameplates_font_size:SetPoint("TOPLEFT", nameplates_font, "BOTTOMLEFT", 16, -16)

	local nameplates_font_shadow = ns.CreateCheckBox(parent, "nameplates_font_shadow", L.font_stats_font_shadow)
	nameplates_font_shadow:SetPoint("LEFT", nameplates_font_size, "RIGHT", 160, 0)

	local subheader = ns.addSubCategory(parent, L.font_subheader_action)
	subheader:SetPoint("TOPLEFT", nameplates_font_size, "BOTTOMLEFT", 0, -10)

	local action_bars_font = ns.CreateDropDown(parent, "action_bars_font", true, L.font_stats_font, FontTable, LSM and true, true)
	action_bars_font:SetPoint("TOPLEFT", subheader, "BOTTOMLEFT", -16, -10)

	local action_bars_font_style = ns.CreateDropDown(parent, "action_bars_font_style", true, L.font_stats_font_style, FlagsTable)
	action_bars_font_style:SetPoint("LEFT", action_bars_font, "RIGHT", 150, 0)

	local action_bars_font_size = ns.CreateNumberSlider(parent, "action_bars_font_size", nil, nil, 8, 48, 1, true, FONT_SIZE)
	action_bars_font_size:SetPoint("TOPLEFT", action_bars_font, "BOTTOMLEFT", 16, -16)

	local action_bars_font_shadow = ns.CreateCheckBox(parent, "action_bars_font_shadow", L.font_stats_font_shadow)
	action_bars_font_shadow:SetPoint("LEFT", action_bars_font_size, "RIGHT", 160, 0)

	local subheader = ns.addSubCategory(parent, L.font_subheader_cooldown)
	subheader:SetPoint("TOPLEFT", action_bars_font_size, "BOTTOMLEFT", 0, -10)

	local cooldown_timers_font = ns.CreateDropDown(parent, "cooldown_timers_font", true, L.font_stats_font, FontTable, LSM and true, true)
	cooldown_timers_font:SetPoint("TOPLEFT", subheader, "BOTTOMLEFT", -16, -10)

	local cooldown_timers_font_style = ns.CreateDropDown(parent, "cooldown_timers_font_style", true, L.font_stats_font_style, FlagsTable)
	cooldown_timers_font_style:SetPoint("LEFT", cooldown_timers_font, "RIGHT", 150, 0)

	local cooldown_timers_font_size = ns.CreateNumberSlider(parent, "cooldown_timers_font_size", nil, nil, 8, 48, 1, true, FONT_SIZE)
	cooldown_timers_font_size:SetPoint("TOPLEFT", cooldown_timers_font, "BOTTOMLEFT", 16, -16)

	local cooldown_timers_font_shadow = ns.CreateCheckBox(parent, "cooldown_timers_font_shadow", L.font_stats_font_shadow)
	cooldown_timers_font_shadow:SetPoint("LEFT", cooldown_timers_font_size, "RIGHT", 160, 0)

	local global_font = ns.CreateCheckBox(parent, "global_font")
	global_font:SetPoint("TOPLEFT", cooldown_timers_font_size, "BOTTOMLEFT", 0, -30)

	-- Panel 2
	local parent = ShestakUIOptionsPanel.font2

	local subheader = ns.addSubCategory(parent, L.font_subheader_combat)
	subheader:SetPoint("TOPLEFT", parent.subText, "BOTTOMLEFT", 0, 0)

	local combat_text_font = ns.CreateDropDown(parent, "combat_text_font", true, L.font_stats_font, FontTable, LSM and true, true)
	combat_text_font:SetPoint("TOPLEFT", subheader, "BOTTOMLEFT", -16, -10)

	local combat_text_font_style = ns.CreateDropDown(parent, "combat_text_font_style", true, L.font_stats_font_style, FlagsTable)
	combat_text_font_style:SetPoint("LEFT", combat_text_font, "RIGHT", 150, 0)

	local combat_text_font_size = ns.CreateNumberSlider(parent, "combat_text_font_size", nil, nil, 8, 48, 1, true, FONT_SIZE)
	combat_text_font_size:SetPoint("TOPLEFT", combat_text_font, "BOTTOMLEFT", 16, -16)

	local combat_text_font_shadow = ns.CreateCheckBox(parent, "combat_text_font_shadow", L.font_stats_font_shadow)
	combat_text_font_shadow:SetPoint("LEFT", combat_text_font_size, "RIGHT", 160, 0)

	local subheader = ns.addSubCategory(parent, L.font_subheader_filger)
	subheader:SetPoint("TOPLEFT", combat_text_font_size, "BOTTOMLEFT", 0, -10)

	local filger_font = ns.CreateDropDown(parent, "filger_font", true, L.font_stats_font, FontTable, LSM and true, true)
	filger_font:SetPoint("TOPLEFT", subheader, "BOTTOMLEFT", -16, -10)

	local filger_font_style = ns.CreateDropDown(parent, "filger_font_style", true, L.font_stats_font_style, FlagsTable)
	filger_font_style:SetPoint("LEFT", filger_font, "RIGHT", 150, 0)

	local filger_font_size = ns.CreateNumberSlider(parent, "filger_font_size", nil, nil, 8, 48, 1, true, FONT_SIZE)
	filger_font_size:SetPoint("TOPLEFT", filger_font, "BOTTOMLEFT", 16, -16)

	local filger_font_shadow = ns.CreateCheckBox(parent, "filger_font_shadow", L.font_stats_font_shadow)
	filger_font_shadow:SetPoint("LEFT", filger_font_size, "RIGHT", 160, 0)

	local subheader = ns.addSubCategory(parent, L.font_subheader_threat)
	subheader:SetPoint("TOPLEFT", filger_font_size, "BOTTOMLEFT", 0, -10)

	local threat_meter_font = ns.CreateDropDown(parent, "threat_meter_font", true, L.font_stats_font, FontTable, LSM and true, true)
	threat_meter_font:SetPoint("TOPLEFT", subheader, "BOTTOMLEFT", -16, -10)

	local threat_meter_font_style = ns.CreateDropDown(parent, "threat_meter_font_style", true, L.font_stats_font_style, FlagsTable)
	threat_meter_font_style:SetPoint("LEFT", threat_meter_font, "RIGHT", 150, 0)

	local threat_meter_font_size = ns.CreateNumberSlider(parent, "threat_meter_font_size", nil, nil, 8, 48, 1, true, FONT_SIZE)
	threat_meter_font_size:SetPoint("TOPLEFT", threat_meter_font, "BOTTOMLEFT", 16, -16)

	local threat_meter_font_shadow = ns.CreateCheckBox(parent, "threat_meter_font_shadow", L.font_stats_font_shadow)
	threat_meter_font_shadow:SetPoint("LEFT", threat_meter_font_size, "RIGHT", 160, 0)

	local subheader = ns.addSubCategory(parent, L.font_subheader_raidcd)
	subheader:SetPoint("TOPLEFT", threat_meter_font_size, "BOTTOMLEFT", 0, -10)

	local raid_cooldowns_font = ns.CreateDropDown(parent, "raid_cooldowns_font", true, L.font_stats_font, FontTable, LSM and true, true)
	raid_cooldowns_font:SetPoint("TOPLEFT", subheader, "BOTTOMLEFT", -16, -10)

	local raid_cooldowns_font_style = ns.CreateDropDown(parent, "raid_cooldowns_font_style", true, L.font_stats_font_style, FlagsTable)
	raid_cooldowns_font_style:SetPoint("LEFT", raid_cooldowns_font, "RIGHT", 150, 0)

	local raid_cooldowns_font_size = ns.CreateNumberSlider(parent, "raid_cooldowns_font_size", nil, nil, 8, 48, 1, true, FONT_SIZE)
	raid_cooldowns_font_size:SetPoint("TOPLEFT", raid_cooldowns_font, "BOTTOMLEFT", 16, -16)

	local raid_cooldowns_font_shadow = ns.CreateCheckBox(parent, "raid_cooldowns_font_shadow", L.font_stats_font_shadow)
	raid_cooldowns_font_shadow:SetPoint("LEFT", raid_cooldowns_font_size, "RIGHT", 160, 0)

	local subheader = ns.addSubCategory(parent, L.font_subheader_loot)
	subheader:SetPoint("TOPLEFT", raid_cooldowns_font_size, "BOTTOMLEFT", 0, -10)

	local loot_font = ns.CreateDropDown(parent, "loot_font", true, L.font_stats_font, FontTable, LSM and true, true)
	loot_font:SetPoint("TOPLEFT", subheader, "BOTTOMLEFT", -16, -10)

	local loot_font_style = ns.CreateDropDown(parent, "loot_font_style", true, L.font_stats_font_style, FlagsTable)
	loot_font_style:SetPoint("LEFT", loot_font, "RIGHT", 150, 0)

	local loot_font_size = ns.CreateNumberSlider(parent, "loot_font_size", nil, nil, 8, 48, 1, true, FONT_SIZE)
	loot_font_size:SetPoint("TOPLEFT", loot_font, "BOTTOMLEFT", 16, -16)

	local loot_font_shadow = ns.CreateCheckBox(parent, "loot_font_shadow", L.font_stats_font_shadow)
	loot_font_shadow:SetPoint("LEFT", loot_font_size, "RIGHT", 160, 0)

	-- Panel 3
	local parent = ShestakUIOptionsPanel.font3

	local subheader = ns.addSubCategory(parent, L.font_subheader_bag)
	subheader:SetPoint("TOPLEFT", parent.subText, "BOTTOMLEFT", 0, 0)

	local bags_font = ns.CreateDropDown(parent, "bags_font", true, L.font_stats_font, FontTable, LSM and true, true)
	bags_font:SetPoint("TOPLEFT", subheader, "BOTTOMLEFT", -16, -10)

	local bags_font_style = ns.CreateDropDown(parent, "bags_font_style", true, L.font_stats_font_style, FlagsTable)
	bags_font_style:SetPoint("LEFT", bags_font, "RIGHT", 150, 0)

	local bags_font_size = ns.CreateNumberSlider(parent, "bags_font_size", nil, nil, 8, 48, 1, true, FONT_SIZE)
	bags_font_size:SetPoint("TOPLEFT", bags_font, "BOTTOMLEFT", 16, -16)

	local bags_font_shadow = ns.CreateCheckBox(parent, "bags_font_shadow", L.font_stats_font_shadow)
	bags_font_shadow:SetPoint("LEFT", bags_font_size, "RIGHT", 160, 0)

	local subheader = ns.addSubCategory(parent, L.font_subheader_chat)
	subheader:SetPoint("TOPLEFT", bags_font_size, "BOTTOMLEFT", 0, -10)

	local chat_font = ns.CreateDropDown(parent, "chat_font", true, L.font_stats_font, FontTable, LSM and true, true)
	chat_font:SetPoint("TOPLEFT", subheader, "BOTTOMLEFT", -16, -10)

	local chat_font_style = ns.CreateDropDown(parent, "chat_font_style", true, L.font_stats_font_style, FlagsTable)
	chat_font_style:SetPoint("LEFT", chat_font, "RIGHT", 150, 0)

	local chat_font_shadow = ns.CreateCheckBox(parent, "chat_font_shadow", L.font_stats_font_shadow)
	chat_font_shadow:SetPoint("TOPLEFT", chat_font, "BOTTOMLEFT", 16, -7)

	local subheader = ns.addSubCategory(parent, L.font_subheader_chat_tabs)
	subheader:SetPoint("TOPLEFT", chat_font_shadow, "BOTTOMLEFT", 0, -10)

	local chat_tabs_font = ns.CreateDropDown(parent, "chat_tabs_font", true, L.font_stats_font, FontTable, LSM and true, true)
	chat_tabs_font:SetPoint("TOPLEFT", subheader, "BOTTOMLEFT", -16, -10)

	local chat_tabs_font_style = ns.CreateDropDown(parent, "chat_tabs_font_style", true, L.font_stats_font_style, FlagsTable)
	chat_tabs_font_style:SetPoint("LEFT", chat_tabs_font, "RIGHT", 150, 0)

	local chat_tabs_font_size = ns.CreateNumberSlider(parent, "chat_tabs_font_size", nil, nil, 8, 48, 1, true, FONT_SIZE)
	chat_tabs_font_size:SetPoint("TOPLEFT", chat_tabs_font, "BOTTOMLEFT", 16, -16)

	local chat_tabs_font_shadow = ns.CreateCheckBox(parent, "chat_tabs_font_shadow", L.font_stats_font_shadow)
	chat_tabs_font_shadow:SetPoint("LEFT", chat_tabs_font_size, "RIGHT", 160, 0)

	local subheader = ns.addSubCategory(parent, L.font_subheader_style)
	subheader:SetPoint("TOPLEFT", chat_tabs_font_size, "BOTTOMLEFT", 0, -10)

	local stylization_font = ns.CreateDropDown(parent, "stylization_font", true, L.font_stats_font, FontTable, LSM and true, true)
	stylization_font:SetPoint("TOPLEFT", subheader, "BOTTOMLEFT", -16, -10)

	local stylization_font_style = ns.CreateDropDown(parent, "stylization_font_style", true, L.font_stats_font_style, FlagsTable)
	stylization_font_style:SetPoint("LEFT", stylization_font, "RIGHT", 150, 0)

	local stylization_font_size = ns.CreateNumberSlider(parent, "stylization_font_size", nil, nil, 8, 48, 1, true, FONT_SIZE)
	stylization_font_size:SetPoint("TOPLEFT", stylization_font, "BOTTOMLEFT", 16, -16)

	local stylization_font_shadow = ns.CreateCheckBox(parent, "stylization_font_shadow", L.font_stats_font_shadow)
	stylization_font_shadow:SetPoint("LEFT", stylization_font_size, "RIGHT", 160, 0)

	local subheader = ns.addSubCategory(parent, L.font_subheader_stats)
	subheader:SetPoint("TOPLEFT", stylization_font_size, "BOTTOMLEFT", 0, -10)

	local stats_font = ns.CreateDropDown(parent, "stats_font", true, nil, FontTable, LSM and true, true)
	stats_font:SetPoint("TOPLEFT", subheader, "BOTTOMLEFT", -16, -10)

	local stats_font_style = ns.CreateDropDown(parent, "stats_font_style", true, nil, FlagsTable)
	stats_font_style:SetPoint("LEFT", stats_font, "RIGHT", 150, 0)

	local stats_font_size = ns.CreateNumberSlider(parent, "stats_font_size", nil, nil, 8, 48, 1, true, FONT_SIZE)
	stats_font_size:SetPoint("TOPLEFT", stats_font, "BOTTOMLEFT", 16, -16)

	local stats_font_shadow = ns.CreateCheckBox(parent, "stats_font_shadow")
	stats_font_shadow:SetPoint("LEFT", stats_font_size, "RIGHT", 160, 0)

	-- Panel 3
	local parent = ShestakUIOptionsPanel.font4

	local subheader = ns.addSubCategory(parent, L.font_subheader_blizzard)
	subheader:SetPoint("TOPLEFT", parent.subText, "BOTTOMLEFT", 0, 0)

	local tooltip_header_font_size = ns.CreateNumberSlider(parent, "tooltip_header_font_size", nil, nil, 10, 22, 1, true)
	tooltip_header_font_size:SetPoint("TOPLEFT", subheader, "BOTTOMLEFT", 0, -30)

	local tooltip_font_size = ns.CreateNumberSlider(parent, "tooltip_font_size", nil, nil, 10, 22, 1, true)
	tooltip_font_size:SetPoint("LEFT", tooltip_header_font_size, "RIGHT", 120, 0)

	local bubble_font_size = ns.CreateNumberSlider(parent, "bubble_font_size", nil, nil, 10, 24, 1, true, CHAT_BUBBLES_TEXT)
	bubble_font_size:SetPoint("TOPLEFT", tooltip_header_font_size, "BOTTOMLEFT", 0, -20)

	local quest_tracker_font_mult = ns.CreateNumberSlider(parent, "quest_tracker_font_mult", nil, nil, 1, 1.7, 0.05, true)
	quest_tracker_font_mult:SetPoint("LEFT", bubble_font_size, "RIGHT", 120, 0)
end

-- Skins
do
	local parent = ShestakUIOptionsPanel.skins

	local blizzard_frames = ns.CreateCheckBox(parent, "blizzard_frames", L_GUI_SKINS_BLIZZARD)
	blizzard_frames:SetPoint("TOPLEFT", parent.subText, "BOTTOMLEFT", 0, 0)

	local bubbles = ns.CreateCheckBox(parent, "bubbles")
	bubbles:SetPoint("TOPLEFT", blizzard_frames, "BOTTOMLEFT", 0, 0)

	local minimap_buttons = ns.CreateCheckBox(parent, "minimap_buttons", L_GUI_SKINS_MINIMAP_BUTTONS)
	minimap_buttons:SetPoint("TOPLEFT", bubbles, "BOTTOMLEFT", 0, 0)

	local minimap_buttons_mouseover = ns.CreateCheckBox(parent, "minimap_buttons_mouseover")
	minimap_buttons_mouseover:SetPoint("TOPLEFT", minimap_buttons, "BOTTOMLEFT", 20, 0)

	-- Addons
	local subheader = ns.addSubCategory(parent, L_GUI_SKINS_SUBHEADER)
	subheader:SetPoint("TOPLEFT", minimap_buttons_mouseover, "BOTTOMLEFT", -20, -16)

	local ace3 = ns.CreateCheckBox(parent, "ace3")
	ace3:SetPoint("TOPLEFT", subheader, "BOTTOMLEFT", 0, -8)

	local skinTable = {
		{"atlasloot"},
		{"bigwigs"},
		{"blood_shield_tracker"},
		{"capping"},
		{"clique"},
		{"cool_line"},
		{"dbm"},
		{"details"},
		{"dominos"},
		{"flyout_button"},
		{"ls_toasts"},
		{"mage_nuggets"},
		{"my_role_play"},
		{"npcscan"},
		{"nug_running"},
		{"omen"},
		{"opie"},
		{"ovale"},
		{"plater"},
		{"postal"},
		{"recount"},
		{"rematch"},
		{"skada"},
		{"tiny_dps"},
		{"vanaskos"},
		{"weak_auras"},
	}

	local last
	for i = 1, #skinTable do
		local name = tostring(unpack(skinTable[i]))
		local addon
		if i == 1 then
			addon = ns.CreateCheckBox(parent, name)
			addon:SetPoint("LEFT", ace3, "RIGHT", 320, 0)
			last = ace3
		elseif i % 2 == 0 then
			addon = ns.CreateCheckBox(parent, name)
			addon:SetPoint("TOPLEFT", last, "BOTTOMLEFT", 0, 0)
			last = addon
		else
			addon = ns.CreateCheckBox(parent, name)
			addon:SetPoint("LEFT", last, "RIGHT", 320, 0)
		end
	end
end

-- Unit Frames
do
	local parent = ShestakUIOptionsPanel.unitframe

	local enable = ns.CreateCheckBox(parent, "enable", L_GUI_UF_ENABLE)
	enable:SetPoint("TOPLEFT", parent.subText, "BOTTOMLEFT", 0, 0)

	local own_color = ns.CreateCheckBox(parent, "own_color", L_GUI_UF_OWN_COLOR)
	own_color:SetPoint("TOPLEFT", enable, "BOTTOMLEFT", 0, 0)

	local uf_color = ns.CreateColourPicker(parent, "uf_color", true, L_GUI_UF_UF_COLOR)
	uf_color:SetPoint("TOPLEFT", own_color, "BOTTOMLEFT", 24, -4)

	local uf_color_bg = ns.CreateColourPicker(parent, "uf_color_bg", true)
	uf_color_bg:SetPoint("LEFT", uf_color, "RIGHT", 248, 0)

	local enemy_health_color = ns.CreateCheckBox(parent, "enemy_health_color")
	enemy_health_color:SetPoint("TOPLEFT", uf_color, "BOTTOMLEFT", -24, -4)

	local show_total_value = ns.CreateCheckBox(parent, "show_total_value", L_GUI_UF_TOTAL_VALUE)
	show_total_value:SetPoint("TOPLEFT", enemy_health_color, "BOTTOMLEFT", 0, 0)

	local color_value = ns.CreateCheckBox(parent, "color_value", L_GUI_UF_COLOR_VALUE)
	color_value:SetPoint("TOPLEFT", show_total_value, "BOTTOMLEFT", 0, 0)

	local bar_color_value = ns.CreateCheckBox(parent, "bar_color_value", L_GUI_UF_BAR_COLOR_VALUE)
	bar_color_value:SetPoint("TOPLEFT", color_value, "BOTTOMLEFT", 0, 0)

	local lines = ns.CreateCheckBox(parent, "lines", L_GUI_UF_LINES)
	lines:SetPoint("TOPLEFT", bar_color_value, "BOTTOMLEFT", 0, 0)

	-- Cast bars
	local subheader = ns.addSubCategory(parent, L_GUI_UF_SUBHEADER_CAST)
	subheader:SetPoint("TOPLEFT", lines, "BOTTOMLEFT", 0, -16)

	local unit_castbar = ns.CreateCheckBox(parent, "unit_castbar", L_GUI_UF_UNIT_CASTBAR)
	unit_castbar:SetPoint("TOPLEFT", subheader, "BOTTOMLEFT", 0, -8)

	local castbar_icon = ns.CreateCheckBox(parent, "castbar_icon", L_GUI_UF_CASTBAR_ICON)
	castbar_icon:SetPoint("TOPLEFT", unit_castbar, "BOTTOMLEFT", 0, 0)

	local castbar_latency = ns.CreateCheckBox(parent, "castbar_latency", L_GUI_UF_CASTBAR_LATENCY)
	castbar_latency:SetPoint("TOPLEFT", castbar_icon, "BOTTOMLEFT", 0, 0)

	local castbar_ticks = ns.CreateCheckBox(parent, "castbar_ticks", L_GUI_UF_CASTBAR_TICKS)
	castbar_ticks:SetPoint("TOPLEFT", castbar_latency, "BOTTOMLEFT", 0, 0)

	local castbar_focus_type = ns.CreateDropDown(parent, "castbar_focus_type", true, L.unitframe_castbar_focus_type, {"ICON", "BAR", "NONE"})
	castbar_focus_type:SetPoint("TOPLEFT", castbar_ticks, "BOTTOMLEFT", -16, -2)

	-- Frames
	local subheader = ns.addSubCategory(parent, L_GUI_UF_SUBHEADER_FRAMES)
	subheader:SetPoint("TOPLEFT", castbar_focus_type, "BOTTOMLEFT", 16, -11)

	local show_pet = ns.CreateCheckBox(parent, "show_pet", L_GUI_UF_SHOW_PET)
	show_pet:SetPoint("TOPLEFT", subheader, "BOTTOMLEFT", 0, -8)

	local show_focus = ns.CreateCheckBox(parent, "show_focus", L_GUI_UF_SHOW_FOCUS)
	show_focus:SetPoint("TOPLEFT", show_pet, "BOTTOMLEFT", 0, 0)

	local show_target_target = ns.CreateCheckBox(parent, "show_target_target", L_GUI_UF_SHOW_TOT)
	show_target_target:SetPoint("LEFT", show_focus, "RIGHT", 248, 0)
	show_target_target.Text:SetWidth(270)

	local show_boss = ns.CreateCheckBox(parent, "show_boss", L_GUI_UF_SHOW_BOSS)
	show_boss:SetPoint("TOPLEFT", show_focus, "BOTTOMLEFT", 0, 0)

	local boss_on_right = ns.CreateCheckBox(parent, "boss_on_right", L_GUI_UF_BOSS_RIGHT)
	boss_on_right:SetPoint("LEFT", show_boss, "RIGHT", 248, 0)
	boss_on_right.Text:SetWidth(270)

	local show_arena = ns.CreateCheckBox(parent, "show_arena", L_GUI_UF_SHOW_ARENA)
	show_arena:SetPoint("TOPLEFT", show_boss, "BOTTOMLEFT", 0, 0)

	local arena_on_right = ns.CreateCheckBox(parent, "arena_on_right", L_GUI_UF_ARENA_RIGHT)
	arena_on_right:SetPoint("LEFT", show_arena, "RIGHT", 248, 0)

	-- Panel 2
	local parent = ShestakUIOptionsPanel.unitframe2

	local icons_pvp = ns.CreateCheckBox(parent, "icons_pvp")
	icons_pvp:SetPoint("TOPLEFT", parent.subText, "BOTTOMLEFT", 0, 0)

	local icons_combat = ns.CreateCheckBox(parent, "icons_combat", L_GUI_UF_ICONS_COMBAT)
	icons_combat:SetPoint("TOPLEFT", icons_pvp, "BOTTOMLEFT", 0, 0)

	local icons_resting = ns.CreateCheckBox(parent, "icons_resting", L_GUI_UF_ICONS_RESTING)
	icons_resting:SetPoint("TOPLEFT", icons_combat, "BOTTOMLEFT", 0, 0)

	-- Portraits
	local subheader = ns.addSubCategory(parent, L_GUI_UF_SUBHEADER_PORTRAIT)
	subheader:SetPoint("TOPLEFT", icons_resting, "BOTTOMLEFT", 0, -16)

	local portrait_enable = ns.CreateCheckBox(parent, "portrait_enable", L_GUI_UF_PORTRAIT_ENABLE)
	portrait_enable:SetPoint("TOPLEFT", subheader, "BOTTOMLEFT", 0, -8)

	local portrait_classcolor_border = ns.CreateCheckBox(parent, "portrait_classcolor_border", L_GUI_UF_PORTRAIT_CLASSCOLOR_BORDER)
	portrait_classcolor_border:SetPoint("TOPLEFT", portrait_enable, "BOTTOMLEFT", 0, 0)

	local portrait_type = ns.CreateDropDown(parent, "portrait_type", true, nil, PortraitTable)
	portrait_type:SetPoint("TOPLEFT", portrait_classcolor_border, "BOTTOMLEFT", -16, -10)

	local portrait_height = ns.CreateNumberSlider(parent, "portrait_height", nil, nil, 0, 190, 1, true, L_GUI_UF_PORTRAIT_HEIGHT)
	portrait_height:SetPoint("TOPLEFT", portrait_type, "BOTTOMLEFT", 16, -16)

	local portrait_width = ns.CreateNumberSlider(parent, "portrait_width", nil, nil, 0, 130, 1, true, L_GUI_UF_PORTRAIT_WIDTH)
	portrait_width:SetPoint("LEFT", portrait_height, "RIGHT", 120, 0)

	-- Plugins
	local subheader = ns.addSubCategory(parent, L_GUI_UF_SUBHEADER_PLUGINS)
	subheader:SetPoint("TOPLEFT", portrait_height, "BOTTOMLEFT", 0, -16)

	local plugins_gcd = ns.CreateCheckBox(parent, "plugins_gcd", L_GUI_UF_PLUGINS_GCD)
	plugins_gcd:SetPoint("TOPLEFT", subheader, "BOTTOMLEFT", 0, -8)

	local plugins_swing = ns.CreateCheckBox(parent, "plugins_swing", L_GUI_UF_PLUGINS_SWING)
	plugins_swing:SetPoint("TOPLEFT", plugins_gcd, "BOTTOMLEFT", 0, 0)

	local plugins_experience_bar = ns.CreateCheckBox(parent, "plugins_experience_bar")
	plugins_experience_bar:SetPoint("TOPLEFT", plugins_swing, "BOTTOMLEFT", 0, 0)

	local plugins_reputation_bar = ns.CreateCheckBox(parent, "plugins_reputation_bar")
	plugins_reputation_bar:SetPoint("TOPLEFT", plugins_experience_bar, "BOTTOMLEFT", 0, 0)

	local plugins_smooth_bar = ns.CreateCheckBox(parent, "plugins_smooth_bar", L_GUI_UF_PLUGINS_SMOOTH_BAR)
	plugins_smooth_bar:SetPoint("TOPLEFT", plugins_reputation_bar, "BOTTOMLEFT", 0, 0)

	local plugins_enemy_spec = ns.CreateCheckBox(parent, "plugins_enemy_spec", L_GUI_UF_PLUGINS_ENEMY_SPEC)
	plugins_enemy_spec:SetPoint("TOPLEFT", plugins_smooth_bar, "BOTTOMLEFT", 0, 0)

	local plugins_combat_feedback = ns.CreateCheckBox(parent, "plugins_combat_feedback", L_GUI_UF_PLUGINS_COMBAT_FEEDBACK)
	plugins_combat_feedback:SetPoint("TOPLEFT", plugins_enemy_spec, "BOTTOMLEFT", 0, 0)

	local plugins_fader = ns.CreateCheckBox(parent, "plugins_fader", L_GUI_UF_PLUGINS_FADER)
	plugins_fader:SetPoint("TOPLEFT", plugins_combat_feedback, "BOTTOMLEFT", 0, 0)

	local plugins_diminishing = ns.CreateCheckBox(parent, "plugins_diminishing", L_GUI_UF_PLUGINS_DIMINISHING)
	plugins_diminishing:SetPoint("TOPLEFT", plugins_fader, "BOTTOMLEFT", 0, 0)

	local plugins_power_prediction = ns.CreateCheckBox(parent, "plugins_power_prediction", L_GUI_UF_PLUGINS_POWER_PREDICTION)
	plugins_power_prediction:SetPoint("TOPLEFT", plugins_diminishing, "BOTTOMLEFT", 0, 0)

	local plugins_absorbs = ns.CreateCheckBox(parent, "plugins_absorbs")
	plugins_absorbs:SetPoint("TOPLEFT", plugins_power_prediction, "BOTTOMLEFT", 0, 0)

	-- Panel 3
	local parent = ShestakUIOptionsPanel.unitframe3

	local subheader = ns.addSubCategory(parent, L.unitframe_subheader_player_width)
	subheader:SetPoint("TOPLEFT", parent.subText, "BOTTOMLEFT", 0, 0)

	local player_width = ns.CreateNumberSlider(parent, "player_width", nil, nil, 105, 400, 1, true)
	player_width:SetPoint("TOPLEFT", subheader, "BOTTOMLEFT", 0, -28)

	local subheader = ns.addSubCategory(parent, L.unitframe_subheader_boss_width)
	subheader:SetPoint("TOPLEFT", player_width, "BOTTOMLEFT", 0, -10)

	local boss_width = ns.CreateNumberSlider(parent, "boss_width", nil, nil, 105, 300, 1, true, L.unitframe_player_width)
	boss_width:SetPoint("TOPLEFT", subheader, "BOTTOMLEFT", 0, -28)

	local extra_height_auto = ns.CreateCheckBox(parent, "extra_height_auto")
	extra_height_auto:SetPoint("TOPLEFT", boss_width, "BOTTOMLEFT", 0, -10)

	local extra_health_height = ns.CreateNumberSlider(parent, "extra_health_height", nil, nil, 0, 40, 1, true)
	extra_health_height:SetPoint("TOPLEFT", extra_height_auto, "BOTTOMLEFT", 0, -20)

	local extra_power_height = ns.CreateNumberSlider(parent, "extra_power_height", nil, nil, 0, 20, 1, true)
	extra_power_height:SetPoint("LEFT", extra_health_height, "RIGHT", 120, 0)

	local subheader = ns.addSubCategory(parent, L.unitframe_subheader_castbar)
	subheader:SetPoint("TOPLEFT", extra_health_height, "BOTTOMLEFT", 0, -10)

	local castbar_width = ns.CreateNumberSlider(parent, "castbar_width", nil, nil, 190, 450, 1, true, L.unitframe_player_width)
	castbar_width:SetPoint("TOPLEFT", subheader, "BOTTOMLEFT", 0, -28)

	local castbar_height = ns.CreateNumberSlider(parent, "castbar_height", nil, nil, 16, 40, 1, true)
	castbar_height:SetPoint("LEFT", castbar_width, "RIGHT", 120, 0)

	local function toggleOptions()
		local shown = not extra_height_auto:GetChecked()
		extra_health_height:SetShown(shown)
		extra_power_height:SetShown(shown)
	end

	extra_height_auto:HookScript("OnClick", toggleOptions)
	extra_health_height:HookScript("OnShow", toggleOptions)
end

-- Unit Frames Class bar
do
	local parent = ShestakUIOptionsPanel.unitframe_class_bar

	local combo = ns.CreateCheckBox(parent, "combo", L_GUI_UF_PLUGINS_COMBO_BAR)
	combo:SetPoint("TOPLEFT", parent.subText, "BOTTOMLEFT", 0, 0)

	local combo_always = ns.CreateCheckBox(parent, "combo_always", L_GUI_UF_PLUGINS_COMBO_BAR_ALWAYS)
	combo_always:SetPoint("TOPLEFT", combo, "BOTTOMLEFT", 20, 0)

	local combo_old = ns.CreateCheckBox(parent, "combo_old", L_GUI_UF_PLUGINS_COMBO_BAR_OLD)
	combo_old:SetPoint("TOPLEFT", combo_always, "BOTTOMLEFT", 0, 0)

	combo.children = {combo_always, combo_old}

	local arcane = ns.CreateCheckBox(parent, "arcane", L_GUI_UF_PLUGINS_ARCANE_BAR)
	arcane:SetPoint("TOPLEFT", combo_old, "BOTTOMLEFT", -20, 0)

	local chi = ns.CreateCheckBox(parent, "chi", L_GUI_UF_PLUGINS_CHI_BAR)
	chi:SetPoint("TOPLEFT", arcane, "BOTTOMLEFT", 0, 0)

	local essence = ns.CreateCheckBox(parent, "essence")
	essence:SetPoint("TOPLEFT", chi, "BOTTOMLEFT", 0, 0)

	local stagger = ns.CreateCheckBox(parent, "stagger", L_GUI_UF_PLUGINS_STAGGER_BAR)
	stagger:SetPoint("TOPLEFT", essence, "BOTTOMLEFT", 0, 0)

	local holy = ns.CreateCheckBox(parent, "holy", L_GUI_UF_PLUGINS_HOLY_BAR)
	holy:SetPoint("TOPLEFT", stagger, "BOTTOMLEFT", 0, 0)

	local shard = ns.CreateCheckBox(parent, "shard", L_GUI_UF_PLUGINS_SHARD_BAR)
	shard:SetPoint("TOPLEFT", holy, "BOTTOMLEFT", 0, 0)

	local rune = ns.CreateCheckBox(parent, "rune", L_GUI_UF_PLUGINS_RUNE_BAR)
	rune:SetPoint("TOPLEFT", shard, "BOTTOMLEFT", 0, 0)

	local totem = ns.CreateCheckBox(parent, "totem", L_GUI_UF_PLUGINS_TOTEM_BAR)
	totem:SetPoint("TOPLEFT", rune, "BOTTOMLEFT", 0, 0)

	local totem_other = ns.CreateCheckBox(parent, "totem_other")
	totem_other:SetPoint("TOPLEFT", totem, "BOTTOMLEFT", 20, 0)

	totem.children = {totem_other}
end

-- Raid Frames
do
	local parent = ShestakUIOptionsPanel.raidframe

	local layout = ns.CreateDropDown(parent, "layout", true, nil, RaidTable)
	layout:SetPoint("TOPLEFT", parent.subText, "BOTTOMLEFT", -16, 0)

	local show_party = ns.CreateCheckBox(parent, "show_party", L_GUI_UF_SHOW_PARTY)
	show_party:SetPoint("TOPLEFT", layout, "BOTTOMLEFT", 16, 0)

	local show_raid = ns.CreateCheckBox(parent, "show_raid", L_GUI_UF_SHOW_RAID)
	show_raid:SetPoint("LEFT", show_party, "RIGHT", 248, 0)

	local show_target = ns.CreateCheckBox(parent, "show_target")
	show_target:SetPoint("TOPLEFT", show_party, "BOTTOMLEFT", 0, 0)

	local show_pet = ns.CreateCheckBox(parent, "show_pet")
	show_pet:SetPoint("LEFT", show_target, "RIGHT", 248, 0)

	local raid_tanks = ns.CreateCheckBox(parent, "raid_tanks", L_GUI_UF_SHOW_TANK)
	raid_tanks:SetPoint("TOPLEFT", show_target, "BOTTOMLEFT", 0, 0)

	local raid_tanks_tt = ns.CreateCheckBox(parent, "raid_tanks_tt", L_GUI_UF_SHOW_TANK_TT)
	raid_tanks_tt:SetPoint("LEFT", raid_tanks, "RIGHT", 248, 0)
	raid_tanks_tt.Text:SetWidth(270)

	local solo_mode = ns.CreateCheckBox(parent, "solo_mode", L_GUI_UF_SOLO_MODE)
	solo_mode:SetPoint("TOPLEFT", raid_tanks, "BOTTOMLEFT", 0, 0)

	local player_in_party = ns.CreateCheckBox(parent, "player_in_party", L_GUI_UF_PLAYER_PARTY)
	player_in_party:SetPoint("LEFT", solo_mode, "RIGHT", 248, 0)

	local raid_groups = ns.CreateNumberSlider(parent, "raid_groups", nil, nil, 1, 8, 1, true, L_GUI_UF_RAID_GROUP)
	raid_groups:SetPoint("TOPLEFT", solo_mode, "BOTTOMLEFT", 0, -20)

	local auto_position = ns.CreateDropDown(parent, "auto_position", true, L.raidframe_auto_position, {"DYNAMIC", "STATIC", "NONE"})
	auto_position:SetPoint("TOPLEFT", raid_groups, "BOTTOMLEFT", -16, -10)

	local party_vertical = ns.CreateCheckBox(parent, "party_vertical", nil, L.raidframe_raid_groups_vertical_desc)
	party_vertical:SetPoint("TOPLEFT", auto_position, "BOTTOMLEFT", 16, 0)

	local raid_groups_vertical = ns.CreateCheckBox(parent, "raid_groups_vertical")
	raid_groups_vertical:SetPoint("TOPLEFT", party_vertical, "BOTTOMLEFT", 0, 0)

	local vertical_health = ns.CreateCheckBox(parent, "vertical_health")
	vertical_health:SetPoint("TOPLEFT", raid_groups_vertical, "BOTTOMLEFT", 0, 0)

	local by_role = ns.CreateCheckBox(parent, "by_role", L_GUI_UF_BY_ROLE)
	by_role:SetPoint("TOPLEFT", vertical_health, "BOTTOMLEFT", 0, 0)

	local aggro_border = ns.CreateCheckBox(parent, "aggro_border", L_GUI_UF_AGGRO_BORDER)
	aggro_border:SetPoint("TOPLEFT", by_role, "BOTTOMLEFT", 0, 0)

	local deficit_health = ns.CreateCheckBox(parent, "deficit_health", L_GUI_UF_DEFICIT_HEALTH)
	deficit_health:SetPoint("TOPLEFT", aggro_border, "BOTTOMLEFT", 0, 0)

	local hide_health_value = ns.CreateCheckBox(parent, "hide_health_value")
	hide_health_value:SetPoint("TOPLEFT", deficit_health, "BOTTOMLEFT", 0, 0)

	local alpha_health = ns.CreateCheckBox(parent, "alpha_health", L_GUI_UF_ALPHA_HEALTH)
	alpha_health:SetPoint("TOPLEFT", hide_health_value, "BOTTOMLEFT", 0, 0)

	local show_range = ns.CreateCheckBox(parent, "show_range", L_GUI_UF_SHOW_RANGE)
	show_range:SetPoint("TOPLEFT", alpha_health, "BOTTOMLEFT", 0, 0)

	local range_alpha = ns.CreateNumberSlider(parent, "range_alpha", nil, nil, 0, 1, 0.05, true, L_GUI_UF_RANGE_ALPHA, L_GUI_UF_RANGE_ALPHA_DESC)
	range_alpha:SetPoint("TOPLEFT", show_range, "BOTTOMLEFT", 0, -20)

	-- Icons
	local subheader = ns.addSubCategory(parent, L_GUI_UF_SUBHEADER_ICONS)
	subheader:SetPoint("TOPLEFT", range_alpha, "BOTTOMLEFT", 0, -10)

	local icons_role = ns.CreateCheckBox(parent, "icons_role", L_GUI_UF_ICONS_ROLE)
	icons_role:SetPoint("TOPLEFT", subheader, "BOTTOMLEFT", 0, -8)

	local icons_raid_mark = ns.CreateCheckBox(parent, "icons_raid_mark", L_GUI_UF_ICONS_RAID_MARK)
	icons_raid_mark:SetPoint("LEFT", icons_role, "RIGHT", 248, 0)

	local icons_ready_check = ns.CreateCheckBox(parent, "icons_ready_check", L_GUI_UF_ICONS_READY_CHECK)
	icons_ready_check:SetPoint("TOPLEFT", icons_role, "BOTTOMLEFT", 0, 0)

	local icons_leader = ns.CreateCheckBox(parent, "icons_leader", L_GUI_UF_ICONS_LEADER)
	icons_leader:SetPoint("LEFT", icons_ready_check, "RIGHT", 248, 0)

	local icons_sumon = ns.CreateCheckBox(parent, "icons_sumon", L_GUI_UF_ICONS_SUMON)
	icons_sumon:SetPoint("TOPLEFT", icons_ready_check, "BOTTOMLEFT", 0, 0)

	local icons_phase = ns.CreateCheckBox(parent, "icons_phase")
	icons_phase:SetPoint("LEFT", icons_sumon, "RIGHT", 248, 0)

	-- Panel 2
	local parent = ShestakUIOptionsPanel.raidframe2

	local plugins_aura_watch = ns.CreateCheckBox(parent, "plugins_aura_watch")
	plugins_aura_watch:SetPoint("TOPLEFT", parent.subText, "BOTTOMLEFT", 0, 0)

	local ListButton = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
	ListButton:SetPoint("LEFT", plugins_aura_watch, "RIGHT", 400, 0)
	ListButton:SetSize(100, 23)
	ListButton:SetText(ADD)
	ListButton:SetWidth(ListButton.Text:GetWidth() + 15)
	ListButton:SetScript("OnClick", function()
		if not C.options["raidframe"] then
			C.options["raidframe"] = {}
		end
		if not C.options["raidframe"]["plugins_aura_watch_list"] then
			C.options["raidframe"]["plugins_aura_watch_list"] = {}
		end
		BuildSpellList(C.options["raidframe"]["plugins_aura_watch_list"])
	end)
	tinsert(ns.buttons, ListButton)

	local function toggleListButton()
		local shown = plugins_aura_watch:GetChecked()
		ListButton:SetEnabled(shown)
	end

	plugins_aura_watch:HookScript("OnClick", toggleListButton)
	ListButton:HookScript("OnShow", toggleListButton)

	local plugins_aura_watch_timer = ns.CreateCheckBox(parent, "plugins_aura_watch_timer")
	plugins_aura_watch_timer:SetPoint("TOPLEFT", plugins_aura_watch, "BOTTOMLEFT", 20, 0)

	local plugins_debuffhighlight_icon = ns.CreateCheckBox(parent, "plugins_debuffhighlight_icon")
	plugins_debuffhighlight_icon:SetPoint("TOPLEFT", plugins_aura_watch_timer, "BOTTOMLEFT", 0, 0)

	local plugins_pvp_debuffs = ns.CreateCheckBox(parent, "plugins_pvp_debuffs")
	plugins_pvp_debuffs:SetPoint("TOPLEFT", plugins_debuffhighlight_icon, "BOTTOMLEFT", 0, 0)

	plugins_aura_watch.children = {plugins_aura_watch_timer, plugins_debuffhighlight_icon, plugins_pvp_debuffs}

	local plugins_healcomm = ns.CreateCheckBox(parent, "plugins_healcomm", L_GUI_UF_PLUGINS_HEALCOMM)
	plugins_healcomm:SetPoint("TOPLEFT", plugins_pvp_debuffs, "BOTTOMLEFT", -20, 0)

	local plugins_over_absorb = ns.CreateCheckBox(parent, "plugins_over_absorb")
	plugins_over_absorb:SetPoint("TOPLEFT", plugins_healcomm, "BOTTOMLEFT", 20, 0)

	local plugins_over_heal_absorb = ns.CreateCheckBox(parent, "plugins_over_heal_absorb")
	plugins_over_heal_absorb:SetPoint("TOPLEFT", plugins_over_absorb, "BOTTOMLEFT", 0, 0)

	local plugins_auto_resurrection = ns.CreateCheckBox(parent, "plugins_auto_resurrection")
	plugins_auto_resurrection:SetPoint("TOPLEFT", plugins_over_heal_absorb, "BOTTOMLEFT", -20, 0)

	-- Heal layout size
	local subheader = ns.addSubCategory(parent, L.raidframe_subheader_heal_size)
	subheader:SetPoint("TOPLEFT", plugins_auto_resurrection, "BOTTOMLEFT", 0, -10)

	local heal_party_width = ns.CreateNumberSlider(parent, "heal_party_width", nil, nil, 50, 200, 1, true, L.raidframe_dps_party_width)
	heal_party_width:SetPoint("TOPLEFT", subheader, "BOTTOMLEFT", 0, -30)

	local heal_party_height = ns.CreateNumberSlider(parent, "heal_party_height", nil, nil, 20, 200, 1, true, L.raidframe_dps_party_height)
	heal_party_height:SetPoint("LEFT", heal_party_width, "RIGHT", 120, 0)

	local heal_raid_width = ns.CreateNumberSlider(parent, "heal_raid_width", nil, nil, 50, 200, 1, true, L.raidframe_dps_raid_width)
	heal_raid_width:SetPoint("TOPLEFT", heal_party_width, "BOTTOMLEFT", 0, -20)

	local heal_raid_height = ns.CreateNumberSlider(parent, "heal_raid_height", nil, nil, 20, 200, 1, true, L.raidframe_dps_raid_height)
	heal_raid_height:SetPoint("LEFT", heal_raid_width, "RIGHT", 120, 0)

	local heal_party_power_height = ns.CreateNumberSlider(parent, "heal_party_power_height", nil, nil, 0, 10, 1, true, L.raidframe_dps_party_power_height)
	heal_party_power_height:SetPoint("TOPLEFT", heal_raid_width, "BOTTOMLEFT", 0, -20)

	local heal_raid_power_height = ns.CreateNumberSlider(parent, "heal_raid_power_height", nil, nil, 0, 10, 1, true, L.raidframe_dps_raid_power_height)
	heal_raid_power_height:SetPoint("LEFT", heal_party_power_height, "RIGHT", 120, 0)

	-- DPS layout size
	local subheader = ns.addSubCategory(parent, L.raidframe_subheader_dps_size)
	subheader:SetPoint("TOPLEFT", heal_party_power_height, "BOTTOMLEFT", 0, -10)

	local dps_party_width = ns.CreateNumberSlider(parent, "dps_party_width", nil, nil, 80, 300, 1, true)
	dps_party_width:SetPoint("TOPLEFT", subheader, "BOTTOMLEFT", 0, -30)

	local dps_party_height = ns.CreateNumberSlider(parent, "dps_party_height", nil, nil, 15, 60, 1, true)
	dps_party_height:SetPoint("LEFT", dps_party_width, "RIGHT", 120, 0)

	local dps_raid_width = ns.CreateNumberSlider(parent, "dps_raid_width", nil, nil, 80, 200, 1, true)
	dps_raid_width:SetPoint("TOPLEFT", dps_party_width, "BOTTOMLEFT", 0, -20)

	local dps_raid_height = ns.CreateNumberSlider(parent, "dps_raid_height", nil, nil, 15, 40, 1, true)
	dps_raid_height:SetPoint("LEFT", dps_raid_width, "RIGHT", 120, 0)

	local dps_party_power_height = ns.CreateNumberSlider(parent, "dps_party_power_height", nil, nil, 0, 10, 1, true)
	dps_party_power_height:SetPoint("TOPLEFT", dps_raid_width, "BOTTOMLEFT", 0, -20)

	local dps_raid_power_height = ns.CreateNumberSlider(parent, "dps_raid_power_height", nil, nil, 0, 10, 1, true)
	dps_raid_power_height:SetPoint("LEFT", dps_party_power_height, "RIGHT", 120, 0)
end

-- Auras/Buffs/Debuffs
do
	local parent = ShestakUIOptionsPanel.aura

	local show_spiral = ns.CreateCheckBox(parent, "show_spiral", L_GUI_AURA_SHOW_SPIRAL)
	show_spiral:SetPoint("TOPLEFT", parent.subText, "BOTTOMLEFT", 0, 0)

	local show_timer = ns.CreateCheckBox(parent, "show_timer", L_GUI_AURA_SHOW_TIMER)
	show_timer:SetPoint("TOPLEFT", show_spiral, "BOTTOMLEFT", 0, 0)

	local cast_by = ns.CreateCheckBox(parent, "cast_by", L_GUI_AURA_CAST_BY)
	cast_by:SetPoint("TOPLEFT", show_timer, "BOTTOMLEFT", 0, 0)

	-- Buffs
	local subheader = ns.addSubCategory(parent, L.aura_subheader_buffs)
	subheader:SetPoint("TOPLEFT", cast_by, "BOTTOMLEFT", 0, -10)

	local player_auras = ns.CreateCheckBox(parent, "player_auras", L_GUI_AURA_PLAYER_AURAS)
	player_auras:SetPoint("TOPLEFT", subheader, "BOTTOMLEFT", 0, -10)

	local player_buff_mouseover = ns.CreateCheckBox(parent, "player_buff_mouseover")
	player_buff_mouseover:SetPoint("LEFT", player_auras, "RIGHT", 320, 0)

	local classcolor_border = ns.CreateCheckBox(parent, "classcolor_border", L_GUI_AURA_CLASSCOLOR_BORDER)
	classcolor_border:SetPoint("TOPLEFT", player_auras, "BOTTOMLEFT", 0, 0)

	local player_buff_size = ns.CreateNumberSlider(parent, "player_buff_size", nil, nil, 0, 50, 1, true, L_GUI_AURA_PLAYER_BUFF_SIZE, L_GUI_AURA_PLAYER_BUFF_SIZE_DESC)
	player_buff_size:SetPoint("TOPLEFT", classcolor_border, "BOTTOMLEFT", 0, -20)

	-- Debuffs
	local subheader = ns.addSubCategory(parent, L.aura_subheader_debuffs)
	subheader:SetPoint("TOPLEFT", player_buff_size, "BOTTOMLEFT", 0, -10)

	local target_auras = ns.CreateCheckBox(parent, "target_auras", L_GUI_AURA_TARGET_AURAS)
	target_auras:SetPoint("TOPLEFT", subheader, "BOTTOMLEFT", 0, -10)

	local tot_debuffs = ns.CreateCheckBox(parent, "tot_debuffs", L_GUI_AURA_TOT_DEBUFFS)
	tot_debuffs:SetPoint("LEFT", target_auras, "RIGHT", 320, 0)
	tot_debuffs.Text:SetWidth(200)

	local focus_debuffs = ns.CreateCheckBox(parent, "focus_debuffs", L_GUI_AURA_FOCUS_DEBUFFS)
	focus_debuffs:SetPoint("TOPLEFT", target_auras, "BOTTOMLEFT", 0, 0)

	local fot_debuffs = ns.CreateCheckBox(parent, "fot_debuffs", L_GUI_AURA_FOT_DEBUFFS)
	fot_debuffs:SetPoint("LEFT", focus_debuffs, "RIGHT", 320, 0)
	fot_debuffs.Text:SetWidth(200)

	local pet_debuffs = ns.CreateCheckBox(parent, "pet_debuffs", L_GUI_AURA_PET_DEBUFFS)
	pet_debuffs:SetPoint("TOPLEFT", focus_debuffs, "BOTTOMLEFT", 0, 0)

	local player_aura_only = ns.CreateCheckBox(parent, "player_aura_only", L_GUI_AURA_PLAYER_AURA_ONLY)
	player_aura_only:SetPoint("TOPLEFT", pet_debuffs, "BOTTOMLEFT", 0, 0)

	local debuff_color_type = ns.CreateCheckBox(parent, "debuff_color_type", L_GUI_AURA_DEBUFF_COLOR_TYPE)
	debuff_color_type:SetPoint("TOPLEFT", player_aura_only, "BOTTOMLEFT", 0, 0)

	local debuff_size = ns.CreateNumberSlider(parent, "debuff_size", nil, nil, 0, 50, 1, true)
	debuff_size:SetPoint("TOPLEFT", debuff_color_type, "BOTTOMLEFT", 0, -20)

	-- Boss auras
	local subheader = ns.addSubCategory(parent, L.aura_subheader_boss)
	subheader:SetPoint("TOPLEFT", debuff_size, "BOTTOMLEFT", 0, -10)

	local boss_auras = ns.CreateCheckBox(parent, "boss_auras", ENABLE)
	boss_auras:SetPoint("TOPLEFT", subheader, "BOTTOMLEFT", 0, -10)

	local boss_debuffs = ns.CreateNumberSlider(parent, "boss_debuffs", nil, nil, 0, 5, 1, true, L_GUI_UF_BOSS_DEBUFFS, L_GUI_UF_BOSS_DEBUFFS_DESC)
	boss_debuffs:SetPoint("TOPLEFT", boss_auras, "BOTTOMLEFT", 0, -20)

	local boss_buffs = ns.CreateNumberSlider(parent, "boss_buffs", nil, nil, 0, 3, 1, true, L_GUI_UF_BOSS_BUFFS, L_GUI_UF_BOSS_BUFFS_DESC)
	boss_buffs:SetPoint("LEFT", boss_debuffs, "RIGHT", 120, 0)
end

-- ActionBar
do
	local parent = ShestakUIOptionsPanel.actionbar

	local enable = ns.CreateCheckBox(parent, "enable", L_GUI_ACTIONBAR_ENABLE)
	enable:SetPoint("TOPLEFT", parent.subText, "BOTTOMLEFT", 0, 0)

	local hotkey = ns.CreateCheckBox(parent, "hotkey", L_GUI_ACTIONBAR_HOTKEY)
	hotkey:SetPoint("TOPLEFT", enable, "BOTTOMLEFT", 0, 0)

	local macro = ns.CreateCheckBox(parent, "macro", L_GUI_ACTIONBAR_MACRO)
	macro:SetPoint("TOPLEFT", hotkey, "BOTTOMLEFT", 0, 0)

	local show_grid = ns.CreateCheckBox(parent, "show_grid", L_GUI_ACTIONBAR_GRID)
	show_grid:SetPoint("TOPLEFT", macro, "BOTTOMLEFT", 0, 0)

	local button_size = ns.CreateNumberSlider(parent, "button_size", nil, nil, 0, 50, 1, true, L_GUI_ACTIONBAR_BUTTON_SIZE)
	button_size:SetPoint("TOPLEFT", show_grid, "BOTTOMLEFT", 0, -20)

	local button_space = ns.CreateNumberSlider(parent, "button_space", nil, nil, 0, 10, 1, true, L_GUI_ACTIONBAR_BUTTON_SPACE)
	button_space:SetPoint("LEFT", button_size, "RIGHT", 120, 0)

	local split_bars = ns.CreateCheckBox(parent, "split_bars", L_GUI_ACTIONBAR_SPLIT_BARS)
	split_bars:SetPoint("TOPLEFT", button_size, "BOTTOMLEFT", 0, -10)

	local classcolor_border = ns.CreateCheckBox(parent, "classcolor_border", L_GUI_ACTIONBAR_CLASSCOLOR_BORDER)
	classcolor_border:SetPoint("TOPLEFT", split_bars, "BOTTOMLEFT", 0, 0)

	local hide_highlight = ns.CreateCheckBox(parent, "hide_highlight", L_GUI_ACTIONBAR_HIDE_HIGHLIGHT)
	hide_highlight:SetPoint("TOPLEFT", classcolor_border, "BOTTOMLEFT", 0, 0)

	local toggle_mode = ns.CreateCheckBox(parent, "toggle_mode")
	toggle_mode:SetPoint("TOPLEFT", hide_highlight, "BOTTOMLEFT", 0, 0)

	local bottombars = ns.CreateNumberSlider(parent, "bottombars", nil, nil, 1, 3, 1, true, L_GUI_ACTIONBAR_BOTTOMBARS)
	bottombars:SetPoint("TOPLEFT", toggle_mode, "BOTTOMLEFT", 0, -20)

	local rightbars = ns.CreateNumberSlider(parent, "rightbars", nil, nil, 0, 3, 1, true, L_GUI_ACTIONBAR_RIGHTBARS)
	rightbars:SetPoint("LEFT", bottombars, "RIGHT", 120, 0)

	local bottombars_mouseover = ns.CreateCheckBox(parent, "bottombars_mouseover")
	bottombars_mouseover:SetPoint("TOPLEFT", bottombars, "BOTTOMLEFT", 0, -10)

	local rightbars_mouseover = ns.CreateCheckBox(parent, "rightbars_mouseover", L_GUI_ACTIONBAR_RIGHTBARS_MOUSEOVER)
	rightbars_mouseover:SetPoint("TOPLEFT", bottombars_mouseover, "BOTTOMLEFT", 0, 0)

	local petbar_hide = ns.CreateCheckBox(parent, "petbar_hide", L_GUI_ACTIONBAR_PETBAR_HIDE)
	petbar_hide:SetPoint("TOPLEFT", rightbars_mouseover, "BOTTOMLEFT", 0, 0)

	local petbar_horizontal = ns.CreateCheckBox(parent, "petbar_horizontal", L_GUI_ACTIONBAR_PETBAR_HORIZONTAL)
	petbar_horizontal:SetPoint("TOPLEFT", petbar_hide, "BOTTOMLEFT", 0, 0)

	local petbar_mouseover = ns.CreateCheckBox(parent, "petbar_mouseover", L_GUI_ACTIONBAR_PETBAR_MOUSEOVER)
	petbar_mouseover:SetPoint("TOPLEFT", petbar_horizontal, "BOTTOMLEFT", 20, 0)

	-- petbar_horizontal.children = {petbar_mouseover}

	local stancebar_hide = ns.CreateCheckBox(parent, "stancebar_hide", L_GUI_ACTIONBAR_STANCEBAR_HIDE)
	stancebar_hide:SetPoint("TOPLEFT", petbar_mouseover, "BOTTOMLEFT", -20, 0)

	local stancebar_horizontal = ns.CreateCheckBox(parent, "stancebar_horizontal", L_GUI_ACTIONBAR_STANCEBAR_HORIZONTAL)
	stancebar_horizontal:SetPoint("TOPLEFT", stancebar_hide, "BOTTOMLEFT", 0, 0)

	local stancebar_mouseover = ns.CreateCheckBox(parent, "stancebar_mouseover", L_GUI_ACTIONBAR_STANCEBAR_MOUSEOVER)
	stancebar_mouseover:SetPoint("TOPLEFT", stancebar_horizontal, "BOTTOMLEFT", 20, 0)

	local stancebar_mouseover_alpha = ns.CreateNumberSlider(parent, "stancebar_mouseover_alpha", nil, nil, 0, 0.7, 0.1, true, L.nameplate_alpha)
	stancebar_mouseover_alpha:SetPoint("LEFT", stancebar_mouseover, "RIGHT", 224, 0)

	-- stancebar_horizontal.children = {stancebar_mouseover}

	local micromenu = ns.CreateCheckBox(parent, "micromenu", L_GUI_ACTIONBAR_MICROMENU)
	micromenu:SetPoint("TOPLEFT", stancebar_mouseover, "BOTTOMLEFT", -20, 0)

	local micromenu_mouseover = ns.CreateCheckBox(parent, "micromenu_mouseover", L_GUI_ACTIONBAR_MICROMENU_MOUSEOVER)
	micromenu_mouseover:SetPoint("TOPLEFT", micromenu, "BOTTOMLEFT", 20, 0)

	micromenu.children = {micromenu_mouseover}

	-- Panel 2
	local parent = ShestakUIOptionsPanel.actionbar2

	local editor = ns.CreateCheckBox(parent, "editor")
	editor:SetPoint("TOPLEFT", parent.subText, "BOTTOMLEFT", 0, 0)

	-- Bar 1
	local subheader = ns.addSubCategory(editor, BINDING_HEADER_ACTIONBAR.." 1")
	subheader:SetPoint("TOPLEFT", editor, "BOTTOMLEFT", 0, -10)

	local bar1_num = ns.CreateNumberSlider(parent, "bar1_num", nil, nil, 0, 12, 1, true)
	bar1_num:SetPoint("TOPLEFT", subheader, "BOTTOMLEFT", 0, -30)

	local bar1_row = ns.CreateNumberSlider(parent, "bar1_row", nil, nil, 1, 12, 1, true)
	bar1_row:SetPoint("LEFT", bar1_num, "RIGHT", 120, 0)

	local bar1_size = ns.CreateNumberSlider(parent, "bar1_size", nil, nil, 0, 50, 1, true, L_GUI_ACTIONBAR_BUTTON_SIZE)
	bar1_size:SetPoint("TOPLEFT", bar1_num, "BOTTOMLEFT", 0, -20)

	local bar1_mouseover = ns.CreateCheckBox(parent, "bar1_mouseover")
	bar1_mouseover:SetPoint("LEFT", bar1_size, "RIGHT", 130, 0)

	-- Bar 2
	local subheader = ns.addSubCategory(editor, BINDING_HEADER_ACTIONBAR.." 2")
	subheader:SetPoint("TOPLEFT", bar1_size, "BOTTOMLEFT", 0, -10)

	local bar2_num = ns.CreateNumberSlider(parent, "bar2_num", nil, nil, 0, 12, 1, true, L.actionbar_bar1_num)
	bar2_num:SetPoint("TOPLEFT", subheader, "BOTTOMLEFT", 0, -30)

	local bar2_row = ns.CreateNumberSlider(parent, "bar2_row", nil, nil, 1, 12, 1, true, L.actionbar_bar1_row)
	bar2_row:SetPoint("LEFT", bar2_num, "RIGHT", 120, 0)

	local bar2_size = ns.CreateNumberSlider(parent, "bar2_size", nil, nil, 0, 50, 1, true, L_GUI_ACTIONBAR_BUTTON_SIZE)
	bar2_size:SetPoint("TOPLEFT", bar2_num, "BOTTOMLEFT", 0, -20)

	local bar2_mouseover = ns.CreateCheckBox(parent, "bar2_mouseover", L.actionbar_bar1_mouseover)
	bar2_mouseover:SetPoint("LEFT", bar2_size, "RIGHT", 130, 0)

	-- Bar 3
	local subheader = ns.addSubCategory(editor, BINDING_HEADER_ACTIONBAR.." 3")
	subheader:SetPoint("TOPLEFT", bar2_size, "BOTTOMLEFT", 0, -10)

	local bar3_num = ns.CreateNumberSlider(parent, "bar3_num", nil, nil, 0, 12, 1, true, L.actionbar_bar1_num)
	bar3_num:SetPoint("TOPLEFT", subheader, "BOTTOMLEFT", 0, -30)

	local bar3_row = ns.CreateNumberSlider(parent, "bar3_row", nil, nil, 1, 12, 1, true, L.actionbar_bar1_row)
	bar3_row:SetPoint("LEFT", bar3_num, "RIGHT", 120, 0)

	local bar3_size = ns.CreateNumberSlider(parent, "bar3_size", nil, nil, 0, 50, 1, true, L_GUI_ACTIONBAR_BUTTON_SIZE)
	bar3_size:SetPoint("TOPLEFT", bar3_num, "BOTTOMLEFT", 0, -20)

	local bar3_mouseover = ns.CreateCheckBox(parent, "bar3_mouseover", L.actionbar_bar1_mouseover)
	bar3_mouseover:SetPoint("LEFT", bar3_size, "RIGHT", 130, 0)

	-- Bar 4
	local subheader = ns.addSubCategory(editor, BINDING_HEADER_ACTIONBAR.." 4")
	subheader:SetPoint("TOPLEFT", bar3_size, "BOTTOMLEFT", 0, -10)

	local bar4_num = ns.CreateNumberSlider(parent, "bar4_num", nil, nil, 0, 12, 1, true, L.actionbar_bar1_num)
	bar4_num:SetPoint("TOPLEFT", subheader, "BOTTOMLEFT", 0, -30)

	local bar4_row = ns.CreateNumberSlider(parent, "bar4_row", nil, nil, 1, 12, 1, true, L.actionbar_bar1_row)
	bar4_row:SetPoint("LEFT", bar4_num, "RIGHT", 120, 0)

	local bar4_size = ns.CreateNumberSlider(parent, "bar4_size", nil, nil, 0, 50, 1, true, L_GUI_ACTIONBAR_BUTTON_SIZE)
	bar4_size:SetPoint("TOPLEFT", bar4_num, "BOTTOMLEFT", 0, -20)

	local bar4_mouseover = ns.CreateCheckBox(parent, "bar4_mouseover", L.actionbar_bar1_mouseover)
	bar4_mouseover:SetPoint("LEFT", bar4_size, "RIGHT", 130, 0)

	-- Bar 5
	local subheader = ns.addSubCategory(editor, BINDING_HEADER_ACTIONBAR.." 5")
	subheader:SetPoint("TOPLEFT", bar4_size, "BOTTOMLEFT", 0, -10)

	local bar5_num = ns.CreateNumberSlider(parent, "bar5_num", nil, nil, 0, 12, 1, true, L.actionbar_bar1_num)
	bar5_num:SetPoint("TOPLEFT", subheader, "BOTTOMLEFT", 0, -30)

	local bar5_row = ns.CreateNumberSlider(parent, "bar5_row", nil, nil, 1, 12, 1, true, L.actionbar_bar1_row)
	bar5_row:SetPoint("LEFT", bar5_num, "RIGHT", 120, 0)

	local bar5_size = ns.CreateNumberSlider(parent, "bar5_size", nil, nil, 0, 50, 1, true, L_GUI_ACTIONBAR_BUTTON_SIZE)
	bar5_size:SetPoint("TOPLEFT", bar5_num, "BOTTOMLEFT", 0, -20)

	local bar5_mouseover = ns.CreateCheckBox(parent, "bar5_mouseover", L.actionbar_bar1_mouseover)
	bar5_mouseover:SetPoint("LEFT", bar5_size, "RIGHT", 130, 0)

	-- Panel 2
	local parent = ShestakUIOptionsPanel.actionbar3

	-- Bar 6
	local subheader = ns.addSubCategory(parent, BINDING_HEADER_ACTIONBAR.." 6")
	subheader:SetPoint("TOPLEFT", parent.subText, "BOTTOMLEFT", 0, -10)

	local bar6_num = ns.CreateNumberSlider(parent, "bar6_num", nil, nil, 0, 12, 1, true, L.actionbar_bar1_num)
	bar6_num:SetPoint("TOPLEFT", subheader, "BOTTOMLEFT", 0, -30)

	local bar6_row = ns.CreateNumberSlider(parent, "bar6_row", nil, nil, 1, 12, 1, true, L.actionbar_bar1_row)
	bar6_row:SetPoint("LEFT", bar6_num, "RIGHT", 120, 0)

	local bar6_size = ns.CreateNumberSlider(parent, "bar6_size", nil, nil, 0, 50, 1, true, L_GUI_ACTIONBAR_BUTTON_SIZE)
	bar6_size:SetPoint("TOPLEFT", bar6_num, "BOTTOMLEFT", 0, -20)

	local bar6_mouseover = ns.CreateCheckBox(parent, "bar6_mouseover", L.actionbar_bar1_mouseover)
	bar6_mouseover:SetPoint("LEFT", bar6_size, "RIGHT", 130, 0)

	-- Bar 7
	local subheader = ns.addSubCategory(parent, BINDING_HEADER_ACTIONBAR.." 7")
	subheader:SetPoint("TOPLEFT", bar6_size, "BOTTOMLEFT", 0, -10)

	local bar7_enable = ns.CreateCheckBox(parent, "bar7_enable", ENABLE)
	bar7_enable:SetPoint("TOPLEFT", subheader, "BOTTOMLEFT", 0, -10)

	local bar7_num = ns.CreateNumberSlider(parent, "bar7_num", nil, nil, 0, 12, 1, true, L.actionbar_bar1_num)
	bar7_num:SetPoint("TOPLEFT", bar7_enable, "BOTTOMLEFT", 0, -20)

	local bar7_row = ns.CreateNumberSlider(parent, "bar7_row", nil, nil, 1, 12, 1, true, L.actionbar_bar1_row)
	bar7_row:SetPoint("LEFT", bar7_num, "RIGHT", 120, 0)

	local bar7_size = ns.CreateNumberSlider(parent, "bar7_size", nil, nil, 0, 50, 1, true, L_GUI_ACTIONBAR_BUTTON_SIZE)
	bar7_size:SetPoint("TOPLEFT", bar7_num, "BOTTOMLEFT", 0, -20)

	local bar7_mouseover = ns.CreateCheckBox(parent, "bar7_mouseover", L.actionbar_bar1_mouseover)
	bar7_mouseover:SetPoint("LEFT", bar7_size, "RIGHT", 130, 0)

	-- Bar 8
	local subheader = ns.addSubCategory(parent, BINDING_HEADER_ACTIONBAR.." 8")
	subheader:SetPoint("TOPLEFT", bar7_size, "BOTTOMLEFT", 0, -10)

	local bar8_enable = ns.CreateCheckBox(parent, "bar8_enable", ENABLE)
	bar8_enable:SetPoint("TOPLEFT", subheader, "BOTTOMLEFT", 0, -10)

	local bar8_num = ns.CreateNumberSlider(parent, "bar8_num", nil, nil, 0, 12, 1, true, L.actionbar_bar1_num)
	bar8_num:SetPoint("TOPLEFT", bar8_enable, "BOTTOMLEFT", 0, -20)

	local bar8_row = ns.CreateNumberSlider(parent, "bar8_row", nil, nil, 1, 12, 1, true, L.actionbar_bar1_row)
	bar8_row:SetPoint("LEFT", bar8_num, "RIGHT", 120, 0)

	local bar8_size = ns.CreateNumberSlider(parent, "bar8_size", nil, nil, 0, 50, 1, true, L_GUI_ACTIONBAR_BUTTON_SIZE)
	bar8_size:SetPoint("TOPLEFT", bar8_num, "BOTTOMLEFT", 0, -20)

	local bar8_mouseover = ns.CreateCheckBox(parent, "bar8_mouseover", L.actionbar_bar1_mouseover)
	bar8_mouseover:SetPoint("LEFT", bar8_size, "RIGHT", 130, 0)
end

-- Tooltip
do
	local parent = ShestakUIOptionsPanel.tooltip

	local enable = ns.CreateCheckBox(parent, "enable")
	enable:SetPoint("TOPLEFT", parent.subText, "BOTTOMLEFT", 0, 0)

	local shift_modifer = ns.CreateCheckBox(parent, "shift_modifer")
	shift_modifer:SetPoint("TOPLEFT", enable, "BOTTOMLEFT", 0, 0)

	local cursor = ns.CreateCheckBox(parent, "cursor")
	cursor:SetPoint("TOPLEFT", shift_modifer, "BOTTOMLEFT", 0, 0)

	local item_icon = ns.CreateCheckBox(parent, "item_icon")
	item_icon:SetPoint("TOPLEFT", cursor, "BOTTOMLEFT", 0, 0)

	local health_value = ns.CreateCheckBox(parent, "health_value")
	health_value:SetPoint("TOPLEFT", item_icon, "BOTTOMLEFT", 0, 0)

	local hidebuttons = ns.CreateCheckBox(parent, "hidebuttons")
	hidebuttons:SetPoint("TOPLEFT", health_value, "BOTTOMLEFT", 0, 0)

	local hide_combat = ns.CreateCheckBox(parent, "hide_combat")
	hide_combat:SetPoint("TOPLEFT", hidebuttons, "BOTTOMLEFT", 0, 0)

	-- Plugins
	local subheader = ns.addSubCategory(parent, L_GUI_UF_SUBHEADER_PLUGINS)
	subheader:SetPoint("TOPLEFT", hide_combat, "BOTTOMLEFT", 0, -16)

	local title = ns.CreateCheckBox(parent, "title")
	title:SetPoint("TOPLEFT", subheader, "BOTTOMLEFT", 0, -8)

	local realm = ns.CreateCheckBox(parent, "realm")
	realm:SetPoint("LEFT", title, "RIGHT", 320, 0)
	realm.Text:SetWidth(200)

	local target = ns.CreateCheckBox(parent, "target")
	target:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, 0)
	target.Text:SetWidth(300)

	local rank = ns.CreateCheckBox(parent, "rank")
	rank:SetPoint("LEFT", target, "RIGHT", 320, 0)
	rank.Text:SetWidth(200)

	local average_lvl = ns.CreateCheckBox(parent, "average_lvl", STAT_AVERAGE_ITEM_LEVEL)
	average_lvl:SetPoint("TOPLEFT", target, "BOTTOMLEFT", 0, 0)

	local show_shift = ns.CreateCheckBox(parent, "show_shift")
	show_shift:SetPoint("TOPLEFT", average_lvl, "BOTTOMLEFT", 20, 0)

	local raid_icon = ns.CreateCheckBox(parent, "raid_icon")
	raid_icon:SetPoint("TOPLEFT", show_shift, "BOTTOMLEFT", -20, 0)

	local unit_role = ns.CreateCheckBox(parent, "unit_role")
	unit_role:SetPoint("LEFT", raid_icon, "RIGHT", 320, 0)
	unit_role.Text:SetWidth(200)

	local who_targetting = ns.CreateCheckBox(parent, "who_targetting")
	who_targetting:SetPoint("TOPLEFT", raid_icon, "BOTTOMLEFT", 0, 0)

	local spell_id = ns.CreateCheckBox(parent, "spell_id")
	spell_id:SetPoint("TOPLEFT", who_targetting, "BOTTOMLEFT", 0, 0)

	local item_count = ns.CreateCheckBox(parent, "item_count")
	item_count:SetPoint("TOPLEFT", spell_id, "BOTTOMLEFT", 0, 0)

	local achievements = ns.CreateCheckBox(parent, "achievements")
	achievements:SetPoint("TOPLEFT", item_count, "BOTTOMLEFT", 0, 0)

	local instance_lock = ns.CreateCheckBox(parent, "instance_lock")
	instance_lock:SetPoint("TOPLEFT", achievements, "BOTTOMLEFT", 0, 0)

	local mount = ns.CreateCheckBox(parent, "mount")
	mount:SetPoint("TOPLEFT", instance_lock, "BOTTOMLEFT", 0, 0)
end

-- Chat
do
	local parent = ShestakUIOptionsPanel.chat

	local enable = ns.CreateCheckBox(parent, "enable")
	enable:SetPoint("TOPLEFT", parent.subText, "BOTTOMLEFT", 0, 0)

	local width = ns.CreateNumberSlider(parent, "width", nil, nil, 0, 750, 1, true)
	width:SetPoint("TOPLEFT", enable, "BOTTOMLEFT", 0, -20)

	local height = ns.CreateNumberSlider(parent, "height", nil, nil, 0, 300, 1, true)
	height:SetPoint("LEFT", width, "RIGHT", 120, 0)

	local background = ns.CreateCheckBox(parent, "background")
	background:SetPoint("TOPLEFT", width, "BOTTOMLEFT", 0, -10)

	local background_alpha = ns.CreateNumberSlider(parent, "background_alpha", nil, nil, 0, 1, 0.05, true)
	background_alpha:SetPoint("TOPLEFT", background, "BOTTOMLEFT", 0, -20)

	local filter = ns.CreateCheckBox(parent, "filter")
	filter:SetPoint("TOPLEFT", background_alpha, "BOTTOMLEFT", 0, -10)

	local spam = ns.CreateCheckBox(parent, "spam")
	spam:SetPoint("TOPLEFT", filter, "BOTTOMLEFT", 0, 0)

	local spam_list = ns.CreateEditBox(parent, "spam_list", true)
	spam_list:SetPoint("TOPLEFT", spam, "BOTTOMLEFT", 6, -10)
	spam_list:SetWidth(200)
	spam_list:SetMaxLetters(40)

	local chat_bar = ns.CreateCheckBox(parent, "chat_bar")
	chat_bar:SetPoint("TOPLEFT", spam_list, "BOTTOMLEFT", -6, -10)

	local chat_bar_mouseover = ns.CreateCheckBox(parent, "chat_bar_mouseover")
	chat_bar_mouseover:SetPoint("TOPLEFT", chat_bar, "BOTTOMLEFT", 20, 0)

	chat_bar.children = {chat_bar_mouseover}

	local whisp_sound = ns.CreateCheckBox(parent, "whisp_sound")
	whisp_sound:SetPoint("TOPLEFT", chat_bar_mouseover, "BOTTOMLEFT", -20, 0)

	local combatlog = ns.CreateCheckBox(parent, "combatlog")
	combatlog:SetPoint("TOPLEFT", whisp_sound, "BOTTOMLEFT", 0, 0)

	local tabs_mouseover = ns.CreateCheckBox(parent, "tabs_mouseover")
	tabs_mouseover:SetPoint("TOPLEFT", combatlog, "BOTTOMLEFT", 0, 0)

	local sticky = ns.CreateCheckBox(parent, "sticky")
	sticky:SetPoint("TOPLEFT", tabs_mouseover, "BOTTOMLEFT", 0, 0)

	local damage_meter_spam = ns.CreateCheckBox(parent, "damage_meter_spam")
	damage_meter_spam:SetPoint("TOPLEFT", sticky, "BOTTOMLEFT", 0, 0)

	local loot_icons = ns.CreateCheckBox(parent, "loot_icons")
	loot_icons:SetPoint("TOPLEFT", damage_meter_spam, "BOTTOMLEFT", 0, 0)

	local role_icons = ns.CreateCheckBox(parent, "role_icons", L.tooltip_unit_role)
	role_icons:SetPoint("TOPLEFT", loot_icons, "BOTTOMLEFT", 0, 0)

	local history = ns.CreateCheckBox(parent, "history", HISTORY)
	history:SetPoint("TOPLEFT", role_icons, "BOTTOMLEFT", 0, 0)

	local hide_combat = ns.CreateCheckBox(parent, "hide_combat")
	hide_combat:SetPoint("TOPLEFT", history, "BOTTOMLEFT", 0, 0)

	local custom_time_color = ns.CreateCheckBox(parent, "custom_time_color")
	custom_time_color:SetPoint("TOPLEFT", hide_combat, "BOTTOMLEFT", 0, 0)

	local time_color = ns.CreateColourPicker(parent, "time_color", true)
	time_color:SetPoint("TOPLEFT", custom_time_color, "BOTTOMLEFT", 24, -4)
end

-- Nameplate
do
	local parent = ShestakUIOptionsPanel.nameplate

	local multScale = 768 / select(2, GetPhysicalScreenSize())

	local enable = ns.CreateCheckBox(parent, "enable", L_GUI_NAMEPLATE_ENABLE)
	enable:SetPoint("TOPLEFT", parent.subText, "BOTTOMLEFT", 0, 0)

	local width = ns.CreateNumberSlider(parent, "width", nil, nil, 0, 150 / multScale, 1, true, L_GUI_NAMEPLATE_WIDTH)
	width:SetPoint("TOPLEFT", enable, "BOTTOMLEFT", 0, -20)

	local height = ns.CreateNumberSlider(parent, "height", nil, nil, 0, 20 / multScale, 1, true, L_GUI_NAMEPLATE_HEIGHT)
	height:SetPoint("LEFT", width, "RIGHT", 120, 0)

	local ad_width = ns.CreateNumberSlider(parent, "ad_width", nil, nil, 0, 80 / multScale, 1, true)
	ad_width:SetPoint("TOPLEFT", width, "BOTTOMLEFT", 0, -20)

	local ad_height = ns.CreateNumberSlider(parent, "ad_height", nil, nil, 0, 15 / multScale, 1, true)
	ad_height:SetPoint("LEFT", ad_width, "RIGHT", 120, 0)

	local alpha = ns.CreateNumberSlider(parent, "alpha", nil, nil, 0, 1, 0.05, true)
	alpha:SetPoint("TOPLEFT", ad_width, "BOTTOMLEFT", 0, -20)

	local combat = ns.CreateCheckBox(parent, "combat", L_GUI_NAMEPLATE_COMBAT)
	combat:SetPoint("TOPLEFT", alpha, "BOTTOMLEFT", 0, -10)

	local health_value = ns.CreateCheckBox(parent, "health_value", L_GUI_NAMEPLATE_HEALTH)
	health_value:SetPoint("TOPLEFT", combat, "BOTTOMLEFT", 0, 0)

	local show_castbar_name = ns.CreateCheckBox(parent, "show_castbar_name", L_GUI_NAMEPLATE_CASTBAR_NAME)
	show_castbar_name:SetPoint("TOPLEFT", health_value, "BOTTOMLEFT", 0, 0)

	local class_icons = ns.CreateCheckBox(parent, "class_icons", L_GUI_NAMEPLATE_CLASS_ICON)
	class_icons:SetPoint("TOPLEFT", show_castbar_name, "BOTTOMLEFT", 0, 0)

	local name_abbrev = ns.CreateCheckBox(parent, "name_abbrev", L_GUI_NAMEPLATE_NAME_ABBREV)
	name_abbrev:SetPoint("TOPLEFT", class_icons, "BOTTOMLEFT", 0, 0)

	local short_name = ns.CreateCheckBox(parent, "short_name")
	short_name:SetPoint("TOPLEFT", name_abbrev, "BOTTOMLEFT", 0, 0)

	local clamp = ns.CreateCheckBox(parent, "clamp")
	clamp:SetPoint("TOPLEFT", short_name, "BOTTOMLEFT", 0, 0)

	local track_debuffs = ns.CreateCheckBox(parent, "track_debuffs", L_GUI_NAMEPLATE_SHOW_DEBUFFS)
	track_debuffs:SetPoint("TOPLEFT", clamp, "BOTTOMLEFT", 0, 0)
	track_debuffs.Text:SetWidth(350)

	local ListButton = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
	ListButton:SetPoint("LEFT", track_debuffs, "RIGHT", 400, 0)
	ListButton:SetSize(100, 23)
	ListButton:SetText(ADD)
	ListButton:SetWidth(ListButton.Text:GetWidth() + 15)
	ListButton:SetScript("OnClick", function()
		if not C.options["nameplate"] then
			C.options["nameplate"] = {}
		end
		if not C.options["nameplate"]["debuffs_list"] then
			C.options["nameplate"]["debuffs_list"] = {}
		end
		BuildSpellList(C.options["nameplate"]["debuffs_list"])
	end)
	tinsert(ns.buttons, ListButton)

	local function toggleListButton()
		local shown = track_debuffs:GetChecked()
		ListButton:SetEnabled(shown)
	end

	track_debuffs:HookScript("OnClick", toggleListButton)
	ListButton:HookScript("OnShow", toggleListButton)

	local track_buffs = ns.CreateCheckBox(parent, "track_buffs", L_GUI_NAMEPLATE_SHOW_BUFFS)
	track_buffs:SetPoint("TOPLEFT", track_debuffs, "BOTTOMLEFT", 0, 0)

	local ListButton = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
	ListButton:SetPoint("LEFT", track_buffs, "RIGHT", 400, 0)
	ListButton:SetSize(100, 23)
	ListButton:SetText(ADD)
	ListButton:SetWidth(ListButton.Text:GetWidth() + 15)
	ListButton:SetScript("OnClick", function()
		if not C.options["nameplate"] then
			C.options["nameplate"] = {}
		end
		if not C.options["nameplate"]["buffs_list"] then
			C.options["nameplate"]["buffs_list"] = {}
		end
		BuildSpellList(C.options["nameplate"]["buffs_list"])
	end)
	tinsert(ns.buttons, ListButton)

	local function toggleListButton()
		local shown = track_buffs:GetChecked()
		ListButton:SetEnabled(shown)
	end

	track_buffs:HookScript("OnClick", toggleListButton)
	ListButton:HookScript("OnShow", toggleListButton)

	local auras_size = ns.CreateNumberSlider(parent, "auras_size", nil, nil, 0, 35 / multScale, 1, true, L_GUI_NAMEPLATE_DEBUFFS_SIZE)
	auras_size:SetPoint("TOPLEFT", track_buffs, "BOTTOMLEFT", 0, -20)

	local healer_icon = ns.CreateCheckBox(parent, "healer_icon", L_GUI_NAMEPLATE_HEALER_ICON)
	healer_icon:SetPoint("TOPLEFT", auras_size, "BOTTOMLEFT", 0, -10)

	local totem_icons = ns.CreateCheckBox(parent, "totem_icons", L_GUI_NAMEPLATE_TOTEM_ICONS)
	totem_icons:SetPoint("TOPLEFT", healer_icon, "BOTTOMLEFT", 0, 0)

	local target_glow = ns.CreateCheckBox(parent, "target_glow")
	target_glow:SetPoint("TOPLEFT", totem_icons, "BOTTOMLEFT", 0, 0)

	local only_name = ns.CreateCheckBox(parent, "only_name")
	only_name:SetPoint("TOPLEFT", target_glow, "BOTTOMLEFT", 0, 0)

	local quests = ns.CreateCheckBox(parent, "quests")
	quests:SetPoint("TOPLEFT", only_name, "BOTTOMLEFT", 0, 0)

	-- Panel 2
	local parent = ShestakUIOptionsPanel.nameplate2

	local low_health_value = ns.CreateNumberSlider(parent, "low_health_value", nil, nil, 0.1, 1, 0.05, true)
	low_health_value:SetPoint("TOPLEFT", parent.subText, "BOTTOMLEFT", 0, -20)

	local low_health_color = ns.CreateColourPicker(parent, "low_health_color", true)
	low_health_color:SetPoint("LEFT", low_health_value, "RIGHT", 85, 0)

	local low_health = ns.CreateCheckBox(parent, "low_health")
	low_health:SetPoint("LEFT", low_health_color, "RIGHT", 15, 0)
	low_health.Text:SetWidth(250)

	local cast_color = ns.CreateCheckBox(parent, "cast_color")
	cast_color:SetPoint("TOPLEFT", low_health_value, "BOTTOMLEFT", 0, -8)

	local kick_color = ns.CreateCheckBox(parent, "kick_color")
	kick_color:SetPoint("TOPLEFT", cast_color, "BOTTOMLEFT", 0, 0)

	local enhance_threat = ns.CreateCheckBox(parent, "enhance_threat", L_GUI_NAMEPLATE_THREAT)
	enhance_threat:SetPoint("TOPLEFT", kick_color, "BOTTOMLEFT", 0, 0)

	local good_color = ns.CreateColourPicker(parent, "good_color", true, L_GUI_NAMEPLATE_GOOD_COLOR)
	good_color:SetPoint("TOPLEFT", enhance_threat, "BOTTOMLEFT", 24, -4)

	local near_color = ns.CreateColourPicker(parent, "near_color", true, L_GUI_NAMEPLATE_NEAR_COLOR)
	near_color:SetPoint("TOPLEFT", good_color, "BOTTOMLEFT", 0, -8)

	local bad_color = ns.CreateColourPicker(parent, "bad_color", true, L_GUI_NAMEPLATE_BAD_COLOR)
	bad_color:SetPoint("TOPLEFT", near_color, "BOTTOMLEFT", 0, -8)

	local offtank_color = ns.CreateColourPicker(parent, "offtank_color", true, L_GUI_NAMEPLATE_OFFTANK_COLOR)
	offtank_color:SetPoint("TOPLEFT", bad_color, "BOTTOMLEFT", 0, -8)

	local extra_color = ns.CreateColourPicker(parent, "extra_color", true)
	extra_color:SetPoint("TOPLEFT", offtank_color, "BOTTOMLEFT", 0, -8)

	local mob_color_enable = ns.CreateCheckBox(parent, "mob_color_enable")
	mob_color_enable:SetPoint("TOPLEFT", extra_color, "BOTTOMLEFT", -24, -8)

	local mob_color = ns.CreateColourPicker(parent, "mob_color", true)
	mob_color:SetPoint("TOPLEFT", mob_color_enable, "BOTTOMLEFT", 24, -4)
end

-- Combat text
do
	local parent = ShestakUIOptionsPanel.combattext

	local enable = ns.CreateCheckBox(parent, "enable", L_GUI_COMBATTEXT_ENABLE)
	enable:SetPoint("TOPLEFT", parent.subText, "BOTTOMLEFT", 0, 0)

	local blizz_head_numbers = ns.CreateCheckBox(parent, "blizz_head_numbers")
	blizz_head_numbers:SetPoint("TOPLEFT", enable, "BOTTOMLEFT", 0, 0)

	local damage_style = ns.CreateCheckBox(parent, "damage_style")
	damage_style:SetPoint("TOPLEFT", blizz_head_numbers, "BOTTOMLEFT", 20, 0)

	blizz_head_numbers.children = {damage_style}

	local damage = ns.CreateCheckBox(parent, "damage", L_GUI_COMBATTEXT_DAMAGE)
	damage:SetPoint("TOPLEFT", damage_style, "BOTTOMLEFT", -20, 0)

	local pet_damage = ns.CreateCheckBox(parent, "pet_damage", L_GUI_COMBATTEXT_PET_DAMAGE)
	pet_damage:SetPoint("TOPLEFT", damage, "BOTTOMLEFT", 20, 0)

	local dot_damage = ns.CreateCheckBox(parent, "dot_damage", L_GUI_COMBATTEXT_DOT_DAMAGE)
	dot_damage:SetPoint("TOPLEFT", pet_damage, "BOTTOMLEFT", 0, 0)

	local healing = ns.CreateCheckBox(parent, "healing", L_GUI_COMBATTEXT_HEALING)
	healing:SetPoint("TOPLEFT", dot_damage, "BOTTOMLEFT", -20, 0)

	local show_hots = ns.CreateCheckBox(parent, "show_hots", L_GUI_COMBATTEXT_HOTS)
	show_hots:SetPoint("TOPLEFT", healing, "BOTTOMLEFT", 20, 0)

	local show_overhealing = ns.CreateCheckBox(parent, "show_overhealing", L_GUI_COMBATTEXT_OVERHEALING)
	show_overhealing:SetPoint("TOPLEFT", show_hots, "BOTTOMLEFT", 0, 0)

	local incoming = ns.CreateCheckBox(parent, "incoming", L.combattext_incoming)
	incoming:SetPoint("TOPLEFT", show_overhealing, "BOTTOMLEFT", -20, 0)

	local damage_color = ns.CreateCheckBox(parent, "damage_color", L_GUI_COMBATTEXT_DAMAGE_COLOR)
	damage_color:SetPoint("TOPLEFT", incoming, "BOTTOMLEFT", 0, 0)

	local dispel = ns.CreateCheckBox(parent, "dispel", L_GUI_COMBATTEXT_DISPEL)
	dispel:SetPoint("TOPLEFT", damage_color, "BOTTOMLEFT", 0, 0)

	local interrupt = ns.CreateCheckBox(parent, "interrupt", L_GUI_COMBATTEXT_INTERRUPT)
	interrupt:SetPoint("TOPLEFT", dispel, "BOTTOMLEFT", 0, 0)

	local icons = ns.CreateCheckBox(parent, "icons", L_GUI_COMBATTEXT_ICONS)
	icons:SetPoint("TOPLEFT", interrupt, "BOTTOMLEFT", 0, 0)

	local icon_size = ns.CreateNumberSlider(parent, "icon_size", nil, nil, 0, 40, 1, true, L_GUI_COMBATTEXT_ICON_SIZE, L_GUI_COMBATTEXT_ICON_SIZE_DESC)
	icon_size:SetPoint("TOPLEFT", icons, "BOTTOMLEFT", 0, -20)

	local max_lines = ns.CreateNumberSlider(parent, "max_lines", nil, nil, 0, 30, 1, true, L_GUI_COMBATTEXT_MAX_LINES, L_GUI_COMBATTEXT_MAX_LINES_DESC)
	max_lines:SetPoint("TOPLEFT", icon_size, "BOTTOMLEFT", 0, -20)

	local time_visible = ns.CreateNumberSlider(parent, "time_visible", nil, nil, 0, 10, 1, true, L_GUI_COMBATTEXT_TIME_VISIBLE, L_GUI_COMBATTEXT_TIME_VISIBLE_DESC)
	time_visible:SetPoint("LEFT", max_lines, "RIGHT", 120, 0)

	local short_numbers = ns.CreateCheckBox(parent, "short_numbers", L_GUI_COMBATTEXT_SHORT_NUMBERS)
	short_numbers:SetPoint("TOPLEFT", max_lines, "BOTTOMLEFT", 0, -8)

	local merge_aoe_spam = ns.CreateCheckBox(parent, "merge_aoe_spam")
	merge_aoe_spam:SetPoint("TOPLEFT", short_numbers, "BOTTOMLEFT", 0, 0)

	local ListButton = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
	ListButton:SetPoint("LEFT", merge_aoe_spam, "RIGHT", 400, 0)
	ListButton:SetSize(100, 23)
	ListButton:SetText(ADD)
	ListButton:SetWidth(ListButton.Text:GetWidth() + 15)
	ListButton:SetScript("OnClick", function()
		if not C.options["combattext"] then
			C.options["combattext"] = {}
		end
		if not C.options["combattext"]["spells_list"] then
			C.options["combattext"]["spells_list"] = {}
		end
		BuildSpellList(C.options["combattext"]["spells_list"], true)
	end)
	tinsert(ns.buttons, ListButton)

	local function toggleListButton()
		local shown = merge_aoe_spam:GetChecked()
		ListButton:SetEnabled(shown)
	end

	merge_aoe_spam:HookScript("OnClick", toggleListButton)
	ListButton:HookScript("OnShow", toggleListButton)

	local merge_melee = ns.CreateCheckBox(parent, "merge_melee", L_GUI_COMBATTEXT_MERGE_MELEE)
	merge_melee:SetPoint("TOPLEFT", merge_aoe_spam, "BOTTOMLEFT", 20, 0)

	local merge_all = ns.CreateCheckBox(parent, "merge_all")
	merge_all:SetPoint("TOPLEFT", merge_melee, "BOTTOMLEFT", 0, 0)

	local direction = ns.CreateCheckBox(parent, "direction", L_GUI_COMBATTEXT_DIRECTION)
	direction:SetPoint("TOPLEFT", merge_all, "BOTTOMLEFT", -20, 0)

	-- Panel 2
	local parent = ShestakUIOptionsPanel.combattext2

	local dk_runes = ns.CreateCheckBox(parent, "dk_runes", L_GUI_COMBATTEXT_DK_RUNES)
	dk_runes:SetPoint("TOPLEFT", parent.subText, "BOTTOMLEFT", 0, 0)

	local killingblow = ns.CreateCheckBox(parent, "killingblow", L_GUI_COMBATTEXT_KILLINGBLOW)
	killingblow:SetPoint("TOPLEFT", dk_runes, "BOTTOMLEFT", 0, 0)

	local scrollable = ns.CreateCheckBox(parent, "scrollable", L_GUI_COMBATTEXT_SCROLLABLE)
	scrollable:SetPoint("TOPLEFT", killingblow, "BOTTOMLEFT", 0, 0)

	local crit_prefix = ns.CreateEditBox(parent, "crit_prefix", true, L_GUI_COMBATTEXT_CRIT_PREFIX)
	crit_prefix:SetPoint("TOPLEFT", scrollable, "BOTTOMLEFT", 6, -8)

	local crit_postfix = ns.CreateEditBox(parent, "crit_postfix", true, L_GUI_COMBATTEXT_CRIT_POSTFIX)
	crit_postfix:SetPoint("TOPLEFT", crit_prefix, "BOTTOMLEFT", 0, -10)

	local treshold = ns.CreateEditBox(parent, "treshold", true, L_GUI_COMBATTEXT_TRESHOLD, true)
	treshold:SetPoint("TOPLEFT", crit_postfix, "BOTTOMLEFT", 0, -10)

	local heal_treshold = ns.CreateEditBox(parent, "heal_treshold", true, L_GUI_COMBATTEXT_HEAL_TRESHOLD, true)
	heal_treshold:SetPoint("TOPLEFT", treshold, "BOTTOMLEFT", 0, -10)
end

-- Bag
do
	local parent = ShestakUIOptionsPanel.bag

	local enable = ns.CreateCheckBox(parent, "enable", L_GUI_BAGS_ENABLE)
	enable:SetPoint("TOPLEFT", parent.subText, "BOTTOMLEFT", 0, 0)

	local ilvl = ns.CreateCheckBox(parent, "ilvl", L_GUI_BAGS_ILVL)
	ilvl:SetPoint("TOPLEFT", enable, "BOTTOMLEFT", 0, 0)

	local new_items = ns.CreateCheckBox(parent, "new_items")
	new_items:SetPoint("TOPLEFT", ilvl, "BOTTOMLEFT", 0, 0)

	local filter = ns.CreateCheckBox(parent, "filter")
	filter:SetPoint("TOPLEFT", new_items, "BOTTOMLEFT", 0, 0)

	local button_size = ns.CreateNumberSlider(parent, "button_size", nil, nil, 0, 50, 1, true, L_GUI_BAGS_BUTTON_SIZE)
	button_size:SetPoint("TOPLEFT", filter, "BOTTOMLEFT", 0, -20)

	local button_space = ns.CreateNumberSlider(parent, "button_space", nil, nil, 0, 10, 1, true, L_GUI_BAGS_BUTTON_SPACE)
	button_space:SetPoint("LEFT", button_size, "RIGHT", 120, 0)

	local bag_columns = ns.CreateNumberSlider(parent, "bag_columns", nil, nil, 0, 20, 1, true, L_GUI_BAGS_BAG)
	bag_columns:SetPoint("TOPLEFT", button_size, "BOTTOMLEFT", 0, -20)

	local bank_columns = ns.CreateNumberSlider(parent, "bank_columns", nil, nil, 0, 25, 1, true, L_GUI_BAGS_BANK)
	bank_columns:SetPoint("LEFT", bag_columns, "RIGHT", 120, 0)
end

-- Minimap
do
	local parent = ShestakUIOptionsPanel.minimap

	local enable = ns.CreateCheckBox(parent, "enable", L_GUI_MINIMAP_ENABLE)
	enable:SetPoint("TOPLEFT", parent.subText, "BOTTOMLEFT", 0, 0)

	local on_top = ns.CreateCheckBox(parent, "on_top")
	on_top:SetPoint("TOPLEFT", enable, "BOTTOMLEFT", 0, 0)

	local tracking_icon = ns.CreateCheckBox(parent, "tracking_icon", L_GUI_MINIMAP_ICON)
	tracking_icon:SetPoint("TOPLEFT", on_top, "BOTTOMLEFT", 0, 0)

	local garrison_icon = ns.CreateCheckBox(parent, "garrison_icon", DRAGONFLIGHT_LANDING_PAGE_TITLE)
	garrison_icon:SetPoint("TOPLEFT", tracking_icon, "BOTTOMLEFT", 0, 0)

	local size = ns.CreateNumberSlider(parent, "size", nil, nil, 0, 300, 1, true, L_GUI_MINIMAP_SIZE)
	size:SetPoint("TOPLEFT", garrison_icon, "BOTTOMLEFT", 0, -20)

	local hide_combat = ns.CreateCheckBox(parent, "hide_combat", L_GUI_MINIMAP_HIDE_COMBAT)
	hide_combat:SetPoint("TOPLEFT", size, "BOTTOMLEFT", 0, -10)

	local toggle_menu = ns.CreateCheckBox(parent, "toggle_menu", L_GUI_MINIMAP_TOGGLE_MENU)
	toggle_menu:SetPoint("TOPLEFT", hide_combat, "BOTTOMLEFT", 0, 0)

	-- Other
	local subheader = ns.addSubCategory(parent, OTHER)
	subheader:SetPoint("TOPLEFT", toggle_menu, "BOTTOMLEFT", 0, -16)

	local bg_map_stylization = ns.CreateCheckBox(parent, "bg_map_stylization")
	bg_map_stylization:SetPoint("TOPLEFT", subheader, "BOTTOMLEFT", 0, -8)

	local fog_of_war = ns.CreateCheckBox(parent, "fog_of_war")
	fog_of_war:SetPoint("TOPLEFT", bg_map_stylization, "BOTTOMLEFT", 0, 0)
end

-- Loot
do
	local parent = ShestakUIOptionsPanel.loot

	local lootframe = ns.CreateCheckBox(parent, "lootframe", L_GUI_LOOT_ENABLE)
	lootframe:SetPoint("TOPLEFT", parent.subText, "BOTTOMLEFT", 0, 0)

	local icon_size = ns.CreateNumberSlider(parent, "icon_size", nil, nil, 0, 50, 1, true, L_GUI_LOOT_ICON_SIZE)
	icon_size:SetPoint("TOPLEFT", lootframe, "BOTTOMLEFT", 0, -20)

	local width = ns.CreateNumberSlider(parent, "width", nil, nil, 0, 400, 1, true, L_GUI_LOOT_WIDTH)
	width:SetPoint("TOPLEFT", icon_size, "BOTTOMLEFT", 0, -20)

	local faster_loot = ns.CreateCheckBox(parent, "faster_loot")
	faster_loot:SetPoint("TOPLEFT", width, "BOTTOMLEFT", 0, -10)

	local rolllootframe = ns.CreateCheckBox(parent, "rolllootframe", L_GUI_LOOT_ROLL_ENABLE)
	rolllootframe:SetPoint("TOPLEFT", faster_loot, "BOTTOMLEFT", 0, 0)

	local auto_greed = ns.CreateCheckBox(parent, "auto_greed", L_GUI_LOOT_AUTOGREED)
	auto_greed:SetPoint("TOPLEFT", rolllootframe, "BOTTOMLEFT", 0, 0)

	local auto_confirm_de = ns.CreateCheckBox(parent, "auto_confirm_de", L_GUI_LOOT_AUTODE)
	auto_confirm_de:SetPoint("TOPLEFT", auto_greed, "BOTTOMLEFT", 0, 0)
end

-- Filger
do
	local parent = ShestakUIOptionsPanel.filger

	local enable = ns.CreateCheckBox(parent, "enable", L_GUI_FILGER_ENABLE)
	enable:SetPoint("TOPLEFT", parent.subText, "BOTTOMLEFT", 0, 0)

	local show_tooltip = ns.CreateCheckBox(parent, "show_tooltip", L_GUI_FILGER_SHOW_TOOLTIP)
	show_tooltip:SetPoint("TOPLEFT", enable, "BOTTOMLEFT", 0, 0)

	local expiration = ns.CreateCheckBox(parent, "expiration", L_GUI_FILGER_EXPIRATION)
	expiration:SetPoint("TOPLEFT", show_tooltip, "BOTTOMLEFT", 0, 0)

	-- Elements
	local subheader = ns.addSubCategory(parent, L.filger_subheader_elements)
	subheader:SetPoint("TOPLEFT", expiration, "BOTTOMLEFT", 0, -10)

	local show_buff = ns.CreateCheckBox(parent, "show_buff")
	show_buff:SetPoint("TOPLEFT", subheader, "BOTTOMLEFT", 0, -10)

	local show_proc = ns.CreateCheckBox(parent, "show_proc")
	show_proc:SetPoint("LEFT", show_buff, "RIGHT", 320, 0)

	local show_debuff = ns.CreateCheckBox(parent, "show_debuff")
	show_debuff:SetPoint("TOPLEFT", show_buff, "BOTTOMLEFT", 0, 0)

	local show_aura_bar = ns.CreateCheckBox(parent, "show_aura_bar")
	show_aura_bar:SetPoint("LEFT", show_debuff, "RIGHT", 320, 0)

	local show_pvp_player = ns.CreateCheckBox(parent, "show_pvp_player")
	show_pvp_player:SetPoint("TOPLEFT", show_debuff, "BOTTOMLEFT", 0, 0)

	local show_pvp_target = ns.CreateCheckBox(parent, "show_pvp_target")
	show_pvp_target:SetPoint("LEFT", show_pvp_player, "RIGHT", 320, 0)

	local show_special = ns.CreateCheckBox(parent, "show_special")
	show_special:SetPoint("TOPLEFT", show_pvp_player, "BOTTOMLEFT", 0, 0)

	local show_cd = ns.CreateCheckBox(parent, "show_cd")
	show_cd:SetPoint("LEFT", show_special, "RIGHT", 320, 0)

	-- Size
	local subheader = ns.addSubCategory(parent, L.filger_subheader_size)
	subheader:SetPoint("TOPLEFT", show_special, "BOTTOMLEFT", 0, -10)

	local buffs_size = ns.CreateNumberSlider(parent, "buffs_size", nil, nil, 0, 60, 1, true, L_GUI_FILGER_BUFFS_SIZE)
	buffs_size:SetPoint("TOPLEFT", subheader, "BOTTOMLEFT", 0, -30)

	local buffs_space = ns.CreateNumberSlider(parent, "buffs_space", nil, nil, 0, 10, 1, true)
	buffs_space:SetPoint("LEFT", buffs_size, "RIGHT", 120, 0)

	local pvp_size = ns.CreateNumberSlider(parent, "pvp_size", nil, nil, 0, 90, 1, true, L_GUI_FILGER_PVP_SIZE)
	pvp_size:SetPoint("TOPLEFT", buffs_size, "BOTTOMLEFT", 0, -20)

	local pvp_space = ns.CreateNumberSlider(parent, "pvp_space", nil, nil, 0, 10, 1, true)
	pvp_space:SetPoint("LEFT", pvp_size, "RIGHT", 120, 0)

	local cooldown_size = ns.CreateNumberSlider(parent, "cooldown_size", nil, nil, 0, 60, 1, true, L_GUI_FILGER_COOLDOWN_SIZE)
	cooldown_size:SetPoint("TOPLEFT", pvp_size, "BOTTOMLEFT", 0, -20)

	local cooldown_space = ns.CreateNumberSlider(parent, "cooldown_space", nil, nil, 0, 10, 1, true)
	cooldown_space:SetPoint("LEFT", cooldown_size, "RIGHT", 120, 0)

	-- Testing
	local subheader = ns.addSubCategory(parent, L.filger_subheader_test)
	subheader:SetPoint("TOPLEFT", cooldown_size, "BOTTOMLEFT", 0, -10)

	local test_mode = ns.CreateCheckBox(parent, "test_mode", L_GUI_FILGER_TEST_MODE)
	test_mode:SetPoint("TOPLEFT", subheader, "BOTTOMLEFT", 0, -10)

	local max_test_icon = ns.CreateNumberSlider(parent, "max_test_icon", nil, nil, 0, 10, 1, true, L_GUI_FILGER_MAX_TEST_ICON)
	max_test_icon:SetPoint("TOPLEFT", test_mode, "BOTTOMLEFT", 0, -20)

	-- Spell List
	local subheader = ns.addSubCategory(parent, L.filger_subheader_spells)
	subheader:SetPoint("TOPLEFT", max_test_icon, "BOTTOMLEFT", 0, -10)

	local category_list = ns.CreateDropDown(parent, "category_list", true, L.filger_category_list, FilgerTable)
	category_list:SetPoint("TOPLEFT", subheader, "BOTTOMLEFT", -16, -10)

	hooksecurefunc(category_list, "SetValue", function()
		if not C.options["filger"] then
			C.options["filger"] = {}
		end
		if not C.options["filger"][FilgerDropDownText[category_list.selectedValue]] then
			C.options["filger"][FilgerDropDownText[category_list.selectedValue]] = {}
		end
		BuildSpellList(C.options["filger"][FilgerDropDownText[category_list.selectedValue]], false, true)
	end)
end

-- Announcements
do
	local parent = ShestakUIOptionsPanel.announcements

	local interrupts = ns.CreateCheckBox(parent, "interrupts")
	interrupts:SetPoint("TOPLEFT", parent.subText, "BOTTOMLEFT", 0, 0)

	local spells = ns.CreateCheckBox(parent, "spells")
	spells:SetPoint("TOPLEFT", interrupts, "BOTTOMLEFT", 0, 0)

	local ListButton = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
	ListButton:SetPoint("LEFT", spells, "RIGHT", 400, 0)
	ListButton:SetSize(100, 23)
	ListButton:SetText(ADD)
	ListButton:SetWidth(ListButton.Text:GetWidth() + 15)
	ListButton:SetScript("OnClick", function()
		if not C.options["announcements"] then
			C.options["announcements"] = {}
		end
		if not C.options["announcements"]["spells_list"] then
			C.options["announcements"]["spells_list"] = T.announce_spells
		end
		BuildSpellList(C.options["announcements"]["spells_list"])
	end)
	tinsert(ns.buttons, ListButton)

	local function toggleListButton()
		local shown = spells:GetChecked()
		ListButton:SetEnabled(shown)
		if not T.announce_spells then
			ListButton.tooltipText = "|cffFFD100"..REQUIRES_RELOAD.."|r"
			ListButton:SetScript("OnClick", nil)
		end
	end

	spells:HookScript("OnClick", toggleListButton)
	ListButton:HookScript("OnShow", toggleListButton)

	local spells_from_all = ns.CreateCheckBox(parent, "spells_from_all")
	spells_from_all:SetPoint("TOPLEFT", spells, "BOTTOMLEFT", 20, 0)

	spells.children = {spells_from_all}

	local feasts = ns.CreateCheckBox(parent, "feasts")
	feasts:SetPoint("TOPLEFT", spells_from_all, "BOTTOMLEFT", -20, 0)

	local portals = ns.CreateCheckBox(parent, "portals")
	portals:SetPoint("TOPLEFT", feasts, "BOTTOMLEFT", 0, 0)

	local toys = ns.CreateCheckBox(parent, "toys")
	toys:SetPoint("TOPLEFT", portals, "BOTTOMLEFT", 0, 0)

	local flask_food = ns.CreateCheckBox(parent, "flask_food")
	flask_food:SetPoint("TOPLEFT", toys, "BOTTOMLEFT", 0, 0)

	local flask_food_raid = ns.CreateCheckBox(parent, "flask_food_raid")
	flask_food_raid:SetPoint("TOPLEFT", flask_food, "BOTTOMLEFT", 20, 0)

	local flask_food_auto = ns.CreateCheckBox(parent, "flask_food_auto")
	flask_food_auto:SetPoint("TOPLEFT", flask_food_raid, "BOTTOMLEFT", 0, 0)

	flask_food.children = {flask_food_raid, flask_food_auto}

	local drinking = ns.CreateCheckBox(parent, "drinking")
	drinking:SetPoint("TOPLEFT", flask_food_auto, "BOTTOMLEFT", -20, 0)

	local pull_countdown = ns.CreateCheckBox(parent, "pull_countdown")
	pull_countdown:SetPoint("TOPLEFT", drinking, "BOTTOMLEFT", 0, 0)

	-- Self announce
	local subheader = ns.addSubCategory(parent, L.announcements_subheader_self)
	subheader:SetPoint("TOPLEFT", pull_countdown, "BOTTOMLEFT", 0, -10)

	local bad_gear = ns.CreateCheckBox(parent, "bad_gear")
	bad_gear:SetPoint("TOPLEFT", subheader, "BOTTOMLEFT", 0, -10)

	local safari_hat = ns.CreateCheckBox(parent, "safari_hat")
	safari_hat:SetPoint("TOPLEFT", bad_gear, "BOTTOMLEFT", 0, 0)
end

-- Automation
do
	local parent = ShestakUIOptionsPanel.automation

	local release = ns.CreateCheckBox(parent, "release")
	release:SetPoint("TOPLEFT", parent.subText, "BOTTOMLEFT", 0, 0)

	local screenshot = ns.CreateCheckBox(parent, "screenshot")
	screenshot:SetPoint("TOPLEFT", release, "BOTTOMLEFT", 0, 0)

	local solve_artifact = ns.CreateCheckBox(parent, "solve_artifact")
	solve_artifact:SetPoint("TOPLEFT", screenshot, "BOTTOMLEFT", 0, 0)

	local accept_invite = ns.CreateCheckBox(parent, "accept_invite")
	accept_invite:SetPoint("TOPLEFT", solve_artifact, "BOTTOMLEFT", 0, 0)

	local decline_duel = ns.CreateCheckBox(parent, "decline_duel")
	decline_duel:SetPoint("TOPLEFT", accept_invite, "BOTTOMLEFT", 0, 0)

	local accept_quest = ns.CreateCheckBox(parent, "accept_quest")
	accept_quest:SetPoint("TOPLEFT", decline_duel, "BOTTOMLEFT", 0, 0)

	local skip_cinematic = ns.CreateCheckBox(parent, "skip_cinematic")
	skip_cinematic:SetPoint("TOPLEFT", accept_quest, "BOTTOMLEFT", 0, 0)

	local auto_role = ns.CreateCheckBox(parent, "auto_role")
	auto_role:SetPoint("TOPLEFT", skip_cinematic, "BOTTOMLEFT", 0, 0)

	local cancel_bad_buffs = ns.CreateCheckBox(parent, "cancel_bad_buffs")
	cancel_bad_buffs:SetPoint("TOPLEFT", auto_role, "BOTTOMLEFT", 0, 0)

	local tab_binder = ns.CreateCheckBox(parent, "tab_binder")
	tab_binder:SetPoint("TOPLEFT", cancel_bad_buffs, "BOTTOMLEFT", 0, 0)

	local logging_combat = ns.CreateCheckBox(parent, "logging_combat")
	logging_combat:SetPoint("TOPLEFT", tab_binder, "BOTTOMLEFT", 0, 0)

	local buff_on_scroll = ns.CreateCheckBox(parent, "buff_on_scroll")
	buff_on_scroll:SetPoint("TOPLEFT", logging_combat, "BOTTOMLEFT", 0, 0)

	local open_items = ns.CreateCheckBox(parent, "open_items")
	open_items:SetPoint("TOPLEFT", buff_on_scroll, "BOTTOMLEFT", 0, 0)

	local resurrection = ns.CreateCheckBox(parent, "resurrection")
	resurrection:SetPoint("TOPLEFT", open_items, "BOTTOMLEFT", 0, 0)

	local summon = ns.CreateCheckBox(parent, "summon")
	summon:SetPoint("TOPLEFT", resurrection, "BOTTOMLEFT", 0, 0)

	local whisper_invite = ns.CreateCheckBox(parent, "whisper_invite")
	whisper_invite:SetPoint("TOPLEFT", summon, "BOTTOMLEFT", 0, 0)
	whisper_invite.needsReload = false

	local invite_keyword = ns.CreateEditBox(parent, "invite_keyword", true)
	invite_keyword:SetPoint("TOPLEFT", whisper_invite, "BOTTOMLEFT", 6, -6)
	invite_keyword:SetWidth(90)
	invite_keyword:SetMaxLetters(20)

	local auto_collapse = ns.CreateDropDown(parent, "auto_collapse", true, false, CollapseTable)
	auto_collapse:SetPoint("TOPLEFT", invite_keyword, "BOTTOMLEFT", -22, -10)
end

-- Reminder
do
	local parent = ShestakUIOptionsPanel.reminder

	local solo_buffs_enable = ns.CreateCheckBox(parent, "solo_buffs_enable", L_GUI_REMINDER_SOLO_ENABLE)
	solo_buffs_enable:SetPoint("TOPLEFT", parent.subText, "BOTTOMLEFT", 0, 0)

	local solo_buffs_sound = ns.CreateCheckBox(parent, "solo_buffs_sound", L_GUI_REMINDER_SOLO_SOUND)
	solo_buffs_sound:SetPoint("TOPLEFT", solo_buffs_enable, "BOTTOMLEFT", 0, 0)

	local solo_buffs_size = ns.CreateNumberSlider(parent, "solo_buffs_size", nil, nil, 0, 80, 1, true, L_GUI_REMINDER_SOLO_SIZE, L_GUI_REMINDER_SOLO_SIZE_DESC)
	solo_buffs_size:SetPoint("TOPLEFT", solo_buffs_sound, "BOTTOMLEFT", 0, -20)

	-- Raid buffs
	local subheader = ns.addSubCategory(parent, L_GUI_REMINDER_SUBHEADER)
	subheader:SetPoint("TOPLEFT", solo_buffs_size, "BOTTOMLEFT", 0, -16)

	local raid_buffs_enable = ns.CreateCheckBox(parent, "raid_buffs_enable", L_GUI_REMINDER_RAID_ENABLE)
	raid_buffs_enable:SetPoint("TOPLEFT", subheader, "BOTTOMLEFT", 0, -8)

	local raid_buffs_always = ns.CreateCheckBox(parent, "raid_buffs_always", L_GUI_REMINDER_RAID_ALWAYS)
	raid_buffs_always:SetPoint("TOPLEFT", raid_buffs_enable, "BOTTOMLEFT", 0, 0)

	local raid_buffs_size = ns.CreateNumberSlider(parent, "raid_buffs_size", nil, nil, 0, 40, 1, true, L_GUI_REMINDER_RAID_SIZE, L_GUI_REMINDER_RAID_SIZE_DESC)
	raid_buffs_size:SetPoint("TOPLEFT", raid_buffs_always, "BOTTOMLEFT", 0, -20)

	local raid_buffs_alpha = ns.CreateNumberSlider(parent, "raid_buffs_alpha", nil, nil, 0, 1, 0.05, true, L_GUI_REMINDER_RAID_ALPHA, L_GUI_REMINDER_RAID_ALPHA_DESC)
	raid_buffs_alpha:SetPoint("TOPLEFT", raid_buffs_size, "BOTTOMLEFT", 0, -20)
end

-- Raid cooldowns
do
	local parent = ShestakUIOptionsPanel.raidcooldown

	local enable = ns.CreateCheckBox(parent, "enable", L_GUI_COOLDOWN_RAID_ENABLE)
	enable:SetPoint("TOPLEFT", parent.subText, "BOTTOMLEFT", 0, 0)

	local height = ns.CreateNumberSlider(parent, "height", nil, nil, 0, 30, 1, true, L_GUI_COOLDOWN_RAID_HEIGHT)
	height:SetPoint("TOPLEFT", enable, "BOTTOMLEFT", 0, -20)

	local width = ns.CreateNumberSlider(parent, "width", nil, nil, 0, 300, 1, true, L_GUI_COOLDOWN_RAID_WIDTH)
	width:SetPoint("LEFT", height, "RIGHT", 120, 0)

	local upwards = ns.CreateCheckBox(parent, "upwards", L_GUI_COOLDOWN_RAID_SORT)
	upwards:SetPoint("TOPLEFT", height, "BOTTOMLEFT", 0, -10)

	local expiration = ns.CreateCheckBox(parent, "expiration", L_GUI_COOLDOWN_RAID_EXPIRATION)
	expiration:SetPoint("TOPLEFT", upwards, "BOTTOMLEFT", 0, 0)

	local show_self = ns.CreateCheckBox(parent, "show_self", L_GUI_COOLDOWN_RAID_SHOW_SELF)
	show_self:SetPoint("TOPLEFT", expiration, "BOTTOMLEFT", 0, 0)

	local show_icon = ns.CreateCheckBox(parent, "show_icon", L_GUI_COOLDOWN_RAID_ICONS)
	show_icon:SetPoint("TOPLEFT", show_self, "BOTTOMLEFT", 0, 0)

	local show_inraid = ns.CreateCheckBox(parent, "show_inraid", L_GUI_COOLDOWN_RAID_IN_RAID)
	show_inraid:SetPoint("TOPLEFT", show_icon, "BOTTOMLEFT", 0, 0)

	local show_inparty = ns.CreateCheckBox(parent, "show_inparty", L_GUI_COOLDOWN_RAID_IN_PARTY)
	show_inparty:SetPoint("TOPLEFT", show_inraid, "BOTTOMLEFT", 0, 0)

	local show_inarena = ns.CreateCheckBox(parent, "show_inarena", L_GUI_COOLDOWN_RAID_IN_ARENA)
	show_inarena:SetPoint("TOPLEFT", show_inparty, "BOTTOMLEFT", 0, 0)

	local ListButton = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
	ListButton:SetPoint("TOPLEFT", show_inarena, "BOTTOMLEFT", 3, -5)
	ListButton:SetSize(100, 23)
	ListButton:SetText(L_GUI_SPELL_LIST)
	ListButton:SetWidth(ListButton.Text:GetWidth() + 15)
	ListButton.tooltipText = "|cffFFD100"..L_GUI_RESET_SPELLS_DESC.."|r"
	ListButton:SetScript("OnClick", function()
		if not C.options["raidcooldown"] then
			C.options["raidcooldown"] = {}
		end
		if not C.options["raidcooldown"]["spells_list"] then
			C.options["raidcooldown"]["spells_list"] = T.raid_spells
			C.options.raidcooldown.spells_list_ver = 4
		end
		if IsControlKeyDown() then
			C.options["raidcooldown"]["spells_list"] = nil
			ns.setReloadNeeded(true)
			ListButton.tooltipText = "|cffFFD100"..REQUIRES_RELOAD.."|r"
			ListButton:SetScript("OnClick", nil)
			GameTooltip:Hide()
			SpellList:Hide()
			return
		end
		BuildSpellList(C.options["raidcooldown"]["spells_list"], true)
	end)
	tinsert(ns.buttons, ListButton)

	local function toggleListButton()
		local shown = enable:GetChecked()
		ListButton:SetEnabled(shown)
		if not T.raid_spells then ListButton:Disable() return end
	end

	enable:HookScript("OnClick", toggleListButton)
	ListButton:HookScript("OnShow", toggleListButton)
end

-- Enemy cooldowns
do
	local parent = ShestakUIOptionsPanel.enemycooldown

	local enable = ns.CreateCheckBox(parent, "enable", L_GUI_COOLDOWN_ENEMY_ENABLE)
	enable:SetPoint("TOPLEFT", parent.subText, "BOTTOMLEFT", 0, 0)

	local size = ns.CreateNumberSlider(parent, "size", nil, nil, 0, 60, 1, true, L_GUI_COOLDOWN_ENEMY_SIZE)
	size:SetPoint("TOPLEFT", enable, "BOTTOMLEFT", 0, -20)

	local direction = ns.CreateDropDown(parent, "direction", true, L_GUI_COOLDOWN_ENEMY_DIRECTION, {"RIGHT", "LEFT", "UP", "DOWN"})
	direction:SetPoint("TOPLEFT", size, "BOTTOMLEFT", -16, -10)

	local show_always = ns.CreateCheckBox(parent, "show_always", L_GUI_COOLDOWN_ENEMY_EVERYWHERE)
	show_always:SetPoint("TOPLEFT", direction, "BOTTOMLEFT", 16, 0)

	local show_inpvp = ns.CreateCheckBox(parent, "show_inpvp", L_GUI_COOLDOWN_ENEMY_IN_BG)
	show_inpvp:SetPoint("TOPLEFT", show_always, "BOTTOMLEFT", 0, 0)

	local show_inarena = ns.CreateCheckBox(parent, "show_inarena", L_GUI_COOLDOWN_ENEMY_IN_ARENA)
	show_inarena:SetPoint("TOPLEFT", show_inpvp, "BOTTOMLEFT", 0, 0)

	local show_inparty = ns.CreateCheckBox(parent, "show_inparty")
	show_inparty:SetPoint("TOPLEFT", show_inarena, "BOTTOMLEFT", 0, 0)

	local class_color = ns.CreateCheckBox(parent, "class_color")
	class_color:SetPoint("TOPLEFT", show_inparty, "BOTTOMLEFT", 0, 0)

	local ListButton = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
	ListButton:SetPoint("TOPLEFT", class_color, "BOTTOMLEFT", 3, -5)
	ListButton:SetSize(100, 23)
	ListButton:SetText(L_GUI_SPELL_LIST)
	ListButton:SetWidth(ListButton.Text:GetWidth() + 15)
	ListButton.tooltipText = "|cffFFD100"..L_GUI_RESET_SPELLS_DESC.."|r"
	ListButton:SetScript("OnClick", function()
		if not C.options["enemycooldown"] then
			C.options["enemycooldown"] = {}
		end
		if not C.options["enemycooldown"]["spells_list"] then
			C.options["enemycooldown"]["spells_list"] = T.enemy_spells
			C.options.enemycooldown.spells_list_ver = 2
		end
		if IsControlKeyDown() then
			C.options["enemycooldown"]["spells_list"] = nil
			ns.setReloadNeeded(true)
			ListButton.tooltipText = "|cffFFD100"..REQUIRES_RELOAD.."|r"
			ListButton:SetScript("OnClick", nil)
			GameTooltip:Hide()
			SpellList:Hide()
			return
		end
		BuildSpellList(C.options["enemycooldown"]["spells_list"], true)
	end)
	tinsert(ns.buttons, ListButton)

	local function toggleListButton()
		local shown = enable:GetChecked()
		ListButton:SetEnabled(shown)
		if not T.enemy_spells then ListButton:Disable() return end
	end

	enable:HookScript("OnClick", toggleListButton)
	ListButton:HookScript("OnShow", toggleListButton)
end

-- Pulse cooldowns
do
	local parent = ShestakUIOptionsPanel.pulsecooldown

	local enable = ns.CreateCheckBox(parent, "enable")
	enable:SetPoint("TOPLEFT", parent.subText, "BOTTOMLEFT", 0, 0)

	local size = ns.CreateNumberSlider(parent, "size", nil, nil, 0, 150, 1, true)
	size:SetPoint("TOPLEFT", enable, "BOTTOMLEFT", 0, -20)

	local sound = ns.CreateCheckBox(parent, "sound")
	sound:SetPoint("TOPLEFT", size, "BOTTOMLEFT", 0, -10)

	local anim_scale = ns.CreateNumberSlider(parent, "anim_scale", nil, nil, 0, 3, 0.05, true)
	anim_scale:SetPoint("TOPLEFT", sound, "BOTTOMLEFT", 0, -20)

	local hold_time = ns.CreateNumberSlider(parent, "hold_time", nil, nil, 0, 5, 1, true)
	hold_time:SetPoint("TOPLEFT", anim_scale, "BOTTOMLEFT", 0, -20)

	local threshold = ns.CreateNumberSlider(parent, "threshold", nil, nil, 0, 15, 1, true)
	threshold:SetPoint("TOPLEFT", hold_time, "BOTTOMLEFT", 0, -20)

	-- Filtering list
	local subheader = ns.addSubCategory(parent, L.pulsecooldown_subheader_whitelist)
	subheader:SetPoint("TOPLEFT", threshold, "BOTTOMLEFT", 0, -10)

	local ListButton = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
	ListButton:SetPoint("TOPLEFT", subheader, "BOTTOMLEFT", 0, -15)
	ListButton:SetSize(100, 23)
	ListButton:SetText(ADD)
	ListButton:SetWidth(ListButton.Text:GetWidth() + 15)
	ListButton:SetScript("OnClick", function()
		if not C.options["pulsecooldown"] then
			C.options["pulsecooldown"] = {}
		end
		if not C.options["pulsecooldown"]["spells_list"] then
			C.options["pulsecooldown"]["spells_list"] = {}
		end
		BuildSpellList(C.options["pulsecooldown"]["spells_list"])
	end)
	tinsert(ns.buttons, ListButton)

	local whitelist = ns.CreateCheckBox(parent, "whitelist")
	whitelist:SetPoint("LEFT", ListButton, "RIGHT", 40, 0)
end

-- Threat
do
	local parent = ShestakUIOptionsPanel.threat

	local enable = ns.CreateCheckBox(parent, "enable", L_GUI_THREAT_ENABLE)
	enable:SetPoint("TOPLEFT", parent.subText, "BOTTOMLEFT", 0, 0)

	local height = ns.CreateNumberSlider(parent, "height", nil, nil, 0, 25, 1, true, L_GUI_THREAT_HEIGHT)
	height:SetPoint("TOPLEFT", enable, "BOTTOMLEFT", 0, -20)

	local width = ns.CreateNumberSlider(parent, "width", nil, nil, 0, 350, 1, true, L_GUI_THREAT_WIDTH)
	width:SetPoint("TOPLEFT", height, "BOTTOMLEFT", 0, -20)

	local bar_rows = ns.CreateNumberSlider(parent, "bar_rows", nil, nil, 1, 15, 1, true, L_GUI_THREAT_ROWS)
	bar_rows:SetPoint("TOPLEFT", width, "BOTTOMLEFT", 0, -20)

	local hide_solo = ns.CreateCheckBox(parent, "hide_solo", L_GUI_THREAT_HIDE_SOLO)
	hide_solo:SetPoint("TOPLEFT", bar_rows, "BOTTOMLEFT", 0, -20)
end

-- Top Panel
do
	local parent = ShestakUIOptionsPanel.toppanel

	local enable = ns.CreateCheckBox(parent, "enable", L_GUI_TOP_PANEL_ENABLE)
	enable:SetPoint("TOPLEFT", parent.subText, "BOTTOMLEFT", 0, 0)

	local mouseover = ns.CreateCheckBox(parent, "mouseover", L_GUI_TOP_PANEL_MOUSE)
	mouseover:SetPoint("TOPLEFT", enable, "BOTTOMLEFT", 0, 0)

	local height = ns.CreateNumberSlider(parent, "height", nil, nil, 40, 150, 1, true, L_GUI_TOP_PANEL_HEIGHT)
	height:SetPoint("TOPLEFT", mouseover, "BOTTOMLEFT", 0, -20)

	local width = ns.CreateNumberSlider(parent, "width", nil, nil, 100, 500, 1, true, L_GUI_TOP_PANEL_WIDTH)
	width:SetPoint("TOPLEFT", height, "BOTTOMLEFT", 0, -20)
end

-- Stats
do
	local parent = ShestakUIOptionsPanel.stats

	local clock = ns.CreateCheckBox(parent, "clock", L_GUI_STATS_CLOCK)
	clock:SetPoint("TOPLEFT", parent.subText, "BOTTOMLEFT", 0, 0)

	local latency = ns.CreateCheckBox(parent, "latency", L_GUI_STATS_LATENCY)
	latency:SetPoint("TOPLEFT", clock, "BOTTOMLEFT", 0, 0)

	local fps = ns.CreateCheckBox(parent, "fps", L_GUI_STATS_FPS)
	fps:SetPoint("TOPLEFT", latency, "BOTTOMLEFT", 0, 0)

	local friend = ns.CreateCheckBox(parent, "friend", FRIENDS)
	friend:SetPoint("TOPLEFT", fps, "BOTTOMLEFT", 0, 0)

	local guild = ns.CreateCheckBox(parent, "guild", GUILD)
	guild:SetPoint("TOPLEFT", friend, "BOTTOMLEFT", 0, 0)

	local durability = ns.CreateCheckBox(parent, "durability", DURABILITY)
	durability:SetPoint("TOPLEFT", guild, "BOTTOMLEFT", 0, 0)

	local experience = ns.CreateCheckBox(parent, "experience", L_GUI_STATS_EXPERIENCE)
	experience:SetPoint("TOPLEFT", durability, "BOTTOMLEFT", 0, 0)

	local talents = ns.CreateCheckBox(parent, "talents", SPECIALIZATION, L_GUI_STATS_TALENTS_DESC)
	talents:SetPoint("TOPLEFT", experience, "BOTTOMLEFT", 0, 0)

	local location = ns.CreateCheckBox(parent, "location", L_GUI_STATS_LOCATION)
	location:SetPoint("TOPLEFT", talents, "BOTTOMLEFT", 0, 0)

	local coords = ns.CreateCheckBox(parent, "coords", L_GUI_STATS_COORDS)
	coords:SetPoint("TOPLEFT", location, "BOTTOMLEFT", 0, 0)

	local battleground = ns.CreateCheckBox(parent, "battleground", L_GUI_STATS_BG)
	battleground:SetPoint("TOPLEFT", coords, "BOTTOMLEFT", 0, 0)

	local damage = ns.CreateCheckBox(parent, "damage", DAMAGE)
	damage:SetPoint("TOPLEFT", battleground, "BOTTOMLEFT", 0, 0)

	local bottom_line = ns.CreateCheckBox(parent, "bottom_line")
	bottom_line:SetPoint("TOPLEFT", damage, "BOTTOMLEFT", 0, 0)

	-- Currency
	local currency = ns.addSubCategory(parent, L_GUI_STATS_SUBHEADER_CURRENCY)
	currency:SetPoint("TOPLEFT", bottom_line, "BOTTOMLEFT", 0, -16)

	local currency_archaeology = ns.CreateCheckBox(parent, "currency_archaeology", L_GUI_STATS_CURRENCY_ARCHAEOLOGY)
	currency_archaeology:SetPoint("TOPLEFT", currency, "BOTTOMLEFT", 0, -8)

	local currency_cooking = ns.CreateCheckBox(parent, "currency_cooking", L_GUI_STATS_CURRENCY_COOKING)
	currency_cooking:SetPoint("TOPLEFT", currency_archaeology, "BOTTOMLEFT", 0, 0)

	local currency_raid = ns.CreateCheckBox(parent, "currency_raid", L_GUI_STATS_CURRENCY_RAID)
	currency_raid:SetPoint("TOPLEFT", currency_cooking, "BOTTOMLEFT", 0, 0)

	local currency_misc = ns.CreateCheckBox(parent, "currency_misc", CURRENCY.. " "..EXPANSION_NAME9)
	currency_misc:SetPoint("TOPLEFT", currency_raid, "BOTTOMLEFT", 0, 0)

	local ResetGoldButton = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
	ResetGoldButton:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -20, 5)
	ResetGoldButton:SetSize(100, 23)
	ResetGoldButton:SetText(RESET.." "..strlower(WORLD_QUEST_REWARD_FILTERS_GOLD))
	ResetGoldButton:SetWidth(ResetGoldButton.Text:GetWidth() + 15)
	ResetGoldButton:SetScript("OnClick", function()
		StaticPopup_Show("RESET_STATS")
	end)

	tinsert(ns.buttons, ResetGoldButton)
end

-- Trade
do
	local parent = ShestakUIOptionsPanel.trade

	local profession_tabs = ns.CreateCheckBox(parent, "profession_tabs")
	profession_tabs:SetPoint("TOPLEFT", parent.subText, "BOTTOMLEFT", 0, 0)

	local already_known = ns.CreateCheckBox(parent, "already_known")
	already_known:SetPoint("TOPLEFT", profession_tabs, "BOTTOMLEFT", 0, 0)

	local disenchanting = ns.CreateCheckBox(parent, "disenchanting")
	disenchanting:SetPoint("TOPLEFT", already_known, "BOTTOMLEFT", 0, 0)

	local enchantment_scroll = ns.CreateCheckBox(parent, "enchantment_scroll")
	enchantment_scroll:SetPoint("TOPLEFT", disenchanting, "BOTTOMLEFT", 0, 0)

	local sum_buyouts = ns.CreateCheckBox(parent, "sum_buyouts")
	sum_buyouts:SetPoint("TOPLEFT", enchantment_scroll, "BOTTOMLEFT", 0, 0)

	local archaeology = ns.CreateCheckBox(parent, "archaeology")
	archaeology:SetPoint("TOPLEFT", sum_buyouts, "BOTTOMLEFT", 0, 0)

	local merchant_itemlevel = ns.CreateCheckBox(parent, "merchant_itemlevel")
	merchant_itemlevel:SetPoint("TOPLEFT", archaeology, "BOTTOMLEFT", 0, 0)
end

-- Miscellaneous
do
	local parent = ShestakUIOptionsPanel.misc

	local raid_tools = ns.CreateCheckBox(parent, "raid_tools")
	raid_tools:SetPoint("TOPLEFT", parent.subText, "BOTTOMLEFT", 0, 0)

	local shift_marking = ns.CreateCheckBox(parent, "shift_marking")
	shift_marking:SetPoint("TOPLEFT", raid_tools, "BOTTOMLEFT", 0, 0)

	local afk_spin_camera = ns.CreateCheckBox(parent, "afk_spin_camera")
	afk_spin_camera:SetPoint("TOPLEFT", shift_marking, "BOTTOMLEFT", 0, 0)

	local quest_auto_button = ns.CreateCheckBox(parent, "quest_auto_button")
	quest_auto_button:SetPoint("TOPLEFT", afk_spin_camera, "BOTTOMLEFT", 0, 0)

	local item_level = ns.CreateCheckBox(parent, "item_level")
	item_level:SetPoint("TOPLEFT", quest_auto_button, "BOTTOMLEFT", 0, 0)

	local click_cast = ns.CreateCheckBox(parent, "click_cast")
	click_cast:SetPoint("TOPLEFT", item_level, "BOTTOMLEFT", 0, 0)

	local click_cast_filter = ns.CreateCheckBox(parent, "click_cast_filter")
	click_cast_filter:SetPoint("TOPLEFT", click_cast, "BOTTOMLEFT", 20, 0)

	click_cast.children = {click_cast_filter}

	local chars_currency = ns.CreateCheckBox(parent, "chars_currency")
	chars_currency:SetPoint("TOPLEFT", click_cast_filter, "BOTTOMLEFT", -20, 0)
end

----------------------------------------------------------------------------------------
--	Skin extra frames
----------------------------------------------------------------------------------------
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function()
	if not ShestakUI then return end
	T, C = unpack(ShestakUI)

	SpellList:StripTextures()
	SpellList:CreateBackdrop("Transparent")
	SpellList.backdrop:SetPoint("TOPLEFT", -18, 0)
	SpellList.backdrop:SetPoint("BOTTOMRIGHT", 0, 9)

	SpellListScrollFrameSpellList:StripTextures()
	SpellListScrollFrameSpellList:CreateBackdrop("Overlay")
	SpellListScrollFrameSpellList.backdrop:SetPoint("TOPLEFT", 2, 3)
	SpellListScrollFrameSpellList.backdrop:SetPoint("BOTTOMRIGHT", 2, -3)
	T.SkinCloseButton(SpellListCloseButton)

	SpellListScrollFrameSpellList.ScrollBar:SetPoint("TOPLEFT", SpellListScrollFrameSpellList, "TOPRIGHT", 9, 3)
	SpellListScrollFrameSpellList.ScrollBar:SetPoint("BOTTOMLEFT", SpellListScrollFrameSpellList, "BOTTOMRIGHT", 9, -4)
	T.SkinScrollBar(SpellListScrollFrameSpellList.ScrollBar)

	T.SkinEditBox(SpellListTextInput)
	T.SkinEditBox(SpellListTextInput2)

	ProfileList:StripTextures()
	ProfileList:CreateBackdrop("Transparent")
	ProfileList.backdrop:SetPoint("TOPLEFT", -18, 0)
	ProfileList.backdrop:SetPoint("BOTTOMRIGHT", 0, 9)
	T.SkinCloseButton(ProfileListCloseButton)

	ProfileListPanel:CreateBackdrop("Overlay")

	ShestakUIInfoFrame:SetTemplate("Overlay")

	ShestakUIProfileFrame:SetTemplate("Transparent")
	T.SkinScrollBar(ShestakUIProfileFrameScroll.ScrollBar)
	ShestakUIProfileFrameScroll:CreateBackdrop("Overlay")
	ShestakUIProfileFrameScroll.backdrop:SetPoint("TOPLEFT", -4, 4)
	ShestakUIProfileFrameScroll.backdrop:SetPoint("BOTTOMRIGHT", 4, -4)

	C_Timer.After(3, function()
		local dropdown = ShestakUIOptionsPanelgeneralchoose_profileDropDown
		if dropdown then
			T.SkinDropDownBox(dropdown)
		end
	end)
end)

----------------------------------------------------------------------------------------
--	Slash commands
----------------------------------------------------------------------------------------
do
	function SlashCmdList.CONFIG()
		if not options or not options:IsShown() then
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
			HideUIPanel(GameMenuFrame)
			options:Show()
		else
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
			options:Hide()
		end
	end
	SLASH_CONFIG1 = "/config"
	SLASH_CONFIG2 = "/cfg"
	SLASH_CONFIG3 = "/configui"

	function SlashCmdList.RESETCONFIG()
		if ShestakUIOptionsGlobal[realm][name] == true then
			StaticPopup_Show("SHESTAKUI_RESET_PERCHAR")
		else
			StaticPopup_Show("SHESTAKUI_RESET")
		end
	end
	SLASH_RESETCONFIG1 = "/resetconfig"
end

----------------------------------------------------------------------------------------
--	Button in GameMenuButton frame
----------------------------------------------------------------------------------------
local menuButton = CreateFrame("Button", "GameMenuButtonSettingsUI", GameMenuFrame, "GameMenuButtonTemplate")
menuButton:SetText("ShestakUI")
menuButton:SetPoint("TOP", GetLocale() ~= "koKR" and "GameMenuButtonAddons" or "GameMenuButtonRatings", "BOTTOM", 0, -1)

GameMenuFrame:HookScript("OnShow", function(self)
	self:SetHeight(self:GetHeight() + menuButton:GetHeight())
	GameMenuButtonLogout:SetPoint("TOP", menuButton, "BOTTOM", 0, -16)
end)

menuButton:SetScript("OnClick", function()
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
	HideUIPanel(GameMenuFrame)
	options:Show()
end)
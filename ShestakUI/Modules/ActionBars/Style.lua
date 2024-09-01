local T, C, L, _ = unpack(ShestakUI)
if C.actionbar.enable ~= true then return end

----------------------------------------------------------------------------------------
--	Style ActionBars buttons(by Tukz)
----------------------------------------------------------------------------------------
local function StyleNormalButton(button, size)
	if not button.isSkinned then
		local name = button:GetName()
		local icon = _G[name.."Icon"]
		local count = _G[name.."Count"]
		local flash = _G[name.."Flash"]
		local hotkey = _G[name.."HotKey"]
		local border = button.Border or _G[name.."Border"]
		local btname = _G[name.."Name"]
		local normal = button.NormalTexture or _G[name.."NormalTexture"]
		local normal2 = button:GetNormalTexture()
		local float = _G[name.."FloatingBG"]
		local highlight = button.SpellHighlightTexture
		local isExtraAction = name:match("ExtraAction")
		local isFlyout = name:match("Flyout")
		local flyoutBorder = _G[name.."FlyoutBorder"]
		local flyoutBorderShadow = _G[name.."FlyoutBorderShadow"]
		local autocast = button.AutoCastOverlay
		local shine = _G[name.."Shine"]
		local spellAlert = button.SpellActivationAlert

		if button.IconMask then
			button.IconMask:Hide()
		end

		if button.SlotArt then
			button.SlotArt:SetAlpha(0)
		end

		if button.RightDivider then
			button.RightDivider:Kill()
		end

		if button.SlotBackground then
			button.SlotBackground:SetAlpha(0)
		end

		if button.NewActionTexture then
			button.NewActionTexture:SetAlpha(0)
		end

		if normal then
			normal:SetTexture()
			normal:Hide()
			normal:SetAlpha(0)
		end

		if normal2 then
			normal2:SetTexture()
			normal2:Hide()
			normal2:SetAlpha(0)
		end

		flash:SetTexture("")
		button:SetNormalTexture(0)

		if float then
			float:SetTexture("")
		end

		if border then
			border:SetTexture("")
		end

		if not isExtraAction then
			count:ClearAllPoints()
			count:SetPoint("BOTTOMRIGHT", 0, 2)
			count:SetFont(C.font.action_bars_font, C.font.action_bars_font_size, C.font.action_bars_font_style)
			count:SetShadowOffset(C.font.action_bars_font_shadow and 1 or 0, C.font.action_bars_font_shadow and -1 or 0)
			count:SetHeight(C.font.action_bars_font_size)
		end

		if btname then
			if C.actionbar.macro == true then
				btname:ClearAllPoints()
				btname:SetPoint("BOTTOM", 0, 1)
				btname:SetFont(C.font.action_bars_font, C.font.action_bars_font_size, C.font.action_bars_font_style)
				btname:SetShadowOffset(C.font.action_bars_font_shadow and 1 or 0, C.font.action_bars_font_shadow and -1 or 0)
				btname:SetWidth(C.actionbar.button_size - 1)
				btname:SetHeight(C.font.action_bars_font_size)
			else
				btname:Kill()
			end
		end

		if C.actionbar.hotkey == true then
			hotkey:ClearAllPoints()
			hotkey:SetPoint("TOPRIGHT", 0, -1)
			hotkey:SetFont(C.font.action_bars_font, C.font.action_bars_font_size, C.font.action_bars_font_style)
			hotkey:SetShadowOffset(C.font.action_bars_font_shadow and 1 or 0, C.font.action_bars_font_shadow and -1 or 0)
			hotkey:SetWidth(C.actionbar.button_size - 1)
			hotkey:SetHeight(C.font.action_bars_font_size)
			hotkey:SetParent(button)
			hooksecurefunc(hotkey, "SetVertexColor", function(_, _, g)
				if g < 0.8 then
					hotkey:SetVertexColor(ACTIONBAR_HOTKEY_FONT_COLOR:GetRGB())
				end
			end)
		else
			hotkey:Kill()
		end

		if not isFlyout and not isExtraAction then
			button:SetSize(size or C.actionbar.button_size, size or C.actionbar.button_size)

			-- Dragonflight - Hide profession quality icons
			if button.ProfessionQualityOverlayFrame then
				button.ProfessionQualityOverlayFrame:SetAlpha(0)
			end
			hooksecurefunc(button, "UpdateProfessionQuality", function(self)
				if self.ProfessionQualityOverlayFrame then
					self.ProfessionQualityOverlayFrame:SetAlpha(0)
				end
			end)
		end
		button:SetTemplate("Transparent")
		if C.actionbar.classcolor_border == true then
			button:SetBackdropBorderColor(unpack(C.media.classborder_color))
		end

		icon:CropIcon()
		icon:SetDrawLayer("BACKGROUND", 7)

		if normal then
			normal:ClearAllPoints()
			normal:SetPoint("TOPLEFT")
			normal:SetPoint("BOTTOMRIGHT")
		end

		if highlight then
			highlight:ClearAllPoints()
			highlight:SetPoint("TOPLEFT", -4, 4)
			highlight:SetPoint("BOTTOMRIGHT", 4, -4)
		end

		button.oborder:SetFrameLevel(button:GetFrameLevel())
		button.iborder:SetFrameLevel(button:GetFrameLevel())

		if button.QuickKeybindHighlightTexture then
			button.QuickKeybindHighlightTexture:SetScale(0.0001)
		end

		if button.SpellCastAnimFrame then
			button.SpellCastAnimFrame:SetScale(0.0001) -- 10.1.5 cast texture
		end

		if button.InterruptDisplay then
			button.InterruptDisplay:SetScale(0.0001) -- 10.1.5 interrupt texture
		end

		if button.CooldownFlash.Flipbook then
			-- button.CooldownFlash.Flipbook:Kill() -- 10.1.5 new GCD flash
		end

		if button.TargetReticleAnimFrame then
			button.TargetReticleAnimFrame:SetScale(0.0001)
		end

		if flyoutBorder then
			flyoutBorder:SetTexture("")
		end
		if flyoutBorderShadow then
			flyoutBorderShadow:SetTexture("")
		end

		if autocast then
			autocast:SetSize(C.actionbar.button_size * 1.05, C.actionbar.button_size * 1.05)
		end

		if shine then
			shine:SetSize(C.actionbar.button_size, C.actionbar.button_size)
		end

		if spellAlert then
			spellAlert:SetSize((size or C.actionbar.button_size) * 1.4, (size or C.actionbar.button_size) * 1.4)
			ActionButton_HideOverlayGlow(button)
		end

		button:StyleButton()

		button.isSkinned = true
	end
end

local function StyleSmallButton(button, name, isPet)
	if not button.isSkinned then
		local normal = _G[name.."NormalTexture"]
		local flash = _G[name.."Flash"]
		local hotkey = _G[name.."HotKey"]
		local icon = _G[name.."Icon"]

		button:SetNormalTexture(0)

		if normal then
			normal:SetAlpha(0)
		end

		if button.IconMask then
			button.IconMask:Hide()
		end

		hooksecurefunc(button, "SetNormalTexture", function(self, texture)
			if texture and texture ~= "" then
				self:SetNormalTexture(0)
			end
		end)

		flash:SetColorTexture(0.8, 0.8, 0.8, 0.5)
		flash:SetPoint("TOPLEFT", button, 2, -2)
		flash:SetPoint("BOTTOMRIGHT", button, -2, 2)

		if C.actionbar.hotkey == true then
			hotkey:ClearAllPoints()
			hotkey:SetPoint("TOPRIGHT", 0, 0)
			hotkey:SetFont(C.font.action_bars_font, C.font.action_bars_font_size, C.font.action_bars_font_style)
			hotkey:SetShadowOffset(C.font.action_bars_font_shadow and 1 or 0, C.font.action_bars_font_shadow and -1 or 0)
			hotkey:SetWidth(C.actionbar.button_size - 1)
		else
			hotkey:Kill()
		end

		button:SetSize(C.actionbar.button_size, C.actionbar.button_size)
		button:SetTemplate("Transparent")
		if C.actionbar.classcolor_border == true then
			button:SetBackdropBorderColor(unpack(C.media.classborder_color))
		end

		icon:CropIcon()
		icon:SetDrawLayer("BACKGROUND", 7)

		if isPet then
			local autocast = button.AutoCastOverlay
			autocast:SetSize(C.actionbar.button_size * 1.05, C.actionbar.button_size * 1.05)
			autocast:SetPoint("CENTER", 0, 0)
		end

		if normal then
			normal:ClearAllPoints()
			normal:SetPoint("TOPLEFT")
			normal:SetPoint("BOTTOMRIGHT")
		end

		if button.QuickKeybindHighlightTexture then
			button.QuickKeybindHighlightTexture:SetScale(0.0001)
		end

		button:StyleButton()

		button.isSkinned = true
	end
end

function T.StyleShift()
	for i = 1, 10 do
		local name = "StanceButton"..i
		local button = _G[name]
		StyleSmallButton(button, name)
	end
end

function T.StylePet()
	for i = 1, NUM_PET_ACTION_SLOTS do
		local name = "PetActionButton"..i
		local button = _G[name]
		StyleSmallButton(button, name, true)
	end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", function()
	for i = 1, 12 do
		StyleNormalButton(_G["ActionButton"..i], C.actionbar.editor and C.actionbar.bar1_size)
		StyleNormalButton(_G["MultiBarBottomLeftButton"..i], C.actionbar.editor and C.actionbar.bar2_size)
		StyleNormalButton(_G["MultiBarLeftButton"..i], C.actionbar.editor and C.actionbar.bar3_size)
		StyleNormalButton(_G["MultiBarRightButton"..i], C.actionbar.editor and C.actionbar.bar4_size)
		StyleNormalButton(_G["MultiBarBottomRightButton"..i], C.actionbar.editor and C.actionbar.bar5_size)
		StyleNormalButton(_G["MultiBar5Button"..i], C.actionbar.editor and C.actionbar.bar6_size)
		StyleNormalButton(_G["MultiBar6Button"..i], C.actionbar.bar7_size)
		StyleNormalButton(_G["MultiBar7Button"..i], C.actionbar.bar8_size)
	end

	StyleNormalButton(ExtraActionButton1)
end)

local function SetupFlyoutButton(button, self)
	if button:GetHeight() ~= C.actionbar.button_size and not InCombatLockdown() then
		button:SetSize(C.actionbar.button_size, C.actionbar.button_size)
	end

	if not button.IsSkinned then
		StyleNormalButton(button)

		if C.actionbar.rightbars_mouseover == true then
			SpellFlyout:HookScript("OnEnter", function() RightBarMouseOver(1) end)
			SpellFlyout:HookScript("OnLeave", function() RightBarMouseOver(0) end)
			button:HookScript("OnEnter", function() RightBarMouseOver(1) end)
			button:HookScript("OnLeave", function() RightBarMouseOver(0) end)
		end

		if C.actionbar.bottombars_mouseover == true then
			SpellFlyout:HookScript("OnEnter", function() BottomBarMouseOver(1) end)
			SpellFlyout:HookScript("OnLeave", function() BottomBarMouseOver(0) end)
			button:HookScript("OnEnter", function() BottomBarMouseOver(1) end)
			button:HookScript("OnLeave", function() BottomBarMouseOver(0) end)
		end
		button.IsSkinned = true
	end
end

local function StyleFlyoutButton(self)
	local button, i = _G["SpellFlyoutButton1"], 1
	while button do
		SetupFlyoutButton(button, self)

		i = i + 1
		button = _G["SpellFlyoutButton"..i]
	end
end

SpellFlyout:HookScript("OnShow", StyleFlyoutButton)
SpellFlyout.Background:Hide()

if C.actionbar.hotkey == true then
	local gsub = string.gsub
	local function UpdateHotkey(self, pass)
		local hotkey = _G[self:GetName().."HotKey"]
		local text = hotkey:GetText()
		if not text then return end

		text = gsub(text, "(s%-)", "S")
		text = gsub(text, "(a%-)", "A")
		text = gsub(text, "(а%-)", "A") -- fix ruRU
		text = gsub(text, "(c%-)", "C")
		text = gsub(text, "(Mouse Button )", "M")
		text = gsub(text, "(Кнопка мыши )", "M")
		text = gsub(text, KEY_BUTTON3, "M3")
		text = gsub(text, KEY_PAGEUP, "PU")
		text = gsub(text, KEY_PAGEDOWN, "PD")
		text = gsub(text, KEY_SPACE, "SpB")
		text = gsub(text, KEY_INSERT, "Ins")
		text = gsub(text, KEY_HOME, "Hm")
		text = gsub(text, KEY_DELETE, "Del")
		text = gsub(text, KEY_NUMPADDECIMAL, "Nu.")
		text = gsub(text, KEY_NUMPADDIVIDE, "Nu/")
		text = gsub(text, KEY_NUMPADMINUS, "Nu-")
		text = gsub(text, KEY_NUMPADMULTIPLY, "Nu*")
		text = gsub(text, KEY_NUMPADPLUS, "Nu+")
		text = gsub(text, KEY_NUMLOCK, "NuL")
		text = gsub(text, KEY_MOUSEWHEELDOWN, "MWD")
		text = gsub(text, KEY_MOUSEWHEELUP, "MWU")

		if not pass then
			hotkey:ClearAllPoints()
			hotkey:SetPoint("TOPRIGHT", 0, -1)
			hotkey:SetWidth(self:GetWidth() - 1)
			hotkey:SetHeight(C.font.action_bars_font_size)
		end

		if hotkey:GetText() == _G["RANGE_INDICATOR"] then
			hotkey:SetText("")
		else
			hotkey:SetText(text)
		end
	end

	local frame = CreateFrame("Frame")
	frame:RegisterEvent("UPDATE_BINDINGS")
	frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	frame:SetScript("OnEvent", function()
		for i = 1, 12 do
			UpdateHotkey(_G["ActionButton"..i])
			UpdateHotkey(_G["MultiBarBottomLeftButton"..i])
			UpdateHotkey(_G["MultiBarBottomRightButton"..i])
			UpdateHotkey(_G["MultiBarLeftButton"..i])
			UpdateHotkey(_G["MultiBarRightButton"..i])
			UpdateHotkey(_G["MultiBar5Button"..i])
			UpdateHotkey(_G["MultiBar6Button"..i])
			UpdateHotkey(_G["MultiBar7Button"..i])
		end
		for i = 1, 10 do
			UpdateHotkey(_G["StanceButton"..i], true)
			UpdateHotkey(_G["PetActionButton"..i], true)
		end
		UpdateHotkey(ExtraActionButton1, true)
	end)
end

if C.actionbar.hide_highlight == true then
	local function HideHighlightButton(self)
		if self.overlay then
			self.overlay:Hide()
			ActionButton_HideOverlayGlow(self)
		end
	end

	hooksecurefunc("ActionButton_ShowOverlayGlow", HideHighlightButton)
else
	hooksecurefunc("ActionButton_ShowOverlayGlow", function(button)
		-- Make proc glow better
		button.SpellActivationAlert.ProcStartFlipbook:ClearAllPoints()
		button.SpellActivationAlert.ProcStartFlipbook:SetPoint("TOPLEFT", button, -C.actionbar.button_size * 0.9, C.actionbar.button_size * 0.9)
		button.SpellActivationAlert.ProcStartFlipbook:SetPoint("BOTTOMRIGHT", button, C.actionbar.button_size * 0.9, -C.actionbar.button_size * 0.9)
		button.SpellActivationAlert.ProcLoop:Play()
	end)
end
local T, C, L = unpack(ShestakUI)

----------------------------------------------------------------------------------------
--	Temporary stuff
----------------------------------------------------------------------------------------
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function()
	if not C_AddOns.IsAddOnLoaded("SimpleAssistedCombatIcon") then return end

	AssistedCombatIconFrame.Icon:SkinIcon()
	AssistedCombatIconFrame.Cooldown:SetDrawEdge(false)

	AssistedCombatIconFrame.db.border.thickness = 0 -- remove border
	AssistedCombatIconFrame:ApplyOptions()

	hooksecurefunc(AssistedCombatIconFrame, "Update", function()
		local keybind = AssistedCombatIconFrame.Keybind
		keybind:SetFont(C.font.stylization_font, C.font.stylization_font_size, C.font.stylization_font_style)
		keybind:SetShadowOffset(C.font.stylization_font_shadow and 1 or 0, C.font.stylization_font_shadow and -1 or 0)

		local text = keybind:GetText()
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
		keybind:SetText(text)
	end)
end)
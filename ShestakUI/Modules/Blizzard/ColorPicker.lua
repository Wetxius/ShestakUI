local T, C, L = unpack(ShestakUI)
if C.general.color_picker ~= true then return end

----------------------------------------------------------------------------------------
--	Improved ColorPicker(ColorPickerPlus by Jaslm)
----------------------------------------------------------------------------------------
local colorBuffer = {}
local editingText

local delayFunc
local function delayCall()
	if delayFunc then
		delayFunc()
		delayFunc = nil
	end
end

local function alphaValue(num)
	return num and floor((num * 100) + .05) or 0
end

local function UpdateAlphaText(alpha)
	if not alpha then
		alpha = alphaValue(ColorPickerFrame:GetColorAlpha())
	end

	_G.ColorPPBoxA:SetText(alpha)
end

local last = { r = 0, g = 0, b = 0, a = 0 }
local function onAlphaValueChanged(_, value)
	local alpha = alphaValue(value)
	if last.a ~= alpha then
		last.a = alpha
	else -- alpha matched so we don't need to update
		return
	end

	UpdateAlphaText(alpha)

	if not _G.ColorPickerFrame:IsVisible() then
		delayCall()
	else
		local opacityFunc = ColorPickerFrame.opacityFunc
		if delayFunc and (delayFunc ~= opacityFunc) then
			delayFunc = opacityFunc
		elseif not delayFunc then
			delayFunc = opacityFunc
			C_Timer.After(0.15, function()
				delayCall()
			end)
		end
	end
end

local function UpdateAlpha(tbox)
	local num = tbox:GetNumber()
	if num > 100 then
		tbox:SetText(100)
		num = 100
	end

	local value = num * 0.01
	ColorPickerFrame.Content.ColorPicker:SetColorAlpha(value)
	onAlphaValueChanged(nil, value)
end

local function expandFromThree(r, g, b)
	return strjoin("",r,r,g,g,b,b)
end

local function extendToSix(str)
	for _=1, 6-strlen(str) do str=str..0 end
	return str
end

local function GetHexColor(box)
	local rgb, rgbSize = box:GetText(), box:GetNumLetters()
	if rgbSize == 3 then
		rgb = gsub(rgb, "(%x)(%x)(%x)$", expandFromThree)
	elseif rgbSize < 6 then
		rgb = gsub(rgb, "(.+)$", extendToSix)
	end

	local r, g, b = tonumber(strsub(rgb,0,2),16) or 0, tonumber(strsub(rgb,3,4),16) or 0, tonumber(strsub(rgb,5,6),16) or 0

	return r/255, g/255, b/255
end

local function UpdateColorTexts(r, g, b, box)
	if not (r and g and b) then
		r, g, b = _G.ColorPickerFrame:GetColorRGB()

		if box then
			if box == ColorPickerFrame.Content.HexBox then
				r, g, b = GetHexColor(box)
			else
				local num = box:GetNumber()
				if num > 255 then
					num = 255
				end

				local c = num/255
				if box == _G.ColorPPBoxR then
					r = c
				elseif box == _G.ColorPPBoxG then
					g = c
				elseif box == _G.ColorPPBoxB then
					b = c
				end
			end
		end
	end

	-- we want those /255 values
	r, g, b = T.Round(r*255), T.Round(g*255), T.Round(b*255)

	ColorPickerFrame.Content.HexBox:SetText(format("%.2x%.2x%.2x", r, g, b))
	_G.ColorPPBoxR:SetText(r)
	_G.ColorPPBoxG:SetText(g)
	_G.ColorPPBoxB:SetText(b)
end

local function UpdateColor()
	local r, g, b = GetHexColor(ColorPickerFrame.Content.HexBox)
	ColorPickerFrame.Content.ColorPicker:SetColorRGB(r, g, b)
	ColorPickerFrame.Content.ColorSwatchCurrent:SetColorTexture(r, g, b)
end

local function onColorSelect(frame, r, g, b)
	if frame.noColorCallback then
		return -- prevent error from E:GrabColorPickerValues, better note in that function
	elseif r ~= last.r or g ~= last.g or b ~= last.b then
		last.r, last.g, last.b = r, g, b
	else -- colors match so we don"t need to update, most likely mouse is held down
		return
	end

	ColorPickerFrame.Content.ColorSwatchCurrent:SetColorTexture(r, g, b)
	UpdateColorTexts(r, g, b)
	UpdateAlphaText()

	if not frame:IsVisible() then
		delayCall()
	elseif not delayFunc then
		delayFunc = ColorPickerFrame.swatchFunc

		if delayFunc then
			C_Timer.After(0.15, function()
				delayCall()
			end)
		end
	end
end

local load = CreateFrame("Frame")
load:RegisterEvent("PLAYER_ENTERING_WORLD")
load:SetScript("OnEvent", function(self)
	self:UnregisterAllEvents()

	if C_AddOns.IsAddOnLoaded("ColorPickerPlus") then return end

	ColorPickerFrame:HookScript("OnShow", function(frame)
		-- Get color that will be replaced
		local r, g, b = frame:GetColorRGB()
		frame.Content.ColorSwatchOriginal:SetColorTexture(r, g, b)

		-- Show/hide the alpha box
		if frame.hasOpacity then
			ColorPPBoxA:Show()
			ColorPPBoxLabelA:Show()
			frame.Content.HexBox:SetScript("OnTabPressed", function() ColorPPBoxA:SetFocus() end)
			UpdateAlphaText()
		else
			ColorPPBoxA:Hide()
			ColorPPBoxLabelA:Hide()
			frame.Content.HexBox:SetScript("OnTabPressed", function() ColorPPBoxR:SetFocus() end)
		end

		UpdateColorTexts(nil, nil, nil, ColorPickerFrame.Content.HexBox)
	end)

	ColorPickerFrame.Content.ColorPicker:SetScript("OnColorSelect", onColorSelect)

	-- Make the Color Picker dialog a bit taller, to make room for edit boxes
	ColorPickerFrame:SetHeight(ColorPickerFrame:GetHeight() + 40)

	ColorPickerFrame.Content.ColorSwatchOriginal:ClearAllPoints()
	ColorPickerFrame.Content.ColorSwatchOriginal:SetPoint("TOPLEFT", ColorPickerFrame.Content.ColorSwatchCurrent, "BOTTOMLEFT", 0, -2)

	ColorPickerFrame.Content.HexBox:SetSize(78, 18)

	-- Add Color Swatch for the copied color
	local t = ColorPickerFrame:CreateTexture("ColorPPCopyColorSwatch")
	local w, h = ColorPickerFrame.Content.ColorSwatchCurrent:GetSize()
	t:SetSize(w, h)
	t:SetColorTexture(0, 0, 0)
	t:Hide()
	t:SetPoint("LEFT", ColorPickerFrame.Content.ColorSwatchCurrent, "RIGHT", 2, -13)

	-- Add copy button to the ColorPickerFrame
	local b = CreateFrame("Button", "ColorPPCopy", ColorPickerFrame, "UIPanelButtonTemplate")
	b:SkinButton()
	b:SetText(CALENDAR_COPY_EVENT)
	b:SetWidth(85)
	b:SetHeight(22)
	b:SetPoint("TOPLEFT", ColorPickerFrame.Content.ColorSwatchOriginal, "BOTTOMLEFT", -6, -5)

	-- Copy color into buffer on button click
	b:SetScript("OnClick", function()
		-- Copy current dialog colors into buffer
		colorBuffer.r, colorBuffer.g, colorBuffer.b = ColorPickerFrame:GetColorRGB()

		-- Enable Paste button and display copied color into swatch
		ColorPPPaste:Enable()
		ColorPPCopyColorSwatch:SetColorTexture(colorBuffer.r, colorBuffer.g, colorBuffer.b)
		ColorPPCopyColorSwatch:Show()

		if ColorPickerFrame.hasOpacity then
			colorBuffer.a = ColorPickerFrame:GetColorAlpha()
		else
			colorBuffer.a = nil
		end
	end)

	local alphaUpdater = CreateFrame('Frame', '$parent_AlphaUpdater', ColorPickerFrame)
	alphaUpdater:SetScript('OnUpdate', function()
		if ColorPickerFrame.Content.ColorPicker.Alpha:IsMouseOver() then
			onAlphaValueChanged(nil, ColorPickerFrame:GetColorAlpha())
		end
	end)

	-- Paste button
	b = CreateFrame("Button", "ColorPPPaste", ColorPickerFrame, "UIPanelButtonTemplate")
	b:SetText(CALENDAR_PASTE_EVENT)
	b:SkinButton()
	b:SetWidth(85)
	b:SetHeight(22)
	b:SetPoint("TOPLEFT", "ColorPPCopy", "BOTTOMLEFT", 0, -7)
	b:Disable()

	-- Paste color on button click, updating frame components
	b:SetScript("OnClick", function()
		ColorPickerFrame.Content.ColorPicker:SetColorRGB(colorBuffer.r, colorBuffer.g, colorBuffer.b)
		ColorPickerFrame.Content.ColorSwatchCurrent:SetColorTexture(colorBuffer.r, colorBuffer.g, colorBuffer.b)

		if ColorPickerFrame.hasOpacity and colorBuffer.a then -- color copied had an alpha value
			ColorPickerFrame.Content.ColorPicker:SetColorAlpha(colorBuffer.a)
		end
	end)

	-- ClassColor button
	b = CreateFrame("Button", "ColorPPClass", ColorPickerFrame, "UIPanelButtonTemplate")
	b:SkinButton()
	b:SetText(CLASS)
	b:SetWidth(b:GetWidth() + 10)
	b:SetHeight(22)
	b:SetPoint("TOPRIGHT", "ColorPPPaste", "BOTTOMRIGHT", 0, -7)

	b:SetScript("OnClick", function()
		ColorPickerFrame.Content.ColorPicker:SetColorRGB(T.color.r, T.color.g, T.color.b)
		ColorPickerFrame.Content.ColorSwatchCurrent:SetColorTexture(T.color.r, T.color.g, T.color.b)
		if ColorPickerFrame.hasOpacity then
			ColorPickerFrame.Content.ColorPicker:SetColorAlpha(0)
		end
	end)

	-- Set up edit box frames and interior label and text areas
	local boxes = {"R", "G", "B", "A"}
	for i = 1, table.getn(boxes) do
		local rgb = boxes[i]
		local box = CreateFrame("EditBox", "ColorPPBox"..rgb, ColorPickerFrame, "InputBoxTemplate")
		T.SkinEditBox(box)
		box:SetID(i)
		box:SetFrameStrata("DIALOG")
		box:SetAutoFocus(false)
		box:SetTextInsets(0, 7, 1, 0)
		box:SetJustifyH("RIGHT")
		box:SetHeight(18)
		box:SetMaxLetters(3)
		box:SetWidth(40)
		box:SetNumeric(true)
		box:SetPoint("TOP", ColorPickerFrame.Content.ColorSwatchOriginal, "BOTTOM", 0, -99)

		-- Label
		local label = box:CreateFontString("ColorPPBoxLabel"..rgb, "ARTWORK", "GameFontNormal")
		label:SetTextColor(1, 1, 1)
		label:SetPoint("RIGHT", "ColorPPBox"..rgb, "LEFT", -4, 0)
		label:SetText(rgb)

		-- Set up scripts to handle event appropriately
		if i == 4 then
			box:SetScript("OnKeyUp", function(eb, key)
				local copyPaste = IsControlKeyDown() and key == "V"
				if key == "BACKSPACE" or copyPaste or (strlen(key) == 1 and not IsModifierKeyDown()) then
					UpdateAlpha(eb)
				elseif key == "ENTER" or key == "ESCAPE" then
					eb:ClearFocus()
					UpdateAlpha(eb)
				end
			end)
		else
			-- set up scripts to handle event appropriately
			box:SetScript("OnKeyUp", function(eb, key)
				local copyPaste = IsControlKeyDown() and key == "V"
				if key == "BACKSPACE" or copyPaste or (strlen(key) == 1 and not IsModifierKeyDown()) then
					UpdateColorTexts(nil, nil, nil, eb)
					UpdateColor()
				elseif key == "ENTER" or key == "ESCAPE" then
					eb:ClearFocus()
					UpdateColorTexts(nil, nil, nil, eb)
					UpdateColor()
				end
			end)
		end

		box:SetScript("OnEditFocusGained", function(self) self:SetCursorPosition(0) self:HighlightText() end)
		box:SetScript("OnEditFocusLost", function(self) self:HighlightText(0, 0) end)
		box:Show()
	end

	-- Finish up with placement
	ColorPPBoxR:SetPoint("LEFT", ColorPickerFrame.Content, 25, 0)
	ColorPPBoxG:SetPoint("LEFT", "ColorPPBoxR", "RIGHT", 22, 0)
	ColorPPBoxB:SetPoint("LEFT", "ColorPPBoxG", "RIGHT", 22, 0)
	ColorPPBoxA:SetPoint("LEFT", "ColorPPBoxB", "RIGHT", 22, 0)

	-- Define the order of tab cursor movement
	ColorPPBoxR:SetScript("OnTabPressed", function() ColorPPBoxG:SetFocus() end)
	ColorPPBoxG:SetScript("OnTabPressed", function() ColorPPBoxB:SetFocus() end)
	ColorPPBoxB:SetScript("OnTabPressed", function() ColorPickerFrame.Content.HexBox:SetFocus() end)
	ColorPPBoxA:SetScript("OnTabPressed", function() ColorPPBoxR:SetFocus() end)

	-- Make the color picker movable
	local mover = CreateFrame("Frame", nil, ColorPickerFrame)
	mover:SetPoint("TOPLEFT", ColorPickerFrame, "TOPLEFT", 0, 0)
	mover:SetPoint("BOTTOMRIGHT", ColorPickerFrame, "TOPRIGHT", 0, -15)
	mover:EnableMouse(true)
	mover:SetScript("OnMouseDown", function() ColorPickerFrame:StartMoving() end)
	mover:SetScript("OnMouseUp", function() ColorPickerFrame:StopMovingOrSizing() end)
	ColorPickerFrame:EnableKeyboard(false)
end)
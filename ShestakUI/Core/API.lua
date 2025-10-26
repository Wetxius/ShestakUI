﻿local T, C, L = unpack(ShestakUI)

local backdropr, backdropg, backdropb, backdropa = unpack(C.media.backdrop_color)
local borderr, borderg, borderb, bordera = unpack(C.media.border_color)

local Mult = T.mult
if T.screenHeight > 1200 then
	Mult = T.Scale(1)
end

----------------------------------------------------------------------------------------
--	Position functions
----------------------------------------------------------------------------------------
local function SetOutside(obj, anchor, xOffset, yOffset)
	xOffset = xOffset or 2
	yOffset = yOffset or 2
	anchor = anchor or obj:GetParent()

	if obj:GetPoint() then
		obj:ClearAllPoints()
	end

	obj:SetPoint("TOPLEFT", anchor, "TOPLEFT", -xOffset, yOffset)
	obj:SetPoint("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", xOffset, -yOffset)
end

local function SetInside(obj, anchor, xOffset, yOffset)
	xOffset = xOffset or 2
	yOffset = yOffset or 2
	anchor = anchor or obj:GetParent()

	if obj:GetPoint() then
		obj:ClearAllPoints()
	end

	obj:SetPoint("TOPLEFT", anchor, "TOPLEFT", xOffset, -yOffset)
	obj:SetPoint("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", -xOffset, yOffset)
end

local function SetMovePoint(self, x, y, point, anchor, attachTo)
	local old_point, old_anchor, old_attachTo, old_x, old_y = self:GetPoint()
	if point or attachTo then
		self:ClearAllPoints()
	end

	self:SetPoint(point or old_point, anchor or old_anchor, attachTo or old_attachTo, x or old_x, y or old_y)
end

----------------------------------------------------------------------------------------
--	Template functions
----------------------------------------------------------------------------------------
local function CreateOverlay(f)
	if f.overlay then return end

	local overlay = f:CreateTexture("$parentOverlay", "BORDER")
	overlay:SetInside()
	overlay:SetTexture(C.media.blank)
	overlay:SetVertexColor(0.1, 0.1, 0.1, 1)
	f.overlay = overlay
end

local function CreateBorder(f, i, o)
	if i then
		if f.iborder then return end
		local border = CreateFrame("Frame", "$parentInnerBorder", f, "BackdropTemplate")
		border:SetPoint("TOPLEFT", Mult, -Mult)
		border:SetPoint("BOTTOMRIGHT", -Mult, Mult)
		border:SetBackdrop({
			edgeFile = C.media.blank, edgeSize = Mult,
			insets = {left = Mult, right = Mult, top = Mult, bottom = Mult}
		})
		border:SetBackdropBorderColor(unpack(C.media.backdrop_color))
		f.iborder = border
	end

	if o then
		if f.oborder then return end
		local border = CreateFrame("Frame", "$parentOuterBorder", f, "BackdropTemplate")
		border:SetPoint("TOPLEFT", -Mult, Mult)
		border:SetPoint("BOTTOMRIGHT", Mult, -Mult)
		border:SetFrameLevel(f:GetFrameLevel() + 1)
		border:SetBackdrop({
			edgeFile = C.media.blank, edgeSize = Mult,
			insets = {left = Mult, right = Mult, top = Mult, bottom = Mult}
		})
		border:SetBackdropBorderColor(unpack(C.media.backdrop_color))
		f.oborder = border
	end
end

local function GetTemplate(t)
	if t == "ClassColor" then
		borderr, borderg, borderb, bordera = unpack(C.media.classborder_color)
		backdropr, backdropg, backdropb, backdropa = unpack(C.media.backdrop_color)
	else
		borderr, borderg, borderb, bordera = unpack(C.media.border_color)
		backdropr, backdropg, backdropb, backdropa = unpack(C.media.backdrop_color)
	end
end

local function SetTemplate(f, t)
	Mixin(f, BackdropTemplateMixin) -- 9.0 to set backdrop
	GetTemplate(t)

	f:SetBackdrop({
		bgFile = C.media.blank, edgeFile = C.media.blank, edgeSize = Mult,
		insets = {left = -Mult, right = -Mult, top = -Mult, bottom = -Mult}
	})

	if t == "Transparent" then
		backdropa = C.media.backdrop_alpha
		f:CreateBorder(true, true)
	elseif t == "Overlay" then
		backdropa = 1
		f:CreateOverlay()
	else
		backdropa = C.media.backdrop_color[4]
	end

	f:SetBackdropColor(backdropr, backdropg, backdropb, backdropa)
	f:SetBackdropBorderColor(borderr, borderg, borderb, bordera)
end

local function CreatePanel(f, t, w, h, a1, p, a2, x, y)
	Mixin(f, BackdropTemplateMixin) -- 9.0 to set backdrop
	GetTemplate(t)

	f:SetWidth(w)
	f:SetHeight(h)
	f:SetFrameLevel(3)
	f:SetFrameStrata("BACKGROUND")
	f:SetPoint(a1, p, a2, x, y)
	f:SetBackdrop({
		bgFile = C.media.blank, edgeFile = C.media.blank, edgeSize = Mult,
		insets = {left = -Mult, right = -Mult, top = -Mult, bottom = -Mult}
	})

	if t == "Transparent" then
		backdropa = C.media.backdrop_alpha
		f:CreateBorder(true, true)
	elseif t == "Overlay" then
		backdropa = 1
		f:CreateOverlay()
	elseif t == "Invisible" then
		backdropa = 0
		bordera = 0
	else
		backdropa = C.media.backdrop_color[4]
	end

	f:SetBackdropColor(backdropr, backdropg, backdropb, backdropa)
	f:SetBackdropBorderColor(borderr, borderg, borderb, bordera)
end

local function CreateBackdrop(f, t)
	local f = (f.IsObjectType and f:IsObjectType("Texture") and f:GetParent()) or f
	if f.backdrop then return end
	if not t then t = "Default" end

	local b = CreateFrame("Frame", "$parentBackdrop", f)
	b:SetOutside()
	b:SetTemplate(t)

	if f:GetFrameLevel() - 1 >= 0 then
		b:SetFrameLevel(f:GetFrameLevel() - 1)
	else
		b:SetFrameLevel(0)
	end

	f.backdrop = b
end

local StripTexturesBlizzFrames = {
	"Inset",
	"inset",
	"InsetFrame",
	"LeftInset",
	"RightInset",
	"NineSlice",
	"BG",
	"Bg",
	"border",
	"Border",
	"BorderFrame",
	"bottomInset",
	"BottomInset",
	"bgLeft",
	"bgRight",
	"FilligreeOverlay",
	"PortraitOverlay",
	"ArtOverlayFrame",
	"Portrait",
	"portrait",
	"ScrollFrameBorder",
	"EdgeShadows",
	"Background"
}

local function StripTextures(object, kill)
	if object.GetNumRegions then
		for _, region in next, {object:GetRegions()} do
			if region and region.IsObjectType and region:IsObjectType("Texture") then
				if kill then
					region:Kill()
				else
					region:SetTexture("")
					region:SetAtlas("")
				end
			end
		end
	end

	local frameName = object.GetName and object:GetName()
	for _, blizzard in pairs(StripTexturesBlizzFrames) do
		local blizzFrame = object[blizzard] or frameName and _G[frameName..blizzard]
		if blizzFrame then
			blizzFrame:StripTextures(kill)
		end
	end
end

----------------------------------------------------------------------------------------
--	Kill object function
----------------------------------------------------------------------------------------
local HiddenFrame = CreateFrame("Frame")
HiddenFrame:Hide()
T.Hider = HiddenFrame
local function Kill(object)
	if object.UnregisterAllEvents then
		object:UnregisterAllEvents()
		object:SetParent(HiddenFrame)
	else
		object.Show = T.dummy
	end
	object:Hide()
end

----------------------------------------------------------------------------------------
--	Style ActionBars/Bags buttons function(by Chiril & Karudon)
----------------------------------------------------------------------------------------
local function StyleButton(button, t, size, setBackdrop)
	if not size then size = 2 end
	if button.SetHighlightTexture and not button.hover then
		local hover = button:CreateTexture()
		hover:SetColorTexture(1, 1, 1, 0.3)
		if setBackdrop then
			hover:SetInside(button.backdrop)
		else
			hover:SetPoint("TOPLEFT", button, size, -size)
			hover:SetPoint("BOTTOMRIGHT", button, -size, size)
		end
		button.hover = hover
		button:SetHighlightTexture(hover)
	end

	if not t and button.SetPushedTexture and not button.pushed then
		local pushed = button:CreateTexture()
		pushed:SetColorTexture(0.9, 0.8, 0.1, 0.3)
		if setBackdrop then
			pushed:SetInside(button.backdrop)
		else
			pushed:SetPoint("TOPLEFT", button, size, -size)
			pushed:SetPoint("BOTTOMRIGHT", button, -size, size)
		end
		button.pushed = pushed
		button:SetPushedTexture(pushed)
	end

	if button.SetCheckedTexture and not button.checked then
		local checked = button:CreateTexture()
		checked:SetColorTexture(0, 1, 0, 0.3)
		if setBackdrop then
			checked:SetInside(button.backdrop)
		else
			checked:SetPoint("TOPLEFT", button, size, -size)
			checked:SetPoint("BOTTOMRIGHT", button, -size, size)
		end
		button.checked = checked
		button:SetCheckedTexture(checked)
	end

	local cooldown = button:GetName() and _G[button:GetName().."Cooldown"]
	if cooldown then
		cooldown:ClearAllPoints()
		cooldown:SetPoint("TOPLEFT", button, size, -size)
		cooldown:SetPoint("BOTTOMRIGHT", button, -size, size)
	end
end

----------------------------------------------------------------------------------------
--	Style buttons function
----------------------------------------------------------------------------------------
T.SetModifiedBackdrop = function(self)
	if self:IsEnabled() then
		self:SetBackdropBorderColor(unpack(C.media.classborder_color))
		if self.overlay then
			self.overlay:SetVertexColor(C.media.classborder_color[1] * 0.3, C.media.classborder_color[2] * 0.3, C.media.classborder_color[3] * 0.3, 1)
		end
		if self.colorText == "Text" then
			self.Text:SetTextColor(1, 1, 1)
		elseif self.colorText == "Button" then
			self.ButtonText:SetTextColor(1, 1, 1)
		elseif self.colorText == "Name" then
			_G[self:GetName().."Text"]:SetTextColor(1, 1, 1)
		end
	end
end

T.SetOriginalBackdrop = function(self)
	self:SetBackdropBorderColor(unpack(C.media.border_color))
	if self.overlay then
		self.overlay:SetVertexColor(0.1, 0.1, 0.1, 1)
	end
	if self.colorText == "Text" then
		self.Text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	elseif self.colorText == "Button" then
		self.ButtonText:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	elseif self.colorText == "Name" then
		_G[self:GetName().."Text"]:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	end
end

local function SkinButton(f, strip, colorText)
	if strip then f:StripTextures() end

	if f.SetNormalTexture then f:SetNormalTexture(0) end
	if f.SetHighlightTexture then f:SetHighlightTexture(0) end
	if f.SetPushedTexture then f:SetPushedTexture(0) end
	if f.SetDisabledTexture then f:SetDisabledTexture(0) end

	if f.Left then f.Left:SetAlpha(0) end
	if f.Right then f.Right:SetAlpha(0) end
	if f.Middle then f.Middle:SetAlpha(0) end
	if f.Center then f.Center:SetAlpha(0) end
	if f.LeftSeparator then f.LeftSeparator:SetAlpha(0) end
	if f.RightSeparator then f.RightSeparator:SetAlpha(0) end
	if f.Flash then f.Flash:SetAlpha(0) end

	if f.TopLeft then f.TopLeft:Hide() end
	if f.TopRight then f.TopRight:Hide() end
	if f.BottomLeft then f.BottomLeft:Hide() end
	if f.BottomRight then f.BottomRight:Hide() end
	if f.TopMiddle then f.TopMiddle:Hide() end
	if f.MiddleLeft then f.MiddleLeft:Hide() end
	if f.MiddleRight then f.MiddleRight:Hide() end
	if f.BottomMiddle then f.BottomMiddle:Hide() end
	if f.MiddleMiddle then f.MiddleMiddle:Hide() end
	if f.Background then f.Background:Hide() end

	if colorText then f.colorText = colorText end -- some buttons have yellow static color

	f:SetTemplate("Overlay")
	f:HookScript("OnEnter", T.SetModifiedBackdrop)
	f:HookScript("OnLeave", T.SetOriginalBackdrop)
end

----------------------------------------------------------------------------------------
--	Style icon function
----------------------------------------------------------------------------------------
local function SkinIcon(icon, t, parent)
	parent = parent or icon:GetParent()

	if t then
		icon.b = CreateFrame("Frame", nil, parent)
		icon.b:SetTemplate("Default")
		icon.b:SetOutside(icon)
	else
		parent:CreateBackdrop("Default")
		parent.backdrop:SetOutside(icon)
	end

	icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	icon:SetParent(t and icon.b or parent)
end

local function CropIcon(icon)
	icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	icon:SetInside()
end

----------------------------------------------------------------------------------------
--	Font function
----------------------------------------------------------------------------------------
local function FontString(parent, name, fontName, fontHeight, fontStyle)
	local fs = parent:CreateFontString(nil, "OVERLAY")
	fs:SetFont(fontName, fontHeight, fontStyle)
	fs:SetJustifyH("LEFT")

	if not name then
		parent.text = fs
	else
		parent[name] = fs
	end

	return fs
end

----------------------------------------------------------------------------------------
--	Fade in/out functions
----------------------------------------------------------------------------------------
local function FadeIn(f)
	UIFrameFadeIn(f, 0.4, f:GetAlpha(), 1)
end

local function FadeOut(f)
	UIFrameFadeOut(f, 0.8, f:GetAlpha(), 0)
end

local function addAPI(object)
	local mt = getmetatable(object).__index
	if not object.SetOutside then mt.SetOutside = SetOutside end
	if not object.SetInside then mt.SetInside = SetInside end
	if not object.SetMovePoint then mt.SetMovePoint = SetMovePoint end
	if not object.CreateOverlay then mt.CreateOverlay = CreateOverlay end
	if not object.CreateBorder then mt.CreateBorder = CreateBorder end
	if not object.SetTemplate then mt.SetTemplate = SetTemplate end
	if not object.CreatePanel then mt.CreatePanel = CreatePanel end
	if not object.CreateBackdrop then mt.CreateBackdrop = CreateBackdrop end
	if not object.StripTextures then mt.StripTextures = StripTextures end
	if not object.Kill then mt.Kill = Kill end
	if not object.StyleButton then mt.StyleButton = StyleButton end
	if not object.SkinButton then mt.SkinButton = SkinButton end
	if not object.SkinIcon then mt.SkinIcon = SkinIcon end
	if not object.CropIcon then mt.CropIcon = CropIcon end
	if not object.FontString then mt.FontString = FontString end
	if not object.FadeIn then mt.FadeIn = FadeIn end
	if not object.FadeOut then mt.FadeOut = FadeOut end
end

local handled = {["Frame"] = true}
local object = CreateFrame("Frame")
addAPI(object)
addAPI(object:CreateTexture())
addAPI(object:CreateFontString())

object = EnumerateFrames()
while object do
	if not object:IsForbidden() and not handled[object:GetObjectType()] then
		addAPI(object)
		handled[object:GetObjectType()] = true
	end

	object = EnumerateFrames(object)
end

-- Hacky fix for issue on 7.1 PTR where scroll frames no longer seem to inherit the methods from the "Frame" widget
local scrollFrame = CreateFrame("ScrollFrame")
addAPI(scrollFrame)

----------------------------------------------------------------------------------------
--	Style functions
----------------------------------------------------------------------------------------
T.SkinFuncs = {}
T.SkinFuncs["ShestakUI"] = {}

function T.SkinScrollBar(frame, isMinimal)
	frame:StripTextures()

	local frameName = frame.GetName and frame:GetName()
	local UpButton = frame.ScrollUpButton or frame.ScrollUp or frame.UpButton or frame.Back or _G[frameName and frameName.."ScrollUpButton"] or frame:GetParent().scrollUp
	local DownButton = frame.ScrollDownButton or frame.ScrollDown or frame.DownButton or frame.Forward or _G[frameName and frameName.."ScrollDownButton"] or frame:GetParent().scrollDown
	local ThumbTexture = frame.ThumbTexture or frame.thumbTexture or _G[frameName and frameName.."ThumbTexture"]
	local newThumb = frame.Back and frame:GetThumb()

	local minimal = isMinimal or frame.GetWidth and frame:GetWidth() < 10

	if UpButton and DownButton then
		if not UpButton.icon and not minimal then
			T.SkinNextPrevButton(UpButton, nil, "Up")
			UpButton:SetSize(UpButton:GetWidth() + 7, UpButton:GetHeight() + 7)
		end

		if not DownButton.icon and not minimal then
			T.SkinNextPrevButton(DownButton, nil, "Down")
			DownButton:SetSize(DownButton:GetWidth() + 7, DownButton:GetHeight() + 7)
		end

		if ThumbTexture then
			ThumbTexture:SetTexture(nil)
			if not frame.thumbbg then
				frame.thumbbg = CreateFrame("Frame", nil, frame)
				frame.thumbbg:SetPoint("TOPLEFT", ThumbTexture, "TOPLEFT", 0, -3)
				frame.thumbbg:SetPoint("BOTTOMRIGHT", ThumbTexture, "BOTTOMRIGHT", 0, 3)
				frame.thumbbg:SetTemplate("Overlay")

				frame:HookScript("OnShow", function()
					local _, maxValue = frame:GetMinMaxValues()
					if maxValue == 0 then
						frame:SetAlpha(0)
					else
						frame:SetAlpha(1)
					end
				end)

				frame:HookScript("OnMinMaxChanged", function()
					local _, maxValue = frame:GetMinMaxValues()
					if maxValue == 0 then
						frame:SetAlpha(0)
					else
						frame:SetAlpha(1)
					end
				end)

				frame:HookScript("OnDisable", function()
					frame:SetAlpha(0)
				end)

				frame:HookScript("OnEnable", function()
					frame:SetAlpha(1)
				end)
			end
		elseif newThumb then
			if frame.Background then
				frame.Background:Hide()
			end
			if frame.Track then
				frame.Track:DisableDrawLayer("ARTWORK")
			end
			newThumb:DisableDrawLayer("BACKGROUND")
			newThumb:DisableDrawLayer("ARTWORK")
			if not frame.thumbbg then
				frame.thumbbg = CreateFrame("Frame", nil, newThumb)
				frame.thumbbg:SetPoint("TOPLEFT", newThumb, "TOPLEFT", 0, -3)
				frame.thumbbg:SetPoint("BOTTOMRIGHT", newThumb, "BOTTOMRIGHT", 0, 3)
				frame.thumbbg:SetTemplate("Overlay")

				if not newThumb:IsShown() then
					frame:SetAlpha(0)
				end

				hooksecurefunc(newThumb, "Hide", function()
					frame:SetAlpha(0)
				end)

				hooksecurefunc(newThumb, "Show", function()
					frame:SetAlpha(1)
				end)

				hooksecurefunc(newThumb, "SetShown", function(_, showThumb)
					if showThumb then
						frame:SetAlpha(1)
					else
						frame:SetAlpha(0)
					end
				end)
			end

			if minimal then
				newThumb:SetWidth(10)
			end
		end
	end
end

local tabs = {
	"LeftDisabled",
	"MiddleDisabled",
	"RightDisabled",
	"Left",
	"Middle",
	"Right",
}

function T.SkinTab(tab, bg)
	if not tab then return end

	for _, object in pairs(tabs) do
		local tex = tab:GetName() and _G[tab:GetName()..object]
		if tex then
			tex:SetTexture(nil)
		end
	end

	if tab.GetHighlightTexture and tab:GetHighlightTexture() then
		tab:GetHighlightTexture():SetTexture(nil)
	else
		tab:StripTextures()
	end

	tab.backdrop = CreateFrame("Frame", nil, tab)
	tab.backdrop:SetFrameLevel(tab:GetFrameLevel() - 1)
	if bg then
		tab.backdrop:SetTemplate("Overlay")
		tab.backdrop:SetPoint("TOPLEFT", 2, -9)
		tab.backdrop:SetPoint("BOTTOMRIGHT", -2, -2)
	else
		tab.backdrop:SetTemplate("Transparent")
		tab.backdrop:SetPoint("TOPLEFT", 0, -3)
		tab.backdrop:SetPoint("BOTTOMRIGHT", 0, 3)
	end
end

function T.SkinNextPrevButton(btn, left, scroll)
	local normal, pushed, disabled
	local frameName = btn.GetName and btn:GetName()
	local isPrevButton = frameName and (string.find(frameName, "Left") or string.find(frameName, "Prev") or string.find(frameName, "Decrement") or string.find(frameName, "Back")) or left
	local isScrollUpButton = frameName and string.find(frameName, "ScrollUp") or scroll == "Up"
	local isScrollDownButton = frameName and string.find(frameName, "ScrollDown") or scroll == "Down"

	if btn:GetNormalTexture() then
		normal = btn:GetNormalTexture():GetTexture()
	end

	if btn:GetPushedTexture() then
		pushed = btn:GetPushedTexture():GetTexture()
	end

	if btn:GetDisabledTexture() then
		disabled = btn:GetDisabledTexture():GetTexture()
	end

	btn:StripTextures()

	if btn.Texture then
		btn.Texture:SetAlpha(0)

		if btn.Overlay then
			btn.Overlay:SetAlpha(0)
		end
	end

	if scroll == "Up" or scroll == "Down" or scroll == "Any" then
		normal = nil
		pushed = nil
		disabled = nil
	end

	if not normal then
		if isPrevButton then
			normal = "Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up"
		elseif isScrollUpButton then
			normal = "Interface\\ChatFrame\\UI-ChatIcon-ScrollUp-Up"
		elseif isScrollDownButton then
			normal = "Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up"
		else
			normal = "Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up"
		end
	end

	if not pushed then
		if isPrevButton then
			pushed = "Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Down"
		elseif isScrollUpButton then
			pushed = "Interface\\ChatFrame\\UI-ChatIcon-ScrollUp-Down"
		elseif isScrollDownButton then
			pushed = "Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Down"
		else
			pushed = "Interface\\Buttons\\UI-SpellbookIcon-NextPage-Down"
		end
	end

	if not disabled then
		if isPrevButton then
			disabled = "Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Disabled"
		elseif isScrollUpButton then
			disabled = "Interface\\ChatFrame\\UI-ChatIcon-ScrollUp-Disabled"
		elseif isScrollDownButton then
			disabled = "Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Disabled"
		else
			disabled = "Interface\\Buttons\\UI-SpellbookIcon-NextPage-Disabled"
		end
	end

	btn:SetNormalTexture(normal)
	btn:SetPushedTexture(pushed)
	btn:SetDisabledTexture(disabled)

	btn:SetTemplate("Overlay")
	btn:SetSize(btn:GetWidth() - 7, btn:GetHeight() - 7)

	if normal and pushed and disabled then
		btn:GetNormalTexture():SetTexCoord(0.3, 0.29, 0.3, 0.81, 0.65, 0.29, 0.65, 0.81)
		if btn:GetPushedTexture() then
			btn:GetPushedTexture():SetTexCoord(0.3, 0.35, 0.3, 0.81, 0.65, 0.35, 0.65, 0.81)
		end
		if btn:GetDisabledTexture() then
			btn:GetDisabledTexture():SetTexCoord(0.3, 0.29, 0.3, 0.75, 0.65, 0.29, 0.65, 0.75)
		end

		btn:GetNormalTexture():ClearAllPoints()
		btn:GetNormalTexture():SetPoint("TOPLEFT", 2, -2)
		btn:GetNormalTexture():SetPoint("BOTTOMRIGHT", -2, 2)
		if btn:GetDisabledTexture() then
			btn:GetDisabledTexture():SetAllPoints(btn:GetNormalTexture())
		end
		if btn:GetPushedTexture() then
			btn:GetPushedTexture():SetAllPoints(btn:GetNormalTexture())
		end
		if btn:GetHighlightTexture() then
			btn:GetHighlightTexture():SetColorTexture(1, 1, 1, 0.3)
			btn:GetHighlightTexture():SetAllPoints(btn:GetNormalTexture())
		end
	end
end

function T.SkinRotateButton(btn)
	btn:SetTemplate("Default")
	btn:SetSize(btn:GetWidth() - 14, btn:GetHeight() - 14)

	btn:GetNormalTexture():SetTexCoord(0.3, 0.29, 0.3, 0.65, 0.69, 0.29, 0.69, 0.65)
	btn:GetPushedTexture():SetTexCoord(0.3, 0.29, 0.3, 0.65, 0.69, 0.29, 0.69, 0.65)

	btn:GetHighlightTexture():SetColorTexture(1, 1, 1, 0.3)

	btn:GetNormalTexture():ClearAllPoints()
	btn:GetNormalTexture():SetPoint("TOPLEFT", 2, -2)
	btn:GetNormalTexture():SetPoint("BOTTOMRIGHT", -2, 2)
	btn:GetPushedTexture():SetAllPoints(btn:GetNormalTexture())
	btn:GetHighlightTexture():SetAllPoints(btn:GetNormalTexture())
end

function T.SkinEditBox(frame, width, height)
	frame:DisableDrawLayer("BACKGROUND")

	frame:CreateBackdrop("Overlay")

	local frameName = frame.GetName and frame:GetName()
	if frameName and (frameName:find("Gold") or frameName:find("Silver") or frameName:find("Copper")) then
		frame.backdrop:SetPoint("TOPLEFT", -3, 1)
		frame.backdrop:SetPoint("BOTTOMRIGHT", -2, 0)
	end

	if width then frame:SetWidth(width) end
	if height then frame:SetHeight(height) end
end

function T.SkinDropDownBox(frame, width, pos)
	if frame.Arrow then
		frame.Background:SetTexture(nil)
		frame:CreateBackdrop("Overlay")
		frame.backdrop:SetPoint("TOPLEFT", -2, -1)
		frame.backdrop:SetPoint("BOTTOMRIGHT", 0, 1)
		frame:SetFrameLevel(frame:GetFrameLevel() + 2)
		frame.Arrow:SetAlpha(0)
		if frame.TabHighlight then frame.TabHighlight:SetAlpha(0) end

		local tex = frame:CreateTexture(nil, "ARTWORK")
		tex:SetPoint("RIGHT", frame, -4, 0)
		tex:SetSize(15, 15)
		tex:SetTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up")
		tex:SetTexCoord(0.3, 0.29, 0.3, 0.81, 0.65, 0.29, 0.65, 0.81)

		local f = CreateFrame("Frame", nil, frame)
		f:SetOutside(tex)
		f:SetTemplate("Default")
		tex:SetParent(f)
	return
	end

	local frameName = frame.GetName and frame:GetName()
	local button = frame.Button or frameName and (_G[frameName.."Button"] or _G[frameName.."_Button"])
	local text = frameName and _G[frameName.."Text"] or frame.Text
	if not width then width = 155 end

	frame:StripTextures()
	frame:SetWidth(width)

	if text then
		text:ClearAllPoints()
		text:SetPoint("RIGHT", button, "LEFT", -2, 0)
	end

	button:ClearAllPoints()
	if pos then
		button:SetPoint("TOPRIGHT", frame.Right, -20, -21)
	else
		button:SetPoint("RIGHT", frame, "RIGHT", -10, 3)
	end
	button.SetPoint = T.dummy
	T.SkinNextPrevButton(button, nil, "Down")

	frame:CreateBackdrop("Overlay")
	frame:SetFrameLevel(frame:GetFrameLevel() + 2)
	frame.backdrop:SetPoint("TOPLEFT", 20, -2)
	frame.backdrop:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 2, -2)
end

function T.SkinFilter(frame, height)
	frame:SkinButton(nil, "Text")

	local tex = frame:CreateTexture(nil, "ARTWORK")
	tex:SetPoint("RIGHT", frame, -4, 0)
	tex:SetSize(14, 14)
	tex:SetTexture("Interface\\ChatFrame\\ChatFrameExpandArrow")

	if frame.ResetButton then
		T.SkinCloseButton(frame.ResetButton)
		frame.ResetButton:ClearAllPoints()
		frame.ResetButton:SetPoint("CENTER", frame, "TOPRIGHT", 0, 0)
	end

	if height then
		frame:SetHeight(22)
	end
end

function T.SkinCheckBox(frame, size)
	if size then
		frame:SetSize(size, size)
	end
	frame:SetNormalTexture(0)
	frame:SetPushedTexture(0)
	frame:CreateBackdrop("Overlay")
	frame:SetFrameLevel(frame:GetFrameLevel() + 2)
	frame.backdrop:SetPoint("TOPLEFT", 4, -4)
	frame.backdrop:SetPoint("BOTTOMRIGHT", -4, 4)

	if frame.SetHighlightTexture then
		local highligh = frame:CreateTexture()
		highligh:SetColorTexture(1, 1, 1, 0.3)
		highligh:SetPoint("TOPLEFT", frame, 6, -6)
		highligh:SetPoint("BOTTOMRIGHT", frame, -6, 6)
		frame:SetHighlightTexture(highligh)
	end

	if frame.SetCheckedTexture then
		local checked = frame:CreateTexture()
		checked:SetColorTexture(1, 0.82, 0, 0.8)
		checked:SetPoint("TOPLEFT", frame, 6, -6)
		checked:SetPoint("BOTTOMRIGHT", frame, -6, 6)
		frame:SetCheckedTexture(checked)
	end

	if frame.SetDisabledCheckedTexture then
		local disabled = frame:CreateTexture()
		disabled:SetColorTexture(0.6, 0.6, 0.6, 0.75)
		disabled:SetPoint("TOPLEFT", frame, 6, -6)
		disabled:SetPoint("BOTTOMRIGHT", frame, -6, 6)
		frame:SetDisabledCheckedTexture(disabled)
	end
end

function T.SkinCheckBoxAtlas(checkbox, size)
	if size then
		checkbox:SetSize(size, size)
	end

	checkbox:CreateBackdrop("Overlay")
	checkbox.backdrop:SetInside(nil, 4, 4)

	for _, region in next, { checkbox:GetRegions() } do
		if region:IsObjectType("Texture") then
			if region:GetAtlas() == "checkmark-minimal" or region:GetTexture() == 130751 then
				region:SetTexture(C.media.texture)

				local checkedTexture = checkbox:GetCheckedTexture()
				checkedTexture:SetColorTexture(1, 0.82, 0, 0.8)
				checkedTexture:SetInside(checkbox.backdrop)
			else
				region:SetTexture("")
			end
		end
	end
end

function T.SkinCloseButton(f, point, text, pixel)
	f:StripTextures()
	f:SetTemplate("Overlay")
	f:SetSize(18, 18)

	if not text then text = "x" end
	if text == "-" and not pixel then
		f.text = f:CreateTexture(nil, "OVERLAY")
		f.text:SetSize(7, 1)
		f.text:SetPoint("CENTER")
		f.text:SetTexture(C.media.blank)
	end
	if text == "-" and pixel then
		f.text = f:CreateTexture(nil, "OVERLAY")
		f.text:SetSize(5, 1)
		f.text:SetPoint("CENTER")
		f.text:SetTexture(C.media.blank)
	end
	if not f.text then
		if pixel then
			f.text = f:FontString(nil, [[Interface\AddOns\ShestakUI\Media\Fonts\Pixel.ttf]], 8)
			f.text:SetPoint("CENTER", 0, 0)
		else
			f.text = f:FontString(nil, C.media.normal_font, 17)
			f.text:SetPoint("CENTER", 0, 1)
		end
		f.text:SetText(text)
	end

	if point then
		f:SetPoint("TOPRIGHT", point, "TOPRIGHT", -4, -4)
	else
		f:SetPoint("TOPRIGHT", -4, -4)
	end

	f:HookScript("OnEnter", T.SetModifiedBackdrop)
	f:HookScript("OnLeave", T.SetOriginalBackdrop)
end

function T.SkinSlider(f)
	f:StripTextures()

	local bd = CreateFrame("Frame", nil, f)
	bd:SetTemplate("Overlay")
	if f:GetOrientation() == "VERTICAL" then
		bd:SetPoint("TOPLEFT", -2, -6)
		bd:SetPoint("BOTTOMRIGHT", 2, 6)
		f:GetThumbTexture():SetRotation(rad(90))
	else
		bd:SetPoint("TOPLEFT", 14, -2)
		bd:SetPoint("BOTTOMRIGHT", -15, 3)
	end
	bd:SetFrameLevel(f:GetFrameLevel() - 1)

	f:SetThumbTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
	f:GetThumbTexture():SetBlendMode("ADD")
end

function T.SkinSliderStep(frame, minimal)
	frame:StripTextures()

	local slider = frame.Slider
	if not slider then return end

	slider:DisableDrawLayer("ARTWORK")

	local thumb = slider.Thumb
	if thumb then
		thumb:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]])
		thumb:SetBlendMode("ADD")
		thumb:SetSize(20, 30)
	end

	local offset = minimal and 10 or 13
	slider:CreateBackdrop("Overlay")
	slider.backdrop:SetPoint("TOPLEFT", 10, -offset)
	slider.backdrop:SetPoint("BOTTOMRIGHT", -10, offset)

	if not slider.barStep then
		local step = CreateFrame("StatusBar", nil, slider.backdrop)
		step:SetStatusBarTexture(C.media.texture)
		step:SetStatusBarColor(1, 0.82, 0, 1)
		step:SetPoint("TOPLEFT", slider.backdrop, T.mult * 2, -T.mult * 2)
		step:SetPoint("BOTTOMLEFT", slider.backdrop, T.mult * 2, T.mult * 2)
		step:SetPoint("RIGHT", thumb, "CENTER")

		slider.barStep = step
	end
end

function T.SkinIconSelectionFrame(frame, frameNameOverride)
	local frameName = frameNameOverride or frame:GetName()
	local editBox = frame.BorderBox.IconSelectorEditBox
	local okayButton = frame.OkayButton or frame.BorderBox.OkayButton or _G[frameName.."Okay"]
	local cancelButton = frame.CancelButton or frame.BorderBox.CancelButton or _G[frameName.."Cancel"]

	frame:StripTextures()
	frame.BorderBox:StripTextures()
	frame:CreateBackdrop("Transparent")
	frame.backdrop:SetPoint("TOPLEFT", 3, 1)
	frame:SetHeight(frame:GetHeight() + 13)

	T.SkinScrollBar(frame.IconSelector.ScrollBar)

	okayButton:SkinButton()
	cancelButton:SkinButton()
	cancelButton:ClearAllPoints()
	cancelButton:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -5, 5)

	editBox:DisableDrawLayer("BACKGROUND")
	T.SkinEditBox(editBox)

	local button = frame.BorderBox.SelectedIconArea and frame.BorderBox.SelectedIconArea.SelectedIconButton
	if button then
		button:DisableDrawLayer("BACKGROUND")
		local texture = button.Icon:GetTexture()
		button:StripTextures()
		button:StyleButton(true)
		button:SetTemplate("Default")

		button.Icon:ClearAllPoints()
		button.Icon:SetPoint("TOPLEFT", 2, -2)
		button.Icon:SetPoint("BOTTOMRIGHT", -2, 2)
		button.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		if texture then
			button.Icon:SetTexture(texture)
		end
	end

	hooksecurefunc(frame.IconSelector.ScrollBox, "Update", function(self)
		for i = 1, self.ScrollTarget:GetNumChildren() do
			local child = select(i, self.ScrollTarget:GetChildren())
			if child.Icon and not child.styled then
				local texture = child.Icon:GetTexture()
				child:StripTextures()
				child:StyleButton(true)
				child:SetTemplate("Default")

				child.Icon:ClearAllPoints()
				child.Icon:SetPoint("TOPLEFT", 2, -2)
				child.Icon:SetPoint("BOTTOMRIGHT", -2, 2)
				child.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				if texture then
					child.Icon:SetTexture(texture)
				end
				child.styled = true
			end
		end
	end)

	local dropdown = frame.BorderBox.IconTypeDropdown
	if dropdown then
		T.SkinDropDownBox(dropdown)
	end

	if frame.DepositSettingsMenu then
		frame.DepositSettingsMenu:DisableDrawLayer("OVERLAY")
		for _, child in pairs({frame.DepositSettingsMenu:GetChildren()}) do
			if child:IsObjectType("CheckButton") then
				T.SkinCheckBox(child, 22)
			elseif child.Arrow then
				T.SkinDropDownBox(child)
			end
		end
	end
end

function T.SkinMaxMinFrame(frame, point)
	frame:SetSize(18, 18)

	if point then
		frame:SetPoint("RIGHT", point, "LEFT", -2, 0)
	end

	for name, direction in pairs({ ["MaximizeButton"] = "up", ["MinimizeButton"] = "down"}) do
		local button = frame[name]
		if button then
			button:StripTextures()
			button:SetTemplate("Overlay")
			button:SetPoint("CENTER")
			button:SetHitRectInsets(1, 1, 1, 1)

			button.minus = button:CreateTexture(nil, "OVERLAY")
			button.minus:SetSize(7, 1)
			button.minus:SetPoint("CENTER")
			button.minus:SetTexture(C.media.blank)

			if direction == "up" then
				button.plus = button:CreateTexture(nil, "OVERLAY")
				button.plus:SetSize(1, 7)
				button.plus:SetPoint("CENTER")
				button.plus:SetTexture(C.media.blank)
			end

			button:HookScript("OnEnter", T.SetModifiedBackdrop)
			button:HookScript("OnLeave", T.SetOriginalBackdrop)
		end
	end
end

function T.SkinExpandOrCollapse(f)
	f:SetHighlightTexture(0)
	f:SetPushedTexture(0)

	local bg = CreateFrame("Frame", nil, f)
	bg:SetSize(13, 13)
	bg:SetPoint("TOPLEFT", f:GetNormalTexture(), 0, -1)
	bg:SetTemplate("Overlay")
	f.bg = bg

	bg.minus = bg:CreateTexture(nil, "OVERLAY")
	bg.minus:SetSize(5, 1)
	bg.minus:SetPoint("CENTER")
	bg.minus:SetTexture(C.media.blank)

	bg.plus = bg:CreateTexture(nil, "OVERLAY")
	bg.plus:SetSize(1, 5)
	bg.plus:SetPoint("CENTER")
	bg.plus:SetTexture(C.media.blank)
	bg.plus:Hide()

	hooksecurefunc(f, "SetNormalTexture", function(self, texture)
		if self.settingTexture then return end
		self.settingTexture = true
		self:SetNormalTexture(0)

		if texture and texture ~= "" then
			if texture:find("Plus") or texture:find("closed") then
				self.bg.plus:Show()
			elseif texture:find("Minus") or texture:find("open") then
				self.bg.plus:Hide()
			end
			self.bg:Show()
		else
			self.bg:Hide()
		end
		self.settingTexture = nil
	end)

	f:HookScript("OnEnter", function(self)
		self.bg:SetBackdropBorderColor(unpack(C.media.classborder_color))
		if self.bg.overlay then
			self.bg.overlay:SetVertexColor(C.media.classborder_color[1] * 0.3, C.media.classborder_color[2] * 0.3, C.media.classborder_color[3] * 0.3, 1)
		end
	end)

	f:HookScript("OnLeave", function(self)
		self.bg:SetBackdropBorderColor(unpack(C.media.border_color))
		if self.bg.overlay then
			self.bg.overlay:SetVertexColor(0.1, 0.1, 0.1, 1)
		end
	end)
end

function T.SkinProfessionsFlyout(_, parent)
	for i = 1, parent:GetNumChildren() do
		local frame = select(i, parent:GetChildren())
		if frame.HideUnownedCheckbox and not frame.backdrop then
			frame:StripTextures()
			frame:CreateBackdrop("Transparent")
			frame.backdrop:SetFrameLevel(2)
			hooksecurefunc(frame, "SetParent", function()
				frame.backdrop:SetFrameStrata("LOW")
			end)
			frame.backdrop:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 5, 2)
			T.SkinCheckBox(frame.HideUnownedCheckbox, 24)
			T.SkinScrollBar(frame.ScrollBar)
			hooksecurefunc(frame.ScrollBox, "Update", function(self)
				for i = 1, self.ScrollTarget:GetNumChildren() do
					local button = select(i, self.ScrollTarget:GetChildren())
					if button.IconBorder and not button.styled then
						button:SetTemplate("Transparent")
						button.icon:CropIcon()
						button:SetNormalTexture(0)
						button:SetPushedTexture(0)
						button:GetHighlightTexture():Hide()
						T.SkinIconBorder(button.IconBorder, button)

						button.styled = true
					end
				end
			end)

			break
		end
	end
end

function T.SkinHelpBox(frame)
	frame:StripTextures()
	frame:SetTemplate("Transparent")
	if frame.CloseButton then
		T.SkinCloseButton(frame.CloseButton)
	end
	if frame.Arrow then
		frame.Arrow:Hide()
	end
end

function T.SkinFrameTab(frame)
	frame:SetSize(34, 44)

	frame:CreateBackdrop("Overlay")
	frame.backdrop:SetPoint("TOPLEFT", 2, -2)
	frame.backdrop:SetPoint("BOTTOMRIGHT", -2, 2)

	if frame.Background then
		frame.Background:SetAlpha(0)
	end

	if frame.SelectedTexture then
		frame.SelectedTexture:SetDrawLayer("ARTWORK")
		frame.SelectedTexture:ClearAllPoints()
		frame.SelectedTexture:SetPoint("TOPLEFT", 4, -4)
		frame.SelectedTexture:SetPoint("BOTTOMRIGHT", -4, 4)
		frame.SelectedTexture:SetColorTexture(1, 0.82, 0, 0.3)
	end

	-- Hover texture
	for _, region in next, {frame:GetRegions()} do
		if region:IsObjectType("Texture") then
			if region:GetAtlas() == "QuestLog-Tab-side-Glow-hover" then
				region:SetPoint("TOPLEFT", 4, -4)
				region:SetPoint("BOTTOMRIGHT", -4, 4)
				region:SetColorTexture(1, 1, 1, 0.3)
			end
		end
	end
end

function T.SkinFrame(frame, backdrop, x, y)
	local name = frame and frame.GetName and frame:GetName()
	local portraitFrame = name and _G[name.."Portrait"] or frame.Portrait or frame.portrait
	local portraitFrameOverlay = name and _G[name.."PortraitOverlay"] or frame.PortraitOverlay
	local artFrameOverlay = name and _G[name.."ArtOverlayFrame"] or frame.ArtOverlayFrame

	frame:StripTextures()
	if backdrop then
		frame:CreateBackdrop("Transparent")
		if x and y then
			frame.backdrop:SetPoint("TOPLEFT", x, -y)
			frame.backdrop:SetPoint("BOTTOMRIGHT", -x, y)
		end
	else
		frame:SetTemplate("Transparent")
	end

	if frame.CloseButton then
		T.SkinCloseButton(frame.CloseButton)
	end

	if portraitFrame then portraitFrame:SetAlpha(0) end
	if portraitFrameOverlay then portraitFrameOverlay:SetAlpha(0) end
	if artFrameOverlay then artFrameOverlay:SetAlpha(0) end
end

local iconColors = {
	["uncollected"] = {r = borderr, g = borderg, b = borderb},
	["gray"]		= {r = borderr, g = borderg, b = borderb},
	["white"]		= {r = borderr, g = borderg, b = borderb},
	["green"]		= BAG_ITEM_QUALITY_COLORS[2],
	["blue"]		= BAG_ITEM_QUALITY_COLORS[3],
	["purple"]		= BAG_ITEM_QUALITY_COLORS[4],
	["orange"]		= BAG_ITEM_QUALITY_COLORS[5],
	["artifact"]	= BAG_ITEM_QUALITY_COLORS[6],
	["account"]		= BAG_ITEM_QUALITY_COLORS[7],
	["epic"]		= BAG_ITEM_QUALITY_COLORS[4],
	["legendary"]	= BAG_ITEM_QUALITY_COLORS[5],
}

function T.SkinIconBorder(frame, parent, useAtlas)
	local border = parent or frame:GetParent().backdrop
	frame:SetAlpha(0)
	if not useAtlas then
		hooksecurefunc(frame, "SetVertexColor", function(_, r, g, b)
			if r ~= BAG_ITEM_QUALITY_COLORS[1].r and g ~= BAG_ITEM_QUALITY_COLORS[1].g and not (r > 0.9 and g > 0.9 and b > 0.9) then
				border:SetBackdropBorderColor(r, g, b)
			else
				border:SetBackdropBorderColor(unpack(C.media.border_color))
			end
		end)
	end

	hooksecurefunc(frame, "SetAtlas", function(_, atlas)
		local atlasAbbr = atlas and strmatch(atlas, "%-(%w+)$")
		local color = atlasAbbr and iconColors[atlasAbbr]
		if color then
			border:SetBackdropBorderColor(color.r, color.g, color.b)
		end
	end)

	hooksecurefunc(frame, "Hide", function()
		border:SetBackdropBorderColor(unpack(C.media.border_color))
	end)

	hooksecurefunc(frame, "SetShown", function(_, show)
		if not show then
			border:SetBackdropBorderColor(unpack(C.media.border_color))
		end
	end)
end

function T.ReplaceIconString(frame, text)
	if not text then text = frame:GetText() end
	if not text or text == "" then return end

	local newText, count = gsub(text, "|T([^:]-):[%d+:]+|t", "|T%1:14:14:0:0:64:64:5:59:5:59|t")
	if count > 0 then frame:SetFormattedText("%s", newText) end
end

function T.SkinModelControl(frame)
	for i = 1, 5 do
		local button = select(i, frame.ControlFrame:GetChildren())
		if button.NormalTexture then
			button.NormalTexture:SetAlpha(0)
			button.PushedTexture:SetAlpha(0)
		end
	end
end

local LoadBlizzardSkin = CreateFrame("Frame")
LoadBlizzardSkin:RegisterEvent("ADDON_LOADED")
LoadBlizzardSkin:SetScript("OnEvent", function(self, _, addonName)
	if C_AddOns.IsAddOnLoaded("Skinner") or C_AddOns.IsAddOnLoaded("Aurora") or not C.skins.blizzard_frames then
		self:UnregisterEvent("ADDON_LOADED")
		return
	end

	for addon, skinfunc in pairs(T.SkinFuncs) do
		if type(skinfunc) == "function" then	-- this is loaded by demand addons
			if addon == addonName then
				if skinfunc then
					skinfunc()
				end
			end
		elseif type(skinfunc) == "table" then	-- check for ShestakUI tables that contain loaded functions
			if addon == addonName then
				for _, skinfunc in pairs(T.SkinFuncs[addon]) do
					if skinfunc then
						skinfunc()
					end
				end
			end
		end
	end
end)

-- Check if addon is loaded and apply skin
local LoadedSkin = CreateFrame("Frame")
LoadedSkin:RegisterEvent("PLAYER_LOGIN")
LoadedSkin:SetScript("OnEvent", function()
	if C_AddOns.IsAddOnLoaded("Skinner") or C_AddOns.IsAddOnLoaded("Aurora") or not C.skins.blizzard_frames then return end

	for addon, skinfunc in pairs(T.SkinFuncs) do
		if type(skinfunc) == "function" then
			local isLoaded, isFinished = C_AddOns.IsAddOnLoaded(addon)
			if isLoaded and isFinished then
				if skinfunc then
					skinfunc()
				end
			end
		end
	end
end)
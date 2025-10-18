local T, C, L = unpack(ShestakUI)
if C.skins.blizzard_frames ~= true then return end

----------------------------------------------------------------------------------------
--	ItemSocketingUI skin
----------------------------------------------------------------------------------------
local function LoadSkin()
	ItemSocketingFrame:StripTextures()
	ItemSocketingFrame:CreateBackdrop("Transparent")
	ItemSocketingFrame.backdrop:SetPoint("TOPLEFT", 0, 0)
	ItemSocketingFrame.backdrop:SetPoint("BOTTOMRIGHT", 0, 0)
	ItemSocketingFrameInset:StripTextures()
	ItemSocketingScrollFrame:StripTextures()
	ItemSocketingScrollFrame:CreateBackdrop("Overlay")
	T.SkinScrollBar(ItemSocketingScrollFrame.ScrollBar)
	ItemSocketingDescription:DisableDrawLayer("BORDER")
	ItemSocketingDescription:DisableDrawLayer("BACKGROUND")

	local Container = ItemSocketingFrame.SocketingContainer
	for _, button in ipairs(Container.SocketFrames) do
		button:StripTextures()
		button:StyleButton()
		button:SetTemplate("Overlay")
		button.BracketFrame:Kill()
		button.Background:Kill()

		button.Icon:SkinIcon()
	end

	local GEM_TYPE_INFO = {
		Yellow = {r = 0.97, g = 0.82, b = 0.29},
		Red = {r = 1, g = 0.47, b = 0.47},
		Blue = {r = 0.47, g = 0.67, b = 1},
		PunchcardRed = {r = 1, g = 0.47, b = 0.47},
		PunchcardYellow = {r = 0.97, g = 0.82, b = 0.29},
		PunchcardBlue = {r = 0.47, g = 0.67, b = 1},
		Cypher = {r = 1, g = 0.8, b = 0},
		Tinker = {r = 1, g = 0.47, b = 0.47},
		Primordial = {r = 1, g = 0, b = 1},
		Fragrance = {r = 1, g = 1, b = 1},
		SingingThunder = {r = 0.97, g = 0.82, b = 0.29},
		SingingSea = {r = 0.47, g = 0.67, b = 1},
		SingingWind = {r = 1, g = 0.47, b = 0.47},
	}

	hooksecurefunc("ItemSocketingFrame_Update", function()
		for i, socket in ipairs(Container.SocketFrames) do
			local gemColor = C_ItemSocketInfo.GetSocketTypes(i)
			local color = GEM_TYPE_INFO[gemColor]
			if color then
				socket:SetBackdropBorderColor(color.r, color.g, color.b)
				socket.overlay:SetVertexColor(color.r, color.g, color.b, 0.35)
			else
				socket:SetBackdropBorderColor(unpack(C.media.border_color))
				socket.overlay:SetVertexColor(0.1, 0.1, 0.1, 1)
			end
		end
	end)

	ItemSocketingFramePortrait:Kill()
	Container.ApplySocketsButton:ClearAllPoints()
	Container.ApplySocketsButton:SetPoint("BOTTOMRIGHT", ItemSocketingFrame.backdrop, "BOTTOMRIGHT", -5, 5)
	Container.ApplySocketsButton:SkinButton()
	T.SkinCloseButton(ItemSocketingFrameCloseButton, ItemSocketingFrame.backdrop)
end

T.SkinFuncs["Blizzard_ItemSocketingUI"] = LoadSkin
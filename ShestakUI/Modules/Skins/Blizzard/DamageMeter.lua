local T, C, L = unpack(ShestakUI)
if C.skins.blizzard_frames ~= true then return end

----------------------------------------------------------------------------------------
--	Damage Meter skin
----------------------------------------------------------------------------------------
local barHeight = 14
local function LoadSkin()
	local function skinBar(frame, second)
		for _, frame in next, {frame.ScrollTarget:GetChildren()} do
			local bar = frame.StatusBar
			local icon = frame.Icon
			local height = bar and bar:GetHeight() or 14
			if issecretvalue(height) then height = 14 end
			if second then height = barHeight end
			if bar and not bar.styled then
				bar:SetStatusBarTexture(C.media.texture)
				bar.Background:Hide()
				frame:CreateBackdrop("Overlay")
				frame.backdrop:SetPoint("TOPLEFT", 4, -1)
				frame.backdrop:SetPoint("BOTTOMRIGHT", -1, 1)

				if icon and icon.Icon:IsShown() then
					frame.backdrop:SetPoint("TOPLEFT", height + 2, -1)
				end

				bar.Name:SetFont(C.font.stylization_font, C.font.stylization_font_size, C.font.stylization_font_style)
				bar.Value:SetFont(C.font.stylization_font, C.font.stylization_font_size, C.font.stylization_font_style)

				barHeight = height -- store it while source window not loaded
				bar.styled = true
			end

			if icon and not icon.styled then
				icon.b = CreateFrame("Frame", nil, frame)
				icon.b:SetTemplate("Default")
				icon.b:SetPoint("LEFT", frame, "LEFT", 1, 0)
				icon.b:SetSize(height, height)

				icon:SetInside(icon.b)
				icon.styled = true
			end

			if not icon.Icon:IsShown() and icon.b then
				icon.b:Hide()
			end

			if bar and bar.styled then
				if icon then
					for i = 1, bar:GetNumPoints() do
						local ap, p, rp, x, y = bar:GetPoint(i)
						if canaccessvalue(ap) then
							if ap == "TOP" and y == -1 then
								bar:SetPoint(ap, p, rp, x, y - 2)
							elseif ap == "BOTTOMRIGHT" and y == 1 then
								bar:SetPoint(ap, p, rp, x + 1, y + 2)
							end
						else
							bar:SetInside(frame.backdrop)
						end
					end
					bar:SetPoint("LEFT", frame.backdrop, "LEFT", 2, 0)
				else
					bar:SetInside(frame.backdrop)
				end
			end
			if bar and bar.BackgroundEdge then bar.BackgroundEdge:Hide() end
		end
	end

	DamageMeter:ForEachSessionWindow(function(window)
		T.SkinFrame(window, true, 10, 4)
		T.SkinFrame(window.SourceWindow, true, 12, 10)
		T.SkinScrollBar(window.SourceWindow.ScrollBar)

		window.DamageMeterTypeDropdown:SetSize(18, 18)
		window.DamageMeterTypeDropdown:SkinButton()
		window.DamageMeterTypeDropdown.Arrow:SetTexCoord(0.3, 0.7, 0.25, 0.65)
		window.DamageMeterTypeDropdown.Arrow:SetInside(window.DamageMeterTypeDropdown)
		window.DamageMeterTypeDropdown:ClearAllPoints()
		window.DamageMeterTypeDropdown:SetPoint("TOPLEFT", window.Header, "TOPLEFT", 16, -10)
		window.DamageMeterTypeDropdown.TypeName:SetPoint("LEFT", window.DamageMeterTypeDropdown.Arrow, "LEFT", 30, 0)

		window.SessionDropdown:SkinButton()
		window.SessionDropdown:SetPoint("RIGHT", window.SettingsDropdown, -28, 0)

		window.SettingsDropdown:SetSize(18, 18)
		window.SettingsDropdown:SkinButton()
		window.SettingsDropdown.Icon:SetTexCoord(0.3, 0.73, 0.2, 0.65)
		window.SettingsDropdown.Icon:SetInside(window.SettingsDropdown)
		window.SettingsDropdown:ClearAllPoints()
		window.SettingsDropdown:SetPoint("TOPRIGHT", window.Header, "TOPRIGHT", -16, -10)

		skinBar(window.ScrollBox)

		hooksecurefunc(window.ScrollBox, "Update", function(frame)
			skinBar(frame)
		end)

		hooksecurefunc(window.SourceWindow.ScrollBox, "Update", function(frame)
			skinBar(frame, true)
		end)
	end)
end

T.SkinFuncs["Blizzard_DamageMeter"] = LoadSkin
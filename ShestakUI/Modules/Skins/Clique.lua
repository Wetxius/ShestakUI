local T, C, L = unpack(ShestakUI)
if C.skins.blizzard_frames ~= true or C.skins.clique ~= true then return end

----------------------------------------------------------------------------------------
--	Clique skin
----------------------------------------------------------------------------------------
local function LoadSkin()
	if not C_AddOns.IsAddOnLoaded("Clique") then return end
	C_Timer.After(0.25, function()
	-- CliqueUIBindingFrame:StripTextures()
	-- CliqueUIBindingFrame:SetTemplate("Transparent")
	-- CliqueConfigPortrait:SetAlpha(0)

	-- CliqueConfigPage1Column1:StripTextures()
	-- CliqueConfigPage1Column2:StripTextures()
	-- CliqueConfigInset:StripTextures()
	-- CliqueConfigPage1_VSlider:StripTextures()

	-- CliqueClickGrabber:StripTextures()
	-- CliqueClickGrabber:CreateBackdrop("Overlay")
	-- CliqueClickGrabber.backdrop:SetPoint("TOPLEFT", -1, 0)
	-- CliqueClickGrabber.backdrop:SetPoint("BOTTOMRIGHT", 2, 3)

	-- CliqueDialog:StripTextures()
	-- CliqueDialog:SetTemplate("Transparent")

	-- T.SkinCloseButton(CliqueConfigCloseButton)
	-- if CliqueDialog.CloseButton then T.SkinCloseButton(CliqueDialog.CloseButton) end
	-- if CliqueDialogCloseButton then T.SkinCloseButton(CliqueDialogCloseButton) end

	-- CliqueConfigPage1ButtonOptions:SkinButton(true)
	-- CliqueConfigPage1ButtonOther:SkinButton(true)
	-- CliqueConfigPage1ButtonSpell:SkinButton(true)
	-- CliqueConfigPage2ButtonBinding:SkinButton()
	-- CliqueConfigPage2ButtonSave:SkinButton(true)
	-- CliqueConfigPage2ButtonCancel:SkinButton(true)
	-- CliqueDialogButtonBinding:SkinButton()
	-- CliqueDialogButtonAccept:SkinButton()

	-- if T.client == "ruRU" then
		-- CliqueConfigPage1ButtonSpell:SetWidth(130)
		-- CliqueConfigPage1ButtonSpellText:SetWidth(CliqueConfigPage1ButtonSpell:GetWidth())
		-- CliqueConfigPage1ButtonSpellText:SetHeight(CliqueConfigPage1ButtonSpell:GetHeight())
		-- CliqueConfigPage1ButtonOther:SetWidth(110)
	-- end

	-- CliqueConfigPage1:SetScript("OnShow", function()
		-- for i = 1, 12 do
			-- if _G["CliqueRow"..i] then
				-- _G["CliqueRow"..i.."Icon"]:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				-- _G["CliqueRow"..i.."Bind"]:ClearAllPoints()
				-- if _G["CliqueRow"..i] == CliqueRow1 then
					-- _G["CliqueRow"..i.."Bind"]:SetPoint("RIGHT", _G["CliqueRow"..i], 8, 0)
				-- else
					-- _G["CliqueRow"..i.."Bind"]:SetPoint("RIGHT", _G["CliqueRow"..i], -8, 0)
				-- end
			-- end
		-- end
		-- CliqueRow1:ClearAllPoints()
		-- CliqueRow1:SetPoint("TOPLEFT", 5, -(CliqueConfigPage1Column1:GetHeight() + 3))
	-- end)

	end)
end

local LoadTootlipSkin = CreateFrame("Frame")
LoadTootlipSkin:RegisterEvent("ADDON_LOADED")
LoadTootlipSkin:SetScript("OnEvent", function(self, _, addon)
	if C_AddOns.IsAddOnLoaded("Skinner") or C_AddOns.IsAddOnLoaded("Aurora")  then
		self:UnregisterEvent("ADDON_LOADED")
		return
	end

	if addon == "Blizzard_PlayerSpells" then
		-- LoadSkin()
	end
end)
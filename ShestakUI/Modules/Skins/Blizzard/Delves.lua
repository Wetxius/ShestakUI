local T, C, L = unpack(ShestakUI)
if C.skins.blizzard_frames ~= true then return end

----------------------------------------------------------------------------------------
--	Delves skin
----------------------------------------------------------------------------------------
local function LoadFirstSkin()
	local frame = _G.DelvesCompanionConfigurationFrame
	T.SkinFrame(frame)
	frame.CompanionConfigShowAbilitiesButton:SkinButton()
	frame.CompanionPortraitFrame:SetFrameLevel(10)

	local function SkinOptionSlot(frame, skip)
		local option = frame.OptionsList
		option:StripTextures()
		option:SetTemplate("Transparent")

		if not skip then
			hooksecurefunc(option.ScrollBox, "Update", function(self)
				self:ForEachFrame(function(button)
					if not button.IsSkinned then
						if button.Border then button.Border:SetAlpha(0) end
						if button.Icon then
							button.Icon:SkinIcon()
						end

						button.IsSkinned = true
					end
				end)
			end)
		end
	end

	SkinOptionSlot(frame.CompanionCombatRoleSlot, true)
	SkinOptionSlot(frame.CompanionUtilityTrinketSlot)
	SkinOptionSlot(frame.CompanionCombatTrinketSlot)

	local ablityFrame = _G.DelvesCompanionAbilityListFrame
	T.SkinFrame(ablityFrame)
	T.SkinDropDownBox(ablityFrame.DelvesCompanionRoleDropdown)
	T.SkinNextPrevButton(ablityFrame.DelvesCompanionAbilityListPagingControls.PrevPageButton, true)
	T.SkinNextPrevButton(ablityFrame.DelvesCompanionAbilityListPagingControls.NextPageButton)

	hooksecurefunc(ablityFrame, "UpdatePaginatedButtonDisplay", function(self)
		for _, button in pairs(self.buttons) do
			if not button.styled then
				if button.Icon then
					button.Icon:SkinIcon()
				end

				button.styled = true
			end
		end
	end)
end

T.SkinFuncs["Blizzard_DelvesCompanionConfiguration"] = LoadFirstSkin

local function LoadSecondSkin()
	local frame = _G.DelvesDifficultyPickerFrame
	T.SkinFrame(frame)

	T.SkinDropDownBox(frame.Dropdown)
	frame.EnterDelveButton:SkinButton()

	local function skinReward(rewardFrame)
		if not rewardFrame.IsSkinned then
			rewardFrame.NameFrame:SetAlpha(0)
			rewardFrame.Icon:SkinIcon()
			rewardFrame.IconBorder:SetAlpha(0)

			rewardFrame.IsSkinned = true
		end
	end

	hooksecurefunc(frame.DelveRewardsContainerFrame.ScrollBox, "Update", function(self)
		self:ForEachFrame(skinReward)
	end)
end

T.SkinFuncs["Blizzard_DelvesDifficultyPicker"] = LoadSecondSkin

local function LoadThirdSkin()
	local frame = _G.DelvesDashboardFrame
	frame.DashboardBackground:SetAlpha(0)
	frame.ButtonPanelLayoutFrame.CompanionConfigButtonPanel.CompanionConfigButton:SkinButton(nil, "Button")
	frame.ButtonPanelLayoutFrame.CompanionConfigButtonPanel.CompanionConfigButton:SetMovePoint(nil, 29)

	for _, panel in pairs({frame.ButtonPanelLayoutFrame.CompanionConfigButtonPanel, frame.ButtonPanelLayoutFrame.GreatVaultButtonPanel}) do
		panel.ButtonPanelBackground:SetAlpha(0)
		panel:CreateBackdrop("Overlay")
		panel.backdrop:SetInside(panel.ButtonPanelBackground, 6, 6)
	end
end

T.SkinFuncs["Blizzard_DelvesDashboardUI"] = LoadThirdSkin
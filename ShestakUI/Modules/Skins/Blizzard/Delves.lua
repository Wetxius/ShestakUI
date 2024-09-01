local T, C, L = unpack(ShestakUI)
if C.skins.blizzard_frames ~= true then return end

----------------------------------------------------------------------------------------
--	Delves skin
----------------------------------------------------------------------------------------
local function LoadFirstSkin()
	local CompanionConfigurationFrame = _G.DelvesCompanionConfigurationFrame
	T.SkinFrame(CompanionConfigurationFrame)
	CompanionConfigurationFrame.CompanionConfigShowAbilitiesButton:SkinButton()

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

	SkinOptionSlot(CompanionConfigurationFrame.CompanionCombatRoleSlot, true)
	SkinOptionSlot(CompanionConfigurationFrame.CompanionUtilityTrinketSlot)
	SkinOptionSlot(CompanionConfigurationFrame.CompanionCombatTrinketSlot)

	local CompanionAbilityListFrame = _G.DelvesCompanionAbilityListFrame
	T.SkinFrame(CompanionAbilityListFrame)
	T.SkinDropDownBox(CompanionAbilityListFrame.DelvesCompanionRoleDropdown)
	T.SkinNextPrevButton(CompanionAbilityListFrame.DelvesCompanionAbilityListPagingControls.PrevPageButton, true)
	T.SkinNextPrevButton(CompanionAbilityListFrame.DelvesCompanionAbilityListPagingControls.NextPageButton)
end

T.SkinFuncs["Blizzard_DelvesCompanionConfiguration"] = LoadFirstSkin

local function LoadSecondSkin()
	local DifficultyPickerFrame = _G.DelvesDifficultyPickerFrame
	T.SkinFrame(DifficultyPickerFrame)

	T.SkinDropDownBox(DifficultyPickerFrame.Dropdown)
	DifficultyPickerFrame.EnterDelveButton:SkinButton()

	hooksecurefunc(DifficultyPickerFrame.DelveRewardsContainerFrame, "SetRewards", function(frame)
		for rewardFrame in frame.rewardPool:EnumerateActive() do
			if not rewardFrame.IsSkinned then
				rewardFrame:CreateBackdrop("Transparent")
				rewardFrame.NameFrame:SetAlpha(0)
				rewardFrame.IconBorder:SetAlpha(0)
				rewardFrame.Icon:SkinIcon(true)

				rewardFrame.IsSkinned = true
			end
		end
	end)
end

T.SkinFuncs["Blizzard_DelvesDifficultyPicker"] = LoadSecondSkin

local function LoadThirdSkin()
	local Dashboard = _G.DelvesDashboardFrame
	Dashboard.DashboardBackground:SetAlpha(0)
	Dashboard.ButtonPanelLayoutFrame.CompanionConfigButtonPanel.CompanionConfigButton:SkinButton()
end

T.SkinFuncs["Blizzard_DelvesDashboardUI"] = LoadThirdSkin
local T, C, L = unpack(ShestakUI)
if C.skins.blizzard_frames ~= true then return end

----------------------------------------------------------------------------------------
--	Delves skin
----------------------------------------------------------------------------------------
local function LoadFirstSkin()
	local frame = _G.DelvesCompanionConfigurationFrame
	T.SkinFrame(frame)
	frame.CompanionConfigShowAbilitiesButton:SkinButton()

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

	hooksecurefunc(frame.DelveRewardsContainerFrame, "SetRewards", function(frame)
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
	local frame = _G.DelvesDashboardFrame
	frame.DashboardBackground:SetAlpha(0)
	frame.ButtonPanelLayoutFrame.CompanionConfigButtonPanel.CompanionConfigButton:SkinButton()
end

T.SkinFuncs["Blizzard_DelvesDashboardUI"] = LoadThirdSkin
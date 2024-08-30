local T, C, L = unpack(ShestakUI)
if C.skins.blizzard_frames ~= true then return end

----------------------------------------------------------------------------------------
--	Delves skin
----------------------------------------------------------------------------------------
local function LoadSkin()
	local CompanionConfigurationFrame = _G.DelvesCompanionConfigurationFrame
	T.SkinFrame(CompanionConfigurationFrame)
	CompanionConfigurationFrame.CompanionConfigShowAbilitiesButton:SkinButton()

	local function HandleButton(button)
		if button.IsSkinned then return end

		if button.Border then button.Border:SetAlpha(0) end
		if button.Icon then
			button.Icon:SkinIcon()
		end

		button.IsSkinned = true
	end

	local function UpdateButton(self)
		self:ForEachFrame(HandleButton)
	end

	local function HandleOptionSlot(frame, skip)
		local option = frame.OptionsList
		option:StripTextures()
		option:SetTemplate("Transparent")

		if not skip then
			hooksecurefunc(option.ScrollBox, "Update", UpdateButton)
		end
	end

	HandleOptionSlot(CompanionConfigurationFrame.CompanionCombatRoleSlot, true)
	HandleOptionSlot(CompanionConfigurationFrame.CompanionUtilityTrinketSlot)
	HandleOptionSlot(CompanionConfigurationFrame.CompanionCombatTrinketSlot)

	local CompanionAbilityListFrame = _G.DelvesCompanionAbilityListFrame
	T.SkinFrame(CompanionAbilityListFrame)
	T.SkinDropDownBox(CompanionAbilityListFrame.DelvesCompanionRoleDropdown)
	T.SkinNextPrevButton(CompanionAbilityListFrame.DelvesCompanionAbilityListPagingControls.PrevPageButton, true)
	T.SkinNextPrevButton(CompanionAbilityListFrame.DelvesCompanionAbilityListPagingControls.NextPageButton)
end

T.SkinFuncs["Blizzard_DelvesCompanionConfiguration"] = LoadSkin

local function LoadSkin()
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

T.SkinFuncs["Blizzard_DelvesDifficultyPicker"] = LoadSkin

local function LoadSkin()
	local Dashboard = _G.DelvesDashboardFrame
	Dashboard.DashboardBackground:SetAlpha(0)
	Dashboard.ButtonPanelLayoutFrame.CompanionConfigButtonPanel.CompanionConfigButton:SkinButton()
end

T.SkinFuncs["Blizzard_DelvesDashboardUI"] = LoadSkin
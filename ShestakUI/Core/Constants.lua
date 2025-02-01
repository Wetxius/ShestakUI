local T, C, L = unpack(ShestakUI)

----------------------------------------------------------------------------------------
--	ShestakUI variables
----------------------------------------------------------------------------------------
T.dummy = function() return end
T.name = UnitName("player")
T.class = select(2, UnitClass("player"))
T.level = UnitLevel("player")
T.client = GetLocale()
T.realm = GetRealmName()
T.color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[T.class]
T.version = C_AddOns.GetAddOnMetadata("ShestakUI", "Version")
T.screenWidth, T.screenHeight = GetPhysicalScreenSize()
T.newPatch = select(4, GetBuildInfo()) >= 110100

-- NOTE: Restore old function
GetContainerItemInfo = function(bagIndex, slotIndex)
	local info = C_Container.GetContainerItemInfo(bagIndex, slotIndex)
	if info then
		return info.iconFileID, info.stackCount, info.isLocked, info.quality, info.isReadable, info.hasLoot, info.hyperlink, info.isFiltered, info.hasNoValue, info.itemID, info.isBound
	end
end

UnitAura = function(unit, auraIndex, filter)
	return AuraUtil.UnpackAuraData(C_UnitAuras.GetAuraDataByIndex(unit, auraIndex, filter))
end

UnitBuff = function(unit, auraIndex, filter)
	return AuraUtil.UnpackAuraData(C_UnitAuras.GetBuffDataByIndex(unit, auraIndex, filter))
end

GetSpellInfo = function(data)
	local spellInfo = C_Spell.GetSpellInfo(data)
	if spellInfo then
		return spellInfo.name, nil, spellInfo.iconID, spellInfo.castTime, spellInfo.minRange, spellInfo.maxRange, spellInfo.spellID, spellInfo.originalIconID
	end
end

GetSpellCooldown = function(data)
	local info = C_Spell.GetSpellCooldown(data)
	if info then
		return info.startTime, info.duration, info.isEnabled, info.modRate
	end
end

local function EasyMenu_Initialize(frame, level, menuList)
	for index = 1, #menuList do
		local value = menuList[index]
		if value.text then
			value.index = index
			UIDropDownMenu_AddButton(value, level)
		end
	end
end

function EasyMenu(menuList, menuFrame, anchor, x, y, displayMode, autoHideDelay)
	if displayMode == "MENU"  then
		menuFrame.displayMode = displayMode
	end
	UIDropDownMenu_Initialize(menuFrame, EasyMenu_Initialize, displayMode, nil, menuList)
	ToggleDropDownMenu(1, nil, menuFrame, anchor, x, y, menuList, nil, autoHideDelay)
end
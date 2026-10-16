local T, C, L = unpack(ShestakUI)
if C.reminder.raid_buffs_enable ~= true then return end

----------------------------------------------------------------------------------------
--	Raid buffs on player(by Elv22)
----------------------------------------------------------------------------------------
local battleelixirbuffs = T.ReminderBuffs["BattleElixir"]
local guardianelixirbuffs = T.ReminderBuffs["GuardianElixir"]
local custombuffs = T.ReminderBuffs["Custom"]

local playerBuff = {}
local icons = {}
local UpdatePositions

local function CheckElixir()
	local battleelixir, guardianelixir
	if #battleelixirbuffs > 0 then
		for i = 1, #battleelixirbuffs do
			local name, icon = unpack(battleelixirbuffs[i])
			if playerBuff[name] then
				FlaskFrame.t:SetTexture(icon)
				battleelixir = true
				break
			else
				battleelixir = false
			end
		end
	end

	if #guardianelixirbuffs > 0 then
		for i = 1, #guardianelixirbuffs do
			local name, icon = unpack(guardianelixirbuffs[i])
			if playerBuff[name] then
				guardianelixir = true
				if not battleelixir then
					FlaskFrame.t:SetTexture(icon)
				end
				break
			else
				guardianelixir = false
			end
		end
	end

	if guardianelixir == true and battleelixir == true then
		FlaskFrame:SetAlpha(C.reminder.raid_buffs_alpha)
		flask = true
		return
	else
		FlaskFrame:SetAlpha(1)
		flask = false
	end
end

local function CheckBuff(list)
	local buffList = T.ReminderBuffs[list]
	local frame = _G[list.."Frame"]

	for i = 1, #buffList do
		local name, icon = unpack(buffList[i])
		if i == 1 then
			frame.t:SetTexture(icon)
		end
		if playerBuff[name] then
			frame:SetAlpha(C.reminder.raid_buffs_alpha)
			break
		else
			frame:SetAlpha(1)
			if list == "Flask" then
				CheckElixir()
			end
		end
	end
end

local function CheckWeaponBuff()
	local weaponBuff = false
	local weaponOffBuff = false
	local hasMainHandEnchant = C_PaperDollInfo.GetTemporaryEnchantmentInfo(INVSLOT_MAINHAND)
	local hasOffHandEnchant = C_PaperDollInfo.GetTemporaryEnchantmentInfo(INVSLOT_OFFHAND)
	if hasMainHandEnchant then
		weaponBuff = true
	end
	local OffhandHasWeapon = C_PaperDollInfo.OffhandHasWeapon()
	if not OffhandHasWeapon or OffhandHasWeapon and hasOffHandEnchant then
		weaponOffBuff = true
	end

	if weaponBuff == true and weaponOffBuff == true then
		WeaponFrame:SetAlpha(C.reminder.raid_buffs_alpha)
		weapon = true
		return
	else
		WeaponFrame:SetAlpha(1)
		weapon = false
	end
end

local function OnAuraChange(_, event, arg1)
	if (event == "UNIT_AURA" or event == "UNIT_INVENTORY_CHANGED") and arg1 ~= "player" then return end

	-- Hide frame when solo without option
	local _, instanceType = IsInInstance()
	if (not IsInGroup() or instanceType ~= "raid") and C.reminder.raid_buffs_always == false then
		RaidBuffReminder:SetAlpha(0)
		return
	end

	wipe(playerBuff)
	local isSecret
	local i = 1
	if not C_Secrets.ShouldAurasBeSecret() then
		while true do
			local name
			local auraData = C_UnitAuras.GetAuraDataByIndex("player", i, "HELPFUL")
			if auraData and not canaccessvalue(auraData.name) then isSecret = true end  -- BETA
			if auraData and canaccessvalue(auraData.name) then
				name = auraData.name
			end
			if not name then break end
			playerBuff[name] = true
			i = i + 1
		end
	else
		isSecret = true
	end

	-- Hide if found secret
	if isSecret then
		RaidBuffReminder:SetAlpha(0)
		return
	else
		RaidBuffReminder:SetAlpha(1)
	end

	-- Check for our role
	if T.Role == "Caster" or T.Role == "Healer" then
		T.ReminderCasterBuffs()
	else
		T.ReminderPhysicalBuffs()
	end

	-- Start checking buffs to see if we can find a match from the list
	CheckBuff("Flask")
	CheckBuff("Food")

	do
		WeaponFrame.t:SetTexture(135250)
		CheckWeaponBuff()
	end

	CheckBuff("Stamina")
	CheckBuff("Vers")
	CheckBuff("Spell4")
	CheckBuff("Reduce")

	if #custombuffs > 0 then
		CheckBuff("Custom")
	else
		CustomFrame:Hide()
		custom = true
	end

	UpdatePositions()
end

-- Create Anchor
local RaidBuffsAnchor = CreateFrame("Frame", "RaidBuffsAnchor", UIParent)
RaidBuffsAnchor:SetWidth((C.reminder.raid_buffs_size * 6) + 15)
RaidBuffsAnchor:SetHeight(C.reminder.raid_buffs_size)
RaidBuffsAnchor:SetPoint(unpack(C.position.raid_buffs))

-- Create Main bar
local raidbuff_reminder = CreateFrame("Frame", "RaidBuffReminder", UIParent)
raidbuff_reminder:CreatePanel("Invisible", (C.reminder.raid_buffs_size * 6) + 15, C.reminder.raid_buffs_size + 4, "TOPLEFT", RaidBuffsAnchor, "TOPLEFT", 0, 4)
raidbuff_reminder:RegisterEvent("UNIT_AURA")
raidbuff_reminder:RegisterEvent("PLAYER_ENTERING_WORLD")
raidbuff_reminder:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
raidbuff_reminder:RegisterEvent("ZONE_CHANGED_NEW_AREA")
raidbuff_reminder:RegisterEvent("UNIT_INVENTORY_CHANGED")
raidbuff_reminder:SetScript("OnEvent", OnAuraChange)

local line = math.ceil(C.minimap.size / (C.reminder.raid_buffs_size + 2))

local buffButtons = {
	"FlaskFrame",
	"FoodFrame",
	"WeaponFrame",
	"StaminaFrame",
	"VersFrame",
	"Spell4Frame",
	"ReduceFrame",
	"CustomFrame",
}

local color = C.reminder.raid_buffs_classcolor and "ClassColor" or "Default"
for i = 1, #buffButtons do
	local name = buffButtons[i]
	local button = CreateFrame("Frame", name, RaidBuffReminder)
	if i == 1 then
		button:CreatePanel(color, C.reminder.raid_buffs_size, C.reminder.raid_buffs_size, "BOTTOMLEFT", RaidBuffReminder, "BOTTOMLEFT", 0, 0)
	elseif i == line then
		button:CreatePanel(color, C.reminder.raid_buffs_size, C.reminder.raid_buffs_size, "BOTTOM", buffButtons[1], "TOP", 0, 3)
	else
		button:CreatePanel(color, C.reminder.raid_buffs_size, C.reminder.raid_buffs_size, "LEFT", buffButtons[i-1], "RIGHT", 3, 0)
	end
	button:SetFrameLevel(RaidBuffReminder:GetFrameLevel() + 2)

	button.t = button:CreateTexture(name..".t", "OVERLAY")
	button.t:CropIcon()
	tinsert(icons, button)
end

function UpdatePositions()
	local line = math.ceil(C.minimap.size / (C.reminder.raid_buffs_size + 2))
	local first, previousBuff
	for i = 1, #icons do
		local buff = icons[i]
		buff:ClearAllPoints()
		if buff:GetAlpha() == C.reminder.raid_buffs_alpha then
			line = line + 1
		else
			if not first then
				buff:SetPoint("BOTTOMLEFT", RaidBuffReminder, "BOTTOMLEFT", 0, 0)
				first = true
			else
				buff:SetPoint("LEFT", previousBuff, "RIGHT", 3, 0)
			end
			previousBuff = buff
			if i >= line then
				buff:SetAlpha(0)
			else
				buff:SetAlpha(1)
			end
		end
	end
end
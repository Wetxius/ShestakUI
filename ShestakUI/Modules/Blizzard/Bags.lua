local T, C, L = unpack(ShestakUI)
if C.bag.enable ~= true then return end

----------------------------------------------------------------------------------------
--	Based on Stuffing(by Hungtar, editor Tukz)
----------------------------------------------------------------------------------------
local BAGS_BACKPACK = {0, 1, 2, 3, 4, 5}
local BAGS_BANK = {6, 7, 8, 9, 10, 11}
local BAGS_BANK_1 = {6, 7, 8}
local BAGS_BANK_2 = {9, 10, 11}
local BAGS_WARBAND = {12, 13, 14, 15, 16}
local BAGS_WARBAND_1 = {12, 13, 14}
local BAGS_WARBAND_2 = {15, 16}
local ST_NORMAL = 1
local ST_FISHBAG = 2
local ST_SPECIAL = 3
local bag_bars = 0
local unusable

-- Unfit-1.0 Library
if T.class == "DEATHKNIGHT" then
	unusable = { -- weapon, armor, dual-wield
		{Enum.ItemWeaponSubclass.Bows, Enum.ItemWeaponSubclass.Guns, Enum.ItemWeaponSubclass.Warglaive, Enum.ItemWeaponSubclass.Staff, Enum.ItemWeaponSubclass.Unarmed, Enum.ItemWeaponSubclass.Dagger, Enum.ItemWeaponSubclass.Thrown, Enum.ItemWeaponSubclass.Crossbow, Enum.ItemWeaponSubclass.Wand},
		{Enum.ItemArmorSubclass.Shield}
	}
elseif T.class == "DEMONHUNTER" then
	unusable = {
		{Enum.ItemWeaponSubclass.Axe2H, Enum.ItemWeaponSubclass.Bows, Enum.ItemWeaponSubclass.Guns, Enum.ItemWeaponSubclass.Mace1H, Enum.ItemWeaponSubclass.Mace2H, Enum.ItemWeaponSubclass.Polearm, Enum.ItemWeaponSubclass.Sword2H, Enum.ItemWeaponSubclass.Staff, Enum.ItemWeaponSubclass.Thrown, Enum.ItemWeaponSubclass.Crossbow, Enum.ItemWeaponSubclass.Wand},
		{Enum.ItemArmorSubclass.Mail, Enum.ItemArmorSubclass.Plate, Enum.ItemArmorSubclass.Shield}
	}
elseif T.class == "DRUID" then
	unusable = {
		{Enum.ItemWeaponSubclass.Axe1H, Enum.ItemWeaponSubclass.Axe2H, Enum.ItemWeaponSubclass.Bows, Enum.ItemWeaponSubclass.Guns, Enum.ItemWeaponSubclass.Sword1H, Enum.ItemWeaponSubclass.Sword2H, Enum.ItemWeaponSubclass.Warglaive, Enum.ItemWeaponSubclass.Thrown, Enum.ItemWeaponSubclass.Crossbow, Enum.ItemWeaponSubclass.Wand},
		{Enum.ItemArmorSubclass.Mail, Enum.ItemArmorSubclass.Plate, Enum.ItemArmorSubclass.Shield},
		true
	}
elseif T.class == "EVOKER" then
	unusable = {
		{Enum.ItemWeaponSubclass.Bows, Enum.ItemWeaponSubclass.Guns, Enum.ItemWeaponSubclass.Polearm, Enum.ItemWeaponSubclass.Warglaive, Enum.ItemWeaponSubclass.Thrown, Enum.ItemWeaponSubclass.Crossbow, Enum.ItemWeaponSubclass.Wand},
		{Enum.ItemArmorSubclass.Plate, Enum.ItemArmorSubclass.Shield},
		true
	}
elseif T.class == "HUNTER" then
	unusable = {
		{Enum.ItemWeaponSubclass.Mace1H, Enum.ItemWeaponSubclass.Mace2H, Enum.ItemWeaponSubclass.Warglaive, Enum.ItemWeaponSubclass.Thrown, Enum.ItemWeaponSubclass.Wand},
		{Enum.ItemArmorSubclass.Plate, Enum.ItemArmorSubclass.Shield}
	}
elseif T.class == "MAGE" then
	unusable = {
		{Enum.ItemWeaponSubclass.Axe1H, Enum.ItemWeaponSubclass.Axe2H, Enum.ItemWeaponSubclass.Bows, Enum.ItemWeaponSubclass.Guns, Enum.ItemWeaponSubclass.Mace1H, Enum.ItemWeaponSubclass.Mace2H, Enum.ItemWeaponSubclass.Polearm, Enum.ItemWeaponSubclass.Sword2H, Enum.ItemWeaponSubclass.Warglaive, Enum.ItemWeaponSubclass.Unarmed, Enum.ItemWeaponSubclass.Thrown, Enum.ItemWeaponSubclass.Crossbow},
		{Enum.ItemArmorSubclass.Leather, Enum.ItemArmorSubclass.Mail, Enum.ItemArmorSubclass.Plate, Enum.ItemArmorSubclass.Shield},
		true
	}
elseif T.class == "MONK" then
	unusable = {
		{Enum.ItemWeaponSubclass.Axe2H, Enum.ItemWeaponSubclass.Bows, Enum.ItemWeaponSubclass.Guns, Enum.ItemWeaponSubclass.Mace2H, Enum.ItemWeaponSubclass.Sword2H, Enum.ItemWeaponSubclass.Warglaive, Enum.ItemWeaponSubclass.Dagger, Enum.ItemWeaponSubclass.Thrown, Enum.ItemWeaponSubclass.Crossbow, Enum.ItemWeaponSubclass.Wand},
		{Enum.ItemArmorSubclass.Mail, Enum.ItemArmorSubclass.Plate, Enum.ItemArmorSubclass.Shield}
	}
elseif T.class == "PALADIN" then
	unusable = {
		{Enum.ItemWeaponSubclass.Bows, Enum.ItemWeaponSubclass.Guns, Enum.ItemWeaponSubclass.Warglaive, Enum.ItemWeaponSubclass.Staff, Enum.ItemWeaponSubclass.Unarmed, Enum.ItemWeaponSubclass.Dagger, Enum.ItemWeaponSubclass.Thrown, Enum.ItemWeaponSubclass.Crossbow, Enum.ItemWeaponSubclass.Wand},
		{},
		true
	}
elseif T.class == "PRIEST" then
	unusable = {
		{Enum.ItemWeaponSubclass.Axe1H, Enum.ItemWeaponSubclass.Axe2H, Enum.ItemWeaponSubclass.Bows, Enum.ItemWeaponSubclass.Guns, Enum.ItemWeaponSubclass.Mace2H, Enum.ItemWeaponSubclass.Polearm, Enum.ItemWeaponSubclass.Sword1H, Enum.ItemWeaponSubclass.Sword2H, Enum.ItemWeaponSubclass.Warglaive, Enum.ItemWeaponSubclass.Unarmed, Enum.ItemWeaponSubclass.Thrown, Enum.ItemWeaponSubclass.Crossbow},
		{Enum.ItemArmorSubclass.Leather, Enum.ItemArmorSubclass.Mail, Enum.ItemArmorSubclass.Plate, Enum.ItemArmorSubclass.Shield},
		true
	}
elseif T.class == "ROGUE" then
	unusable = {
		{Enum.ItemWeaponSubclass.Axe2H, Enum.ItemWeaponSubclass.Mace2H, Enum.ItemWeaponSubclass.Polearm, Enum.ItemWeaponSubclass.Sword2H, Enum.ItemWeaponSubclass.Warglaive, Enum.ItemWeaponSubclass.Staff, Enum.ItemWeaponSubclass.Wand},
		{Enum.ItemArmorSubclass.Mail, Enum.ItemArmorSubclass.Plate, Enum.ItemArmorSubclass.Shield}
	}
elseif T.class == "SHAMAN" then
	unusable = {
		{Enum.ItemWeaponSubclass.Bows, Enum.ItemWeaponSubclass.Guns, Enum.ItemWeaponSubclass.Polearm, Enum.ItemWeaponSubclass.Sword1H, Enum.ItemWeaponSubclass.Sword2H, Enum.ItemWeaponSubclass.Warglaive, Enum.ItemWeaponSubclass.Thrown, Enum.ItemWeaponSubclass.Crossbow, Enum.ItemWeaponSubclass.Wand},
		{Enum.ItemArmorSubclass.Plate}
	}
elseif T.class == "WARLOCK" then
	unusable = {
		{Enum.ItemWeaponSubclass.Axe1H, Enum.ItemWeaponSubclass.Axe2H, Enum.ItemWeaponSubclass.Bows, Enum.ItemWeaponSubclass.Guns, Enum.ItemWeaponSubclass.Mace1H, Enum.ItemWeaponSubclass.Mace2H, Enum.ItemWeaponSubclass.Polearm, Enum.ItemWeaponSubclass.Sword2H, Enum.ItemWeaponSubclass.Warglaive, Enum.ItemWeaponSubclass.Unarmed, Enum.ItemWeaponSubclass.Thrown, Enum.ItemWeaponSubclass.Crossbow},
		{Enum.ItemArmorSubclass.Leather, Enum.ItemArmorSubclass.Mail, Enum.ItemArmorSubclass.Plate, Enum.ItemArmorSubclass.Shield},
		true
	}
elseif T.class == "WARRIOR" then
	unusable = {{Enum.ItemWeaponSubclass.Warglaive, Enum.ItemWeaponSubclass.Wand}, {}}
else
	unusable = {{}, {}}
end

local _unusable = {}

for i, class in ipairs({Enum.ItemClass.Weapon, Enum.ItemClass.Armor}) do
	local list = {}
	for _, subclass in ipairs(unusable[i]) do
		list[subclass] = true
	end

	_unusable[class] = list
end

local function IsClassUnusable(class, subclass, slot)
	if class and subclass and _unusable[class] then
		return slot ~= "" and _unusable[class][subclass] or slot == "INVTYPE_WEAPONOFFHAND" and unusable[3]
	end
end

local function IsItemUnusable(...)
	if ... then
		local slot, _,_, class, subclass = select(9, C_Item.GetItemInfo(...))
		return IsClassUnusable(class, subclass, slot)
	end
end

Stuffing = CreateFrame("Frame", nil, UIParent)
Stuffing:RegisterEvent("ADDON_LOADED")
Stuffing:RegisterEvent("PLAYER_ENTERING_WORLD")
Stuffing:SetScript("OnEvent", function(this, event, ...)
	if T.anotherBags then return end
	Stuffing[event](this, ...)
end)

-- Drop down menu stuff from Postal
local Stuffing_DDMenu = CreateFrame("Frame", "StuffingDropDownMenu")
Stuffing_DDMenu.displayMode = "MENU"
Stuffing_DDMenu.info = {}
Stuffing_DDMenu.HideMenu = function()
	if UIDROPDOWNMENU_OPEN_MENU == Stuffing_DDMenu then
		CloseDropDownMenus()
	end
end

local function Stuffing_OnShow()
	Stuffing:PLAYERBANKSLOTS_CHANGED(29)

	for i = 0, #BAGS_BACKPACK - 1 do
		Stuffing:BAG_UPDATE(i)
	end

	Stuffing:Layout()
	Stuffing:SearchReset()
	PlaySound(SOUNDKIT.IG_BACKPACK_OPEN)
end

local function StuffingBank_OnHide() -- close bank frame
	if Stuffing.warbandFrame and Stuffing.warbandFrame:IsShown() then return end	-- fallback when switch layout
	C_Bank.CloseBankFrame()
	if Stuffing.frame:IsShown() then
		Stuffing.frame:Hide()
	end
	PlaySound(SOUNDKIT.IG_BACKPACK_CLOSE)
end

local function StuffingWarband_OnHide() -- close account warband frame
	if Stuffing.bankFrame and Stuffing.bankFrame:IsShown() then return end	-- fallback when switch layout
	C_Bank.CloseBankFrame()
	if Stuffing.frame:IsShown() then
		Stuffing.frame:Hide()
	end
	PlaySound(SOUNDKIT.IG_BACKPACK_CLOSE)
end

local function Stuffing_OnHide() -- close main bags
	if Stuffing.warbandFrame and Stuffing.warbandFrame:IsShown() then
		C_Bank.CloseBankFrame()
		Stuffing.warbandFrame:Hide()
	end
	if Stuffing.bankFrame and Stuffing.bankFrame:IsShown() then
		Stuffing.bankFrame:Hide()
	end
	PlaySound(SOUNDKIT.IG_BACKPACK_CLOSE)
end

local function Stuffing_Open() -- open main bags
	if not Stuffing.frame:IsShown() then
		Stuffing.frame:Show()
	end
end

local function Stuffing_Close() -- call Stuffing_OnHide()
	C_Timer.After(0.01, function() -- fix showing GameMenu when pressing ESC
		if Stuffing.frame:IsShown() then
			Stuffing.frame:Hide()
		end
	end)
end

local function Stuffing_Toggle() -- toggle main bags
	if Stuffing.frame:IsShown() then
		Stuffing.frame:Hide()
	else
		Stuffing.frame:Show()
	end
end

-- Bag slot stuff
local trashButton = {}
local trashBag = {}

local ItemDB = {}
local function _getRealItemLevel(link, bag, slot)
	if ItemDB[link] then return ItemDB[link] end

	local realItemLevel = C_Item.GetCurrentItemLevel(ItemLocation:CreateFromBagAndSlot(bag, slot))

	ItemDB[link] = tonumber(realItemLevel)
	return realItemLevel
end

local itemSpellID = {
	-- Deposit Anima: Infuse (value) stored Anima into your covenant's Reservoir.
	[347555] = 3,
	[345706] = 5,
	[336327] = 35,
	[336456] = 250,

	-- Deliver Relic: Submit your findings to Archivist Roh-Suir to generate (value) Cataloged Research.
	[356931] = 6,
	[356933] = 1,
	[356934] = 8,
	[356935] = 16,
	[356936] = 48,
	[356937] = 26,
	[356938] = 100,
	[356939] = 150,
	[356940] = 300
}

function Stuffing:SlotUpdate(b)
	local info = C_Container.GetContainerItemInfo(b.bag, b.slot)
	local count, locked, quality, clink
	if info then
		count, locked, quality, clink = info.stackCount, info.isLocked, info.quality, info.hyperlink
	end
	local texture = info and info.iconFileID or 0
	local questData = C_Container.GetContainerItemQuestInfo(b.bag, b.slot)
	local isQuestItem, questId, isActiveQuest = questData.isQuestItem, questData.questID, questData.isActive
	local itemIsUpgrade

	-- Set all slot color to default ShestakUI on update
	if not b.frame.lock then
		b.frame:SetBackdropBorderColor(unpack(C.media.border_color))
	end

	if b.cooldown and StuffingFrameBags and StuffingFrameBags:IsShown() then
		local start, duration, enable = C_Container.GetContainerItemCooldown(b.bag, b.slot)
		CooldownFrame_Set(b.cooldown, start, duration, enable)
	end

	if C.bag.ilvl == true then
		b.frame.text:SetText("")
	end

	b.frame.Azerite:Hide()
	b.frame.Conduit:Hide()
	b.frame.Conduit2:Hide()
	b.frame.Cosmetic:Hide()
	b.frame.profQuality:Hide()

	b.frame:UpdateItemContextMatching() -- Update Scrap items

	if b.frame.UpgradeIcon then
		b.frame.UpgradeIcon:SetPoint("TOPLEFT", C.bag.button_size/2.7, -C.bag.button_size/2.7)
		b.frame.UpgradeIcon:SetSize(C.bag.button_size/1.7, C.bag.button_size/1.7)
		-- Use Pawn's (third-party addon) function if present; else fallback to Blizzard's.
		-- 10.0.2 Build 46658 No longer have IsContainerItemAnUpgrade
		itemIsUpgrade = PawnIsContainerItemAnUpgrade and PawnIsContainerItemAnUpgrade(b.frame:GetParent():GetID(), b.frame:GetID())
		b.frame.UpgradeIcon:SetShown(itemIsUpgrade or false)
	end

	if C_AddOns.IsAddOnLoaded("CanIMogIt") then
		CIMI_AddToFrame(b.frame, ContainerFrame_CIMIUpdateIcon)
		ContainerFrame_CIMIUpdateIcon(b.frame.CanIMogItOverlay)
	end

	if clink then
		b.name, _, _, b.itemlevel, b.level, _, _, _, _, _, _, b.itemClassID, b.itemSubClassID = C_Item.GetItemInfo(clink)
		_, b.spellID = C_Item.GetItemSpell(clink) -- for anima

		if C.bag.ilvl then
			if info.itemID == 82800 then -- pet
				local _, petLevel, petName = strmatch(clink, "|H%w+:(%d+):(%d+):.-|h%[(.-)%]|h")
				b.name = petName
				b.itemlevel = petLevel
				b.frame.text:SetText(b.itemlevel)
			elseif info.itemID == 180653 or info.itemID == 187786 or info.itemID == 151086 then -- keystone
				b.itemlevel = strmatch(clink, "%d+:%d+:(%d+)")
				b.itemlevel = tonumber(b.itemlevel) or 0
				b.frame.text:SetText(b.itemlevel)
			else
				if b.itemlevel and b.itemlevel > 1 and quality > 1 and (b.itemClassID == 2 or b.itemClassID == 4 or (b.itemClassID == 3 and b.itemSubClassID == 11)) then
					b.itemlevel = _getRealItemLevel(clink, b.bag, b.slot) or b.itemlevel
					b.frame.text:SetText(b.itemlevel)
				end
			end
		end

		if not b.name then	-- Keystone doesn't have name
			b.name = clink:match("%[(.-)%]") or ""
		end

		if C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID(clink) then
			b.frame.Azerite:SetAtlas("AzeriteIconFrame")
			b.frame.Azerite:Show()
		elseif C_Item.IsCosmeticItem(clink) then
			b.frame.Cosmetic:Show()
		elseif C_Soulbinds.IsItemConduitByItemInfo(clink) then
			b.frame.Conduit:SetAtlas("ConduitIconFrame")
			b.frame.Conduit:Show()
			local color = BAG_ITEM_QUALITY_COLORS[quality]
			if color then
				b.frame.Conduit:SetVertexColor(color.r, color.g, color.b)
			end
			b.frame.Conduit2:SetAtlas("ConduitIconFrame-Corners")
			b.frame.Conduit2:Show()
		end

		local profQual = C_TradeSkillUI.GetItemReagentQualityByItemInfo(clink) or C_TradeSkillUI.GetItemCraftedQualityByItemInfo(clink)
		if profQual then
			local atlas = ("Professions-Icon-Quality-Tier%d-Inv"):format(profQual)
			b.frame.profQuality:SetAtlas(atlas, TextureKitConstants.UseAtlasSize)
			b.frame.profQuality:Show()
		end

		if (IsItemUnusable(clink) or b.level and b.level > T.level) and not locked then
			_G[b.frame:GetName().."IconTexture"]:SetVertexColor(1, 0.1, 0.1)
		else
			_G[b.frame:GetName().."IconTexture"]:SetVertexColor(1, 1, 1)
		end

		-- Color slot according to item quality
		if not b.frame.lock and quality and quality > 1 and not (isQuestItem or questId) then
			local R, G, B = C_Item.GetItemQualityColor(quality)
			if b.frame then
				b.frame:SetBackdropBorderColor(R, G, B)
			end
		elseif questId and not isActiveQuest then
			b.frame:SetBackdropBorderColor(1, 0.3, 0.3)
		elseif questId or isQuestItem then
			b.frame:SetBackdropBorderColor(1, 1, 0)
		end
	else
		b.name, b.level = nil, nil
	end

	SetItemButtonTexture(b.frame, texture)
	SetItemButtonCount(b.frame, count)
	SetItemButtonDesaturated(b.frame, locked)

	local mult = itemSpellID[b.spellID]
	if mult and count then
		b.count:SetText(mult * count) -- replace item count with anima count
		b.count:SetTextColor(1, 1, 0)
	end

	if C.bag.new_items then
		local IsNewItem = C_NewItems.IsNewItem(b.bag, b.slot)
		if IsNewItem then
			if not b.frame.Animation then
				b.frame.Animation = b.frame:CreateAnimationGroup()
				b.frame.Animation:SetLooping("BOUNCE")

				b.frame.Animation.FadeOut = b.frame.Animation:CreateAnimation("Alpha")
				b.frame.Animation.FadeOut:SetFromAlpha(1)
				b.frame.Animation.FadeOut:SetToAlpha(0.6)
				b.frame.Animation.FadeOut:SetDuration(0.4)
				b.frame.Animation.FadeOut:SetSmoothing("IN_OUT")
				b.frame:HookScript("OnEnter", function()
					local IsNewItem = C_NewItems.IsNewItem(b.bag, b.slot)

					if not IsNewItem and b.frame.Animation:IsPlaying() then
						b.frame.Animation:Stop()
					end
				end)
			end

			if not b.frame.Animation:IsPlaying() then
				b.frame.Animation:Play()
			end
		end
	end

	b.frame:Show()
end

function Stuffing:BagSlotUpdate(bag)
	if not self.buttons then
		return
	end

	for _, v in ipairs(self.buttons) do
		if v.bag == bag then
			self:SlotUpdate(v)
		end
	end
end

function Stuffing:UpdateCooldowns(b)
	if b.cooldown and StuffingFrameBags and StuffingFrameBags:IsShown() then
		local start, duration, enable = C_Container.GetContainerItemCooldown(b.bag, b.slot)
		CooldownFrame_Set(b.cooldown, start, duration, enable)
	end
end

local function AddBankTabSettingsToTooltip(tooltip, depositFlags)
	if not tooltip or not depositFlags then return end

	if FlagsUtil.IsSet(depositFlags, Enum.BagSlotFlags.ExpansionCurrent) then
		GameTooltip_AddNormalLine(tooltip, BANK_TAB_EXPANSION_ASSIGNMENT:format(BANK_TAB_EXPANSION_FILTER_CURRENT))
	elseif FlagsUtil.IsSet(depositFlags, Enum.BagSlotFlags.ExpansionLegacy) then
		GameTooltip_AddNormalLine(tooltip, BANK_TAB_EXPANSION_ASSIGNMENT:format(BANK_TAB_EXPANSION_FILTER_LEGACY))
	end

	local filterList = ContainerFrameUtil_ConvertFilterFlagsToList(depositFlags)
	if filterList then
		GameTooltip_AddNormalLine(tooltip, BANK_TAB_DEPOSIT_ASSIGNMENTS:format(filterList), true)
	end
end

function Stuffing:BagFrameSlotNew(p, slot)
	for _, v in ipairs(self.bagframe_buttons) do
		if v.slot == slot then
			return v, false
		end
	end

	local ret = {}

	-- Bank and Account
	if slot > 5 then
		ret.slot = slot
		local name = slot >= 12 and "StuffingABag" or "StuffingBBag"
		slot = slot >= 12 and slot - 11 or slot - 5
		ret.frame = CreateFrame("ItemButton", name..slot.."Slot", p, "")
		Mixin(ret.frame, BackdropTemplateMixin)

		ret.frame:SetID(ret.slot)
		ret.frame.bagID = slot

		_G[ret.frame:GetName().."IconTexture"]:SetTexture(136511)

		local tooltip_show = function(self)
			if not BankFrame.BankPanel.purchasedBankTabData then return end
			local data = BankFrame.BankPanel.purchasedBankTabData[self.bagID]
			if not data then return end

			GameTooltip:SetOwner(self, "ANCHOR_LEFT", 19, 7)
			GameTooltip:ClearLines()
			GameTooltip_SetTitle(GameTooltip, data.name, NORMAL_FONT_COLOR)
			AddBankTabSettingsToTooltip(GameTooltip, data.depositFlags)
			GameTooltip_AddInstructionLine(GameTooltip, BANK_TAB_TOOLTIP_CLICK_INSTRUCTION)
			GameTooltip:Show()
		end

		ret.frame:HookScript("OnEnter", tooltip_show)
		ret.frame:HookScript("OnLeave", function() GameTooltip:Hide() end)

		table.insert(self.bagframe_buttons, ret)
	else
		ret.frame = CreateFrame("ItemButton", "StuffingFBag"..(slot + 1).."Slot", p, "")
		Mixin(ret.frame, BackdropTemplateMixin)

		ret.frame.ID = C_Container.ContainerIDToInventoryID(slot + 1)
		local bag_tex = GetInventoryItemTexture("player", ret.frame.ID)
		_G[ret.frame:GetName().."IconTexture"]:SetTexture(bag_tex)
		ret.frame:SetID(ret.frame.ID)

		ret.frame:RegisterForDrag("LeftButton")
		ret.frame:SetScript("OnDragStart", function(self)
			PickupBagFromSlot(self:GetID())
		end)
		ret.frame:SetScript("OnReceiveDrag", function(self)
			PutItemInBag(self:GetID())
		end)

		local tooltip_show = function(self)
			GameTooltip:SetOwner(self, "ANCHOR_LEFT", 19, 7)
			GameTooltip:ClearLines()
			if GetInventoryItemLink("player", ret.frame.ID) then
				GameTooltip:SetInventoryItem("player", self:GetID())
			else
				local text = ret.slot == 4 and EQUIP_CONTAINER_REAGENT or EQUIP_CONTAINER
				GameTooltip:AddLine(text)
				GameTooltip:Show()
			end
		end

		ret.frame:HookScript("OnEnter", tooltip_show)
		ret.frame:HookScript("OnLeave", function() GameTooltip:Hide() end)

		local quality = GetInventoryItemQuality("player", ret.frame.ID)
		if quality then
			ret.frame.quality = quality
		-- else
			-- C_Timer.After(1, function() -- TODO: Test it if quality not returned after first open
				-- ret.frame.quality = GetInventoryItemQuality("player", ret.frame.ID)
			-- end)
		end

		ret.slot = slot
		table.insert(self.bagframe_buttons, ret)
	end

	ret.frame:StyleButton()
	ret.frame:SetTemplate("Default")
	ret.frame:SetNormalTexture((0))

	ret.icon = _G[ret.frame:GetName().."IconTexture"]
	ret.icon:CropIcon()

	-- C_Timer.After(2, function() -- TODO: Test it if quality not returned after first open
	if ret.frame.quality and ret.frame.quality > 1 then
		local r, g, b = C_Item.GetItemQualityColor(ret.frame.quality)
		ret.frame:SetBackdropBorderColor(r, g, b)
	end
	-- end)

	return ret
end

function Stuffing:SlotNew(bag, slot)
	for _, v in ipairs(self.buttons) do
		if v.bag == bag and v.slot == slot then
			v.lock = false
			return v, false
		end
	end

	local tpl = "ContainerFrameItemButtonTemplate"

	if bag == -1 then
		tpl = "BankItemButtonGenericTemplate"
	end

	local ret = {}

	if #trashButton > 0 then
		local f = -1
		for i, v in ipairs(trashButton) do
			local b, s = v:GetName():match("(%d+)_(%d+)")

			b = tonumber(b)
			s = tonumber(s)

			if b == bag and s == slot then
				f = i
				break
			else
				v:Hide()
			end
		end

		if f ~= -1 then
			ret.frame = trashButton[f]
			table.remove(trashButton, f)
			ret.frame:Show()
		end
	end

	if not ret.frame then
		ret.frame = CreateFrame("ItemButton", "StuffingBag"..bag.."_"..slot, self.bags[bag], tpl)
		ret.frame:StyleButton()
		ret.frame:SetTemplate("Default")
		ret.frame:SetNormalTexture(0)
		ret.frame:SetFrameStrata("HIGH")
		ret.frame:SetFrameLevel(20)

		ret.icon = _G[ret.frame:GetName().."IconTexture"]
		ret.icon:CropIcon()

		ret.count = _G[ret.frame:GetName().."Count"]
		ret.count:SetFont(C.font.bags_font, C.font.bags_font_size, C.font.bags_font_style)
		ret.count:SetShadowOffset(C.font.bags_font_shadow and 1 or 0, C.font.bags_font_shadow and -1 or 0)
		ret.count:SetPoint("BOTTOMRIGHT", 1, 1)

		if C.bag.ilvl == true then
			ret.frame.text = ret.frame:CreateFontString(nil, "ARTWORK")
			ret.frame.text:SetFont(C.font.bags_font, C.font.bags_font_size, C.font.bags_font_style)
			ret.frame.text:SetPoint("TOPLEFT", 1, -1)
			ret.frame.text:SetTextColor(1, 1, 0)
		end

		ret.frame.Azerite = ret.frame:CreateTexture(nil, "ARTWORK")
		ret.frame.Azerite:SetAtlas("AzeriteIconFrame")
		ret.frame.Azerite:SetPoint("TOPLEFT", ret.frame, 1, -1)
		ret.frame.Azerite:SetPoint("BOTTOMRIGHT", ret.frame, -1, 1)
		ret.frame.Azerite:Hide()

		ret.frame.Conduit = ret.frame:CreateTexture(nil, "ARTWORK")
		ret.frame.Conduit:SetAtlas("ConduitIconFrame")
		ret.frame.Conduit:SetPoint("TOPLEFT", ret.frame, 2, -2)
		ret.frame.Conduit:SetPoint("BOTTOMRIGHT", ret.frame, -2, 2)
		ret.frame.Conduit:Hide()

		ret.frame.Conduit2 = ret.frame:CreateTexture(nil, "ARTWORK")
		ret.frame.Conduit2:SetAtlas("ConduitIconFrame-Corners")
		ret.frame.Conduit2:SetPoint("TOPLEFT", ret.frame, 2, -2)
		ret.frame.Conduit2:SetPoint("BOTTOMRIGHT", ret.frame, -2, 2)
		ret.frame.Conduit2:Hide()

		ret.frame.Cosmetic = ret.frame:CreateTexture(nil, "ARTWORK")
		ret.frame.Cosmetic:SetAtlas("CosmeticIconFrame")
		ret.frame.Cosmetic:SetPoint("TOPLEFT", ret.frame, 2, -2)
		ret.frame.Cosmetic:SetPoint("BOTTOMRIGHT", ret.frame, -2, 2)
		ret.frame.Cosmetic:Hide()

		ret.frame.profQuality = ret.frame:CreateTexture(nil, "ARTWORK")
		ret.frame.profQuality:SetPoint("TOPLEFT", ret.frame, 0, 0)
		ret.frame.profQuality:Hide()

		local Battlepay = _G[ret.frame:GetName()].BattlepayItemTexture
		if Battlepay then
			Battlepay:SetAlpha(0)
		end
	end

	ret.bag = bag
	ret.slot = slot
	ret.frame:SetID(slot)

	ret.cooldown = _G[ret.frame:GetName().."Cooldown"]
	ret.cooldown:Show()

	self:SlotUpdate(ret)

	return ret, true
end

-- From OneBag
local BAGTYPE_PROFESSION = 0x0008 + 0x0010 + 0x0020 + 0x0040 + 0x0080 + 0x0200 + 0x0400 + 0x10000
local BAGTYPE_FISHING = 32768

function Stuffing:BagType(bag)
	local bagType = select(2, C_Container.GetContainerNumFreeSlots(bag))

	if bagType and bit.band(bagType, BAGTYPE_FISHING) > 0 then
		return ST_FISHBAG
	elseif bagType and bit.band(bagType, BAGTYPE_PROFESSION) > 0 then
		return ST_SPECIAL
	end

	return ST_NORMAL
end

function Stuffing:BagNew(bag, f)
	for _, v in pairs(self.bags) do
		if v:GetID() == bag then
			v.bagType = self:BagType(bag)
			return v
		end
	end

	local ret

	if #trashBag > 0 then
		local f = -1
		for i, v in pairs(trashBag) do
			if v:GetID() == bag then
				f = i
				break
			end
		end

		if f ~= -1 then
			ret = trashBag[f]
			table.remove(trashBag, f)
			ret:Show()
			ret.bagType = self:BagType(bag)
			return ret
		end
	end

	ret = CreateFrame("Frame", "StuffingBag"..bag, f)
	ret.bagType = self:BagType(bag)

	ret:SetID(bag)
	return ret
end

local bind = {
	[0] = "",
	[1] = "bop bound"..ITEM_BIND_ON_PICKUP,
	[2] = "boe"..ITEM_BIND_ON_EQUIP,
	[3] = ITEM_BIND_ON_USE,
	[4] = ITEM_BIND_QUEST,
	[8] = ITEM_BIND_TO_ACCOUNT,
	[9] = ITEM_BIND_TO_ACCOUNT_UNTIL_EQUIP
}

local bindAccount = {
	[ITEM_ACCOUNTBOUND] = true,
	[ITEM_BIND_TO_ACCOUNT] = true,
	[ITEM_BNETACCOUNTBOUND] = true,
}

function Stuffing:SearchUpdate(str)
	str = string.lower(str)

	for _, b in ipairs(self.buttons) do
		if b.frame and not b.name then
			if str == "" then
				b.frame.searchOverlay:Hide()
			else
				b.frame.searchOverlay:Show()
			end
		end
		if b.name then
			local ilink = C_Container.GetContainerItemLink(b.bag, b.slot)
			if ilink then
				local _, setName = C_Container.GetContainerItemEquipmentSetInfo(b.bag, b.slot)
				setName = setName or ""
				local _, _, _, _, minLevel, class, subclass, _, equipSlot, _, _, _, _, bindType = C_Item.GetItemInfo(ilink)
				class = class or ""
				subclass = subclass or ""
				equipSlot = equipSlot or ""
				bindType = bind[bindType] or ""
				minLevel = minLevel or 1
				local isBoA = false
				if str and (str == "boa" or str == "bow") then
					local data = C_TooltipInfo.GetBagItem(b.bag, b.slot)
					if data then
						for j = 2, 5 do
							local lineData = data.lines[j]
							if not lineData then break end
							local title = lineData.leftText
							if title and bindAccount[title] then
								isBoA = true
								break
							end
						end
					end
				end

				if not isBoA and not string.find(string.lower(b.name), str) and not string.find(string.lower(setName), str) and not string.find(string.lower(class), str) and not string.find(string.lower(subclass), str) and not string.find(string.lower(equipSlot), str) and not string.find(string.lower(bindType), str) then
					if IsItemUnusable(b.name) or minLevel > T.level then
						_G[b.frame:GetName().."IconTexture"]:SetVertexColor(0.5, 0.5, 0.5)
					end
					SetItemButtonDesaturated(b.frame, true)
					b.frame.searchOverlay:Show()
				else
					if IsItemUnusable(b.name) or minLevel > T.level then
						_G[b.frame:GetName().."IconTexture"]:SetVertexColor(1, 0.1, 0.1)
					end
					SetItemButtonDesaturated(b.frame, false)
					b.frame.searchOverlay:Hide()
				end
			end
		end
	end
end

function Stuffing:SearchReset()
	for _, b in ipairs(self.buttons) do
		if IsItemUnusable(b.name) or (b.level and b.level > T.level) then
			_G[b.frame:GetName().."IconTexture"]:SetVertexColor(1, 0.1, 0.1)
		end
		b.frame.searchOverlay:Hide()
		SetItemButtonDesaturated(b.frame, false)
	end

	self.frame.editbox:SetText("")
	self.frame.editbox:Hide()
	self.frame.editbox:ClearFocus()
	self.frame.detail:Show()
end

function Stuffing:ToggleSlots(frame, first)
	local slotShow, slotHide, tabSelected, tabEmpty
	if frame == "bank" then
		slotShow = first and BAGS_BANK_1 or BAGS_BANK_2
		slotHide = first and BAGS_BANK_2 or BAGS_BANK_1
		tabSelected = first and StuffingFrameBankTab1 or StuffingFrameBankTab2
		tabEmpty = first and StuffingFrameBankTab2 or StuffingFrameBankTab1
	else
		slotShow = first and BAGS_WARBAND_1 or BAGS_WARBAND_2
		slotHide = first and BAGS_WARBAND_2 or BAGS_WARBAND_1
		tabSelected = first and StuffingFrameWarbandTab1 or StuffingFrameWarbandTab2
		tabEmpty = first and StuffingFrameWarbandTab2 or StuffingFrameWarbandTab1
	end

	for _, x in ipairs(slotHide) do
		for _, v in ipairs(self.buttons) do
			if v.bag == x then
				v.frame:Hide()
			end
		end
	end

	for _, x in ipairs(slotShow) do
		for _, v in ipairs(self.buttons) do
			if v.bag == x then
				v.frame:Show()
			end
		end
	end

	tabSelected.overlay:SetVertexColor(0.4, 0.4, 0.4, 1)
	tabEmpty.overlay:SetVertexColor(0.1, 0.1, 0.1, 1)
end

local function DragFunction(self, mode)
	for index = 1, select("#", self:GetChildren()) do
		local frame = select(index, self:GetChildren())
		if frame:GetName() and frame:GetName():match("StuffingBag") then
			if mode then
				frame:Hide()
			else
				frame:Show()
			end
		end
	end
end

function Stuffing:CreateBagFrame(w)
	local n = "StuffingFrame"..w
	local f = CreateFrame("Frame", n, UIParent)
	if w ~= "Warband" then
		f:EnableMouse(true)
		f:SetMovable(true)
		f:SetFrameStrata("HIGH")
		f:SetFrameLevel(10)
		f:RegisterForDrag("LeftButton")
		f:SetScript("OnDragStart", function(self)
			if IsAltKeyDown() or IsShiftKeyDown() then
				self:StartMoving()
				DragFunction(self, true)
				f.moved = true
			end
		end)

		f:SetScript("OnDragStop", function(self)
			if f.moved then	-- prevent false register without modifier key
				self:StopMovingOrSizing()
				DragFunction(self, false)
				local ap, p, rp, x, y = f:GetPoint()
				if not p then p = UIParent end
				local positionTable = T.CurrentProfile()
				positionTable[f:GetName()] = {ap, p:GetName(), rp, x, y}
				f.moved = nil
			end
		end)

		f:SetScript("OnMouseDown", function(_, button)
			if IsControlKeyDown() and button == "RightButton" then
				f:ClearAllPoints()
				if w == "Bank" then
					f:SetPoint(unpack(C.position.bank))
				else
					f:SetPoint(unpack(C.position.bag))
				end
				f:SetUserPlaced(false)
				local positionTable = T.CurrentProfile()
				positionTable[f:GetName()] = nil
			end
		end)

		local positionTable = T.CurrentProfile()
		if positionTable[f:GetName()] then
			f:SetPoint(unpack(positionTable[f:GetName()]))
		else
			if w == "Bank" then
				f:SetPoint(unpack(C.position.bank))
			else
				f:SetPoint(unpack(C.position.bag))
			end
		end
	end

	-- Create the bags frame
	local fb = CreateFrame("Frame", n.."BagsFrame", f)
	fb:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, 3)
	fb:SetFrameStrata("HIGH")
	f.bags_frame = fb

	if w == "Bank" or w == "Warband" then
		-- Switch layout button
		f.b_switch = CreateFrame("Button", "StuffingSwitchButton"..w, f)
		f.b_switch:SetSize(95, 20)
		f.b_switch:SetPoint("TOPLEFT", 10, -4)
		f.b_switch:RegisterForClicks("AnyUp")
		f.b_switch:SkinButton()
		f.b_switch:FontString("text", C.font.bags_font, C.font.bags_font_size, C.font.bags_font_style)
		f.b_switch.text:SetPoint("CENTER")
		f.b_switch.text:SetText(w == "Bank" and ACCOUNT_BANK_PANEL_TITLE or BANK)
		f.b_switch:SetWidth(f.b_switch.text:GetWidth() + 15)
		f.b_switch:SetFontString(f.b_switch.text)

		if w == "Bank" then
			f.b_switch:SetScript("OnClick", function()
				self.warbandFrame:Show()
				self.bankFrame:Hide()
				if bag_bars == 1 then
					Stuffing:Layout("warband")
				end
				BankFrame.BankPanel:SetBankType(Enum.BankType.Account or 2)
				PlaySound(SOUNDKIT.IG_CHARACTER_INFO_TAB)
			end)
		else
			f.b_switch:SetScript("OnClick", function()
				self.bankFrame:Show()
				self.warbandFrame:Hide()
				if bag_bars == 1 then
					Stuffing:Layout("bank")
				end
				BankFrame.BankPanel:SetBankType(Enum.BankType.Character or 0)
				PlaySound(SOUNDKIT.IG_CHARACTER_INFO_TAB)
			end)
		end

		-- Deposit button
		f.b_deposit = CreateFrame("Button", nil, f)
		f.b_deposit:SetSize(170, 20)
		f.b_deposit:SetPoint("TOPLEFT", f.b_switch, "TOPRIGHT", 3, 0)
		f.b_deposit:RegisterForClicks("AnyUp")
		f.b_deposit:SkinButton()
		f.b_deposit:FontString("text", C.font.bags_font, C.font.bags_font_size, C.font.bags_font_style)
		f.b_deposit.text:SetShadowOffset(C.font.bags_font_shadow and 1 or 0, C.font.bags_font_shadow and -1 or 0)
		f.b_deposit.text:SetTextColor(1, 1, 1)
		f.b_deposit.text:SetText(w == "Bank" and CHARACTER_BANK_DEPOSIT_BUTTON_LABEL or ACCOUNT_BANK_DEPOSIT_BUTTON_LABEL)
		f.b_deposit:SetWidth(f.b_deposit.text:GetWidth() + 15)
		f.b_deposit:SetFontString(f.b_deposit.text)

		if w == "Bank" then
			f.b_deposit:SetScript("OnClick", function(_, btn)
				BankPanel.AutoDepositFrame.DepositButton:OnClick()
			end)
		else
			local tooltip_show = function(self)
				GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT", 0, 7)
				GameTooltip:ClearLines()
				if GetCVarBool("bankAutoDepositReagents") then
					GameTooltip:SetText(BANK_DEPOSIT_INCLUDE_REAGENTS_CHECKBOX_LABEL.."|cff55ff55: "..L_STATS_ON.."|r")
				else
					GameTooltip:SetText(BANK_DEPOSIT_INCLUDE_REAGENTS_CHECKBOX_LABEL.."|cffff5555: "..strupper(OFF).."|r")
				end
			end

			f.b_deposit:HookScript("OnEnter", tooltip_show)
			f.b_deposit:HookScript("OnLeave", function() GameTooltip:Hide() end)

			f.b_deposit:SetScript("OnClick", function(_, btn)
				if btn == "RightButton" then
					local isOn = GetCVarBool("bankAutoDepositReagents")
					SetCVar("bankAutoDepositReagents", isOn and 0 or 1)
					f.b_deposit:GetScript("OnEnter")(f.b_deposit)
				else
					BankPanel.AutoDepositFrame.DepositButton:OnClick()
				end
			end)
		end

		-- Tab
		for i = 1, 2 do
			f.tab = CreateFrame("Button", n.."Tab"..i, f, "")
			f.tab:SetSize(17 + C.font.bags_font_size, 17 + C.font.bags_font_size)
			f.tab:SetTemplate("Overlay")
			f.tab:EnableMouse(true)
			f.tab.text = f.tab:CreateFontString(nil, "ARTWORK")
			f.tab.text:SetFont(C.font.bags_font, C.font.bags_font_size, C.font.bags_font_style)
			f.tab.text:SetPoint("CENTER", 1, 0)
			f.tab.text:SetTextColor(1, 1, 1)
			if i == 1 then
				f.tab:SetPoint("TOPLEFT", f, "TOPRIGHT", 3, 0)
				f.tab.overlay:SetVertexColor(0.4, 0.4, 0.4, 1)
				f.tab.text:SetText("1")
			else
				f.tab:SetPoint("TOPLEFT", _G[n.."Tab"..i-1], "BOTTOMLEFT", 0, -3)
				f.tab.text:SetText("2")
			end

			f.tab:RegisterForClicks("AnyUp")
			f.tab:SetScript("OnClick", function()
				if i == 1 then
					if w == "Bank" then
						Stuffing:ToggleSlots("bank", true)
					else
						Stuffing:ToggleSlots("warband", true)
					end
				else
					if w == "Bank" then
						if not f.tab.bank then	-- need only one time, save cpu
							Stuffing:Layout("bank_2")
							f.tab.bank = true
						end
						Stuffing:ToggleSlots("bank", false)
					else
						if not f.tab.warband then
							Stuffing:Layout("warband_2")
							f.tab.warband = true
						end
						Stuffing:ToggleSlots("warband", false)
					end
				end
				PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
			end)
		end

		-- Buy button
		fb.b_purchase = CreateFrame("ItemButton", "StuffingPurchaseButton"..w, fb, "InsecureActionButtonTemplate")
		fb.b_purchase:SetFrameLevel(15)
		Mixin(fb.b_purchase, BackdropTemplateMixin)
		fb.b_purchase:RegisterForClicks("AnyUp", "AnyDown")
		fb.b_purchase:SetAttribute("type", "click")
		fb.b_purchase:SetAttribute("clickbutton", _G.BankFrame.BankPanel.PurchasePrompt.TabCostFrame.PurchaseButton)

		fb.b_purchase:SetSize(C.bag.button_size, C.bag.button_size)
		fb.b_purchase:SetPoint("RIGHT", fb, "RIGHT", -10, 0)

		fb.b_purchase:StyleButton()
		fb.b_purchase:SetTemplate("Default")
		fb.b_purchase:SetBackdropBorderColor(1, 1, 0)
		fb.b_purchase:SetNormalTexture((0))

		fb.b_purchase.icon = _G[fb.b_purchase:GetName().."IconTexture"]
		fb.b_purchase.icon:CropIcon()
		fb.b_purchase.icon:SetTexture(135769)

		if C_Bank.CanPurchaseBankTab(w == "Bank" and Enum.BankType.Character or Enum.BankType.Account) then
			fb.b_purchase:Show()
		else
			fb.b_purchase:Hide()
		end
	end

	if w == "Warband" then
		f:ClearAllPoints()
		f:SetPoint("TOPLEFT", _G["StuffingFrameBank"], "TOPLEFT", 0, 0)
		T.SkinIconSelectionFrame(BankPanel.TabSettingsMenu)

		-- Gold ammount
		local goldText = f:CreateFontString(nil, "ARTWORK")
		goldText:SetFont(C.font.stats_font, C.font.stats_font_size, C.font.stats_font_style)
		goldText:SetShadowOffset(C.font.stats_font_shadow and 1 or 0, C.font.stats_font_shadow and -1 or 0)
		goldText:SetPoint("RIGHT", f, "TOPRIGHT", -25, -13)

		local function comma_value(n) -- credit http://richard.warburton.it
			local left, num, right = string.match(n,"^([^%d]*%d)(%d*)(.-)$")
			return left..(num:reverse():gsub("(%d%d%d)","%1,"):reverse())..right
		end
		local function formatgold()
			local amount = C_Bank.FetchDepositedMoney(Enum.BankType.Account) or 0
			local gold, silver, copper = floor(amount * 0.0001), floor(mod(amount * 0.01, 100)), floor(mod(amount, 100))

			return (gold > 0 and format("%s|cffffd700%s|r ", comma_value(gold), GOLD_AMOUNT_SYMBOL) or "")
			.. (format("%.2d|cffc7c7cf%s|r ", silver, SILVER_AMOUNT_SYMBOL))
			.. (format("%.2d|cffeda55f%s|r", copper, COPPER_AMOUNT_SYMBOL))
		end
		goldText:SetText(formatgold())

		local goldButton = CreateFrame("Button", nil, f)
		goldButton:SetAlpha(0)
		goldButton:SetAllPoints(goldText)
		goldButton:RegisterForClicks("AnyUp")
		goldButton:SetScript("OnClick", function(_, btn)
			if btn == "RightButton" then
				BankPanel.MoneyFrame.DepositButton:OnClick()
			else
				BankPanel.MoneyFrame.WithdrawButton:OnClick()
			end
		end)

		local tooltip_show = function(self)
			GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT", 0, 11)
			GameTooltip:ClearLines()
			GameTooltip:SetText(LEFT_BUTTON_STRING..": |cffff5555"..BANK_WITHDRAW_MONEY_BUTTON_LABEL.."|r\n"..RIGHT_BUTTON_STRING..": |cff55ff55"..BANK_DEPOSIT_MONEY_BUTTON_LABEL.."|r")
		end

		goldButton:HookScript("OnEnter", tooltip_show)
		goldButton:HookScript("OnLeave", function() GameTooltip:Hide() end)

		goldButton:RegisterEvent("PLAYER_MONEY")
		goldButton:RegisterEvent("ACCOUNT_MONEY")
		goldButton:SetScript("OnEvent", function()
			goldText:SetText(formatgold())
		end)
	end

	-- Close button
	f.b_close = CreateFrame("Button", "StuffingCloseButton"..w, f, "UIPanelCloseButton")
	T.SkinCloseButton(f.b_close, nil, nil, true)
	f.b_close:SetSize(15, 15)
	f.b_close:RegisterForClicks("AnyUp")
	f.b_close:SetScript("OnClick", function(self, btn)
		if btn == "RightButton" then
			if Stuffing_DDMenu.initialize ~= Stuffing.Menu then
				CloseDropDownMenus()
				Stuffing_DDMenu.initialize = Stuffing.Menu
			end
			ToggleDropDownMenu(nil, nil, Stuffing_DDMenu, self:GetName(), 0, 0)
			return
		elseif btn == "LeftButton" and IsShiftKeyDown() then
			if InCombatLockdown() then
				print("|cffffff00"..ERR_NOT_IN_COMBAT.."|r") return
			end
			Stuffing:SetBagsForSorting("d")
			Stuffing:Restack()
			return
		end
		self:GetParent():Hide()
	end)

	local tooltip_show = function(self)
		GameTooltip:SetOwner(self, "ANCHOR_LEFT", 19, 7)
		GameTooltip:ClearLines()
		GameTooltip:SetText(L_BAG_RIGHT_CLICK_CLOSE)
	end

	f.b_close:HookScript("OnEnter", tooltip_show)
	f.b_close:HookScript("OnLeave", function() GameTooltip:Hide() end)

	return f
end

function Stuffing:InitBank()
	if self.bankFrame then
		return
	end

	local f = self:CreateBagFrame("Bank")
	f:SetScript("OnHide", StuffingBank_OnHide)
	self.bankFrame = f

	if self.warbandFrame then return end
	local f = self:CreateBagFrame("Warband")
	f:Hide()
	f:SetScript("OnHide", StuffingWarband_OnHide)
	self.warbandFrame = f

	-- Update bank bags icon
	hooksecurefunc(BankFrame.BankPanel, "RefreshBankTabs", function(self)
		if not self.purchasedBankTabData then return end

		if not BankFrame.BankPanel.purchasedBankTabData[4] then -- only first 3 bags exist
			local data = BankFrame.BankPanel.purchasedBankTabData[1]
			if data then
				if data.bankType == 0 then
					StuffingFrameBankTab1:Hide()
					StuffingFrameBankTab2:Hide()
				else
					StuffingFrameWarbandTab1:Hide()
					StuffingFrameWarbandTab2:Hide()
				end
			end
		end

		for _, data in pairs(self.purchasedBankTabData) do
			if data.ID >= 12 then
				local slot = data.ID - 11
				if _G["StuffingABag"..slot.."Slot"] then
					_G["StuffingABag"..slot.."SlotIconTexture"]:SetTexture(data.icon)
				end
			else
				local slot = data.ID - 5
				if _G["StuffingBBag"..slot.."Slot"] then
					_G["StuffingBBag"..slot.."SlotIconTexture"]:SetTexture(data.icon)
				end
			end
		end
	end)
end

function Stuffing:InitBags()
	if self.frame then return end

	self.buttons = {}
	self.bags = {}
	self.bagframe_buttons = {}
	self.bags_num = {}

	local f = self:CreateBagFrame("Bags")
	f:SetScript("OnShow", Stuffing_OnShow)
	f:SetScript("OnHide", Stuffing_OnHide)

	-- Search editbox (tekKonfigAboutPanel.lua)
	local editbox = CreateFrame("EditBox", nil, f)
	editbox:Hide()
	editbox:SetAutoFocus(false)
	editbox:SetHeight(32)
	editbox:CreateBackdrop("Overlay")
	editbox.backdrop:SetPoint("TOPLEFT", -2, 1)
	editbox.backdrop:SetPoint("BOTTOMRIGHT", 2, -1)

	local fullReset = function()
		Stuffing:SearchReset()
	end

	local clearFocus = function(self)
		self:HighlightText(0, 0)
		self:ClearFocus()
	end

	local gainFocus = function(self)
		self:HighlightText()
	end

	local updateSearch = function(self, t)
		if t == true then
			Stuffing:SearchUpdate(self:GetText())
		end
	end

	editbox:SetScript("OnEscapePressed", fullReset)
	editbox:SetScript("OnEnterPressed", clearFocus)
	editbox:SetScript("OnEditFocusLost", clearFocus)
	editbox:SetScript("OnEditFocusGained", gainFocus)
	editbox:SetScript("OnTextChanged", updateSearch)

	local detail = f:CreateFontString(nil, "ARTWORK", "GameFontHighlightLarge")
	detail:SetPoint("TOPLEFT", f, 12, -8)
	detail:SetPoint("RIGHT", f, -150, -8)
	detail:SetHeight(13)
	detail:SetShadowColor(0, 0, 0, 0)
	detail:SetJustifyH("LEFT")
	detail:SetText("|cff9999ff"..SEARCH.."|r")
	editbox:SetAllPoints(detail)

	local buttons = {}
	local filterTable = {
		[1] = {3566860, C_Item.GetItemClassInfo(0)},	-- Consumable
		[2] = {135280, C_Item.GetItemClassInfo(2)},		-- Weapon
		[3] = {132341, C_Item.GetItemClassInfo(4)},		-- Armor
		[4] = {132281, C_Item.GetItemClassInfo(7)},		-- Tradeskill
		[5] = {236667, ITEM_BIND_QUEST},				-- Quest
		[6] = {133784, ITEM_BIND_ON_EQUIP},				-- BoE
	}
	for i = 1, #filterTable do
		local button = CreateFrame("Button", "BagsFilterButton"..i, C.bag.filter and f or editbox)
		button:SetSize(25, 25)
		button:SetTemplate("Overlay")
		button:EnableMouse(true)
		button:RegisterForClicks("AnyUp")
		if i == 1 then
			button:SetPoint("TOPRIGHT", f, "TOPLEFT", -1, 0)
		else
			button:SetPoint("TOP", buttons[i-1], "BOTTOM", 0, -1)
		end
		buttons[i] = button
		local icon, text = unpack(filterTable[i])
		button.Icon = button:CreateTexture(nil, "OVERLAY")
		button.Icon:SetTexture(icon)
		button.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		button.Icon:SetPoint("TOPLEFT", button, 2, -2)
		button.Icon:SetPoint("BOTTOMRIGHT", button, -2, 2)
		button:SetScript("OnClick", function()
			if editbox:GetText() == text then
				Stuffing:SearchReset()
			else
				detail:Hide()
				editbox:Show()
				editbox:SetText(text)
				Stuffing:SearchUpdate(text)
			end
		end)

		local tooltip_show = function(self)
			GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT", -5, 5)
			GameTooltip:ClearLines()
			GameTooltip:SetText(text)
		end

		button:SetScript("OnEnter", tooltip_show)
		button:SetScript("OnLeave", function() GameTooltip:Hide() end)
	end

	local button = CreateFrame("Button", nil, f)
	button:EnableMouse(true)
	button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	button:SetAllPoints(detail)
	button.ttText = L_BAG_RIGHT_CLICK_SEARCH
	button:SetScript("OnClick", function(self, btn)
		if btn == "RightButton" then
			self:GetParent().detail:Hide()
			self:GetParent().editbox:Show()
			self:GetParent().editbox:HighlightText()
			self:GetParent().editbox:SetFocus()
		else
			if self:GetParent().editbox:IsShown() then
				Stuffing:SearchReset()
			end
		end
	end)

	local tooltip_show = function(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", -12, 11)
		GameTooltip:ClearLines()
		GameTooltip:SetText(self.ttText)
	end

	button:SetScript("OnEnter", tooltip_show)
	button:SetScript("OnLeave", function() GameTooltip:Hide() end)

	f.editbox = editbox
	f.detail = detail
	f.button = button
	self.frame = f
	f:Hide()
end

local function TabOnClick(self, btn)
	if not BankFrame.BankPanel.purchasedBankTabData then return end

	local data = BankFrame.BankPanel.purchasedBankTabData[self.bagID]
	if not data then return end

	if btn == "RightButton" then
		local menu = BankFrame.BankPanel.TabSettingsMenu
		if menu then
			if menu:IsShown() then menu:Hide() end
			menu:SetParent(UIParent)
			menu:ClearAllPoints()
			menu:SetPoint("CENTER", 0, 100)
			menu:EnableMouse(true)
			menu:SetFrameStrata("DIALOG")
			menu:OnOpenTabSettingsRequested(self:GetID())
		end
	end
end

function Stuffing:Layout(type)
	local slots = 0
	local rows = 0
	local off = 20
	local cols, f, bsf, bs
	local mult = 0

	if type == "bank" then
		bsf = BAGS_BANK
		bs = BAGS_BANK_1
		cols = C.bag.bank_columns
		f = self.bankFrame
	elseif type == "bank_2" then
		bsf = BAGS_BANK
		bs = BAGS_BANK_2
		cols = C.bag.bank_columns
		f = self.bankFrame
	elseif type == "warband" then
		bsf = BAGS_WARBAND
		bs = BAGS_WARBAND_1
		cols = C.bag.bank_columns
		f = self.warbandFrame
	elseif type == "warband_2" then
		bsf = BAGS_WARBAND
		bs = BAGS_WARBAND_2
		cols = C.bag.bank_columns
		f = self.warbandFrame
	else
		bsf = BAGS_BACKPACK
		bs = BAGS_BACKPACK
		cols = C.bag.bag_columns
		f = self.frame
		mult = 1

		f.editbox:SetFont(C.media.normal_font, C.font.bags_font_size + 3, "")
		f.detail:SetFont(C.font.bags_font, C.font.bags_font_size, C.font.bags_font_style)
		f.detail:SetShadowOffset(C.font.bags_font_shadow and 1 or 0, C.font.bags_font_shadow and -1 or 0)
	end

	f:SetClampedToScreen(1)
	f:SetTemplate("Transparent")

	-- Bag frame stuff
	local fb = f.bags_frame
	if bag_bars == 1 then
		fb:SetClampedToScreen(1)
		fb:SetTemplate("Transparent")

		local bsize = C.bag.button_size

		local w = 2 * 10
		w = w + ((#bsf - mult) * bsize) + ((#bsf - 1 - mult) * C.bag.button_space)

		fb:SetHeight(2 * 10 + bsize)
		fb:SetWidth(w)
		fb:Show()
	else
		fb:Hide()
	end

	local idx = 0
	for _, v in ipairs(bsf) do
		if (not type and v <= 4) or (type and v ~= -1) then
			local bsize = C.bag.button_size
			local b = self:BagFrameSlotNew(fb, v)
			local xoff = 10

			xoff = xoff + (idx * bsize) + (idx * C.bag.button_space)

			b.frame:ClearAllPoints()
			b.frame:SetPoint("LEFT", fb, "LEFT", xoff, 0)
			b.frame:SetSize(bsize, bsize)

			local btns = self.buttons
			b.frame:HookScript("OnEnter", function()
				local bag
				if type then bag = v else bag = v + 1 end

				for _, val in ipairs(btns) do
					if val.bag == bag then
						val.frame.searchOverlay:Hide()
					else
						val.frame.searchOverlay:Show()
					end
				end
			end)

			b.frame:HookScript("OnLeave", function()
				for _, btn in ipairs(btns) do
					btn.frame.searchOverlay:Hide()
				end
			end)

			b.frame:SetScript("OnClick", type and TabOnClick or nil)

			idx = idx + 1
		end
	end

	for _, i in ipairs(bs) do
		local x = C_Container.GetContainerNumSlots(i)
		if x > 0 then
			if not self.bags[i] then
				self.bags[i] = self:BagNew(i, f)
			end

			slots = slots + C_Container.GetContainerNumSlots(i)
		end
		self.bags_num[i] = x
	end

	rows = floor(slots / cols)
	if (slots % cols) ~= 0 then
		rows = rows + 1
	end

	f:SetWidth(cols * C.bag.button_size + (cols - 1) * C.bag.button_space + 10 * 2)
	f:SetHeight(rows * C.bag.button_size + (rows - 1) * C.bag.button_space + off + 10 * 2)

	local idx = 0
	for _, i in ipairs(bs) do
		local bag_cnt = C_Container.GetContainerNumSlots(i)
		local specialType = select(2, C_Container.GetContainerNumFreeSlots(i))
		if bag_cnt > 0 then
			self.bags[i] = self:BagNew(i, f)
			local bagType = self.bags[i].bagType

			self.bags[i]:Show()
			for j = 1, bag_cnt do
				local b, isnew = self:SlotNew(i, j)
				local xoff
				local yoff
				local x = (idx % cols)
				local y = floor(idx / cols)

				if isnew then
					table.insert(self.buttons, idx + 1, b)
				end

				xoff = 10 + (x * C.bag.button_size) + (x * C.bag.button_space)
				yoff = off + 10 + (y * C.bag.button_size) + ((y - 1) * C.bag.button_space)
				yoff = yoff * -1

				b.frame:ClearAllPoints()
				b.frame:SetPoint("TOPLEFT", f, "TOPLEFT", xoff, yoff)
				b.frame:SetSize(C.bag.button_size, C.bag.button_size)
				b.frame.lock = false
				b.frame:SetAlpha(1)

				if bagType == ST_FISHBAG then
					b.frame:SetBackdropBorderColor(1, 0, 0)	-- Tackle
					b.frame.lock = true
				elseif bagType == ST_SPECIAL then
					if specialType == 0x0008 then			-- Leatherworking
						b.frame:SetBackdropBorderColor(0.8, 0.7, 0.3)
					elseif specialType == 0x0010 then		-- Inscription
						b.frame:SetBackdropBorderColor(0.3, 0.3, 0.8)
					elseif specialType == 0x0020 then		-- Herbs
						b.frame:SetBackdropBorderColor(0.3, 0.7, 0.3)
					elseif specialType == 0x0040 then		-- Enchanting
						b.frame:SetBackdropBorderColor(0.6, 0, 0.6)
					elseif specialType == 0x0080 then		-- Engineering
						b.frame:SetBackdropBorderColor(0.9, 0.4, 0.1)
					elseif specialType == 0x0200 then		-- Gems
						b.frame:SetBackdropBorderColor(0, 0.7, 0.8)
					elseif specialType == 0x0400 then		-- Mining
						b.frame:SetBackdropBorderColor(0.4, 0.3, 0.1)
					elseif specialType == 0x10000 then		-- Cooking
						b.frame:SetBackdropBorderColor(0.9, 0, 0.1)
					end
					b.frame.lock = true
				elseif i == 5 then 		-- Reagent
					b.frame:SetBackdropBorderColor(0.5, 0.25, 0.1)
					b.frame.lock = true
				end

				idx = idx + 1
			end
		end
	end
end

function Stuffing:SetBagsForSorting(c)
	Stuffing_Open()

	self.sortBags = {}

	local cmd = ((c == nil or c == "") and {"d"} or {strsplit("/", c)})
	-- TODO: add check for tab?
	local targetBags = (self.bankFrame and self.bankFrame:IsShown()) and BAGS_BANK or (self.warbandFrame and self.warbandFrame:IsShown()) and BAGS_WARBAND or BAGS_BACKPACK

	for _, s in ipairs(cmd) do
		if s == "c" then
			self.sortBags = {}
		elseif s == "d" then
			for _, i in ipairs(targetBags) do
				if self.bags[i] and self.bags[i].bagType == ST_NORMAL then
					table.insert(self.sortBags, i)
				end
			end
		elseif s == "p" then
			for _, i in ipairs(targetBags) do
				if self.bags[i] and self.bags[i].bagType == ST_SPECIAL then
					table.insert(self.sortBags, i)
				end
			end
		else
			table.insert(self.sortBags, tonumber(s))
		end
	end
end

local function InBags(x)
	if not Stuffing.bags[x] then
		return false
	end

	for _, v in ipairs(Stuffing.sortBags) do
		if x == v then
			return true
		end
	end
	return false
end

local BS_bagGroups
local BS_itemSwapGrid

local function BS_clearData()
	BS_itemSwapGrid = {}
	BS_bagGroups = {}
end

function Stuffing:SortOnUpdate(elapsed)
	self.elapsed = (self.elapsed or 0) + elapsed

	if self.elapsed < 0.05 then
		return
	end

	self.elapsed = 0

	local changed = false
	local blocked = false

	for bagIndex in pairs(BS_itemSwapGrid) do
		for slotIndex in pairs(BS_itemSwapGrid[bagIndex]) do
			local destinationBag = BS_itemSwapGrid[bagIndex][slotIndex].destinationBag
			local destinationSlot = BS_itemSwapGrid[bagIndex][slotIndex].destinationSlot

			local _, _, locked1 = GetContainerItemInfo(bagIndex, slotIndex)
			local _, _, locked2 = GetContainerItemInfo(destinationBag, destinationSlot)

			if locked1 or locked2 then
				blocked = true
			elseif bagIndex ~= destinationBag or slotIndex ~= destinationSlot then
				C_Container.PickupContainerItem(bagIndex, slotIndex)
				C_Container.PickupContainerItem(destinationBag, destinationSlot)

				local tempItem = BS_itemSwapGrid[destinationBag][destinationSlot]
				BS_itemSwapGrid[destinationBag][destinationSlot] = BS_itemSwapGrid[bagIndex][slotIndex]
				BS_itemSwapGrid[bagIndex][slotIndex] = tempItem

				changed = true
				return
			end
		end
	end

	if not changed and not blocked then
		self:SetScript("OnUpdate", nil)
		BS_clearData()
	end
end

function Stuffing:SortBags()
	BS_clearData()

	local bagList
	if Stuffing.warbandFrame and Stuffing.warbandFrame:IsShown() then -- FIXME sort only visiable tab
		bagList = {16, 15, 14, 13, 12}
	elseif Stuffing.bankFrame and Stuffing.bankFrame:IsShown() then
		bagList = {11, 10, 9, 8, 7, 6}
	else
		bagList = {4, 3, 2, 1, 0}
	end

	for _, slotNum in pairs(bagList) do
		if C_Container.GetContainerNumSlots(slotNum) > 0 then
			BS_itemSwapGrid[slotNum] = {}
			local family = select(2, C_Container.GetContainerNumFreeSlots(slotNum))
			if family then
				if family == 0 then family = "Default" end
				if not BS_bagGroups[family] then
					BS_bagGroups[family] = {}
					BS_bagGroups[family].bagSlotNumbers = {}
				end
				table.insert(BS_bagGroups[family].bagSlotNumbers, slotNum)
			end
		end
	end

	for _, group in pairs(BS_bagGroups) do
		group.itemList = {}
		for _, bagSlot in pairs(group.bagSlotNumbers) do
			for itemSlot = 1, C_Container.GetContainerNumSlots(bagSlot) do
				local itemLink = C_Container.GetContainerItemLink(bagSlot, itemSlot)
				if itemLink ~= nil then
					local newItem = {}

					local n, _, q, iL, rL, c1, c2, _, Sl, _, _, classID = C_Item.GetItemInfo(itemLink)
					local p = 1
					-- Hearthstone
					if n == C_Item.GetItemInfo(6948) or n == C_Item.GetItemInfo(110560) or n == C_Item.GetItemInfo(140192) then
						p = 99
					elseif n == C_Item.GetItemInfo(141605) then -- Flight Master's Whistle
						p = 98
					elseif n == C_Item.GetItemInfo(128353) then -- Admiral's Compass
						p = 97
					end
					-- Fix for battle pets
					if not n then
						n = itemLink
						q = select(4, GetContainerItemInfo(bagSlot, itemSlot))
						iL = 1
						rL = 1
						c1 = "Pet"
						c2 = "Pet"
						Sl = ""
					end

					-- Keystone
					local ks = strmatch(itemLink, "keystone:(%d+)")
					if ks then
						p = 10
					end

					if classID == 0 then	-- Consumable
						p = 9
					elseif classID == 2 or classID == 4 then	-- Weapon and Armor
						p = 8
					end

					newItem.sort = p..q..c1..c2..rL..n..iL..Sl

					tinsert(group.itemList, newItem)

					BS_itemSwapGrid[bagSlot][itemSlot] = newItem
					newItem.startBag = bagSlot
					newItem.startSlot = itemSlot
				end
			end
		end

		table.sort(group.itemList, function(a, b)
			return a.sort > b.sort
		end)

		for index, item in pairs(group.itemList) do
			local gridSlot = index
			for _, bagSlotNumber in pairs(group.bagSlotNumbers) do
				if gridSlot <= C_Container.GetContainerNumSlots(bagSlotNumber) then
					BS_itemSwapGrid[item.startBag][item.startSlot].destinationBag = bagSlotNumber
					BS_itemSwapGrid[item.startBag][item.startSlot].destinationSlot = C_Container.GetContainerNumSlots(bagSlotNumber) - gridSlot + 1
					break
				else
					gridSlot = gridSlot - C_Container.GetContainerNumSlots(bagSlotNumber)
				end
			end
		end
	end

	self:SetScript("OnUpdate", Stuffing.SortOnUpdate)
end

function Stuffing:RestackOnUpdate(e)
	if not self.elapsed then
		self.elapsed = 0
	end

	self.elapsed = self.elapsed + e

	if self.elapsed < 0.1 then return end

	self.elapsed = 0
	self:Restack()
end

function Stuffing:Restack()
	local st = {}
	local sr = {}
	local did_restack = false

	if not (Stuffing.bankFrame and Stuffing.bankFrame:IsShown()) then
		Stuffing_Open()
	end

	for _, v in pairs(self.buttons) do
		if InBags(v.bag) then
			local _, cnt, _, _, _, _, clink = GetContainerItemInfo(v.bag, v.slot)
			if clink then
				local n, _, _, _, _, _, _, s = C_Item.GetItemInfo(clink)

				if n and cnt ~= s then
					if not st[clink] then
						st[clink] = {{item = v, size = cnt, max = s}}
					else
						table.insert(st[clink], {item = v, size = cnt, max = s})
					end
				end
			end
		end
	end
	for _, v in pairs(st) do
		if #v > 1 then
			for j = 2, #v, 2 do
				local a, b = v[j - 1], v[j]
				local _, _, l1 = GetContainerItemInfo(a.item.bag, a.item.slot)
				local _, _, l2 = GetContainerItemInfo(b.item.bag, b.item.slot)

				if l1 or l2 then
					did_restack = true
				else
					C_Container.PickupContainerItem(a.item.bag, a.item.slot)
					C_Container.PickupContainerItem(b.item.bag, b.item.slot)
					did_restack = true
				end
			end
		end
	end

	if did_restack then
		self:SetScript("OnUpdate", Stuffing.RestackOnUpdate)
	else
		self:SetScript("OnUpdate", nil)
	end
end

function Stuffing.Menu(self, level)
	if not level then return end

	local info = self.info

	wipe(info)

	if level ~= 1 then return end

	wipe(info)
	info.text = BAG_FILTER_CLEANUP.." Blizzard"
	info.notCheckable = 1
	info.func = function()
		if Stuffing.bankFrame and Stuffing.bankFrame:IsShown() then
			C_Container.SortBankBags()
		elseif Stuffing.warbandFrame and Stuffing.warbandFrame:IsShown() then
			C_Container.SortAccountBankBags()
		else
			C_Container.SortBags()
		end
	end
	UIDropDownMenu_AddButton(info, level)

	wipe(info)
	info.text = BAG_FILTER_CLEANUP
	info.notCheckable = 1
	info.func = function()
		if InCombatLockdown() then
			print("|cffffff00"..ERR_NOT_IN_COMBAT.."|r") return
		end
		Stuffing:SortBags()
	end
	UIDropDownMenu_AddButton(info, level)

	wipe(info)
	info.text = L_BAG_STACK_MENU
	info.notCheckable = 1
	info.func = function()
		if InCombatLockdown() then
			print("|cffffff00"..ERR_NOT_IN_COMBAT.."|r") return
		end
		Stuffing:SetBagsForSorting("d")
		Stuffing:Restack()
	end
	UIDropDownMenu_AddButton(info, level)

	wipe(info)
	info.text = L_BAG_SHOW_BAGS
	info.checked = function()
		return bag_bars == 1
	end

	info.func = function()
		if bag_bars == 1 then
			bag_bars = 0
		else
			bag_bars = 1
		end
		Stuffing:Layout()
		if Stuffing.bankFrame and Stuffing.bankFrame:IsShown() then
			Stuffing:Layout("bank")
		elseif Stuffing.warbandFrame and Stuffing.warbandFrame:IsShown() then
			Stuffing:Layout("warband")
		end
	end
	UIDropDownMenu_AddButton(info, level)

	wipe(info)
	info.disabled = nil
	info.notCheckable = 1
	info.text = CLOSE
	info.func = self.HideMenu
	info.tooltipTitle = CLOSE
	UIDropDownMenu_AddButton(info, level)
end

function Stuffing:ADDON_LOADED(addon)
	if addon ~= "ShestakUI" then return nil end

	self:RegisterEvent("BAG_UPDATE")
	self:RegisterEvent("ITEM_LOCK_CHANGED")
	self:RegisterEvent("BANKFRAME_OPENED")
	self:RegisterEvent("BANKFRAME_CLOSED")
	self:RegisterEvent("PLAYER_INTERACTION_MANAGER_FRAME_SHOW")
	self:RegisterEvent("PLAYER_INTERACTION_MANAGER_FRAME_HIDE")
	self:RegisterEvent("PLAYERBANKSLOTS_CHANGED")
	self:RegisterEvent("BAG_CLOSED")
	self:RegisterEvent("BAG_UPDATE_COOLDOWN")
	self:RegisterEvent("BAG_CONTAINER_UPDATE")
	self:RegisterEvent("BAG_UPDATE_DELAYED")

	self:InitBags()

	tinsert(UISpecialFrames, "StuffingFrameBags")

	ToggleBackpack = Stuffing_Toggle
	ToggleBag = Stuffing_Toggle
	ToggleAllBags = Stuffing_Toggle
	OpenAllBags = Stuffing_Open
	OpenBackpack = Stuffing_Open

	hooksecurefunc("CloseAllBags", Stuffing_Close)
	hooksecurefunc("CloseBackpack", Stuffing_Close)

	OpenAllBagsMatchingContext = function()
		local count = 0
		for i = 0, NUM_BAG_FRAMES do
			if ItemButtonUtil.GetItemContextMatchResultForContainer(i) == ItemButtonUtil.ItemContextMatchResult.Match then
				Stuffing_Open()
				count = count + 1
			end
		end
		return count
	end

	-- Hide Blizzard Bank
	BankFrame:UnregisterAllEvents()
	BankFrame:SetScale(0.00001)
	BankFrame:SetAlpha(0)
	BankFrame:ClearAllPoints()
	BankFrame:SetPoint("TOPLEFT")
end

function Stuffing:PLAYER_ENTERING_WORLD()
	Stuffing:UnregisterEvent("PLAYER_ENTERING_WORLD")
	ToggleBackpack()
	ToggleBackpack()
end

function Stuffing:PLAYERBANKSLOTS_CHANGED()
	if self.bankFrame and self.bankFrame:IsShown() then
		self:BagSlotUpdate(-1)
	end
end

function Stuffing:BAG_UPDATE(id)
	self:BagSlotUpdate(id)
end

function Stuffing:BAG_UPDATE_DELAYED()
	for _, i in ipairs(BAGS_BACKPACK) do
		local numSlots = C_Container.GetContainerNumSlots(i)
		if self.bags_num[i] and self.bags_num[i] ~= numSlots then
			self:Layout()
			return
		end
	end
end

function Stuffing:ITEM_LOCK_CHANGED(bag, slot)
	if slot == nil then return end
	for _, v in ipairs(self.buttons) do
		if v.bag == bag and v.slot == slot then
			self:SlotUpdate(v)
			break
		end
	end
end

function Stuffing:BANKFRAME_OPENED()
	if not self.bankFrame then
		self:InitBank()
	end

	self:Layout("bank")
	for _, x in ipairs(BAGS_BANK) do
		self:BagSlotUpdate(x)
	end

	self.bankFrame:Show()
	Stuffing_Open()

	self:Layout("warband")
	for _, x in ipairs(BAGS_WARBAND) do
		self:BagSlotUpdate(x)
	end

	-- Reset selected tab
	Stuffing:ToggleSlots("bank", true)
	Stuffing:ToggleSlots("warband", true)

	-- If open via Warband Bank Distance Inhibitor
	if not C_Bank.CanViewBank(Enum.BankType.Character) and C_Bank.CanViewBank(Enum.BankType.Account) then
		StuffingSwitchButtonBank:Click()
	end
end

function Stuffing:BANKFRAME_CLOSED()
	if self.bankFrame then
		self.bankFrame:Hide()
	end
end

function Stuffing:PLAYER_INTERACTION_MANAGER_FRAME_SHOW(...)
	local type = ...
	if type == 10 then	-- Guild bank
		Stuffing_Open()
	elseif type == 40 then	-- ScrappingMachine
		for i = 0, #BAGS_BACKPACK - 1 do
			Stuffing:BAG_UPDATE(i)
		end
	end
end

function Stuffing:PLAYER_INTERACTION_MANAGER_FRAME_HIDE(...)
	local type = ...
	if type == 10 then	-- Guild bank
		Stuffing_Close()
	end
end

function Stuffing:BAG_CLOSED(id)
	local b = self.bags[id]
	if b then
		table.remove(self.bags, id)
		b:Hide()
		table.insert(trashBag, #trashBag + 1, b)
		self.bags_num[id] = -1
	end

	while true do
		local changed = false

		for i, v in ipairs(self.buttons) do
			if v.bag == id then
				v.frame:Hide()
				v.frame.lock = false

				table.insert(trashButton, #trashButton + 1, v.frame)
				table.remove(self.buttons, i)

				v = nil
				changed = true
			end
		end

		if not changed then
			break
		end
	end
	if id > 5 then
		Stuffing_Close() -- prevent graphical bug with empty slots
	end
end

function Stuffing:BAG_UPDATE_COOLDOWN()
	for _, v in pairs(self.buttons) do
		self:UpdateCooldowns(v)
	end
end

function Stuffing:BAG_CONTAINER_UPDATE()
	for _, v in ipairs(self.bagframe_buttons) do
		if v.frame and v.slot < 5 then -- exclude bank
			v.frame.ID = C_Container.ContainerIDToInventoryID(v.slot + 1)

			local slotLink = GetInventoryItemLink("player", v.frame.ID)
			v.frame:SetBackdropBorderColor(unpack(C.media.border_color))
			if slotLink then
				local _, _, quality = C_Item.GetItemInfo(slotLink)
				if quality and quality > 1 then
					local r, g, b = C_Item.GetItemQualityColor(quality)
					v.frame:SetBackdropBorderColor(r, g, b)
				end
			end

			local bag_tex = GetInventoryItemTexture("player", v.frame.ID)
			_G[v.frame:GetName().."IconTexture"]:SetTexture(bag_tex)
		end
	end
end

-- Kill Blizzard functions
LootWonAlertFrame_OnClick = T.dummy
LootUpgradeFrame_OnClick = T.dummy
LegendaryItemAlertFrame_OnClick = T.dummy
local T, C, L = unpack(ShestakUI)
if C.nameplate.enable ~= true then return end

----------------------------------------------------------------------------------------
--	The best way to add or delete spell is to go at www.wowhead.com, search for a spell.
--	Example: Polymorph -> http://www.wowhead.com/spell=118
--	Take the number ID at the end of the URL, and add it to the list
----------------------------------------------------------------------------------------
local function SpellName(id)
	local name = GetSpellInfo(id)
	if name then
		return name
	else
		print("|cffff0000ShestakUI: Nameplates spell ID ["..tostring(id).."] no longer exists!|r")
		return "Empty"
	end
end

T.DebuffWhiteList = {
	-- Death Knight
	[108194] = true,	-- Asphyxiate
	[47476] = true,		-- Strangulate
	[55078] = true,		-- Blood Plague
	[55095] = true,		-- Frost Fever
	-- Druid
	[33786] = true,		-- Cyclone
	[339] = true,		-- Entangling Roots
	[164812] = true,	-- Moonfire
	[164815] = true,	-- Sunfire
	[58180] = true,		-- Infected Wounds
	[155722] = true,	-- Rake
	[1079] = true,		-- Rip
	-- Evoker
	[360806] = true,	-- Sleep Walk
	-- Hunter
	[3355] = true,		-- Freezing Trap
	[13812] = true,		-- Explosive Trap
	[217200] = true,	-- Barbed Shot
	-- Mage
	[118] = true,		-- Polymorph
	[31661] = true,		-- Dragon's Breath
	[122] = true,		-- Frost Nova
	[44457] = true,		-- Living Bomb
	[114923] = true,	-- Nether Tempest
	[120] = true,		-- Cone of Cold
	-- Monk
	[115078] = true,	-- Paralysis
	-- Paladin
	[20066] = true,		-- Repentance
	[853] = true,		-- Hammer of Justice
	[183218] = true,	-- Hand of Hindrance
	-- Priest
	[204213] = true,	-- Purge the Wicked
	[9484] = true,		-- Shackle Undead
	[8122] = true,		-- Psychic Scream
	[64044] = true,		-- Psychic Horror
	[15487] = true,		-- Silence
	[589] = true,		-- Shadow Word: Pain
	[34914] = true,		-- Vampiric Touch
	-- Rogue
	[6770] = true,		-- Sap
	[2094] = true,		-- Blind
	[1776] = true,		-- Gouge
	-- Shaman
	[51514] = true,		-- Hex
	[3600] = true,		-- Earthbind
	[196840] = true,	-- Frost Shock
	[188389] = true,	-- Flame Shock
	[197209] = true,	-- Lightning Rod
	-- Warlock
	[710] = true,		-- Banish
	[6789] = true,		-- Mortal Coil
	[5782] = true,		-- Fear
	[5484] = true,		-- Howl of Terror
	[6358] = true,		-- Seduction
	[30283] = true,		-- Shadowfury
	[603] = true,		-- Doom
	[980] = true,		-- Agony
	[146739] = true,	-- Corruption
	[48181] = true,		-- Haunt
	[348] = true,		-- Immolate
	[30108] = true,		-- Unstable Affliction
	-- Warrior
	[5246] = true,		-- Intimidating Shout
	[132168] = true,	-- Shockwave
	[262115] = true,	-- Deep Wounds
	-- Racial
	[20549] = true,		-- War Stomp (Tauren)
	[107079] = true,	-- Quaking Palm (Pandaren)
}

for _, spell in pairs(C.nameplate.debuffs_list) do
	T.DebuffWhiteList[spell] = true
end

T.DebuffBlackList = {
	-- [spellID] = true,	-- Spell Name
}

for _, spell in pairs(C.nameplate.ignore_list) do
	T.DebuffBlackList[spell] = true
end

T.BuffWhiteList = {
	-- [SpellName(226510)] = true,	-- Sanguine Ichor
}

for _, spell in pairs(C.nameplate.buffs_list) do
	T.BuffWhiteList[SpellName(spell)] = true
end

T.BuffBlackList = {
	-- [SpellName(spellID)] = true,	-- Spell Name
}

T.PlateBlacklist = {
	["24207"] = true,	-- Army of the Dead
	["29630"] = true,	-- Fanged Pit Viper (Gundrak)
	["55659"] = true,	-- Wild Imp
	["167966"] = true,	-- Experimental Sludge (De Other Side)
}

T.InterruptCast = { -- Yellow border for interruptible cast
	-- The War Within Season 1
	[461904] = true,	-- Cosmic Ascension
	[462508] = true,	-- Dark Prayer
	-- Algeth'ar Academy
	[396812] = true,	-- Mystic Blast
	[332612] = true,	-- Healing Touch
	[377389] = true,	-- Call of the Flock
	[387843] = true,	-- Astral Bomb
	-- The Azure Vault
	[370225] = true,	-- Shriek
	-- The Nokhud Offensive
	[386024] = true,	-- Tempest
	[373395] = true,	-- Bloodcurdling Shout
	-- Halls of Valor
	[215433] = true,	-- Holy Radiance
	-- Shadowmoon Burial Grounds
	[152818] = true,	-- Shadow Mend
	-- Temple of the Jade Serpent
	[395859] = true,	-- Haunting Scream
}

T.ImportantCast = { -- Red border for non-interruptible cast
	-- The Nokhud Offensive
	[383823] = true,	-- Rally the Clan
	-- Ruby Life Pools
	[372743] = true,	-- Ice Shield
	-- Court of Stars
	[210261] = true,	-- Sound Alarm
}

for _, spell in pairs(C.nameplate.cast_color_list) do
	T.InterruptCast[spell] = true
end

local color = C.nameplate.mob_color
local color_alt = C.nameplate.mob_color_alt
T.ColorPlate = {
	-- Midnight
	["caster"] = color,			-- All caster mobs
	["miniboss"] = color_alt,	-- All miniboss
	-- Algeth'ar Academy
	["196548"] = color,			-- Ancient Branch
	-- The Azure Vault
	["187159"] = color_alt,		-- Shrieking Whelp
	-- The Nokhud Offensive
	["194894"] = color,			-- Primalist Stormspeaker
	-- Temple of the Jade Serpent
	["59555"] = color,			-- Haunting Sha
	["59545"] = color,			-- The Golden Beetle
	-- Court of Stars
	["104251"] = color_alt,		-- Duskwatch Sentry
	-- PvP
	["5925"] = color,			-- Grounding Totem
}

for word in gmatch(C.nameplate.mob_color_list, "%S+") do
	T.ColorPlate[tostring(word)] = color
end

for word in gmatch(C.nameplate.mob_color_alt_list, "%S+") do
	T.ColorPlate[tostring(word)] = color_alt
end

T.ShortNames = {
	-- Академия Алгет'ар
	["Рассерженная стрекотуха"] = "Cтрекотуха",
	["Мерзкий плеточник"] = "Плеточник",
	["Алгет'арский охранник"] = "Охранник",
	["Алгет'арский рыцарь эха"] = "Рыцарь",
	["Алгет'арская заклинательница"] = "Заклинательница",
	["Алгет'арский целитель"] = "Целитель",
	-- Наступление клана Нокхуд
	["Мастер копья из клана Нокхуд"] = "Мастер копья",
	["Лучница из клана Нокхуд"] = "Лучница",
	["Боевое копье клана Нокхуд"] = "Копье",
	["Трубач из клана Нокхуд"] = "Трубач",
	["Нокхудский копейщик"] = "Копейщик",
	["Громовой кулак из клана Нокхуд"] = "Кулак",
	["Псарь из клана Нокхуд"] = "Псарь",
	["Заступник из клана Нокхуд"] = "Заступник",
	-- Квартал Звезд
	["Караульный из Сумеречной стражи"] = "Караульный",
	["Часовой из Сумеречной стражи"] = "Часовой",
	["Бдительный инквизитор"] = "Инквизитор",
	["Пылающий бес"] = "Бес",
	["Порабощенная Скверной карательница"] = "Карательница",
}
local T, C, L = unpack(ShestakUI)

----------------------------------------------------------------------------------------
--	The best way to add or delete spell is to go at www.wowhead.com, search for a spell.
--	Example: Renew -> http://www.wowhead.com/spell=139
--	Take the number ID at the end of the URL, and add it to the list
----------------------------------------------------------------------------------------
if C.raidframe.plugins_buffs then
	T.RaidBuffs = {
		DRUID = {
			{774, "TOPRIGHT", {0.8, 0.4, 0.8}},					-- Rejuvenation
			{48438, "BOTTOMRIGHT", {0.8, 0.4, 0}},				-- Wild Growth
			{8936, "BOTTOMLEFT", {0.2, 0.8, 0.2}},				-- Regrowth
			{33763, "TOPLEFT", {0.4, 0.8, 0.2}},				-- Lifebloom
			-- {391891, "TOP", {0.2, 0.7, 0.2}},					-- Adaptive Swarm
			-- {102351, "BOTTOM", {0.2, 0.7, 0.2}},				-- Cenarion Ward
			-- {102342, "LEFT", {0.45, 0.3, 0.2}, true},			-- Ironbark
			{155777, "RIGHT", {0.4, 0.9, 0.4}},					-- Rejuvenation (Germination)
		},
		EVOKER = {
			-- Preservation
			{355941, "TOPRIGHT", {0.20, 0.58, 0.50}},			-- Dream Breath
			{363502, "BOTTOMLEFT", {0.26, 0.73, 0.63}},			-- Dream Flight
			{366155, "RIGHT", {0.14, 1.00, 0.88}},				-- Reversion
			{364343, "TOP", {0.13, 0.87, 0.50}},				-- Echo
			{373267, "TOPLEFT", {0.82, 0.29, 0.24}},			-- Life Bind (Verdant Embrace)
			-- {357170, "BOTTOM", {0.11, 0.57, 0.71}},				-- Time Dilation
			-- {376788, "BOTTOMRIGHT", {0.11, 0.57, 0.71}},		-- Dream Breath (Echo)
			-- Augmentation
			{360827, "TOPRIGHT", {0.33, 0.33, 0.77}},			-- Blistering Scales
			{410089, "TOP", {0.13, 0.87, 0.50}},				-- Prescience
			{395152, "BOTTOMRIGHT", {0.14, 1.00, 0.88}},		-- Ebon Might
			-- {406732, "RIGHT", {0.82, 0.29, 0.24}},				-- Spatial Paradox < on yourself
		},
		MONK = {
			{119611, "TOPRIGHT", {0.2, 0.7, 0.7}},				-- Renewing Mist
			-- {116841, "RIGHT", {0.12, 1.00, 0.53}},				-- Tiger's Lust (Freedom)
			{115175, "BOTTOMRIGHT", {0.7, 0.4, 0}},				-- Soothing Mist
			{124682, "BOTTOMLEFT", {0.4, 0.8, 0.2}},			-- Enveloping Mist
			-- {325209, "BOTTOM", {0.3, 0.6, 0.6}},				-- Enveloping Breath
			{450769, "TOPLEFT", {0.3, 0.6, 0.6}},				-- Aspect of Harmony
			-- {116849, "LEFT", {0.81, 0.85, 0.1}, true},			-- Life Cocoon
		},
		PALADIN = {
			{53563, "TOPRIGHT", {0.7, 0.3, 0.7}},				-- Beacon of Light
			{156910, "TOPRIGHT", {0.7, 0.3, 0.7}},				-- Beacon of Faith
			{1244893, "TOPRIGHT", {0.7, 0.3, 0.7}},				-- Beacon of the Savior
			-- {157047, "TOP", {0.15, 0.58, 0.84}},				-- Saved by the Light (T25 Talent)
			-- {1022, "BOTTOMRIGHT", {0.2, 0.2, 1}, true},			-- Blessing of Protection
			-- {1044, "BOTTOMRIGHT", {0.89, 0.45, 0}, true},		-- Blessing of Freedom
			-- {6940, "BOTTOMRIGHT", {0.89, 0.1, 0.1}, true},		-- Blessing of Sacrifice
			-- {204018, "BOTTOMRIGHT", {0.4, 0.6, 0.8}, true},		-- Blessing of Spellwarding
			{156322, "BOTTOMLEFT", {0.9, 0.5, 0.1}},				-- Eternal Flame
		},
		PRIEST = {
			{194384, "TOPRIGHT", {0.8, 0.4, 0.2}},				-- Atonement
			{139, "TOP", {0.4, 0.7, 0.2}},						-- Renew
			{41635, "BOTTOMRIGHT", {0.2, 0.7, 0.2}},			-- Prayer of Mending
			{6788, "BOTTOMLEFT", {1, 0, 0}},					-- Weakened Soul
			{17, "TOPLEFT", {0.81, 0.85, 0.1}},					-- Power Word: Shield
			-- {33206, "LEFT", {0.89, 0.1, 0.1}, true},			-- Pain Suppression
			-- {47788, "LEFT", {0.86, 0.52, 0}, true},				-- Guardian Spirit
		},
		SHAMAN = {
			{61295, "TOPRIGHT", {0.7, 0.3, 0.7}},				-- Riptide
			{974, "BOTTOMRIGHT", {0.91, 0.80, 0.44}},			-- Earth Shield
			{382024, "BOTTOMLEFT", {0.8, 0.9, 0.7}},			-- Earthliving Weapon
		},
		HUNTER = {
			{35079, "TOPRIGHT", {0.2, 0.2, 1}},					-- Misdirection
			{90361, "TOP", {0.34, 0.47, 0.31}},					-- Spirit Mend (HoT)
		},
		ROGUE = {
			{57934, "TOPRIGHT", {0.89, 0.1, 0.1}},				-- Tricks of the Trade
		},
		WARRIOR  = {
			{3411, "TOPRIGHT", {0.89, 0.1, 0.1}},				-- Intervene
		},
		WARLOCK = {
			{20707, "TOPRIGHT", {0.7, 0.32, 0.75}},				-- Soulstone
		},
		ALL = {
			{23333, "LEFT", {1, 0, 0}, true},					-- Warsong flag, Horde
			{23335, "LEFT", {0, 0, 1}, true},					-- Warsong flag, Alliance
			{34976, "LEFT", {1, 0, 0}, true},					-- Netherstorm Flag
		},
	}

	T.RaidBuffsIgnore = {
		--[spellID] = true,			-- Spell name
	}
end

local function SpellName(id)
	local name = GetSpellInfo(id)
	if name then
		return name
	else
		print("|cffff0000ShestakUI: RaidDebuffs spell ID ["..tostring(id).."] no longer exists!|r")
		return "Empty"
	end
end

----------------------------------------------------------------------------------------
--	Debuffs
----------------------------------------------------------------------------------------
if C.raidframe.plugins_debuffs ~= true then return end

local RaidDebuffs = {
	-- Manaforge Omega
	-- Plexus Sentinel
	-- [SpellName(1219459)] = 3,	-- Manifest Matrices
}

local DungeonDebuffs = {
	-- The War Within Season 1
	-- [SpellName(440313)] = 6,	-- Void Rift
}

local OtherDebuffs = {
	[SpellName(87023)] = 4,		-- Cauterize
	[SpellName(94794)] = 4,		-- Rocket Fuel Leak
	[SpellName(116888)] = 4,	-- Shroud of Purgatory
	[SpellName(121175)] = 2,	-- Orb of Power (PvP)
	[SpellName(160029)] = 3,	-- Resurrecting (Pending CR)
	[SpellName(225080)] = 3,	-- Reincarnation (Ankh ready)
	[SpellName(255234)] = 3,	-- Totemic Revival
}

-- Add spells from GUI
for _, spell in pairs(C.raidframe.plugins_debuffs_list) do
	OtherDebuffs[SpellName(spell)] = 3
end

for spell, prio in pairs(OtherDebuffs) do
	RaidDebuffs[spell] = prio
	DungeonDebuffs[spell] = prio
end

-----------------------------------------------------------------
-- PvP
-----------------------------------------------------------------
if C.raidframe.plugins_pvp_debuffs == true then
	local PvPDebuffs = {
	-- Death Knight
	[SpellName(47476)] = 2,		-- Strangulate
	[SpellName(108194)] = 4,	-- Asphyxiate
	[SpellName(207171)] = 4,	-- Winter is Coming
	[SpellName(206961)] = 3,	-- Tremble Before Me
	[SpellName(207167)] = 4,	-- Blinding Sleet
	[SpellName(212540)] = 1,	-- Flesh Hook (Pet)
	[SpellName(91807)] = 1,		-- Shambling Rush (Pet)
	[SpellName(204085)] = 1,	-- Deathchill
	[SpellName(233395)] = 1,	-- Frozen Center
	[SpellName(212332)] = 4,	-- Smash (Pet)
	[SpellName(212337)] = 4,	-- Powerful Smash (Pet)
	[SpellName(91800)] = 4,		-- Gnaw (Pet)
	[SpellName(91797)] = 4,		-- Monstrous Blow (Pet)
	[SpellName(210141)] = 3,	-- Zombie Explosion
	-- Demon Hunter
	[SpellName(207685)] = 4,	-- Sigil of Misery
	[SpellName(217832)] = 3,	-- Imprison
	[SpellName(204490)] = 4,	-- Sigil of Silence
	[SpellName(179057)] = 3,	-- Chaos Nova
	[SpellName(211881)] = 4,	-- Fel Eruption
	[SpellName(205630)] = 3,	-- Illidan's Grasp
	[SpellName(213491)] = 4,	-- Demonic Trample
	-- Druid
	[SpellName(81261)] = 2,		-- Solar Beam
	[SpellName(5211)] = 4,		-- Mighty Bash
	[SpellName(163505)] = 4,	-- Rake
	[SpellName(203123)] = 4,	-- Maim
	[SpellName(202244)] = 4,	-- Overrun
	[SpellName(99)] = 4,		-- Incapacitating Roar
	[SpellName(33786)] = 5,		-- Cyclone
	[SpellName(45334)] = 1,		-- Immobilized
	[SpellName(102359)] = 1,	-- Mass Entanglement
	[SpellName(339)] = 1,		-- Entangling Roots
	[SpellName(2637)] = 1,		-- Hibernate
	[SpellName(102793)] = 1,	-- Ursol's Vortex
	-- Evoker
	[SpellName(355689)] = 4,	-- Landslide
	[SpellName(370898)] = 1,	-- Permeating Chill
	[SpellName(360806)] = 3,	-- Sleep Walk
	-- Hunter
	[SpellName(202933)] = 4,	-- Spider Sting
	[SpellName(213691)] = 4,	-- Scatter Shot
	[SpellName(19386)] = 3,		-- Wyvern Sting
	[SpellName(3355)] = 3,		-- Freezing Trap
	[SpellName(209790)] = 3,	-- Freezing Arrow
	[SpellName(24394)] = 4,		-- Intimidation
	[SpellName(117526)] = 4,	-- Binding Shot
	[SpellName(190927)] = 1,	-- Harpoon
	[SpellName(201158)] = 1,	-- Super Sticky Tar
	[SpellName(162480)] = 1,	-- Steel Trap
	[SpellName(212638)] = 1,	-- Tracker's Net
	[SpellName(200108)] = 1,	-- Ranger's Net
	-- Mage
	[SpellName(118)] = 3,		-- Polymorph
	[SpellName(82691)] = 3,		-- Ring of Frost
	[SpellName(31661)] = 3,		-- Dragon's Breath
	[SpellName(122)] = 1,		-- Frost Nova
	[SpellName(33395)] = 1,		-- Freeze
	[SpellName(157997)] = 1,	-- Ice Nova
	[SpellName(228600)] = 1,	-- Glacial Spike
	[SpellName(198121)] = 1,	-- Frostbite
	-- Monk
	[SpellName(119381)] = 4,	-- Leg Sweep
	[SpellName(202346)] = 4,	-- Double Barrel
	[SpellName(115078)] = 4,	-- Paralysis
	[SpellName(198909)] = 3,	-- Song of Chi-Ji
	[SpellName(202274)] = 3,	-- Incendiary Brew
	[SpellName(233759)] = 4,	-- Grapple Weapon
	[SpellName(123407)] = 1,	-- Spinning Fire Blossom
	[SpellName(116706)] = 1,	-- Disable
	[SpellName(232055)] = 4,	-- Fists of Fury
	-- Paladin
	[SpellName(853)] = 3,		-- Hammer of Justice
	[SpellName(20066)] = 3,		-- Repentance
	[SpellName(105421)] = 3,	-- Blinding Light
	[SpellName(31935)] = 2,		-- Avenger's Shield
	[SpellName(217824)] = 4,	-- Shield of Virtue
	[SpellName(205290)] = 3,	-- Wake of Ashes
	-- Priest
	[SpellName(9484)] = 3,		-- Shackle Undead
	[SpellName(200196)] = 4,	-- Holy Word: Chastise
	[SpellName(605)] = 5,		-- Mind Control
	[SpellName(8122)] = 3,		-- Psychic Scream
	[SpellName(15487)] = 2,		-- Silence
	[SpellName(64044)] = 1,		-- Psychic Horror
	[SpellName(453)] = 5,		-- Mind Soothe
	-- Rogue
	[SpellName(2094)] = 4,		-- Blind
	[SpellName(6770)] = 4,		-- Sap
	[SpellName(1776)] = 4,		-- Gouge
	[SpellName(1330)] = 2,		-- Garrote - Silence
	[SpellName(207777)] = 4,	-- Dismantle
	[SpellName(408)] = 4,		-- Kidney Shot
	[SpellName(1833)] = 4,		-- Cheap Shot
	[SpellName(207736)] = 5,	-- Shadowy Duel (Smoke effect)
	[SpellName(212182)] = 5,	-- Smoke Bomb
	-- Shaman
	[SpellName(51514)] = 3,		-- Hex
	[SpellName(118905)] = 3,	-- Static Charge
	[SpellName(77505)] = 4,		-- Earthquake (Knocking down)
	[SpellName(118345)] = 4,	-- Pulverize (Pet)
	[SpellName(204399)] = 3,	-- Earthfury
	[SpellName(204437)] = 3,	-- Lightning Lasso
	[SpellName(157375)] = 4,	-- Gale Force
	[SpellName(64695)] = 1,		-- Earthgrab
	-- Warlock
	[SpellName(710)] = 5,		-- Banish
	[SpellName(6789)] = 3,		-- Mortal Coil
	[SpellName(118699)] = 3,	-- Fear
	[SpellName(6358)] = 3,		-- Seduction (Succub)
	[SpellName(171017)] = 4,	-- Meteor Strike (Infernal)
	[SpellName(22703)] = 4,		-- Infernal Awakening (Infernal CD)
	[SpellName(30283)] = 3,		-- Shadowfury
	[SpellName(89766)] = 4,		-- Axe Toss
	[SpellName(233582)] = 1,	-- Entrenched in Flame
	-- Warrior
	[SpellName(5246)] = 4,		-- Intimidating Shout
	[SpellName(132169)] = 4,	-- Storm Bolt
	[SpellName(132168)] = 4,	-- Shockwave
	[SpellName(199085)] = 4,	-- Warpath
	[SpellName(105771)] = 1,	-- Charge
	[SpellName(199042)] = 1,	-- Thunderstruck
	[SpellName(236077)] = 4,	-- Disarm
	-- Racial
	[SpellName(20549)] = 4,		-- War Stomp
	[SpellName(107079)] = 4,	-- Quaking Palm
	}

	tinsert(T.RaidBuffs["ALL"], {284402, "RIGHT", {1, 0, 0}, true})	-- Vampiric Touch (Don't dispel)
	tinsert(T.RaidBuffs["ALL"], {30108, "RIGHT", {1, 0, 0}, true})	-- Unstable Affliction (Don't dispel)

	for spell, prio in pairs(PvPDebuffs) do
		OtherDebuffs[spell] = prio
	end
end

T.RaidDebuffsReverse = {
	--[spellID] = true,			-- Spell name
}

T.RaidDebuffsIgnore = {
	[980] = true,			-- Agony
	[1943] = true,			-- Rupture
	[425180] = true,		-- Vicious Brand
}

T.RaidDebuffs = OtherDebuffs
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", function()
	T.RaidDebuffs = {} -- wipe and collect depending of zone

	local _, instanceType = IsInInstance()
	if instanceType == "raid" then
		T.RaidDebuffs = RaidDebuffs
	elseif instanceType == "party" then
		T.RaidDebuffs = DungeonDebuffs
	else
		T.RaidDebuffs = OtherDebuffs
	end
end)
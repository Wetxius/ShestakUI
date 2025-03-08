local T, C, L = unpack(ShestakUI)
if C.raidframe.plugins_aura_watch ~= true then return end

----------------------------------------------------------------------------------------
--	The best way to add or delete spell is to go at www.wowhead.com, search for a spell.
--	Example: Renew -> http://www.wowhead.com/spell=139
--	Take the number ID at the end of the URL, and add it to the list
----------------------------------------------------------------------------------------
T.RaidBuffs = {
	DRUID = {
		{774, "TOPRIGHT", {0.8, 0.4, 0.8}},					-- Rejuvenation
		{48438, "BOTTOMRIGHT", {0.8, 0.4, 0}},				-- Wild Growth
		{8936, "BOTTOMLEFT", {0.2, 0.8, 0.2}},				-- Regrowth
		{33763, "TOPLEFT", {0.4, 0.8, 0.2}},				-- Lifebloom
		{391891, "TOP", {0.2, 0.7, 0.2}},					-- Adaptive Swarm
		{102351, "BOTTOM", {0.2, 0.7, 0.2}},				-- Cenarion Ward
		{102342, "LEFT", {0.45, 0.3, 0.2}, true},			-- Ironbark
		{155777, "RIGHT", {0.4, 0.9, 0.4}},					-- Rejuvenation (Germination)
	},
	EVOKER = {
		-- Preservation
		{355941, "TOPRIGHT", {0.20, 0.58, 0.50}},			-- Dream Breath
		{363502, "BOTTOMLEFT", {0.26, 0.73, 0.63}},			-- Dream Flight
		{366155, "RIGHT", {0.14, 1.00, 0.88}},				-- Reversion
		{364343, "TOP", {0.13, 0.87, 0.50}},				-- Echo
		{373267, "TOPLEFT", {0.82, 0.29, 0.24}},			-- Life Bind (Verdant Embrace)
		{357170, "BOTTOM", {0.11, 0.57, 0.71}},				-- Time Dilation
		-- Augmentation
		{360827, "TOPRIGHT", {0.33, 0.33, 0.77}},			-- Blistering Scales
		{410089, "TOP", {0.13, 0.87, 0.50}},				-- Prescience
		{395296, "BOTTOMRIGHT", {0.14, 1.00, 0.88}},		-- Ebon Might
		{406732, "RIGHT", {0.82, 0.29, 0.24}},				-- Spatial Paradox < on yourself
	},
	MONK = {
		{119611, "TOPRIGHT", {0.2, 0.7, 0.7}},				-- Renewing Mist
		{116841, "RIGHT", {0.12, 1.00, 0.53}},				-- Tiger's Lust (Freedom)
		{115175, "BOTTOMRIGHT", {0.7, 0.4, 0}},				-- Soothing Mist
		{124682, "BOTTOMLEFT", {0.4, 0.8, 0.2}},			-- Enveloping Mist
		{325209, "BOTTOM", {0.3, 0.6, 0.6}},				-- Enveloping Breath
		{116849, "LEFT", {0.81, 0.85, 0.1}, true},			-- Life Cocoon
	},
	PALADIN = {
		{53563, "TOPRIGHT", {0.7, 0.3, 0.7}},				-- Beacon of Light
		{156910, "TOPRIGHT", {0.7, 0.3, 0.7}},				-- Beacon of Faith
		{200025, "TOPRIGHT", {0.7, 0.3, 0.7}},				-- Beacon of Virtue
		{157047, "TOP", {0.15, 0.58, 0.84}},				-- Saved by the Light (T25 Talent)
		{1022, "BOTTOMRIGHT", {0.2, 0.2, 1}, true},			-- Blessing of Protection
		{1044, "BOTTOMRIGHT", {0.89, 0.45, 0}, true},		-- Blessing of Freedom
		{6940, "BOTTOMRIGHT", {0.89, 0.1, 0.1}, true},		-- Blessing of Sacrifice
		{204018, "BOTTOMRIGHT", {0.4, 0.6, 0.8}, true},		-- Blessing of Spellwarding
		{287280, "BOTTOMLEFT", {0.9, 0.5, 0.1}},			-- Glimmer of Light
		{223306, "TOPLEFT", {0.8, 0.8, 0.1}},				-- Bestow Faith
	},
	PRIEST = {
		{194384, "TOPRIGHT", {0.8, 0.4, 0.2}},				-- Atonement
		{139, "TOP", {0.4, 0.7, 0.2}},						-- Renew
		{41635, "BOTTOMRIGHT", {0.2, 0.7, 0.2}},			-- Prayer of Mending
		{6788, "BOTTOMLEFT", {1, 0, 0}},					-- Weakened Soul
		{17, "TOPLEFT", {0.81, 0.85, 0.1}},					-- Power Word: Shield
		{33206, "LEFT", {0.89, 0.1, 0.1}, true},			-- Pain Suppression
		{47788, "LEFT", {0.86, 0.52, 0}, true},				-- Guardian Spirit
	},
	SHAMAN = {
		{61295, "TOPRIGHT", {0.7, 0.3, 0.7}},				-- Riptide
		{974, "BOTTOMRIGHT", {0.91, 0.80, 0.44}},			-- Earth Shield
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

local function SpellName(id)
	local name = GetSpellInfo(id)
	if name then
		return name
	else
		print("|cffff0000ShestakUI: RaidAuraWatch spell ID ["..tostring(id).."] no longer exists!|r")
		return "Empty"
	end
end

----------------------------------------------------------------------------------------
--	Debuffs
----------------------------------------------------------------------------------------
local RaidDebuffs = {
	-- Liberation of Undermine

	-- Nerub'ar Palace
	-- Ulgrax the Devourer
	[SpellName(434705)] = 3,	-- Tenderized
	[SpellName(435138)] = 3,	-- Digestive Acid
	[SpellName(439037)] = 3,	-- Disembowel
	[SpellName(439419)] = 3,	-- Stalker Netting
	[SpellName(434778)] = 3,	-- Brutal Lashings
	[SpellName(435136)] = 3,	-- Venomous Lash
	[SpellName(438012)] = 3,	-- Hungering Bellows
	-- The Bloodbound Horror
	[SpellName(442604)] = 3,	-- Goresplatter
	[SpellName(445570)] = 3,	-- Unseeming Blight
	[SpellName(443612)] = 3,	-- Baneful Shift
	[SpellName(443042)] = 3,	-- Grasp From Beyond
	-- Sikran
	[SpellName(435410)] = 3,	-- Phase Lunge
	[SpellName(458277)] = 3,	-- Shattering Sweep
	[SpellName(438845)] = 3,	-- Expose
	[SpellName(433517)] = 3,	-- Phase Blades
	[SpellName(459785)] = 3,	-- Cosmic Residue
	[SpellName(459273)] = 3,	-- Cosmic Shards
	-- Rasha'nan
	[SpellName(439785)] = 3,	-- Corrosion
	[SpellName(439786)] = 3,	-- Rolling Acid
	[SpellName(439787)] = 3,	-- Acidic Stupor
	[SpellName(458067)] = 3,	-- Savage Wound
	[SpellName(456170)] = 3,	-- Spinneret's Strands
	[SpellName(439780)] = 3,	-- Sticky Webs
	[SpellName(439776)] = 3,	-- Acid Pool
	[SpellName(455287)] = 3,	-- Infested Bite
	-- Eggtender Ovi'nax
	[SpellName(442257)] = 3,	-- Infest
	[SpellName(442799)] = 3,	-- Sanguine Overflow
	[SpellName(441362)] = 3,	-- Volatile Concotion
	[SpellName(442660)] = 3,	-- Rupture
	[SpellName(440421)] = 3,	-- Experimental Dosage
	[SpellName(442250)] = 3,	-- Fixate
	[SpellName(442437)] = 3,	-- Violent Discharge
	[SpellName(443274)] = 3,	-- Reverberation
	-- Nexus-Princess Ky'veza
	[SpellName(440377)] = 3,	-- Void Shredders
	[SpellName(436870)] = 3,	-- Assassination
	[SpellName(440576)] = 3,	-- Chasmal Gash
	[SpellName(437343)] = 3,	-- Queensbane
	[SpellName(436664)] = 3,	-- Regicide
	-- The Silken Court
	[SpellName(450129)] = 3,	-- Entropic Desolation
	[SpellName(449857)] = 3,	-- Impaled
	[SpellName(438749)] = 3,	-- Scarab Fixation
	[SpellName(438708)] = 3,	-- Stinging Swarm
	[SpellName(438218)] = 3,	-- Piercing Strike
	[SpellName(454311)] = 3,	-- Barbed Webs
	[SpellName(438773)] = 3,	-- Shattered Shell
	[SpellName(438355)] = 3,	-- Cataclysmic Entropy
	[SpellName(438656)] = 3,	-- Venomous Rain
	[SpellName(441772)] = 3,	-- Void Bolt
	[SpellName(441788)] = 3,	-- Web Vortex
	[SpellName(440001)] = 3,	-- Binding Webs
	[SpellName(449857)] = 3,	-- Impaled
	[SpellName(438218)] = 3,	-- Piercing Strike
	-- Queen Ansurek
	[SpellName(441865)] = 3,	-- Royal Shackles
	[SpellName(436800)] = 3,	-- Liquefy
	[SpellName(455404)] = 3,	-- Feast
	[SpellName(439829)] = 3,	-- Silken Tomb
	[SpellName(437586)] = 3,	-- Reactive Toxin
}

local DungeonDebuffs = {
	-- The War Within Season 1
	[SpellName(440313)] = 6,	-- Void Rift

	-- The Rookery (Season 2)
	[SpellName(429493)] = 3,	-- Unstable Corruption
	[SpellName(424739)] = 3,	-- Chaotic Corruption
	[SpellName(426160)] = 3,	-- Dark Gravity
	[SpellName(1214324)] = 3,	-- Crashing Thunder
	[SpellName(424966)] = 3,	-- Lingering Void
	[SpellName(467907)] = 3,	-- Festering Void
	[SpellName(458082)] = 3,	-- Stormrider's Charge
	[SpellName(472764)] = 3,	-- Void Extraction
	[SpellName(427616)] = 3,	-- Energized Barrage
	[SpellName(430814)] = 3,	-- Attracting Shadows
	[SpellName(430179)] = 3,	-- Seeping Corruption
	[SpellName(1214523)] = 3,	-- Feasting Void

	-- Priory of the Sacred Flame (Season 2)
	[SpellName(424414)] = 3,	-- Pierce Armor
	[SpellName(423015)] = 3,	-- Castigator's Shield
	[SpellName(447439)] = 3,	-- Savage Mauling
	[SpellName(425556)] = 3,	-- Sanctified Ground
	[SpellName(428170)] = 3,	-- Blinding Light
	[SpellName(448492)] = 3,	-- Thunderclap
	[SpellName(427621)] = 3,	-- Impale
	[SpellName(446403)] = 3,	-- Sacrificial Flame
	[SpellName(451764)] = 3,	-- Radiant Flame
	[SpellName(424426)] = 3,	-- Lunging Strike
	[SpellName(448787)] = 3,	-- Purification
	[SpellName(435165)] = 3,	-- Blazing Strike
	[SpellName(448515)] = 3,	-- Divine Judgment
	[SpellName(427635)] = 3,	-- Grievous Rip
	[SpellName(427897)] = 3,	-- Heat Wave
	[SpellName(424430)] = 3,	-- Consecration
	[SpellName(453461)] = 3,	-- Caltrops
	[SpellName(427900)] = 3,	-- Molten Pool

	-- Cinderbrew Meadery (Season 2)
	[SpellName(441397)] = 3,	-- Bee Venom
	[SpellName(431897)] = 3,	-- Rowdy Yell
	[SpellName(442995)] = 3,	-- Swarming Surprise
	[SpellName(437956)] = 3,	-- Erupting Inferno
	[SpellName(434773)] = 3,	-- Mean Mug
	[SpellName(438975)] = 3,	-- Shredding Sting
	[SpellName(463220)] = 3,	-- Volatile Keg
	[SpellName(449090)] = 3,	-- Reckless Delivery
	[SpellName(437721)] = 3,	-- Boiling Flames
	[SpellName(441179)] = 3,	-- Oozing Honey
	[SpellName(434707)] = 3,	-- Cinderbrew Toss
	[SpellName(445180)] = 3,	-- Crawling Brawl
	[SpellName(442589)] = 3,	-- Beeswax
	[SpellName(435789)] = 3,	-- Cindering Wounds
	[SpellName(432182)] = 3,	-- Throw Cinderbrew
	[SpellName(436644)] = 3,	-- Burning Ricochet
	[SpellName(436624)] = 3,	-- Cash Cannon
	[SpellName(439325)] = 3,	-- Burning Fermentation
	[SpellName(432196)] = 3,	-- Hot Honey
	[SpellName(439586)] = 3,	-- Fluttering Wing
	[SpellName(440141)] = 3,	-- Honey Marinade

	-- Darkflame Cleft (Season 2)
	[SpellName(426943)] = 3,	-- Rising Gloom
	[SpellName(427015)] = 3,	-- Shadowblast
	[SpellName(422648)] = 3,	-- Darkflame Pickaxe
	[SpellName(1218308)] = 3,	-- Enkindling Inferno
	[SpellName(422245)] = 3,	-- Rock Buster
	[SpellName(423693)] = 3,	-- Luring Candleflame
	[SpellName(421638)] = 3,	-- Wicklighter Barrage
	[SpellName(424223)] = 3,	-- Incite Flames
	[SpellName(421146)] = 3,	-- Throw Darkflame
	[SpellName(427180)] = 3,	-- Fear of the Gloom
	[SpellName(424322)] = 3,	-- Explosive Flame
	[SpellName(420307)] = 3,	-- Candlelight
	[SpellName(422806)] = 3,	-- Smothering Shadows
	[SpellName(469620)] = 3,	-- Creeping Shadow
	[SpellName(443694)] = 3,	-- Crude Weapons
	[SpellName(428019)] = 3,	-- Flashpoint
	[SpellName(423501)] = 3,	-- Wild Wallop
	[SpellName(426277)] = 3,	-- One-Hand Headlock
	[SpellName(423654)] = 3,	-- Ouch!
	[SpellName(421653)] = 3,	-- Cursed Wax
	[SpellName(421067)] = 3,	-- Molten Wax
	[SpellName(426883)] = 3,	-- Bonk!
	[SpellName(440653)] = 3,	-- Surging Flamethrower

	-- Operation: Floodgate (Season 2)
	[SpellName(462737)] = 3,	-- Black Blood Wound
	[SpellName(1213803)] = 3,	-- Nailed
	[SpellName(468672)] = 3,	-- Pinch
	[SpellName(468616)] = 3,	-- Leaping Spark
	[SpellName(469799)] = 3,	-- Overcharge
	[SpellName(469811)] = 3,	-- Backwash
	[SpellName(468680)] = 3,	-- Crabsplosion
	[SpellName(473051)] = 3,	-- Rushing Tide
	[SpellName(474351)] = 3,	-- Shreddation Sawblade
	[SpellName(465830)] = 3,	-- Warp Blood
	[SpellName(468723)] = 3,	-- Shock Water
	[SpellName(474388)] = 3,	-- Flamethrower
	[SpellName(472338)] = 3,	-- Surveyed Ground
	[SpellName(462771)] = 3,	-- Surveying Beam
	[SpellName(473836)] = 3,	-- Electrocrush
	[SpellName(470038)] = 3,	-- Razorchoke Vines
	[SpellName(473713)] = 3,	-- Kinetic Explosive Gel
	[SpellName(468811)] = 3,	-- Gigazap
	[SpellName(466188)] = 3,	-- Thunder Punch
	[SpellName(460965)] = 3,	-- Barreling Charge
	[SpellName(472878)] = 3,	-- Sludge Claws
	[SpellName(473224)] = 3,	-- Sonic Boom

	-- The Stonevault (Season 1)
	[SpellName(427329)] = 3,	-- Void Corruption
	[SpellName(435813)] = 3,	-- Void Empowerment
	[SpellName(423572)] = 3,	-- Void Empowerment
	[SpellName(424889)] = 3,	-- Seismic Reverberation
	[SpellName(424795)] = 3,	-- Refracting Beam
	[SpellName(457465)] = 3,	-- Entropy
	[SpellName(425974)] = 3,	-- Ground Pound
	[SpellName(445207)] = 3,	-- Piercing Wail
	[SpellName(428887)] = 3,	-- Smashed
	[SpellName(427382)] = 3,	-- Concussive Smash
	[SpellName(449154)] = 3,	-- Molten Mortar
	[SpellName(427361)] = 3,	-- Fracture
	[SpellName(443494)] = 3,	-- Crystalline Eruption
	[SpellName(424913)] = 3,	-- Volatile Explosion
	[SpellName(443954)] = 3,	-- Exhaust Vents
	[SpellName(426308)] = 3,	-- Void Infection
	[SpellName(429999)] = 3,	-- Flaming Scrap
	[SpellName(429545)] = 3,	-- Censoring Gear
	[SpellName(428819)] = 3,	-- Exhaust Vents

	-- City of Threads (Season 1)
	[SpellName(434722)] = 3,	-- Subjugate
	[SpellName(439341)] = 3,	-- Splice
	[SpellName(440437)] = 3,	-- Shadow Shunpo
	[SpellName(448561)] = 3,	-- Shadows of Doubt
	[SpellName(440107)] = 3,	-- Knife Throw
	[SpellName(439324)] = 3,	-- Umbral Weave
	[SpellName(442285)] = 3,	-- Corrupted Coating
	[SpellName(440238)] = 3,	-- Ice Sickles
	[SpellName(461842)] = 3,	-- Oozing Smash
	[SpellName(434926)] = 3,	-- Lingering Influence
	[SpellName(440310)] = 3,	-- Chains of Oppression
	[SpellName(439646)] = 3,	-- Process of Elimination
	[SpellName(448562)] = 3,	-- Doubt
	[SpellName(441391)] = 3,	-- Dark Paranoia
	[SpellName(461989)] = 3,	-- Oozing Smash
	[SpellName(441298)] = 3,	-- Freezing Blood
	[SpellName(441286)] = 3,	-- Dark Paranoia
	[SpellName(452151)] = 3,	-- Rigorous Jab
	[SpellName(451239)] = 3,	-- Brutal Jab
	[SpellName(443509)] = 3,	-- Ravenous Swarm
	[SpellName(443437)] = 3,	-- Shadows of Doubt
	[SpellName(451295)] = 3,	-- Void Rush
	[SpellName(443427)] = 3,	-- Web Bolt
	[SpellName(461630)] = 3,	-- Venomous Spray
	[SpellName(445435)] = 3,	-- Black Blood
	[SpellName(443401)] = 3,	-- Venom Strike
	[SpellName(443430)] = 3,	-- Silk Binding
	[SpellName(443438)] = 3,	-- Doubt
	[SpellName(443435)] = 3,	-- Twist Thoughts
	[SpellName(443432)] = 3,	-- Silk Binding
	[SpellName(448047)] = 3,	-- Web Wrap
	[SpellName(451426)] = 3,	-- Gossamer Barrage
	[SpellName(446718)] = 3,	-- Umbral Weave
	[SpellName(450055)] = 3,	-- Gutburst
	[SpellName(450783)] = 3,	-- Perfume Toss

	-- The Dawnbreaker (Season 1)
	[SpellName(463428)] = 3,	-- Lingering Erosion
	[SpellName(426736)] = 3,	-- Shadow Shroud
	[SpellName(434096)] = 3,	-- Sticky Webs
	[SpellName(453173)] = 3,	-- Collapsing Night
	[SpellName(426865)] = 3,	-- Dark Orb
	[SpellName(434090)] = 3,	-- Spinneret's Strands
	[SpellName(434579)] = 3,	-- Corrosion
	[SpellName(426735)] = 3,	-- Burning Shadows
	[SpellName(434576)] = 3,	-- Acidic Stupor
	[SpellName(452127)] = 3,	-- Animate Shadows
	[SpellName(438957)] = 3,	-- Acid Pools
	[SpellName(434441)] = 3,	-- Rolling Acid
	[SpellName(451119)] = 3,	-- Abyssal Blast
	[SpellName(453345)] = 3,	-- Abyssal Rot
	[SpellName(449332)] = 3,	-- Encroaching Shadows
	[SpellName(431333)] = 3,	-- Tormenting Beam
	[SpellName(431309)] = 3,	-- Ensnaring Shadows
	[SpellName(451107)] = 3,	-- Bursting Cocoon
	[SpellName(434406)] = 3,	-- Rolling Acid
	[SpellName(431491)] = 3,	-- Tainted Slash
	[SpellName(434113)] = 3,	-- Spinneret's Strands
	[SpellName(431350)] = 3,	-- Tormenting Eruption
	[SpellName(431365)] = 3,	-- Tormenting Ray
	[SpellName(434668)] = 3,	-- Sparking Arathi Bomb
	[SpellName(460135)] = 3,	-- Dark Scars
	[SpellName(451098)] = 3,	-- Tacky Nova
	[SpellName(450855)] = 3,	-- Dark Orb
	[SpellName(431494)] = 3,	-- Black Edge
	[SpellName(451115)] = 3,	-- Terrifying Slam
	[SpellName(432448)] = 3,	-- Stygian Seed

	-- Ara-Kara, City of Echoes (Season 1)
	[SpellName(461487)] = 3,	-- Cultivated Poisons
	[SpellName(432227)] = 3,	-- Venom Volley
	[SpellName(432119)] = 3,	-- Faded
	[SpellName(433740)] = 3,	-- Infestation
	[SpellName(439200)] = 3,	-- Voracious Bite
	[SpellName(433781)] = 3,	-- Ceaseless Swarm
	[SpellName(432132)] = 3,	-- Erupting Webs
	[SpellName(434252)] = 3,	-- Massive Slam
	[SpellName(432031)] = 3,	-- Grasping Blood
	[SpellName(438599)] = 3,	-- Bleeding Jab
	[SpellName(438618)] = 3,	-- Venomous Spit
	[SpellName(436401)] = 3,	-- AUGH!
	[SpellName(434830)] = 3,	-- Vile Webbing
	[SpellName(436322)] = 3,	-- Poison Bolt
	[SpellName(434083)] = 3,	-- Ambush
	[SpellName(433843)] = 3,	-- Erupting Webs

	-- Previous Expansion Dungeons (Season 2)
	-- Theater of Pain
 	[SpellName(333299)] = 3,	-- Curse of Desolation
 	[SpellName(319539)] = 3,	-- Soulless
 	[SpellName(326892)] = 3,	-- Fixate
 	[SpellName(321768)] = 3,	-- On the Hook
 	[SpellName(323825)] = 3,	-- Grasping Rift
 	[SpellName(342675)] = 3,	-- Bone Spear
 	[SpellName(323831)] = 3,	-- Death Grasp
 	[SpellName(330608)] = 3,	-- Vile Eruption
 	[SpellName(330868)] = 3,	-- Necrotic Bolt Volley
 	[SpellName(323750)] = 3,	-- Vile Gas
 	[SpellName(323406)] = 3,	-- Jagged Gash
 	[SpellName(330700)] = 3,	-- Decaying Blight
 	[SpellName(319626)] = 3,	-- Phantasmal Parasite
 	[SpellName(324449)] = 3,	-- Manifest Death
 	[SpellName(341949)] = 3,	-- Withering Blight
 	[SpellName(333861)] = 3,	-- Ricocheting Blade

	-- The MOTHERLODE!!
 	[SpellName(263074)] = 4,	-- Festering Bite
 	[SpellName(280605)] = 4,	-- Brain Freeze
 	[SpellName(257337)] = 4,	-- Shocking Claw
 	[SpellName(270882)] = 5,	-- Blazing Azerite
 	[SpellName(268797)] = 4,	-- Transmute: Enemy to Goo
 	[SpellName(259856)] = 4,	-- Chemical Burn
 	[SpellName(269302)] = 3,	-- Toxic Blades
 	[SpellName(280604)] = 3,	-- Iced Spritzer
 	[SpellName(257371)] = 4,	-- Tear Gas
 	[SpellName(257544)] = 4,	-- Jagged Cut
 	[SpellName(268846)] = 4,	-- Echo Blade
 	[SpellName(262794)] = 5,	-- Energy Lash
 	[SpellName(262513)] = 5,	-- Azerite Heartseeker
 	[SpellName(260838)] = 5,	-- Homing Missle
 	[SpellName(263637)] = 4,	-- Clothesline

	-- Operation: Mechagon
 	[SpellName(291928)] = 3,	-- Giga-Zap
 	[SpellName(302274)] = 3,	-- Fulminating Zap
 	[SpellName(298669)] = 3,	-- Taze
 	[SpellName(295445)] = 3,	-- Wreck
 	[SpellName(294929)] = 3,	-- Blazing Chomp
 	[SpellName(297257)] = 3,	-- Electrical Charge
 	[SpellName(294855)] = 3,	-- Blossom Blast
 	[SpellName(291972)] = 3,	-- Explosive Leap
 	[SpellName(285443)] = 3,	-- "Hidden" Flame Cannon
 	[SpellName(291974)] = 3,	-- Obnoxious Monologue
 	[SpellName(296150)] = 3,	-- Vent Blast
 	[SpellName(298602)] = 3,	-- Smoke Cloud
 	[SpellName(296560)] = 3,	-- Clinging Static
 	[SpellName(297283)] = 3,	-- Cave In
 	[SpellName(291914)] = 3,	-- Cutting Beam
 	[SpellName(302384)] = 3,	-- Static Discharge

	-- Previous Expansion Dungeons (Season 1)
	-- Mists of Tirna Scithe
	[SpellName(325027)] = 3,	-- Bramble Burst
	[SpellName(323043)] = 3,	-- Bloodletting
	[SpellName(322557)] = 3,	-- Soul Split
	[SpellName(331172)] = 3,	-- Mind Link
	[SpellName(322563)] = 3,	-- Marked Prey
	[SpellName(322487)] = 3,	-- Overgrowth
	[SpellName(328756)] = 3,	-- Repulsive Visage
	[SpellName(325021)] = 3,	-- Mistveil Tear
	[SpellName(321891)] = 3,	-- Freeze Tag Fixation
	[SpellName(325224)] = 3,	-- Anima Injection
	[SpellName(326092)] = 3,	-- Debilitating Poison
	[SpellName(325418)] = 3,	-- Volatile Acid

	-- The Necrotic Wake
	[SpellName(321821)] = 3,	-- Disgusting Guts
	[SpellName(323365)] = 3,	-- Clinging Darkness
	[SpellName(338353)] = 3,	-- Goresplatter
	[SpellName(333485)] = 3,	-- Disease Cloud
	[SpellName(338357)] = 3,	-- Tenderize
	[SpellName(328181)] = 3,	-- Frigid Cold
	[SpellName(320170)] = 3,	-- Necrotic Bolt
	[SpellName(323464)] = 3,	-- Dark Ichor
	[SpellName(323198)] = 3,	-- Dark Exile
	[SpellName(343504)] = 3,	-- Dark Grasp
	[SpellName(343556)] = 3,	-- Morbid Fixation
	[SpellName(324381)] = 3,	-- Chill Scythe
	[SpellName(320573)] = 3,	-- Shadow Well
	[SpellName(333492)] = 3,	-- Necrotic Ichor
	[SpellName(334748)] = 3,	-- Drain Fluids
	[SpellName(333489)] = 3,	-- Necrotic Breath
	[SpellName(320717)] = 3,	-- Blood Hunger

	-- Siege of Boralus
	[SpellName(257168)] = 3,	-- Cursed Slash
	[SpellName(272588)] = 3,	-- Rotting Wounds
	[SpellName(272571)] = 3,	-- Choking Waters
	[SpellName(274991)] = 3,	-- Putrid Waters
	[SpellName(275835)] = 3,	-- Stinging Venom Coating
	[SpellName(273930)] = 3,	-- Hindering Cut
	[SpellName(257292)] = 3,	-- Heavy Slash
	[SpellName(261428)] = 3,	-- Hangman's Noose
	[SpellName(256897)] = 3,	-- Clamping Jaws
	[SpellName(272874)] = 3,	-- Trample
	[SpellName(273470)] = 3,	-- Gut Shot
	[SpellName(272834)] = 3,	-- Viscous Slobber
	[SpellName(257169)] = 3,	-- Terrifying Roar
	[SpellName(272713)] = 3,	-- Crushing Slam

	-- Grim Batol
	[SpellName(449885)] = 3,	-- Shadow Gale
	[SpellName(449474)] = 3,	-- Molten Spark
	[SpellName(456773)] = 3,	-- Twilight Wind
	[SpellName(448953)] = 3,	-- Rumbling Earth
	[SpellName(447268)] = 3,	-- Skullsplitter
	[SpellName(449536)] = 3,	-- Molten Pool
	[SpellName(450095)] = 3,	-- Curse of Entropy
	[SpellName(448057)] = 3,	-- Abyssal Corruption
	[SpellName(451871)] = 3,	-- Mass Temor
	[SpellName(451613)] = 3,	-- Twilight Flame
	[SpellName(451378)] = 3,	-- Rive
	[SpellName(76711)] = 3,		-- Sear Mind
	[SpellName(462220)] = 3,	-- Blazing Shadowflame
	[SpellName(451395)] = 3,	-- Corrupt
	[SpellName(82850)] = 3,		-- Flaming Fixate
	[SpellName(451241)] = 3,	-- Shadowflame Slash
	[SpellName(451965)] = 3,	-- Molten Wake
	[SpellName(451224)] = 3,	-- Enveloping Shadowflame
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
for _, spell in pairs(C.raidframe.plugins_aura_watch_list) do
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
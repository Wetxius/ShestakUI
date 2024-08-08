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

T.RaidDebuffs = {
	----------------------------------------------------------
	------------------------- General ------------------------
	----------------------------------------------------------
	-- Misc
	[SpellName(160029)] = 3, -- Resurrecting (Pending CR)
	----------------------------------------------------------
	-------------------- Mythic+ Specific --------------------
	----------------------------------------------------------
	-- Mythic+ Affixes
	[SpellName(226512)] = 3,	-- Sanguine
	[SpellName(240559)] = 3,	-- Grievous
	[SpellName(240443)] = 3,	-- Bursting
	-- Dragonflight Season 3
	[SpellName(409492)] = 6,	-- Afflicted Cry
	
	----------------------------------------------------------
	---------------- The War Within Dungeons -----------------
	----------------------------------------------------------
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
	--Beta[SpellName(463428)] = 3,	-- Lingering Erosion
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
	-- The Rookery (Season 2)
	-- Priory of the Sacred Flame (Season 2)
	-- Cinderbrew Meadery (Season 2)
	-- Darkflame Cleft (Season 2)
	----------------------------------------------------------
	--------------- The War Within (Season 1) ----------------
	----------------------------------------------------------
	-- Mists of Tirna Scithe
	[SpellName(325027)] = 3,	-- Bramble Burst
	[SpellName(323043)] = 3,	-- Bloodletting
	[SpellName(322557)] = 3,	-- Soul Split
	[SpellName(331172)] = 3,	-- Mind Link
	[SpellName(322563)] = 3,	-- Marked Prey
	[SpellName(322487)] = 3,	-- Overgrowth 1
	[SpellName(322486)] = 3,	-- Overgrowth 2
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
	[SpellName(343556)] = 3,	-- Morbid Fixation 1
	[SpellName(338606)] = 3,	-- Morbid Fixation 2
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
	[SpellName(449885)] = 3,	-- Shadow Gale 1
	[SpellName(461513)] = 3,	-- Shadow Gale 2
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
	[SpellName(76711)] = 3,	-- Sear Mind
	[SpellName(462220)] = 3,	-- Blazing Shadowflame
	[SpellName(451395)] = 3,	-- Corrupt
	[SpellName(82850)] = 3,	-- Flaming Fixate
	[SpellName(451241)] = 3,	-- Shadowflame Slash
	[SpellName(451965)] = 3,	-- Molten Wake
	[SpellName(451224)] = 3,	-- Enveloping Shadowflame
	---------------------------------------------------------
	------------------- Nerub'ar Palace ---------------------
	---------------------------------------------------------
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
	[SpellName(433517)] = 3,	-- Phase Blades 1
	[SpellName(434860)] = 3,	-- Phase Blades 2
	[SpellName(459785)] = 3,	-- Cosmic Residue
	[SpellName(459273)] = 3,	-- Cosmic Shards
	-- Rasha'nan
	[SpellName(439785)] = 3,	-- Corrosion
	[SpellName(439786)] = 3,	-- Rolling Acid 1
	[SpellName(439790)] = 3,	-- Rolling Acid 2
	[SpellName(439787)] = 3,	-- Acidic Stupor
	[SpellName(458067)] = 3,	-- Savage Wound
	[SpellName(456170)] = 3,	-- Spinneret's Strands 1
	[SpellName(439783)] = 3,	-- Spinneret's Strands 2
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
	[SpellName(436664)] = 3,	-- Regicide 1
	[SpellName(436666)] = 3,	-- Regicide 2
	[SpellName(435486)] = 3,	-- Regicide 3
	--[SpellName(435535)] = 3,	-- Regicide 4
	[SpellName(436665)] = 3,	-- Regicide 5
	[SpellName(436663)] = 3,	-- Regicide 6
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
	-- Queen Ansurek
	-- TODO: No raid testing available for this boss
	----------------------------------------------------------
	----------------- Dragonflight Dungeons ------------------
	----------------------------------------------------------
	
	---------------------------------------------------------
	-- Aberrus, the Shadowed Crucible
	---------------------------------------------------------
	-- Kazzara
	[SpellName(406530)] = 3,	-- Riftburn
	[SpellName(402420)] = 3,	-- Molten Scar
	[SpellName(402253)] = 3,	-- Ray of Anguish
	[SpellName(406525)] = 3,	-- Dread Rift
	[SpellName(404743)] = 3,	-- Terror Claws
	-- Molgoth
	[SpellName(405084)] = 3,	-- Lingering Umbra
	[SpellName(405645)] = 3,	-- Engulfing Heat
	[SpellName(405642)] = 3,	-- Blistering Twilight
	[SpellName(402617)] = 3,	-- Blazing Heat
	[SpellName(401809)] = 3,	-- Corrupting Shadow
	[SpellName(405394)] = 3,	-- Shadowflame
	-- Experimentation of Dracthyr
	[SpellName(406317)] = 3,	-- Rending Charge
	[SpellName(405392)] = 3,	-- Disintegrate
	[SpellName(406233)] = 3,	-- Deep Breath
	[SpellName(407327)] = 3,	-- Unstable Essence
	[SpellName(406313)] = 3,	-- Infused Strikes
	[SpellName(407302)] = 3,	-- Infused Explosion
	-- Zaqali Invasion
	[SpellName(408873)] = 3,	-- Heavy Cudgel
	[SpellName(410353)] = 3,	-- Flaming Cudgel
	[SpellName(407017)] = 3,	-- Vigorous Gale
	[SpellName(401452)] = 3,	-- Blazing Spear
	[SpellName(409275)] = 3,	-- Magma Flow
	-- Rashok
	[SpellName(407547)] = 3,	-- Flaming Upsurge
	[SpellName(407597)] = 3,	-- Earthen Crush
	[SpellName(405819)] = 3,	-- Searing Slam
	[SpellName(408857)] = 3,	-- Doom Flame
	-- Zskarn
	[SpellName(404955)] = 3,	-- Shrapnel Bomb
	[SpellName(404010)] = 3,	-- Unstable Embers
	[SpellName(404942)] = 3,	-- Searing Claws
	[SpellName(403978)] = 3,	-- Blast Wave
	[SpellName(405592)] = 3,	-- Salvage Parts
	[SpellName(405462)] = 3,	-- Dragonfire Traps
	[SpellName(409942)] = 3,	-- Elimination Protocol
	-- Magmorax
	[SpellName(408955)] = 3,	-- Incinerating Maws
	[SpellName(402994)] = 3,	-- Molten Spittle
	[SpellName(403747)] = 3,	-- Igniting Roar
	-- Echo of Neltharion
	[SpellName(409373)] = 3,	-- Disrupt Earth
	[SpellName(407182)] = 3,	-- Rushing Shadows
	[SpellName(405484)] = 3,	-- Surrendering to Corruption
	[SpellName(409058)] = 3,	-- Seeping Lava
	[SpellName(402120)] = 3,	-- Collapsed Earth
	[SpellName(407728)] = 3,	-- Sundered Shadow
	[SpellName(401998)] = 3,	-- Calamitous Strike
	[SpellName(408160)] = 3,	-- Shadow Strike
	[SpellName(403846)] = 3,	-- Sweeping Shadows
	[SpellName(401133)] = 3,	-- Wildshift (Druid)
	[SpellName(401131)] = 3,	-- Wild Summoning (Warlock)
	[SpellName(401130)] = 3,	-- Wild Magic (Mage)
	[SpellName(401135)] = 3,	-- Wild Breath (Evoker)
	[SpellName(408071)] = 3,	-- Shapeshifter's Fervor
	[SpellName(410953)] = 3,	-- Volcanic Heart
	-- Scalecommander Sarkareth
	[SpellName(403520)] = 3,	-- Embrace of Nothingness
	[SpellName(401383)] = 3,	-- Oppressing Howl
	[SpellName(401951)] = 3,	-- Oblivion
	[SpellName(407496)] = 3,	-- Infinite Duress
	[SpellName(401680)] = 3,	-- Mass Disintegrate

	-----------------------------------------------------------------
	-- Vault of the Incarnates
	-----------------------------------------------------------------
	-- Eranog
	[SpellName(370648)] = 5,	-- Primal Flow
	[SpellName(390715)] = 6,	-- Primal Rifts
	[SpellName(370597)] = 6,	-- Kill Order
	-- Terros
	[SpellName(381253)] = 5,	-- Awakened Earth
	[SpellName(386352)] = 3,	-- Rock Blast
	[SpellName(382458)] = 6,	-- Resonant Aftermath
	-- The Primal Council
	[SpellName(371624)] = 5,	-- Conductive Mark
	[SpellName(372027)] = 4,	-- Slashing Blaze
	[SpellName(374039)] = 4,	-- Meteor Axe
	-- Sennarth, the Cold Breath
	[SpellName(371976)] = 4,	-- Chilling Blast
	[SpellName(372082)] = 5,	-- Enveloping Webs
	[SpellName(374659)] = 4,	-- Rush
	[SpellName(374104)] = 5,	-- Wrapped in Webs
	[SpellName(373048)] = 3,	-- Suffocating Webs
	-- Dathea, Ascended
	[SpellName(391686)] = 5,	-- Conductive Mark
	[SpellName(388290)] = 4,	-- Cyclone
	-- Kurog Grimtotem
	[SpellName(377780)] = 5,	-- Skeletal Fractures
	[SpellName(372514)] = 5,	-- Frost Bite
	[SpellName(374554)] = 4,	-- Lava Pool
	[SpellName(374023)] = 6,	-- Searing Carnage
	[SpellName(374427)] = 6,	-- Ground Shatter
	[SpellName(390920)] = 5,	-- Shocking Burst
	[SpellName(372458)] = 6,	-- Below Zero
	-- Broodkeeper Diurna
	[SpellName(388920)] = 6,	-- Frozen Shroud
	[SpellName(378782)] = 5,	-- Mortal Wounds
	[SpellName(378787)] = 5,	-- Crushing Stoneclaws
	[SpellName(375620)] = 6,	-- Ionizing Charge
	[SpellName(375578)] = 4,	-- Flame Sentry
	-- Raszageth the Storm-Eater
	[SpellName(381615)] = 4,	-- Static Charge
	[SpellName(399713)] = 4,	-- Magnetic Charge
	[SpellName(385073)] = 5,	-- Ball Lightning
	[SpellName(377467)] = 4,	-- Fulminating Charge

	-----------------------------------------------------------------
	-- Amirdrassil: The Dream's Hope
	-----------------------------------------------------------------
	-- Gnarlroot
	[SpellName(421972)] = 3,	-- Controlled Burn
	[SpellName(424734)] = 3,	-- Uprooted Agony
	[SpellName(426106)] = 3,	-- Dreadfire Barrage
	[SpellName(425002)] = 3,	-- Ember-Charred I
	[SpellName(421038)] = 3,	-- Ember-Charred II
	-- Igira the Cruel
	[SpellName(414367)] = 3,	-- Gathering Torment
	[SpellName(424065)] = 3,	-- Wracking Skewer I
	[SpellName(416056)] = 3,	-- Wracking Skever II
	[SpellName(414888)] = 3,	-- Blistering Spear
	-- Volcoross
	[SpellName(419054)] = 3,	-- Molten Venom
	[SpellName(421207)] = 3,	-- Coiling Flames
	[SpellName(423494)] = 3,	-- Tidal Blaze
	[SpellName(423759)] = 3,	-- Serpent's Crucible
	-- Council of Dreams
	[SpellName(420948)] = 3,	-- Barreling Charge
	[SpellName(421032)] = 3,	-- Captivating Finale
	[SpellName(420858)] = 3,	-- Poisonous Javelin
	[SpellName(418589)] = 3,	-- Polymorph Bomb
	[SpellName(421031)] = 4, 	-- Song of the Dragon
	[SpellName(426390)] = 3,	-- Corrosive Pollen
	-- Larodar, Keeper of the Flame
	[SpellName(425888)] = 3,	-- Igniting Growth
	[SpellName(426249)] = 3,	-- Blazing Coalescence
	[SpellName(421594)] = 3,	-- Smoldering Suffocation
	[SpellName(427299)] = 3,	-- Flash Fire
	[SpellName(428901)] = 3,	-- Ashen Devastation
	-- Nymue, Weaver of the Cycle
	[SpellName(423195)] = 3,	-- Inflorescence
	[SpellName(427137)] = 3,	-- Threads of Life I
	[SpellName(427138)] = 3,	-- Threads of Life II
	[SpellName(428273)] = 3,	-- Woven Resonance
	-- Smolderon
	[SpellName(426018)] = 3,	-- Seeking Inferno
	[SpellName(421455)] = 3,	-- Overheated
	[SpellName(421643)] = 4, 	-- Emberscar's Mark
	[SpellName(421656)] = 3,	-- Cauterizing Wound
	[SpellName(425574)] = 3,	-- Lingering Burn
	-- Tindral Sageswift, Seer of the Flame
	[SpellName(427297)] = 3,	-- Flame Surge
	[SpellName(424581)] = 3,	-- Fiery Growth
	[SpellName(424580)] = 3,	-- Falling Stars
	[SpellName(424578)] = 3,	-- Blazing Mushroom
	[SpellName(424579)] = 5,	-- Suppressive Ember
	[SpellName(424495)] = 3,	-- Mass Entanblement
	[SpellName(424665)] = 3,	-- Seed of Flame
	-- Fyrakk the Blazing
-----------------------------------------------------------------
-- Dungeons
-----------------------------------------------------------------
	-----------------------------------------------------------------
	-- Dragonflight (Season 1)
	-----------------------------------------------------------------
	-- Court of Stars
	[SpellName(207278)] = 3,	-- Arcane Lockdown
	[SpellName(209516)] = 3,	-- Mana Fang
	[SpellName(209512)] = 3,	-- Disrupting Energy
	[SpellName(211473)] = 3,	-- Shadow Slash
	[SpellName(207979)] = 3,	-- Shockwave
	[SpellName(207980)] = 3,	-- Disintegration Beam
	[SpellName(211464)] = 3,	-- Fel Detonation
	[SpellName(208165)] = 3,	-- Withering Soul
	[SpellName(209413)] = 3,	-- Suppress
	[SpellName(209027)] = 3,	-- Quelling Strike
	-- Halls of Valor
	[SpellName(197964)] = 3,	-- Runic Brand
	[SpellName(193783)] = 3,	-- Aegis of Aggramar
	[SpellName(196838)] = 3,	-- Scent of Blood
	[SpellName(199674)] = 3,	-- Wicked Dagger
	[SpellName(193260)] = 3,	-- Static Field
	[SpellName(193743)] = 3,	-- Aegis of Aggramar Wielder
	[SpellName(199652)] = 3,	-- Sever
	[SpellName(198944)] = 3,	-- Breach Armor
	[SpellName(215430)] = 3,	-- Thunderstrike
	[SpellName(203963)] = 3,	-- Eye of the Storm
	[SpellName(196497)] = 3,	-- Ravenous Leap
	[SpellName(193660)] = 3,	-- Felblaze Rush
	-- Shadowmoon Burial Grounds
	[SpellName(156776)] = 3,	-- Rending Voidlash
	[SpellName(153692)] = 3,	-- Necrotic Pitch
	[SpellName(153524)] = 3,	-- Plague Spit
	[SpellName(154469)] = 3,	-- Ritual of Bones
	[SpellName(162652)] = 3,	-- Lunar Purity
	[SpellName(164907)] = 3,	-- Void Cleave
	[SpellName(152979)] = 3,	-- Soul Shred
	[SpellName(158061)] = 3,	-- Blessed Waters of Purity
	[SpellName(154442)] = 3,	-- Malevolence
	[SpellName(153501)] = 3,	-- Void Blast
	-- Temple of the Jade Serpent
	[SpellName(396150)] = 3,	-- Feeling of Superiority
	[SpellName(397878)] = 3,	-- Tainted Ripple
	[SpellName(106113)] = 3,	-- Touch of Nothingness
	[SpellName(397914)] = 3,	-- Defiling Mist
	[SpellName(397904)] = 3,	-- Setting Sun Kick
	[SpellName(397911)] = 3,	-- Touch of Ruin
	[SpellName(395859)] = 3,	-- Haunting Scream
	[SpellName(374037)] = 3,	-- Overwhelming Rage
	[SpellName(396093)] = 3,	-- Savage Leap
	[SpellName(106823)] = 3,	-- Serpent Strike
	[SpellName(396152)] = 3,	-- Feeling of Inferiority
	[SpellName(110125)] = 3,	-- Shattered Resolve
	[SpellName(397797)] = 3,	-- Corrupted Vortex
	-- Ruby Life Pools
	[SpellName(392406)] = 3,	-- Thunderclap
	[SpellName(372820)] = 3,	-- Scorched Earth
	[SpellName(384823)] = 3,	-- Inferno
	[SpellName(381862)] = 3,	-- Infernocore
	[SpellName(372860)] = 3,	-- Searing Wounds
	[SpellName(373869)] = 3,	-- Burning Touch
	[SpellName(385536)] = 3,	-- Flame Dance
	[SpellName(381518)] = 3,	-- Winds of Change
	[SpellName(372858)] = 3,	-- Searing Blows
	[SpellName(372682)] = 3,	-- Primal Chill
	[SpellName(373693)] = 3,	-- Living Bomb
	[SpellName(392924)] = 3,	-- Shock Blast
	[SpellName(381515)] = 3,	-- Stormslam
	[SpellName(396411)] = 3,	-- Primal Overload
	[SpellName(384773)] = 3,	-- Flaming Embers
	[SpellName(392451)] = 3,	-- Flashfire
	[SpellName(372697)] = 3,	-- Jagged Earth
	[SpellName(372047)] = 3,	-- Flurry
	[SpellName(372963)] = 3,	-- Chillstorm
	-- The Nokhud Offensive
	[SpellName(382628)] = 3,	-- Surge of Power
	[SpellName(386025)] = 3,	-- Tempest
	[SpellName(381692)] = 3,	-- Swift Stab
	[SpellName(387615)] = 3,	-- Grasp of the Dead
	[SpellName(387629)] = 3,	-- Rotting Wind
	[SpellName(386912)] = 3,	-- Stormsurge Cloud
	[SpellName(395669)] = 3,	-- Aftershock
	[SpellName(384134)] = 3,	-- Pierce
	[SpellName(388451)] = 3,	-- Stormcaller's Fury
	[SpellName(395035)] = 3,	-- Shatter Soul
	[SpellName(376899)] = 3,	-- Crackling Cloud
	[SpellName(384492)] = 3,	-- Hunter's Mark
	[SpellName(376730)] = 3,	-- Stormwinds
	[SpellName(376894)] = 3,	-- Crackling Upheaval
	[SpellName(388801)] = 3,	-- Mortal Strike
	[SpellName(376827)] = 3,	-- Conductive Strike
	[SpellName(376864)] = 3,	-- Static Spear
	[SpellName(375937)] = 3,	-- Rending Strike
	[SpellName(376634)] = 3,	-- Iron Spear
	-- The Azure Vault
	[SpellName(388777)] = 3,	-- Oppressive Miasma
	[SpellName(386881)] = 3,	-- Frost Bomb
	[SpellName(387150)] = 3,	-- Frozen Ground
	[SpellName(387564)] = 3,	-- Mystic Vapors
	[SpellName(385267)] = 3,	-- Crackling Vortex
	[SpellName(386640)] = 3,	-- Tear Flesh
	[SpellName(374567)] = 3,	-- Explosive Brand
	[SpellName(374523)] = 3,	-- Arcane Roots
	[SpellName(375596)] = 3,	-- Erratic Growth Channel
	[SpellName(375602)] = 3,	-- Erratic Growth
	[SpellName(370764)] = 3,	-- Piercing Shards
	[SpellName(384978)] = 3,	-- Dragon Strike
	[SpellName(375649)] = 3,	-- Infused Ground
	[SpellName(387151)] = 3,	-- Icy Devastator
	[SpellName(377488)] = 3,	-- Icy Bindings
	[SpellName(374789)] = 3,	-- Infused Strike
	[SpellName(371007)] = 3,	-- Splintering Shards
	[SpellName(375591)] = 3,	-- Sappy Burst
	[SpellName(385409)] = 3,	-- Ouch, ouch, ouch!
	[SpellName(386549)] = 3,	-- Waking Bane
	-- Algeth'ar Academy
	[SpellName(389033)] = 3,	-- Lasher Toxin
	[SpellName(391977)] = 3,	-- Oversurge
	[SpellName(386201)] = 3,	-- Corrupted Mana
	[SpellName(389011)] = 3,	-- Overwhelming Power
	[SpellName(387932)] = 3,	-- Astral Whirlwind
	[SpellName(396716)] = 3,	-- Splinterbark
	[SpellName(388866)] = 3,	-- Mana Void
	[SpellName(386181)] = 3,	-- Mana Bomb
	[SpellName(388912)] = 3,	-- Severing Slash
	[SpellName(377344)] = 3,	-- Peck
	[SpellName(376997)] = 3,	-- Savage Peck
	[SpellName(388984)] = 3,	-- Vicious Ambush
	[SpellName(388544)] = 3,	-- Barkbreaker
	[SpellName(377008)] = 3,	-- Deafening Screech

	-----------------------------------------------------------------
	-- Dragonflight (Season 2)
	-----------------------------------------------------------------
	-- Freehold
	[SpellName(258323)] = 3,	-- Infected Wound
	[SpellName(257775)] = 3,	-- Plague Step
	[SpellName(257908)] = 3,	-- Oiled Blade
	[SpellName(257436)] = 3,	-- Poisoning Strike
	[SpellName(274389)] = 3,	-- Rat Traps
	[SpellName(274555)] = 3,	-- Scabrous Bites
	[SpellName(258875)] = 4,	-- Blackout Barrel
	[SpellName(256363)] = 3,	-- Ripper Punch
	[SpellName(258352)] = 3,	-- Grapeshot
	[SpellName(413136)] = 3,	-- Whirling Dagger
	-- Neltharion's Lair
	[SpellName(199705)] = 3,	-- Devouring
	[SpellName(199178)] = 3,	-- Spiked Tongue
	[SpellName(210166)] = 3,	-- Toxic Retch
	[SpellName(193941)] = 3,	-- Impaling Shard
	[SpellName(183465)] = 3,	-- Viscid Bile
	[SpellName(226296)] = 3,	-- Piercing Shards
	[SpellName(226388)] = 3,	-- Rancid Ooze
	[SpellName(200154)] = 3,	-- Burning Hatred
	[SpellName(183407)] = 3,	-- Acid Splatter
	[SpellName(215898)] = 3,	-- Crystalline Ground
	[SpellName(188494)] = 3,	-- Rancid Maw
	[SpellName(192800)] = 3,	-- Choking Dust
	-- Underrot
	[SpellName(265468)] = 3,	-- Withering Curse
	[SpellName(278961)] = 3,	-- Decaying Mind
	[SpellName(259714)] = 3,	-- Decaying Spores
	[SpellName(272180)] = 3,	-- Death Bolt
	[SpellName(272609)] = 3,	-- Maddening Gaze
	[SpellName(269301)] = 3,	-- Putrid Blood
	[SpellName(265533)] = 3,	-- Blood Maw
	[SpellName(265019)] = 3,	-- Savage Cleave
	[SpellName(265377)] = 3,	-- Hooked Snare
	[SpellName(265625)] = 3,	-- Dark Omen
	[SpellName(260685)] = 3,	-- Taint of G'huun
	[SpellName(266107)] = 3,	-- Thirst for Blood
	[SpellName(260455)] = 3,	-- Serrated Fangs
	-- Vortex Pinnacle
	[SpellName(87618)] = 3,		-- Static Cling
	[SpellName(410870)] = 3,	-- Cyclone
	[SpellName(86292)] = 3,		-- Cyclone Shield
	[SpellName(88282)] = 3,		-- Upwind of Altairus
	[SpellName(88286)] = 3,		-- Downwind of Altairus
	[SpellName(410997)] = 3,	-- Rushing Wind
	[SpellName(411003)] = 3,	-- Turbulence
	[SpellName(87771)] = 3,		-- Crusader Strike
	[SpellName(87759)] = 3,		-- Shockwave
	[SpellName(88314)] = 3,		-- Twisting Winds
	[SpellName(76622)] = 3,		-- Sunder Armor
	[SpellName(88171)] = 3,		-- Hurricane
	[SpellName(88182)] = 3,		-- Lethargic Poison
	-- Brackenhide Hollow
	[SpellName(385361)] = 3,	-- Rotting Sickness
	[SpellName(378020)] = 3,	-- Gash Frenzy
	[SpellName(385356)] = 3,	-- Ensnaring Trap
	[SpellName(373917)] = 3,	-- Decaystrike
	[SpellName(377864)] = 3,	-- Infectious Spit
	[SpellName(376933)] = 3,	-- Grasping Vines
	[SpellName(384425)] = 3,	-- Smell Like Meat
	[SpellName(373896)] = 3,	-- Withering Rot
	[SpellName(377844)] = 3,	-- Bladestorm
	[SpellName(378229)] = 3,	-- Marked for Butchery
	[SpellName(376149)] = 3,	-- Choking Rotcloud
	[SpellName(384725)] = 3,	-- Feeding Frenzy
	[SpellName(385303)] = 3,	-- Teeth Trap
	[SpellName(368299)] = 3,	-- Toxic Trap
	[SpellName(384970)] = 3,	-- Scented Meat
	[SpellName(368091)] = 3,	-- Infected Bite
	[SpellName(385185)] = 3,	-- Disoriented
	[SpellName(387210)] = 3,	-- Decaying Strength
	[SpellName(382808)] = 3,	-- Withering Contagion
	[SpellName(382723)] = 3,	-- Crushing Smash
	[SpellName(382787)] = 3,	-- Decay Claws
	[SpellName(385058)] = 3,	-- Withering Poison
	[SpellName(383399)] = 3,	-- Rotting Surge
	[SpellName(367484)] = 3,	-- Vicious Clawmangle
	[SpellName(367521)] = 3,	-- Bone Bolt
	[SpellName(368081)] = 3,	-- Withering
	[SpellName(374245)] = 3,	-- Rotting Creek
	[SpellName(367481)] = 3,	-- Bloody Bite
	-- Halls of Infusion
	[SpellName(387571)] = 3,	-- Focused Deluge
	[SpellName(383935)] = 3,	-- Spark Volley
	[SpellName(385555)] = 3,	-- Gulp
	[SpellName(384524)] = 3,	-- Titanic Fist
	[SpellName(385963)] = 3,	-- Frost Shock
	[SpellName(374389)] = 3,	-- Gulp Swog Toxin
	[SpellName(386743)] = 3,	-- Polar Winds
	[SpellName(389179)] = 3,	-- Power Overload
	[SpellName(389181)] = 3,	-- Power Field
	[SpellName(257274)] = 3,	-- Vile Coating
	[SpellName(375384)] = 3,	-- Rumbling Earth
	[SpellName(374563)] = 3,	-- Dazzle
	[SpellName(389446)] = 3,	-- Nullifying Pulse
	[SpellName(374615)] = 3,	-- Cheap Shot
	[SpellName(391610)] = 3,	-- Blinding Winds
	[SpellName(374724)] = 3,	-- Molten Subduction
	[SpellName(385168)] = 3,	-- Thunderstorm
	[SpellName(387359)] = 3,	-- Waterlogged
	[SpellName(391613)] = 3,	-- Creeping Mold
	[SpellName(374706)] = 3,	-- Pyretic Burst
	[SpellName(389443)] = 3,	-- Purifying Blast
	[SpellName(374339)] = 3,	-- Demoralizing Shout
	[SpellName(374020)] = 3,	-- Containment Beam
	[SpellName(391634)] = 3,	-- Deep Chill
	[SpellName(393444)] = 3,	-- Gushing Wound
	-- Neltharus
	[SpellName(374534)] = 3,	-- Heated Swings
	[SpellName(373735)] = 3,	-- Dragon Strike
	[SpellName(377018)] = 3,	-- Molten Gold
	[SpellName(374842)] = 3,	-- Blazing Aegis
	[SpellName(375890)] = 3,	-- Magma Eruption
	[SpellName(396332)] = 3,	-- Fiery Focus
	[SpellName(389059)] = 3,	-- Slag Eruption
	[SpellName(376784)] = 3,	-- Flame Vulnerability
	[SpellName(377542)] = 3,	-- Burning Ground
	[SpellName(374451)] = 3,	-- Burning Chain
	[SpellName(372461)] = 3,	-- Imbued Magma
	[SpellName(378818)] = 3,	-- Magma Conflagration
	[SpellName(377522)] = 3,	-- Burning Pursuit
	[SpellName(375204)] = 3,	-- Liquid Hot Magma
	[SpellName(374482)] = 3,	-- Grounding Chain
	[SpellName(372971)] = 3,	-- Reverberating Slam
	[SpellName(384161)] = 3,	-- Mote of Combustion
	[SpellName(374854)] = 3,	-- Erupted Ground
	[SpellName(373089)] = 3,	-- Scorching Fusillade
	[SpellName(372224)] = 3,	-- Dragonbone Axe
	[SpellName(372570)] = 3,	-- Bold Ambush
	[SpellName(372459)] = 3,	-- Burning
	[SpellName(372208)] = 3,	-- Djaradin Lava
	[SpellName(414585)] = 3,	-- Fiery Demise
	-- Uldaman: Legacy of Tyr
	[SpellName(368996)] = 3,	-- Purging Flames
	[SpellName(369792)] = 3,	-- Skullcracker
	[SpellName(372718)] = 3,	-- Earthen Shards
	[SpellName(382071)] = 3,	-- Resonating Orb
	[SpellName(377405)] = 3,	-- Time Sink
	[SpellName(369006)] = 3,	-- Burning Heat
	[SpellName(369110)] = 3,	-- Unstable Embers
	[SpellName(375286)] = 3,	-- Searing Cannonfire
	[SpellName(372652)] = 3,	-- Resonating Orb
	[SpellName(377825)] = 3,	-- Burning Pitch
	[SpellName(369411)] = 3,	-- Sonic Burst
	[SpellName(382576)] = 3,	-- Scorn of Tyr
	[SpellName(369366)] = 3,	-- Trapped in Stone
	[SpellName(369365)] = 3,	-- Curse of Stone
	[SpellName(369419)] = 3,	-- Venomous Fangs
	[SpellName(377486)] = 3,	-- Time Blade
	[SpellName(369818)] = 3,	-- Diseased Bite
	[SpellName(377732)] = 3,	-- Jagged Bite
	[SpellName(369828)] = 3,	-- Chomp
	[SpellName(369811)] = 3,	-- Brutal Slam
	[SpellName(376325)] = 3,	-- Eternity Zone
	[SpellName(369337)] = 3,	-- Difficult Terrain
	[SpellName(376333)] = 3,	-- Temporal Zone
	[SpellName(377510)] = 3,	-- Stolen Time
	-- Dawn of the Infinite
	[SpellName(413041)] = 3,	-- Sheared Lifespan 1
	[SpellName(416716)] = 3,	-- Sheared Lifespan 2
	[SpellName(413013)] = 3,	-- Chronoshear
	[SpellName(413208)] = 3,	-- Sand Buffeted
	[SpellName(408084)] = 3,	-- Necrofrost
	[SpellName(413142)] = 3,	-- Eon Shatter
	[SpellName(409266)] = 3,	-- Extinction Blast 1
	[SpellName(414300)] = 3,	-- Extinction Blast 2
	[SpellName(401667)] = 3,	-- Time Stasis
	[SpellName(412027)] = 3,	-- Chronal Burn
	[SpellName(400681)] = 3,	-- Spark of Tyr
	[SpellName(404141)] = 3,	-- Chrono-faded
	[SpellName(407147)] = 3,	-- Blight Seep
	[SpellName(410497)] = 3,	-- Mortal Wounds
	[SpellName(418009)] = 3,	-- Serrated Arrows
	[SpellName(407406)] = 3,	-- Corrosion
	[SpellName(401420)] = 3,	-- Sand Stomp
	[SpellName(403912)] = 3,	-- Accelerating Time
	[SpellName(403910)] = 3,	-- Decaying Time

	-----------------------------------------------------------------
	-- Dragonflight (Season 3)
	-----------------------------------------------------------------
	-- Darkheart Thicket
	[SpellName(198408)] = 3,	-- Nightfall
	[SpellName(196376)] = 3,	-- Grievous Tear
	[SpellName(200182)] = 3,	-- Festering Rip
	[SpellName(200238)] = 3,	-- Feed on the Weak
	[SpellName(200289)] = 3,	-- Growing Paranoia
	[SpellName(204667)] = 3,	-- Nightmare Breath
	[SpellName(204611)] = 3,	-- Crushing Grip
	[SpellName(199460)] = 3,	-- Falling Rocks
	[SpellName(200329)] = 3,	-- Overwhelming Terror
	[SpellName(191326)] = 3,	-- Breath of Corruption
	[SpellName(204243)] = 3,	-- Tormenting Eye
	[SpellName(225484)] = 3,	-- Grievous Rip
	[SpellName(200642)] = 3,	-- Despair
	[SpellName(199063)] = 3,	-- Strangling Roots
	[SpellName(198477)] = 3,	-- Fixate
	[SpellName(204246)] = 3,	-- Tormenting Fear
	[SpellName(198904)] = 3,	-- Poison Spear
	[SpellName(200684)] = 3,	-- Nightmare Toxin
	[SpellName(200243)] = 3,	-- Waking Nightmare
	[SpellName(200580)] = 3,	-- Maddening Roar
	[SpellName(200771)] = 3,	-- Propelling Charge
	[SpellName(200273)] = 3,	-- Cowardice
	[SpellName(201365)] = 3,	-- Darksoul Drain
	[SpellName(201839)] = 3,	-- Curse of Isolation
	[SpellName(201902)] = 3,	-- Scorching Shot
	-- Black Rook Hold
	[SpellName(202019)] = 3,	-- Shadow Bolt Volley
	[SpellName(197521)] = 3,	-- Blazing Trail
	[SpellName(197478)] = 3,	-- Dark Rush
	[SpellName(197546)] = 3,	-- Brutal Glaive
	[SpellName(198079)] = 3,	-- Hateful Gaze
	[SpellName(224188)] = 3,	-- Hateful Charge
	[SpellName(201733)] = 3,	-- Stinging Swarm
	[SpellName(194966)] = 3,	-- Soul Echoes
	[SpellName(198635)] = 3,	-- Unerring Shear
	[SpellName(225909)] = 3,	-- Soul Venom
	[SpellName(198501)] = 3,	-- Fel Vomitus
	[SpellName(198446)] = 3,	-- Fel Vomit
	[SpellName(200084)] = 3,	-- Soul Blade
	[SpellName(197821)] = 3,	-- Felblazed Ground
	[SpellName(203163)] = 3,	-- Sic Bats!
	[SpellName(199368)] = 3,	-- Legacy of the Ravencrest
	[SpellName(225732)] = 3,	-- Strike Down
	[SpellName(199168)] = 3,	-- Itchy!
	[SpellName(225963)] = 3,	-- Bloodthirsty Leap
	[SpellName(214002)] = 3,	-- Raven's Dive
	[SpellName(197974)] = 3,	-- Bonecrushing Strike I
	[SpellName(200261)] = 3,	-- Bonecrushing Strike II
	[SpellName(204896)] = 3,	-- Drain Life
	[SpellName(199097)] = 3,	-- Cloud of Hypnosis
	-- Waycrest Manor
	[SpellName(260703)] = 3,	-- Unstable Runic Mark
	[SpellName(261438)] = 3,	-- Wasting Strike
	[SpellName(261140)] = 3,	-- Virulent Pathogen
	[SpellName(260900)] = 3,	-- Soul Manipulation I
	[SpellName(260926)] = 3,	-- Soul Manipulation II
	[SpellName(260741)] = 3,	-- Jagged Nettles
	[SpellName(268086)] = 3,	-- Aura of Dread
	[SpellName(264712)] = 3,	-- Rotten Expulsion
	[SpellName(271178)] = 3,	-- Ravaging Leap
	[SpellName(264040)] = 3,	-- Uprooted Thorns
	[SpellName(265407)] = 3,	-- Dinner Bell
	[SpellName(265761)] = 3,	-- Thorned Barrage
	[SpellName(268125)] = 3,	-- Aura of Thorns
	[SpellName(268080)] = 3,	-- Aura of Apathy
	[SpellName(264050)] = 3,	-- Infected Thorn
	[SpellName(260569)] = 3,	-- Wildfire
	[SpellName(263943)] = 3,	-- Etch
	[SpellName(264378)] = 3,	-- Fragment Soul
	[SpellName(267907)] = 3,	-- Soul Thorns
	[SpellName(264520)] = 3,	-- Severing Serpent
	[SpellName(264105)] = 3,	-- Runic Mark
	[SpellName(265881)] = 3,	-- Decaying Touch
	[SpellName(265882)] = 3,	-- Lingering Dread
	[SpellName(278456)] = 3,	-- Infest I
	[SpellName(278444)] = 3,	-- Infest II
	[SpellName(265880)] = 3,	-- Dread Mark
	-- Atal'Dazar
	[SpellName(250585)] = 3,	-- Toxic Pool
	[SpellName(258723)] = 3,	-- Grotesque Pool
	[SpellName(260668)] = 3,	-- Transfusion I
	[SpellName(260666)] = 3,	-- Transfusion II
	[SpellName(255558)] = 3,	-- Tainted Blood
	[SpellName(250036)] = 3,	-- Shadowy Remains
	[SpellName(257483)] = 3,	-- Pile of Bones
	[SpellName(253562)] = 3,	-- Wildfire
	[SpellName(254959)] = 3,	-- Soulburn
	[SpellName(255814)] = 3,	-- Rending Maul
	[SpellName(255582)] = 3,	-- Molten Gold
	[SpellName(252687)] = 3,	-- Venomfang Strike
	[SpellName(255041)] = 3,	-- Terrifying Screech
	[SpellName(255567)] = 3,	-- Frenzied Charge
	[SpellName(255836)] = 3,	-- Transfusion Boss I
	[SpellName(255835)] = 3,	-- Transfusion Boss II
	[SpellName(250372)] = 3,	-- Lingering Nausea
	[SpellName(257407)] = 3,	-- Pursuit
	[SpellName(255434)] = 3,	-- Serrated Teeth
	[SpellName(255371)] = 3,	-- Terrifying Visage
	-- Everbloom
	[SpellName(427513)] = 3,	-- Noxious Discharge
	[SpellName(428834)] = 3,	-- Verdant Eruption
	[SpellName(427510)] = 3,	-- Noxious Charge
	[SpellName(427863)] = 3,	-- Frostbolt I
	[SpellName(169840)] = 3,	-- Frostbolt II
	[SpellName(428084)] = 3,	-- Glacial Fusion
	[SpellName(426991)] = 3,	-- Blazing Cinders
	[SpellName(169179)] = 3,	-- Colossal Blow
	[SpellName(164886)] = 3,	-- Dreadpetal Pollen
	[SpellName(169445)] = 3,	-- Noxious Eruption
	[SpellName(164294)] = 3,	-- Unchecked Growth I
	[SpellName(164302)] = 3,	-- Unchecked Growth II
	[SpellName(165123)] = 3,	-- Venom Burst
	[SpellName(169658)] = 3,	-- Poisonous Claws
	[SpellName(169839)] = 3,	-- Pyroblast
	[SpellName(164965)] = 3,	-- Choking Vines
	-- Throne of the Tides
	[SpellName(429048)] = 3,	-- Flame Shock
	[SpellName(427668)] = 3,	-- Festering Shockwave
	[SpellName(427670)] = 3,	-- Crushing Claw
	[SpellName(76363)]  = 3, 	-- Wave of Corruption
	[SpellName(426660)] = 3,	-- Razor Jaws
	[SpellName(426727)] = 3,	-- Acid Barrage
	[SpellName(428404)] = 3,	-- Blotting Darkness
	[SpellName(428403)] = 3,	-- Grimy
	[SpellName(426663)] = 3,	-- Ravenous Pursuit
	[SpellName(426783)] = 3,	-- Mind Flay
	[SpellName(75992)]  = 3, 	-- Lightning Surge
	[SpellName(428868)] = 3,	-- Putrid Roar
	[SpellName(428407)] = 3,	-- Blotting Barrage
	[SpellName(427559)] = 3,	-- Bubbling Ooze
	[SpellName(76516)]  = 3, 	-- Poisoned Spear
	[SpellName(428542)] = 3,	-- Crushing Depths
	[SpellName(426741)] = 3,	-- Shellbreaker
	[SpellName(76820)]  = 3, 	-- Hex
	[SpellName(426688)] = 3,	-- Volatile Acid
	[SpellName(428103)] = 3,	-- Frostbolt

-----------------------------------------------------------------
-- Other
-----------------------------------------------------------------
	[SpellName(87023)] = 4,		-- Cauterize
	[SpellName(94794)] = 4,		-- Rocket Fuel Leak
	[SpellName(116888)] = 4,	-- Shroud of Purgatory
	[SpellName(121175)] = 2,	-- Orb of Power
}

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
		T.RaidDebuffs[spell] = prio
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

for _, spell in pairs(C.raidframe.plugins_aura_watch_list) do
	T.RaidDebuffs[SpellName(spell)] = 3
end
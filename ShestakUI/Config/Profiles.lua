local T, C, L = unpack(ShestakUI)

----------------------------------------------------------------------------------------
--	ShestakUI personal configuration file
--	BACKUP THIS FILE BEFORE UPDATING!
--	ATTENTION: When saving changes to a file encoded file should be in UTF8
----------------------------------------------------------------------------------------
--	Configuration example:
----------------------------------------------------------------------------------------
-- if T.name == "MegaChar" then
--		C["chat"].width = 100500
--		C["tooltip"].cursor = false
--		C["unitframe_class_bar"].totem = false
--		C["position"].tooltip = {"BOTTOMRIGHT", Minimap, "TOPRIGHT", 2, 5}
--		C["position"].bottom_bars = {"BOTTOM", UIParent, "BOTTOM", 2, 8}
--		C["position"].unitframes.tank = {"BOTTOMLEFT", UIParent, "BOTTOM", 176, 68}
--		T.CustomFilgerSpell = {
--			{"T_DEBUFF_ICON", {spellID = 115767, unitID = "target", caster = "player", filter = "DEBUFF"}},
--		}
-- end
----------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------
--	Per Class Config (overwrite general)
--	Class need to be UPPERCASE
----------------------------------------------------------------------------------------
if T.class == "DRUID" then

end

----------------------------------------------------------------------------------------
--	Per Character Name Config (overwrite general and class)
--	Name need to be case sensitive
----------------------------------------------------------------------------------------
if T.name == "CharacterName" then

end

----------------------------------------------------------------------------------------
--	Per Max Character Level Config (overwrite general, class and name)
----------------------------------------------------------------------------------------
if T.level ~= GetMaxPlayerLevel() then

end

----------------------------------------------------------------------------------------
--	Sw2rT1 Config
----------------------------------------------------------------------------------------
if Sw2rT1 then
	C["general"].welcome_message = false
	C["general"].hide_banner = false
	C["general"].hide_talking_head = true
	C["misc"].shift_marking = false
	C["misc"].raid_tools = false
	C["trade"].disenchanting = true
	C["announcements"].pull_countdown = false
	C["automation"].accept_invite = true
	--C["automation"].accept_quest = true
	C["automation"].auto_collapse = true
	C["skins"].blizzard_frames = true
	C["skins"].minimap_buttons = true
	C["skins"].dbm = true
	C["skins"].details = true
	C["skins"].weak_auras = true
	C["combattext"].crit_prefix = ""
	C["combattext"].crit_postfix = ""
	C["minimap"].size = 165
	C["minimap"].fog_of_war = true
	C["raidcooldown"].enable = false
	C["threat"].enable = false
	C["tooltip"].item_icon = true
	C["tooltip"].title = true
	C["tooltip"].raid_icon = true
	C["tooltip"].average_lvl = true
	C["tooltip"].item_count = true
	C["tooltip"].instance_lock = true
	C["chat"].combatlog = false
	C["chat"].damage_meter_spam = true
	C["bag"].ilvl = true
	C["filger"].enable = false
	C["unitframe"].enemy_health_color = false
	C["unitframe"].castbar_latency = false
	C["raidframe"].raid_groups = 6
	C["raidframe"].icons_role = true
	C["toppanel"].enable = false
	C["position"].quest = {"TOPRIGHT", UIParent, "TOPRIGHT", -52, -73}
end

----------------------------------------------------------------------------------------
--	Wetxius Config
----------------------------------------------------------------------------------------
if IsWetxius then
	C["general"].welcome_message = false
	C["general"].vehicle_mouseover = true
	C["skins"].blizzard_frames = true
	C["skins"].minimap_buttons = true
	C["skins"].bigwigs = true
	C["skins"].details = true
	C["skins"].rarescanner = true
	C["unitframe"].castbar_icon = true
	C["unitframe"].plugins_enemy_spec = true
	C["raidframe"].solo_mode = true
	C["raidframe"].icons_leader = false
	C["aura"].show_spiral = true
	C["aura"].cast_by = true
	C["actionbar"].toggle_mode = false
	C["actionbar"].bottombars = 3
	C["actionbar"].stancebar_mouseover_alpha = 0.3
	C["tooltip"].hide_combat = true
	C["tooltip"].rank = false
	C["tooltip"].spell_id = true
	C["tooltip"].unit_role = true
	C["tooltip"].mount = true
	C["chat"].background = true
	C["chat"].spam = true
	C["chat"].damage_meter_spam = true
	C["chat"].chat_bar = true
	C["chat"].chat_bar_mouseover = true
	C["chat"].combatlog = false
	C["chat"].loot_icons = true
	-- C["chat"].history = true
	C["chat"].role_icons = true
	C["chat"].custom_time_color = false
	C["nameplate"].health_value = true
	C["nameplate"].healer_icon = true
	C["nameplate"].track_buffs = true
	C["nameplate"].low_health = true
	C["nameplate"].quests = true
	C["nameplate"].cast_color = true
	C["nameplate"].kick_color = true
	C["nameplate"].mob_color_enable = true
	C["nameplate"].extra_color = {1, 0, 0.55}
	C["combattext"].crit_prefix = ""
	C["combattext"].blizz_head_numbers = true
	C["combattext"].dk_runes = false
	C["bag"].ilvl = true
	C["bag"].new_items = true
	C["minimap"].toggle_menu = false
	C["minimap"].fog_of_war = true
	C["filger"].show_tooltip = true
	C["announcements"].bad_gear = true
	C["automation"].accept_invite = true
	C["automation"].screenshot = true
	C["automation"].auto_role = true
	C["automation"].tab_binder = true
	C["automation"].open_items = true
	C["automation"].minimap_zoom = true
	C["automation"].reputation = true
	C["automation"].auto_collapse = "SCENARIO"
	C["enemycooldown"].show_inparty = true
	C["enemycooldown"].class_color = true
	C["pulsecooldown"].enable = true
	C["pulsecooldown"].threshold = 6
	C["threat"].enable = false
	C["toppanel"].enable = false
	C["stats"].battleground = true
	C["stats"].currency_cooking = false
	C["stats"].currency_professions = false
	C["stats"].currency_raid = false
	C["stats"].currency_misc = false
	C["trade"].disenchanting = true
	C["trade"].enchantment_scroll = true
	C["misc"].shift_marking = false
	C["misc"].quest_auto_button = true
	C["misc"].click_cast = true
	C["font"].stats_font = C.media.normal_font
	C["font"].stats_font_style = "OUTLINE"
	C["font"].stats_font_size = 12
	C["position"].bag = {"BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -21, 20}
	C["position"].bank = {"BOTTOMLEFT", UIParent, "BOTTOMLEFT", 21, 20}
	C["position"].unitframes.arena = {"BOTTOMRIGHT", UIParent, "RIGHT", -55, -70}
	C["position"].stance_bar = {"TOPRIGHT", "ActionBarAnchor", "TOPLEFT", -3, 0}

	local frame = CreateFrame("Frame")
	frame:RegisterEvent("PLAYER_LOGIN")
	frame:SetScript("OnEvent", function()
		C["combattext"].heal_treshold = UnitHealthMax("player")/100
		if xCT3 then
			xCT3:SetPoint("CENTER", 0, 305)
			xCT3:SetWidth(400)
		end
		if PTR_IssueReporter then
			PTR_IssueReporter:SetAlpha(0)
			PTR_IssueReporter:SetScale(0.0001)
		end
		SetCVar("lootUnderMouse", 1)
		SetCVar("nameplateShowFriendlyNPCs", 0)
		local anchor = _G["oUF_Player"] or ChatFrame1
		C["position"].auto_button = {"BOTTOMLEFT", anchor, "TOPRIGHT", 33, 83}
		if AutoButtonAnchor then
			AutoButtonAnchor:ClearAllPoints()
			AutoButtonAnchor:SetPoint(unpack(C.position.auto_button))
		end
	end)

	T.CustomFilgerSpell = {
		-- {"P_PROC_ICON", {spellID = 26573, filter = "ICD", trigger = "NONE", totem = true}}, 		-- Consecration
	}
end

----------------------------------------------------------------------------------------
--	Load external profile https://github.com/Wetxius/ShestakUI_Profile
----------------------------------------------------------------------------------------
if ShestakUICustomProfile then
	ShestakUICustomProfile()
end
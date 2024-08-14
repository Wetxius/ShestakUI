local T, C, L = unpack(ShestakUI)

----------------------------------------------------------------------------------------
--	Prevent users config errors
----------------------------------------------------------------------------------------
if C.actionbar.rightbars > 3 then
	C.actionbar.rightbars = 3
end

if C.actionbar.bottombars > 3 then
	C.actionbar.bottombars = 3
end

if C.actionbar.split_bars == true then
	C.actionbar.bottombars = 3
end

if C.actionbar.bottombars < 1 then
	C.actionbar.bottombars = 1
end

if C.actionbar.editor then
	C.actionbar.bottombars_mouseover = false
	C.actionbar.rightbars_mouseover = false
	C.actionbar.toggle_mode = false
end

----------------------------------------------------------------------------------------
--	Auto-overwrite script config is X addon is found
----------------------------------------------------------------------------------------
if C_AddOns.IsAddOnLoaded("Stuf") or C_AddOns.IsAddOnLoaded("PitBull4") or C_AddOns.IsAddOnLoaded("ShadowedUnitFrames") then
	C.unitframe.enable = false
end

if C_AddOns.IsAddOnLoaded("Grid") or C_AddOns.IsAddOnLoaded("Grid2") or C_AddOns.IsAddOnLoaded("HealBot") or C_AddOns.IsAddOnLoaded("VuhDo") or C_AddOns.IsAddOnLoaded("Cell") or C_AddOns.IsAddOnLoaded("Aptechka") then
	C.raidframe.show_party = false
	C.raidframe.show_raid = false
	C.raidframe.auto_position = "NONE"
end

if C_AddOns.IsAddOnLoaded("TidyPlates") or C_AddOns.IsAddOnLoaded("nPlates") or C_AddOns.IsAddOnLoaded("Kui_Nameplates") or C_AddOns.IsAddOnLoaded("rNamePlates") or C_AddOns.IsAddOnLoaded("EKplates") or C_AddOns.IsAddOnLoaded("bdNameplates") or C_AddOns.IsAddOnLoaded("Plater") or C_AddOns.IsAddOnLoaded("Nameplates") or C_AddOns.IsAddOnLoaded("NeatPlates") then
	C.nameplate.enable = false
end

if C_AddOns.IsAddOnLoaded("Dominos") or C_AddOns.IsAddOnLoaded("Bartender4") or C_AddOns.IsAddOnLoaded("RazerNaga") then
	C.actionbar.enable = false
	C.actionbar.toggle_mode = false
end

if C_AddOns.IsAddOnLoaded("Mapster") then
	C.minimap.fog_of_war = false
end

if C_AddOns.IsAddOnLoaded("Prat-3.0") or C_AddOns.IsAddOnLoaded("Chatter") or C_AddOns.IsAddOnLoaded("BasicChatMods") or C_AddOns.IsAddOnLoaded("Glass") then
	C.chat.enable = false
end

if C_AddOns.IsAddOnLoaded("Quartz") or C_AddOns.IsAddOnLoaded("AzCastBar") then
	C.unitframe.unit_castbar = false
	C.unitframe.plugins_swing = false
	C.unitframe.plugins_gcd = false
end

if C_AddOns.IsAddOnLoaded("Afflicted3") or C_AddOns.IsAddOnLoaded("InterruptBar") then
	C.enemycooldown.enable = false
end

if C_AddOns.IsAddOnLoaded("TipTac") or C_AddOns.IsAddOnLoaded("FreebTip") or C_AddOns.IsAddOnLoaded("bTooltip") or C_AddOns.IsAddOnLoaded("PhanxTooltip") or C_AddOns.IsAddOnLoaded("Icetip") then
	C.tooltip.enable = false
end

if C_AddOns.IsAddOnLoaded("Gladius") or C_AddOns.IsAddOnLoaded("GladiusEx") then
	C.unitframe.show_arena = false
end

if C_AddOns.IsAddOnLoaded("Omen") or C_AddOns.IsAddOnLoaded("rThreat") then
	C.threat.enable = false
end

if C_AddOns.IsAddOnLoaded("DBM-SpellTimers") then
	C.raidcooldown.enable = false
end

T.anotherBags = C_AddOns.IsAddOnLoaded("AdiBags") or C_AddOns.IsAddOnLoaded("ArkInventory") or C_AddOns.IsAddOnLoaded("cargBags_Nivaya") or C_AddOns.IsAddOnLoaded("cargBags") or C_AddOns.IsAddOnLoaded("Bagnon") or C_AddOns.IsAddOnLoaded("Combuctor") or C_AddOns.IsAddOnLoaded("TBag") or C_AddOns.IsAddOnLoaded("BaudBag") or C_AddOns.IsAddOnLoaded("Baganator")
if T.anotherBags then
	C.bag.enable = false
end

if C_AddOns.IsAddOnLoaded("MikScrollingBattleText") or C_AddOns.IsAddOnLoaded("Parrot") or C_AddOns.IsAddOnLoaded("xCT") or C_AddOns.IsAddOnLoaded("sct") then
	C.combattext.enable = false
end

if C_AddOns.IsAddOnLoaded("Doom_CooldownPulse") then
	C.pulsecooldown.enable = false
end

if C_AddOns.IsAddOnLoaded("GnomishVendorShrinker") or C_AddOns.IsAddOnLoaded("AlreadyKnown") then
	C.trade.already_known = false
end

if C_AddOns.IsAddOnLoaded("Clique") or C_AddOns.IsAddOnLoaded("sBinder") then
	C.misc.click_cast = false
end

if C_AddOns.IsAddOnLoaded("RaidSlackCheck") then
	C.announcements.flask_food = false
	C.announcements.feasts = false
end

if C_AddOns.IsAddOnLoaded("PhoenixStyle") then
	C.announcements.toys = false
end

if C_AddOns.IsAddOnLoaded("Overachiever") then
	C.tooltip.achievements = false
end

if C_AddOns.IsAddOnLoaded("ChatSounds") then
	C.chat.whisp_sound = false
end

if C_AddOns.IsAddOnLoaded("Aurora") then
	C.skins.blizzard_frames = false
end

if C_AddOns.IsAddOnLoaded("BigWigs") or C_AddOns.IsAddOnLoaded("DBM-Core") then
	C.automation.auto_role = false
end

if C_AddOns.IsAddOnLoaded("QuickQuest") then
	C.automation.accept_quest = false
end

----------------------------------------------------------------------------------------
--	Load external profile settings
----------------------------------------------------------------------------------------
if T.PostDisable then
	T.PostDisable()
end
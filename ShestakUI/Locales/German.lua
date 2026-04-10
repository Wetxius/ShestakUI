local T, C, L = unpack(ShestakUI)
if T.client ~= "deDE" then return end

----------------------------------------------------------------------------------------
--	Localization for deDE client
--	Translation: Alwa, Baine, Chubidu, F5Hellbound, Sinaris, Vienchen
----------------------------------------------------------------------------------------
-- Announce flasks and food
L_ANNOUNCE_FF_NOFOOD = "Kein Essen: "
L_ANNOUNCE_FF_NOFLASK = "Kein Fläschchen: "
L_ANNOUNCE_FF_ALLBUFFED = "Alles drin!"
L_ANNOUNCE_FF_CHECK_BUTTON = "Überprüfe Essen und Fläschchen"

-- Says thanks for some spells
L_ANNOUNCE_SS_THANKS = "Danke für "
L_ANNOUNCE_SS_RECEIVED = " erhalten von "

-- Pull countdown announce
L_ANNOUNCE_PC_GO = "GO!"
L_ANNOUNCE_PC_MSG = "Pull %s in %s.."
L_ANNOUNCE_PC_ABORTED = "Pull ABGEBROCHEN!"

-- Announce feasts and portals
L_ANNOUNCE_FP_PRE = "%s bereitet ein %s vor."
L_ANNOUNCE_FP_PUT = "%s stellt ein %s auf."
L_ANNOUNCE_FP_CAST = "%s zaubert ein %s."
L_ANNOUNCE_FP_CLICK = "%s zaubert ein %s. Klick!"
L_ANNOUNCE_FP_USE = "%s nahm %s."

-- Announce your interrupts
L_ANNOUNCE_INTERRUPTED = INTERRUPTED

-- Tooltip
L_TOOLTIP_LOADING = "Lade..."
L_TOOLTIP_ACH_STATUS = "Dein Fortschritt:"
L_TOOLTIP_ACH_COMPLETE = "Dein Status: Fertig gestellt am "
L_TOOLTIP_ACH_INCOMPLETE = "Dein Status: Noch nicht fertig"
L_TOOLTIP_SPELL_ID = "Zauber-ID:"
L_TOOLTIP_ITEM_ID = "Gegenstands-ID:"
L_TOOLTIP_WHO_TARGET = "Anvisiert von"
L_TOOLTIP_ITEM_COUNT = "Gegenstandsanzahl:"
L_TOOLTIP_INSPECT_OPEN = "Betrachtungsfenster offen"

-- Misc
L_MISC_UNDRESS = "Ausziehen"
L_MISC_DRINKING = " trinkt."
L_MISC_BUY_STACK = "Alt-Klick, um einen Stapel zu kaufen"
L_MISC_HEADER_MARK = "Mausdrüber Raid Icon"
L_MISC_BINDER_OPEN = "Maus gebunden"
L_MISC_SCROLL = "Rolle"
L_MISC_HEADER_QUEST = "Auto-Quest-Button"

-- Raid Utility
L_RAID_UTIL_DISBAND = "Gruppe auflösen"

-- Zone name
L_ZONE_ANCIENTDALARAN = "Dalarankrater"

-- WatchFrame Wowhead link
L_WATCH_WOWHEAD_LINK = "Wowhead-Link"

-- Toggle Menu
L_TOGGLE_ADDON = "Erweiterung "
L_TOGGLE_ADDONS = " Erweiterungen"
L_TOGGLE_EXPAND = "erweitern "
L_TOGGLE_COLLAPSE = "schließen "
L_TOGGLE_RCLICK = "Rechtsklick zum Aktivieren oder Deaktivieren "
L_TOGGLE_LCLICK = "Linksklick, um Fenster aktiv zu halten "
L_TOGGLE_RELOAD = " (benötigt UI-Neustart)"
L_TOGGLE_NOT_FOUND = " nicht gefunden."

-- UnitFrame
L_UF_GHOST = "Geist"
L_UF_DEAD = "Tot"
L_UF_OFFLINE = "Offline"
L_UF_MANA = "Niedriges Mana"

-- Map
L_MAP_CURSOR = "Mauszeiger: "
L_MAP_BOUNDS = "Außerhalb der Begrenzung!"
L_MAP_FOG = "Nebel des Krieges"
L_MAP_COORDS = "Koordinaten"

-- Minimap
L_MINIMAP_CALENDAR = "Kalender"
L_MINIMAP_FARM = "Minimap-Größe"
L_MINIMAP_TOGGLE = "Aktionsleisten umschalten"

-- Chat
L_CHAT_WHISPER = "Von"
L_CHAT_BN_WHISPER = "Von"
L_CHAT_AFK = "[AFK]"
L_CHAT_DND = "[DND]"
L_CHAT_GM = "[GM]"
L_CHAT_GUILD = "G"
L_CHAT_PARTY = "P"
L_CHAT_PARTY_LEADER = "PL"
L_CHAT_RAID = "R"
L_CHAT_RAID_LEADER = "RL"
L_CHAT_RAID_WARNING = "RW"
L_CHAT_INSTANCE_CHAT = "I"
L_CHAT_INSTANCE_CHAT_LEADER = "IL"
L_CHAT_OFFICER = "O"
L_CHAT_PET_BATTLE = "PB"
L_CHAT_COME_ONLINE = "ist jetzt |cff298F00online|r."
L_CHAT_GONE_OFFLINE = "ist jetzt |cffff0000offline|r."

-- Errors frame
L_ERRORFRAME_L = "Klick, um Fehler anzuzeigen."

-- Bags
L_BAG_SHOW_BAGS = "Zeige Taschen"
L_BAG_RIGHT_CLICK_SEARCH = "Rechtsklick zum Suchen"
L_BAG_STACK_MENU = "Stapeln"
L_BAG_RIGHT_CLICK_CLOSE = "Rechtsklick öffnet Menü"

-- Grab mail
L_MAIL_STOPPED = "Angehalten, Inventar ist voll."
L_MAIL_UNIQUE = "Angehalten, dieses einzigartige Item befindet sich bereits in der Tasche oder auf der Bank."
L_MAIL_COMPLETE = "Alles fertig."
L_MAIL_NEED = "Benötige einen Briefkasten."
L_MAIL_MESSAGES = "Nachrichten"

-- Loot
L_LOOT_RANDOM = "Zufälliger Spieler"
L_LOOT_SELF = "Selbst nehmen"
L_LOOT_FISH = "Angeln"
L_LOOT_ANNOUNCE = "Ansagen"
L_LOOT_TO_RAID = "  schlachtzug"
L_LOOT_TO_PARTY = "  gruppe"
L_LOOT_TO_GUILD = "  gilde"
L_LOOT_TO_SAY = "  sagen"

-- LitePanels AFK module
L_PANELS_AFK = "Du bist AFK!"
L_PANELS_AFK_RCLICK = "Rechts-Klick zum Verstecken."
L_PANELS_AFK_LCLICK = "Links-Klick, um zurück zu gehen."

-- Cooldowns
L_COOLDOWNS = "Abklingzeit: "
L_COOLDOWNS_COMBATRESS = "Battlerezz"
L_COOLDOWNS_COMBATRESS_REMAINDER = "Battlerezz übrig: "
L_COOLDOWNS_NEXTTIME = "Nächste Möglichkeit: "

-- Bind key
L_BIND_SAVED = "Alle Tastenbelegungen wurden gespeichert."
L_BIND_DISCARD = "Alle gerade neu belegten Tastenbelegungen wurden verworfen."
L_BIND_INSTRUCT = "Bewege deine Maus über einen Aktionsbutton, um ihn mit einem Hotkey zu belegen. Drücke Escape oder Rechte Maustaste, um die aktuelle Tastenbelegung des Buttons zu löschen."
L_BIND_CLEARED = "Alle Tastaturbelegungen gelöscht für"
L_BIND_BINDING = "Belegung"
L_BIND_KEY = "Taste"
L_BIND_NO_SET = "Keine Tastaturbelegung festgelegt"

-- Info text
L_INFO_ERRORS = "Noch keine Fehler."
L_INFO_INVITE = "Gruppeneinladung akzeptiert von "
L_INFO_DUEL = "Duellanfrage ignoriert von "
L_INFO_PET_DUEL = "Haustier-Duellanfrage ignoriert von "
L_INFO_DISBAND = "Löse Gruppe auf..."
L_INFO_SETTINGS_DBM = "Gebe /settings dbm ein, um DBM-Einstellungen zu laden."
L_INFO_SETTINGS_BIGWIGS = "Gebe /settings bw ein, um BigWigs-Einstellungen zu laden."
L_INFO_SETTINGS_MSBT = "Gebe /settings msbt ein, um die MSBT-Einstellungen zu laden."
L_INFO_SETTINGS_SKADA = "Gebe /settings skada ein, um die Skada-Einstellungen zu laden."
L_INFO_SETTINGS_ALL = "Gebe /settings all ein, um die Einstellungen für alle unterstützten AddOns zu laden."
L_INFO_NOT_INSTALLED = " ist nicht installiert."
L_INFO_SKIN_DISABLED1 = "Stilisierung für "
L_INFO_SKIN_DISABLED2 = " ist ausgeschaltet."

-- Moving elements
L_MOVE_RIGHT_CLICK = "Rechts-Klick zum Zurücksetzen der Position"
L_MOVE_MIDDLE_CLICK = "Mittelklick zum temporären Verstecken"

-- Popups
L_POPUP_INSTALLUI = "Dies ist deine erste Benutzung von ShestakUI mit diesem Charakter. Das Interface wird nun neu geladen, um es zu konfigurieren."
L_POPUP_RESETUI = "Bist du sicher, dass du die Einstellungen von ShestakUI zurücksetzen möchtest?"
L_POPUP_RESETSTATS = "Bist du sicher, dass du die Gold- und Spielzeit-Statistik zurücksetzen möchtest?"
L_POPUP_DISBAND_RAID = "Bist du sicher, dass du die Gruppe auflösen möchtest?"
L_POPUP_DISABLEUI = "ShestakUI funktioniert nicht mit deiner Auflösung. Möchtest du ShestakUI deaktivieren? (Drücke Abbrechen, falls du eine andere Auflösung testen willst)"
L_POPUP_SETTINGS_ALL = "Einstellungen für alle AddOns übernehmen? (DBM, BigWigs, Skada und MSBT)"
L_POPUP_SETTINGS_DBM = "Die Position der DBM-Elemente muss verändert werden."
L_POPUP_SETTINGS_BW = "Die Position der BigWigs-Elemente muss verändert werden."
L_POPUP_ARMORY = "Waffenkammer"

-- Welcome message
L_WELCOME_LINE_1 = "Willkommen bei ShestakUI "
L_WELCOME_LINE_2_1 = "Gebe /cfg ein, um das Interface zu konfigurieren, oder besuche https://github.com/Wetxius/ShestakUI_Help/wiki/English"
L_WELCOME_LINE_2_2 = "für weitere Informationen."

-- Combat text
L_COMBATTEXT_KILLING_BLOW = "Todesstoß"
L_COMBATTEXT_TEST_DISABLED = "Kampftext-Testmodus deaktiviert."
L_COMBATTEXT_TEST_ENABLED = "Kampftext-Testmodus aktiviert."
L_COMBATTEXT_TEST_USE_MOVE = "Gib '/xct move' ein, um die Kampftext-Fenster freizugeben, damit du sie verschieben und verändern kannst."
L_COMBATTEXT_TEST_USE_TEST = "Gib '/xct' ein, um den Kampftext-Testmodus zu aktivieren."
L_COMBATTEXT_TEST_USE_RESET = "Gib /xct reset ein, um die Standardpositionen wiederherzustellen."
L_COMBATTEXT_POPUP = "Um die Kampftext-Fensterpositionen zu sichern, muss das Interface neu geladen werden."
L_COMBATTEXT_UNSAVED = "Kampftext-Fensterpositionen nicht gespeichert, vergiss nicht das Interface neu zu laden."
L_COMBATTEXT_UNLOCKED = "Kampftext freigegeben."

-- LiteStats
L_STATS_AUTO_REPAIR = "Automatisch reparieren"
L_STATS_GUILD_REPAIR = "Reparieren mit Gildenbank"
L_STATS_AUTO_SELL = "Junk automatisch verkaufen"
L_STATS_BANDWIDTH = "Bandbreite:"
L_STATS_DOWNLOAD = "Download:"
L_STATS_CURRENCY_RAID = "Schlachtzugs-Siegel"
L_STATS_MEMORY_USAGE = "Blizzard-UI Speicherauslastung:"
L_STATS_TOTAL_MEMORY_USAGE = "Gesamte Speicherauslastung:"
L_STATS_TOTAL_CPU_USAGE = "Gesamte CPU-Auslastung:"
L_STATS_GARBAGE_COLLECTED = "Speicher bereinigt"
L_STATS_HIDDEN = "Versteckt"
L_STATS_JUNK_ALREADY_ADDITIONS = "ist bereits in der Junk-Liste."
L_STATS_JUNK_ITEMLINK = "Itemlink"
L_STATS_JUNK_ADDITIONS = "Junk-Ergänzungen"
L_STATS_JUNK_LIST = "Junk-Liste"
L_STATS_JUNK_PROFIT = "Junk-Gewinn"
L_STATS_JUNK_CLEARED = "Junk-Liste geleert."
L_STATS_JUNK_CLEAR_ADDITIONS = "Ergänzungsliste leeren."
L_STATS_JUNK_ADDED = "Junk hinzugefügt"
L_STATS_JUNK_ADD_ITEM = "Items hinzufügen/entfernen."
L_STATS_JUNK_REMOVED = "Junk entfernt"
L_STATS_JUNK_ITEMS_LIST = "Liste der Verkaufsgegenstände."
L_STATS_KILLS = "G"
L_STATS_XP_RATE = "Level XP-Rate"
L_STATS_HR = "Std"
L_STATS_INF = "unendlich"
L_STATS_ON = "AN"
L_STATS_PLAYED_LEVEL = "Auf diesem Level gespielt"
L_STATS_PLAYED_SESSION = "Diese Sitzung gespielt"
L_STATS_ACC_PLAYED = "Gesamtspielzeit"
L_STATS_PLAYED_TOTAL = "Gesamt gespielt"
L_STATS_QUEST = "Q"
L_STATS_QUESTS_TO = "Quests/Getötet bis %s"
L_STATS_CURRENT_XP = "Aktuell/Max XP"
L_STATS_REMAINING_XP = "Verbleibende XP"
L_STATS_RESTED_XP = "Erholte XP"
L_STATS_SERVER_GOLD = "Server-Gold"
L_STATS_SESSION_GAIN = "Sitzung - Gewinn/Verlust"
L_STATS_SESSION_XP = "Sitzung - XP-Rate"
L_STATS_SORTING_BY = "Sortiert nach"
L_STATS_SEALS = "Angebot der Woche"
L_STATS_SPEC = "Spec"
L_STATS_TIPS = "Tipps:"
L_STATS_OPEN_CALENDAR = "Linksklick öffnet den Kalender."
L_STATS_RC_TIME_MANAGER = "Rechtsklick öffnet die Uhr-Einstellungen."
L_STATS_TOGGLE_TIME = "Lokal/Realm & 24-Stunden-Modus können in den Uhr-Einstellungen gewechselt werden."
L_STATS_MEMORY = "Speicher"
L_STATS_RC_COLLECTS_GARBAGE = "Rechtsklick sammelt Lua-Müll."
L_STATS_VIEW_NOTES = "Halte Alt gedrückt, um Ränge, Notizen und Offiziersnotizen anzuzeigen."
L_STATS_CHANGE_SORTING = "[Gilde] Rechtsklick ändert die Sortierung, Shift-Rechtsklick kehrt die Reihenfolge um."
L_STATS_OPEN_CHARACTER = "Linksklick öffnet das Charakterfenster."
L_STATS_RC_AUTO_REPAIRING1 = "Rechtsklick schaltet automatische Reparatur ein/aus."
L_STATS_RC_AUTO_REPAIRING2 = "Mittelklick schaltet Gilden-Autoreparatur ein/aus."
L_STATS_EQUIPMENT_CHANGER = "Shift-Klick oder Alt-Klick für den Ausrüstungsmanager."
L_STATS_RC_EXPERIENCE = "Rechtsklick wechselt zwischen Erfahrung, Spielzeit und Fraktionsüberwachung."
L_STATS_WATCH_FACTIONS = "Überwache Fraktionen aus dem Ruffenster."
L_STATS_TOOLTIP_EXPERIENCE = "Bei Level < Max wird ein Tooltip mit weiteren Details angezeigt."
L_STATS_TOOLTIP_TIME_PLAYED = "Bei Max-Level zeigt der Tooltip die gesamte Account-Spielzeit an."
L_STATS_OPEN_TALENT = "Linksklick wechselt deine Talentspezialisierung."
L_STATS_RC_TALENT = "Rechtsklick ändert die Beute-Spezialisierung."
L_STATS_LOCATION = "Standort/Koordinaten"
L_STATS_WORLD_MAP = "Klick öffnet die Weltkarte."
L_STATS_INSERTS_COORDS = "Shift-Klick auf das Standort/Koordinaten-Modul fügt deine aktuellen Koordinaten in den Chat ein."
L_STATS_OPEN_CURRENCY = "Linksklick öffnet das Abzeichen-Fenster."
L_STATS_RC_AUTO_SELLING = "Rechtsklick schaltet automatischen Junk-Verkauf ein/aus."
L_STATS_NEED_TO_SELL = "Verwende /junk, um zu konfigurieren, welche Gegenstände verkauft werden sollen."
L_STATS_WATCH_CURRENCY = "Bereits angesehene Gegenstände aus dem Abzeichen-Fenster werden im Tooltip angezeigt."
L_STATS_OTHER_OPTIONS = "Weitere Einstellungen können in %s konfiguriert werden"

-- Slash commands
L_SLASHCMD_HELP = {
	"Verfügbare Slash-Befehle:",
	"/rl - Interface neu laden.",
	"/rc - Bereitschaftscheck starten.",
	"/gm - Game Master Fenster öffnen.",
	"/dis ADDON_NAME - Addon deaktivieren.",
	"/en ADDON_NAME - Addon aktivieren.",
	"/rd - Gruppe oder Schlachtzug auflösen.",
	"/toraid - In Gruppe oder Schlachtzug umwandeln.",
	"/teleport - Aus beliebigem Dungeon teleportieren.",
	"/ss - Zwischen Talenten wechseln.",
	"/tt - Ziel anflüstern.",
	"/farmmode - Minimap vergrößern.",
	"/resetui - Allgemeine Einstellungen auf Standard zurücksetzen.",
	"/resetuf - Einheitenfenster auf Standardposition zurücksetzen.",
	"/resetconfig - ShestakUI_Config Einstellungen zurücksetzen.",
	"/resetstats - Gold-Statistik und gespielte Zeit zurücksetzen.",
	"/settings - Einstellungen für msbt, dbm, skada oder alle Addons übernehmen.",
	"/ls - Hilfe für LiteStats.",
	"/xct - Kampflogtext verwalten.",
	"/raidcd - Schlachtzug-Abklingzeiten testen.",
	"/enemycd - Gegner-Abklingzeiten testen.",
	"/pulsecd - Pulsierende Abklingzeiten testen.",
	"/threat - Bedrohungsmeter testen.",
	"/testuf - Einheitenfenster testen.",
	"/moveui - Interface-Elemente verschieben.",
	"/cfg - Interface-Einstellungen öffnen.",
}
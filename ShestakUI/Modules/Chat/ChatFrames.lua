﻿local T, C, L = unpack(ShestakUI)
if C.chat.enable ~= true then return end

----------------------------------------------------------------------------------------
--	Style chat frame(by Tukz and p3lim)
----------------------------------------------------------------------------------------
local origs = {}

local function Strip(info, name)
	return string.format("|Hplayer:%s|h[%s]|h", info, name:gsub("%-[^|]+", ""))
end

-- Function to rename channel and other stuff
local AddMessage = function(self, text, ...)
	if type(text) == "string" then
		text = text:gsub("|h%[(%d+)%. .-%]|h", "|h[%1]|h")
		text = text:gsub("|Hplayer:(.-)|h%[(.-)%]|h", Strip)
	end
	return origs[self](self, text, ...)
end

-- Global strings
_G.CHAT_INSTANCE_CHAT_GET = "|Hchannel:INSTANCE_CHAT|h["..L_CHAT_INSTANCE_CHAT.."]|h %s:\32"
_G.CHAT_INSTANCE_CHAT_LEADER_GET = "|Hchannel:INSTANCE_CHAT|h["..L_CHAT_INSTANCE_CHAT_LEADER.."]|h %s:\32"
_G.CHAT_BN_WHISPER_GET = L_CHAT_BN_WHISPER.." %s:\32"
_G.CHAT_GUILD_GET = "|Hchannel:GUILD|h["..L_CHAT_GUILD.."]|h %s:\32"
_G.CHAT_OFFICER_GET = "|Hchannel:OFFICER|h["..L_CHAT_OFFICER.."]|h %s:\32"
_G.CHAT_PARTY_GET = "|Hchannel:PARTY|h["..L_CHAT_PARTY.."]|h %s:\32"
_G.CHAT_PARTY_LEADER_GET = "|Hchannel:PARTY|h["..L_CHAT_PARTY_LEADER.."]|h %s:\32"
_G.CHAT_PARTY_GUIDE_GET = CHAT_PARTY_LEADER_GET
_G.CHAT_RAID_GET = "|Hchannel:RAID|h["..L_CHAT_RAID.."]|h %s:\32"
_G.CHAT_RAID_LEADER_GET = "|Hchannel:RAID|h["..L_CHAT_RAID_LEADER.."]|h %s:\32"
_G.CHAT_RAID_WARNING_GET = "["..L_CHAT_RAID_WARNING.."] %s:\32"
_G.CHAT_PET_BATTLE_COMBAT_LOG_GET = "|Hchannel:PET_BATTLE_COMBAT_LOG|h["..L_CHAT_PET_BATTLE.."]|h:\32"
_G.CHAT_PET_BATTLE_INFO_GET = "|Hchannel:PET_BATTLE_INFO|h["..L_CHAT_PET_BATTLE.."]|h:\32"
_G.CHAT_SAY_GET = "%s:\32"
_G.CHAT_WHISPER_GET = L_CHAT_WHISPER.." %s:\32"
_G.CHAT_YELL_GET = "%s:\32"
_G.CHAT_FLAG_AFK = "|cffE7E716"..L_CHAT_AFK.."|r "
_G.CHAT_FLAG_DND = "|cffFF0000"..L_CHAT_DND.."|r "
_G.CHAT_FLAG_GM = "|cff4154F5"..L_CHAT_GM.."|r "
_G.ERR_FRIEND_ONLINE_SS = "|Hplayer:%s|h[%s]|h "..L_CHAT_COME_ONLINE
_G.ERR_FRIEND_OFFLINE_S = "[%s] "..L_CHAT_GONE_OFFLINE

-- Kill channel and voice buttons
ChatFrameChannelButton:Kill()
ChatFrameToggleVoiceDeafenButton:Kill()
ChatFrameToggleVoiceMuteButton:Kill()

-- Set chat style
local function SetChatStyle(frame)
	local id = frame:GetID()
	local chat = frame:GetName()
	local editBox = _G[chat.."EditBox"]

	_G[chat]:SetFrameLevel(5)

	-- Removes crap from the bottom of the chatbox so it can go to the bottom of the screen
	_G[chat]:SetClampedToScreen(false)

	-- Stop the chat chat from fading out
	_G[chat]:SetFading(false)

	-- Move the chat edit box
	editBox:ClearAllPoints()
	editBox:SetPoint("BOTTOMLEFT", ChatFrame1, "TOPLEFT", -10, 23)
	editBox:SetPoint("BOTTOMRIGHT", ChatFrame1, "TOPRIGHT", 11, 23)

	-- Hide textures
	for j = 1, #CHAT_FRAME_TEXTURES do
		_G[chat..CHAT_FRAME_TEXTURES[j]]:SetTexture(nil)
	end

	-- Removes Default ChatFrame Tabs texture
	_G[format("ChatFrame%sTab", id)].Left:Kill()
	_G[format("ChatFrame%sTab", id)].Middle:Kill()
	_G[format("ChatFrame%sTab", id)].Right:Kill()

	_G[format("ChatFrame%sTab", id)].ActiveLeft:Kill()
	_G[format("ChatFrame%sTab", id)].ActiveMiddle:Kill()
	_G[format("ChatFrame%sTab", id)].ActiveRight:Kill()

	_G[format("ChatFrame%sTab", id)].HighlightLeft:Kill()
	_G[format("ChatFrame%sTab", id)].HighlightMiddle:Kill()
	_G[format("ChatFrame%sTab", id)].HighlightRight:Kill()

	-- Killing off the new chat tab selected feature
	_G[format("ChatFrame%sButtonFrameMinimizeButton", id)]:Kill()
	_G[format("ChatFrame%sButtonFrame", id)]:Kill()

	-- Kills off the retarded new circle around the editbox
	_G[format("ChatFrame%sEditBoxLeft", id)]:Kill()
	_G[format("ChatFrame%sEditBoxMid", id)]:Kill()
	_G[format("ChatFrame%sEditBoxRight", id)]:Kill()

	if T.newPatch then
		_G[format("ChatFrame%sEditBoxFocusLeft", id)]:SetTexture("")
		_G[format("ChatFrame%sEditBoxFocusMid", id)]:SetTexture("")
		_G[format("ChatFrame%sEditBoxFocusRight", id)]:SetTexture("")
	end

	_G[format("ChatFrame%sTabGlow", id)]:Kill()

	-- Kill scroll bar
	frame.ScrollBar:Kill()
	frame.ScrollToBottomButton:Kill()

	-- Kill off editbox artwork
	local a, b, c = select(6, editBox:GetRegions())
	a:Kill() b:Kill() c:Kill()

	-- Kill bubble tex/glow
	if _G[chat.."Tab"].conversationIcon then _G[chat.."Tab"].conversationIcon:Kill() end

	-- Disable alt key usage
	editBox:SetAltArrowKeyMode(false)

	-- Hide editbox on login
	editBox:Hide()

	-- Script to hide editbox instead of fading editbox to 0.35 alpha via IM Style
	editBox:HookScript("OnEditFocusGained", function(self) self:Show() end)
	editBox:HookScript("OnEditFocusLost", function(self) if self:GetText() == "" then self:Hide() end end)

	-- Hide edit box every time we click on a tab
	_G[chat.."Tab"]:HookScript("OnClick", function() editBox:Hide() end)

	-- Create our own texture for edit box
	if C.chat.background == true and C.chat.tabs_mouseover ~= true then
		local EditBoxBackground = CreateFrame("Frame", "ChatEditBoxBackground", editBox)
		EditBoxBackground:CreatePanel("Transparent", 1, 1, "LEFT", editBox, "LEFT", 0, 0)
		EditBoxBackground:ClearAllPoints()
		EditBoxBackground:SetPoint("TOPLEFT", editBox, "TOPLEFT", 7, -5)
		EditBoxBackground:SetPoint("BOTTOMRIGHT", editBox, "BOTTOMRIGHT", -7, 4)
		EditBoxBackground:SetFrameStrata("LOW")
		EditBoxBackground:SetFrameLevel(1)

		local function colorize(r, g, b)
			EditBoxBackground:SetBackdropBorderColor(r, g, b)
		end

		-- Update border color according where we talk
		if T.newPatch then
			hooksecurefunc(editBox, "UpdateHeader", function()
				local chatType = editBox:GetAttribute("chatType")
				if not chatType then return end

				local chanTarget = editBox:GetAttribute("channelTarget")
				local chanName = chanTarget and GetChannelName(chanTarget)
				if chanName and chatType == "CHANNEL" then
					if chanName == 0 then
						colorize(unpack(C.media.border_color))
					else
						colorize(ChatTypeInfo[chatType..chanName].r, ChatTypeInfo[chatType..chanName].g, ChatTypeInfo[chatType..chanName].b)
					end
				else
					colorize(ChatTypeInfo[chatType].r, ChatTypeInfo[chatType].g, ChatTypeInfo[chatType].b)
				end
			end)
		else
			hooksecurefunc("ChatEdit_UpdateHeader", function()
				local chatType = _G[chat.."EditBox"]:GetAttribute("chatType")
				if not chatType then return end

				local chanTarget = _G[chat.."EditBox"]:GetAttribute("channelTarget")
				local chanName = chanTarget and GetChannelName(chanTarget)
				if chanName and chatType == "CHANNEL" then
					if chanName == 0 then
						colorize(unpack(C.media.border_color))
					else
						colorize(ChatTypeInfo[chatType..chanName].r, ChatTypeInfo[chatType..chanName].g, ChatTypeInfo[chatType..chanName].b)
					end
				else
					colorize(ChatTypeInfo[chatType].r, ChatTypeInfo[chatType].g, ChatTypeInfo[chatType].b)
				end
			end)
		end
	end

	-- Rename combat log tab
	if _G[chat] == _G["ChatFrame2"] then
		CombatLogQuickButtonFrame_Custom:StripTextures()
		CombatLogQuickButtonFrame_Custom:CreateBackdrop("Transparent")
		CombatLogQuickButtonFrame_Custom.backdrop:SetPoint("TOPLEFT", 1, -4)
		CombatLogQuickButtonFrame_Custom.backdrop:SetPoint("BOTTOMRIGHT", -22, 0)
		T.SkinCloseButton(CombatLogQuickButtonFrame_CustomAdditionalFilterButton, CombatLogQuickButtonFrame_Custom.backdrop, " ", true)
		CombatLogQuickButtonFrame_CustomAdditionalFilterButton:SetSize(12, 12)
		CombatLogQuickButtonFrame_CustomAdditionalFilterButton:SetHitRectInsets (0, 0, 0, 0)
		CombatLogQuickButtonFrame_CustomProgressBar:ClearAllPoints()
		CombatLogQuickButtonFrame_CustomProgressBar:SetPoint("TOPLEFT", CombatLogQuickButtonFrame_Custom.backdrop, 2, -2)
		CombatLogQuickButtonFrame_CustomProgressBar:SetPoint("BOTTOMRIGHT", CombatLogQuickButtonFrame_Custom.backdrop, -2, 2)
		CombatLogQuickButtonFrame_CustomProgressBar:SetStatusBarTexture(C.media.texture)
		CombatLogQuickButtonFrameButton1:SetPoint("BOTTOM", 0, 0)
	end

	if _G[chat] ~= _G["ChatFrame2"] then
		origs[_G[chat]] = _G[chat].AddMessage
		_G[chat].AddMessage = AddMessage
		-- Custom timestamps color
		local color = C.chat.custom_time_color and T.RGBToHex(unpack(C.chat.time_color)) or ""
		_G.TIMESTAMP_FORMAT_HHMM = color.."[%I:%M]|r "
		_G.TIMESTAMP_FORMAT_HHMMSS = color.."[%I:%M:%S]|r "
		_G.TIMESTAMP_FORMAT_HHMMSS_24HR = color.."[%H:%M:%S]|r "
		_G.TIMESTAMP_FORMAT_HHMMSS_AMPM = color.."[%I:%M:%S %p]|r "
		_G.TIMESTAMP_FORMAT_HHMM_24HR = color.."[%H:%M]|r "
		_G.TIMESTAMP_FORMAT_HHMM_AMPM = color.."[%I:%M %p]|r "
	end

	frame.skinned = true
end

-- Setup chatframes 1 to 10 on login
local function SetupChat()
	for i = 1, NUM_CHAT_WINDOWS do
		local frame = _G[format("ChatFrame%s", i)]
		SetChatStyle(frame)
	end

	-- Remember last channel
	local var
	if C.chat.sticky == true then
		var = 1
	else
		var = 0
	end
	ChatTypeInfo.SAY.sticky = var
	ChatTypeInfo.PARTY.sticky = var
	ChatTypeInfo.PARTY_LEADER.sticky = var
	ChatTypeInfo.GUILD.sticky = var
	ChatTypeInfo.OFFICER.sticky = var
	ChatTypeInfo.RAID.sticky = var
	ChatTypeInfo.RAID_WARNING.sticky = var
	ChatTypeInfo.INSTANCE_CHAT.sticky = var
	ChatTypeInfo.INSTANCE_CHAT_LEADER.sticky = var
	ChatTypeInfo.WHISPER.sticky = var
	ChatTypeInfo.BN_WHISPER.sticky = var
	ChatTypeInfo.CHANNEL.sticky = var
end

local function SetupChatPosAndFont()
	for i = 1, NUM_CHAT_WINDOWS do
		local chat = _G[format("ChatFrame%s", i)]
		local id = chat:GetID()
		local _, fontSize = FCF_GetChatWindowInfo(id)

		-- Min. size for chat font
		if fontSize < 11 then
			FCF_SetChatWindowFontSize(nil, chat, 11)
		else
			FCF_SetChatWindowFontSize(nil, chat, fontSize)
		end

		-- Font and font style for chat
		chat:SetFont(C.font.chat_font, fontSize, C.font.chat_font_style)
		chat:SetShadowOffset(C.font.chat_font_shadow and 1 or 0, C.font.chat_font_shadow and -1 or 0)

		-- Force chat position
		if i == 1 then
			chat:ClearAllPoints()
			chat:SetSize(C.chat.width, C.chat.height)
			if C.chat.background == true then
				chat:SetPoint(C.position.chat[1], C.position.chat[2], C.position.chat[3], C.position.chat[4], C.position.chat[5] + 4)
			else
				chat:SetPoint(C.position.chat[1], C.position.chat[2], C.position.chat[3], C.position.chat[4], C.position.chat[5])
			end
			FCF_SavePositionAndDimensions(chat)
		elseif i == 2 then
			if C.chat.combatlog ~= true then
				FCF_DockFrame(chat)
				ChatFrame2Tab:EnableMouse(false)
				ChatFrame2Tab.Text:Hide()
				ChatFrame2Tab:SetWidth(0.001)
				ChatFrame2Tab.SetWidth = T.dummy
				FCF_DockUpdate()
			end
		end

		chat:SetScript("OnMouseWheel", FloatingChatFrame_OnMouseScroll)
	end

	-- Reposition Quick Join Toast
	QuickJoinToastButton:ClearAllPoints()
	QuickJoinToastButton:SetPoint("TOPLEFT", 0, 90)
	QuickJoinToastButton.ClearAllPoints = T.dummy
	QuickJoinToastButton.SetPoint = T.dummy

	QuickJoinToastButton.Toast:ClearAllPoints()
	QuickJoinToastButton.Toast:SetPoint(unpack(C.position.bn_popup))
	QuickJoinToastButton.Toast.Background:SetTexture("")
	QuickJoinToastButton.Toast:CreateBackdrop("Transparent")
	QuickJoinToastButton.Toast.backdrop:SetPoint("TOPLEFT", 0, 0)
	QuickJoinToastButton.Toast.backdrop:SetPoint("BOTTOMRIGHT", 0, 0)
	QuickJoinToastButton.Toast.backdrop:Hide()
	QuickJoinToastButton.Toast:SetWidth(C.chat.width + 7)
	QuickJoinToastButton.Toast.Text:SetWidth(C.chat.width - 20)

	hooksecurefunc(QuickJoinToastButton, "ShowToast", function() QuickJoinToastButton.Toast.backdrop:Show() end)
	hooksecurefunc(QuickJoinToastButton, "HideToast", function() QuickJoinToastButton.Toast.backdrop:Hide() end)

	-- Reposition Battle.net popup
	BNToastFrame:ClearAllPoints()
	BNToastFrame:SetPoint(unpack(C.position.bn_popup))

	hooksecurefunc(BNToastFrame, "SetPoint", function(self, _, anchor) -- not sure if it still needed
		if anchor ~= C.position.bn_popup[2] then
			self:ClearAllPoints()
			self:SetPoint(unpack(C.position.bn_popup))
		end
	end)

	-- /run BNToastFrame:AddToast(BN_TOAST_TYPE_ONLINE, 1)
	hooksecurefunc(BNToastFrame, "ShowToast", function(self)
		if not self.IsSkinned then
			T.SkinCloseButton(self.CloseButton, nil, "x")
			self.CloseButton:SetSize(16, 16)
			self.IsSkinned = true
		end
	end)
end

-- Reposition 3 chat frame tab if it don't fit to 1
-- for i = 3, NUM_CHAT_WINDOWS do
	-- local tab = _G[format("ChatFrame%sTab", i)]
	-- hooksecurefunc(tab, "SetPoint", function(self, point, anchor, attachTo, x, y)
		-- if anchor == GeneralDockManagerScrollFrameChild and y == -1 then
			-- self:ClearAllPoints()
			-- self:SetPoint(point, anchor, attachTo, x, -2)
		-- end
	-- end)
-- end

GeneralDockManagerOverflowButton:SetPoint("BOTTOMRIGHT", ChatFrame1, "TOPRIGHT", 0, 5)
hooksecurefunc(GeneralDockManagerScrollFrame, "SetPoint", function(self, point, anchor, attachTo, x, y)
	if anchor == GeneralDockManagerOverflowButton and x == 0 and y == 0 then
		self:SetPoint(point, anchor, attachTo, 0, -4)
	end
end)

local UIChat = CreateFrame("Frame")
UIChat:RegisterEvent("ADDON_LOADED")
UIChat:RegisterEvent("PLAYER_ENTERING_WORLD")
UIChat:SetScript("OnEvent", function(self, event, addon)
	if event == "ADDON_LOADED" then
		if addon == "Blizzard_CombatLog" then
			self:UnregisterEvent("ADDON_LOADED")
			SetupChat(self)
		end
	elseif event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		SetupChatPosAndFont(self)
	end
end)

-- Setup temp chat (BN, WHISPER) when needed
local function SetupTempChat()
	local frame = FCF_GetCurrentChatFrame()
	if frame.skinned then return end
	SetChatStyle(frame)
end
hooksecurefunc("FCF_OpenTemporaryWindow", SetupTempChat)

-- Disable pet battle tab
local old = FCFManager_GetNumDedicatedFrames
function FCFManager_GetNumDedicatedFrames(...)
	return select(1, ...) ~= "PET_BATTLE_COMBAT_LOG" and old(...) or 1
end

-- Remove player's realm name
local function RemoveRealmName(_, _, msg, author, ...)
	local realm = string.gsub(T.realm, " ", "")
	if msg:find("-" .. realm) then
		return false, gsub(msg, "%-"..realm, ""), author, ...
	end
end
ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", RemoveRealmName)

----------------------------------------------------------------------------------------
--	Save slash command typo
----------------------------------------------------------------------------------------
local function TypoHistory_Posthook_AddMessage(chat, text)
	if text and strfind(text, HELP_TEXT_SIMPLE) then
		ChatEdit_AddHistory(chat.editBox)
	end
end

for i = 1, NUM_CHAT_WINDOWS do
	if i ~= 2 then
		hooksecurefunc(_G["ChatFrame"..i], "AddMessage", TypoHistory_Posthook_AddMessage)
	end
end

----------------------------------------------------------------------------------------
--	Loot icons
----------------------------------------------------------------------------------------
if C.chat.loot_icons == true then
	local function AddLootIcons(_, _, message, ...)
		local function Icon(link)
			local texture = C_Item.GetItemIconByID(link)
			return "\124T"..texture..":12:12:0:0:64:64:5:59:5:59\124t"..link
		end
		message = message:gsub("(\124c%x+\124Hitem:.-\124h\124r)", Icon)
		return false, message, ...
	end

	ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", AddLootIcons)
end

----------------------------------------------------------------------------------------
--	Swith channels by Tab
----------------------------------------------------------------------------------------
local cycles = {
	{chatType = "SAY", use = function() return 1 end},
	{chatType = "PARTY", use = function() return not IsInRaid() and IsInGroup(LE_PARTY_CATEGORY_HOME) end},
	{chatType = "RAID", use = function() return IsInRaid(LE_PARTY_CATEGORY_HOME) end},
	{chatType = "INSTANCE_CHAT", use = function() return IsPartyLFG() or C_PartyInfo.IsPartyWalkIn() end},
	{chatType = "GUILD", use = function() return IsInGuild() end},
	{chatType = "SAY", use = function() return 1 end},
}

local function UpdateTabChannelSwitch(self)
	if strsub(tostring(self:GetText()), 1, 1) == "/" then return end
	local currChatType = self:GetAttribute("chatType")
	for i, curr in ipairs(cycles) do
		if curr.chatType == currChatType then
			local h, r, step = i + 1, #cycles, 1
			if IsShiftKeyDown() then h, r, step = i - 1, 1, -1 end
			for j = h, r, step do
				if cycles[j]:use(self, currChatType) then
					self:SetAttribute("chatType", cycles[j].chatType)
					ChatEdit_UpdateHeader(self)
					return
				end
			end
		end
	end
end
hooksecurefunc("ChatEdit_CustomTabPressed", UpdateTabChannelSwitch)

----------------------------------------------------------------------------------------
--	Role icons
----------------------------------------------------------------------------------------
if C.chat.role_icons == true then
	local chats = {
		CHAT_MSG_SAY = 1, CHAT_MSG_YELL = 1,
		CHAT_MSG_WHISPER = 1, CHAT_MSG_WHISPER_INFORM = 1,
		CHAT_MSG_PARTY = 1, CHAT_MSG_PARTY_LEADER = 1,
		CHAT_MSG_INSTANCE_CHAT = 1, CHAT_MSG_INSTANCE_CHAT_LEADER = 1,
		CHAT_MSG_RAID = 1, CHAT_MSG_RAID_LEADER = 1, CHAT_MSG_RAID_WARNING = 1,
	}

	local role_tex = {
		TANK = "\124T"..[[Interface\AddOns\ShestakUI\Media\Textures\Tank.tga]]..":12:12:0:0:64:64:5:59:5:59\124t",
		HEALER	= "\124T"..[[Interface\AddOns\ShestakUI\Media\Textures\Healer.tga]]..":12:12:0:0:64:64:5:59:5:59\124t",
		DAMAGER = "\124T"..[[Interface\AddOns\ShestakUI\Media\Textures\Damager.tga]]..":12:12:0:0:64:64:5:59:5:59\124t",
	}

	local GetColoredName_orig = _G.GetColoredName
	local function GetColoredName_hook(event, arg1, arg2, ...)
		local ret = GetColoredName_orig(event, arg1, arg2, ...)
		if chats[event] then
			local role = UnitGroupRolesAssigned(arg2)
			if role == "NONE" and arg2:match(" *- *"..GetRealmName().."$") then
				role = UnitGroupRolesAssigned(arg2:gsub(" *-[^-]+$",""))
			end
			if role and role ~= "NONE" then
				ret = role_tex[role]..""..ret
			end
		end
		return ret
	end
	_G.GetColoredName = GetColoredName_hook
end

----------------------------------------------------------------------------------------
--	Prevent reposition ChatFrame
----------------------------------------------------------------------------------------
hooksecurefunc(ChatFrame1, "SetPoint", function(self, _, _, _, x)
	if MoverInfo and MoverInfo:IsShown() then return end -- Allow to /moveui
	local positionTable = T.CurrentProfile()
	if positionTable["ChatFrame1"] then
		local _, _, _, newx = unpack(positionTable["ChatFrame1"])
		if x ~= newx then
			self:ClearAllPoints()
			self:SetPoint(unpack(positionTable["ChatFrame1"]))
		end
	else
		if x ~= C.position.chat[4] then
			self:ClearAllPoints()
			self:SetSize(C.chat.width, C.chat.height)
			if C.chat.background == true then
				self:SetPoint(C.position.chat[1], C.position.chat[2], C.position.chat[3], C.position.chat[4], C.position.chat[5] + 4)
			else
				self:SetPoint(C.position.chat[1], C.position.chat[2], C.position.chat[3], C.position.chat[4], C.position.chat[5])
			end
		end
	end
end)

----------------------------------------------------------------------------------------
--	Right chat frame
----------------------------------------------------------------------------------------
if not C.chat.second_frame then return end
local rightAnchor = CreateFrame("Frame", "ChatFrameRightAnchor", UIParent)
rightAnchor:SetSize(C.chat.width, C.chat.height)
if C.minimap.on_top then
	if C.chat.background == true then
		rightAnchor:SetPoint(C.position.chat_right[1], C.position.chat_right[2], C.position.chat_right[3], C.position.chat_right[4], C.position.chat_right[5] + 4)
	else
		rightAnchor:SetPoint(unpack(C.position.chat_right))
	end
else
	if C.chat.background == true then
		rightAnchor:SetPoint(C.position.chat_right[1], C.position.chat_right[2], C.position.chat_right[3], C.position.chat_right[4] - C.minimap.size - 23, C.position.chat_right[5] + 4)
	else
		rightAnchor:SetPoint(C.position.chat_right[1], C.position.chat_right[2], C.position.chat_right[3], C.position.chat_right[4] - C.minimap.size - 23, C.position.chat_right[5])
	end
end

hooksecurefunc(ChatFrame4, "SetPoint", function(self, _, _, _, x)
	if x ~= C.position.chat_right[4] then
		self:ClearAllPoints()
		self:SetSize(C.chat.width, C.chat.height)
		self:SetAllPoints(rightAnchor)
	end
end)

C_Timer.After(0.1, function()
	if not ChatFrame4 then
		FCF_OpenNewWindow(LOOT)
	end
	if ChatFrame4 then
		FCF_UnDockFrame(ChatFrame4)
		ChatFrame4:SetAllPoints(rightAnchor)
		FCF_SetTabPosition(ChatFrame4, 0)
		FCF_CheckShowChatFrame(ChatFrame4)
	end
end)
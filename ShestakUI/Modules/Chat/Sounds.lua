﻿local T, C, L = unpack(ShestakUI)
if C.chat.enable ~= true or C.chat.whisp_sound ~= true then return end

----------------------------------------------------------------------------------------
--	Play sound files system(by Tukz)
----------------------------------------------------------------------------------------
local SoundSys = CreateFrame("Frame")
SoundSys:RegisterEvent("CHAT_MSG_WHISPER")
SoundSys:RegisterEvent("CHAT_MSG_BN_WHISPER")
SoundSys:HookScript("OnEvent", function(_, event)
	if event == "CHAT_MSG_WHISPER" or event == "CHAT_MSG_BN_WHISPER" then
		PlaySoundFile(C.media.whisp_sound, "Master")
	end
end)
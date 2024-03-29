﻿local T, C, L = unpack(ShestakUI)
if C.automation.screenshot ~= true then return end

----------------------------------------------------------------------------------------
--	Take screenshots of defined events (Sinaris)
----------------------------------------------------------------------------------------
local function OnEvent()
	C_Timer.After(1, function() Screenshot() end)
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("ACHIEVEMENT_EARNED")
frame:SetScript("OnEvent", OnEvent)
local T, C, L = unpack(ShestakUI)
if C.automation.minimap_zoom ~= true then return end

----------------------------------------------------------------------------------------
--	Auto change minimap zoom level when moving
----------------------------------------------------------------------------------------
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_MOUNT_DISPLAY_CHANGED")
frame:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
frame:RegisterEvent("PLAYER_STARTED_MOVING")
frame:RegisterEvent("PLAYER_STOPPED_MOVING")
frame:RegisterEvent("PLAYER_IS_GLIDING_CHANGED")	-- dragonriding
frame:RegisterEvent("NEW_WMO_CHUNK")				-- change zone in Dornogal
frame:SetScript("OnEvent", function()
	C_Timer.After(0.5, function()
		if IsFlying() then
			Minimap:SetZoom(0)
		else
			local speed = GetUnitSpeed("player")
			if speed == 0 then -- stand
				Minimap:SetZoom(4)
			elseif speed < 10 then -- run
				Minimap:SetZoom(3)
			elseif speed < 20 then -- mounted
				Minimap:SetZoom(2)
			end
		end
	end)
end)
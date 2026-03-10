local T, C, L = unpack(ShestakUI)

----------------------------------------------------------------------------------------
--	Faster auto looting
----------------------------------------------------------------------------------------
if C.loot.faster_loot then
	local tDelay = 0
	local LOOT_DELAY = 0.3

	local frame = CreateFrame("Frame")
	frame:RegisterEvent("LOOT_READY")
	frame:SetScript("OnEvent", function()
		if GetCVarBool("autoLootDefault") ~= IsModifiedClick("AUTOLOOTTOGGLE") then
			if (GetTime() - tDelay) >= LOOT_DELAY then
				for i = GetNumLootItems(), 1, -1 do
					LootSlot(i)
				end
				tDelay = GetTime()
			end
		end
	end)
else
	local frame = CreateFrame("Frame")
	frame:RegisterEvent("LOOT_OPENED")
	frame:SetScript("OnEvent", function()
		local numItems = GetNumLootItems()

		if numItems == 0 then
		   CloseLoot()
		   return
		end

		if GetCVarBool("autoLootDefault") ~= IsModifiedClick("AUTOLOOTTOGGLE") then
			for i = numItems, 1, -1 do
				LootSlot(i)
			end
		end
	end)
end
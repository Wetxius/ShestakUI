local T, C, L = unpack(select(2, ...))

----------------------------------------------------------------------------------------
--	Auto greed on green items(by Tekkub) and NeedTheOrb(by Myrilandell of Lothar)
----------------------------------------------------------------------------------------
if C.loot.auto_greed == true then
	local autogreed = CreateFrame("Frame")
	autogreed:RegisterEvent("START_LOOT_ROLL")
	autogreed:SetScript("OnEvent", function(self, event, id)
		local name = select(2, GetLootRollItemInfo(id))
		if name == select(1, GetItemInfo(43102)) then
			RollOnLoot(id, 2)
		end
		if T.level ~= MAX_PLAYER_LEVEL and T.author ~= true then return end
		if id and select(4, GetLootRollItemInfo(id)) == 2 and not select(5, GetLootRollItemInfo(id)) then
			for i in pairs(T.NeedLoot) do
				if name == select(1, GetItemInfo(T.NeedLoot[i])) and RollOnLoot(id, 1) then
					RollOnLoot(id, 1)
					return
				end
			end
			if RollOnLoot(id, 3) then
				RollOnLoot(id, 3)
			else
				RollOnLoot(id, 2)
			end
		end
	end)
end

----------------------------------------------------------------------------------------
--	Disenchant confirmation(tekKrush by Tekkub)
----------------------------------------------------------------------------------------
if C.loot.auto_confirm_de == true then
	local acd = CreateFrame("Frame")
	acd:RegisterEvent("CONFIRM_DISENCHANT_ROLL")
	acd:RegisterEvent("CONFIRM_LOOT_ROLL")
	acd:RegisterEvent("LOOT_BIND_CONFIRM")
	acd:SetScript("OnEvent", function(self, event, id)
		if GetNumRaidMembers() == 0 and GetNumPartyMembers() == 0 then
			local elapsed = 0
			self:SetScript("OnUpdate", function(self, elap)
				elapsed = elapsed + elap
				if elapsed < 0.2 then
					StaticPopup_Hide("LOOT_BIND")
					return
				end
				elapsed = 0
				ConfirmLootSlot(id)
				self:SetScript("OnUpdate", nil)
			end)
		else
			for i = 1, STATICPOPUP_NUMDIALOGS do
				local frame = _G["StaticPopup"..i]
				if (frame.which == "CONFIRM_LOOT_ROLL" or frame.which == "LOOT_BIND" or frame.which == "LOOT_BIND_CONFIRM") and frame:IsVisible() then StaticPopup_OnClick(frame, 1) end
			end
		end
	end)
end
local T, C, L = unpack(ShestakUI)
if C.unitframe.enable ~= true then return end

----------------------------------------------------------------------------------------
--	Unit frames functions
----------------------------------------------------------------------------------------
local _, ns = ...
local oUF = ns.oUF
T.oUF = oUF

T.UpdateAllElements = function(frame)
	for _, v in ipairs(frame.__elements) do
		v(frame, "UpdateElement", frame.unit)
	end
end

T.SetFontString = function(parent, fontName, fontHeight, fontStyle)
	local fs = parent:CreateFontString(nil, "ARTWORK")
	fs:SetFont(fontName, fontHeight, fontStyle)
	fs:SetShadowOffset(C.font.unit_frames_font_shadow and 1 or 0, C.font.unit_frames_font_shadow and -1 or 0)
	return fs
end

local gradient = C_CurveUtil.CreateColorCurve()
gradient:AddPoint(0.0, CreateColor(0.69, 0.31, 0.31))
gradient:AddPoint(0.5, CreateColor(0.65, 0.63, 0.35))
gradient:AddPoint(1, CreateColor(0.33, 0.59, 0.33))

T.PostUpdateHealth = function(health, unit, cur, max)
	if not health.value then return end	-- arena target
	if not UnitIsConnected(unit) or UnitIsDeadOrGhost(unit) then
		health:SetValue(0)
		if not UnitIsConnected(unit) then
			health.value:SetText("|cffD7BEA5"..L_UF_OFFLINE.."|r")
		elseif UnitIsDead(unit) then
			health.value:SetText("|cffD7BEA5"..L_UF_DEAD.."|r")
		elseif UnitIsGhost(unit) then
			health.value:SetText("|cffD7BEA5"..L_UF_GHOST.."|r")
		end
	else
		local perc = UnitHealthPercent(unit, true, CurveConstants.ScaleTo100)

		local hex
		if C.unitframe.color_value then
			local color = UnitHealthPercent(unit, true, gradient)
			hex = color:GenerateHexColor()
		end
		if (unit == "player" and not UnitHasVehicleUI("player") or unit == "vehicle") and health:GetAttribute("normalUnit") ~= "pet" then
			if C.unitframe.show_total_value then
				if C.unitframe.color_value then
					health.value:SetFormattedText("|cff559655%s|r |cffD7BEA5-|r |cff559655%s|r", AbbreviateNumbers(cur), AbbreviateNumbers(max))
				else
					health.value:SetFormattedText("|cffffffff%s - %s|r", AbbreviateNumbers(cur), AbbreviateNumbers(max))
				end
			else
				if C.unitframe.color_value then
					health.value:SetFormattedText("|cffAF5050%d|r |cffD7BEA5-|r |c%s%d%%|r", cur, hex, perc)
				else
					health.value:SetFormattedText("|cffffffff%d - %d%%|r", cur, perc)
				end
			end
		elseif unit == "target" then
			if C.unitframe.show_total_value then
				if C.unitframe.color_value then
					health.value:SetFormattedText("|cff559655%s|r |cffD7BEA5-|r |cff559655%s|r", AbbreviateNumbers(cur), AbbreviateNumbers(max))
				else
					health.value:SetFormattedText("|cffffffff%s - %s|r", AbbreviateNumbers(cur), AbbreviateNumbers(max))
				end
			else
				if C.unitframe.color_value then
					health.value:SetFormattedText("|c%s%d%%|r |cffD7BEA5-|r |cffAF5050%s|r", hex, perc, AbbreviateNumbers(cur))
				else
					health.value:SetFormattedText("|cffffffff%d%% - %s|r", perc, AbbreviateNumbers(cur))
				end
			end
		elseif unit and unit:find("boss%d") then
			if C.unitframe.color_value then
				health.value:SetFormattedText("|c%s%d%%|r |cffD7BEA5-|r |cffAF5050%s|r", hex, perc, AbbreviateNumbers(cur))
			else
				health.value:SetFormattedText("|cffffffff%d%% - %s|r", perc, AbbreviateNumbers(cur))
			end
		else
			if C.unitframe.color_value then
				health.value:SetFormattedText("|c%s%d%%|r", hex, perc)
			else
				health.value:SetFormattedText("|cffffffff%d%%|r", perc)
			end
		end

		-- if cur ~= max then
			-- r, g, b = oUF:ColorGradient(cur, max, 0.69, 0.31, 0.31, 0.65, 0.63, 0.35, 0.33, 0.59, 0.33)
			-- if (unit == "player" and not UnitHasVehicleUI("player") or unit == "vehicle") and health:GetAttribute("normalUnit") ~= "pet" then
				-- if C.unitframe.show_total_value then
					-- if C.unitframe.color_value == true then
						-- health.value:SetFormattedText("|cff559655%s|r |cffD7BEA5-|r |cff559655%s|r", T.ShortValue(cur), T.ShortValue(max))
					-- else
						-- health.value:SetFormattedText("|cffffffff%s - %s|r", T.ShortValue(cur), T.ShortValue(max))
					-- end
				-- else
					-- if C.unitframe.color_value == true then
						-- health.value:SetFormattedText("|cffAF5050%d|r |cffD7BEA5-|r |cff%02x%02x%02x%d%%|r", cur, r * 255, g * 255, b * 255, floor(cur / max * 100))
					-- else
						-- health.value:SetFormattedText("|cffffffff%d - %d%%|r", cur, floor(cur / max * 100))
					-- end
				-- end
			-- elseif unit == "target" then
				-- if C.unitframe.show_total_value then
					-- if C.unitframe.color_value == true then
						-- health.value:SetFormattedText("|cff559655%s|r |cffD7BEA5-|r |cff559655%s|r", T.ShortValue(cur), T.ShortValue(max))
					-- else
						-- health.value:SetFormattedText("|cffffffff%s - %s|r", T.ShortValue(cur), T.ShortValue(max))
					-- end
				-- else
					-- if C.unitframe.color_value == true then
						-- health.value:SetFormattedText("|cff%02x%02x%02x%d%%|r |cffD7BEA5-|r |cffAF5050%s|r", r * 255, g * 255, b * 255, floor(cur / max * 100), T.ShortValue(cur))
					-- else
						-- health.value:SetFormattedText("|cffffffff%d%% - %s|r", floor(cur / max * 100), T.ShortValue(cur))
					-- end
				-- end
			-- elseif unit and unit:find("boss%d") then
				-- if C.unitframe.color_value == true then
					-- health.value:SetFormattedText("|cff%02x%02x%02x%d%%|r |cffD7BEA5-|r |cffAF5050%s|r", r * 255, g * 255, b * 255, floor(cur / max * 100), T.ShortValue(cur))
				-- else
					-- health.value:SetFormattedText("|cffffffff%d%% - %s|r", floor(cur / max * 100), T.ShortValue(cur))
				-- end
			-- else
				-- if C.unitframe.color_value == true then
					-- health.value:SetFormattedText("|cff%02x%02x%02x%d%%|r", r * 255, g * 255, b * 255, floor(cur / max * 100))
				-- else
					-- health.value:SetFormattedText("|cffffffff%d%%|r", floor(cur / max * 100))
				-- end
			-- end
		-- else
			-- if (unit == "player" and not UnitHasVehicleUI("player") or unit == "vehicle") then
				-- if C.unitframe.color_value == true then
					-- health.value:SetText("|cff559655"..max.."|r")
				-- else
					-- health.value:SetText("|cffffffff"..max.."|r")
				-- end
			-- else
				-- if C.unitframe.color_value == true then
					-- health.value:SetText("|cff559655"..T.ShortValue(max).."|r")
				-- else
					-- health.value:SetText("|cffffffff"..T.ShortValue(max).."|r")
				-- end
			-- end
		-- end
	end
end

T.PostUpdateBackdropColor = function(element, color)
	local bg = element.bg
	if bg then
		local mu = bg.multiplier or 1
		local r, g, b = color:GetRGB()
		bg:SetVertexColor(r * mu, g * mu, b * mu)
	end
end

T.PostUpdateHealthColor = function(health, unit, color)
	T.PostUpdateBackdropColor(health, color)

	if not health.value then return end	-- arena target
	if UnitIsConnected(unit) and not UnitIsDeadOrGhost(unit) then
		local r, g, b
		if (C.unitframe.own_color ~= true and C.unitframe.enemy_health_color and unit == "target" and UnitIsEnemy(unit, "player") and (UnitIsPlayer(unit) or UnitInPartyIsAI(unit))) or (C.unitframe.own_color ~= true and unit == "target" and not UnitIsPlayer(unit) and not UnitInPartyIsAI(unit) and UnitIsFriend(unit, "player")) then
			local c = T.oUF_colors.reaction[UnitReaction(unit, "player")]
			if c then
				r, g, b = c:GetRGB()
			else
				r, g, b = 0.3, 0.7, 0.3
			end
			health:SetStatusBarColor(r, g, b)
		end
		if unit == "pet" then
			local _, class = UnitClass("player")
			local r, g, b = T.oUF_colors.class[class]:GetRGB()
			if C.unitframe.own_color then
				health:SetStatusBarColor(unpack(C.unitframe.uf_color))
				health.bg:SetVertexColor(0.1, 0.1, 0.1)
			else
				if b then
					health:GetStatusBarTexture():SetVertexColor(r, g, b)
					if health.bg and health.bg.multiplier then
						local mu = health.bg.multiplier
						health.bg:SetVertexColor(r * mu, g * mu, b * mu)
					end
				end
			end
		end
		if C.unitframe.bar_color_value and not UnitIsTapDenied(unit) then
			if C.unitframe.own_color then
				r, g, b = C.unitframe.uf_color[1], C.unitframe.uf_color[2], C.unitframe.uf_color[3]
			else
				r, g, b = health:GetStatusBarColor()
			end

			local curve = C_CurveUtil.CreateColorCurve()
			curve:AddPoint(0.0, CreateColor(1, 0, 0))
			curve:AddPoint(0.5, CreateColor(1, 1, 0))
			curve:AddPoint(1, CreateColor(r, g, b))

			local color = UnitHealthPercent(unit, true, curve)
			local newr, newg, newb = color:GetRGB()
			health:GetStatusBarTexture():SetVertexColor(newr, newg, newb)
			if health.bg and health.bg.multiplier then
				-- local mu = health.bg.multiplier -- can't calc secret value
				health.bg:SetVertexColor(newr, newg, newb, 0.2)
			end
		end
	end
end

T.PostUpdateRaidHealth = function(health, unit, cur, max)
	local self = health:GetParent()
	local power = self.Power
	local border = self.backdrop
	if not UnitIsConnected(unit) or UnitIsDeadOrGhost(unit) then
		health:SetValue(0)
		if not UnitIsConnected(unit) then
			health.value:SetText("|cffD7BEA5"..L_UF_OFFLINE.."|r")
		elseif UnitIsDead(unit) then
			health.value:SetText("|cffD7BEA5"..L_UF_DEAD.."|r")
		elseif UnitIsGhost(unit) then
			health.value:SetText("|cffD7BEA5"..L_UF_GHOST.."|r")
		end
	else
		local perc = UnitHealthPercent(unit, true, CurveConstants.ScaleTo100)

		local hex
		if C.unitframe.color_value then
			local color = UnitHealthPercent(unit, true, gradient)
			hex = color:GenerateHexColor()
		end
		if self:GetParent():GetName():match("oUF_PartyDPS") then
			if C.unitframe.color_value then
				health.value:SetFormattedText("|cffAF5050%s|r |cffD7BEA5-|r |c%s%d%%|r", AbbreviateNumbers(cur), hex, perc)
			else
				health.value:SetFormattedText("|cffffffff%s - %d%%|r", AbbreviateNumbers(cur), perc)
			end
		else
			if C.unitframe.color_value then
				if C.raidframe.deficit_health then
					local missing = UnitHealthMissing(unit)
					health.value:SetText("|cffffffff".."-"..AbbreviateNumbers(missing))
				else
					health.value:SetFormattedText("|c%s%d%%|r", hex, perc)
				end
			else
				if C.raidframe.deficit_health then
					local missing = UnitHealthMissing(unit)
					health.value:SetText("|cffffffff".."-"..AbbreviateNumbers(missing))
				else
					health.value:SetFormattedText("|cffffffff%d%%|r", perc)
				end
			end
		end

		-- if cur ~= max then
			-- r, g, b = oUF:ColorGradient(cur, max, 0.69, 0.31, 0.31, 0.65, 0.63, 0.35, 0.33, 0.59, 0.33)
			-- if self:GetParent():GetName():match("oUF_PartyDPS") then
				-- if C.unitframe.color_value == true then
					-- health.value:SetFormattedText("|cffAF5050%s|r |cffD7BEA5-|r |cff%02x%02x%02x%d%%|r", T.ShortValue(cur), r * 255, g * 255, b * 255, floor(cur / max * 100))
				-- else
					-- health.value:SetFormattedText("|cffffffff%s - %d%%|r", T.ShortValue(cur), floor(cur / max * 100))
				-- end
			-- else
				-- if C.unitframe.color_value == true then
					-- if C.raidframe.deficit_health == true then
						-- health.value:SetText("|cffffffff".."-"..T.ShortValue(max - cur))
					-- else
						-- health.value:SetFormattedText("|cff%02x%02x%02x%d%%|r", r * 255, g * 255, b * 255, floor(cur / max * 100))
					-- end
				-- else
					-- if C.raidframe.deficit_health == true then
						-- health.value:SetText("|cffffffff".."-"..T.ShortValue(max - cur))
					-- else
						-- health.value:SetFormattedText("|cffffffff%d%%|r", floor(cur / max * 100))
					-- end
				-- end
			-- end
		-- else
			-- if C.unitframe.color_value == true then
				-- health.value:SetText("|cff559655"..T.ShortValue(max).."|r")
			-- else
				-- health.value:SetText("|cffffffff"..T.ShortValue(max).."|r")
			-- end
		-- end
		if C.raidframe.alpha_health then
			-- if cur / max > 0.95 then -- BETA can't calc secret value
				-- health:SetAlpha(0.6)
				-- power:SetAlpha(0.6)
				-- border:SetAlpha(0.6)
			-- else
				-- health:SetAlpha(1)
				-- power:SetAlpha(1)
				-- border:SetAlpha(1)
			-- end
		end
	end
end

T.PostUpdateRaidHealthColor = function(health, unit, color)
	T.PostUpdateBackdropColor(health, color)

	if UnitIsConnected(unit) and not UnitIsDeadOrGhost(unit) then
		local r, g, b
		if not UnitIsPlayer(unit) and not UnitInPartyIsAI(unit) and UnitIsFriend(unit, "player") and C.unitframe.own_color ~= true then
			local c = T.oUF_colors.reaction[5]
			local r, g, b = c:GetRGB()
			health:SetStatusBarColor(r, g, b)
			if health.bg and health.bg.multiplier then
				local mu = health.bg.multiplier
				health.bg:SetVertexColor(r * mu, g * mu, b * mu)
			end
		end
		if C.unitframe.bar_color_value and not UnitIsTapDenied(unit) then
			if C.unitframe.own_color then
				r, g, b = C.unitframe.uf_color[1], C.unitframe.uf_color[2], C.unitframe.uf_color[3]
			else
				r, g, b = health:GetStatusBarColor()
			end

			local curve = C_CurveUtil.CreateColorCurve()
			curve:AddPoint(0.0, CreateColor(1, 0, 0))
			curve:AddPoint(0.5, CreateColor(1, 1, 0))
			curve:AddPoint(1, CreateColor(r, g, b))

			local color = UnitHealthPercent(unit, true, curve)
			local newr, newg, newb = color:GetRGB()
			health:GetStatusBarTexture():SetVertexColor(newr, newg, newb)
			if health.bg and health.bg.multiplier then
				-- local mu = health.bg.multiplier -- can't calc secret value
				health.bg:SetVertexColor(newr, newg, newb, 0.2)
			end
		end
	end
end

T.ForceUpdate = function(self)
	self.Power:ForceUpdate(self.Power)
end

T.PostUpdatePower = function(power, unit, cur, _, max)
	local self = power:GetParent()
	local pType, pToken = UnitPowerType(unit)
	local isDead = not UnitIsConnected(unit) or UnitIsDeadOrGhost(unit)

	if isDead then
		power:SetValue(0)
	end

	-- if unit == "focus" or unit == "focustarget" or unit == "targettarget" or (self:GetParent():GetName():match("oUF_RaidDPS")) then return end
	if not power.value then return end

	if isDead then -- BETA or max == 0
		power.value:SetText()
	else
		local perc = UnitPowerPercent(unit, pType, true, CurveConstants.ScaleTo100)

		if pType == 0 and pToken ~= "POWER_TYPE_DINO_SONIC" then
			if unit == "target" then
				if C.unitframe.show_total_value then
					if C.unitframe.color_value then
						power.value:SetFormattedText("%s |cffD7BEA5-|r %s", AbbreviateNumbers(cur), AbbreviateNumbers(max))
					else
						power.value:SetFormattedText("|cffffffff%s - %s|r", AbbreviateNumbers(cur), AbbreviateNumbers(max))
					end
				else
					if C.unitframe.color_value then
						power.value:SetFormattedText("%d%% |cffD7BEA5-|r %s", perc, AbbreviateNumbers(cur))
					else
						power.value:SetFormattedText("|cffffffff%d%% - %s|r", perc, AbbreviateNumbers(cur))
					end
				end
			elseif (unit == "player" and power:GetAttribute("normalUnit") == "pet") or unit == "pet" then
				if C.unitframe.show_total_value then
					if C.unitframe.color_value then
						power.value:SetFormattedText("%s |cffD7BEA5-|r %s", AbbreviateNumbers(cur), AbbreviateNumbers(max))
					else
						power.value:SetFormattedText("%s |cffffffff-|r %s", AbbreviateNumbers(cur), AbbreviateNumbers(max))
					end
				else
					if C.unitframe.color_value then
						power.value:SetFormattedText("%d%%", perc)
					else
						power.value:SetFormattedText("|cffffffff%d%%|r", perc)
					end
				end
			elseif unit and (unit:find("arena%d") or unit:find("boss%d")) then
				if C.unitframe.color_value then
					power.value:SetFormattedText("|cffD7BEA5%d%% - %s|r", perc, AbbreviateNumbers(cur))
				else
					power.value:SetFormattedText("|cffffffff%d%% - %s|r", perc, AbbreviateNumbers(cur))
				end
			elseif self:GetParent():GetName():match("oUF_PartyDPS") then
				if C.unitframe.color_value then
					power.value:SetFormattedText("%s |cffD7BEA5-|r %d%%", AbbreviateNumbers(cur), perc)
				else
					power.value:SetFormattedText("|cffffffff%s - %d%%|r", AbbreviateNumbers(cur), perc)
				end
			else
				if C.unitframe.show_total_value then
					if C.unitframe.color_value then
						power.value:SetFormattedText("%s |cffD7BEA5-|r %s", AbbreviateNumbers(cur), AbbreviateNumbers(max))
					else
						power.value:SetFormattedText("|cffffffff%s - %s|r", AbbreviateNumbers(cur), AbbreviateNumbers(max))
					end
				else
					if C.unitframe.color_value then
						power.value:SetFormattedText("%d |cffD7BEA5-|r %d%%", cur, perc)
					else
						power.value:SetFormattedText("|cffffffff%d - %d%%|r", cur, perc)
					end
				end
			end
		else
			if C.unitframe.color_value then
				power.value:SetText(cur)
			else
				power.value:SetText("|cffffffff"..cur.."|r")
			end
		end

		-- if cur ~= max then
			-- if pType == 0 and pToken ~= "POWER_TYPE_DINO_SONIC" then
				-- if unit == "target" then
					-- if C.unitframe.show_total_value then
						-- if C.unitframe.color_value == true then
							-- power.value:SetFormattedText("%s |cffD7BEA5-|r %s", T.ShortValue(max - (max - cur)), T.ShortValue(max))
						-- else
							-- power.value:SetFormattedText("|cffffffff%s - %s|r", T.ShortValue(max - (max - cur)), T.ShortValue(max))
						-- end
					-- else
						-- if C.unitframe.color_value == true then
							-- power.value:SetFormattedText("%d%% |cffD7BEA5-|r %s", perc, T.ShortValue(max - (max - cur)))
						-- else
							-- power.value:SetFormattedText("|cffffffff%d%% - %s|r", perc, T.ShortValue(max - (max - cur)))
						-- end
					-- end
				-- elseif (unit == "player" and power:GetAttribute("normalUnit") == "pet") or unit == "pet" then
					-- if C.unitframe.show_total_value then
						-- if C.unitframe.color_value == true then
							-- power.value:SetFormattedText("%s |cffD7BEA5-|r %s", T.ShortValue(max - (max - cur)), T.ShortValue(max))
						-- else
							-- power.value:SetFormattedText("%s |cffffffff-|r %s", T.ShortValue(max - (max - cur)), T.ShortValue(max))
						-- end
					-- else
						-- if C.unitframe.color_value == true then
							-- power.value:SetFormattedText("%d%%", perc)
						-- else
							-- power.value:SetFormattedText("|cffffffff%d%%|r", perc)
						-- end
					-- end
				-- elseif unit and (unit:find("arena%d") or unit:find("boss%d")) then
					-- if C.unitframe.color_value == true then
						-- power.value:SetFormattedText("|cffD7BEA5%d%% - %s|r", perc, T.ShortValue(max - (max - cur)))
					-- else
						-- power.value:SetFormattedText("|cffffffff%d%% - %s|r", perc, T.ShortValue(max - (max - cur)))
					-- end
				-- elseif self:GetParent():GetName():match("oUF_PartyDPS") then
					-- if C.unitframe.color_value == true then
						-- power.value:SetFormattedText("%s |cffD7BEA5-|r %d%%", T.ShortValue(max - (max - cur)), perc)
					-- else
						-- power.value:SetFormattedText("|cffffffff%s - %d%%|r", T.ShortValue(max - (max - cur)), perc)
					-- end
				-- else
					-- if C.unitframe.show_total_value then
						-- if C.unitframe.color_value == true then
							-- power.value:SetFormattedText("%s |cffD7BEA5-|r %s", T.ShortValue(max - (max - cur)), T.ShortValue(max))
						-- else
							-- power.value:SetFormattedText("|cffffffff%s - %s|r", T.ShortValue(max - (max - cur)), T.ShortValue(max))
						-- end
					-- else
						-- if C.unitframe.color_value == true then
							-- power.value:SetFormattedText("%d |cffD7BEA5-|r %d%%", max - (max - cur), perc)
						-- else
							-- power.value:SetFormattedText("|cffffffff%d - %d%%|r", max - (max - cur), perc)
						-- end
					-- end
				-- end
			-- else
				-- if C.unitframe.color_value == true then
					-- power.value:SetText(max - (max - cur))
				-- else
					-- power.value:SetText("|cffffffff"..max - (max - cur).."|r")
				-- end
			-- end
		-- else
			-- if unit == "pet" or unit == "target" or (unit and unit:find("arena%d")) or (self:GetParent():GetName():match("oUF_PartyDPS")) then
				-- if C.unitframe.color_value == true then
					-- power.value:SetText(T.ShortValue(cur))
				-- else
					-- power.value:SetText("|cffffffff"..T.ShortValue(cur).."|r")
				-- end
			-- else
				-- if C.unitframe.color_value == true then
					-- power.value:SetText(cur)
				-- else
					-- power.value:SetText("|cffffffff"..cur.."|r")
				-- end
			-- end
		-- end
	end
end

T.PostUpdatePowerBackdropColor = function(element, color, altR, altG, altB)
	local bg = element.bg
	if bg then
		local mu = bg.multiplier or 1
		local r, g, b = 0, 0, 0
		if color then
			r, g, b = color:GetRGB()
		elseif altR then
			r, g, b = altR, altG, altB
		end
		bg:SetVertexColor(r * mu, g * mu, b * mu)
	end
end

T.PostUpdatePowerColor = function(power, unit, color, altR, altG, altB)
	T.PostUpdatePowerBackdropColor(power, color, altR, altG, altB)

	if UnitIsConnected(unit) and not UnitIsDeadOrGhost(unit) then
		local _, pToken = UnitPowerType(unit)

		local color = T.oUF_colors.power[pToken]
		if color then
			power:SetStatusBarColor(color:GetRGB())
			if power.value then
				power.value:SetTextColor(color:GetRGB())
			end
		end
	end
end

local SetUpAnimGroup = function(self)
	self.anim = self:CreateAnimationGroup()
	self.anim:SetLooping("BOUNCE")
	self.anim.fade = self.anim:CreateAnimation("Alpha")
	self.anim.fade:SetFromAlpha(1)
	self.anim.fade:SetToAlpha(0)
	self.anim.fade:SetDuration(0.6)
	self.anim.fade:SetSmoothing("IN_OUT")
end

local Flash = function(self)
	if not self.anim then
		SetUpAnimGroup(self)
	end

	if not self.anim:IsPlaying() then
		self.anim:Play()
	end
end

local StopFlash = function(self)
	if self.anim then
		self.anim:Finish()
	end
end

T.UpdateManaLevel = function(self, elapsed)
	self.elapsed = (self.elapsed or 0) + elapsed
	if self.elapsed < 0.2 then return end
	self.elapsed = 0

	if UnitPowerType("player") == 0 then
		-- local cur = UnitPower("player", 0) -- BETA can't calculate
		-- local max = UnitPowerMax("player", 0)
		-- local percMana = max > 0 and (cur / max * 100) or 100
		-- if percMana <= 20 and not UnitIsDeadOrGhost("player") then
			-- self.ManaLevel:SetText("|cffaf5050"..MANA_LOW.."|r")
			-- Flash(self)
		-- else
			-- self.ManaLevel:SetText()
			-- StopFlash(self)
		-- end

		if UnitIsDeadOrGhost("player") then
			self.ManaLevel:SetText()
		else
			local curve = C_CurveUtil.CreateColorCurve()
			curve:SetType(Enum.LuaCurveType.Step)
			curve:AddPoint(0, CreateColor(1, 1, 1, 1))
			curve:AddPoint(0.2, CreateColor(1, 1, 1, 0))
			local color = UnitPowerPercent("player", 0, true, curve)
			local _, _, _, alpha = color:GetRGBA()
			self.ManaLevel:SetText("|cffaf5050"..MANA_LOW.."|r")
			self.ManaLevel:SetAlpha(alpha)
		end
	elseif T.class ~= "DRUID" and T.class ~= "PRIEST" and T.class ~= "SHAMAN" then
		self.ManaLevel:SetText()
		StopFlash(self)
	end
end

T.UpdateClassMana = function(self, elapsed)
	self.elapsed = (self.elapsed or 0) + elapsed
	if self.elapsed < 0.05 then return end
	self.elapsed = 0

	if self.unit ~= "player" then return end

	if UnitPowerType("player") ~= 0 then
		-- local min = UnitPower("player", 0) -- BETA can't calculate
		-- local max = UnitPowerMax("player", 0)
		-- local percMana = max > 0 and (min / max * 100) or 100
		local percMana = UnitPowerPercent("player", 0, true, CurveConstants.ScaleTo100)
		-- if percMana <= 20 and not UnitIsDeadOrGhost("player") then
			-- self.FlashInfo.ManaLevel:SetText("|cffaf5050"..MANA_LOW.."|r")
			-- Flash(self.FlashInfo)
		-- else
			-- self.FlashInfo.ManaLevel:SetText()
			-- StopFlash(self.FlashInfo)
		-- end

		if UnitIsDeadOrGhost("player") then
			self.ClassMana:SetAlpha(0)
			self.FlashInfo.ManaLevel:SetText()
		else
			local curve = C_CurveUtil.CreateColorCurve()
			curve:SetType(Enum.LuaCurveType.Step)
			curve:AddPoint(0, CreateColor(1, 1, 1, 1))
			curve:AddPoint(0.2, CreateColor(1, 1, 1, 0))
			local color = UnitPowerPercent("player", 0, true, curve)
			local _, _, _, alpha = color:GetRGBA()
			self.FlashInfo.ManaLevel:SetText("|cffaf5050"..MANA_LOW.."|r")
			self.FlashInfo.ManaLevel:SetAlpha(alpha)

			local curve = C_CurveUtil.CreateColorCurve()
			curve:AddPoint(0.99, CreateColor(1, 1, 1, 1))
			curve:AddPoint(1, CreateColor(1, 1, 1, 0))
			local color = UnitPowerPercent("player", 0, true, curve)
			local _, _, _, alpha = color:GetRGBA()

			-- if min ~= max then
				if self.Power.value:GetText() then
					self.ClassMana:SetPoint("RIGHT", self.Power.value, "LEFT", -1, 0)
					self.ClassMana:SetFormattedText("%d%%|r |cffD7BEA5-|r", percMana)
					self.ClassMana:SetJustifyH("RIGHT")
				else
					self.ClassMana:SetPoint("LEFT", self.Power, "LEFT", 4, 0)
					self.ClassMana:SetFormattedText("%d%%", percMana)
				end
			-- else
				-- self.ClassMana:SetText()
			-- end

			self.ClassMana:SetAlpha(alpha)
		end
	else
		self.ClassMana:SetAlpha(0)
	end
end

T.UpdatePvPStatus = function(self)
	local unit = self.unit

	if self.Status then
		local factionGroup = UnitFactionGroup(unit)
		if UnitIsPVPFreeForAll(unit) then
			self.Status:SetText(PVP)
		elseif factionGroup and UnitIsPVP(unit) then
			self.Status:SetText(PVP)
		else
			self.Status:SetText("")
		end
	end
end

local ticks = {}
local setBarTicks = function(Castbar, numTicks)
	for _, v in pairs(ticks) do
		v:Hide()
	end
	if numTicks and numTicks > 0 then
		local delta = Castbar:GetWidth() / numTicks
		for i = 1, numTicks do
			if not ticks[i] then
				ticks[i] = Castbar:CreateTexture(nil, "OVERLAY")
				ticks[i]:SetTexture(C.media.texture)
				ticks[i]:SetVertexColor(unpack(C.media.border_color))
				ticks[i]:SetWidth(1)
				ticks[i]:SetHeight(Castbar:GetHeight())
				ticks[i]:SetDrawLayer("OVERLAY", 7)
			end
			ticks[i]:ClearAllPoints()
			ticks[i]:SetPoint("CENTER", Castbar, "RIGHT", -delta * i, 0)
			ticks[i]:Show()
		end
	end
end

local function castColor(unit)
	local r, g, b
	if UnitIsPlayer(unit) or UnitInPartyIsAI(unit) or unit == "pet" or unit == "vehicle" then
		local _, class = UnitClass(unit)
		local color = T.oUF_colors.class[class]
		if color then
			r, g, b = color:GetRGB()
		end
	else
		local reaction = UnitReaction(unit, "player")
		local color = T.oUF_colors.reaction[reaction]
		if color and reaction >= 5 then
			r, g, b = color:GetRGB()
		else
			r, g, b = 0.85, 0.77, 0.36
		end
	end

	return r, g, b
end

T.PostCastStart = function(Castbar, unit)
	if unit == "vehicle" then unit = "player" end

	if unit == "player" and C.unitframe.castbar_latency == true and Castbar.Latency then
		local _, _, _, ms = GetNetStats()
		Castbar.Latency:SetText(("%dms"):format(ms))
		if Castbar.casting then
			Castbar.SafeZone:SetDrawLayer("BORDER")
			Castbar.SafeZone:SetVertexColor(0.85, 0.27, 0.27)
		else
			Castbar.SafeZone:SetDrawLayer("ARTWORK")
			Castbar.SafeZone:SetVertexColor(0.85, 0.27, 0.27, 0.75)
		end
	end

	if unit == "player" and C.unitframe.castbar_ticks then
		if Castbar.casting then
			setBarTicks(Castbar, 0)
		else
			local spell = UnitChannelInfo(unit)
			Castbar.channelingTicks = canaccessvalue(spell) and T.CastBarTicks[spell] or 0
			setBarTicks(Castbar, Castbar.channelingTicks)
		end
	end

	local r, g, b = C.unitframe.uf_color[1], C.unitframe.uf_color[2], C.unitframe.uf_color[3]
	if not C.unitframe.own_color then
		r, g, b = castColor(unit)
	end

	if UnitCanAttack("player", unit) then -- check interrupt only for hostile
		local color = C_CurveUtil.EvaluateColorFromBoolean(Castbar.notInterruptible, {r = 0.8, g = 0, b = 0, a = 1}, {r = r, g = g, b = b, a = 1})
		local color_border = C_CurveUtil.EvaluateColorFromBoolean(Castbar.notInterruptible, {r = 0.8, g = 0, b = 0, a = 1}, {r = C.media.border_color[1], g = C.media.border_color[2], b = C.media.border_color[3], a = 1})

		Castbar:GetStatusBarTexture():SetVertexColor(color:GetRGBA())
		if C.unitframe.own_color then
			local color_bg = C_CurveUtil.EvaluateColorFromBoolean(Castbar.notInterruptible, {r = 0.8, g = 0, b = 0, a = 0.2}, {r = C.unitframe.uf_color_bg[1], g = C.unitframe.uf_color_bg[2], b = C.unitframe.uf_color_bg[3], a = 1})
			Castbar.bg:SetVertexColor(color_bg:GetRGBA())
		else
			Castbar.bg:SetVertexColor(color.r, color.g, color.b, 0.2)
		end
		Castbar.Overlay:SetBackdropBorderColor(color_border:GetRGB())
		if (C.unitframe.castbar_icon and unit == "target") or (unit == "focus" and C.unitframe.castbar_focus_type ~= "NONE") then
			Castbar.Button:SetBackdropBorderColor(color_border:GetRGB())
		end
	else
		Castbar:SetStatusBarColor(r, g, b)
		if C.unitframe.own_color then
			Castbar.bg:SetVertexColor(C.unitframe.uf_color_bg[1], C.unitframe.uf_color_bg[2], C.unitframe.uf_color_bg[3], 1)
		else
			Castbar.bg:SetVertexColor(r, g, b, 0.2)
		end
		Castbar.Overlay:SetBackdropBorderColor(unpack(C.media.border_color))
		if (C.unitframe.castbar_icon and unit == "target") or (unit == "focus" and C.unitframe.castbar_focus_type ~= "NONE") then
			Castbar.Button:SetBackdropBorderColor(unpack(C.media.border_color))
		end
	end

	if Castbar.Time and Castbar.Text then
		local timeWidth = Castbar.Time:GetStringWidth()
		if not canaccessvalue(timeWidth) then return end
		local textWidth = Castbar:GetWidth() - timeWidth - 5

		if timeWidth == 0 then
			C_Timer.After(0.05, function()
				if not canaccessvalue(Castbar.Time:GetStringWidth()) then return end
				textWidth = Castbar:GetWidth() - Castbar.Time:GetStringWidth() - 5
				if textWidth > 0 then
					Castbar.Text:SetWidth(textWidth)
				end
			end)
		else
			Castbar.Text:SetWidth(textWidth)
		end
	end
end

T.CustomCastTimeText = function(self, durationObject)
	local duration = durationObject:GetRemainingDuration()
	if self.endTime then
		local max = self.max or (self.endTime - self.startTime)
		self.Time:SetText(("%.1f / %.1f"):format(self.channeling and duration or max - duration, max))
	else
		self.Time:SetText(("%.1f"):format(duration))
	end
end

T.CustomCastDelayText = function(self, durationObject)
	local duration = durationObject:GetRemainingDuration()
	if self.endTime then
		local max = self.max or (self.endTime - self.startTime)
		self.Time:SetText(("%.1f |cffaf5050%s %.1f|r"):format(self.channeling and duration or max - duration, self.channeling and "-" or "+", abs(self.delay)))
	else
		self.Time:SetText(("%.1f"):format(duration))
	end
end

T.AuraTrackerTime = function(self, elapsed)
	if self.active then
		self.timeleft = self.timeleft - elapsed
		if self.timeleft <= 5 then
			self.text:SetTextColor(1, 0, 0)
		else
			self.text:SetTextColor(1, 1, 1)
		end
		if self.timeleft <= 0 then
			self.icon:SetTexture("")
			self.text:SetText("")
		end
		self.text:SetFormattedText("%.1f", self.timeleft)
	end
end

T.PostCreateIcon = function(element, button)
	button:SetTemplate("Default")

	button.remaining = T.SetFontString(button, C.font.auras_font, C.font.auras_font_size, C.font.auras_font_style)
	button.remaining:SetShadowOffset(C.font.auras_font_shadow and 1 or 0, C.font.auras_font_shadow and -1 or 0)
	button.remaining:SetPoint("CENTER", button, "CENTER", 1, 1)
	button.remaining:SetJustifyH("CENTER")

	button.Cooldown.noCooldownCount = true
	button.Cooldown:SetDrawEdge(false)

	button.Icon:SetPoint("TOPLEFT", 2, -2)
	button.Icon:SetPoint("BOTTOMRIGHT", -2, 2)
	button.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

	button.Count:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 1, 0)
	button.Count:SetJustifyH("RIGHT")
	button.Count:SetFont(C.font.auras_font, C.font.auras_font_size, C.font.auras_font_style)
	button.Count:SetShadowOffset(C.font.auras_font_shadow and 1 or 0, C.font.auras_font_shadow and -1 or 0)

	if C.aura.show_spiral == true then
		element.disableCooldown = false
		button.Cooldown:SetReverse(true)
		button.Cooldown:SetHideCountdownNumbers(true)
		button.Cooldown:SetPoint("TOPLEFT", button, "TOPLEFT", 2, -2)
		button.Cooldown:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
		button.parent = CreateFrame("Frame", nil, button)
		button.parent:SetFrameLevel(button.Cooldown:GetFrameLevel() + 1)
		button.Count:SetParent(button.parent)
		button.remaining:SetParent(button.parent)
	else
		element.disableCooldown = true
	end
end

local day, hour, minute = 86400, 3600, 60
local FormatTime = function(s)
	if s >= day then
		return format("%dd", floor(s / day + 0.5))
	elseif s >= hour then
		return format("%dh", floor(s / hour + 0.5))
	elseif s >= minute then
		return format("%dm", floor(s / minute + 0.5))
	elseif s >= 5 then
		return floor(s + 0.5)
	end
	return format("%.1f", s)
end

T.CreateAuraTimer = function(self, elapsed)
	-- if self.timeLeft then
		self.elapsed = (self.elapsed or 0) + elapsed
		if self.elapsed >= 0.1 then
			-- if not self.first then
				-- self.timeLeft = self.timeLeft - self.elapsed
			-- else
				-- self.timeLeft = self.timeLeft - GetTime()
				-- self.first = false
			-- end
			local start, duration = self.Cooldown:GetCooldownTimes()
			local timeleft
			if duration and duration > 0 then
				timeleft = (duration + start) / 1000 - GetTime()
			end
			if timeleft and timeleft > 0 then
				local time = FormatTime(timeleft)
				self.remaining:SetText(time)
			else
				self.remaining:Hide()
				self.remaining:SetText("")
				self:SetScript("OnUpdate", nil)
			end
			self.elapsed = 0
		end
	-- end
end


local playerUnits = {
	player = true,
	pet = true,
	vehicle = true,
}

T.PostUpdateIcon = function(element, button, unit, data)
	if data.isHarmfulAura then
		if not UnitIsFriend("player", unit) and not data.isPlayerAura then
			if not C.aura.player_aura_only then
				button:SetBackdropBorderColor(unpack(C.media.border_color))
				button.Icon:SetDesaturated(true)
			end
		else
			if C.aura.debuff_color_type then
				local color = C_UnitAuras.GetAuraDispelTypeColor(unit, data.auraInstanceID, element.dispelColorCurve)
				button:SetBackdropBorderColor(color:GetRGBA())
				button.Icon:SetDesaturated(false)
			else
				button:SetBackdropBorderColor(1, 0, 0)
			end
		end
	else
		local color = C_CurveUtil.EvaluateColorFromBoolean(data.isStealable, {r = 1, g = 0.85, b = 0, a = 1}, {r = C.media.border_color[1], g = C.media.border_color[2], b = C.media.border_color[3], a = 1})
		button:SetBackdropBorderColor(color:GetRGB())
		if (T.class == "MAGE" or T.class == "PRIEST" or T.class == "SHAMAN" or T.class == "HUNTER") and data.dispelName == "Magic" and not UnitIsFriend("player", unit) then -- this is work? data.dispelName is often nil
			button:SetBackdropBorderColor(1, 0.85, 0)
		else
			button:SetBackdropBorderColor(unpack(C.media.border_color))
		end
		button.Icon:SetDesaturated(false)
	end

	-- if data.duration and (canaccessvalue(data.duration) and data.duration > 0) and C.aura.show_timer == true then
	if data.expirationTime and C.aura.show_timer then
		button.remaining:Show()
		-- button.timeLeft = data.expirationTime
		button:SetScript("OnUpdate", T.CreateAuraTimer)
	else
		button.remaining:Hide()
		-- button.timeLeft = math.huge
		button:SetScript("OnUpdate", nil)
	end

	button.first = true
end

T.PostUpdateGapButton = function(_, _, button)
	button:Hide()
end

T.CustomFilter = function(_, unit, data)
	if C.aura.player_aura_only then
		if data.isHarmfulAura then
			if not UnitIsFriend("player", unit) and not data.isPlayerAura then
				return false
			end
		end
	end
	return true
end

T.CustomFilterBoss = function(_, unit, data)
	if data.isHarmfulAura then
		if data.isPlayerAura or UnitIsUnit(unit, data.sourceUnit) then
		-- if (data.isPlayerAura or data.sourceUnit == unit) then
			-- if (T.DebuffBlackList and not T.DebuffBlackList[data.name]) or not T.DebuffBlackList then -- BETA secret value
				return true
			-- end
		end
		return false
	end
	return true
end

T.UpdateThreat = function(self, unit, status, color)
	local parent = self:GetParent()
	local badunit = not unit or parent.unit ~= unit

	if not badunit and color and status and status > 1 then
		parent.backdrop:SetBackdropBorderColor(color:GetRGB())
	else
		parent.backdrop:SetBackdropBorderColor(unpack(C.media.border_color))
	end
end

local CountOffSets = {
	TOPLEFT = {"LEFT", "RIGHT", 1, 0},
	TOPRIGHT = {"RIGHT", "LEFT", 2, 0},
	BOTTOMLEFT = {"LEFT", "RIGHT", 1, 0},
	BOTTOMRIGHT = {"RIGHT", "LEFT", 2, 0},
	LEFT = {"LEFT", "RIGHT", 1, 0},
	RIGHT = {"RIGHT", "LEFT", 2, 0},
	TOP = {"RIGHT", "LEFT", 2, 0},
	BOTTOM = {"RIGHT", "LEFT", 2, 0},
}

T.CreateAuraWatchIcon = function(_, aura)
	aura:CreateBorder(nil, true)
	aura.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	aura.icon:SetDrawLayer("ARTWORK")
	if aura.cd then
		aura.cd:SetReverse(true)
		aura.cd:SetHideCountdownNumbers(true)
		if C.raidframe.plugins_buffs_timer then
			aura.parent = CreateFrame("Frame", nil, aura)
			aura.parent:SetFrameLevel(aura.cd:GetFrameLevel() + 1)
			aura.remaining = T.SetFontString(aura.parent, C.font.auras_font, C.font.auras_font_size, C.font.auras_font_style)
			aura.remaining:SetShadowOffset(C.font.auras_font_shadow and 1 or 0, C.font.auras_font_shadow and -1 or 0)
			aura.remaining:SetPoint("CENTER", aura, "CENTER", 1, 0)
			aura.remaining:SetJustifyH("CENTER")
		end
	end
end

T.CreateAuraWatch = function(self)
	local auras = CreateFrame("Frame", nil, self)
	auras:SetPoint("TOPLEFT", self.Health, 0, 0)
	auras:SetPoint("BOTTOMRIGHT", self.Health, 0, 0)
	auras.icons = {}
	auras.PostCreateIcon = T.CreateAuraWatchIcon

	if not C.aura.show_timer then
		auras.hideCooldown = true
	end

	local buffs = {}

	if T.RaidBuffs["ALL"] then
		for _, value in pairs(T.RaidBuffs["ALL"]) do
			tinsert(buffs, value)
		end
	end

	if T.RaidBuffs[T.class] then
		for _, value in pairs(T.RaidBuffs[T.class]) do
			tinsert(buffs, value)
		end
	end

	if buffs then
		for _, spell in pairs(buffs) do
			local aura = CreateFrame("Frame", nil, auras)
			aura.spellID = spell[1]
			aura.anyUnit = spell[4]
			aura.strictMatching = spell[5]
			aura:SetSize(7 * C.raidframe.icon_multiplier, 7 * C.raidframe.icon_multiplier)
			aura:SetPoint(spell[2], 0, 0)

			local tex = aura:CreateTexture(nil, "OVERLAY")
			tex:SetAllPoints(aura)
			tex:SetTexture(C.media.blank)
			if spell[3] then
				tex:SetVertexColor(unpack(spell[3]))
			else
				tex:SetVertexColor(0.8, 0.8, 0.8)
			end
			aura.icon = tex

			local count = T.SetFontString(aura, C.font.unit_frames_font, C.font.unit_frames_font_size, C.font.unit_frames_font_style)
			local point, anchorPoint, x, y = unpack(CountOffSets[spell[2]])
			count:SetPoint(point, aura, anchorPoint, x, y)
			aura.count = count

			auras.icons[spell[1]] = aura
		end
	end

	self.AuraWatch = auras
end

T.CreateHealthPrediction = function(self)
	-- Player healing
	local mhpb = CreateFrame("StatusBar", nil, self.Health)
	mhpb:SetPoint("TOPLEFT", self.Health:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
	mhpb:SetPoint("BOTTOMLEFT", self.Health:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
	mhpb:SetStatusBarTexture(C.media.texture)
	mhpb:SetStatusBarColor(0, 1, 0.5, 0.2)

	-- Other healing
	local ohpb = CreateFrame("StatusBar", nil, self.Health)
	ohpb:SetPoint("TOPLEFT", mhpb:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
	ohpb:SetPoint("BOTTOMLEFT", mhpb:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
	ohpb:SetStatusBarTexture(C.media.texture)
	ohpb:SetStatusBarColor(0, 1, 0, 0.2)

	-- Absorb
	local absorb = CreateFrame("StatusBar", nil, self.Health)
	absorb:SetPoint("TOPLEFT", ohpb:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
	absorb:SetPoint("BOTTOMLEFT", ohpb:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
	absorb:SetStatusBarTexture(C.media.texture)
	absorb:SetStatusBarColor(1, 1, 0, 0.2)

	-- From enemy - heal absorb
	local hab = CreateFrame("StatusBar", nil, self.Health)
	hab:SetPoint("TOPRIGHT", self.Health:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
	hab:SetPoint("BOTTOMRIGHT", self.Health:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
	hab:SetStatusBarTexture(C.media.texture)
	hab:SetStatusBarColor(1, 0, 0, 0.4)
	hab:SetReverseFill(true)

	self.HealthPrediction = {
		healingPlayer = mhpb,
		healingOther = ohpb,
		damageAbsorb = absorb,
		healAbsorb = hab,
		incomingHealOverflow = 1
	}

	-- Over absorb in right
	if C.raidframe.plugins_over_absorb then
		local oa = self.Health:CreateTexture(nil, "ARTWORK")
		oa:SetTexture([[Interface\AddOns\ShestakUI\Media\Textures\Cross.tga]], "REPEAT", "REPEAT")
		oa:SetPoint("TOPLEFT", self.Health, "TOPRIGHT", -6, 0)
		oa:SetPoint("BOTTOMLEFT", self.Health, "BOTTOMRIGHT", -6, 0)
		oa:SetVertexColor(0.5, 0.5, 1)
		oa:SetHorizTile(true)
		oa:SetVertTile(true)
		oa:SetAlpha(0.4)
		oa:SetBlendMode("ADD")
		oa:SetWidth(6)
		self.HealthPrediction.overDamageAbsorbIndicator = oa
	end

	-- Over heal absorb from enemy in left
	if C.raidframe.plugins_over_heal_absorb then
		local oha = self.Health:CreateTexture(nil, "ARTWORK")
		oha:SetTexture([[Interface\AddOns\ShestakUI\Media\Textures\Cross.tga]], "REPEAT", "REPEAT")
		oha:SetPoint("TOPRIGHT", self.Health, "TOPLEFT", 6, 0)
		oha:SetPoint("BOTTOMRIGHT", self.Health, "BOTTOMLEFT", 6, 0)
		oha:SetVertexColor(1, 0, 0)
		oha:SetHorizTile(true)
		oha:SetVertTile(true)
		oha:SetAlpha(0.4)
		oha:SetBlendMode("ADD")
		oha:SetWidth(6)
		self.HealthPrediction.overHealAbsorbIndicator = oha
	end
end
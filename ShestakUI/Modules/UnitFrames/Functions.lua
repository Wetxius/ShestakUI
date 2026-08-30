local T, C, L = unpack(ShestakUI)
if C.unitframe.enable ~= true and C.nameplate.enable ~= true then return end

----------------------------------------------------------------------------------------
--	Unit frames functions
----------------------------------------------------------------------------------------
local _, ns = ...
local oUF = ns.oUF
T.oUF = oUF

T.UpdateAllElements = function(frame)
	--BETA for _, v in ipairs(frame.__elements) do
		-- v(frame, "UpdateElement", frame.unit)
	-- end
	frame:UpdateAllElements("UpdateElement")
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

local health_value = C_CurveUtil.CreateColorCurve()
health_value:SetType(Enum.LuaCurveType.Step)
health_value:AddPoint(0, CreateColor(1, 1, 1, 1))
health_value:AddPoint(1, CreateColor(1, 1, 1, 0))

local full_health_value = C_CurveUtil.CreateColorCurve()
full_health_value:SetType(Enum.LuaCurveType.Step)
full_health_value:AddPoint(0, CreateColor(1, 1, 1, 0))
full_health_value:AddPoint(1, CreateColor(1, 1, 1, 1))

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
		health.value:SetAlpha(1)
		health.short_value:SetText()
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
					health.value:SetFormattedText("|cff559655%s|r |cffD7BEA5-|r |cff559655%s|r", T.ShortValue(cur), T.ShortValue(max))
				else
					health.value:SetFormattedText("|cffffffff%s - %s|r", T.ShortValue(cur), T.ShortValue(max))
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
					health.value:SetFormattedText("|cff559655%s|r |cffD7BEA5-|r |cff559655%s|r", T.ShortValue(cur), T.ShortValue(max))
				else
					health.value:SetFormattedText("|cffffffff%s - %s|r", T.ShortValue(cur), T.ShortValue(max))
				end
			else
				if C.unitframe.color_value then
					health.value:SetFormattedText("|c%s%d%%|r |cffD7BEA5-|r |cffAF5050%s|r", hex, perc, T.ShortValue(cur))
				else
					health.value:SetFormattedText("|cffffffff%d%% - %s|r", perc, T.ShortValue(cur))
				end
			end
		elseif unit and unit:find("boss%d") then
			if C.unitframe.color_value then
				health.value:SetFormattedText("|c%s%d%%|r |cffD7BEA5-|r |cffAF5050%s|r", hex, perc, T.ShortValue(cur))
			else
				health.value:SetFormattedText("|cffffffff%d%% - %s|r", perc, T.ShortValue(cur))
			end
		else
			if C.unitframe.color_value then
				health.value:SetFormattedText("|c%s%d%%|r", hex, perc)
			else
				health.value:SetFormattedText("|cffffffff%d%%|r", perc)
			end
		end

		local color = UnitHealthPercent(unit, true, health_value)
		local _, _, _, alpha = color:GetRGBA()
		health.value:SetAlpha(alpha)

		-- Full health
		do
			if (unit == "player" and not UnitHasVehicleUI("player") or unit == "vehicle") then
				if C.unitframe.color_value then
					health.short_value:SetText("|cff559655"..max.."|r")
				else
					health.short_value:SetText("|cffffffff"..max.."|r")
				end
			else
				if C.unitframe.color_value then
					health.short_value:SetText("|cff559655"..T.ShortValue(max).."|r")
				else
					health.short_value:SetText("|cffffffff"..T.ShortValue(max).."|r")
				end
			end

			local color = UnitHealthPercent(unit, true, full_health_value)
			local _, _, _, alpha = color:GetRGBA()
			health.short_value:SetAlpha(alpha)
		end
	end
end

T.PostUpdateBackdropColor = function(element, color)
	local bg = element.bg
	if bg and color then
		-- local mu = bg.multiplier or 1
		local r, g, b = color:GetRGB()
		-- bg:SetVertexColor(r * mu, g * mu, b * mu)
		bg:SetVertexColor(r, g, b, 0.2)
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
				if color then
					r, g, b = color:GetRGB()
				else
					r, g, b = 0.3, 0.7, 0.3
				end
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

local full_health = C_CurveUtil.CreateColorCurve()
full_health:SetType(Enum.LuaCurveType.Step)
full_health:AddPoint(0, CreateColor(1, 1, 1, 1))
full_health:AddPoint(0.95, CreateColor(1, 1, 1, 0.6))

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
		health.value:SetAlpha(1)
		health.short_value:SetText()
	else
		local perc = UnitHealthPercent(unit, true, CurveConstants.ScaleTo100)

		local hex
		if C.unitframe.color_value then
			local color = UnitHealthPercent(unit, true, gradient)
			hex = color:GenerateHexColor()
		end
		if self:GetParent():GetName():match("oUF_PartyDPS") then
			if C.unitframe.color_value then
				health.value:SetFormattedText("|cffAF5050%s|r |cffD7BEA5-|r |c%s%d%%|r", T.ShortValue(cur), hex, perc)
			else
				health.value:SetFormattedText("|cffffffff%s - %d%%|r", T.ShortValue(cur), perc)
			end
		else
			if C.unitframe.color_value then
				if C.raidframe.deficit_health then
					local missing = UnitHealthMissing(unit)
					health.value:SetText("|cffffffff".."-"..T.ShortValue(missing))
				else
					health.value:SetFormattedText("|c%s%d%%|r", hex, perc)
				end
			else
				if C.raidframe.deficit_health then
					local missing = UnitHealthMissing(unit)
					health.value:SetText("|cffffffff".."-"..T.ShortValue(missing))
				else
					health.value:SetFormattedText("|cffffffff%d%%|r", perc)
				end
			end
		end

		local color = UnitHealthPercent(unit, true, health_value)
		local _, _, _, alpha = color:GetRGBA()
		health.value:SetAlpha(alpha)

		-- Full health
		do
			if C.unitframe.color_value then
				health.short_value:SetText("|cff559655"..T.ShortValue(max).."|r")
			else
				health.short_value:SetText("|cffffffff"..T.ShortValue(max).."|r")
			end

			local color = UnitHealthPercent(unit, true, full_health_value)
			local _, _, _, alpha = color:GetRGBA()
			health.short_value:SetAlpha(alpha)
		end

		if C.raidframe.alpha_health then
			local color = UnitHealthPercent(unit, true, full_health)
			local _, _, _, alpha = color:GetRGBA()
			health:SetAlpha(alpha)
			power:SetAlpha(alpha)
			border:SetAlpha(alpha)
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
				if color then
					r, g, b = color:GetRGB()
				else
					r, g, b = 0.3, 0.7, 0.3
				end
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

local power_value = C_CurveUtil.CreateColorCurve()
power_value:SetType(Enum.LuaCurveType.Step)
power_value:AddPoint(0, CreateColor(1, 1, 1, 1))
power_value:AddPoint(1, CreateColor(1, 1, 1, 0))

local full_power_value = C_CurveUtil.CreateColorCurve()
full_power_value:SetType(Enum.LuaCurveType.Step)
full_power_value:AddPoint(0, CreateColor(1, 1, 1, 0))
full_power_value:AddPoint(1, CreateColor(1, 1, 1, 1))

T.PostUpdatePower = function(power, unit, cur, _, max)
	local self = power:GetParent()
	local pType, pToken = UnitPowerType(unit)
	local isDead = not UnitIsConnected(unit) or UnitIsDeadOrGhost(unit)

	if isDead then
		power:SetValue(0)
	end

	if not power.value then return end

	if isDead then
		power.value:SetText()
		power.short_value:SetText()
	else
		local perc = UnitPowerPercent(unit, pType, true, CurveConstants.ScaleTo100)
		local text = C_StringUtil.TruncateWhenZero(cur)	-- hide if zero
		if pType == 0 and pToken ~= "POWER_TYPE_DINO_SONIC" then
			if unit == "target" then
				if C.unitframe.show_total_value then
					if C.unitframe.color_value then
						power.value:SetFormattedText("%s |cffD7BEA5-|r %s", T.ShortValue(cur), T.ShortValue(max))
					else
						power.value:SetFormattedText("|cffffffff%s - %s|r", T.ShortValue(cur), T.ShortValue(max))
					end
				else
					if C.unitframe.color_value then
						power.value:SetFormattedText("%d%% |cffD7BEA5-|r %s", perc, T.ShortValue(cur))
					else
						power.value:SetFormattedText("|cffffffff%d%% - %s|r", perc, T.ShortValue(cur))
					end
				end
			elseif (unit == "player" and power:GetAttribute("normalUnit") == "pet") or unit == "pet" then
				if C.unitframe.show_total_value then
					if C.unitframe.color_value then
						power.value:SetFormattedText("%s |cffD7BEA5-|r %s", T.ShortValue(cur), T.ShortValue(max))
					else
						power.value:SetFormattedText("%s |cffffffff-|r %s", T.ShortValue(cur), T.ShortValue(max))
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
					power.value:SetFormattedText("|cffD7BEA5%d%% - %s|r", perc, T.ShortValue(cur))
				else
					power.value:SetFormattedText("|cffffffff%d%% - %s|r", perc, T.ShortValue(cur))
				end
			elseif self:GetParent():GetName():match("oUF_PartyDPS") then
				if C.unitframe.color_value then
					power.value:SetFormattedText("%s |cffD7BEA5-|r %d%%", T.ShortValue(cur), perc)
				else
					power.value:SetFormattedText("|cffffffff%s - %d%%|r", T.ShortValue(cur), perc)
				end
			else
				if C.unitframe.show_total_value then
					if C.unitframe.color_value then
						power.value:SetFormattedText("%s |cffD7BEA5-|r %s", T.ShortValue(cur), T.ShortValue(max))
					else
						power.value:SetFormattedText("|cffffffff%s - %s|r", T.ShortValue(cur), T.ShortValue(max))
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
				power.value:SetText(text or cur)
			else
				power.value:SetText("|cffffffff"..text or cur.."|r")
			end
		end

		local color = UnitPowerPercent(unit, pType, true, power_value)
		local _, _, _, alpha = color:GetRGBA()
		power.value:SetAlpha(alpha)

		-- Full power
		do
			if unit == "pet" or unit == "target" or (unit and unit:find("arena%d")) or (self:GetParent():GetName():match("oUF_PartyDPS")) then
				if C.unitframe.color_value then
					power.short_value:SetText(T.ShortValue(cur))
				else
					power.short_value:SetText("|cffffffff"..T.ShortValue(cur).."|r")
				end
			else
				if C.unitframe.color_value then
					power.short_value:SetText(cur)
				else
					power.short_value:SetText("|cffffffff"..cur.."|r")
				end
			end

			local color = UnitPowerPercent(unit, pType, true, full_power_value)
			local _, _, _, alpha = color:GetRGBA()
			power.short_value:SetAlpha(alpha)
		end
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

local low_mana = C_CurveUtil.CreateColorCurve()
low_mana:SetType(Enum.LuaCurveType.Step)
low_mana:AddPoint(0, CreateColor(1, 1, 1, 1))
low_mana:AddPoint(0.2, CreateColor(1, 1, 1, 0))

T.UpdateManaLevel = function(self, elapsed)
	self.elapsed = (self.elapsed or 0) + elapsed
	if self.elapsed < 0.2 then return end
	self.elapsed = 0

	if UnitPowerType("player") == 0 then
		if UnitIsDeadOrGhost("player") then
			self.Text:SetAlpha(0)
		else
			local color = UnitPowerPercent("player", 0, true, low_mana)
			local _, _, _, alpha = color:GetRGBA()
			self.Text:SetAlpha(alpha)
		end
	elseif T.class ~= "DRUID" and T.class ~= "PRIEST" and T.class ~= "SHAMAN" then
		self.Text:SetAlpha(0)
	end
end

local full_mana = C_CurveUtil.CreateColorCurve()
full_mana:AddPoint(0.99, CreateColor(1, 1, 1, 1))
full_mana:AddPoint(1, CreateColor(1, 1, 1, 0))

T.UpdateClassMana = function(self, elapsed)
	self.elapsed = (self.elapsed or 0) + elapsed
	if self.elapsed < 0.05 then return end
	self.elapsed = 0

	if self.__unit ~= "player" then return end

	if UnitPowerType("player") ~= 0 then
		if UnitIsDeadOrGhost("player") then
			self.ClassMana:SetAlpha(0)
			self.LowMana.Text:SetAlpha(0)
		else
			local color = UnitPowerPercent("player", 0, true, low_mana)
			local _, _, _, alpha = color:GetRGBA()
			self.LowMana.Text:SetAlpha(alpha)

			local color = UnitPowerPercent("player", 0, true, full_mana)
			local _, _, _, alpha = color:GetRGBA()
			self.ClassMana:SetAlpha(alpha)

			local percMana = UnitPowerPercent("player", 0, true, CurveConstants.ScaleTo100)
			if self.Power.value:GetText() then
				self.ClassMana:SetPoint("RIGHT", self.Power.value, "LEFT", -1, 0)
				self.ClassMana:SetFormattedText("%d%%|r |cffD7BEA5-|r", percMana)
				self.ClassMana:SetJustifyH("RIGHT")
			else
				self.ClassMana:SetPoint("LEFT", self.Power, "LEFT", 4, 0)
				self.ClassMana:SetFormattedText("%d%%", percMana)
			end
		end
	else
		self.ClassMana:SetAlpha(0)
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

T.PostCastStart = function(Castbar, unit, _, notInterruptible)
	if unit == "vehicle" then unit = "player" end

	if unit == "player" and C.unitframe.castbar_latency and Castbar.Latency then
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
		local color = C_CurveUtil.EvaluateColorFromBoolean(notInterruptible, {r = 0.8, g = 0, b = 0, a = 1}, {r = r, g = g, b = b, a = 1})
		local color_border = C_CurveUtil.EvaluateColorFromBoolean(notInterruptible, {r = 0.8, g = 0, b = 0, a = 1}, {r = C.media.border_color[1], g = C.media.border_color[2], b = C.media.border_color[3], a = 1})

		Castbar:GetStatusBarTexture():SetVertexColor(color:GetRGBA())
		if C.unitframe.own_color then
			local color_bg = C_CurveUtil.EvaluateColorFromBoolean(notInterruptible, {r = 0.8, g = 0, b = 0, a = 0.2}, {r = C.unitframe.uf_color_bg[1], g = C.unitframe.uf_color_bg[2], b = C.unitframe.uf_color_bg[3], a = 1})
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
	local elapsed = durationObject:GetElapsedDuration()
	local total = durationObject:GetTotalDuration()

	self.Time:SetText(("%.1f / %.1f"):format(self.channeling and duration or elapsed, total))
end

T.CustomCastDelayText = function(self, durationObject)
	local duration = durationObject:GetRemainingDuration()
	local elapsed = durationObject:GetElapsedDuration()

	self.Time:SetText(("%.1f |cffaf5050%s %.1f|r"):format(self.channeling and duration or elapsed, self.channeling and "-" or "+", abs(self.delay)))
end

local castTimeFormatter = C_StringUtil.CreateSecondsFormatter()
castTimeFormatter:SetDefaultAbbreviation(Enum.SecondsFormatterAbbreviation.OneLetter)
castTimeFormatter:SetMinInterval(Enum.SecondsFormatterInterval.Seconds)
castTimeFormatter:SetMillisecondsThreshold(60)

T.CustomCastbarTimeBinding = function()
	local binding = C_DurationUtil.CreateDurationTextBinding()
	binding:SetTextFormat("{}/{}", {
		{
			property = Enum.DurationTextBindingProperty.ElapsedDuration,
			formatter = castTimeFormatter,
		},
		{
			property = Enum.DurationTextBindingProperty.TotalDuration,
			formatter = castTimeFormatter,
		},
	})

	return binding
end

local colorStages = {
	[1] = {1, 0, 0},
	[2] = {1, 0.4, 0},
	[3] = {1, 0.9, 0},
	[4] = {0, 1, 0.5},
	[5] = {0, 1, 0.3},
	[6] = {0, 1, 0},
}

T.CustomCreatePip = function(element)
	local pip = CreateFrame("Frame", nil, element:GetParent())
	pip:SetSize(2, element:GetHeight())

	pip.texture = pip:CreateTexture(nil, "BORDER", nil, -2)
	pip.texture:SetTexture(C.media.texture)

	pip.gap = pip:CreateTexture(nil, "ARTWORK")
	pip.gap:SetAllPoints(pip)
	pip.gap:SetTexture(C.media.texture)

	return pip
end

T.PostUpdatePips = function(element)
	for i, pip in next, element.Pips do
		local r, g, b = 0, 1, 1
		if colorStages[i] then
			r, g, b = unpack(colorStages[i])
		end

		pip.texture:SetVertexColor(r, g, b)
		pip.gap:SetVertexColor(r * 0.75, g * 0.75, b * 0.75)

		pip.texture:ClearAllPoints()

		local anchor = element.Pips[i + 1] or element
		if element:GetReverseFill() then
			pip.texture:SetPoint("TOPLEFT", anchor, 0, 0)
			pip.texture:SetPoint("BOTTOMRIGHT", pip, 0, 0)
		else
			pip.texture:SetPoint("TOPRIGHT", anchor, 0, 0)
			pip.texture:SetPoint("BOTTOMLEFT", pip, 0, 0)
		end
	end
end

local dispelColor = {
	None = CreateColor(1, 0, 0),
	Magic = CreateColor(0.2, 0.6, 1),
	Curse = CreateColor(0.6, 0, 1),
	Disease = CreateColor(0.6, 0.4, 0),
	Poison = CreateColor(0, 0.6, 0),
	Enrage = CreateColor(0.95, 0.4, 0.95),
	Bleed = CreateColor(1, 0, 0.5)
}

T.PostCreateIcon = function(element, button, options)
	button:SetTemplate("Default")

	T.SkinCooldown(button.Cooldown, "aura")

	button.Icon:SetPoint("TOPLEFT", 2, -2)
	button.Icon:SetPoint("BOTTOMRIGHT", -2, 2)
	button.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

	button.Count:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 1, 0)
	button.Count:SetJustifyH("RIGHT")
	button.Count:SetFont(C.font.auras_font, C.font.auras_font_size, C.font.auras_font_style)
	button.Count:SetShadowOffset(C.font.auras_font_shadow and 1 or 0, C.font.auras_font_shadow and -1 or 0)

	if options.notPlayerDebuff then
		button:SetBackdropBorderColor(unpack(C.media.border_color))
		button.Icon:SetDesaturated(true)
	elseif options.showStealable then
		for _, border in pairs{T.CreateBorderTexture(button)} do
			button:AddDispelTypeTexture(border, {
				style = Enum.CustomAuraButtonDispelTypeTextureStyle.PreserveAsset,
				showWhenHelpful = true,
				showWithoutDispelType = true,
				stealableFilter = Enum.CustomAuraButtonDispelTypeStealableFilter.Stealable
			})
		end
	elseif C.aura.debuff_color_type then
		for _, border in pairs{T.CreateBorderTexture(button)} do
			button:AddDispelTypeTexture(border, {
			   style = Enum.CustomAuraButtonDispelTypeTextureStyle.PreserveAsset,
			   showWithoutDispelType = true,
			   customDispelColorMap = dispelColor,
			})
		end
	end

	-- TODO: add custom stealable border

	if C.aura.show_spiral then
		button.Cooldown:SetReverse(true)
		button.Cooldown:SetPoint("TOPLEFT", button, "TOPLEFT", 2, -2)
		button.Cooldown:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
		-- button.parent = CreateFrame("Frame", nil, button)
		-- button.parent:SetFrameLevel(button.Cooldown:GetFrameLevel() + 1)
		-- button.Count:SetParent(button.parent)
	else
		-- button.Cooldown:SetAlpha(0)
	end

	if element.isRaidDebuff then
		button.Cooldown:SetHideCountdownNumbers(not C.raidframe.plugins_buffs_timer)
	end
end

T.PostUpdateIcon = function(_, button, unit, data)
	if data.isHarmfulAura then
		if not UnitIsFriend("player", unit) and not data.isPlayerAura then
			if not C.aura.player_aura_only then
				button:SetBackdropBorderColor(unpack(C.media.border_color))
				button.Icon:SetDesaturated(true)
			end
		else
			if C.aura.debuff_color_type then
				local color = C_UnitAuras.GetAuraDispelTypeColor(unit, data.auraInstanceID, T.DispelCurve)
				if color then
					button:SetBackdropBorderColor(color:GetRGBA())
				end
				button.Icon:SetDesaturated(false)
			else
				button:SetBackdropBorderColor(1, 0, 0)
			end
		end
	else
		local color = C_CurveUtil.EvaluateColorFromBoolean(data.isStealable, {r = 1, g = 0.85, b = 0, a = 1}, {r = C.media.border_color[1], g = C.media.border_color[2], b = C.media.border_color[3], a = 1})
		button:SetBackdropBorderColor(color:GetRGB())
		button.Icon:SetDesaturated(false)
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

T.CreateRaidBuffIcon = function(element, button)
	T.SkinCooldown(button.Cooldown, "aura")

	button.Cooldown:SetHideCountdownNumbers(not C.raidframe.plugins_buffs_timer)

	button:CreateBorder(nil, true)
	button.oborder:SetOutside(button.Icon, 1, 1)

	button.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

	if element.point then
		local point, anchorPoint, x, y = unpack(CountOffSets[element.point])
		button.Count:SetPoint(point, button, anchorPoint, x, y)
	else
		button.Count:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 4, -1)
		button.Count:SetJustifyH("RIGHT")
	end
	button.Count:SetFont(C.font.unit_frames_font, C.font.unit_frames_font_size, C.font.unit_frames_font_style)
	button.Count:SetShadowOffset(C.font.auras_font_shadow and 1 or 0, C.font.auras_font_shadow and -1 or 0)

	if element.color then
		local tex = button:CreateTexture(nil, "OVERLAY")
		tex:SetAllPoints(button)
		tex:SetTexture(C.media.blank)
		tex:SetVertexColor(unpack(element.color))
	end

	if C.aura.show_spiral then
		button.Cooldown:SetReverse(true)
		-- button.parent = CreateFrame("Frame", nil, button)
		-- button.parent:SetFrameLevel(button.Cooldown:GetFrameLevel() + 1)
		-- button.Count:SetParent(button.parent)
	else
		-- button.Cooldown:SetAlpha(0)
	end
end

T.CreateAuraWatch = function(self)
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
			local auras = self:CreateAuras()
			auras.size = 7 * C.raidframe.icon_multiplier
			auras:SetPoint(spell[2], 0, 0)
			auras.showCount = true
			auras.disableMouse = true

			auras.point = spell[2]
			auras.color = spell[3]

			if not C.aura.show_timer then
				auras.disableCooldown = true
			end

			auras.PostCreateButton = T.CreateRaidBuffIcon

			local filter = spell[4] and "HELPFUL" or "HELPFUL|PLAYER"
			auras:AddGroup(filter, {
				candidateFilters = {includeSpellIDs = {[spell[1]] = true}},
				maxFrameCount = 1,
			})
		end
	end
end

T.PrivateAurasSetPosition = function(element, aura)
	aura:ClearAllPoints()
	aura:SetPoint("CENTER", element, "CENTER", 0, 0)
end

T.PrivateAurasPostUpdate = function(self)
	for i = 1, #self do
		local aura = self[i]
		aura:SetSize(0.0001, 0.0001)
	end
end

T.CreateHealthPrediction = function(self, vertical)
	-- Player healing
	local mhpb = CreateFrame("StatusBar", nil, self.Health)
	if vertical then
		mhpb:SetPoint("BOTTOMLEFT", self.Health:GetStatusBarTexture(), "TOPLEFT", 0, 0)
		mhpb:SetPoint("BOTTOMRIGHT", self.Health:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
		mhpb:SetOrientation("VERTICAL")
	else
		mhpb:SetPoint("TOPLEFT", self.Health:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
		mhpb:SetPoint("BOTTOMLEFT", self.Health:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
	end
	mhpb:SetStatusBarTexture(C.media.texture)
	mhpb:SetStatusBarColor(0, 1, 0.5, 0.2)
	mhpb:SetValue(0)
	self.Health.HealingPlayer = mhpb

	-- Other healing
	local ohpb = CreateFrame("StatusBar", nil, self.Health)
	if vertical then
		ohpb:SetPoint("BOTTOMLEFT", mhpb:GetStatusBarTexture(), "TOPLEFT", 0, 0)
		ohpb:SetPoint("BOTTOMRIGHT", mhpb:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
		ohpb:SetOrientation("VERTICAL")
	else
		ohpb:SetPoint("TOPLEFT", mhpb:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
		ohpb:SetPoint("BOTTOMLEFT", mhpb:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
	end
	ohpb:SetStatusBarTexture(C.media.texture)
	ohpb:SetStatusBarColor(0, 1, 0, 0.2)
	ohpb:SetValue(0)
	self.Health.HealingOther = ohpb

	-- Absorb
	local absorb = CreateFrame("StatusBar", nil, self.Health)
	if vertical then
		absorb:SetPoint("BOTTOMLEFT", ohpb:GetStatusBarTexture(), "TOPLEFT", 0, 0)
		absorb:SetPoint("BOTTOMRIGHT", ohpb:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
		absorb:SetOrientation("VERTICAL")
	else
		absorb:SetPoint("TOPLEFT", ohpb:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
		absorb:SetPoint("BOTTOMLEFT", ohpb:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
	end
	absorb:SetStatusBarTexture(C.media.texture)
	absorb:SetStatusBarColor(1, 1, 0, 0.2)
	absorb:SetValue(0)
	self.Health.DamageAbsorb = absorb

	-- From enemy - heal absorb
	local hab = CreateFrame("StatusBar", nil, self.Health)
	if vertical then
		hab:SetPoint("TOPLEFT", self.Health:GetStatusBarTexture(), "TOPLEFT", 0, 0)
		hab:SetPoint("TOPRIGHT", self.Health:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
		hab:SetOrientation("VERTICAL")
	else
		hab:SetPoint("TOPRIGHT", self.Health:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
		hab:SetPoint("BOTTOMRIGHT", self.Health:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
	end
	hab:SetStatusBarTexture(C.media.texture)
	hab:SetStatusBarColor(1, 0, 0, 0.4)
	hab:SetReverseFill(true)
	hab:SetValue(0)
	self.Health.HealAbsorb = hab

	self.Health.incomingHealOverflow = 1

	-- Over absorb in right
	if C.raidframe.plugins_over_absorb then
		local oa = CreateFrame("StatusBar", nil, self.Health)
		oa:SetAllPoints(self.Health)
		oa:SetFrameLevel(self.Health:GetFrameLevel())
		if vertical then
			oa:SetOrientation("VERTICAL")
		end
		oa:SetStatusBarTexture(C.media.blank)
		oa:SetReverseFill(true)
		oa:SetValue(0)

		local texture = oa:GetStatusBarTexture()
		texture:SetTexture([[Interface\AddOns\ShestakUI\Media\Textures\Cross.tga]], "REPEAT", "REPEAT")
		texture:SetVertexColor(0.5, 0.5, 1)
		texture:SetHorizTile(true)
		texture:SetVertTile(true)
		texture:SetAlpha(0.5)
		texture:SetBlendMode("ADD")
		self.Health.OverDamageAbsorbIndicator = oa

		hooksecurefunc(self.Health, "PostUpdate", function(self, unit, _, max)
			local absorb = UnitGetTotalAbsorbs(unit)
			oa:SetMinMaxValues(0, max)
			oa:SetValue(absorb)
		end)
	end

	-- Over heal absorb from enemy in left
	if C.raidframe.plugins_over_heal_absorb then
		local oha = self.Health:CreateTexture(nil, "ARTWORK")
		oha:SetTexture([[Interface\AddOns\ShestakUI\Media\Textures\Cross.tga]], "REPEAT", "REPEAT")
		if vertical then
			oha:SetPoint("BOTTOMLEFT", self.Health, "BOTTOMLEFT", 0, 0)
			oha:SetPoint("BOTTOMRIGHT", self.Health, "BOTTOMRIGHT", 0, 0)
			oha:SetHeight(6)
		else
			oha:SetPoint("TOPLEFT", self.Health, "TOPLEFT", 0, 0)
			oha:SetPoint("BOTTOMLEFT", self.Health, "BOTTOMLEFT", 0, 0)
			oha:SetWidth(6)
		end
		oha:SetVertexColor(1, 0, 0)
		oha:SetHorizTile(true)
		oha:SetVertTile(true)
		oha:SetAlpha(0.4)
		oha:SetBlendMode("ADD")
		self.Health.OverHealAbsorbIndicator = oha
	end
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

T.UpdatePvPStatus = function(self)
	local unit = self.__unit

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

T.DispelColor = function(self)
	local frame = self:CreateAuras()
	frame:SetAllPoints(self.Health)
	frame.disableMouse = true
	frame.disableCooldown = true

	frame.PostCreateButton = function(self, button)
		button.Icon:SetAlpha(0)

		local texture = button:CreateTexture(nil, "OVERLAY")
		texture:SetAllPoints(self)
		texture:SetTexture(C.media.highlight)
		texture:SetBlendMode("ADD")

		button:AddDispelTypeTexture(texture, {
			style = Enum.CustomAuraButtonDispelTypeTextureStyle.PreserveAsset,
			showWhenHarmful = true,
			customDispelColorMap = dispelColor,
		})
	end

	frame:AddGroup("HARMFUL|RAID")
end

T.UnitFrame_OnEnter = function(self)
	if GameTooltip:IsForbidden() then
		self.UpdateTooltip = nil
	else
		_G.GameTooltip_SetDefaultAnchor(GameTooltip, self)

		self.UpdateTooltip = (T.NotSecretValue(self.__unit) and self.__unit and GameTooltip:SetUnit(self.__unit) and T.UnitFrame_OnEnter) or nil
	end
end

local function createAnchors()
	P_BUFF_ICON_Anchor:SetPoint(unpack(C.position.filger.player_buff_icon))
	P_BUFF_ICON_Anchor:SetSize(C.filger.buffs_size, C.filger.buffs_size)

	P_PROC_ICON_Anchor:SetPoint(unpack(C.position.filger.player_proc_icon))
	P_PROC_ICON_Anchor:SetSize(C.filger.buffs_size, C.filger.buffs_size)

	SPECIAL_P_BUFF_ICON_Anchor:SetPoint(unpack(C.position.filger.special_proc_icon))
	SPECIAL_P_BUFF_ICON_Anchor:SetSize(C.filger.buffs_size, C.filger.buffs_size)

	T_DEBUFF_ICON_Anchor:SetPoint(unpack(C.position.filger.target_debuff_icon))
	T_DEBUFF_ICON_Anchor:SetSize(C.filger.buffs_size, C.filger.buffs_size)

	T_CC_Anchor:SetPoint(unpack(C.position.filger.target_buff_icon))
	T_CC_Anchor:SetSize(C.filger.pvp_size, C.filger.pvp_size)

	T_BUFF_Anchor:SetPoint("LEFT", T_CC_Anchor, "LEFT", C.filger.pvp_size + 3, 0)
	T_BUFF_Anchor:SetSize(C.filger.pvp_size, C.filger.pvp_size)

	PVE_PVP_DEBUFF_Anchor:SetPoint(unpack(C.position.filger.pve_debuff))
	PVE_PVP_DEBUFF_Anchor:SetSize(C.filger.pvp_size, C.filger.pvp_size)

	FOCUS_CC_Anchor:SetPoint(unpack(C.position.filger.focus_cc))
	FOCUS_CC_Anchor:SetSize(221, 25)

	local IsPortrait = C.unitframe.portrait_enable and C.unitframe.portrait_type ~= "OVERLAY"

	T_DE_BUFF_BAR_Anchor:SetPoint(C.position.filger.target_bar[1], IsPortrait and "oUF_Target_Portrait" or C.position.filger.target_bar[2], C.position.filger.target_bar[3], IsPortrait and C.position.filger.target_bar[4] - 3 or C.position.filger.target_bar[4], IsPortrait and C.position.filger.target_bar[5] + 38 or C.position.filger.target_bar[5])
	T_DE_BUFF_BAR_Anchor:SetSize(218, 25)

	P_BUFF_BAR_Anchor:SetPoint(C.position.filger.player_bar[1], IsPortrait and "oUF_Player_Portrait" or C.position.filger.player_bar[2], C.position.filger.player_bar[3], IsPortrait and C.position.filger.player_bar[4] + 3 or C.position.filger.player_bar[4], IsPortrait and C.position.filger.player_bar[5] + 38 or C.position.filger.player_bar[5])
	P_BUFF_BAR_Anchor:SetSize(218, 25)

	P_BUFF_ICON_Anchor.done = true
end

T.PostCreateFilgerIcon = function(element, button, options)
	button:SetTemplate("Default")

	T.SkinCooldown(button.Cooldown, options.isBar and "bar" or "actionbar")

	button.Icon:SetPoint("TOPLEFT", 2, -2)
	button.Icon:SetPoint("BOTTOMRIGHT", -2, 2)
	button.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

	button.Count:SetPoint("BOTTOMRIGHT", 1, -2)
	button.Count:SetJustifyH("RIGHT")
	button.Count:SetFont(C.font.cooldown_timers_font, C.font.cooldown_timers_font_size, C.font.cooldown_timers_font_style)
	button.Count:SetShadowOffset(C.font.cooldown_timers_font_shadow and 1 or 0, C.font.cooldown_timers_font_shadow and -1 or 0)

	button.Cooldown:SetReverse(true)
	button.Cooldown:SetPoint("TOPLEFT", button, "TOPLEFT", 2, -2)
	button.Cooldown:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
	button.Cooldown:SetSwipeColor(0, 0, 0, 0.6)
	button.Cooldown:SetDrawEdge(false)

	SpellActivationOverlayFrame:SetFrameStrata("BACKGROUND")

	if options.isBar then
		local statusBar = CreateFrame("StatusBar", "nil", button)
		statusBar:SetWidth(options.isFocus and 189 or 186)
		statusBar:SetHeight(button:GetHeight() - 10)
		statusBar:SetStatusBarTexture(C.media.texture)
		statusBar:SetStatusBarColor(T.color.r, T.color.g, T.color.b, 1)
		statusBar:SetPoint("BOTTOMLEFT", button, "BOTTOMRIGHT", 5, 2)
		statusBar:SetFillStyle(Enum.StatusBarFillStyle.StandardNoRangeFill)

		statusBar.bg = CreateFrame("Frame", "$parentBG", statusBar)
		statusBar.bg:SetAllPoints()
		statusBar.bg:CreateBackdrop("Default")

		statusBar.background = statusBar:CreateTexture(nil, "BACKGROUND")
		statusBar.background:SetAllPoints()
		statusBar.background:SetTexture(C.media.texture)
		statusBar.background:SetVertexColor(T.color.r, T.color.g, T.color.b, 0.2)

		button:SetDurationBar(statusBar, {
			interpolation = Enum.StatusBarInterpolation.ExponentialEaseOut,
			direction = Enum.StatusBarTimerDirection.RemainingTime
		})

		button.Count:SetFont(C.font.filger_font, C.font.filger_font_size, C.font.filger_font_style)
		button.Count:SetShadowOffset(C.font.filger_font_shadow and 1 or 0, C.font.filger_font_shadow and -1 or 0)
		button.Count:SetPoint("BOTTOMRIGHT", 1, 0)

		button.Cooldown:SetSwipeColor(0, 0, 0, 0)

		local text = button.Cooldown.text
		text:ClearAllPoints()
		text:SetPoint("RIGHT", statusBar, 0, 0)

		statusBar.spellname = statusBar:CreateFontString("$parentSpellName", "OVERLAY")
		statusBar.spellname:SetFont(C.font.filger_font, C.font.filger_font_size, C.font.filger_font_style)
		statusBar.spellname:SetShadowOffset(C.font.filger_font_shadow and 1 or 0, C.font.filger_font_shadow and -1 or 0)
		statusBar.spellname:SetPoint("LEFT", statusBar, 2, 0)
		statusBar.spellname:SetPoint("RIGHT", text, "LEFT")
		statusBar.spellname:SetJustifyH("LEFT")

		button:SetSpellName(statusBar.spellname)
	end
end

T.CreateFilgerAuras = function(self, unit)
	if not P_BUFF_ICON_Anchor.done then
		createAnchors()
	end
	if unit == "player" then
		-- if C.filger.show_pvp_player then
			-- -- Crowd controls
			-- self.CCDebuffs = self:CreateAuras({
				-- growthX = "LEFT",
				-- growthY = "UP",
				-- layoutLimit = C.filger.pvp_size + C.filger.pvp_space,
				-- initialAnchor = "TOPRIGHT"
			-- })
			-- self.CCDebuffs.size = C.filger.pvp_size
			-- self.CCDebuffs.showCount = true
			-- self.CCDebuffs.elementSpacing = C.filger.pvp_space
			-- self.CCDebuffs.sortDirection = AuraContainerSortDirection.Reverse
			-- self.CCDebuffs.PostCreateButton = T.PostCreateFilgerIcon
			-- self.CCDebuffs:SetPoint("TOPRIGHT", PVE_PVP_DEBUFF_Anchor)
			-- self.CCDebuffs.tooltipAnchor = "ANCHOR_TOPRIGHT"
			-- self.CCDebuffs.tooltipOffsetY = 3
			-- self.CCDebuffs.disableMouse = not C.filger.show_tooltip

			-- self.CCDebuffs:AddGroup("HARMFUL|CROWD_CONTROL", {
				-- maxFrameCount = 2,
			-- })
		-- end
		if C.filger.show_special then
			-- Special buffs on player
			self.SBuffs = self:CreateAuras({
				growthX = "LEFT",
				growthY = "UP",
				initialAnchor = "TOPRIGHT"
			})
			self.SBuffs.size = C.filger.buffs_size
			self.SBuffs.showCount = true
			self.SBuffs.elementSpacing = C.filger.buffs_space
			self.SBuffs.sortDirection = AuraContainerSortDirection.Reverse
			self.SBuffs.PostCreateButton = T.PostCreateFilgerIcon
			self.SBuffs:SetPoint("TOPRIGHT", SPECIAL_P_BUFF_ICON_Anchor)
			self.SBuffs.tooltipAnchor = "ANCHOR_TOPRIGHT"
			self.SBuffs.tooltipOffsetY = 3
			self.SBuffs.disableMouse = not C.filger.show_tooltip

			self.SBuffs:AddGroup("HELPFUL|!BIG_DEFENSIVE|!EXTERNAL_DEFENSIVE", {
				maxFrameCount = 2,
				candidateFilters = {includeSpellIDs = T.Filger_S_P_BUFF},
			})
			self.SBuffs:AddGroup("HELPFUL|BIG_DEFENSIVE|!EXTERNAL_DEFENSIVE", {
				maxFrameCount = 2,
			})
			self.SBuffs:AddGroup("HELPFUL|EXTERNAL_DEFENSIVE", {
				maxFrameCount = 1,
			})
		end
		if C.filger.show_buff then
			-- Player buffs
			self.PBuffs = self:CreateAuras({
				growthX = "LEFT",
				growthY = "UP",
				initialAnchor = "TOPRIGHT"
			})
			self.PBuffs.size = C.filger.buffs_size
			self.PBuffs.showCount = true
			self.PBuffs.elementSpacing = C.filger.buffs_space
			self.PBuffs.sortDirection = AuraContainerSortDirection.Reverse
			self.PBuffs.PostCreateButton = T.PostCreateFilgerIcon
			self.PBuffs:SetPoint("TOPRIGHT", P_BUFF_ICON_Anchor)
			self.PBuffs.tooltipAnchor = "ANCHOR_TOPRIGHT"
			self.PBuffs.tooltipOffsetY = 3
			self.PBuffs.disableMouse = not C.filger.show_tooltip

			self.PBuffs:AddGroup("HELPFUL|PLAYER|!BIG_DEFENSIVE", {
				candidateFilters = {includeSpellIDs = T.Filger_P_BUFF},
			})
		end
		if C.filger.show_proc then
			-- Player's Proc
			self.PProc = self:CreateAuras({
				growthX = "RIGHT",
				growthY = "UP",
			})
			self.PProc.size = C.filger.buffs_size
			self.PProc.showCount = true
			self.PProc.elementSpacing = C.filger.buffs_space
			self.PProc.sortDirection = AuraContainerSortDirection.Reverse
			self.PProc.PostCreateButton = T.PostCreateFilgerIcon
			self.PProc:SetPoint("TOPLEFT", P_PROC_ICON_Anchor)
			self.PProc.tooltipAnchor = "ANCHOR_TOPLEFT"
			self.PProc.tooltipOffsetY = 3
			self.PProc.disableMouse = not C.filger.show_tooltip

			self.PProc:AddGroup("HELPFUL|PLAYER", {
				candidateFilters = {includeSpellIDs = T.Filger_P_PROC},
			})
		end
	elseif unit == "target" then
		if C.filger.show_pvp_target then
			-- Crowd controls
			self.CCDebuffsT = self:CreateAuras({
				growthX = "RIGHT",
				growthY = "UP",
				layoutLimit = C.filger.pvp_size + C.filger.pvp_space,
			})
			self.CCDebuffsT.size = C.filger.pvp_size
			self.CCDebuffsT.showCount = true
			self.CCDebuffsT.elementSpacing = C.filger.pvp_space
			self.CCDebuffsT.sortDirection = AuraContainerSortDirection.Reverse
			self.CCDebuffsT.PostCreateButton = T.PostCreateFilgerIcon
			self.CCDebuffsT:SetPoint("TOPLEFT", T_CC_Anchor)
			self.CCDebuffsT.tooltipAnchor = "ANCHOR_TOPLEFT"
			self.CCDebuffsT.tooltipOffsetY = 3
			self.CCDebuffsT.disableMouse = not C.filger.show_tooltip

			self.CCDebuffsT:AddGroup("HARMFUL|CROWD_CONTROL", {
				maxFrameCount = 2,
			})
		end
		if C.filger.show_pvp_target then
			-- Defensive spells on target
			self.TBuffs = self:CreateAuras({
				growthX = "RIGHT",
				growthY = "UP",
				layoutLimit = C.filger.pvp_size + C.filger.pvp_space,
			})
			self.TBuffs.size = C.filger.pvp_size
			self.TBuffs.showCount = true
			self.TBuffs.elementSpacing = C.filger.pvp_space
			self.TBuffs.sortDirection = AuraContainerSortDirection.Reverse
			self.TBuffs.PostCreateButton = T.PostCreateFilgerIcon
			self.TBuffs:SetPoint("TOPLEFT", T_BUFF_Anchor)
			self.TBuffs.tooltipAnchor = "ANCHOR_TOPLEFT"
			self.TBuffs.tooltipOffsetY = 3
			self.TBuffs.disableMouse = not C.filger.show_tooltip

			self.TBuffs:AddGroup("HELPFUL|BIG_DEFENSIVE|!EXTERNAL_DEFENSIVE", {
				maxFrameCount = 1,
			})
			self.TBuffs:AddGroup("HELPFUL|EXTERNAL_DEFENSIVE", {
				maxFrameCount = 1,
			})
		end
		if C.filger.show_debuff then
			-- Player's Debuffs on target
			self.PDebuffs = self:CreateAuras({
				growthX = "RIGHT",
				growthY = "UP",
			})
			self.PDebuffs.size = C.filger.buffs_size
			self.PDebuffs.showCount = true
			self.PDebuffs.elementSpacing = C.filger.buffs_space
			self.PDebuffs.sortDirection = AuraContainerSortDirection.Reverse
			self.PDebuffs.PostCreateButton = T.PostCreateFilgerIcon
			self.PDebuffs:SetPoint("TOPLEFT", T_DEBUFF_ICON_Anchor)
			self.PDebuffs.tooltipAnchor = "ANCHOR_TOPLEFT"
			self.PDebuffs.tooltipOffsetY = 3
			self.PDebuffs.disableMouse = not C.filger.show_tooltip

			self.PDebuffs:AddGroup("HARMFUL|PLAYER|!CROWD_CONTROL", {
				maxFrameCount = 6,
				candidateFilters = {includeSpellIDs = T.Filger_T_DEBUFF},
			})
		end
		if C.filger.show_aura_bar then
			-- Player's Debuffs bar on target
			self.BarDebuffs = self:CreateAuras({
				growthX = "RIGHT",
				growthY = "UP",
				layoutLimit = 28,
				initialAnchor = "BOTTOMLEFT"
			})
			self.BarDebuffs.size = 25
			self.BarDebuffs.showCount = true
			self.BarDebuffs.lineSpacing = C.filger.buffs_space
			self.BarDebuffs.sortDirection = AuraContainerSortDirection.Reverse
			self.BarDebuffs.PostCreateButton = T.PostCreateFilgerIcon
			self.BarDebuffs:SetPoint("BOTTOMLEFT", T_DE_BUFF_BAR_Anchor)
			self.BarDebuffs.tooltipAnchor = "ANCHOR_TOPLEFT"
			self.BarDebuffs.tooltipOffsetY = 3
			self.BarDebuffs.disableMouse = not C.filger.show_tooltip

			self.BarDebuffs:AddGroup("HARMFUL|PLAYER", {
				isBar = true,
				maxFrameCount = 6,
				candidateFilters = {includeSpellIDs = T.Filger_T_BAR},
			})

			self.BarDebuffs:AddGroup("HELPFUL|PLAYER", {
				isBar = true,
				maxFrameCount = 6,
				candidateFilters = {includeSpellIDs = T.Filger_T_BAR},
			})
		end
	elseif unit == "focus" then
		if C.filger.show_aura_bar then
			-- CC Debuffs bar on focus
			self.CCBarDebuffs = self:CreateAuras({
				growthX = "RIGHT",
				growthY = "UP",
				layoutLimit = 28,
				initialAnchor = "BOTTOMLEFT"
			})
			self.CCBarDebuffs.size = 25
			self.CCBarDebuffs.showCount = true
			self.CCBarDebuffs.lineSpacing = C.filger.buffs_space
			self.CCBarDebuffs.sortDirection = AuraContainerSortDirection.Reverse
			self.CCBarDebuffs.PostCreateButton = T.PostCreateFilgerIcon
			self.CCBarDebuffs:SetPoint("BOTTOMLEFT", FOCUS_CC_Anchor)
			self.CCBarDebuffs.tooltipAnchor = "ANCHOR_TOPLEFT"
			self.CCBarDebuffs.tooltipOffsetY = 3
			self.CCBarDebuffs.disableMouse = not C.filger.show_tooltip

			self.CCBarDebuffs:AddGroup("HARMFUL|CROWD_CONTROL", {
				isBar = true,
				isFocus = true,
				maxFrameCount = 1,
			})
		end
	end
end
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

local low_mana = C_CurveUtil.CreateColorCurve()
low_mana:SetType(Enum.LuaCurveType.Step)
low_mana:AddPoint(0, CreateColor(1, 1, 1, 1))
low_mana:AddPoint(0.2, CreateColor(1, 1, 1, 0))

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
			local color = UnitPowerPercent("player", 0, true, low_mana)
			local _, _, _, alpha = color:GetRGBA()
			self.ManaLevel:SetText("|cffaf5050"..MANA_LOW.."|r")
			self.ManaLevel:SetAlpha(alpha)
		end
	elseif T.class ~= "DRUID" and T.class ~= "PRIEST" and T.class ~= "SHAMAN" then
		self.ManaLevel:SetText()
		StopFlash(self)
	end
end

local full_mana = C_CurveUtil.CreateColorCurve()
full_mana:AddPoint(0.99, CreateColor(1, 1, 1, 1))
full_mana:AddPoint(1, CreateColor(1, 1, 1, 0))

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
			local color = UnitPowerPercent("player", 0, true, low_mana)
			local _, _, _, alpha = color:GetRGBA()
			self.FlashInfo.ManaLevel:SetText("|cffaf5050"..MANA_LOW.."|r")
			self.FlashInfo.ManaLevel:SetAlpha(alpha)

			local color = UnitPowerPercent("player", 0, true, full_mana)
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
	local elapsed = durationObject:GetElapsedDuration()
	local total = durationObject:GetTotalDuration()

	self.Time:SetText(("%.1f / %.1f"):format(self.channeling and duration or elapsed, total))
end

T.CustomCastDelayText = function(self, durationObject)
	local duration = durationObject:GetRemainingDuration()
	local elapsed = durationObject:GetElapsedDuration()

	self.Time:SetText(("%.1f |cffaf5050%s %.1f|r"):format(self.channeling and duration or elapsed, self.channeling and "-" or "+", abs(self.delay)))
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

	T.SkinCooldown(button.Cooldown, "aura")

	button.Icon:SetPoint("TOPLEFT", 2, -2)
	button.Icon:SetPoint("BOTTOMRIGHT", -2, 2)
	button.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

	button.Count:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 1, 0)
	button.Count:SetJustifyH("RIGHT")
	button.Count:SetFont(C.font.auras_font, C.font.auras_font_size, C.font.auras_font_style)
	button.Count:SetShadowOffset(C.font.auras_font_shadow and 1 or 0, C.font.auras_font_shadow and -1 or 0)

	if C.aura.show_spiral then
		button.Cooldown:SetReverse(true)
		button.Cooldown:SetPoint("TOPLEFT", button, "TOPLEFT", 2, -2)
		button.Cooldown:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
		button.parent = CreateFrame("Frame", nil, button)
		button.parent:SetFrameLevel(button.Cooldown:GetFrameLevel() + 1)
		button.Count:SetParent(button.parent)
	else
		button.Cooldown:SetAlpha(0)
	end
end

local dispelIndex = {
	[0] = CreateColor(1, 0, 0),			-- None
	[1] = CreateColor(0.2, 0.6, 1),		-- Magic
	[2] = CreateColor(0.6, 0, 1),		-- Curse
	[3] = CreateColor(0.6, 0.4, 0),		-- Disease
	[4] = CreateColor(0, 0.6, 0),		-- Poison
	[9] = CreateColor(0.95, 0.4, 0.95),	-- Enrage
	[11] = CreateColor(1, 0, 0.5)		-- Bleed
}

local curve = C_CurveUtil.CreateColorCurve()
curve:SetType(Enum.LuaCurveType.Step)
for i, color in pairs(dispelIndex) do
	curve:AddPoint(i, color)
end
T.DispelCurve = curve

T.PostUpdateIcon = function(element, button, unit, data)
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

T.PostUpdateGapButton = function(_, _, button)
	button:Hide()
end

T.CreateRaidBuffIcon = function(element, button)
	if not C.raidframe.plugins_buffs_timer then
		button.Cooldown:SetHideCountdownNumbers(true)
	end
	T.SkinCooldown(button.Cooldown, "aura")

	button:CreateBorder(nil, true)
	button.oborder:SetOutside(button.Icon, 1, 1)

	button.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

	button.Count:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 4, -1)
	button.Count:SetJustifyH("RIGHT")
	button.Count:SetFont(C.font.unit_frames_font, C.font.unit_frames_font_size, C.font.unit_frames_font_style)
	button.Count:SetShadowOffset(C.font.auras_font_shadow and 1 or 0, C.font.auras_font_shadow and -1 or 0)

	if C.aura.show_spiral then
		button.Cooldown:SetReverse(true)
		button.parent = CreateFrame("Frame", nil, button)
		button.parent:SetFrameLevel(button.Cooldown:GetFrameLevel() + 1)
		button.Count:SetParent(button.parent)
	else
		button.Cooldown:SetAlpha(0)
	end
end

T.PostUpdateRaidButton = function(element, button, unit, data)
	if C.aura.debuff_color_type then
		local color = C_UnitAuras.GetAuraDispelTypeColor(unit, data.auraInstanceID, T.DispelCurve)
		if color then
			button:SetBackdropBorderColor(color:GetRGBA())
		end
	else
		button:SetBackdropBorderColor(1, 0, 0)
	end

	if not C.aura.plugins_aura_watch_timer then
		button.Cooldown:SetHideCountdownNumbers(true)
	end
end

-- local CountOffSets = {
	-- TOPLEFT = {"LEFT", "RIGHT", 1, 0},
	-- TOPRIGHT = {"RIGHT", "LEFT", 2, 0},
	-- BOTTOMLEFT = {"LEFT", "RIGHT", 1, 0},
	-- BOTTOMRIGHT = {"RIGHT", "LEFT", 2, 0},
	-- LEFT = {"LEFT", "RIGHT", 1, 0},
	-- RIGHT = {"RIGHT", "LEFT", 2, 0},
	-- TOP = {"RIGHT", "LEFT", 2, 0},
	-- BOTTOM = {"RIGHT", "LEFT", 2, 0},
-- }

-- T.CreateAuraWatchIcon = function(_, aura)
	-- aura:CreateBorder(nil, true)
	-- aura.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	-- aura.icon:SetDrawLayer("ARTWORK")
	-- if aura.cd then
		-- aura.cd:SetReverse(true)
		-- aura.cd:SetHideCountdownNumbers(true)
		-- if C.raidframe.plugins_buffs_timer then
			-- aura.parent = CreateFrame("Frame", nil, aura)
			-- aura.parent:SetFrameLevel(aura.cd:GetFrameLevel() + 1)
			-- aura.remaining = T.SetFontString(aura.parent, C.font.auras_font, C.font.auras_font_size, C.font.auras_font_style)
			-- aura.remaining:SetShadowOffset(C.font.auras_font_shadow and 1 or 0, C.font.auras_font_shadow and -1 or 0)
			-- aura.remaining:SetPoint("CENTER", aura, "CENTER", 1, 0)
			-- aura.remaining:SetJustifyH("CENTER")
		-- end
	-- end
-- end

-- T.CreateAuraWatch = function(self)
	-- local auras = CreateFrame("Frame", nil, self)
	-- auras:SetPoint("TOPLEFT", self.Health, 0, 0)
	-- auras:SetPoint("BOTTOMRIGHT", self.Health, 0, 0)
	-- auras.icons = {}
	-- auras.PostCreateIcon = T.CreateAuraWatchIcon

	-- if not C.aura.show_timer then
		-- auras.hideCooldown = true
	-- end

	-- local buffs = {}

	-- if T.RaidBuffs["ALL"] then
		-- for _, value in pairs(T.RaidBuffs["ALL"]) do
			-- tinsert(buffs, value)
		-- end
	-- end

	-- if T.RaidBuffs[T.class] then
		-- for _, value in pairs(T.RaidBuffs[T.class]) do
			-- tinsert(buffs, value)
		-- end
	-- end

	-- if buffs then
		-- for _, spell in pairs(buffs) do
			-- local aura = CreateFrame("Frame", nil, auras)
			-- aura.spellID = spell[1]
			-- aura.anyUnit = spell[4]
			-- aura.strictMatching = spell[5]
			-- aura:SetSize(7 * C.raidframe.icon_multiplier, 7 * C.raidframe.icon_multiplier)
			-- aura:SetPoint(spell[2], 0, 0)

			-- local tex = aura:CreateTexture(nil, "OVERLAY")
			-- tex:SetAllPoints(aura)
			-- tex:SetTexture(C.media.blank)
			-- if spell[3] then
				-- tex:SetVertexColor(unpack(spell[3]))
			-- else
				-- tex:SetVertexColor(0.8, 0.8, 0.8)
			-- end
			-- aura.icon = tex

			-- local count = T.SetFontString(aura, C.font.unit_frames_font, C.font.unit_frames_font_size, C.font.unit_frames_font_style)
			-- local point, anchorPoint, x, y = unpack(CountOffSets[spell[2]])
			-- count:SetPoint(point, aura, anchorPoint, x, y)
			-- aura.count = count

			-- auras.icons[spell[1]] = aura
		-- end
	-- end

	-- self.AuraWatch = auras
-- end

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
		if data.isPlayerAura then
		-- if data.isPlayerAura or UnitIsUnit(unit, data.sourceUnit) then
		-- if (data.isPlayerAura or data.sourceUnit == unit) then
			-- if (T.DebuffBlackList and not T.DebuffBlackList[data.name]) or not T.DebuffBlackList then -- BETA secret value
				return true
			-- end
		end
		return false
	end
	return true
end
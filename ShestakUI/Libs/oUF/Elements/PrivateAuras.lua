local _, ns = ...
local oUF = ns.oUF

local function CreateAura(element, index)
	-- similar to BuffFramePrivateAuraAnchorTemplate
	local aura = CreateFrame('Frame', nil, element)

	-- each sub-widget just acts as anchor points (frames) and cannot be used to customize things
	-- like texture coordinates or font size
	local icon = CreateFrame('Frame', nil, aura)
	icon:SetAllPoints()
	aura.Icon = icon

	--[[ Callback: PrivateAuras:PostCreateAura(aura, auraIndex)
	Called after a private aura anchor frame has been created.

	* self      - the PrivateAuras element
	* aura      - the private aura anchor frame to be positioned
	* auraIndex - the index of the private aura anchor frame
	--]]
	if(element.PostCreateAura) then element:PostCreateAura(aura, index) end

	return aura
end

local function SetPosition(element, aura, auraIndex)
	-- more or less copied straight from Auras
	local width = element.width or element.size or 16
	local height = element.height or element.size or 16
	local sizeX = width + (element.spacingX or element.spacing or 0)
	local sizeY = height + (element.spacingY or element.spacing or 0)
	local anchor = element.initialAnchor or 'BOTTOMLEFT'
	local growthX = (element.growthX == 'LEFT' and -1) or 1
	local growthY = (element.growthY == 'DOWN' and -1) or 1
	local cols = element.maxCols or math.floor(element:GetWidth() / sizeX + 0.5)

	local col = (auraIndex - 1) % cols
	local row = math.floor((auraIndex - 1) / cols)

	aura:ClearAllPoints()
	aura:SetPoint(anchor, element, anchor, col * sizeX * growthX, row * sizeY * growthY)
end

local function resetAnchors(element)
	for _, anchor in next, element.anchors do
		C_UnitAuras.RemovePrivateAuraAnchor(anchor)
	end

	table.wipe(element.anchors)
end

local function Update(self)
	local element = self.PrivateAuras
	if(element.anchors) then
		resetAnchors(element)
	else
		element.anchors = {}
	end

	for index = 1, (element.num or 6) do -- 5 or 6 is what Blizzard creates, so we default to that
		local aura = element[index]
		if(not aura) then
			--[[ Override: PrivateAuras:CreateAura(auraIndex)
			Used to completely override the internal function for creating private aura anchor frames.

			* self      - the PrivateAuras element
			* auraIndex - the index of the private aura anchor frame
			--]]
			aura = (element.CreateAura or CreateAura) (element, index)
			table.insert(element, aura)
		end

		aura:SetSize(element.width or element.size or 16, element.height or element.size or 16)

		--[[ Override: PrivateAuras:SetPosition(aura, auraIndex)
		Used to completely override the internal function for (re-)positioning private aura anchor
		frames. Called when new auras have been created.

		* self      - the PrivateAuras element
		* aura      - the private aura anchor frame to be positioned
		* auraIndex - the index of the private aura anchor frame
		--]]
		do
			(element.SetPosition or SetPosition) (element, aura, index)
		end

		table.insert(element.anchors, C_UnitAuras.AddPrivateAuraAnchor({
			unitToken = element.__owner.unit,
			auraIndex = index,
			parent = aura,
			showCountdownFrame = not element.disableCooldown,
			showCountdownNumbers = not element.disableCooldownText,
			iconInfo = {
				iconWidth = aura:GetWidth(),
				iconHeight = aura:GetHeight(),
				iconAnchor = {
					-- we anchor to sub-widgets of each "aura" frame to make it easier to move
					-- after-the-fact
					point = 'CENTER',
					relativeTo = aura.Icon,
					relativePoint = 'CENTER',
					offsetX = 0,
					offsetY = 0,
				},
				borderScale = element.borderScale,
			},
		}))
	end

	--[[ Callback: PrivateAuras:PostUpdate()
	Called after the element has been updated.

	* self - the PrivateAuras element
	--]]
	if(element.PostUpdate) then element:PostUpdate() end
end

local function Path(self, ...)
	--[[ Override: PrivateAuras:Override()
	Used to completely override the internal function for creating, positioning and registering
	all private auras.

	* self - the PrivateAuras element
	--]]
	do
		(self.PrivateAuras.Override or Update) (self, ...)
	end
end

local function ForceUpdate(element)
	return Path(element.__owner)
end

local function Disable(self)
	local element = self.PrivateAuras
	if(element and element.anchors) then
		resetAnchors(element)
	end
end

local function Enable(self, unit)
	if(self.unit ~= 'player' and not self.unit:match('raid%d?$') and not self.unit:match('party%d?$')) then
		Disable(self)

		return false
	end

	local element = self.PrivateAuras
	if(element) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		return true
	end
end

oUF:AddElement('PrivateAuras', Path, Enable, Disable)
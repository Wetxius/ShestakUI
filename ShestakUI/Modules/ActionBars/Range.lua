local T, C, L = unpack(ShestakUI)
if C_AddOns.IsAddOnLoaded("tullaRange") then return end
if C.actionbar.enable ~= true then return end

----------------------------------------------------------------------------------------
--	Out of range check(tullaRange by Tuller)
----------------------------------------------------------------------------------------
local AddonName, Addon = ...

Addon.frame = CreateFrame("Frame", nil, SettingsPanel or InterfaceOptionsFrame)
Addon.frame.owner = Addon

local flashAnimations = {}

local function startFlashing(button)
	local animation = flashAnimations[button]

	if not animation then
		animation = button.Flash:CreateAnimationGroup()
		animation:SetLooping("BOUNCE")

		local alpha = animation:CreateAnimation("ALPHA")
		alpha:SetDuration(Addon:GetFlashDuration())
		alpha:SetFromAlpha(0)
		alpha:SetToAlpha(0.7)
		alpha.owner = button

		flashAnimations[button] = animation
	end

	button.Flash:Show()
	animation:Play()
end

local function stopFlashing(button)
	local animation = flashAnimations[button]

	if animation then
		animation:Stop()
		button.Flash:Hide()
	end
end

function Addon.StartAttackAnimation(button)
	if button:IsVisible() then
		startFlashing(button)
	end
end

function Addon.UpdateAttackAnimation(button)
	if (button.flashing == 1 or button.flashing == true) and button:IsVisible() then
		startFlashing(button)
	else
		stopFlashing(button)
	end
end

local function isUsuableAction(slot)
	local actionType, id = GetActionInfo(slot)

	if actionType == "macro" then
		-- for macros with names that start with a #, we prioritize the OOM
		-- check using a spell cost strategy over other ones to better
		-- clarify if the macro is actually usable or not
		local name = GetMacroInfo(id)

		if name and name:sub(1, 1) == "#" then
			local spellID = GetMacroSpell(id)

			-- only run the check for spell macros
			if spellID then
				local costs = C_Spell.GetSpellPowerCost(spellID)
				if costs then
					for i = 1, #costs do
						local cost = costs[i]

						if UnitPower("player", cost.type) < cost.minCost then
							return false, false
						end
					end
				end
			end
		end
	end

	return IsUsableAction(slot)
end

function Addon.GetActionState(slot)
	local usable, oom = isUsuableAction(slot)
	local oor = IsActionInRange(slot) == false

	return usable and not oor, oom, oor
end

function Addon.GetPetActionState(slot)
	local _, _, _, _, _, _, spellID, checksRange, inRange = GetPetActionInfo(slot)
	local oor = checksRange and not inRange

	if spellID then
		local _, oom = C_Spell.IsSpellUsable(spellID)
		if oom then
			return false, oom, oor
		end
	end

	return (not oor) and GetPetActionSlotUsable(slot), false, oor
end

local states = {}
local registered = {}

--------------------------------------------------------------------------------
-- action button coloring
--------------------------------------------------------------------------------

local function actionButton_UpdateColor(button)
	local usable, oom, oor = Addon.GetActionState(button.action)

	-- icon coloring
	local iconState
	if usable then
		iconState = "normal"
	elseif oom then
		iconState = "oom"
	elseif oor then
		iconState = "oor"
	else
		iconState = "unusable"
	end

	local icon = button.icon
	do
		states[icon] = iconState

		local color = Addon.sets[iconState]
		icon:SetVertexColor(color[1], color[2], color[3], color[4])
		icon:SetDesaturated(color.desaturate)
	end

	-- hotkey coloring
	local hotkeyState
	if oor then
		hotkeyState = "oor"
	else
		hotkeyState = "normal"
	end

	local hotkey = button.HotKey
	do
		states[hotkey] = hotkeyState

		local color = Addon.sets[hotkeyState]
		button.HotKey:SetVertexColor(color[1], color[2], color[3])
	end
end

local function registerActionButton(button)
	if registered[button] then return end

	hooksecurefunc(button, "UpdateUsable", actionButton_UpdateColor)

	if Addon:HandleAttackAnimations() then
		button:HookScript("OnShow", Addon.UpdateAttackAnimation)
		button:HookScript("OnHide", Addon.UpdateAttackAnimation)
		hooksecurefunc(button, "StartFlash", Addon.StartAttackAnimation)
	end

	registered[button] = true
end

--------------------------------------------------------------------------------
-- pet action button coloring
-- This, unfortunately, still requires polling
--------------------------------------------------------------------------------

local watchedPetButtons = {}

-- update pet actions
local function update()
	local getPetActionState = Addon.GetPetActionState
	local colors = Addon.sets

	for button in pairs(watchedPetButtons) do
		local usable, oom, oor = getPetActionState(button:GetID())

		local iconState
		if usable then
			iconState = "normal"
		elseif oom then
			iconState = "oom"
		elseif oor then
			iconState = "oor"
		else
			iconState = "unusable"
		end

		local icon = button.icon
		if states[icon] ~= iconState then
			states[icon] = iconState

			local color = colors[iconState]
			icon:SetVertexColor(color[1], color[2], color[3], color[4])
			icon:SetDesaturated(color.desaturate)
		end

		local hotkeyState
		if oor then
			hotkeyState = "oor"
		else
			hotkeyState = "normal"
		end

		local hotkey = button.HotKey
		if states[hotkey] ~= hotkeyState then
			states[hotkey] = hotkeyState

			local color = colors[hotkeyState]
			hotkey:SetVertexColor(color[1], color[2], color[3])
		end
	end
end

local ticker = nil
local function updatePetRangeChecker()
	if next(watchedPetButtons) then
		if not ticker then
			ticker = C_Timer.NewTicker(Addon:GetUpdateDelay(), update)
		end
	elseif ticker then
		ticker:Cancel()
		ticker = nil
	end
end

-- returns true if the given pet action button should be watched (due to having
-- a range component and being visible) and false otherwise
local function shouldWatchPetAction(button)
	if button:IsVisible() then
		local _, _, _, _, _, _, _, hasRange = GetPetActionInfo(button:GetID())
		return hasRange
	end

	return false
end

local function petButton_UpdateColor(button)
	local usable, oom, oor = Addon.GetPetActionState(button:GetID())

	local iconState
	if usable then
		iconState = "normal"
	elseif oom then
		iconState = "oom"
	elseif oor then
		iconState = "oor"
	else
		iconState = "unusable"
	end

	local icon = button.icon
	do
		states[icon] = iconState

		local color = Addon.sets[iconState]
		icon:SetVertexColor(color[1], color[2], color[3], color[4])
		icon:SetDesaturated(color.desaturate)
	end

	local hotkeyState
	if oor then
		hotkeyState = "oor"
	else
		hotkeyState = "normal"
	end

	local hotkey = button.HotKey
	do
		states[hotkey] = hotkeyState

		local color = Addon.sets[hotkeyState]
		button.HotKey:SetVertexColor(color[1], color[2], color[3])
	end
end

local function petButton_UpdateWatched(button)
	local state = shouldWatchPetAction(button) or nil

	if state ~= watchedPetButtons[button] then
		watchedPetButtons[button] = state
		updatePetRangeChecker()
	end
end

local function registerPetButton(button)
	if registered[button] then return end

	button:SetScript("OnUpdate", nil)
	button:HookScript("OnShow", petButton_UpdateWatched)
	button:HookScript("OnHide", petButton_UpdateWatched)

	if Addon:HandleAttackAnimations() then
		hooksecurefunc(button, "StartFlash", Addon.StartAttackAnimation)
		button:HookScript("OnShow", Addon.UpdateAttackAnimation)
		button:HookScript("OnHide", Addon.UpdateAttackAnimation)
	end

	registered[button] = true
end

--------------------------------------------------------------------------------
-- engine implementation
--------------------------------------------------------------------------------
function Addon:Enable()
	-- register known action buttons
	for _, button in pairs(ActionBarButtonEventsFrame.frames) do
		registerActionButton(button)
	end

	-- and watch for any additional action buttons
	hooksecurefunc(ActionBarButtonEventsFrame, "RegisterFrame", function(_, button)
		registerActionButton(button)
	end)

	-- disable the ActionBarButtonUpdateFrame OnUpdate handler (unneeded)
	ActionBarButtonUpdateFrame:SetScript("OnUpdate", nil)

	-- watch for range event updates
	self.frame:RegisterEvent("ACTION_RANGE_CHECK_UPDATE")

	if self:HandlePetActions() then
		-- register all pet action buttons
		for _, button in pairs(PetActionBar.actionButtons) do
			registerPetButton(button)
		end

		hooksecurefunc(PetActionBar, "Update", function(bar)
			-- reset the timer on update, so that we don't trigger the bar's
			-- own range updater code
			bar.rangeTimer = nil

			-- if we have a bar, update all the actions
			if PetHasActionBar() then
				for _, button in pairs(bar.actionButtons) do
					if button.icon:IsVisible() then
						petButton_UpdateColor(button)
					end

					petButton_UpdateWatched(button)
				end
			else
				wipe(watchedPetButtons)
				updatePetRangeChecker()
			end
		end)
	end
end

function Addon:RequestUpdate()
	for _, buttons in pairs(ActionBarButtonRangeCheckFrame.actions) do
		for _, button in pairs(buttons) do
			if button:IsVisible() then
				actionButton_UpdateColor(button)
			end
		end
	end

	for _, button in pairs(PetActionBar.actionButtons) do
		if button:IsVisible() then
			petButton_UpdateColor(button)
		end
	end
end

function Addon:ACTION_RANGE_CHECK_UPDATE(_, slot, isInRange, checksRange)
	local buttons = ActionBarButtonRangeCheckFrame.actions[slot]
	if not buttons then
		return
	end

	local oor = checksRange and not isInRange
	if oor then
		local newState = "oor"
		local color = Addon.sets[newState]

		for _, button in pairs(buttons) do
			local icon = button.icon
			if states[icon] ~= newState then
				states[icon] = newState

				icon:SetVertexColor(color[1], color[2], color[3], color[4])
				icon:SetDesaturated(color.desaturate)
			end

			local hotkey = button.HotKey
			if states[hotkey] == newState then
				states[hotkey] = newState
				hotkey:SetVertexColor(color[1], color[2], color[3])
			end
		end
	else
		local oldState = "oor"

		for _, button in pairs(buttons) do
			local icon = button.icon
			if states[icon] == oldState then
				local usable, oom = Addon.GetActionState(button.action)

				local newState
				if usable then
					newState = "normal"
				elseif oom then
					newState = "oom"
				else
					newState = "unusable"
				end

				states[icon] = newState

				local color = Addon.sets[newState]
				icon:SetVertexColor(color[1], color[2], color[3], color[4])
				icon:SetDesaturated(color.desaturate)
			end

			local hotkey = button.HotKey
			if states[hotkey] == oldState then
				states[hotkey] = "normal"

				local color = Addon.sets["normal"]
				hotkey:SetVertexColor(color[1], color[2], color[3])
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--------------------------------------------------------------------------------

-- addon intially loaded
function Addon:OnLoad()
	self.frame:SetScript("OnEvent", function(frame, event, ...)
		local func = frame.owner[event]

		if func then
			func(self, event, ...)
		end
	end)

	-- load the options menu when the settings frame is loaded
	self.frame:SetScript("OnShow", function(frame)
		C_AddOns.LoadAddOn(AddonName .. "_Config")
		frame:SetScript("OnShow", nil)
	end)

	-- register any events we need to watch
	self.frame:RegisterEvent("ADDON_LOADED")
	self.frame:RegisterEvent("PLAYER_LOGIN")
	self.frame:RegisterEvent("PLAYER_LOGOUT")

	-- drop this method, as we won't need it again
	self.OnLoad = nil
	_G[AddonName] = self
end

-- when the addon finishes loading
function Addon:ADDON_LOADED(event, addonName)
	if addonName ~= AddonName then return end

	-- initialize settings
	self.sets = self:GetOrCreateSettings()

	-- add a launcher for the addons tray
	_G[addonName .. '_Launch'] = function()
		if C_AddOns.LoadAddOn(addonName .. '_Config') then
			Settings.OpenToCategory(addonName)
		end
	end

	-- enable the addon, this is defined in classic/modern
	if type(self.Enable) == "function" then
		self:Enable()
	else
		print(addonName, " - Unable to enable for World of Warcraft version", (GetBuildInfo()))
	end

	-- get rid of the handler, as we don't need it anymore
	self.frame:UnregisterEvent(event)
	self[event] = nil
end

function Addon:PLAYER_LOGOUT(event)
	self:TrimSettings()

	self.frame:UnregisterEvent(event)
	self[event] = nil
end

--------------------------------------------------------------------------------
-- Settings management
--------------------------------------------------------------------------------

-- the name of our SavedVariablesentry in the addon toc
local DB_KEY = "TULLARANGE_COLORS"

local function copyDefaults(tbl, defaults)
	for k, v in pairs(defaults) do
		if type(v) == "table" then
			tbl[k] = copyDefaults(tbl[k] or {}, v)
		elseif tbl[k] == nil then
			tbl[k] = v
		end
	end

	return tbl
end

local function removeDefaults(tbl, defaults)
	for k, v in pairs(defaults) do
		if type(tbl[k]) == "table" and type(v) == "table" then
			removeDefaults(tbl[k], v)
			if next(tbl[k]) == nil then
				tbl[k] = nil
			end
		elseif tbl[k] == v then
			tbl[k] = nil
		end
	end

	return tbl
end

-- gets or creates the addon settings database
-- populates it with defaults
function Addon:GetOrCreateSettings()
	local sets = _G[DB_KEY]

	if not sets then
		sets = {}

		_G[DB_KEY] = sets
	end

	return copyDefaults(sets, self:GetDefaultSettings())
end

-- removes any entries from the settings database that equate to default settings
function Addon:TrimSettings()
	local db = _G[DB_KEY]

	if db then
		removeDefaults(db, self:GetDefaultSettings())
	end
end

function Addon:GetDefaultSettings()
	return {
		-- how frequently we want to update, in seconds
		updateDelay = TOOLTIP_UPDATE_TIME,

		-- enable range coloring on pet actions
		petActions = true,

		-- enable flash animations
		flashAnimations = true,
		flashDuration = ATTACK_BUTTON_FLASH_TIME * 2,

		-- default colors (r, g, b, a, desaturate)
		normal = {1, 1, 1, 1, desaturate = false},
		oor = {1, 0.3, 0.1, 1, desaturate = true},
		oom = {0.1, 0.3, 1, 1, desaturate = true},
		unusable = {0.4, 0.4, 0.4, 1, desaturate = false}
	}
end

--------------------------------------------------------------------------------
-- Settings queries
--------------------------------------------------------------------------------

function Addon:GetUpdateDelay()
	return self.sets.updateDelay
end

function Addon:GetFlashDuration()
	return self.sets.flashDuration
end

function Addon:HandlePetActions()
	return self.sets.petActions
end

function Addon:HandleAttackAnimations()
	return self.sets.flashAnimations
end

function Addon:GetColor(state)
	local color = self.sets[state]
	if color then
		return color[1], color[2], color[3], color[4], color.desaturate
	end
end

-- load the addon
Addon:OnLoad()
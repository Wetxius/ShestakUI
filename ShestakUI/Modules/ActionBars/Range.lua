local T, C, L = unpack(ShestakUI)
if C_AddOns.IsAddOnLoaded("tullaRange") then return end
if C.actionbar.enable ~= true then return end

----------------------------------------------------------------------------------------
--	Out of range check(tullaRange by Tuller)
----------------------------------------------------------------------------------------
local AddonName, Addon = ...

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

function Addon.GetActionState(slot)
    local actionType, id = GetActionInfo(slot)
    local isUsable, notEnoughMana

    -- for macros with names that start with a #, we prioritize the OOM
    -- check using a spell cost strategy over other ones to better
    -- clarify if the macro is actually usable or not
    if actionType == "macro" then
        local name = GetMacroInfo(id)
        if name and name:sub(1, 1) == "#" then
            local spellID = GetMacroSpell(id)
            if spellID then
                isUsable, notEnoughMana = C_Spell.IsSpellUsable(spellID)
            end
        end
    end

    if isUsable == nil then
        isUsable, notEnoughMana = IsUsableAction(slot)
    end

    local outOfRange = IsActionInRange(slot) == false
    if isUsable then
        return outOfRange and 'oor' or 'normal', outOfRange
    end

    return notEnoughMana and 'oom' or 'unusable', outOfRange
end

function Addon.GetPetActionState(index)
    local _, _, _, _, _, _, spellID, checksRange, inRange = GetPetActionInfo(index)
    local outOfRange = checksRange and not inRange
    local isUsable, notEnoughMana

    if spellID then
        isUsable, notEnoughMana = C_Spell.IsSpellUsable(spellID)
    else
        isUsable = GetPetActionSlotUsable(index)
        notEnoughMana = false
    end

    if isUsable then
        return outOfRange and 'oor' or 'normal', outOfRange
    end

    return notEnoughMana and 'oom' or 'unusable', outOfRange
end

local states = {}
local registered = {}

--------------------------------------------------------------------------------
-- action button coloring
--------------------------------------------------------------------------------

local function actionButton_Update(button)
    -- icon coloring
    local iconState, outOfRange = Addon.GetActionState(button.action)
    local icon = button.icon

    states[icon] = iconState

    local iconColor = Addon.sets[iconState]
    icon:SetVertexColor(iconColor[1], iconColor[2], iconColor[3], iconColor[4])
    icon:SetDesaturated(iconColor.desaturate)

    -- hotkey coloring
    local hotkey = button.HotKey
    local hotkeyState = outOfRange and 'oor' or 'normal'

    states[hotkey] = hotkeyState

    local hotkeyColor = Addon.sets[hotkeyState]
    hotkey:SetVertexColor(hotkeyColor[1], hotkeyColor[2], hotkeyColor[3])
end

local function actionButton_UpdateRange(button, checksRange, inRange)
    if not registered[button] then return end

    local oor = checksRange and not inRange

    local icon = button.icon
    local iconState = states[icon]
    local newIconState

    if iconState == "normal" and oor then
        newIconState = "oor"
    elseif iconState == "oor" and not oor then
        newIconState = "normal"
    end

    if newIconState then
        states[icon] = newIconState

        local iconColor = Addon.sets[newIconState]
        icon:SetVertexColor(iconColor[1], iconColor[2], iconColor[3], iconColor[4])
        icon:SetDesaturated(iconColor.desaturate)
    end

    local hotkey = button.HotKey
    local hotkeyState = states[hotkey]
    local newHotkeyState

    if hotkeyState == "normal" and oor then
        newHotkeyState = "oor"
    elseif hotkeyState == "oor" and not oor then
        newHotkeyState = "normal"
    end

    if newHotkeyState then
        states[hotkey] = newHotkeyState

        local hotkeyColor = Addon.sets[newHotkeyState]
        hotkey:SetVertexColor(hotkeyColor[1], hotkeyColor[2], hotkeyColor[3])
    end
end

local function actionButton_Register(button)
    if not registered[button] then
        hooksecurefunc(button, "UpdateUsable", actionButton_Update)

        if Addon:HandleAttackAnimations() then
            button:HookScript("OnShow", Addon.UpdateAttackAnimation)
            button:HookScript("OnHide", Addon.UpdateAttackAnimation)
            hooksecurefunc(button, "StartFlash", Addon.StartAttackAnimation)
        end

        registered[button] = true
    end
end

--------------------------------------------------------------------------------
-- pet action button coloring
--------------------------------------------------------------------------------

local function petButton_Register(button)
    if not registered[button] then
        if Addon:HandleAttackAnimations() then
            hooksecurefunc(button, "StartFlash", Addon.StartAttackAnimation)
            button:HookScript("OnShow", Addon.UpdateAttackAnimation)
            button:HookScript("OnHide", Addon.UpdateAttackAnimation)
        end

        registered[button] = true
    end
end

local function petBar_Update(bar)
    if not PetHasActionBar() then return end

    local getState = Addon.GetPetActionState
    for index, button in pairs(bar.actionButtons) do
        if button.icon:IsVisible() then
            -- icon coloring
            local icon = button.icon
            local iconState, outOfRange = getState(index)

            states[icon] = iconState

            local iconColor = Addon.sets[iconState]
            icon:SetVertexColor(iconColor[1], iconColor[2], iconColor[3], iconColor[4])
            icon:SetDesaturated(iconColor.desaturate)
        end
    end
end

--------------------------------------------------------------------------------
-- engine implementation
--------------------------------------------------------------------------------

function Addon:Enable()
    -- register action buttons
    ActionBarButtonEventsFrame:ForEachFrame(actionButton_Register)
    hooksecurefunc(ActionBarButtonEventsFrame, "RegisterFrame", function(_, button)
        actionButton_Register(button)
    end)

    -- watch for range check events
    hooksecurefunc('ActionButton_UpdateRangeIndicator', actionButton_UpdateRange)

    -- disable the ActionBarButtonUpdateFrame OnUpdate handler - we don't actually need it
    ActionBarButtonUpdateFrame:SetScript("OnUpdate", nil)

    if self:HandlePetActions() then
        for _, button in pairs(PetActionBar.actionButtons) do
            petButton_Register(button)
        end

        hooksecurefunc(PetActionBar, "Update", petBar_Update)
        self.frame:RegisterUnitEvent('UNIT_POWER_UPDATE', 'pet')
    end

    self:RequestUpdate()
end

function Addon:UNIT_POWER_UPDATE()
    petBar_Update(PetActionBar)
end

function Addon:RequestUpdate()
    if not self.updateRequested then
        C_Timer.After(1 / 30, function()
            ActionBarButtonEventsFrame:ForEachFrame(actionButton_Update)

            if self:HandlePetActions() then
                petBar_Update(PetActionBar)
            end

            self.updateRequested = nil
        end)

        self.updateRequested = true
    end
end

EventUtil.ContinueOnAddOnLoaded(AddonName, GenerateClosure(function(self, addonName)
    -- add a handler for loading the settings panel
    self.frame = CreateFrame("Frame", nil, SettingsPanel)
    self.frame.owner = self

    self.frame:SetScript("OnShow", function(frame)
        C_AddOns.LoadAddOn(addonName .. "_Config")
        frame:SetScript("OnShow", nil)
    end)

    -- provide a way for the updaters to register events
    self.frame:SetScript('OnEvent', function(_, event, ...)
        self[event](self, event, ...)
    end)

    -- initialize the db
    self.sets = self:GetOrCreateSettings()

    -- cleanup the db upon logout
    EventUtil.RegisterOnceFrameEventAndCallback("PLAYER_LOGOUT", function()
        self:TrimSettings()
    end)

    -- add a launcher for the addons tray
    if AddonCompartmentFrame then
        AddonCompartmentFrame:RegisterAddon {
            text = C_AddOns.GetAddOnMetadata(addonName, "Title"),
            icon = C_AddOns.GetAddOnMetadata(addonName, "IconTexture"),
            func = function()
                if C_AddOns.LoadAddOn(addonName .. '_Config') then
                    Settings.OpenToCategory(addonName)
                end
            end,
        }
    end

    -- enable the addon, this is defined in classic/modern
    if type(self.Enable) == "function" then
        self:Enable()
        self.Enable = nil
    else
        print(addonName, " - Unable to enable for World of Warcraft version", (GetBuildInfo()))
    end
end, Addon))

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
        normal = { 1, 1, 1, 1, desaturate = false },
        oor = { 1, 0.3, 0.1, 1, desaturate = true },
        oom = { 0.1, 0.3, 1, 1, desaturate = true },
        unusable = { 0.4, 0.4, 0.4, 1, desaturate = false }
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
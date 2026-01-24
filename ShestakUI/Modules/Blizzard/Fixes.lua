local T, C, L = unpack(ShestakUI)

----------------------------------------------------------------------------------------
--	Fix blank tooltip
----------------------------------------------------------------------------------------
local bug = nil
local FixTooltip = CreateFrame("Frame")
FixTooltip:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
FixTooltip:RegisterEvent("ACTIONBAR_PAGE_CHANGED")
FixTooltip:SetScript("OnEvent", function()
	if GameTooltip:IsShown() then
		bug = true
	end
end)

local FixTooltipBags = CreateFrame("Frame")
FixTooltipBags:RegisterEvent("BAG_UPDATE_DELAYED")
FixTooltipBags:SetScript("OnEvent", function()
	if StuffingFrameBags and StuffingFrameBags:IsShown() then
		if GameTooltip:IsShown() then
			bug = true
		end
	end
end)

GameTooltip:HookScript("OnTooltipCleared", function(self)
	if self:IsForbidden() then return end
	if bug and self:NumLines() == 0 then
		self:Hide()
		bug = false
	end
end)

----------------------------------------------------------------------------------------
--	Fix RemoveTalent() taint
----------------------------------------------------------------------------------------
FCF_StartAlertFlash = T.dummy

----------------------------------------------------------------------------------------
--	Fix DeclensionFrame strata
----------------------------------------------------------------------------------------
if T.client == "ruRU" then
	_G["DeclensionFrame"]:SetFrameStrata("HIGH")
end

----------------------------------------------------------------------------------------
--	Fix Keybind taint
----------------------------------------------------------------------------------------
_G.SettingsPanel.TransitionBackOpeningPanel = _G.HideUIPanel

----------------------------------------------------------------------------------------
--	Fix LFG FilterButton width
----------------------------------------------------------------------------------------
hooksecurefunc(LFGListFrame.SearchPanel.FilterButton, "SetWidth", function(self, width)	-- FIXME check after while for possible Blizzard fix
	if width ~= 94 then
		self:SetWidth(94)
	end
end)

----------------------------------------------------------------------------------------
--	Hide right-click line on unitframes
----------------------------------------------------------------------------------------
function UnitFrame_UpdateTooltip(self)
	GameTooltip_SetDefaultAnchor(GameTooltip, self)
	if GameTooltip:SetUnit(self.unit, self.hideStatusOnTooltip) then
		self.UpdateTooltip = UnitFrame_UpdateTooltip
	else
		self.UpdateTooltip = nil
	end
end

----------------------------------------------------------------------------------------
-- !!NoTaint2 (Code by warbaby 2022-11 http://abyui.top https://github.com/aby-ui)
----------------------------------------------------------------------------------------
if C_AddOns.IsAddOnLoaded("!!NoTaint2") then return end
if not NoTaint2_Proc_ResetActionButtonAction then
	NoTaint2_Proc_ResetActionButtonAction = 1

	-- use /run ActionButton2.action = 2 ActionButton2:UpdateAction() to test

	function NoTaint2_ResetActionButtonAction(self)
		local ok = issecurevariable(self, "action")
		if not ok and not InCombatLockdown() then
			self.action=nil
			self:SetAttribute("_aby", "action")
		end
	end

	for _, v in ipairs(ActionBarButtonEventsFrame.frames) do
		hooksecurefunc(v, "UpdateAction", NoTaint2_ResetActionButtonAction)
	end

	local f1 = CreateFrame("Frame")
	f1:RegisterEvent("PLAYER_REGEN_ENABLED")
	f1:SetScript("OnEvent", function()
		for _, v in ipairs(ActionBarButtonEventsFrame.frames) do
			NoTaint2_ResetActionButtonAction(v)
		end
	end)
end

if not NoTaint2_CleanStaticPopups then
	--code since !NoTaint, test: /run StaticPopup_Show('PARTY_INVITE',"a") /dump issecurevariable(StaticPopup1, "which")
	function NoTaint2_CleanStaticPopups()
		for index = 1, 4, 1 do
			local frame = _G["StaticPopup"..index];
			if not issecurevariable(frame, "which") then
				if frame:IsShown() then
					local info = StaticPopupDialogs[frame.which];
					if info and not issecurevariable(info, "OnCancel") then
						info.OnCancel()
					end
					frame:Hide()
				end
				frame.which = nil
			end
		end
	end

	function NoTaint2_CleanDropDownList()
		local frameToShow = LFDQueueFrameTypeDropDown
		if not frameToShow then return end
		local parent = frameToShow:GetParent()
		frameToShow:SetParent(nil) --to show
		--RequestLFDPlayerLockInfo() --to trigger LFG_LOCK_INFO_RECEIVED
		frameToShow:SetParent(parent)
	end

	local global_obj_name = {
		UIDROPDOWNMENU_MAXBUTTONS = 1,
		UIDROPDOWNMENU_MAXLEVELS = 1,
		UIDROPDOWNMENU_OPEN_MENU = 1,
		UIDROPDOWNMENU_INIT_MENU = 1,
		OBJECTIVE_TRACKER_UPDATE_REASON = 1,
	}

	function NoTaint2_CleanGlobal()
		for k, _ in pairs(global_obj_name) do
			if not issecurevariable(k) then
				--print("clean", k, issecurevariable(k))
				_G[k] = nil
			end
		end
		--ObjectiveTrackerFrame.lastMapID = nil
	end

	hooksecurefunc(EditModeManagerFrame, "ClearActiveChangesFlags", function(self)
		for _, systemFrame in ipairs(self.registeredSystemFrames) do
			systemFrame:SetHasActiveChanges(nil);
		end
		self:SetHasActiveChanges(nil);
	end)

	-- not sure if this is of any use. PetFrame and ActionBar call it.
	hooksecurefunc(EditModeManagerFrame, "HideSystemSelections", function(self)
		if self.editModeActive == false then
			self.editModeActive = nil
		end
	end)

	hooksecurefunc(EditModeManagerFrame, "IsEditModeLocked", function()
		NoTaint2_CleanGlobal()
	end)

	local function cleanAll()
		NoTaint2_CleanDropDownList()
		NoTaint2_CleanStaticPopups()
		NoTaint2_CleanGlobal()
	end

	local Origin_IsShown = EditModeManagerFrame.IsShown
	hooksecurefunc(EditModeManagerFrame, "IsShown", function(self)
		if Origin_IsShown(self) then return end
		local stack = debugstack(4)
		--call from UIParent.lua if ( not frame or frame:IsShown() ) then
		--different when hooked
		if stack and stack:find('[string "=[C]"]: in function `ShowUIPanel\'\n', 1, true) then
			cleanAll()
		end
	end)
end

if not NoTaint2_Proc_StopEnterWorldLayout then
	NoTaint2_Proc_StopEnterWorldLayout = 1
	local f2 = CreateFrame("Frame")
	f2:RegisterEvent("PLAYER_LEAVING_WORLD")
	f2:RegisterEvent("PLAYER_ENTERING_WORLD")
	f2:SetScript("OnEvent", function(_, event, ...)
		if event == "PLAYER_ENTERING_WORLD" then
			local login, reload = ...
			if not login and not reload then
				NoTaint2_CleanDropDownList()
				NoTaint2_CleanStaticPopups()
				NoTaint2_CleanGlobal()
			end
			EditModeManagerFrame:RegisterEvent("EDIT_MODE_LAYOUTS_UPDATED")
		elseif event == "PLAYER_LEAVING_WORLD" then
			EditModeManagerFrame:UnregisterEvent("EDIT_MODE_LAYOUTS_UPDATED")
		end
	end)
end

if not NoTaint2_Proc_CleanActionButtonFlyout then
	NoTaint2_Proc_CleanActionButtonFlyout = 1
	--[[------------------------------------------------------------
	this is totally magic, thanks god ObjectiveTrackerFrame is after the ActionBars
	---------------------------------------------------------------]]
	local barsToUpdate = { MainMenuBar, MultiBarBottomLeft, MultiBarBottomRight, StanceBar, PetActionBar, PossessActionBar, MultiBarRight, MultiBarLeft, MultiBar5, MultiBar6, MultiBar7 }
	for _, bar in ipairs(barsToUpdate) do
		hooksecurefunc(bar, "UpdateSpellFlyoutDirection", function(self)
			if not issecurevariable(self, "flyoutDirection") then
				self.flyoutDirection = nil
			end
			if not issecurevariable(self, "snappedToFrame") then
				self.snappedToFrame = nil
			end
		end)
	end

	hooksecurefunc("SetClampedTextureRotation", function(texture)
		local parent = texture and texture:GetParent()
		if parent and parent.FlyoutArrowPushed and parent.FlyoutArrowHighlight then
			if not issecurevariable(texture, "rotationDegrees") then
				texture.rotationDegrees = nil
			end
		end
	end)
end

----------------------------------------------------------------------------------------
--	Fix blizzard ui error (from NDui)
----------------------------------------------------------------------------------------
local coordStart = 0.0625;
local coordEnd = 1 - coordStart;
local textureUVs = {			-- keys have to match pieceNames in nineSliceSetup table
	TopLeftCorner = { setWidth = true, setHeight = true, ULx = 0.5078125, ULy = coordStart, LLx = 0.5078125, LLy = coordEnd, URx = 0.6171875, URy = coordStart, LRx = 0.6171875, LRy = coordEnd },
	TopRightCorner = { setWidth = true, setHeight = true, ULx = 0.6328125, ULy = coordStart, LLx = 0.6328125, LLy = coordEnd, URx = 0.7421875, URy = coordStart, LRx = 0.7421875, LRy = coordEnd },
	BottomLeftCorner = { setWidth = true, setHeight = true, ULx = 0.7578125, ULy = coordStart, LLx = 0.7578125, LLy = coordEnd, URx = 0.8671875, URy = coordStart, LRx = 0.8671875, LRy = coordEnd },
	BottomRightCorner = { setWidth = true, setHeight = true, ULx = 0.8828125, ULy = coordStart, LLx = 0.8828125, LLy = coordEnd, URx = 0.9921875, URy = coordStart, LRx = 0.9921875, LRy = coordEnd },
	TopEdge = { setHeight = true, ULx = 0.2578125, ULy = "repeatX", LLx = 0.3671875, LLy = "repeatX", URx = 0.2578125, URy = coordStart, LRx = 0.3671875, LRy = coordStart },
	BottomEdge = { setHeight = true, ULx = 0.3828125, ULy = "repeatX", LLx = 0.4921875, LLy = "repeatX", URx = 0.3828125, URy = coordStart, LRx = 0.4921875, LRy = coordStart },
	LeftEdge = { setWidth = true, ULx = 0.0078125, ULy = coordStart, LLx = 0.0078125, LLy = "repeatY", URx = 0.1171875, URy = coordStart, LRx = 0.1171875, LRy = "repeatY" },
	RightEdge = { setWidth = true, ULx = 0.1328125, ULy = coordStart, LLx = 0.1328125, LLy = "repeatY", URx = 0.2421875, URy = coordStart, LRx = 0.2421875, LRy = "repeatY" },
	Center = { ULx = 0, ULy = 0, LLx = 0, LLy = "repeatY", URx = "repeatX", URy = 0, LRx = "repeatX", LRy = "repeatY" },
};
local function GetBackdropCoordValue(coord, pieceSetup, repeatX, repeatY)
	local value = pieceSetup[coord];
	if value == "repeatX" then
		return repeatX;
	elseif value == "repeatY" then
		return repeatY;
	else
		return value;
	end
end
local function SetupBackdropTextureCoordinates(region, pieceSetup, repeatX, repeatY)
	region:SetTexCoord(	GetBackdropCoordValue("ULx", pieceSetup, repeatX, repeatY), GetBackdropCoordValue("ULy", pieceSetup, repeatX, repeatY),
						GetBackdropCoordValue("LLx", pieceSetup, repeatX, repeatY), GetBackdropCoordValue("LLy", pieceSetup, repeatX, repeatY),
						GetBackdropCoordValue("URx", pieceSetup, repeatX, repeatY), GetBackdropCoordValue("URy", pieceSetup, repeatX, repeatY),
						GetBackdropCoordValue("LRx", pieceSetup, repeatX, repeatY), GetBackdropCoordValue("LRy", pieceSetup, repeatX, repeatY));
end
function BackdropTemplateMixin:SetupTextureCoordinates()
	local width = self:GetWidth();
	if issecretvalue(width) then return end -- needs review
	local height = self:GetHeight();
	local effectiveScale = self:GetEffectiveScale();
	local edgeSize = self:GetEdgeSize();
	local edgeRepeatX = max(0, (width / edgeSize) * effectiveScale - 2 - coordStart);
	local edgeRepeatY = max(0, (height / edgeSize) * effectiveScale - 2 - coordStart);

	for pieceName, pieceSetup in pairs(textureUVs) do
		local region = self[pieceName];
		if region then
			if pieceName == "Center" then
				local repeatX = 1;
				local repeatY = 1;
				if self.backdropInfo.tile then
					local divisor = self.backdropInfo.tileSize;
					if not divisor or divisor == 0 then
						divisor = edgeSize;
					end
					if divisor ~= 0 then
						repeatX = (width / divisor) * effectiveScale;
						repeatY = (height / divisor) * effectiveScale;
					end
				end
				SetupBackdropTextureCoordinates(region, pieceSetup, repeatX, repeatY);
			else
				SetupBackdropTextureCoordinates(region, pieceSetup, edgeRepeatX, edgeRepeatY);
			end
		end
	end
end

MoneyFrame_Update_OLD = MoneyFrame_Update

local function GetMoneyFrame(frameOrName)
	local argType = type(frameOrName)
	if argType == "table" then
		return frameOrName
	elseif argType == "string" then
		return _G[frameOrName]
	end
	return nil
end

function MoneyFrame_Update(frameName, money, forceShow)
	local frame = GetMoneyFrame(frameName);
	if issecretvalue(frame.GoldButton:GetWidth()) then return end
	MoneyFrame_Update_OLD(frameName, money, forceShow)
end

SetTooltipMoney_OLD = SetTooltipMoney

function SetTooltipMoney(frame, money, type, prefixText, suffixText)
	if not frame.shownMoneyFrames then
		frame.shownMoneyFrames = 0;
	end
	local moneyFrame = _G[frame:GetName().."MoneyFrame"..frame.shownMoneyFrames+1]
	local moneyFrameWidth = moneyFrame and moneyFrame:GetWidth()
	if issecretvalue(moneyFrameWidth) then return end
	SetTooltipMoney_OLD(frame, money, type, prefixText, suffixText)
end
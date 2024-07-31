local T, C, L = unpack(ShestakUI)
if C.skins.blizzard_frames ~= true then return end

----------------------------------------------------------------------------------------
--	Calendar skin
----------------------------------------------------------------------------------------
local function LoadSkin()
	local frames = {
		CalendarFrame,
		CalendarCreateEventFrame,
		CalendarCreateEventFrame.Header,
		CalendarCreateEventInviteList,
		CalendarCreateEventDescriptionContainer,
		CalendarCreateEventInviteListSection,
		CalendarTexturePickerFrame,
		CalendarTexturePickerFrame.Header,
		CalendarMassInviteFrame,
		CalendarMassInviteFrame.Header,
		CalendarViewRaidFrame,
		CalendarViewRaidFrame.Header,
		CalendarViewHolidayFrame.Header,
		CalendarViewEventFrame,
		CalendarViewEventFrame.Header,
		CalendarViewEventDescriptionContainer,
		CalendarViewEventInviteList,
		CalendarViewEventInviteListSection,
		CalendarEventPickerFrame,
		CalendarEventPickerFrame.Header
	}

	for _, frame in pairs(frames) do
		frame:StripTextures()
	end

	CalendarFrame:CreateBackdrop("Transparent")
	CalendarFrame.backdrop:SetPoint("TOPLEFT", 0, 0)
	CalendarFrame.backdrop:SetPoint("BOTTOMRIGHT", 0, -5)

	T.SkinCloseButton(CalendarCloseButton)

	T.SkinNextPrevButton(CalendarPrevMonthButton)
	T.SkinNextPrevButton(CalendarNextMonthButton)

	-- Dropdown button
	T.SkinFilter(CalendarFrame.FilterButton, true)

	-- Backdrop
	local bg = CreateFrame("Frame", "CalendarFrameBackdrop", CalendarFrame)
	bg:SetTemplate("Default")
	bg:SetPoint("TOPLEFT", 10, -72)
	bg:SetPoint("BOTTOMRIGHT", -8, 3)

	--FIXME CalendarContextMenu.NineSlice:SetTemplate("Transparent")
	-- CalendarInviteStatusContextMenu.NineSlice:SetTemplate("Transparent")

	-- Boost frame levels
	for i = 1, 42 do
		_G["CalendarDayButton"..i]:SetFrameLevel(_G["CalendarDayButton"..i]:GetFrameLevel() + 1)
	end

	-- CreateEventFrame
	CalendarCreateEventFrame:SetTemplate("Transparent")
	CalendarCreateEventFrame:SetPoint("TOPLEFT", CalendarFrame, "TOPRIGHT", 3, 0)

	CalendarCreateEventCreateButton:SkinButton(true)
	CalendarCreateEventMassInviteButton:SkinButton(true)
	CalendarCreateEventInviteButton:SkinButton(true)
	CalendarCreateEventInviteButton:SetPoint("TOPLEFT", CalendarCreateEventInviteEdit, "TOPRIGHT", 4, 2)
	CalendarCreateEventInviteEdit:SetPoint("TOPLEFT", CalendarCreateEventInviteList, "BOTTOMLEFT", 2, -3)

	CalendarCreateEventInviteList:SetTemplate("Overlay")

	T.SkinEditBox(CalendarCreateEventInviteEdit, CalendarCreateEventInviteEdit:GetWidth() - 2, CalendarCreateEventInviteEdit:GetHeight() - 2)
	T.SkinEditBox(CalendarCreateEventTitleEdit)
	CalendarCreateEventTitleEdit.backdrop:SetPoint("TOPLEFT", -3, 1)
	CalendarCreateEventTitleEdit.backdrop:SetPoint("BOTTOMRIGHT", -3, -1)
	T.SkinDropDownBox(CalendarCreateEventFrame.EventTypeDropdown, 120)

	CalendarCreateEventDescriptionContainer:SetTemplate("Overlay")

	T.SkinCloseButton(CalendarCreateEventCloseButton)

	T.SkinCheckBox(CalendarCreateEventLockEventCheck)

	T.SkinDropDownBox(CalendarCreateEventFrame.HourDropdown, 68)
	T.SkinDropDownBox(CalendarCreateEventFrame.MinuteDropdown, 68)
	T.SkinDropDownBox(CalendarCreateEventFrame.AMPMDropdown, 68)
	T.SkinDropDownBox(CalendarCreateEventFrame.DifficultyOptionDropdown)
	CalendarCreateEventIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	CalendarCreateEventIcon.SetTexCoord = T.dummy

	CalendarClassButtonContainer:HookScript("OnShow", function()
		for i, class in ipairs(CLASS_SORT_ORDER) do
			local button = _G["CalendarClassButton"..i]
			button:StripTextures()
			button:CreateBackdrop("Default")

			local tcoords = CLASS_ICON_TCOORDS[class]
			local buttonIcon = button:GetNormalTexture()
			buttonIcon:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes")
			buttonIcon:SetTexCoord(tcoords[1] + 0.015, tcoords[2] - 0.02, tcoords[3] + 0.018, tcoords[4] - 0.02)
		end

		CalendarClassButton1:SetPoint("TOPLEFT", CalendarClassButtonContainer, "TOPLEFT", 5, 0)

		CalendarClassTotalsButton:StripTextures()
		CalendarClassTotalsButton:CreateBackdrop("Default")
	end)

	-- Texture Picker Frame
	CalendarTexturePickerFrame:SetTemplate("Transparent")

	T.SkinScrollBar(CalendarTexturePickerFrame.ScrollBar)
	CalendarTexturePickerAcceptButton:SkinButton(true)
	CalendarTexturePickerCancelButton:SkinButton(true)
	CalendarCreateEventRaidInviteButton:SkinButton(true)

	-- Mass Invite Frame
	CalendarMassInviteFrame:CreateBackdrop("Overlay")
	T.SkinDropDownBox(CalendarMassInviteFrame.CommunityDropdown, 190)
	T.SkinDropDownBox(CalendarMassInviteFrame.RankDropdown)
	T.SkinEditBox(CalendarMassInviteMinLevelEdit)
	T.SkinEditBox(CalendarMassInviteMaxLevelEdit)
	CalendarMassInviteAcceptButton:SkinButton()
	T.SkinCloseButton(CalendarMassInviteCloseButton)

	-- Raid View
	CalendarViewRaidFrame:SetTemplate("Transparent")
	CalendarViewRaidFrame:SetPoint("TOPLEFT", CalendarFrame, "TOPRIGHT", 3, 0)
	T.SkinCloseButton(CalendarViewRaidCloseButton)

	-- Holiday View
	CalendarViewHolidayFrame:StripTextures(true)
	CalendarViewHolidayFrame:SetTemplate("Transparent")
	CalendarViewHolidayFrame:SetPoint("TOPLEFT", CalendarFrame, "TOPRIGHT", 3, 0)
	T.SkinCloseButton(CalendarViewHolidayCloseButton)

	-- Event View
	CalendarViewEventFrame:SetTemplate("Transparent")
	CalendarViewEventFrame:SetPoint("TOPLEFT", CalendarFrame, "TOPRIGHT", 3, 0)
	CalendarViewEventDescriptionContainer:SetTemplate("Overlay")
	CalendarViewEventInviteList:SetTemplate("Overlay")
	T.SkinCloseButton(CalendarViewEventCloseButton)

	CalendarEventPickerFrame:SetTemplate("Transparent")
	CalendarEventPickerCloseButton:SkinButton(true)

	local buttons = {
		"CalendarViewEventAcceptButton",
		"CalendarViewEventTentativeButton",
		"CalendarViewEventRemoveButton",
		"CalendarViewEventDeclineButton"
	}

	for _, button in pairs(buttons) do
		_G[button]:SkinButton()
	end
end

T.SkinFuncs["Blizzard_Calendar"] = LoadSkin

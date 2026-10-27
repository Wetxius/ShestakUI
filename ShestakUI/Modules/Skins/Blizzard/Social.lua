local T, C, L = unpack(ShestakUI)
if C.skins.blizzard_frames ~= true then return end
if not T.newPatch then return end
----------------------------------------------------------------------------------------
--	Social skin
----------------------------------------------------------------------------------------
local function LoadSkin()
	local frame = SocialUIFrame
	T.SkinFrame(frame)

	local StripAllTextures = {
		FriendsFrame,
		FriendsListFrame,
		FriendsTabHeader,
		AddFriendFrame,
		FriendsFriendsFrame,
		FriendsFrameInset,
		FriendsFrameBattlenetFrame,
		BattleTagInviteFrame,
		QuickJoinRoleSelectionFrame,
		SocialUIFrame.BattleNetBroadcastFrame,
		SocialUIFrame.UnavailableInfoFrame,
		RecruitAFriendFrame.RecruitList.Header,
		RecruitAFriendFrame.RecruitList.ScrollFrameInset,
		RecruitAFriendFrame.RewardClaiming,
		RecruitAFriendRecruitmentFrame,
		RecruitAFriendRewardsFrame
	}

	for i = 1, #StripAllTextures do
		local frame = StripAllTextures[i]
		if frame then
			frame:StripTextures()
		end
	end

	local KillTextures = {
		FriendsFrameIcon
	}

	for i = 1, #KillTextures do
		KillTextures[i]:Kill()
	end

	local buttons = {
		SocialUIFrame.BattleNetBar.ControlsContainer.BattleNetMenuButton,
		SocialUIFrame.RaidFrame.ConvertToRaidButton,
		SocialUIFrame.RaidFrame.RaidInfoButton,
		FriendsFrameAddFriendButton,
		FriendsFrameSendMessageButton,
		WhoFrameWhoButton,
		WhoFrameAddFriendButton,
		WhoFrameGroupInviteButton,
		AddFriendEntryFrameAcceptButton,
		AddFriendEntryFrameCancelButton,
		QuickJoinFrame.JoinQueueButton,
		QuickJoinRoleSelectionFrame.AcceptButton,
		QuickJoinRoleSelectionFrame.CancelButton,
		SocialUIFrame.BattleNetBroadcastFrame.CancelButton,
		SocialUIFrame.BattleNetBroadcastFrame.UpdateButton,
		RecruitAFriendFrame.RewardClaiming.ClaimOrViewRewardButton,
		RecruitAFriendFrame.RecruitmentButton,
		RecruitAFriendFrame.SplashFrame.OKButton,
		RecruitAFriendRecruitmentFrame.GenerateOrCopyLinkButton,
		FriendsFriendsFrame.SendRequestButton,
		FriendsFriendsFrame.CloseButton,
		AddFriendInfoFrame.OkayButton,
		SocialUIFrame.IgnoreListFrame.BlockButton,
		SocialUIFrame.IgnoreListFrame.UnblockButton
	}

	for i = 1, #buttons do
		local button = buttons[i]
		if button then
			button:SkinButton()
		end
	end

	local scrollbars = {
		SocialUIFrame.RecentAlliesList.ScrollBar,
		FriendsListFrame.ScrollBar,
		QuickJoinFrame.ScrollBar,
		RecruitAFriendFrame.RecruitList.ScrollBar,
		FriendsFriendsFrame.ScrollBar,
		SocialUIFrame.IgnoreListFrame.ScrollBar
	}

	for i = 1, #scrollbars do
		local scrollbar = scrollbars[i]
		if scrollbar then
			T.SkinScrollBar(scrollbar, true)
		end
	end

	for _, frame in next, {SocialUIFrame.FriendsList, SocialUIFrame.RecentAlliesList, SocialUIFrame.QuickJoinFrame, SocialUIFrame.FriendRequestsList, SocialUIFrame.RecruitAFriendFrame} do
		frame:StripTextures()
		T.SkinFilter(frame.FilterBar.SearchFilterDropdown)
		frame.FilterBar.SearchFilterDropdown:SetHeight(24)
		frame.FilterBar.SearchFilterDropdown.SetHeight = T.dummy
		T.SkinEditBox(frame.FilterBar.SearchBar)
		T.SkinScrollBar(frame.ScrollBar)
		frame.ActionButton:SkinButton()
		frame.ActionButton:SetHeight(30)

		hooksecurefunc(frame.ScrollBox, "Update", function(frame)
			for _, child in next, {frame.ScrollTarget:GetChildren()} do
				if child and not child.isSkinned then
					if child.CollapseButton then
						child:SetNormalTexture(0)
						child:CreateBackdrop("Overlay")
						child.backdrop:SetPoint("TOPLEFT", child, 0, -1)
						child.backdrop:SetPoint("BOTTOMRIGHT", child, -1, 1)
					end

					if child.TextHolder then
						child.Background:SetAlpha(0)
						child:SetNormalTexture(0)
						child:CreateBackdrop("Overlay")
						child.backdrop:SetPoint("TOPLEFT", child, 0, -1)
						child.backdrop:SetPoint("BOTTOMRIGHT", child, -1, 1)
					end

					if child.PartyButton then
						child.PartyButton:SetNormalTexture(0)

						child.PartyButton.b = CreateFrame("Frame", nil, child)
						child.PartyButton.b:SetTemplate("Overlay")
						child.PartyButton.b:SetInside(child.PartyButton)
					end

					child.isSkinned = true
				end
			end
		end)
	end

	hooksecurefunc(SocialUIFrame, "RefreshTabs", function(frame)
		for _, tabData in ipairs(frame.availableTabData) do
			local tab = frame:GetTabByType(tabData.tabType)
			if tab and not tab.styled then
				T.SkinSideTabs(tab)
				tab.styled = true
			end
		end
	end)

	-- BattleNetBar
	SocialUIFrame.BattleNetBar:StripTextures()
	T.SkinDropDownBox(SocialUIFrame.BattleNetBar.ControlsContainer.OnlineStatusDropdown)

	SocialUIFrame.BattleNetBar.ControlsContainer.BattleNetMenuButton:SetHeight(33)

	local battleTag = SocialUIFrame.BattleNetBar.ControlsContainer.PersonalBattleTagDisplay
	battleTag:CreateBackdrop("Transparent")
	battleTag.backdrop:SetOutside(SocialUIFrame.BattleNetBar.ControlsContainer.BattleNetBackground, 4)
	battleTag.backdrop:SetBackdropColor(FRIENDS_BNET_BACKGROUND_COLOR.r * 0.2, FRIENDS_BNET_BACKGROUND_COLOR.g * 0.2, FRIENDS_BNET_BACKGROUND_COLOR.b * 0.2, 1)
	SocialUIFrame.BattleNetBar.ControlsContainer.BattleNetBackground:SetAlpha(0)

	T.SkinEditBox(AddFriendNameEditBox, nil, AddFriendNameEditBox:GetHeight() - 5)
	AddFriendNameEditBox.backdrop:SetOutside(nil, 4, 0)
	T.SkinFrame(AddFriendFrame)
	FriendsFriendsFrame:SetTemplate("Transparent")

	-- Ignore
	T.SkinFrame(SocialUIFrame.IgnoreListFrame)

	-- Recruit a Friend
	local SplashFrame = RecruitAFriendFrame.SplashFrame
	SplashFrame:CreateBackdrop("Overlay")
	SplashFrame.backdrop:SetPoint("TOPLEFT", 2, -2)
	SplashFrame.backdrop:SetPoint("BOTTOMRIGHT", -1, -1)

	SplashFrame.Picture.b = CreateFrame("Frame", nil, SplashFrame)
	SplashFrame.Picture.b:SetTemplate("Default")
	SplashFrame.Picture.b:SetPoint("TOPLEFT", SplashFrame.Picture, "TOPLEFT", -2, 2)
	SplashFrame.Picture.b:SetPoint("BOTTOMRIGHT", SplashFrame.Picture, "BOTTOMRIGHT", 2, -2)
	SplashFrame.Picture:SetParent(SplashFrame.Picture.b)

	RecruitAFriendFrame.SplashFrame.Description:SetTextColor(1, 1, 1)

	SplashFrame.Background:Hide()
	SplashFrame.PictureFrame:Hide()

	SplashFrame.Bracket_TopLeft:Hide()
	SplashFrame.Bracket_TopRight:Hide()
	SplashFrame.Bracket_BottomRight:Hide()
	SplashFrame.Bracket_BottomLeft:Hide()
	SplashFrame.PictureFrame_Bracket_TopLeft:Hide()
	SplashFrame.PictureFrame_Bracket_TopRight:Hide()
	SplashFrame.PictureFrame_Bracket_BottomRight:Hide()
	SplashFrame.PictureFrame_Bracket_BottomLeft:Hide()

	RecruitAFriendRewardsFrame:SetTemplate("Transparent")
	T.SkinCloseButton(RecruitAFriendRewardsFrame.CloseButton)

	RecruitAFriendRewardsFrame:HookScript("OnShow", function(self)
		for i = 1, self:GetNumChildren() do
			local child = select(i, self:GetChildren())
			local button = child and child.Button
			if button and not button.styled then
				button.Icon:SkinIcon()
				button.IconBorder:SetAlpha(0)
				button:StyleButton(true, 0)

				button.styled = true
			end
		end
	end)

	RecruitAFriendFrame.RewardClaiming.NextRewardButton.Icon:SkinIcon()
	RecruitAFriendFrame.RewardClaiming.NextRewardButton.CircleMask:Hide()
	RecruitAFriendFrame.RewardClaiming.NextRewardButton.IconBorder:SetAlpha(0)

	RecruitAFriendRecruitmentFrame:SetTemplate("Transparent")
	T.SkinCloseButton(RecruitAFriendRecruitmentFrame.CloseButton)
	T.SkinEditBox(RecruitAFriendRecruitmentFrame.EditBox, nil, 18)
	RecruitAFriendRecruitmentFrame.EditBox:SetPoint("RIGHT", RecruitAFriendRecruitmentFrame.GenerateOrCopyLinkButton, "LEFT", -10, 0)

	-- Quick Join Frame
	QuickJoinRoleSelectionFrame:SetTemplate("Transparent")
	T.SkinCloseButton(QuickJoinRoleSelectionFrame.CloseButton)
	T.SkinCheckBox(QuickJoinRoleSelectionFrame.RoleButtonTank.CheckButton)
	T.SkinCheckBox(QuickJoinRoleSelectionFrame.RoleButtonHealer.CheckButton)
	T.SkinCheckBox(QuickJoinRoleSelectionFrame.RoleButtonDPS.CheckButton)

	-- Pending invites
	hooksecurefunc("FriendsFrame_UpdateFriendInviteButton", function(button)
		if not button.IsSkinned then
			button.AcceptButton:SkinButton()
			button.DeclineButton:SkinButton()

			button.IsSkinned = true
		end
	end)

	-- BNet Frame
	-- do
		-- local b = SocialUIFrame.ContactsMenuButton
		-- b:SkinButton()
		-- b:SetSize(23, 23)
	-- end

	SocialUIFrame.BattleNetBroadcastFrame:CreateBackdrop("Transparent")
	SocialUIFrame.BattleNetBroadcastFrame.backdrop:SetPoint("TOPLEFT", 6, 1)
	SocialUIFrame.BattleNetBroadcastFrame.backdrop:SetPoint("BOTTOMRIGHT", -4, 1)

	T.SkinEditBox(SocialUIFrame.BattleNetBroadcastFrame.EditBox, nil, 18)

	-- SocialUIFrame.UnavailableInfoFrame:CreateBackdrop("Transparent")
	-- SocialUIFrame.UnavailableInfoFrame.backdrop:SetPoint("TOPLEFT", 4, -4)
	-- SocialUIFrame.UnavailableInfoFrame.backdrop:SetPoint("BOTTOMRIGHT", -4, 4)

	FriendsFrame:SetTemplate("Transparent")

	local InviteAtlas = {
		["friendslist-invitebutton-horde-normal"] = [[Interface\FriendsFrame\PlusManz-Horde]],
		["friendslist-invitebutton-alliance-normal"] = [[Interface\FriendsFrame\PlusManz-Alliance]],
		["friendslist-invitebutton-default-normal"] = [[Interface\FriendsFrame\PlusManz-PlusManz]]
	}

	local function HandleInviteTex(self, atlas)
		local tex = InviteAtlas[atlas]
		if tex then
			self.inv:SetTexture(tex)
		end
	end

	local function ReskinFriendButton(button)
		if button.styled then return end
		local icon = button.gameIcon

		icon.b = CreateFrame("Frame", nil, button)
		icon.b:SetTemplate("Default")
		icon.b:SetPoint("TOPLEFT", icon, "TOPLEFT", -2, 2)
		icon.b:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 2, -2)

		icon:SetParent(icon.b)
		icon:SetSize(22, 22)
		icon:SetTexCoord(0, 1, 0, 1)
		icon:ClearAllPoints()
		icon:SetPoint("RIGHT", button, "RIGHT", -27, 0)
		icon.SetPoint = T.dummy

		button.travelPassButton:SetSize(20, 30)
		button.travelPassButton:SkinButton()
		button.travelPassButton.NormalTexture:SetAlpha(0)
		button.travelPassButton.PushedTexture:SetAlpha(0)
		button.travelPassButton.DisabledTexture:SetAlpha(0)
		button.travelPassButton:SetPoint("TOPRIGHT", -1, -2)

		button.inv = button.travelPassButton:CreateTexture(nil, "OVERLAY", nil, 7)
		button.inv:SetPoint("TOPRIGHT", 1, -4)
		button.inv:SetSize(22, 22)

		button.travelPassButton.NormalTexture.inv = button.inv
		hooksecurefunc(button.travelPassButton.NormalTexture, "SetAtlas", HandleInviteTex)

		button.background:Hide()
		button.styled = true
	end

	hooksecurefunc("FriendsFrame_UpdateFriendButton", function(button)
		if button.gameIcon then
			ReskinFriendButton(button)
		end

		if button.buttonType == FRIENDS_BUTTON_TYPE_BNET and button.travelPassButton then
			local isEnabled = button.travelPassButton:IsEnabled()
			button.travelPassButton:SetAlpha(isEnabled and 1 or 0.4)
		end

		if button.gameIcon.b then
			button.gameIcon.b:SetShown(button.gameIcon:IsShown())
		end
	end)

	T.SkinCloseButton(FriendsFrameCloseButton)
	T.SkinDropDownBox(FriendsFrameStatusDropdown)
	T.SkinDropDownBox(FriendsFriendsFrameDropdown)

	FriendsFrameStatusDropdown:ClearAllPoints()
	FriendsFrameStatusDropdown:SetPoint("TOPLEFT", FriendsFrame, "TOPLEFT", 22, -27)
	FriendsFrameStatusDropdown.Text:SetFont(C.media.normal_font, 12, "")
	FriendsFrameStatusDropdown.Text:ClearAllPoints()
	FriendsFrameStatusDropdown.Text:SetPoint("LEFT", FriendsFrameStatusDropdown, "LEFT", 7, -1)

	-- Bottom Tabs
	for i = 1, 4 do
		T.SkinTab(_G["FriendsFrameTab"..i])
	end

	for i = 1, 3 do
		T.SkinTab(_G["FriendsTabHeaderTab"..i], true)
	end

	for _, tab in next, {FriendsTabHeader.TabSystem:GetChildren()} do
		tab:StripTextures()
	end
end

tinsert(T.SkinFuncs["ShestakUI"], LoadSkin)
local _, ns = ...
local oUF = ns.oUF

local function Update(self, event)
	local element = self.GroupRoleIndicator

	--[[ Callback: GroupRoleIndicator:PreUpdate()
	Called before the element has been updated.

	* self - the GroupRoleIndicator element
	--]]
	if(element.PreUpdate) then
		element:PreUpdate()
	end

	local role = UnitGroupRolesAssignedEnum(self.__unit)
	if(issecretvalue(role)) then
		role = nil
	end

	if(role == Enum.LFGRole.Tank) then
		element:SetAtlas('UI-LFG-RoleIcon-Tank-Micro-Raid', element.useAtlasSize)
		element:Show()
	elseif(role == Enum.LFGRole.Healer) then
		element:SetAtlas('UI-LFG-RoleIcon-Healer-Micro-Raid', element.useAtlasSize)
		element:Show()
	elseif(role == Enum.LFGRole.Damage) then
		element:SetAtlas('UI-LFG-RoleIcon-DPS-Micro-Raid', element.useAtlasSize)
		element:Show()
	else
		element:Hide()
	end

	--[[ Callback: GroupRoleIndicator:PostUpdate(role)
	Called after the element has been updated.

	* self - the GroupRoleIndicator element
	* role - the role as returned by [UnitGroupRolesAssignedEnum](https://warcraft.wiki.gg/wiki/API_UnitGroupRolesAssignedEnum) (number)
	--]]
	if(element.PostUpdate) then
		return element:PostUpdate(role)
	end
end

local function Path(self, ...)
	--[[ Override: GroupRoleIndicator.Override(self, event, ...)
	Used to completely override the internal update function.

	* self  - the parent object
	* event - the event triggering the update (string)
	* ...   - the arguments accompanying the event
	--]]
	return (self.GroupRoleIndicator.Override or Update) (self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, 'ForceUpdate')
end

local function Enable(self, unit)
	local element = self.GroupRoleIndicator
	if(element) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		if(unit == 'player') then
			self:RegisterEvent('PLAYER_ROLES_ASSIGNED', Path, true)
		else
			self:RegisterEvent('GROUP_ROSTER_UPDATE', Path, true)
		end

		return true
	end
end

local function Disable(self)
	local element = self.GroupRoleIndicator
	if(element) then
		element:Hide()

		self:UnregisterEvent('PLAYER_ROLES_ASSIGNED', Path)
		self:UnregisterEvent('GROUP_ROSTER_UPDATE', Path, true)
	end
end

oUF:AddElement('GroupRoleIndicator', Path, Enable, Disable)
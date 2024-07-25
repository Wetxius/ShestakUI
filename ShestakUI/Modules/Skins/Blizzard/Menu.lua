local T, C, L = unpack(ShestakUI)
if C.skins.blizzard_frames ~= true then return end

----------------------------------------------------------------------------------------
--	Blizzard_Menu skin
----------------------------------------------------------------------------------------
local function LoadSkin()
	local backdrops = {}
	local function SkinFrame(frame)
		frame:StripTextures()

		if backdrops[frame] then
			frame.backdrop = backdrops[frame] -- relink it back
		else
			frame:CreateBackdrop("Transparent") -- :SetTemplate errors out
			backdrops[frame] = frame.backdrop
		end
	end

	local function OpenMenu(manager)
		local menu = manager:GetOpenMenu()
		if menu then
			SkinFrame(menu)
		end
	end

	local manager = _G.Menu.GetManager()
	hooksecurefunc(manager, "OpenMenu", OpenMenu)
	hooksecurefunc(manager, "OpenContextMenu", OpenMenu)
end

tinsert(T.SkinFuncs["ShestakUI"], LoadSkin)
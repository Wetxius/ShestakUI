----------------------------------------------------------------------------------------
--	Initiation of ShestakUI
----------------------------------------------------------------------------------------
-- Including system
local _, engine = ...
engine[1] = {}	-- T, Functions
engine[2] = {}	-- C, Config
engine[3] = {}	-- L, Localization

ShestakUI = engine	-- Allow other addons to use Engine

--[[
	This should be at the top of every file inside of the ShestakUI AddOn:
	local T, C, L = unpack(ShestakUI)

	This is how another addon imports the ShestakUI engine:
	local T, C, L, _ = unpack(ShestakUI)
]]
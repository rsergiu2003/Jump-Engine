--[[

	Created by Rosu Sergiu on 30/Jun/2011

	Jump Engine it's a game engine for createing jumping games for mobile devices.

	This file is part of Jump Engine.
	
	About this file : it's the level manager, will manage the level progress, download the levels, updates to levels, etc.
	The game mamager will use this class to load levels and inquire about progress

    Jump Engine is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Jump Engine is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Jump Engine.  If not, see <http://www.gnu.org/licenses/>.

	Copyright (C) 2011  Rosu Sergiu
--]]

-- fullLevelData - will hold all the platforms for the level, they will be regulary removed from here and added to the gamemanager's list

LevelManager_ = {requestForLevel="",fullLevelData=""}

LevelManager_.metatable = { __index = LevelManager_ };
LevelManager_.new = function()
	local self = {}
	setmetatable(self, LevelManager_.metatable);

	return self;
end

LevelManager = LevelManager_.new();

function LevelManager_:LoadLevel(levelName)
	--first check if we have the file locally
	local path = system.pathForFile( levelName, system.DocumentsDirectory );

	local file = io.open( path, "r" )
	if file then
	   local contents = file:read( "*a" );
	   io.close( file );
		print ("level exists localy");
		LevelManager:ParseLevelData(contents);
		return true;
	else
		if self.requestForLevel ~= "" then
			print ("level request in progress");
			return false;
		end
		print ("level not found locally");
		self.requestForLevel = levelName;
		NetworkWraper:LoadLevel(levelName);
	end
	
	return false;
end

function LevelManager_:LevelDataArrived(data)
	print ("remote level data arrived, saving locally on: "..self.requestForLevel);
	
	local path = system.pathForFile( self.requestForLevel, system.DocumentsDirectory );
	file = io.open( path, "w" );
	file:write(data);
	io.close( file );

	self.requestForLevel = "";
	
	LevelManager:ParseLevelData(data);
	
	return true;
end

-- will parse json level data and add it to it's arrays
function LevelManager_:ParseLevelData(data)
	local json = Json.Decode(data);
	
	--if we already have a level loaded we need to clear it
	if self.fullLevelData ~= "" then 
		print "level already loaded";
	end
	
	self.fullLevelData = {}
	
	for index in pairs(json.platform) do print(index) end;
end
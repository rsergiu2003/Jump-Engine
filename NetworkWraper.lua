--[[

	Created by Rosu Sergiu on 30/Jun/2011

	Jump Engine it's a game engine for createing jumping games for mobile devices.

	This file is part of Jump Engine.

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

NetworkWraper_ = {}

NetworkWraper_.metatable = { __index = NetworkWraper_ };
NetworkWraper_.new = function()
	local self = {}
	setmetatable(self, NetworkWraper_.metatable);

	return self;
end

function NetworkWraper_:LoadLevel(location)
	print ("load level from remote server: "..location);
	network.request( __SERVER_URL__..location, "GET", NetworkWraper_loadLevelArrived );
end

function NetworkWraper_loadLevelArrived(event)
	NetworkWraper_:LoadLevelArrived(event);
end

function NetworkWraper_:LoadLevelArrived(event)
	LevelManager:LevelDataArrived(event.response);
end

NetworkWraper = NetworkWraper_.new();
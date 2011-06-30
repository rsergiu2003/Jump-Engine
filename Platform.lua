--[[

	Created by Rosu Sergiu on 27/Jun/2011

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
Platform = {image=0, x=0, y=0,w=50,h=30,frame,index}

platformIndex = 0;

Platform.metatable = { __index = Platform };
Platform.new = function()
	local self = {}
	setmetatable(self, Platform.metatable);
	
	self.frame = Rect.new();
	self.frame.w = self.w;
	self.frame.h = self.h;
	
	self.index = platformIndex;
	platformIndex = platformIndex + 1;
	return self;
end

function Platform:init (x,y)
	self.image = display.newImage('Images/ground.png');
	
	self.image.x = x;
	self.image.y = y;
	
	self.x = x;
	self.y = y;
	
	self.frame.x = self.x;
	self.frame.y = self.y;
end

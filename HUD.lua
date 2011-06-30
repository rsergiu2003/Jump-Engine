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
HUD_ = {group,distance,pause}

HUD_.metatable = { __index = HUD_ };
HUD_.new = function()
	local self = {}
	setmetatable(self, HUD_.metatable);

	self.group = display.newGroup();

	self.distance = display.newText( "Distance: 000000", 0, 0, "Helvetica", 16 )
	self.distance:setTextColor(255, 255, 255)
	self.group:insert(self.distance);
	
	self.pause = display.newImage("Images/pause.png");
	self.group:insert(self.pause);
	self.pause.x = display.contentWidth - 30;
	function self.pause:touch(event)
			if event.phase == 'ended' then
				GameManager:pauseGame();
				Menu.showMenu(Menu);
			end
			return true;
	end
	self.pause:addEventListener("touch", self.pause);
	
	self.group.isVisible = true;
	return self;
end

function HUD_:updateDistance (distance)
	self.distance.text = "Distance: " .. distance;
end

function HUD_:showHUD ()
	self.group.isVisible = true;
end

function HUD_:hideHUD ()
	self.group.isVisible = false;
end

HUD = HUD_.new();
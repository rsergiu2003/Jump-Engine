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
Bullet = {image, x=0, y=0,w=10,h=10,frame,index,xSpeed=1,ySpeed=2,time=0}

Bullet.metatable = { __index = Bullet };
Bullet.new = function(x,y)
	local self = {}
	setmetatable(self, Bullet.metatable);
	
	self.image = display.newImage("Images/orange_bullet.png");
	
	self.x = ball.x;
	self.y = ball.y;
	
	self.image.x = self.x;
	self.image.y = self.y;

	self.frame = Rect.new();
	self.frame.x = self.x - self.w/2;
	self.frame.y = self.y - self.h/2;
	self.frame.w = self.w;
	self.frame.h = self.h;
	
	--calculate the speed
	distance = calculatePointsDistance(Point.new(x,y),Point.new(ball.image.x,ball.image.y));
	
	xDiff = x - ball.image.x;
	yDiff = ball.image.y-y;
	
	xAspect = xDiff/distance;
	yAspect = yDiff/distance;
	
	maxSpeed = 30;
	self.xSpeed = maxSpeed*xAspect;
	self.ySpeed = maxSpeed*yAspect;
	
	-- init the creation time
	self.time = system.getTimer();
	
	return self;
end

--should return false if the bullet has to be removed
function Bullet:update()
	
	
	if self.x > display.contentWidth then return false; end
	if self.x < 0 then return false; end
	
	self.x = self.x+self.xSpeed;
	self.y = self.y+self.ySpeed;
	
	convertToLocalScreen(self.image,self.x,self.y);
	
	self.frame.x = self.x - self.w/2;
	self.frame.y = self.y - self.h/2;

	if system.getTimer() - self.time > 400 then
		return false;
	else
		return true;
	end
end
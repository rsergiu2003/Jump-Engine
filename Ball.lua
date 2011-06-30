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
Ball = {image,x=0,y=0,speedX,speedY,accelX,accelY,w=60,h=60,frame=0}
function Ball.init(self)
	self.image = display.newImage('Images/ball.png');
	self.image.x = display.contentWidth/2;
	self.speedX=-20;
	self.speedY=50;
	
	self.accelX = 0;
	self.accelY = -700;
	
	self.frame = Rect.new();
	self.frame.w = self.w;
	self.frame.h = self.h;
end 

function Ball.update(self,deltaT)
	self.speedX = self.speedX + self.accelX*(deltaT/1000);
	self.speedY = self.speedY + self.accelY*(deltaT/1000);

	self.x = self.x + self.speedX*(deltaT/1000);
	self.y = self.y + self.speedY*(deltaT/1000);
	
	if self.y<0 then
		self.speedY = 600;
	end
	if self.x>display.contentWidth then 
		self.x = self.x - display.contentWidth;
	end
	
	if self.x<0 then 
		self.x = self.x + display.contentWidth;
	end
	
	self.frame.x = self.x-self.w/2;
	self.frame.y = self.y-self.h/2;
	
	self.image.rotation = self.image.rotation + self.speedX/2;
end

function Ball.testOverPlatform(self,platform) 
	if platform == nil then 
		return false;
	end
	--print (self.x .." "..platform.x);
	if self.x+self.w/2>platform.x and 
	self.x<(platform.x+platform.w) and
	self.y-self.w/2>platform.y-platform.h/2 and
	self.y-self.w/2<platform.y+platform.h/2
	then
		return true;
	else 
		return false;
	end
end

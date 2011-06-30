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
Menu = {startButton,levelsButton,continueButton,helpButton,lastMenuAction,menuBg}

Menu.MenuActionStart = 1;
Menu.MenuActionReStart = 2;
Menu.MenuActionNoAction = 0;

function Menu.createMenu (self)
	self.startButton = display.newImage("Images/Start.png");
	self.startButton.y = 50;
	self.startButton.x = -1*self.startButton.width/2;
	transition.to(self.startButton,{time=200,delay=0,x=display.contentWidth/2});

	Menu.bgGroup = display.newGroup();
	Menu.buttonsGroup = display.newGroup();

	function self.startButton:touch(event)
		if event.phase == 'ended' then
			Menu.startButtonPressed(Menu);
		end
		return true;
	end
	self.startButton:addEventListener("touch", self.startButton);
	Menu.buttonsGroup:insert(self.startButton);
	
	self.levelsButton = display.newImage("Images/levels.jpg");
	self.levelsButton.y = 100;
	self.levelsButton.x = -1*self.levelsButton.width/2;
	transition.to(self.levelsButton,{time=200,delay=100,x=display.contentWidth/2});
	function self.levelsButton:touch(event)
		if event.phase == 'ended' then
			Menu.lastMenuAction = Menu.MenuActionReStart;
			Menu.hideMenu(Menu);
		end
		return true;
	end
	self.levelsButton:addEventListener("touch", self.levelsButton);
	Menu.buttonsGroup:insert(self.levelsButton);
	
	
	self.continueButton = display.newImage("Images/continue.gif");
	self.continueButton.y = 150;
	self.continueButton.x =-1*self.continueButton.width/2;
	transition.to(self.continueButton,{time=200,delay=200,x=display.contentWidth/2});
	function self.continueButton:touch(event)
		if event.phase == 'ended' then
			Menu.hideMenu(Menu);
			GameManager:resumeGame();
		end
		return true;
	end
	self.continueButton:addEventListener("touch", self.continueButton);
	Menu.buttonsGroup:insert(self.continueButton);
	
	
	self.helpButton = display.newImage("Images/help.gif");
	self.helpButton.y = 200;
	self.helpButton.x = -1*self.helpButton.width/2;
	transition.to(self.helpButton,{time=200,delay=300,x=display.contentWidth/2});
	Menu.buttonsGroup:insert(self.helpButton);
	
	
end

function Menu.startButtonPressed(self)
	print "start game";
	Menu.lastMenuAction = Menu.MenuActionStart;
	Menu.hideMenu(Menu)
end

function Menu.hideMenu(self) 
	
	if self.menuBg ~= nil then 
		transition.to(self.menuBg,{time=150,delay=0,x=0-self.menuBg.width/2});
	end
	
	transition.to(self.startButton,{time=200,delay=0,x=display.contentWidth+self.startButton.width/2});
	transition.to(self.levelsButton,{time=200,delay=100,x=display.contentWidth+self.levelsButton.width/2});
	transition.to(self.continueButton,{time=200,delay=200,x=display.contentWidth+self.continueButton.width/2});
	transition.to(self.helpButton,{time=200,delay=300,x=display.contentWidth+self.helpButton.width/2,onComplete=Menu.hideAnimatinDone});
end

function Menu.showMenu(self)
		transition.to(self.startButton,{time=200,delay=0,x=display.contentWidth/2});
		transition.to(self.levelsButton,{time=200,delay=100,x=display.contentWidth/2});
		transition.to(self.continueButton,{time=200,delay=200,x=display.contentWidth/2});
		transition.to(self.helpButton,{time=200,delay=300,x=display.contentWidth/2,onComplete=Menu.showAnimatinDone});
end

function Menu.showGameOver(self)
	self.menuBg = display.newImage("Images/game_over.png");
	self.menuBg.x = 0-self.menuBg.width/2;
	Menu.bgGroup:insert(self.menuBg);
	transition.to(self.menuBg,{time=150,delay=0,x=display.contentWidth/2});
	Menu.showMenu(Menu);
end

function Menu.hideAnimatinDone()
	if Menu.lastMenuAction == Menu.MenuActionStart then 
		ball = Ball;
		ball.init(ball);

		GameManager:startGame();
	end
	
	if Menu.lastMenuAction == Menu.MenuActionReStart then
		GameManager:restartGame ();
	end
	
	display.remove(Menu.menuBg);
	Menu.menuBg = nil;
	Menu.lastMenuAction =  Menu.MenuActionNoAction;
end

function Menu.showAnimatinDone() 
end

function Menu.remove(self)
	--display.remove(self.startButton);
end

function Menu.touches(event)
	if event.phase == 'ended' then 
		
	end
end
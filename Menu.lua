Menu = {startButton,levelsButton,continueButton,helpButton,lastMenuAction}

Menu.MenuActionStart = 1;
Menu.MenuActionNoAction = 0;

function Menu.createMenu (self)
	self.startButton = display.newImage("Images/Start.png");
	self.startButton.y = 50;
	self.startButton.x = -1*self.startButton.width/2;
	transition.to(self.startButton,{time=200,delay=0,x=display.contentWidth/2});

	function self.startButton:touch(event)
		if event.phase == 'ended' then
			Menu.startButtonPressed(Menu);
		end
	end
	self.startButton:addEventListener("touch", self.startButton);
	
	self.levelsButton = display.newImage("Images/levels.jpg");
	self.levelsButton.y = 100;
	self.levelsButton.x = -1*self.levelsButton.width/2;
	transition.to(self.levelsButton,{time=200,delay=100,x=display.contentWidth/2});
	function self.levelsButton:touch(event)
		if event.phase == 'ended' then
			Menu.hideMenu(Menu);
			GameManager:restartGame ();
		end
	end
	self.levelsButton:addEventListener("touch", self.levelsButton);
	
	self.continueButton = display.newImage("Images/continue.gif");
	self.continueButton.y = 150;
	self.continueButton.x =-1*self.continueButton.width/2;
	transition.to(self.continueButton,{time=200,delay=200,x=display.contentWidth/2});
	function self.continueButton:touch(event)
		if event.phase == 'ended' then
			Menu.hideMenu(Menu);
			GameManager:resumeGame();
		end
	end
	self.continueButton:addEventListener("touch", self.continueButton);
	
	self.helpButton = display.newImage("Images/help.gif");
	self.helpButton.y = 200;
	self.helpButton.x = -1*self.helpButton.width/2;
	transition.to(self.helpButton,{time=200,delay=300,x=display.contentWidth/2});
	
end

function Menu.startButtonPressed(self)
	print "start game";
	Menu.lastMenuAction = Menu.MenuActionStart;
	Menu.hideMenu(Menu)
end

function Menu.hideMenu(self) 
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

function Menu.hideAnimatinDone()
	if Menu.lastMenuAction == Menu.MenuActionStart then 
		ball = Ball;
		ball.init(ball);

		GameManager:startGame();
	end
	
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
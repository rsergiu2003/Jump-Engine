Menu = {startButton,levelsButton,continueButton,helpButton}

function Menu.showMenu (self)
	self.startButton = display.newImage("images/Start.png");
	self.startButton.y = 50;
	self.startButton.x = -1*self.startButton.width/2;
	transition.to(self.startButton,{time=200,delay=0,x=display.contentWidth/2});

	function self.startButton:touch(event)
		if event.phase == 'ended' then
			Menu.startButtonPressed(Menu);
		end
	end
	
	self.startButton:addEventListener("touch", self.startButton);
	
	self.levelsButton = display.newImage("images/levels.jpg");
	self.levelsButton.y = 100;
	self.levelsButton.x = -1*self.levelsButton.width/2;
	transition.to(self.levelsButton,{time=200,delay=100,x=display.contentWidth/2});
	
	self.continueButton = display.newImage("images/continue.gif");
	self.continueButton.y = 150;
	self.continueButton.x =-1*self.continueButton.width/2;
	transition.to(self.continueButton,{time=200,delay=200,x=display.contentWidth/2});
	
	self.helpButton = display.newImage("images/help.gif");
	self.helpButton.y = 200;
	self.helpButton.x = -1*self.helpButton.width/2;
	transition.to(self.helpButton,{time=200,delay=300,x=display.contentWidth/2});
	
	
end

function Menu.startButtonPressed(self)
	print "start game";
	
	transition.to(self.startButton,{time=200,delay=0,x=display.contentWidth+self.startButton.width/2});
	transition.to(self.levelsButton,{time=200,delay=100,x=display.contentWidth+self.levelsButton.width/2});
	transition.to(self.continueButton,{time=200,delay=200,x=display.contentWidth+self.continueButton.width/2});
	transition.to(self.helpButton,{time=200,delay=300,x=display.contentWidth+self.helpButton.width/2,onComplete=Menu.hideAnimatinDone});
	
end

function Menu.hideAnimatinDone()
	GameManager:startGame();
	Menu.remove(Menu);
end

function Menu.remove(self)
	display.remove(self.startButton);
end

function Menu.touches(event)
	if event.phase == 'ended' then 
		
	end
end
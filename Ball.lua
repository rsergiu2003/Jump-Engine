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
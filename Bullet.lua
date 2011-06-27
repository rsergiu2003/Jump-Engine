
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
	print (distance);
	
	xDiff = x - ball.image.x;
	yDiff = ball.image.y-y;
	
	xAspect = xDiff/distance;
	yAspect = yDiff/distance;
	
	maxSpeed = 30;
	self.xSpeed = maxSpeed*xAspect;
	self.ySpeed = maxSpeed*yAspect;
	
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
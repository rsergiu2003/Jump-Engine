
Monster = {image=0, x=0, y=0,w=50,h=50,frame,index,xSpeed=1,ySpeed=0}

Monster.metatable = { __index = Monster };
Monster.new = function(x,y)
	local self = {}
	setmetatable(self, Monster.metatable);

	self.image = display.newImage("Images/monster1.png");

	self.image.x = x;
	self.image.y = y;

	self.x = x;
	self.y = y;

	self.frame = Rect.new();
	self.frame.x = x - self.w/2;
	self.frame.y = y - self.h/2;
	self.frame.w = self.w;
	self.frame.h = self.h;
	
	return self;
end

function Monster:update ()
	
	self.x = self.x+self.xSpeed;
	self.y = self.y+self.ySpeed;
	
	convertToLocalScreen(self.image,self.x,self.y);
	
	self.frame.x = self.x - self.w/2;
	self.frame.y = self.y - self.h/2;
	
	if self.x>display.contentWidth then
		self.xSpeed = self.xSpeed*-1;
	end
	if self.x<0 then
		self.xSpeed = self.xSpeed*-1;
	end
end
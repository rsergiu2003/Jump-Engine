
Bullet = {image, x=0, y=0,w=10,h=10,frame,index,xSpeed=0,ySpeed=0}

Bullet.metatable = { __index = Bullet };
Bullet.new = function(x,y)
	local self = {}
	setmetatable(self, Bullet.metatable);
	
	return self;
end
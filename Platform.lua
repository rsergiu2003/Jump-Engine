
Platform = {image=0, x=0, y=0,w=50,h=30,frame,index}

platformIndex = 0;

Platform.metatable = { __index = Platform };
Platform.new = function(name)
	local self = {}
	setmetatable(self, Platform.metatable);

	if name ~= nil then self:setName(name); end
	
	self.frame = Rect.new();
	self.frame.w = self.w;
	self.frame.h = self.h;
	
	self.index = platformIndex;
	platformIndex = platformIndex + 1;
	return self;
end

function Platform:init (x,y)
	self.image = display.newImage('Images/ground.png');
	self.x = x;
	self.y = y;
	
	self.frame.x = self.x;
	self.frame.y = self.y;
end

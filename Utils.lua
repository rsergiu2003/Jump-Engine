--My Constants
__SCREEN_HEIGHT__ = display.contentHeight - 48;



Point = {x,y}

Point.metatable = { __index = Point };
Point.new = function(x,y)
	local self = {}
	setmetatable(self, Point.metatable);
	
	self.x = x;
	self.y = y;
	
	return self;
end

Rect = {x=0, y=0,w=0,h=0}

Rect.metatable = { __index = Rect };
Rect.new = function(x,y,w,h)
	local self = {}
	setmetatable(self, Rect.metatable);
	
	self.x = x;
	self.y = y;
	self.w = w;
	self.h = h;
	
	return self;
end

function rectIntersectsRect(rectA, rectB)
	
	local ax1,ax2,ay1,ay2,bx1,bx2,by1,by2 = 0;
	
	ax1 = math.min(rectA.x,rectA.x+rectA.w);
	ay1 = math.min(rectA.y,rectA.y+rectA.h);
	ax2 = math.max(rectA.x,rectA.x+rectA.w);
	ay2 = math.max(rectA.y,rectA.y+rectA.h);
	
	bx1 = math.min(rectB.x,rectB.x+rectB.w);
	by1 = math.min(rectB.y,rectB.y+rectB.h);
	bx2 = math.max(rectB.x,rectB.x+rectB.w);
	by2 = math.max(rectB.y,rectB.y+rectB.h);
	
	--print (rectA.x .." "..rectB.x);
	
	if ax1 < bx2 and ax2 > bx1 and ay1 < by2 and ay2 > by1 then
		return true
	else
		return false
	end
end

function rectContainsPoint(rect,point)
	--like this to make sure we have shortcircuit
	if point.x > rect.x then
	if point.y > rect.y then
	if point.x < rect.x+rect.w then
	if point.y < rect.y+rect.h then
			return true;
	end end end end
	return false;
end

function calculatePointsDistance(p1,p2)
	diffX = p1.x-p2.x;
	diffY = p1.y-p2.y;
	
	return math.sqrt(diffX*diffX+diffY*diffY);
end
function convertToLocalScreen (image,x,y) 
	image.y = __SCREEN_HEIGHT__ - y;
	image.x = x;
--[[

	if image.y>0 and image.y<480 then 
		image.isVisible = true;
	else
		image.isVisible = false;
	end

--]]
end
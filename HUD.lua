HUD_ = {group,distance}

HUD_.metatable = { __index = HUD_ };
HUD_.new = function(name)
	local self = {}
	setmetatable(self, HUD_.metatable);

	self.group = display.newGroup();

	self.distance = display.newText( "Distance: 0", 0, 0, "Helvetica", 16 )
	self.distance:setTextColor(255, 255, 255)

	self.group:insert(self.distance);
	
	self.group.isVisible = true;
	
	return self;
end

HUD = HUD_.new();
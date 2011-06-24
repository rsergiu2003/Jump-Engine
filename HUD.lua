HUD_ = {group,distance,pause}

HUD_.metatable = { __index = HUD_ };
HUD_.new = function()
	local self = {}
	setmetatable(self, HUD_.metatable);

	self.group = display.newGroup();

	self.distance = display.newText( "Distance: 000000", 0, 0, "Helvetica", 16 )
	self.distance:setTextColor(255, 255, 255)
	self.group:insert(self.distance);
	
	self.pause = display.newImage("Images/pause.png");
	self.group:insert(self.pause);
	self.pause.x = display.contentWidth - 30;
	function self.pause:touch(event)
			if event.phase == 'ended' then
				GameManager:pauseGame();
				Menu.showMenu(Menu);
			end
	end
	self.pause:addEventListener("touch", self.pause);
	
	self.group.isVisible = true;
	return self;
end

function HUD_:updateDistance (distance)
	self.distance.text = "Distance: " .. distance;
end

function HUD_:showHUD ()
	self.group.isVisible = true;
end

function HUD_:hideHUD ()
	self.group.isVisible = false;
end

HUD = HUD_.new();
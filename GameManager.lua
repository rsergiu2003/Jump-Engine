GameManager_ = {pause=true};

GameManager_.metatable = { __index = GameManager_ };
GameManager_.new = function(name)
	local self = {}
	setmetatable(self, GameManager_.metatable);

	if name ~= nil then self:setName(name); end
	
	return self;
end

local function onAccelerate (event)
	ball.speedX = event.xGravity*700;
end

local function testAccel () 
	event = {}
	event.xGravity = remote.xGravity;
	onAccelerate(event);
end

function GameManager_:startGame ()
	ball = Ball;
	ball.init(ball);

	lastTime = system.getTimer();

	maxY = 0;
	
	ball.x = 240;
	ball.y = 100;
	
	GameManager:morePlatforms(__NUMBER_OF_PLATFROMS__,0);
	
	--Runtime:addEventListener ("accelerometer", onAccelerate);
	Runtime:addEventListener( "enterFrame" , testAccel);
	Runtime:addEventListener("enterFrame", gameLoop);
end

function GameManager_:morePlatforms(nr_platforms,offset) 
	for i=1, nr_platforms do
		local aPlatform = Platform.new();
		aPlatform:init(math.random(20,300),i*50+offset)
		table.insert(platforms,1,aPlatform);
	end
	maxY = (nr_platforms+1)*50+offset;
end

latestYOffset = 0;
function GameManager_:centerMap()
	--calculate offsets
	local xOffset = 0;
	local yOffset = 0;
	if ball.y > 240 then
		yOffset = ball.y - 240;
	end
	
	if yOffset < latestYOffset then 
		--yOffset = latestYOffset;
	end
	
	latestYOffset = yOffset;

	convertToLocalScreen(ball.image,ball.x+xOffset,ball.y-yOffset);
	for i=0, table.maxn(platforms)-1 do
		if platforms[i] ~= nil then	
			convertToLocalScreen(platforms[i].image,platforms[i].x,platforms[i].y-yOffset);
		end
	end
end

function GameManager_:clearPlatforms () 

	for j=0, table.maxn(platforms)-1 do
		if platforms[j] ~= nil then
			if (ball.y - platforms[j].y) > 300 then
					display.remove(platforms[j].image);
					table.remove(platforms,j);
			end
		end
	end
 end

GameManager = GameManager_.new();
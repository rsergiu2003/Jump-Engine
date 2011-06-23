--Testing accelerometer
local remote = require("remote")
-- Start The Remote On Port 8080
remote.startServer( "8080" )


require ("Utils");
require ("Platform");
require ("Ball");
require ("HUD");
require ("GameManager");
require ("Menu")

system.setIdleTimer( false );
display.setStatusBar(display.HiddenStatusBar);

__NUMBER_OF_PLATFROMS__ = 101;

platforms = {}


lastTime = 0;
function gameLoop ()
	--print ("loop"..ball.y);
	deltaT = system.getTimer()-lastTime;
	lastTime = system.getTimer();
	ball.update(ball,deltaT);
	for i=0, table.maxn(platforms)-1 do
		test = ball.testOverPlatform(ball,platforms[i]);
		if test then
			if ball.speedY<0 then
				ball.speedY = 600;
			end
		else
		end
		
	end
	GameManager:clearPlatforms();
	GameManager:centerMap ();
	if maxY - ball.y <1000 then 
		GameManager:morePlatforms (50,maxY);
	end
	
	HUD:updateDistance(math.floor(latestYOffset/3));
end

Menu.showMenu(Menu);
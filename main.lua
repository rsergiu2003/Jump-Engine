--[[

	Created by Rosu Sergiu on 27/Jun/2011

	Jump Engine it's a game engine for createing jumping games for mobile devices.

	This file is part of Jump Engine.

    Jump Engine is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Jump Engine is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Jump Engine.  If not, see <http://www.gnu.org/licenses/>.

	Copyright (C) 2011  Rosu Sergiu
--]]
--system.setIdleTimer( false );
display.setStatusBar(display.HiddenStatusBar);

--Testing accelerometer
--local remote = require("remote")
-- Start The Remote On Port 8080
--remote.startServer( "8080" )

require ("Utils");
require ("Platform");
require ("Monster");
require ("Bullet");
require ("Ball");
require ("HUD");
require ("GameManager");
require ("Menu");

__NUMBER_OF_PLATFROMS__ = 50;

platforms = {} -- the platforms
mobsters =  {} -- the monsters
bullets = {} -- the bullets

HUD:hideHUD();

lastTime = 0;
function gameLoop ()
	--print ("loop"..ball.y);
	deltaT = system.getTimer()-lastTime;
	lastTime = system.getTimer();
	ball.update(ball,deltaT);
	
	--test if a platform it's hit
	for i=1, table.maxn(platforms) do
		test = ball.testOverPlatform(ball,platforms[i]);
		if test then
			if ball.speedY<0 then
				ball.speedY = 600;
			end
		end
	end
	
	--test if we hit a monster
	for i=table.maxn(mobsters),1,-1  do
		if mobsters[i]~=nil then
			test = rectIntersectsRect(ball.frame,mobsters[i].frame);
			mobsters[i]:update();
			if test then
				display.remove(mobsters[i].image);
				table.remove(mobsters,i);
	--[[
				GameManager:pauseGame();
				Menu.showGameOver(Menu);
	--]]
			end
		end
	end	
	
	--update and test the bullets
	for i=table.maxn(bullets),1,-1 do
		if bullets ~= nil then
			if bullets[i]:update() == false then
				--will return false if it have to be removed
				display.remove(bullets[i].image);
				table.remove(bullets,i);
			else
				-- if it's ok check over monsters
				for j=table.maxn(mobsters),1,-1  do
					if mobsters[j]~=nil then
						if rectContainsPoint(mobsters[j].frame,Point.new(bullets[i].x,bullets[i].y))==true then
							display.remove(mobsters[j].image);
							table.remove(mobsters,j);
						end
					end
				end
			end
		end
	end
	
	GameManager:clearPlatforms();
	GameManager:centerMap ();
	if maxY - ball.y <1000 then 
		GameManager:morePlatforms (50,maxY);
	end
	
	HUD:updateDistance(math.floor(latestYOffset/3));
	--print ("platforms: "..table.maxn(platforms)..", monsters: "..table.maxn(mobsters)..", bullets: "..table.maxn(bullets));
end


function touch(event)
	GameManager:touchOnScreen(event);
end
Menu.createMenu(Menu);


-- add the ads

local adSpace
function showAd(event)
	-- Is the url a remote call?
	if string.find(event.url, "http://", 1, false) == 1 then
		-- Is it a call to the admob server?
		if string.find(event.url, "c.admob.com", 1, false) == nil then
			adSpace.url = event.url
		else
			-- an actual click on an ad, so open in Safari
			system.openURL(event.url)
		end
	else
		print("loading an ad")
		return true
	end
end

adSpace = native.showWebPopup(0, 432, 320, 48, "ad.html", {baseUrl = system.ResourceDirectory, hasBackground = false, urlRequest = showAd})


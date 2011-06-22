-- Corona® Remote
--
-- Date: January 31, 2011
--
-- Version: 1.2
--
-- File name: remote.lua
--
-- Author: Matthew Pringle
--
-- Update History: v1.1 Intergrated Compass - v1.2 Intergrated Asynchronous Connection
--
-- Comments: Please see http://www.coronaremote.com/ for more information
--
-- Copyright (C) 2011 Matthew Pringle All Rights Reserved
------------------------------------------------------------------------------------------------------------------------

module(..., package.seeall)

------------------------------------------------------------------------------------------------------------------------
-- Load Socket
local socket = require("socket")

------------------------------------------------------------------------------------------------------------------------
-- System Type
local systemType = system.getInfo( "environment" )

------------------------------------------------------------------------------------------------------------------------
-- Initial Values
local tcpServer = false
local tcpServerStatus = false
local connectionKey = "CORONAREMOTE1.2"
local connectionResponseKey = "CORONAREMOTE1.2CONNECTED"
local errorCount = 0
local remoteIP = false
local port = "8080"
xGravity = 0
yGravity = 0
zGravity = 0
xInstant = 0
yInstant = 0
zInstant = 0
magnetic = -1
compass = false
isShake = false

------------------------------------------------------------------------------------------------------------------------
-- Decode Communication
local function decodeCommunication( str )
	
	local t = {}
	local function helper( line ) table.insert( t , line ) return "" end
	helper( ( str:gsub( "(.-)*" , helper ) ) )
	return t

end

------------------------------------------------------------------------------------------------------------------------
-- Check IP
function isIP( ipv4 )

	if ipv4 == false then
		return false
	end
	local retval = false
	local nums = {}
	local iplen = string.len( ipv4 )
	if (iplen < 7 or iplen > 15) then
		return false
	end
	nums = { ipv4:match ("^(%d+)%.(%d+)%.(%d+)%.(%d+)$") }
	if ( nums[1] == nil or nums[2] == nil or nums[3] == nil or nums[4] == nil ) then
		return false
	end
	if ( tonumber( nums[1]) > 255 or tonumber(nums[2]) > 255 or tonumber(nums[3]) > 255 or tonumber(nums[4]) > 255 ) then
		return false
	end
	return true

end

------------------------------------------------------------------------------------------------------------------------
-- Accelerometer System Event
local function accelerometer( event )
	
	if event.isShake ~= true then
		
		xGravity = event.xGravity
		yGravity = event.yGravity
		zGravity = event.zGravity
		xInstant = event.xInstant
		yInstant = event.yInstant
		zInstant = event.zInstant
		isShake = false
	
	else
	
		isShake = true
	
	end
	
end

------------------------------------------------------------------------------------------------------------------------
-- Asynchronous Connection
local function asynchronousConnection( event )
	
	if ( event.isError ) then
		
		-- Reset Values
		xGravity = 0
		yGravity = 0
		zGravity = 0
		xInstant = 0
		yInstant = 0
		zInstant = 0
		isShake = false
		magnetic = -1
		errorCount = 60
	
	else
		
		-- Reset Timeout
		errorCount = 0

		-- Decode Message
		tcpClientMessage = decodeCommunication( event.response )
				
		-- Update Values
		xGravity = tonumber( tcpClientMessage[ 1 ] )
		yGravity = tonumber( tcpClientMessage[ 2 ] )
		zGravity = tonumber( tcpClientMessage[ 3 ] )
		xInstant = tonumber( tcpClientMessage[ 4 ] )
		yInstant = tonumber( tcpClientMessage[ 5 ] )
		zInstant = tonumber( tcpClientMessage[ 6 ] )
		isShake = tcpClientMessage[ 7 ]
		if isShake == "1" then
			isShake = true
		else
			isShake = false
		end
		if compass == true then
			magnetic = tonumber( tcpClientMessage[ 8 ] )
		end

		-- Check Valid IP
		if isIP( remoteIP ) == true and tcpServerStatus == "asynchronous" then
	
			-- Next Asynchronous Connection
			network.request( "http://"..remoteIP..":"..port , "GET" , asynchronousConnection )

		end
	
	end

end

------------------------------------------------------------------------------------------------------------------------
-- Create TCP Server
local function createTCPServer( port )
	
	-- Create Socket
	local tcpServerSocket , err = socket.tcp()
	local backlog = 0
	
	-- Check Socket
	if tcpServerSocket == nil then 
		return nil , err
	end
	
	-- Allow Address Reuse
	tcpServerSocket:setoption( "reuseaddr" , true )
	
	-- Bind Socket
	local res, err = tcpServerSocket:bind( "*" , port )
	if res == nil then
		return nil , err
	end
	
	-- Check Connection
	res , err = tcpServerSocket:listen( backlog )
	if res == nil then 
		return nil , err
	end
	
	-- Return Server
	return tcpServerSocket
	
end

------------------------------------------------------------------------------------------------------------------------
local function startTCPServer()
	
	-- Create Server
	tcpServer , _ = createTCPServer( port )

end

------------------------------------------------------------------------------------------------------------------------
-- Run TCP Server
local function runTCPServer()

	-- Set Timeout
	tcpServer:settimeout( 0 )
	
	-- Set Client
	local tcpClient , _ = tcpServer:accept()

	-- Get Message
	if tcpClient ~= nil then

		local tcpClientMessage , _ = tcpClient:receive('*l')

		if ( tcpClientMessage ~= nil ) then

			if tcpClientMessage == connectionKey then
				
				-- Get IP Address Of Corona Remote
				remoteIP = tcpClient:getpeername()
				
				-- Send Response
				local communication = connectionResponseKey
				tcpClient:send( communication .. "\n" )
				
				-- Check Valid IP
				if isIP( remoteIP ) == true and tcpServerStatus == "tcp" then
					
					-- Reset Timeout
					errorCount = 0
					
					-- Stop TCP Server
					tcpServerStatus = "asynchronous"
					tcpClient:close()
					tcpServer:close()
				
					-- Start Asynchronous Connection
					network.request( "http://"..remoteIP..":"..port , "GET" , asynchronousConnection )
				
				end
			
			end
													
		end

		-- Close Connection
		tcpClient:close()

	end

end

------------------------------------------------------------------------------------------------------------------------
-- Connection Loop
local function connectionLoop()
	
	-- Asynchronous Server Timeout
	if tcpServerStatus == "asynchronous" then
		
		-- Increase Timeout
		errorCount = errorCount + 1
		
		if errorCount >= 60 then
			
			-- Reset Values
			xGravity = 0
			yGravity = 0
			zGravity = 0
			xInstant = 0
			yInstant = 0
			zInstant = 0
			isShake = false
			magnetic = -1
			errorCount = 0
			
			-- Start TCP Server
			tcpServerStatus = "tcp"
			remoteIP = false
			startTCPServer()
		
		end
	
	elseif tcpServerStatus == "tcp" then
		
		runTCPServer()
	
	end

end

------------------------------------------------------------------------------------------------------------------------
-- Start Server
function startServer( newPort )
	
	if systemType == "simulator" then
	
		-- Set Port
		port = newPort
		
		-- Start TCP Server
		startTCPServer()
	
		-- Start Network Listener
		tcpServerStatus = "tcp"
		Runtime:addEventListener( "enterFrame" , connectionLoop )
	
	else
		
		-- Start Accelerometer
		Runtime:addEventListener( "accelerometer" , accelerometer )
	
	end

end

------------------------------------------------------------------------------------------------------------------------
-- Stop Server
function stopServer()
	
	if systemType == "simulator" then
	
		-- Stop Network Listener
		Runtime:removeEventListener( "enterFrame" , connectionLoop )
		
		-- Close Server
		tcpServer:close()
		tcpServer = nil
	
	else
	
		-- Stop Accelerometer
		Runtime:removeEventListener( "accelerometer" , accelerometer )
	
	end
	
	-- Reset Values
	tcpServerStatus = false
	remoteIP = false
	errorCount = 0
	xGravity = 0
	yGravity = 0
	zGravity = 0
	xInstant = 0
	yInstant = 0
	zInstant = 0
	isShake = false
	magnetic = -1

end

------------------------------------------------------------------------------------------------------------------------
-- Update Compass
local function updateCompass( event )
	
	-- Get Magnetic Compass Value
	magnetic = event.magnetic

end

------------------------------------------------------------------------------------------------------------------------
-- Start Compass
function startCompass()
	
	if systemType == "simulator" then
	
		compass = true
	
	else
		
		Runtime:addEventListener( "heading", updateCompass )
	
	end
	
end

------------------------------------------------------------------------------------------------------------------------
-- Stop Compass
function stopCompass()

	if systemType == "simulator" then
	
		compass = false
		magnetic = -1
	
	else
	
		Runtime:removeEventListener( "heading", updateCompass )
		magnetic = -1
	
	end

end

------------------------------------------------------------------------------------------------------------------------
-- Return Values

function xGravityRemote()
	return xGravity
end

function yGravityRemote()
	return yGravity
end

function zGravityRemote()
	return zGravity
end

function xInstantRemote()
	return xInstant
end

function yInstantRemote()
	return yInstant
end

function zInstantRemote()
	return zInstant
end

function isShakeRemote()
	return isShake
end

function accelerometerRemote()
	return xGravity , yGravity , zGravity , xInstant , yInstant , zInstant , isShake
end

function magneticRemote()
	return magnetic
end
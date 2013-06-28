module( ..., package.seeall )

local storyboard = require "storyboard"

-- Game Scene
local sceneGame = storyboard.newScene()

local physics = require "physics"
physics.start( "true" )

-- Gravity is 0 by default
physics.setGravity(0,0)

local Player = require "player"
local Ghost = require "ghost"
local monster
local coins = {}
local group = display.newGroup()
local pos = display.contentHeight * 0.8

local positions = {}
local ghostIcon
local Item = require "item"
local Magnet = require "magnet"
local Balloon = require "balloon"
local Velocity = require "velocity"
local mg
local ball
local wall, wall2
local enter = false
local velo = 15 -- group movement speed
local first = false
local posGhost = 1
local trans = transition.to( group, { y = group.y, time = 10 } )
local active = true
local ind = 1
local textNumber
local gravity = 20
local balloonEnabled = false
local tim = timer.performWithDelay( 0, function() physics.setGravity( 0,0 )end, 1 )
local timerBalloon = timer.performWithDelay( 0, function() physics.setGravity( 0,0 )end, 1 )


-- Calculate euclidean distance from coin to player when magnet is enabled
local function distance( position )

	if coins[position]:getX() ~= nil and coins[position]:getY()~= nil then
		local A = math.pow( (monster:getX() - coins[position]:getX() ),2 )
		local B = math.pow( (monster:getY() - coins[position]:getY() ),2 )
		return math.sqrt( A + B )
	else
		return 1000
	end

end

-- Animate a coin to the player if it is within the radius
local function attract( event )
	for i = ind, ind + 39 do
		if distance( i ) < mg:getRadius() then
			coins[i]:anim( monster:getX(), monster:getY() )			
		end
	end
	if ind + 39 < #coins - 1 then
		ind = ind + 10
	end
end

--function for accelerometer
local function acc(e)  
    gravedadX = e.xInstant
	
	transition.to( monster, { x = monster:getX() + (100.6666 * ( gravedadX ) ), time = 100 } )

end 

--Animate the group that contains background and items

local function moveGrupo()

	trans = transition.to( group, { y = group.y + velo, time = 10, onComplete = moveGrupo } )
	monster:setY( monster:getY() - velo )

	-- if the player falls down under a certain thresold the game is over
	if monster.yOrigin + group.y > ( display.contentHeight*0.8 )  then
		transition.cancel( trans )
		storyboard:gotoScene( "sceneMenu" )
	end

end

-- this function watches that the player doesn't surpass a certain thresold
local function setLimit(event)

	if math.abs( monster:getY() + group.y ) < display.contentHeight * 0.3 then

		monster:setY( display.contentHeight * 0.3 - group.y )
		monster:setLinearVelocity(0,0)

		if first == false then
			first = true
			moveGrupo( )
		end
	end
end

--Save on file the ghost's position
local function savePosGhost(event)
	ghostIcon:add( monster:getX(), monster:getY() )
end

--Get ghost's position
local function drawGhost( event )
	if posGhost < ghostIcon:size() then
		ghostIcon.x, ghostIcon.y = ghostIcon:get( posGhost )
	else
		Runtime:removeEventListener( "enterFrame", drawGhost )
	end
	posGhost = posGhost + 2
end


-- Remove a item if it collides with the player
local function collisionWithItem( self, event )
	if event.phase == "began" then

		--if item is a magnet, enabled magnet
		if event.other:getName() == "magnet" then
			mg:enabledRadius( true )
			Runtime:addEventListener( "enterFrame", attract )
			timer.performWithDelay( 2500, function( ) Runtime:removeEventListener( "enterFrame", attract ) mg:enabledRadius( false ) end, 1 )
		end

		--if item is a balloon, enabled balloon
		if event.other:getName() == "balloon" then
			balloonEnabled = true
			gravity = ball:getGravity()
		end


		-- Set gravity a 0 because player collides with an item
		physics.setGravity( 0,0 )

		timer.cancel( tim )
		timer.cancel( timerBalloon )
		if event.other:getName() == "velocity" then
			velo = vl:getSpeed()
			timer.performWithDelay( 2000, function() velo = 15 end, 1 )
			--velo = 20
		end

		if active == false then
			active = true
			velo = 15
			Runtime:addEventListener("enterFrame", setLimit)
		end

		-- Apply an impulse
		if ( monster:getY() + group.y ) > (display.contentHeight * 0.3) then
			monster:applyLinearImpulse( 0, -20.5, monster:getX(), monster:getY() )
		end

		-- if there is not collision with the player in a few seconds, apply gravity
		tim = timer.performWithDelay( 1000, function() 
												velo = -15
												active = false 
												Runtime:removeEventListener( "enterFrame", setLimit ) 
												physics.setGravity( 0,gravity ) 
												if balloonEnabled then 
													balloonEnabled = false
													-- timer for the duration of balloon
													timerBalloon = timer.performWithDelay( 2500, function() gravity = 20 physics.setGravity( 0,gravity )  end, 1 ) 
												end
											end, 1 )
		--remove item
		display.remove( event.other )
		event.other = nil
		
	end
end


--start the game applying a impulse to the player and initializing the different events
local function startGame( )

	display.remove( textNumber )
	textNumber = nil
	monster.isSleepingAllowed = false

	monster:applyLinearImpulse( 0, -150, monster:getX(), monster:getY() )
	Runtime:addEventListener("enterFrame", setLimit)
	Runtime:addEventListener("accelerometer", acc) 

	f = ghostIcon:openFile()
	if f then
		Runtime:addEventListener("enterFrame", drawGhost)
		Runtime:addEventListener("enterFrame",savePosGhost)
	else
		Runtime:addEventListener("enterFrame",savePosGhost)
	end
end



-- animation at the beginning of the game
local function animation( number )

	if number == 3 then
		transition.to( textNumber, { alpha = 0, xScale = 1, yScale = 1, time = 1000, onComplete = function() textNumber.text = "2" animation( 2 ) end } )
	elseif number == 2 then
			textNumber.alpha = 1
			textNumber.xScale = 4
			textNumber.yScale = 4
			transition.to( textNumber, { alpha = 0, xScale = 1, yScale = 1, time = 1000, onComplete = function() textNumber.text = "1" animation( 1 ) end } )
		elseif number == 1 then
				textNumber.alpha = 1
				textNumber.xScale = 4
				textNumber.yScale = 4
				transition.to( textNumber, { alpha = 0, xScale = 1, yScale = 1, time = 1000, onComplete = function() textNumber.text = "GO!" animation( 0 ) end } )
			elseif number == 0 then
				textNumber.alpha = 1
				transition.to( textNumber, { alpha = 0, time = 500, onComplete = startGame } )
	end
end

-- create the scene with the display objects
function sceneGame:createScene( event )

	wall = display.newImage( "wall1.jpg" )
	wall:rotate(90)
	wall.x = display.contentWidth * 0.5
	wall.y = - wall.contentHeight * 0.05

	wall2 = display.newImage( "wall1.jpg" )
	wall2:rotate(90)
	wall2.x = display.contentWidth * 0.5
	wall2.y = - wall.contentHeight - wall.contentHeight * 0.05

	group:insert( wall )
	group:insert( wall2 )

	mg = Magnet.new( )
	mg:setX(display.contentWidth * 0.5)
	mg:setY(display.contentHeight * 0.7)

	group:insert( mg )
	
	
	vl = Velocity.new( )
	vl:setX(250)
	vl:setY(200)

	group:insert( vl )

	

	ball = Balloon.new( )
	ball:setX( display.contentWidth * 0.4 )
	ball:setY( display.contentHeight * 0.4 )

	group:insert( ball )


	monster = Player.new( )
	monster:setX( display.contentWidth * 0.5 )
	monster:setY( display.contentHeight * 0.9 )


	for i=1, 1000 do
		coins[i] = Item.new( "coin.png", 25, 25 )
		coins[i]:setX( math.random( 50, display.contentWidth - 50 ) )
		coins[i]:setY( pos )

		pos = pos-50
		group:insert( coins[i] )
	end


	group:insert(monster)

	ghostIcon = Ghost.new()
	ghostIcon:setXY( monster:getX(), monster:getY() )

	group:insert( ghostIcon )

	textNumber = display.newText( "3", display.contentWidth * 0.4, display.contentHeight * 0.4, nil, 80 )
	textNumber.xScale = 4
	textNumber.yScale = 4


end


function sceneGame:enterScene( event )
	monster.collision = collisionWithItem
	monster:addEventListener("collision", monster)
	animation( 3 )
end

function sceneGame:exitScene( event )
	Runtime:removeEventListener("enterFrame", setLimit)
	Runtime:removeEventListener("accelerometer", acc)
	Runtime:removeEventListener("enterFrame", drawGhost)
	Runtime:removeEventListener("enterFrame",savePosGhost)
	monster:removeEventListener("collision", monster)
	storyboard.purgeScene( "sceneGame" )

end

function sceneGame:destroyScene( event )
	monster:clean()
	mg:clean()
	ball:clean()
	--vl:clean()

	for i = 1, #coins do
		coins[i]:clean()
	end

	display.remove( ghostIcon )
	ghostIcon = nil
	display.remove( wall )
	wall = nil
	display.remove( wall2 )
	wall2 = nil

	pos = display.contentHeight * 0.8
	group.x = 0
	group.y = 0
	physics.setGravity( 0,0 )
	enter = false
	first = false
	balloonEnabled = false
	posGhost = 1
	ind = 1

end

sceneGame:addEventListener( "createScene", sceneGame )
sceneGame:addEventListener( "enterScene", sceneGame )
sceneGame:addEventListener( "exitScene", sceneGame )
sceneGame:addEventListener( "destroyScene", sceneGame )

return sceneGame


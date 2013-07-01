module( ..., package.seeall )

--Class player
function new()
	local player = display.newImageRect( "player.png", 41, 53 )
	player.name = "player"

	physics.addBody( player, { radius = 20, density = 0.5 } )

	function player:setX( x )
		player.x = x
	end

	function player:setY( y )
		player.y = y
	end

	function player:getX( )
		return player.x
	end

	function player:getY( )
		return player.y
	end

	function player:clean( )
		display.remove( player )
		player = nil
	end

	return player
end


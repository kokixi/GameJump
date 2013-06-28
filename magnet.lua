module( ..., package.seeall )

--Class Magnet inherits from Item
function new()
	local magnet = require("item").new( "magnet.png", 30, 28 )
	magnet.name = "magnet"
	magnet.radius = 150 --Maximum radius a coin is attracted from
	magnet.enabled = false --If magnet is taking effect or not

	function magnet:setRadius( r )
		self.radius = r
	end

	function magnet:getRadius( )
		return self.radius
	end

	function magnet:enabledRadius( status )
		self.enabled = status
	end

	function magnet:getEnabledRadius( )
		return self.enabled
	end

	return magnet

end


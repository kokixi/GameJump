module( ..., package.seeall )

-- Class velocity
function new()
	local velocity = require("item").new( "rocket.png" )
	velocity.name = "velocity"
	velocity.speed = 30 --Maximum radius a coin is attracted from
	velocity.enabled = false --If velocity is taking effect or not

	function velocity:setSpeed( v )
		self.speed = v
	end

	function velocity:getSpeed( )
		return self.speed
	end

	function velocity:enabledRadius( status )
		self.enabled = status
	end

	function velocity:getEnabledRadius( )
		return self.enabled
	end

	return velocity

end

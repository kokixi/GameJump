module( ..., package.seeall )

--Class Balloon inherits from Item
function new()
	local balloon = require("item").new("balloon.png", 28, 55 )
	balloon.name = "balloon"
	balloon.gravity = 1 --Value for gravity when player pick up this item

	function balloon:getGravity( )
		return self.gravity
	end

	return balloon
end


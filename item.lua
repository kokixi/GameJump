module( ..., package.seeall )


-- Class Item
function new( image, dimX, dimY )
	--The item is a coin by default
	local item = display.newImageRect( image, dimX, dimY )
	item.name = "coin"
	physics.addBody( item, "static", { isSensor = true, radius = 20, bounce = 0.2 } )

	function item:getName( )
		return self.name
	end

	function item:anim( xd,yd )
		transition.to( self, { x = xd, y = yd - 30, time = 80 } )
	end

	function item:setX( x )
		self.x = x
	end

	function item:setY( y )
		self.y = y
	end

	function item:getX( )
		return self.x
	end

	function item:getY( )
		return self.y
	end

	function  item:clean( )
		display.remove( self )
		self = nil
	end

	return item
end

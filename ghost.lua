module( ..., package.seeall )

--Class mode ghost
function new()
	local ghost = display.newCircle( 0, 0, 30 ) -- temporary ghost to be redefined
	ghost:setFillColor( 255,0,0 )
	ghost.alpha = 0.3
	local path = system.pathForFile( "ghostmode.txt", system.DocumentsDirectory ) --file to save player's positions 
	local archivo = io.open( path, "r+" )
	local positions = {}
	
	function ghost:openFile()
		
		if archivo then
			local j = 1
			for line in archivo:lines() do
				positions[j] = line 
				j = j + 1
			end
			io.close( archivo )
			archivo = io.open( path, "w" )
			return true
		else
			archivo = io.open( path, "w" )
			return false
		end

	end

	function ghost:setXY( x,y )
		ghost.x = x
		ghost.y = y
	end
	--write in file the positions x and y
	function ghost:add( x,y )
		archivo:write( x .. "\n" )
		archivo:write( y .. "\n" )
	end
	--get the positions x and y from file
	function ghost:get(i)
		return positions[i], positions[i+1]
	end

	function ghost:size( )
		return #positions
	end

	function ghost:clean( )
		for i=1,#positions do
			positions[i] = nil
		end
	end


	return ghost

end


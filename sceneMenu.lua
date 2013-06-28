module( ..., package.seeall )

local storyboard = require "storyboard"

-- Menu Scene

local sceneMenu = storyboard.newScene()

local bPlay

local function changeScene( event )
	if event.phase == "ended" then
		--Load Game Scene
		storyboard.gotoScene( "sceneGame" )
	end
end

function sceneMenu:createScene( event )
	bPlay = display.newRoundedRect( 0,0,200,90,20 )
	bPlay.x = display.contentWidth * 0.5
	bPlay.y = display.contentHeight * 0.5
	bPlay.text = display.newText( "Play",0,0,nil,40 )
	bPlay:setReferencePoint(display.CenterReferencePoint)
	bPlay.text.x = bPlay.x
	bPlay.text.y = bPlay.y
	bPlay.text:setTextColor(0,0,0)
end

function sceneMenu:enterScene( event )
	bPlay:addEventListener( "touch", changeScene )
end

function sceneMenu:exitScene( event )
	bPlay:removeEventListener( "touch", changeScene )
	storyboard.purgeScene( "sceneMenu" )
end

function sceneMenu:destroyScene( event )
	display.remove( bPlay.text )
	bPlay.text = nil
	display.remove( bPlay )
	bPlay = nil
end

sceneMenu:addEventListener( "createScene", sceneMenu )
sceneMenu:addEventListener( "enterScene", sceneMenu )
sceneMenu:addEventListener( "exitScene", sceneMenu )
sceneMenu:addEventListener( "destroyScene", sceneMenu )

return sceneMenu
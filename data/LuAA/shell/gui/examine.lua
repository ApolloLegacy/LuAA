--[[
                     _               ____ ____
                    | |             / _  |  _ \
                    | |      __  __/ /_| | |_\ \ 
                    | |     / / / /  __  |  __  \
                    | |____/ /_/ /  /  | | |  \  \ 
                    |______\____/__/   |_|_|   \__\
                    
    Name :          LuAA - examine.lua
                    Constructs methods for drawing/updating the examine GUI.
    Purpose :        
                    LuAA is a mobile visual novel application programmed in an open-source distribution of the extensible language, Lua, namely MicroLua. MicroLua is designed for ARM hardware architecture, specifically for an ARM7/ARM9 processor configuration found in the Nintendo DS. Thus, it disallows allocation of memory past 4MB, internally. It is packaged with the compiled (proprietary) ARM7/ARM9 binaries to prevent user manipulation. However, the front-end programmed in MicroLua is powerful enough for user customizability (re-compile all included files using NDSTool -> Pack to compile a .nds file). LuAA placed 1st in the Neoflash Spring Coding Competition 2009, originally named AceAttorneyDS (http://www.neoflash.com/forum/index.php?topic=5557.0), winning a $300 prize.

    Author :        Copyright 2009 Daniel Li (http://x711Li.com/)
    Created :       12/27/09
    Tools :         MicroLua used under GNU GPL, version 3.0
    License :
                    This file is part of LuAA.
                    LuAA is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
                    LuAA is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
                    You should have received a copy of the GNU General Public License along with LuAA. If not, see http://www.gnu.org/licenses/.
]]

gui_ = {}
gui_.constructed = true

cmd = {}
cmd[ "Court Record" ] = newRect( 176, 0, 255, 32 )
cmd[ "Back" ] = newRect( 0, 169, 80, 192 )
cmd[ "Examine" ] = newRect( 176, 169, 255, 192 )
cmd[ "SCREEN" ] = newRect( 8, 16, 248, 176 )

if DYNAMIC_GUI == false then
	btn = {}
	if not dynamic then
		gui.loadBtn( "ex_Court Record" )
		gui.loadBtn( "ex_Back" )
		gui.loadBtn( "ex_Examine" )
	else
		gui.loadBtn( "ex_Present" )
	end
end

if dynamic then
	ex.x = 0
	ex.y = 0

	ex.img = Image.load( "art/bg/" .. ex.path .. ".png", RAM )
	ex.map = Map.new( ex.img, "art/bg/" .. ex.path .. ".map", ex.size / 8, ex.size / 8, 8, 8 )
end

local cursor = {
	X = 128,
	Y = 96
}
local inHotspot = 0
local colorDirection = 0
local lineColor = 0

function gui.draw()
	if dynamic then
		Map.draw( SCREEN_DOWN, ex.map, 0, 0, 32, 24 )
	else
		Map.draw( SCREEN_DOWN, bg.map, 0, 0, 32, 24 )
	end
	if lineColor == 15 then colorDirection = 1 elseif lineColor == 0 then colorDirection = 0 end
	if colorDirection == 0 then lineColor = lineColor + 1 else lineColor = lineColor - 1 end
	screen.drawLine( SCREEN_DOWN, cursor.X - 1, 0, cursor.X - 1, 192, Color.new( lineColor, lineColor, 31 ) )
	screen.drawLine( SCREEN_DOWN, 0, cursor.Y - 1, 255, cursor.Y - 1, Color.new( lineColor, lineColor, 31 ) )
	screen.drawRect( SCREEN_DOWN, cursor.X - 8, cursor.Y - 8, cursor.X + 7, cursor.Y + 7, PW_BLUE )
	gui[ "EX_PANEL" ].draw()
	
	if not dynamic then
		gui[ "MENU_BTN" ].draw( 176, 0, 80, 32, "ex_Court Record", 0, 1 )
		gui[ "MENU_BTN" ].draw( 0, 168, 80, 24, "ex_Back", 0, 2 )
		gui[ "MENU_BTN" ].draw( 176, 168, 80, 24, "ex_Examine", 0, 3 )
	else
		gui[ "MENU_BTN" ].draw( 88, 0, 80, 32, "ex_Present", 0, 1 )
	end
	
end

gui.fade_in()

if dynamic then selectanswer( "Select area via Touch Screen" ) end

function gui.deconstruct()
	gui.fade_out()
	if dynamic then
		Image.destroy( ex.img )
		ex.img = nil
	end
	cmd = nil
	if DYNAMIC_GUI == false then
		if not dynamic then
			Image.destroy( btn["ex_Court Record"] )
			btn["ex_Court Record"] = nil
			Image.destroy( btn["ex_Back"] )
			btn["ex_Back"] = nil
			Image.destroy( btn["ex_Examine"] )
			btn["ex_Examine"] = nil
		else
			Image.destroy( btn["ex_Present"] )
			btn["ex_Present"] = nil
			textbox = {
				x = 0,
				y = 128,
				w = 256,
				h = 64,
				message = nil
			}
		end
	end
	cursor = nil
	colorDirection = nil
	lineColor = nil
	gui.construct(gui_.new)

	if gui.name == "advance" and not dynamic then
		interact( EXAMINE, selected )
	end
end

function gui.update()
	
	shell.draw()
	
	Controls.read()
	
	if not dynamic then
		if ( Stylus.released and pointCollide( cmd[ "ex_Court Record" ], Stylus ) ) or Keys.newPress.R then
			gui.click( "MENU_BTN", "ex_Court Record", 1 )
			gui.saved[ 1 ] = "examine"
			gui_.constructed = false
			gui_.new = "courtrecord"
		elseif ( ( Stylus.released and pointCollide( cmd[ "ex_Back" ], Stylus ) ) or Keys.newPress.B ) then
			gui.click( "MENU_BTN", "ex_Back", 2 )
			gui_.constructed = false
			gui_.new = "interaction"
		elseif ( ( Stylus.released and pointCollide( cmd[ "ex_Examine" ], Stylus ) ) or Keys.newPress.A ) then
			gui.click( "MENU_BTN", "ex_Examine", 3 )
			gui_.constructed = false
			gui_.new = "advance"
			letter = {}
			selected = nil
			
			for i,v in ipairs( hotspot ) do
				if pointCollide( hotspot[ i ], cursor ) then selected = hotspot[ i ].object end
			end
			talking = true
		end
	elseif ( Stylus.released and pointCollide( cmd[ "ex_Present" ], Stylus ) ) or Keys.newPress.A then
		gui.click( "MENU_BTN", "ex_Present", 1 )
		gui_.constructed = false
		gui_.new = "advance"
		letter = {}
		selected = nil
		
		for i,v in ipairs( hotspot ) do
			if pointCollide( hotspot[ i ], cursor ) then selected = hotspot[ i ].object end
		end
		talking = true
	end
	
	if Stylus.held and pointCollide( cmd[ "SCREEN" ], Stylus ) then
		cursor.X = Stylus.X
		cursor.Y = Stylus.Y
	end

	if Keys.held.Up and cursor.Y > 16 then cursor.Y = cursor.Y - 4
	elseif Keys.held.Down and cursor.Y < 176 then cursor.Y = cursor.Y + 4
	end
	
	if Keys.held.Right and cursor.X < 248 then cursor.X = cursor.X + 4
	elseif Keys.held.Left and cursor.X > 8 then cursor.X = cursor.X - 4
	end
	
	screen.setAlpha( 8, 1 )
	screen.drawFillRect( SCREEN_UP, 0, 0, 256, 192, PW_BLACK )
	screen.setAlpha( ALPHA_OPAQUE )
	if not gui_.constructed then gui.deconstruct() end
	if not clicking then render() end
end

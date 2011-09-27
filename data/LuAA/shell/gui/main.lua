--[[
                     _               ____ ____
                    | |             / _  |  _ \
                    | |      __  __/ /_| | |_\ \ 
                    | |     / / / /  __  |  __  \
                    | |____/ /_/ /  /  | | |  \  \ 
                    |______\____/__/   |_|_|   \__\
                    
    Name :          LuAA - main.lua
                    Constructs methods for drawing/updating the main menu.
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

-- MENU CONSTRUCTION

gui_ = {}
gui_.constructed = true

cmd = {}
cmd[ "Continue" ] = newRect( 52, 122, 202, 148 )

optSelected = 1

if io.fileExists( "games/game.sav" ) then loadable = true end

-- LOADING OF IMAGES ( LOAD IN RAM, ANY IMAGES THAT EXCEED RAM LIMIT WILL APPEAR WHITE )

logo = Image.load( "art/etc/title.png", RAM )
--[[basic_img = Image.load( "art/gui/pw_basic.png", RAM )
basic_map = Map.new( basic_img, "art/gui/pw_basic.map", 32, 32, 8, 8 )]]

-- DRAWING FUNCTION FOR THE GUI

gui.draw = function()
		screen.blit( SCREEN_UP, 0, 0, logo )
		gui[ "BACKGROUND" ].draw()
		--Map.draw( SCREEN_DOWN, basic_map, 0, 0, 32, 24 )
		gui[ "OPT_BTN" ].draw( 52, 44, 150, 26, "New Game" )
		if loadable ~= nil then gui[ "OPT_BTN" ].draw( 52, 122, 150, 26, "Continue" ) end
		gui[ "OPT_CURSOR" ].draw(cmd[ optSelected ].X1, cmd[ optSelected ].Y1, cmd[ optSelected ].X2 - cmd[ optSelected ].X1, cmd[ optSelected ].Y2 - cmd[ optSelected ].Y1)
		gui[ "SCAN_LINES" ].draw()
end

-- UPDATE FUNCTION FOR THE GUI ( BLITS AND CHECKS FOR STYLUS PRESSES ON BUTTONS )
gui.update = function()
	while gui_.constructed do
		gui.draw()

		Controls.read()
		if Stylus.released then
			if pointCollide( cmd[ "New Game" ], Stylus ) then
				gui.click( "OPT_BTN", "New Game" )
				gui_.new = "caseselection"
				gui_.constructed = false		-- DECONSTRUCT GUI
			elseif pointCollide( cmd[ "Continue" ], Stylus ) and loadable ~= nil then
				gui.click( "OPT_BTN", "Continue" )
				gui_.new = "load"
				gui_.constructed = false		-- DECONSTRUCT GUI
			end
		end
		if Keys.newPress.Up and optSelected > 1 then
			optSelected = 1
		elseif Keys.newPress.Down and loadable ~= nil then
			optSelected = 2
		elseif Keys.newPress.A then
			if optSelected == 1 then
				gui.click( "OPT_BTN", "New Game" )
				gui_.new = "caseselection"
				gui_.constructed = false		-- DECONSTRUCT GUI
			elseif optSelected == 2 then
				gui.click( "OPT_BTN", "Continue" )
				gui_.new = "load"
				gui_.constructed = false		-- DECONSTRUCT GUI	
			end
		end

		if not clicking then render() end
	end
	-- GUI DECONSTRUCTION
	Image.destroy( logo )
	logo = nil
	--[[Image.destroy( basic_img )
	basic_img = nil
	Map.destroy( basic_map )
	basic_map = nil]]
	gui.construct( gui_.new )
end

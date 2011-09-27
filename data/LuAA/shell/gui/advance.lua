--[[
                     _               ____ ____
                    | |             / _  |  _ \
                    | |      __  __/ /_| | |_\ \ 
                    | |     / / / /  __  |  __  \
                    | |____/ /_/ /  /  | | |  \  \ 
                    |______\____/__/   |_|_|   \__\
                    
    Name :          LuAA - advance.lua
                    Constructs methods for drawing/updating the advance GUI.
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

cmd = {}
state = 0
direction = 1

if DYNAMIC_GUI == false then
	btn = {}
	gui.loadBtn( "Court Record" )
end

gui.draw = function()
	gui[ "BACKGROUND" ].draw()
	gui[ "ADV_BTN" ].draw( 16, 40, 224, 112, "Advance" )
	if not talking then

		gui[ "TRIANGLE" ].draw( SCREEN_DOWN, 112 + state * 4, 82, 148 + state * 4, 96, 112 + state * 4, 108, PW_WHITE )
		gui[ "TRIANGLE" ].draw( SCREEN_UP, 248 + state * 1, 178, 254 + state * 1, 185, 248 + state * 1, 190, PW_WHITE )
		
		if direction == 1 then
			state = state + 1
		elseif direction == 0 then
			state = state - 1
		end

		if state == -1 then
			direction = 1
		elseif state == 1 then
			direction = 0
		end
	end
	gui[ "SCAN_LINES" ].draw()
	gui[ "MENU_PANEL" ].draw()
	gui[ "MENU_BTN" ].draw( 176, 0, 80, 32, "Court Record", 0, 1 )
end

gui.fade_in()

gui.deconstruct = function()
	gui.fade_out()
	cmd = nil
	if DYNAMIC_GUI == false then
		Image.destroy( btn["Court Record"] )
		btn["Court Record"] = nil
	end
end

gui.update = function()
	shell.draw()
	Controls.read()
	if ( Stylus.released and pointCollide( cmd[ "Advance" ], Stylus ) ) or Keys.newPress.A then
		gui.click( "ADV_BTN", "Advance" )
		talking = true
	elseif ( Stylus.released and pointCollide( cmd[ "Court Record" ], Stylus ) ) or Keys.newPress.R then
		gui.click( "MENU_BTN", "Court Record", 1 )		
		gui.saved[ 1 ] = "advance"
		gui.construct( "courtrecord" )
	end
	if not clicking then render() end
	if talking == true then clicking = false end
end

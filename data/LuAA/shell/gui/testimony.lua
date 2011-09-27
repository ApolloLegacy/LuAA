--[[
                     _               ____ ____
                    | |             / _  |  _ \
                    | |      __  __/ /_| | |_\ \ 
                    | |     / / / /  __  |  __  \
                    | |____/ /_/ /  /  | | |  \  \ 
                    |______\____/__/   |_|_|   \__\
                    
    Name :          LuAA - testimony.lua
                    Constructs methods for drawing/updating the testimony GUI.
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

gui.saved[ 1 ] = "testimony"
gui.saved[ 2 ] = "testimony"

if DYNAMIC_GUI == false then
	btn = {}
	gui.loadBtn( "Press" )
	gui.loadBtn( "Present" )
end

function gui.deconstruct()
	cmd = nil
	if DYNAMIC_GUI == false then
		Image.destroy( btn["Press"] )
		btn["Press"] = nil
		Image.destroy( btn["Present"] )
		btn["Present"] = nil
	end
end

function gui.draw()
	gui[ "BACKGROUND" ].draw()
	gui[ "ADV_BTN" ].draw( 16, 64, 106, 80, "Back" )
	gui[ "ADV_BTN" ].draw( 136, 64, 106, 80, "Next" )
	gui[ "SCAN_LINES" ].draw()
	gui[ "MENU_PANEL" ].draw()
	gui[ "MENU_BTN" ].draw( 0, 0, 80, 32, "Press", 0, 0 )
	gui[ "MENU_BTN" ].draw( 176, 0, 80, 32, "Present", 0, 1 )
	gui[ "HP_BAR" ].draw()
end

function gui.update()
	shell.draw()
	
	Controls.read()
	if ( ( Stylus.released and pointCollide( cmd[ "Back" ], Stylus ) ) or Keys.newPress.B or Keys.newPress.Left ) and tsm_line > 1 then
		gui.click( "ADV_BTN", "Back" )
		tsm_line = tsm_line - 1
		talking = true	
	elseif ( Stylus.released and pointCollide( cmd[ "Next" ], Stylus ) ) or Keys.newPress.A or Keys.newPress.Right then
		gui.click( "ADV_BTN", "Next" )
		tsm_line = tsm_line + 1
		talking = true
	elseif ( Stylus.released and pointCollide( cmd[ "Press" ], Stylus ) ) or Keys.newPress.L then
		gui.click( "MENU_BTN", "Press", 0 )
		gui.deconstruct()
		gui.construct( "advance" )
		goto( press[ tsm_line ] )
	elseif ( Stylus.released and pointCollide( cmd[ "Present" ], Stylus ) ) or Keys.newPress.R then
		gui.click( "MENU_BTN", "Present", 1 )
		gui.deconstruct()
		pst = true
		gui.construct( "courtrecord" )
	end

	if not clicking then render() end
end

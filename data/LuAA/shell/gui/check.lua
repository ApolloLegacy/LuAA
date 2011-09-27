--[[
                     _               ____ ____
                    | |             / _  |  _ \
                    | |      __  __/ /_| | |_\ \ 
                    | |     / / / /  __  |  __  \
                    | |____/ /_/ /  /  | | |  \  \ 
                    |______\____/__/   |_|_|   \__\
                    
    Name :          LuAA - check.lua
                    Constructs methods for drawing/updating the check GUI.
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

paused = true

cmd = {}

Image.destroy( bg_img )
bg_img = nil

gui.deconstruct() = function()
	cmd = nil
	Image.destroy(check_img)
	check_img = nil
	bg_img = Image.load( "art/bg/" .. bg.path .. ".gif", RAM )
end

gui.draw = function()
	screen.blit( SCREEN_DOWN, 0, 0, check_img )
	gui[ "MENU_BTN" ].draw( 0, 160, 80, 32, "Back", 0, 2 )
end

gui.update = function()
	shell.draw()

	Controls.read()
	if ( Stylus.released and pointCollide( cmd[ "Back" ], Stylus ) ) or Keys.newPress.B then
		gui.deconstruct()
		gui.construct("courtrecord")
	end

	if not clicking then render() end
end

--[[
                     _               ____ ____
                    | |             / _  |  _ \
                    | |      __  __/ /_| | |_\ \ 
                    | |     / / / /  __  |  __  \
                    | |____/ /_/ /  /  | | |  \  \ 
                    |______\____/__/   |_|_|   \__\
                    
    Name :          LuAA - const.lua
                    Standard constants.
    Purpose :        
                    LuAA is a mobile visual novel application programmed in an open-source distribution of the extensible language, Lua, namely MicroLua. 
                    MicroLua is designed for ARM hardware architecture, specifically for an ARM7/ARM9 processor configuration found in the Nintendo DS. 
                    Thus, it disallows allocation of memory past 4MB, internally. It is packaged with the compiled (proprietary) ARM7/ARM9 binaries 
                    to prevent user manipulation. However, the front-end programmed in MicroLua is powerful enough for user customizability 
                    (re-compile all included files using NDSTool -> Pack to compile a .nds file). LuAA placed 1st in the Neoflash Spring Coding Competition 
                    in 2009, originally named AceAttorneyDS (http://www.neoflash.com/forum/index.php?topic=5557.0), winning a $300 prize.

    Author :        Copyright 2009 Daniel Li (http://x711Li.com/)
    Created :       12/27/09
    Tools :         MicroLua used under GNU GPL, version 3.0
    License :
                    This file is part of LuAA.
                    LuAA is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by 
                    the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
                    LuAA is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY 
                    or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
                    You should have received a copy of the GNU General Public License along with LuAA. If not, see http://www.gnu.org/licenses/.
]]

MICROLUA_VERSION = "3.0"
    
SCREEN_WIDTH = 256
SCREEN_HEIGHT = 192

RAM = 0
VRAM = 1

SCREEN_UP = 1
SCREEN_DOWN = 0
--SCREEN_BOTH = 2

ATTR_X1 = 0
ATTR_Y1 = 1
ATTR_X2 = 2
ATTR_Y2 = 3
ATTR_X3 = 4
ATTR_Y3 = 5
ATTR_COLOR = 6
ATTR_COLOR1 = 7
ATTR_COLOR2 = 8
ATTR_COLOR3 = 9
ATTR_COLOR4 = 10
ATTR_TEXT = 11
ATTR_VISIBLE = 12
ATTR_FONT = 13
ATTR_IMAGE = 14

PLAY_LOOP = 0
PLAY_ONCE = 1
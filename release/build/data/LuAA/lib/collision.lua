--[[
                     _               ____ ____
                    | |             / _  |  _ \
                    | |      __  __/ /_| | |_\ \
                    | |     / / / /  __  |  __  \
                    | |____/ /_/ /  /  | | |  \  \
                    |______\____/__/   |_|_|   \__\

    Name :          LuAA - collision.lua
                    Collision library.
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

function newRect(X1, Y1, X2, Y2)
    local aRect = {}
    aRect.X1 = X1
    aRect.Y1 = Y1
    aRect.X2 = X2
    aRect.Y2 = Y2
    return aRect
end

function pointCollide(aRect, aPoint)
    if aRect ~= nil and aPoint ~= nil and
       aPoint.X > aRect.X1 and aPoint.X < aRect.X2 and aPoint.Y > aRect.Y1 and aPoint.Y < aRect.Y2 then
        return true
    end
end
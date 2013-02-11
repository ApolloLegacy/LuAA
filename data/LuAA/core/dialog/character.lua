--[[
                     _               ____ ____
                    | |             / _  |  _ \
                    | |      __  __/ /_| | |_\ \
                    | |     / / / /  __  |  __  \
                    | |____/ /_/ /  /  | | |  \  \
                    |______\____/__/   |_|_|   \__\

    Name :          LuAA - character.lua
                    Character structure.
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

char = {}

function char.construct(action)
    char.size = 0
    char.frames = 0
    char.frame = 1
    char.loops = true
    char.x = 0
    char.y = 0
    local path = "art/char/" .. char.name .. "/" .. char.emotion
    if action then path = "art/char/" .. char.name .. "/" .. char.emotion .. "(" .. action .. ")" end

    dofile(path .. ".lua")
    char.size = size
    char.frames = length
    if loops then char.loops = loops loops = nil end
    size = nil
    length = nil
    if char.img then
        Image.destroy(char.img)
        char.img = nil
    end

    char.img = Image.load(path .. ".png", RAM)
    char.map = Map.new(char.img, path .. ".map", char.size / 8, char.size / 8, 8, 8)
    Map.draw(SCREEN_UP, char.map, 0, 0, 32, 24)
end

function char.draw(timer)
    if timer % 3 == 0 then
        char.frame = char.frame + 1
        if char.frame == char.frames then
            char.x = 0
            char.y = 0
            char.frame = 1
        end
        if char.x + 32 ~= char.size / 8 then
            char.x = char.x + 32
        else
            char.x = 0
            char.y = char.y + 24
        end
        Map.scroll(char.map, char.x + shake_event.x, char.y + shake_event.y)
    end
    Map.draw(SCREEN_UP, char.map, 0, 0, 32, 24)
end

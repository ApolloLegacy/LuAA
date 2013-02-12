--[[
                     _               ____ ____
                    | |             / _  |  _ \
                    | |      __  __/ /_| | |_\ \
                    | |     / / / /  __  |  __  \
                    | |____/ /_/ /  /  | | |  \  \
                    |______\____/__/   |_|_|   \__\

    Name :          LuAA - scene.lua
                    Constructs dialog for loading the scene.
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

bg = {}

fg = {}

function newbg(p, size)
    bg.path = p
    bg.size = 0
    bg.x = 0
    bg.y = 0

    if p then
        bg.size = size
        if bg.img then
            Image.destroy(bg.img)
            bg.img = nil
        end

        bg.img = Image.load("art/bg/" .. p .. ".png", RAM)
        bg.map = Map.new(bg.img, "art/bg/" .. p .. ".map", bg.size / 8, bg.size / 8, 8, 8)
        Map.draw(SCREEN_UP, bg.map, 0, 0, 32, 24)
    elseif bg.img then
        Image.destroy(bg.img)
        bg.img = nil
    end
end

function newfg(p, size)
    fg.path = p
    fg.size = 0
    fg.x = 0
    fg.y = 0

    if p then
        fg.size = size
        if fg.img then
            Image.destroy(fg.img)
            fg = nil
        end

        fg.img = Image.load("art/fg/" .. p .. ".png", RAM)
        fg.map = Map.new(fg.img, "art/fg/" .. p .. ".map", fg.size / 8, fg.size / 8, 8, 8)
        Map.draw(SCREEN_UP, fg.map, 0, 0, 32, 24)
    elseif fg.img then
        Image.destroy(fg.img)
        fg.img = nil
    end
end

function newchar(n, e, aa, ia, ta)
    char.name = n
    char.emotion = e
    char.active = aa
    char.idle = ia
    char.transition = ta

    if n then char.construct(char.active)
    elseif char.img then
        Image.destroy(char.img)
        char.img = nil
    end
end

function newemo(e)
    char.emotion = e
    char.construct(char.active)
end

function newactive(a)
    char.active = a
    char.construct(char.active)
end

function newidle(a)
    char.idle = a
end

function newtransition(a)
    char.transition = a
end

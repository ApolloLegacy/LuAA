--[[
                     _               ____ ____
                    | |             / _  |  _ \
                    | |      __  __/ /_| | |_\ \ 
                    | |     / / / /  __  |  __  \
                    | |____/ /_/ /  /  | | |  \  \ 
                    |______\____/__/   |_|_|   \__\
                    
    Name :          LuAA - options.lua
                    Constructs dialog for options.
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

dynamic = false
talked = {}

function move()
    gui.deconstruct()
    dynamic = false
    opt = movOpt
    dofile("shell/gui/options.lua")
end

function talk()
    gui.deconstruct()
    opt = tlkOpt
    dynamic = false
    dofile("shell/gui/options.lua")
end

function dynamic_options(...)
    newdyn(...)
    gui.deconstruct()
    dynamic = true
    opt = dynOpt
    dofile("shell/gui/options.lua")
    talking = false
    while not talking do
        gui.update()
    end
end

function has_opt(opt)
    local found = false
    
    for i,v in ipairs (tlkOpt) do
        if v.text == opt then
            found = true
            return found
        end
    end
    for i,v in ipairs (movOpt) do
        if v.text == opt then
            found = true
            return found
        end
    end
    
    return found
end

function new_opt(...)
    local optset = {}
    for i = 1, select("#", ...) do
        optset[i] = {}
        optset[i].text = select(i, ...)
    end
    
    return optset
end

function new_mov_opt(...)
    local optset = {}
    for i = 1, select("#", ...) do
        optset[i] = {}
        optset[i].text = select(i, ...).name
        optset[i].path = select(i, ...).pic
    end
    
    return optset
end

function add_tlk(opt)
    local optset = {}
    optset.text = opt:gsub("_", "")
    optset.script = opt:gsub(" ", "_")
    table.insert(tlkOpt, optset)
end

function new_tlk(...)
    tlkOpt = new_opt(...)
end
function new_mov(...)
    movOpt = new_mov_opt(...)
end
function newdyn(...)
    dynOpt = new_opt(...)
end

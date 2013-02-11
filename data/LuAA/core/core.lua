--[[
                     _               ____ ____
                    | |             / _  |  _ \
                    | |      __  __/ /_| | |_\ \ 
                    | |     / / / /  __  |  __  \
                    | |____/ /_/ /  /  | | |  \  \ 
                    |______\____/__/   |_|_|   \__\
                    
    Name :          LuAA - core.lua
                    Constructs game with dependencies.
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

dofile("core/const.lua")

dofile("core/dialog/advance.lua")
dofile("core/dialog/animation.lua")
dofile("core/dialog/character.lua")
dofile("core/dialog/courtrecord.lua")
dofile("core/dialog/examine.lua")
dofile("core/dialog/interaction.lua")
dofile("core/dialog/gui.lua")
dofile("core/dialog/options.lua")
dofile("core/dialog/save.lua")
dofile("core/dialog/scene.lua")
dofile("core/dialog/script.lua")
dofile("core/dialog/sound.lua")
dofile("core/dialog/testimony.lua")

dofile("games/cases.lua")

dofile("shell/shell.lua")
dofile("shell/gui.lua")

microlua = Image.load("art/etc/ml.png", RAM)
x711Li = Image.load("art/etc/x711Li.png", RAM)
font = Font.load("fonts/pw_international.oft")
namefont = Font.load("fonts/pw_name.oft")
arial = Font.load("fonts/arial.oft")

--  Construct script variables/functions

--  Show Micro Lua DS/x711Li logos.
--  PLEASE DO NOT REMOVE/ALTER THIS,
--  credits given where due.

tmr = Timer.new()
tmr:start()

while tmr:time() < 1 do
    screen.blit(SCREEN_UP, 0, 0, microlua)
    screen.blit(SCREEN_DOWN, 0, 0, x711Li)
    render()
end

--  Deconstruct LuAA/core  - > load main menu

Image.destroy(microlua)
microlua = nil
Image.destroy(x711Li)
b12core = nil
tmr = nil

gui.construct("main")

while true do
    gui.update()
end

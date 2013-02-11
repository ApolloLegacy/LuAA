--[[
                     _               ____ ____
                    | |             / _  |  _ \
                    | |      __  __/ /_| | |_\ \ 
                    | |     / / / /  __  |  __  \
                    | |____/ /_/ /  /  | | |  \  \ 
                    |______\____/__/   |_|_|   \__\
                    
    Name :          LuAA - screen.lua
                    Screen library.
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

screen.setSpaceBetweenScreens(10)

mustCountFPS = true

startDrawing = function()
    screen.startDrawing2D()
end

stopDrawing = function()
    -- Count FPS
    if mustCountFPS then 
        NB_FPS_COUNTER = NB_FPS_COUNTER + 1
        mustCountFPS = false
    else
        mustCountFPS = true
    end
    if tmrFpsCounter:time() >= 1000 then
        NB_FPS = NB_FPS_COUNTER
        NB_FPS_COUNTER = 0
        tmrFpsCounter:reset()
        tmrFpsCounter:start()
    end
    -- Draw debug console
    if Debug.isDebugOn then
        screen.drawTextBox(SCREEN_DOWN, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, Debug.debugText, Debug.debugColor)
    end
    screen.endDrawing()
    screen.waitForVBL()        
end

render = function()
    stopDrawing()
    startDrawing()
end
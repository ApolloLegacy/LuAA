--[[
                     _               ____ ____
                    | |             / _  |  _ \
                    | |      __  __/ /_| | |_\ \ 
                    | |     / / / /  __  |  __  \
                    | |____/ /_/ /  /  | | |  \  \ 
                    |______\____/__/   |_|_|   \__\
                    
    Name :          LuAA - load.lua
                    Constructs methods for drawing/updating the loading GUI.
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

optSelected = 1

logo = Image.load("art/etc/title.gif", RAM)

gui.deconstruct = function()    
    cmd = nil
    optSelected = nil
    Image.destroy(logo)
    logo = nil
end

load__struct = loadAndDecryptFile("games/game.sav", {251, 662, 93, 44, 77})
game = load__struct.game
chapter = load__struct.chapter    
hp = load__struct.hp
evidence = load__struct.evidence
profile = load__struct.profile
bookmark = load__struct.bookmark
load__struct = nil

gui.draw = function()
    screen.blit(SCREEN_UP, 0, 0, logo)
    gui["BACKGROUND"].draw()
    screen.drawFillRect(SCREEN_DOWN, 30, 14, 226, 98, PW_BROWN)
    gui["BORDER"].draw(SCREEN_DOWN, 30, 14, 196, 84)
    gui["CENTER_TXT"].draw(30, 18, 196, 25, game)
    gui["CENTER_TXT"].draw(30, 39, 196, 20, chapter)
    gui["CENTER_TXT"].draw(30, 64, 196, 20, "Load game?")
    gui["OPT_BTN"].draw(23, 119, 92, 26, "Yes")
    gui["OPT_BTN"].draw(140, 119, 92, 26, "No")
    gui["OPT_CURSOR"].draw(cmd[optSelected].X1, cmd[optSelected].Y1, cmd[optSelected].X2 - cmd[optSelected].X1, cmd[optSelected].Y2 - cmd[optSelected].Y1)
    gui["SCAN_LINES"].draw()
end

gui.update = function()
    gui.draw()
    
    Controls.read()    
    if Stylus.released and pointCollide(cmd["Yes"], Stylus) then
        load__struct = loadAndDecryptFile("games/game.sav", {251, 662, 93, 44, 77})
        hp = load__struct.hp
        evidence = load__struct.evidence
        profile = load__struct.profile
        bookmark = load__struct.bookmark
        load__struct = nil
        gui.deconstruct()
        gui.construct("advance")
        goto(_G[bookmark]())
    elseif Stylus.released and pointCollide(cmd["No"], Stylus) then
        gui.deconstruct()
        gui.construct("main")
    elseif Keys.newPress.Right then
        optSelected = 2
    elseif Keys.newPress.Left and optSelected > 1 then
        optSelected = 1
    elseif Keys.newPress.A then
        if optSelected == 1 then
            gui.deconstruct()
            gui.construct("advance")
            goto(_G[bookmark]())
        elseif optSelected == 2 then
            gui.deconstruct()
            gui.construct("main")
        end
    end

    if not clicking then render() end
end

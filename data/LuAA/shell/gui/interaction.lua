--[[
                     _               ____ ____
                    | |             / _  |  _ \
                    | |      __  __/ /_| | |_\ \ 
                    | |     / / / /  __  |  __  \
                    | |____/ /_/ /  /  | | |  \  \ 
                    |______\____/__/   |_|_|   \__\
                    
    Name :          LuAA - interaction.lua
                    Constructs methods for drawing/updating the interaction.
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

gui_ = {}
gui_.constructed = true

cmd = {}

gui.saved[1] = "interaction"
gui.saved[2] = "interaction"

optSelected = 1

if DYNAMIC_GUI == false then
    btn = {}
    gui.loadBtn("Court Record")
    gui.loadBtn("int_Examine")
    gui.loadBtn("int_Move")
    if interrogation then
        gui.loadBtn("int_Talk")
        gui.loadBtn("int_Present")
    end
end

function gui.draw()
    gui["BACKGROUND"].draw()
    gui["INT_BTN"].draw(8, 54, 112, 28, "int_Examine", 0)
    gui["INT_BTN"].draw(136, 54, 112, 28, "int_Move", 0)
    if interrogation then
        gui["INT_BTN"].draw(8, 110, 112, 28, "int_Talk", 0)
        gui["INT_BTN"].draw(136, 110, 112, 28, "int_Present", 0)
    end
    gui["OPT_CURSOR"].draw(cmd[optSelected].X1, cmd[optSelected].Y1, cmd[optSelected].X2 - cmd[optSelected].X1, cmd[optSelected].Y2 - cmd[optSelected].Y1)
    gui["SCAN_LINES"].draw()
    
    gui["MENU_PANEL"].draw()
    gui["MENU_BTN"].draw(176, 0, 80, 32, "Court Record", 0, 1)
end

gui.fade_in()

function gui.deconstruct()
    gui.fade_out()
    cmd = nil
    if DYNAMIC_GUI == false then
        Image.destroy(btn["Court Record"])
        btn["Court Record"] = nil
        Image.destroy(btn["int_Examine"])
        btn["int_Examine"] = nil
        Image.destroy(btn["int_Move"])
        btn["int_Move"] = nil
        if interrogation then
            Image.destroy(btn["int_Talk"])
            btn["int_Talk"] = nil
            Image.destroy(btn["int_Present"])
            btn["int_Present"] = nil
        end
    end
    optSelected = nil
    gui.construct(gui_.new)
end

function gui.update()
    shell.draw()
    
    Controls.read()
    if Stylus.released then
        if pointCollide(cmd["int_Examine"], Stylus) then
            optSelected = 1
            gui.click("INT_BTN", "int_Examine")
            gui_.constructed = false
            gui_.new = "examine"
        elseif pointCollide(cmd["int_Move"], Stylus) then
            optSelected = 2
            gui.click("INT_BTN", "int_Move")
            gui_.constructed = false
            opt = movOpt
            gui_.new = "options"
        elseif interrogation then
            if pointCollide(cmd["int_Talk"], Stylus) then
                optSelected = 3
                gui.click("INT_BTN", "int_Talk")                
                gui_.constructed = false
                opt = tlkOpt
                gui_.new = "options"
            elseif pointCollide(cmd["int_Present"], Stylus) then
                optSelected = 4
                gui.click("INT_BTN", "int_Present")
                gui_.constructed = false
                gui_.new = "courtrecord"
                pst = true
            end
        end
    end
    if (Stylus.released and pointCollide(cmd["Court Record"], Stylus)) or Keys.newPress.R then
        gui.click("MENU_BTN", "Court Record", 1)
        gui_.constructed = false
        gui_.new = "courtrecord"
    elseif Keys.newPress.A then
        if optSelected == 1 then
            gui.click("INT_BTN", "int_Examine")
            gui_.constructed = false
            gui_.new = "examine"
        elseif optSelected == 2 then
            gui.click("INT_BTN", "int_Move")
            gui_.constructed = false
            opt = movOpt
            gui_.new = "options"
        elseif optSelected == 3 then
            gui.click("INT_BTN", "int_Talk")
            gui_.constructed = false
            opt = tlkOpt
            gui_.new = "options"
        elseif optSelected == 4 then
            gui.click("INT_BTN", "int_Present")
            gui_.constructed = false
            gui_.new = "courtrecord"
            pst = true
        end
    end
    if Keys.newPress.Left and optSelected % 2 == 0 then optSelected = optSelected - 1 end
    if Keys.newPress.Right and optSelected % 2 == 1 then optSelected = optSelected + 1 end
    if interrogation then    
        if Keys.newPress.Up and optSelected > 2 then optSelected = optSelected - 2 end
        if Keys.newPress.Down and optSelected < 3 then optSelected = optSelected + 2 end
    end
    if not gui_.constructed then gui.deconstruct() end

    if not clicking then render() end
end

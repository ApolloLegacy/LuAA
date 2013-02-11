--[[
                     _               ____ ____
                    | |             / _  |  _ \
                    | |      __  __/ /_| | |_\ \
                    | |     / / / /  __  |  __  \
                    | |____/ /_/ /  /  | | |  \  \
                    |______\____/__/   |_|_|   \__\

    Name :          LuAA - caseselection.lua
                    Constructs methods for drawing/updating the case selection GUI.
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
gui_.constructed = true

cmd = {}

currentCase = 1

if DYNAMIC_GUI == false then
    btn = {}
    gui.loadBtn("Back")
    gui.loadBtn("Confirm")
end

gui_.Y1 = 192

gui_.reloadImages = function()
    if case_top then
        Image.destroy(case_top)
        case_top = nil
    end

    if case_bottom then
        Image.destroy(case_bottom)
        case_bottom = nil
    end

    case_top = Image.load("games/"..cases[currentCase].."/casetop.png", RAM)
    case_bottom = Image.load("games/"..cases[currentCase].."/casebottom.png", RAM)
end

gui_.reloadImages()

repeat
    gui_.Y1 = gui_.Y1 - 2
    screen.blit(SCREEN_DOWN, 0, 0, case_bottom)
    gui["MENU_BTN"].draw(0, gui_.Y1, 80, 32, "Back", 0, 2)
    gui["MENU_BTN"].draw(176, gui_.Y1, 80, 32, "Confirm", 0, 3)
    screen.blit(SCREEN_UP, 0, 0, case_top)
    render()
until gui_.Y1 == 160

cmd = {}
cmd["Left"] = newRect(10, 72, 34, 97)
cmd["Right"] = newRect(222, 72, 246, 97)

gui.draw = function()
    screen.blit(SCREEN_DOWN, 0, 0, case_bottom)
    gui["MENU_BTN"].draw(0, 160, 80, 32, "Back", 0, 2)
    gui["MENU_BTN"].draw(176, 160, 80, 32, "Confirm", 0, 3)
    screen.blit(SCREEN_UP, 0, 0, case_top)
end

gui.update = function()
    while gui_.constructed do
        gui.draw()

        Controls.read()
        if (Stylus.released and pointCollide(cmd["Left"], Stylus)) or Keys.newPress.Left then
            if currentCase ~= 1 then currentCase = currentCase - 1 else currentCase = table.maxn(cases) end
            gui_.reloadImages()
            gui.draw()
            render()
        elseif (Stylus.released and pointCollide(cmd["Right"], Stylus)) or Keys.newPress.Right then
            if currentCase ~= table.maxn(cases) then currentCase = currentCase + 1 else currentCase = 1 end
            gui_.reloadImages()
            gui.draw()
            render()
        elseif (Stylus.released and pointCollide(cmd["Confirm"], Stylus)) or Keys.newPress.A then
            gui.click("MENU_BTN", "Confirm" , 3)
            gui_.new = "advance"
            gui_.constructed = false
        elseif (Stylus.released and pointCollide(cmd["Back"], Stylus)) or Keys.newPress.B then
            gui.click("MENU_BTN", "Back" , 2)
            gui_.new = "main"
            gui_.constructed = false
        end

        if not clicking then render() end
    end
    Image.destroy(case_top)
    case_top = nil
    Image.destroy(case_bottom)
    case_bottom = nil
    if DYNAMIC_GUI == false then
        Image.destroy(btn["Back"])
        btn["Back"] = nil
        Image.destroy(btn["Confirm"])
        btn["Confirm"] = nil
    end

    if gui_.new == "advance" then
        gui_.Y1 = 56
        case_profile = Image.load("games/"..cases[currentCase].."/caseprofile.png", RAM)
        repeat
            if gui_.Y1 > 0 then
                screen.blit(SCREEN_DOWN, 40, gui_.Y1, case_profile)
            else
                screen.blit(SCREEN_DOWN, 40, gui_.Y1, case_profile)
                screen.blit(SCREEN_UP, 40, 192 + gui_.Y1, case_profile)
            end
            gui_.Y1 = gui_.Y1 - 4
            render()
        until gui_.Y1 == -136
        script = true
        Image.destroy(case_profile)
        case_profile = nil
    end
    gui.construct(gui_.new)
    if script then
        --basic_img = Image.load("art/gui/pw_basic.png", RAM)
        --basic_map = Map.new(basic_img, "art/gui/pw_basic.map", 32, 32, 8, 8)
        game = cases[currentCase]
        cases = nil
        currentCase = nil
        talking = true
        dofile("games/"..game.."/main.lua")
        scene = main()
        scene()
        script = nil
    end
end

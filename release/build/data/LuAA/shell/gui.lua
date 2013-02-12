--[[
                     _               ____ ____
                    | |             / _  |  _ \
                    | |      __  __/ /_| | |_\ \
                    | |     / / / /  __  |  __  \
                    | |____/ /_/ /  /  | | |  \  \
                    |______\____/__/   |_|_|   \__\

    Name :          LuAA - gui.lua
                    Constructs methods for drawing the user interface.
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

gui = {}

gui.saved = {}

gui.construct = function(newgui)
    gui.name = newgui
    clicking = false
    dofile("shell/gui/" .. newgui .. ".lua")
end

gui.click = function(btn_type, btn_name, corner)
    clicking = true
    if btn_type == "MENU_BTN" then
        if DYNAMIC_GUI == false then
            Image.destroy(btn[btn_name])
            btn[btn_name] = nil
            btn[btn_name] = Image.load("art/gui/".. btn_name .. "_y.gif", VRAM)
        end
        cmd[btn_name].visible = false
        if corner > 1 then
            repeat
                if main then
                    shell.draw()
                else
                    gui.draw()
                end

                cmd[btn_name].Y1 = cmd[btn_name].Y1 + 4
                cmd[btn_name].Y2 = cmd[btn_name].Y2 + 4
                gui[btn_type].draw(cmd[btn_name].X1, cmd[btn_name].Y1, cmd[btn_name].X2 - cmd[btn_name].X1, cmd[btn_name].Y2 - cmd[btn_name].Y1, btn_name, 1, corner)
                render()
            until cmd[btn_name].Y1 > 192
        else
            repeat
                if main then shell.draw() else gui.draw() end
                cmd[btn_name].Y1 = cmd[btn_name].Y1 - 4
                cmd[btn_name].Y2 = cmd[btn_name].Y2 - 4
                gui[btn_type].draw(cmd[btn_name].X1, cmd[btn_name].Y1, cmd[btn_name].X2 - cmd[btn_name].X1, cmd[btn_name].Y2 - cmd[btn_name].Y1, btn_name, 1, corner)
                render()
            until cmd[btn_name].Y2 < 0
        end
    elseif btn_type == "OPT_BTN" then
        local timer = 0
        repeat
            if main then shell.draw() else gui.draw() end
            gui[btn_type].draw(cmd[btn_name].X1, cmd[btn_name].Y1, cmd[btn_name].X2 - cmd[btn_name].X1, cmd[btn_name].Y2 - cmd[btn_name].Y1, btn_name, 1)
            timer = timer + 1
            render()
        until timer == 12
    elseif btn_type == "INT_BTN" then
        local timer = 0
        Image.destroy(btn[btn_name])
        btn[btn_name] = nil
        btn[btn_name] = Image.load("art/gui/".. btn_name .. "_y.gif", VRAM)
        repeat
            if main then shell.draw() else gui.draw() end
            render()
            timer = timer + 1
        until timer == 12
    elseif btn_type == "ADV_BTN" then
        if main then shell.draw() else gui.draw() end
        gui[btn_type].draw(cmd[btn_name].X1, cmd[btn_name].Y1, cmd[btn_name].X2 - cmd[btn_name].X1, cmd[btn_name].Y2 - cmd[btn_name].Y1, btn_name, 1)
        render()
    end
end

gui.fade_in = function()
    local frame = 32

    repeat
        if main then shell.draw() else gui.draw() end
        screen.setAlpha(frame, 1)
        screen.drawFillRect(SCREEN_DOWN, 0, 0, 256, 192, PW_BLACK)
        screen.setAlpha(ALPHA_OPAQUE, 1)
        render()
        frame = frame - 8
    until frame == 0
end

gui.fade_out = function()
    local frame = 0

    repeat
        if main then shell.draw() else gui.draw() end
        screen.setAlpha(frame, 1)
        screen.drawFillRect(SCREEN_DOWN, 0, 0, 256, 192, PW_BLACK)
        screen.setAlpha(ALPHA_OPAQUE, 1)
        render()
        frame = frame + 8
    until frame == 32
end

if DYNAMIC_GUI == false then
    gui["INT_BTN"] = {
        draw = function(x, y, width, height, name, state)
            if not cmd[name] then
                cmd[name] = newRect(x, y, x + width, y + height)
                cmd[table.maxn(cmd) + 1] = newRect(x, y, x + width, y + height)
            end
            screen.blit(SCREEN_DOWN, x, y, btn[name])
        end
    }
    gui["MENU_BTN"] = {
        color = {
            FILL = PW_SIENNA,
            BORDER = PW_SADDLE,
            SHADE = PW_TAN,
            SEL_FILL = PW_GOLD,
            SEL_BORDER = PW_GOLDENROD,
            SEL_SHADE = PW_LEMON
        },
        draw = function(x, y, width, height, text, state, corner)
            if not cmd[text] then
                cmd[text] = newRect(x, y, x + width, y + height)
            elseif cmd[text].visible == false and state == 0 then
                return
            end
            screen.blit(SCREEN_DOWN, x, y, btn[text])
        end
    }
    gui.loadBtn = function(btn_name)
        btn[btn_name] = Image.load("art/gui/".. btn_name .. ".gif", RAM)
    end
else
    gui["INT_BTN"] = {
        draw = function(x, y, width, height, name, state)
            if not cmd[name] then
                cmd[table.maxn(cmd) + 1] = newRect(x, y, x + width, y + height)
            end
            name = name:gsub("int_", "")
            gui["ADV_BTN"].draw(x, y, width, height, name, state)
            gui["BORDERED_TXT"].draw(SCREEN_DOWN, x + width / 2 - (Font.getStringWidth(font, name) / 2), y + height / 2 - (Font.getCharHeight(font) / 2), name, state, gui["MENU_BTN"].color["BORDER"], gui["MENU_BTN"].color["SEL_BORDER"], font)
        end
    }

    gui["MENU_BTN"] = {
        color = {
            FILL = PW_SIENNA,
            BORDER = PW_SADDLE,
            SHADE = PW_TAN,
            SEL_FILL = PW_GOLD,
            SEL_BORDER = PW_GOLDENROD,
            SEL_SHADE = PW_LEMON
        },
        draw = function(x, y, width, height, text, state, corner)
            if not cmd[text] then
                cmd[text] = newRect(x, y, x + width, y + height)
            elseif cmd[text].visible == false and state == 0 then
                return
            end

            text = text:gsub("ex_", "")

            if corner == 0 then
                screen.drawRect(SCREEN_DOWN, x, y, x + width - 1, y - 1 + (height / 2), PW_WHITE)
                screen.drawRect(SCREEN_DOWN, x, y - 1 + (height / 2), x + width * 0.8, y + height - 2, PW_WHITE)
                screen.drawLine(SCREEN_DOWN, x + width * 0.8, y + height - 3, x + width - 1, y - 2 + (height / 2), PW_WHITE)
                screen.drawRect(SCREEN_DOWN, x + 1, y + 1, x + width - 2, y - 1 + (height / 2), PW_DIMGREY)
                screen.drawRect(SCREEN_DOWN, x + 1, y - 2 + (height / 2), x + width * 0.8, y - 3 + height, PW_DIMGREY)
                screen.drawLine(SCREEN_DOWN, x + width * 0.8, y + height - 4, x + width - 2, y - 2 + (height / 2), PW_DIMGREY)

                if state == 1 then
                    screen.drawLine(SCREEN_DOWN, x + 2, y + 3, x + 2, y + height - 4, gui["MENU_BTN"].color["SEL_BORDER"])
                    screen.drawLine(SCREEN_DOWN, x + 3, y + height - 5, x + width * 0.8, y + height - 5, gui["MENU_BTN"].color["SEL_BORDER"])
                    screen.drawLine(SCREEN_DOWN, x + width * 0.8, y + height - 5, x + width - 3, y - 3 + (height / 2), gui["MENU_BTN"].color["SEL_BORDER"])
                    screen.drawLine(SCREEN_DOWN, x + width - 4, y + 3, x + width - 4, y - 2 + (height / 2), gui["MENU_BTN"].color["SEL_BORDER"])
                    screen.drawLine(SCREEN_DOWN, x + 3, y + 2, x + width - 4, y + 2, gui["MENU_BTN"].color["SEL_SHADE"])
                    screen.drawFillRect(SCREEN_DOWN, x + 3, y + 3, x + width - 4, y + height / 2, gui["MENU_BTN"].color["SEL_FILL"])
                    for i=0,y + height - 6 - (y + height / 2) do
                    screen.drawLine(SCREEN_DOWN, x + 3, y + i + height / 2, x + width - 6 - i * (1 / ((height / 2) / (width * 0.2))), y + i + height / 2 + 1, gui["MENU_BTN"].color["SEL_FILL"])
                    end
                else
                    screen.drawLine(SCREEN_DOWN, x + 2, y + 3, x + 2, y + height - 4, gui["MENU_BTN"].color["BORDER"])
                    screen.drawLine(SCREEN_DOWN, x + 3, y + height - 5, x + width * 0.8, y + height - 5, gui["MENU_BTN"].color["BORDER"])
                    screen.drawLine(SCREEN_DOWN, x + width * 0.8, y + height - 5, x + width - 3, y - 3 + (height / 2), gui["MENU_BTN"].color["BORDER"])
                    screen.drawLine(SCREEN_DOWN, x + width - 4, y + 3, x + width - 4, y - 2 + (height / 2), gui["MENU_BTN"].color["BORDER"])
                    screen.drawLine(SCREEN_DOWN, x + 3, y + 2, x + width - 4, y + 2, gui["MENU_BTN"].color["SHADE"])
                    screen.drawFillRect(SCREEN_DOWN, x + 3, y + 3, x + width - 4, y + height / 2, gui["MENU_BTN"].color["FILL"])
                    for i=0,y + height - 6 - (y + height / 2) do
                    screen.drawLine(SCREEN_DOWN, x + 3, y + i + height / 2, x + width - 6 - i * (1 / ((height / 2) / (width * 0.2))), y + i + height / 2 + 1, gui["MENU_BTN"].color["FILL"])
                    end
                end
                if Font.getStringWidth(font, text) > width * 0.9 and height > (Font.getCharHeight(namefont)) then
                    gui["BORDERED_TXT"].draw(SCREEN_DOWN, x + width * 0.9 / 2 - (Font.getStringWidth(namefont, text) / 2), y + height / 2 - (Font.getCharHeight(namefont) / 2), text, state, gui["MENU_BTN"].color["BORDER"], gui["MENU_BTN"].color["SEL_BORDER"], namefont)
                elseif height > (Font.getCharHeight(font)) then
                    gui["BORDERED_TXT"].draw(SCREEN_DOWN, x + width * 0.9 / 2 - (Font.getStringWidth(font, text) / 2), y + height / 2 - (Font.getCharHeight(font) / 2), text, state, gui["MENU_BTN"].color["BORDER"], gui["MENU_BTN"].color["SEL_BORDER"], font)
                end
            elseif corner == 1 then
                screen.drawRect(SCREEN_DOWN, x + width, y, x + 2, y - 1 + (height / 2), PW_WHITE)
                screen.drawRect(SCREEN_DOWN, x + width, y - 1 + (height / 2), x + width * 0.2 + 1, y + height - 2, PW_WHITE)
                screen.drawLine(SCREEN_DOWN, x + width * 0.2, y + height - 3, x + 2, y - 2 + (height / 2), PW_WHITE)
                screen.drawRect(SCREEN_DOWN, x + width - 1, y + 1, x + 3, y - 1 + (height / 2), PW_DIMGREY)
                screen.drawRect(SCREEN_DOWN, x + width - 1, y - 2 + (height / 2), x + width * 0.2 + 1, y - 3 + height, PW_DIMGREY)
                screen.drawLine(SCREEN_DOWN, x + width * 0.2, y + height - 4, x + 3, y - 2 + (height / 2), PW_DIMGREY)
                if state == 1 then
                screen.drawLine(SCREEN_DOWN, x + width - 2, y + 3, x + width - 2, y + height - 4, gui["MENU_BTN"].color["SEL_BORDER"])
                screen.drawLine(SCREEN_DOWN, x + width - 2, y + height - 5, x + width * 0.2 + 1, y + height - 5, gui["MENU_BTN"].color["SEL_BORDER"])
                screen.drawLine(SCREEN_DOWN, x + width * 0.2, y + height - 5, x + 3, y - 3 + (height / 2), gui["MENU_BTN"].color["SEL_BORDER"])
                screen.drawLine(SCREEN_DOWN, x + 3, y + 3, x + 3, y - 2 + (height / 2), gui["MENU_BTN"].color["SEL_BORDER"])
                screen.drawLine(SCREEN_DOWN, x + width - 2, y + 2, x + 4, y + 2, gui["MENU_BTN"].color["SEL_SHADE"])
                screen.drawFillRect(SCREEN_DOWN, x + width - 2, y + 3, x + 4, y + height / 2, gui["MENU_BTN"].color["SEL_FILL"])
                for i=0,y + height - 6 - (y + height / 2) do
                    screen.drawLine(SCREEN_DOWN, x + width - 2, y + i + height / 2, x + 6 + i * (1 / ((height / 2) / (width * 0.2))), y + i + height / 2 + 1, gui["MENU_BTN"].color["SEL_FILL"])
                end
                else
                screen.drawLine(SCREEN_DOWN, x + width - 2, y + 3, x + width - 2, y + height - 4, gui["MENU_BTN"].color["BORDER"])
                screen.drawLine(SCREEN_DOWN, x + width - 2, y + height - 5, x + width * 0.2 + 1, y + height - 5, gui["MENU_BTN"].color["BORDER"])
                screen.drawLine(SCREEN_DOWN, x + width * 0.2, y + height - 5, x + 3, y - 3 + (height / 2), gui["MENU_BTN"].color["BORDER"])
                screen.drawLine(SCREEN_DOWN, x + 3, y + 3, x + 3, y - 2 + (height / 2), gui["MENU_BTN"].color["BORDER"])
                screen.drawLine(SCREEN_DOWN, x + width - 2, y + 2, x + 4, y + 2, gui["MENU_BTN"].color["SHADE"])
                screen.drawFillRect(SCREEN_DOWN, x + width - 2, y + 3, x + 4, y + height / 2, gui["MENU_BTN"].color["FILL"])
                for i=0,y + height - 6 - (y + height / 2) do
                    screen.drawLine(SCREEN_DOWN, x + width - 2, y + i + height / 2, x + 6 + i * (1 / ((height / 2) / (width * 0.2))), y + i + height / 2 + 1, gui["MENU_BTN"].color["FILL"])
                end
                end
                if Font.getStringWidth(font, text) > width * 0.9 and height > (Font.getCharHeight(namefont)) then
                    gui["BORDERED_TXT"].draw(SCREEN_DOWN, x + width * 0.05 + width / 2 - (Font.getStringWidth(namefont, text) / 2), y + height / 2 - (Font.getCharHeight(namefont) / 2), text, state, gui["MENU_BTN"].color["BORDER"], gui["MENU_BTN"].color["SEL_BORDER"], namefont)
                elseif height > (Font.getCharHeight(font)) then
                    gui["BORDERED_TXT"].draw(SCREEN_DOWN, x + width * 0.1 + width / 2 - (Font.getStringWidth(font, text) / 2), y + height / 2 - (Font.getCharHeight(font) / 2), text, state, gui["MENU_BTN"].color["BORDER"], gui["MENU_BTN"].color["SEL_BORDER"], font)
                end
            elseif corner == 2 then
                screen.drawRect(SCREEN_DOWN, x, y + height, x + width - 1, y + height - (height / 2) + 3, PW_WHITE)
                screen.drawRect(SCREEN_DOWN, x, y + height - (height / 2) + 3, x + width * 0.8, y + 4, PW_WHITE)
                screen.drawLine(SCREEN_DOWN, x + width * 0.8, y + 3, x + width - 1, y + height - (height / 2) + 2, PW_WHITE)
                screen.drawRect(SCREEN_DOWN, x + 1, y + height - 1, x + width - 2, y + height - (height / 2) + 3, PW_DIMGREY)
                screen.drawRect(SCREEN_DOWN, x + 1, y + height - (height / 2) + 3, x + width * 0.8, y + 5, PW_DIMGREY)
                screen.drawLine(SCREEN_DOWN, x + width * 0.8, y + 4, x + width - 2, y + height - (height / 2) + 2, PW_DIMGREY)
                if state == 1 then
                screen.drawLine(SCREEN_DOWN, x + 2, y + height - 2, x + 2, y + 4, gui["MENU_BTN"].color["SEL_BORDER"])
                screen.drawLine(SCREEN_DOWN, x + 3, y + 5, x + width * 0.8, y + 5, gui["MENU_BTN"].color["SEL_BORDER"])
                screen.drawLine(SCREEN_DOWN, x + width * 0.8, y + 5, x + width - 3, y + height - (height / 2) + 2, gui["MENU_BTN"].color["SEL_BORDER"])
                screen.drawLine(SCREEN_DOWN, x + width - 4, y + height - 2, x + width - 4, y + height - (height / 2) + 2, gui["MENU_BTN"].color["SEL_BORDER"])
                screen.drawLine(SCREEN_DOWN, x + 3, y + height - 2, x + width - 4, y + height - 2, gui["MENU_BTN"].color["SEL_SHADE"])
                screen.drawFillRect(SCREEN_DOWN, x + 3, y + height - 2, x + width - 4, y + height - (height / 2) + 1, gui["MENU_BTN"].color["SEL_FILL"])
                for i=0,y + height - 6 - (y + height / 2) do
                    screen.drawLine(SCREEN_DOWN, x + 3, y + height - (i + height / 2), x + width - 5 - i * (1 / ((height / 2) / (width * 0.2))), y + height - (i + height / 2), gui["MENU_BTN"].color["SEL_FILL"])
                end
                else
                screen.drawLine(SCREEN_DOWN, x + 2, y + height - 2, x + 2, y + 4, gui["MENU_BTN"].color["BORDER"])
                screen.drawLine(SCREEN_DOWN, x + 3, y + 5, x + width * 0.8, y + 5, gui["MENU_BTN"].color["BORDER"])
                screen.drawLine(SCREEN_DOWN, x + width * 0.8, y + 5, x + width - 3, y + height - (height / 2) + 2, gui["MENU_BTN"].color["BORDER"])
                screen.drawLine(SCREEN_DOWN, x + width - 4, y + height - 2, x + width - 4, y + height - (height / 2) + 2, gui["MENU_BTN"].color["BORDER"])
                screen.drawLine(SCREEN_DOWN, x + 3, y + height - 2, x + width - 4, y + height - 2, gui["MENU_BTN"].color["SHADE"])
                screen.drawFillRect(SCREEN_DOWN, x + 3, y + height - 2, x + width - 4, y + height - (height / 2) + 1, gui["MENU_BTN"].color["FILL"])
                for i=0,y + height - 6 - (y + height / 2) do
                    screen.drawLine(SCREEN_DOWN, x + 3, y + height - (i + height / 2), x + width - 5 - i * (1 / ((height / 2) / (width * 0.2))), y + height - (i + height / 2), gui["MENU_BTN"].color["FILL"])
                end
                end
                if Font.getStringWidth(font, text) > width * 0.9 and height > (Font.getCharHeight(namefont)) then
                    gui["BORDERED_TXT"].draw(SCREEN_DOWN, x + width / 2 - (Font.getStringWidth(namefont, text) / 2), y + height / 2 - (Font.getCharHeight(namefont) / 2), text, state, gui["MENU_BTN"].color["BORDER"], gui["MENU_BTN"].color["SEL_BORDER"], namefont)
                elseif height > (Font.getCharHeight(font)) then
                    gui["BORDERED_TXT"].draw(SCREEN_DOWN, x + width * 0.9 / 2 - (Font.getStringWidth(font, text) / 2), y + height / 2 - (Font.getCharHeight(font) / 2), text, state, gui["MENU_BTN"].color["BORDER"], gui["MENU_BTN"].color["SEL_BORDER"], font)
                end
            elseif corner == 3 then
                screen.drawRect(SCREEN_DOWN, x + width, y + height, x + 2, y + height - (height / 2) + 3, PW_WHITE)
                screen.drawRect(SCREEN_DOWN, x + width, y + height - (height / 2) + 3, x + width * 0.2 + 1, y + 4, PW_WHITE)
                screen.drawLine(SCREEN_DOWN, x + width * 0.2, y + 3, x + 2, y + height - (height / 2) + 2, PW_WHITE)
                screen.drawRect(SCREEN_DOWN, x + width - 1, y + height - 1, x + 3, y + height - (height / 2) + 3, PW_DIMGREY)
                screen.drawRect(SCREEN_DOWN, x + width - 1, y + height - (height / 2) + 3, x + width * 0.2 + 1, y + 5, PW_DIMGREY)
                screen.drawLine(SCREEN_DOWN, x + width * 0.2, y + 4, x + 3, y + height - (height / 2) + 2, PW_DIMGREY)
                if state == 1 then
                screen.drawLine(SCREEN_DOWN, x + width - 2, y + height - 2, x + width - 2, y + 4, gui["MENU_BTN"].color["SEL_BORDER"])
                screen.drawLine(SCREEN_DOWN, x + width - 3, y + 5, x + width * 0.2 + 1, y + 5, gui["MENU_BTN"].color["SEL_BORDER"])
                screen.drawLine(SCREEN_DOWN, x + width * 0.2, y + 5, x + 3, y + height - (height / 2) + 2, gui["MENU_BTN"].color["SEL_BORDER"])
                screen.drawLine(SCREEN_DOWN, x + 3, y + height - 2, x + 3, y + height - (height / 2) + 2, gui["MENU_BTN"].color["SEL_BORDER"])
                screen.drawLine(SCREEN_DOWN, x + width - 2, y + height - 2, x + 4, y + height - 2, gui["MENU_BTN"].color["SEL_SHADE"])
                screen.drawFillRect(SCREEN_DOWN, x + width - 2, y + height - 2, x + 4, y + height - (height / 2) + 1, gui["MENU_BTN"].color["SEL_FILL"])
                for i=0,y + height - 6 - (y + height / 2) do
                    screen.drawLine(SCREEN_DOWN, x + width - 2, y + height - (i + height / 2), x + 5 + i * (1 / ((height / 2) / (width * 0.2))), y + height - (i + height / 2), gui["MENU_BTN"].color["SEL_FILL"])
                end
                else
                screen.drawLine(SCREEN_DOWN, x + width - 2, y + height - 2, x + width - 2, y + 4, gui["MENU_BTN"].color["BORDER"])
                screen.drawLine(SCREEN_DOWN, x + width - 3, y + 5, x + width * 0.2 + 1, y + 5, gui["MENU_BTN"].color["BORDER"])
                screen.drawLine(SCREEN_DOWN, x + width * 0.2, y + 5, x + 3, y + height - (height / 2) + 2, gui["MENU_BTN"].color["BORDER"])
                screen.drawLine(SCREEN_DOWN, x + 3, y + height - 2, x + 3, y + height - (height / 2) + 2, gui["MENU_BTN"].color["BORDER"])
                screen.drawLine(SCREEN_DOWN, x + width - 2, y + height - 2, x + 4, y + height - 2, gui["MENU_BTN"].color["SHADE"])
                screen.drawFillRect(SCREEN_DOWN, x + width - 2, y + height - 2, x + 4, y + height - (height / 2) + 1, gui["MENU_BTN"].color["FILL"])
                for i=0,y + height - 6 - (y + height / 2) do
                    screen.drawLine(SCREEN_DOWN, x + width - 2, y + height - (i + height / 2), x + 5 + i * (1 / ((height / 2) / (width * 0.2))), y + height - (i + height / 2), gui["MENU_BTN"].color["FILL"])
                end
                end
                if Font.getStringWidth(font, text) > width * 0.9 and height > (Font.getCharHeight(namefont)) then
                    gui["BORDERED_TXT"].draw(SCREEN_DOWN, x + width * 0.05 + width / 2 - (Font.getStringWidth(namefont, text) / 2), y + height / 2 - (Font.getCharHeight(namefont) / 2), text, state, gui["MENU_BTN"].color["BORDER"], gui["MENU_BTN"].color["SEL_BORDER"], namefont)
                elseif height > (Font.getCharHeight(font)) then
                    gui["BORDERED_TXT"].draw(SCREEN_DOWN, x + width * 0.1 + width / 2 - (Font.getStringWidth(font, text) / 2), y + height / 2 - (Font.getCharHeight(font) / 2), text, state, gui["MENU_BTN"].color["BORDER"], gui["MENU_BTN"].color["SEL_BORDER"], font)
                end
            end
        end
    }
end

gui["ADV_BTN"] = {
    color = {
        RECT = PW_SADDLE,
        SEL_RECT = PW_GOLD
    },
    draw = function(x, y, width, height, name, state)
        if not cmd[name] then cmd[name] = newRect(x, y, x + width, y + height) end
        if state == 1 then
            screen.drawFillRect(SCREEN_DOWN, x + 2, y + 2, x + width - 2, y + height - 2, gui["ADV_BTN"].color["SEL_RECT"])
        else
            screen.drawFillRect(SCREEN_DOWN, x + 2, y + 2, x + width - 2, y + height - 2, gui["ADV_BTN"].color["RECT"])
        end
        screen.drawLine(SCREEN_DOWN, x + 2, y + 1, x + width - 2, y + 2, PW_DIMGREY)
        screen.drawLine(SCREEN_DOWN, x + 2, y + height - 1, x + width - 2, y + height - 2, PW_DIMGREY)
        screen.drawLine(SCREEN_DOWN, x + 1, y + 2, x + 2, y + height - 2, PW_DIMGREY)
        screen.drawLine(SCREEN_DOWN, x + width - 2, y + 2, x + width - 1, y + height - 2, PW_DIMGREY)

        screen.drawLine(SCREEN_DOWN, x + 2, y, x + width - 2, y + 1, PW_WHITE)
        screen.drawLine(SCREEN_DOWN, x + 2, y + height - 1, x + width - 2, y + height, PW_WHITE)
        screen.drawLine(SCREEN_DOWN, x, y + 2, x + 1, y + height - 2, PW_WHITE)
        screen.drawLine(SCREEN_DOWN, x + width - 1, y + 2, x + width, y + height - 2, PW_WHITE)
    end
}

gui["TRIANGLE"] = {
    color = PW_WHITE,
    draw = function(screen_id, x1, y1, x2, y2, x3, y3, color)
        repeat
            screen.drawLine(screen_id, x1, y1, x2, y2, color)
            screen.drawLine(screen_id, x1, y1, x3, y3, color)
            screen.drawLine(screen_id, x2, y2, x3, y3, color)
            x1 = x1 + 1
            y1 = y1 + 1
            x3 = x3 + 1
            y3 = y3 - 1
            x2 = x2 - 1
        until y1 == y2
        screen.drawLine(SCREEN_DOWN, x1, (y1 + y3) / 2, x2, y2, color)
    end
}

gui["BACKGROUND"] = {
    color = {
        FILL = tocolor("181832"),
        SHADE = tocolor("272847")
    },
    draw = function()
        screen.drawFillRect(SCREEN_DOWN, 0, 0, 256, 192, gui["BACKGROUND"].color["FILL"])
        screen.drawGradientRect(SCREEN_DOWN, 0, 0, 20, 192, gui["BACKGROUND"].color["FILL"], gui["BACKGROUND"].color["FILL"], gui["BACKGROUND"].color["SHADE"], gui["BACKGROUND"].color["SHADE"])
        screen.drawGradientRect(SCREEN_DOWN, 236, 0, 256, 192, gui["BACKGROUND"].color["FILL"], gui["BACKGROUND"].color["FILL"], gui["BACKGROUND"].color["SHADE"], gui["BACKGROUND"].color["SHADE"])
    end
}

gui["CENTER_TXT"] = {
    draw = function(x, y, width, height, text, color)
        if color == nil then color = PW_WHITE end
        screen.printFont(SCREEN_DOWN, x + width / 2 - (Font.getStringWidth(font, text) / 2), y + height / 2 - (Font.getCharHeight(font) / 2), text, color, font)
    end
}

gui["BORDERED_TXT"] = {
    draw = function(screen_id, x, y, text, state, regcolor, selcolor, font)
        local color = nil
        if state == 0 then color = regcolor elseif state == 1 then color = selcolor end
        if y - 1 < 0 then
            return
        end
        screen.printFont(screen_id, x - 1, y, text, color, font)
        screen.printFont(screen_id, x + 1, y, text, color, font)
        screen.printFont(screen_id, x, y - 1, text, color, font)
        screen.printFont(screen_id, x, y + 1, text, color, font)
        screen.printFont(screen_id, x - 1, y - 1, text, color, font)
        screen.printFont(screen_id, x + 1, y + 1, text, color, font)
        screen.printFont(screen_id, x - 1, y + 1, text, color, font)
        screen.printFont(screen_id, x + 1, y - 1, text, color, font)
        screen.printFont(screen_id, x, y, text, PW_WHITE, font)
    end
}

gui["EX_PANEL"] = {
    draw = function()
        screen.drawFillRect(SCREEN_DOWN, 0, 0, 256, 16, PW_SILVER)
        screen.drawLine(SCREEN_DOWN, 0, 16, 256, 16, PW_GREY)
        screen.drawFillRect(SCREEN_DOWN, 0, 176, 256, 192, PW_SILVER)
        screen.drawLine(SCREEN_DOWN, 0, 175, 256, 175, PW_GREY)
    end
}

gui["MENU_PANEL"] = {
    draw = function()
        screen.drawFillRect(SCREEN_DOWN, 0, 0, 256, 17, PW_SILVER)
        screen.drawLine(SCREEN_DOWN, 0, 17, 256, 17, PW_GREY)
        screen.drawFillRect(SCREEN_DOWN, 0, 175, 256, 192, PW_SILVER)
        screen.drawLine(SCREEN_DOWN, 0, 174, 256, 174, PW_GREY)
    end
}

gui["BORDER"] = {
    draw = function(screen_id, x, y, width, height)
        screen.drawLine(screen_id, x + 1, y, x + width - 1, y, PW_WHITE)
        screen.drawLine(screen_id, x + width - 2, y, x + width - 2, y + height - 1, PW_WHITE)
        screen.drawLine(screen_id, x, y + height - 2, x + width - 2, y + height - 2, PW_WHITE)
        screen.drawLine(screen_id, x, y + 1, x, y + height - 1, PW_WHITE)

        screen.drawLine(screen_id, x + 1, y + 1, x + width, y + 1, PW_GREY)
        screen.drawLine(screen_id, x + width - 1, y + 1, x + width - 1, y + height - 1, PW_GREY)
        screen.drawLine(screen_id, x + 1, y + height - 1, x + width - 2, y + height - 1, PW_GREY)
        screen.drawLine(screen_id, x + 1, y + 1, x + 1, y + height - 1, PW_GREY)
    end
}

gui["SCAN_LINES"] = {
    draw = function()
        screen.setAlpha(4, 1)
        for i = 1, 64 do
            screen.drawLine(SCREEN_DOWN, 0, i * 3, 256, i * 3, PW_WHITE)
        end
        screen.setAlpha(ALPHA_OPAQUE)
    end
}

gui["HP_BAR"] = {
    draw = function()
        gui["BORDER"].draw(SCREEN_UP, 170, 8, 84, 14)
        screen.drawFillRect(SCREEN_UP, 172, 10, 252, 20, PW_BURGUNDY)
        screen.drawLine(SCREEN_UP, 172, 10, 172 + hp, 10, HP_SHADE[1])
        screen.drawLine(SCREEN_UP, 172, 11, 172 + hp, 11, HP_SHADE[2])
        screen.drawFillRect(SCREEN_UP, 172, 12, 172 + hp, 18, HP_SHADE[3])
        screen.drawLine(SCREEN_UP, 172, 18, 172 + hp, 18, HP_SHADE[4])
        screen.drawLine(SCREEN_UP, 172, 19, 172 + hp, 19, HP_SHADE[5])
        if risked_hp then
            screen.setAlpha(risked_hp.alpha, 1)
            screen.drawLine(SCREEN_UP, 172 + hp - risked_hp.hp, 10, 172 + hp, 10, HP_SHADE[6])
            screen.drawLine(SCREEN_UP, 172 + hp - risked_hp.hp, 11, 172 + hp, 11, HP_SHADE[7])
            screen.drawLine(SCREEN_UP, 172 + hp - risked_hp.hp, 12, 172 + hp, 12, HP_SHADE[8])
            screen.drawLine(SCREEN_UP, 172 + hp - risked_hp.hp, 13, 172 + hp, 13, HP_SHADE[8])
            screen.drawLine(SCREEN_UP, 172 + hp - risked_hp.hp, 14, 172 + hp, 14, HP_SHADE[8])
            screen.drawLine(SCREEN_UP, 172 + hp - risked_hp.hp, 15, 172 + hp, 15, HP_SHADE[8])
            screen.drawLine(SCREEN_UP, 172 + hp - risked_hp.hp, 16, 172 + hp, 16, HP_SHADE[8])
            screen.drawLine(SCREEN_UP, 172 + hp - risked_hp.hp, 17, 172 + hp, 17, HP_SHADE[8])
            screen.drawLine(SCREEN_UP, 172 + hp - risked_hp.hp, 18, 172 + hp, 18, HP_SHADE[9])
            screen.drawLine(SCREEN_UP, 172 + hp - risked_hp.hp, 19, 172 + hp, 19, HP_SHADE[10])
            risked_hp.alpha = risked_hp.alpha + 1 * direction
            if risked_hp.alpha == 24 then risked_hp.direction = -1
            elseif risked_hp.alpha == 0 then risked_hp.direction = 1
            end
            screen.setAlpha(ALPHA_OPAQUE)
        end
    end
}

gui["OPT_BTN"] = {
    color = {
        FILL = PW_WHITE,
        BORDER = PW_TAN,
        SHADE = PW_SILVER,
        SEL_FILL = PW_LEMON,
        SEL_BORDER = PW_GOLDENROD,
        FONT = PW_SADDLE
    },
    draw = function(x, y, width, height, text, state)
        if not cmd[text] then
            cmd[table.maxn(cmd) + 1] = newRect(x, y, x + width, y + height)
            cmd[text] = newRect(x, y, x + width, y + height)
        end
        if state == 1 then
            screen.drawFillRect(SCREEN_DOWN, x + 1, y + 1, x + width - 1, y + height - 1, gui["OPT_BTN"].color["SEL_FILL"])
            screen.drawLine(SCREEN_DOWN, x + 1, y, x + width - 1, y + 1, gui["OPT_BTN"].color["SEL_BORDER"])
            screen.drawLine(SCREEN_DOWN, x + 1, y + height - 1, x + width - 1, y + height, gui["OPT_BTN"].color["SEL_BORDER"])
            screen.drawLine(SCREEN_DOWN, x, y + 1, x + 1, y + height - 1, gui["OPT_BTN"].color["SEL_BORDER"])
            screen.drawLine(SCREEN_DOWN, x + width - 1, y + 1, x + width, y + height - 1, gui["OPT_BTN"].color["SEL_BORDER"])
        else
            screen.drawFillRect(SCREEN_DOWN, x + 1, y + 1, x + width - 1, y + height - 1, gui["OPT_BTN"].color["FILL"])
            screen.drawLine(SCREEN_DOWN, x + 1, y, x + width - 1, y + 1, gui["OPT_BTN"].color["BORDER"])
            screen.drawLine(SCREEN_DOWN, x + 1, y + height - 1, x + width - 1, y + height, gui["OPT_BTN"].color["BORDER"])
            screen.drawLine(SCREEN_DOWN, x, y + 1, x + 1, y + height - 1, gui["OPT_BTN"].color["BORDER"])
            screen.drawLine(SCREEN_DOWN, x + width - 1, y + 1, x + width, y + height - 1, gui["OPT_BTN"].color["BORDER"])
            screen.drawLine(SCREEN_DOWN, x + 1, y + height - 2, x + width - 1, y + height - 1, gui["OPT_BTN"].color["SHADE"])
        end
        for i=0,1 do
        screen.printFont(SCREEN_DOWN, x + i + width / 2 - (Font.getStringWidth(font, text) / 2), y + height / 2 - (Font.getCharHeight(font) / 2), text, gui["OPT_BTN"].color["FONT"], font)
        end
    end
}

gui["OPT_CURSOR"] = {
    color = {
        BORDER = PW_TANGERINE,
        FILL = PW_YELLOW
    },
    draw = function(x, y, width, height, state)
        if clicking == true and not state and height ~= 28 then
            return
        end
        screen.drawRect(SCREEN_DOWN, x - 2, y, x + 1, y + 9, gui["OPT_CURSOR"].color["BORDER"])
        screen.drawRect(SCREEN_DOWN, x - 1, y - 1, x + 2, y + 2, gui["OPT_CURSOR"].color["BORDER"])
        screen.drawRect(SCREEN_DOWN, x, y - 2, x + 9, y + 1, gui["OPT_CURSOR"].color["BORDER"])
        screen.drawLine(SCREEN_DOWN, x - 1, y + 1, x - 1, y + 8, gui["OPT_CURSOR"].color["FILL"])
        screen.drawLine(SCREEN_DOWN, x + 1, y - 1, x + 8, y - 1, gui["OPT_CURSOR"].color["FILL"])
        screen.drawLine(SCREEN_DOWN, x, y, x, y, gui["OPT_CURSOR"].color["FILL"])

        screen.drawRect(SCREEN_DOWN, x + width - 1, y, x + width + 2, y + 9, gui["OPT_CURSOR"].color["BORDER"])
        screen.drawRect(SCREEN_DOWN, x + width - 2, y - 1, x + width + 1, y + 2, gui["OPT_CURSOR"].color["BORDER"])
        screen.drawRect(SCREEN_DOWN, x + width - 9, y - 2, x + width, y + 1, gui["OPT_CURSOR"].color["BORDER"])
        screen.drawLine(SCREEN_DOWN, x + width, y + 1, x + width, y + 8, gui["OPT_CURSOR"].color["FILL"])
        screen.drawLine(SCREEN_DOWN, x + width - 8, y - 1, x + width - 1, y - 1, gui["OPT_CURSOR"].color["FILL"])
        screen.drawLine(SCREEN_DOWN, x + width - 1, y, x + width - 1, y, gui["OPT_CURSOR"].color["FILL"])

        screen.drawRect(SCREEN_DOWN, x - 2, y + height - 9, x + 1, y + height, gui["OPT_CURSOR"].color["BORDER"])
        screen.drawRect(SCREEN_DOWN, x - 1, y + height - 2, x + 2, y + height + 1, gui["OPT_CURSOR"].color["BORDER"])
        screen.drawRect(SCREEN_DOWN, x, y + height - 1, x + 9, y + height + 2, gui["OPT_CURSOR"].color["BORDER"])
        screen.drawLine(SCREEN_DOWN, x - 1, y + height - 8, x - 1, y + height - 1, gui["OPT_CURSOR"].color["FILL"])
        screen.drawLine(SCREEN_DOWN, x + 1, y + height, x + 8, y + height, gui["OPT_CURSOR"].color["FILL"])
        screen.drawLine(SCREEN_DOWN, x, y + height - 1, x, y + height - 1, gui["OPT_CURSOR"].color["FILL"])

        screen.drawRect(SCREEN_DOWN, x + width - 1, y + height - 9, x + width + 2, y + height, gui["OPT_CURSOR"].color["BORDER"])
        screen.drawRect(SCREEN_DOWN, x + width - 2, y + height - 2, x + width + 1, y + height + 1, gui["OPT_CURSOR"].color["BORDER"])
        screen.drawRect(SCREEN_DOWN, x + width - 9, y + height - 1, x + width, y + height + 2, gui["OPT_CURSOR"].color["BORDER"])
        screen.drawLine(SCREEN_DOWN, x + width, y + height - 8, x + width, y + height - 1, gui["OPT_CURSOR"].color["FILL"])
        screen.drawLine(SCREEN_DOWN, x + width - 8, y + height, x + width - 1, y + height, gui["OPT_CURSOR"].color["FILL"])
        screen.drawLine(SCREEN_DOWN, x + width - 1, y + height - 1, x + width - 1, y + height - 1, gui["OPT_CURSOR"].color["FILL"])
    end
}

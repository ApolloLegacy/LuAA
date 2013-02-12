--[[
                     _               ____ ____
                    | |             / _  |  _ \
                    | |      __  __/ /_| | |_\ \
                    | |     / / / /  __  |  __  \
                    | |____/ /_/ /  /  | | |  \  \
                    |______\____/__/   |_|_|   \__\

    Name :          LuAA - shell.lua
                    Constructs methods for drawing game output.
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

paused = false
blinkTimer = 0

shell = {
    draw = function()
        if not paused then blinkTimer = blinkTimer + 1 end

        if bg.img then
            Map.scroll(bg.map, bg.x, bg.y)
            Map.draw(SCREEN_UP, bg.map, 0, 0, 32, 24)
            --screen.blit(SCREEN_UP, bg.x + shake_event.x, bg.y + shake_event.y, bg.img)
        end

        if char.name then
            char.draw(blinkTimer)
        end

        if fg.img then
            Map.scroll(fg.map, fg.x, fg.y)
            Map.draw(SCREEN_UP, fg.map, 0, 0, 32, 24)
        end

        if testimony then gui["HP_BAR"].draw() end

        if ev_event.frame > 0 then
            if ev_event.frame == ev_event.length then
                ev_event.direction = -1
                ev_event.frame = 3
            else
                if ev_event.frame == 1 then
                    point = 0
                    if ev_event.bg then
                        Image.destroy(ev_event.bg)
                        ev_event.bg = nil
                    end
                    ev_event.bg = Image.load("art/gui/ev_frame-0.gif", RAM)
                elseif ev_event.frame == 2 then
                    point = 5
                    Image.destroy(ev_event.bg)
                    ev_event.bg = nil
                    ev_event.bg = Image.load("art/gui/ev_frame-1.gif", RAM)
                elseif ev_event.frame == 3 then
                    point = 13
                    Image.destroy(ev_event.bg)
                    ev_event.bg = nil

                    if ev_event.fg then
                        Image.destroy(ev_event.fg)
                        ev_event.fg = nil
                    end
                    ev_event.bg = Image.load("art/gui/ev_frame-2.gif", RAM)
                    ev_event.fg = Image.load("art/ev/" .. ev_event.pic, RAM)
                end

                if ev_event.corner == TOP_LEFT then
                    screen.blit(SCREEN_UP, point, point, ev_event.bg)
                    if ev_event.fg then screen.blit(SCREEN_UP, point + 3, point + 3, ev_event.fg) end
                elseif ev_event.corner == TOP_RIGHT then
                    screen.blit(SCREEN_UP, 256 - Image.width(ev_event.bg) - point, point, ev_event.bg)
                    if ev_event.fg then screen.blit(SCREEN_UP, 256 - Image.width(ev_event.bg) - point + 3, point + 3, ev_event.fg) end
                end
                ev_event.frame = ev_event.frame + ev_event.direction

                if ev_event.frame == 0 then
                    Image.destroy(ev_event.bg)
                    ev_event.bg = nil
                    Image.destroy(ev_event.fg)
                    ev_event.fg = nil
                end
            end
        end

        if addev_event.fg then
            screen.drawFillRect(SCREEN_UP, addev_event.x, addev_event.y, addev_event.x + addev_event.w, addev_event.y + addev_event.h, PW_PERU)
            gui["BORDER"].draw(SCREEN_UP, addev_event.x, addev_event.y, addev_event.w, addev_event.h)
            screen.blit(SCREEN_UP, addev_event.x + 8, addev_event.y + 8, addev_event.fg)
            gui["BORDER"].draw(SCREEN_UP, addev_event.x + 6, addev_event.y + 6, 68, 68)
            screen.drawFillRect(SCREEN_UP, addev_event.x + 91, addev_event.y + 8, addev_event.x + 246, addev_event.y + 25, PW_DIMGREY)
            screen.drawFillRect(SCREEN_UP, addev_event.x + 92, addev_event.y + 26, addev_event.x + 246, addev_event.y + 72, PW_LIGHTGREEN)
            screen.drawLine(SCREEN_UP, addev_event.x + 91, addev_event.y + 25, addev_event.x + 246, addev_event.y + 26, PW_PALEGREEN)
            screen.drawLine(SCREEN_UP, addev_event.x + 91, addev_event.y + 26, addev_event.x + 91, addev_event.y + 72, PW_PALEGREEN)
            gui["BORDER"].draw(SCREEN_UP, addev_event.x + 89, addev_event.y + 6, 159, 68)
            screen.printFont(SCREEN_UP, addev_event.x + 91 + (155 / 2) - (Font.getStringWidth(font, addev_event.ev.name) / 2), addev_event.y + 7, addev_event.ev.name, PW_ORANGE, font)
            for i,v in ipairs(addev_event.ev.info) do
                screen.printFont(SCREEN_UP, addev_event.x + 96, addev_event.y + 28 + 15 * (i - 1), v, PW_PALEGREEN, arial)
                screen.printFont(SCREEN_UP, addev_event.x + 96, addev_event.y + 27 + 15 * (i - 1), v, PW_DIMGREY, arial)
            end
            if addev_event.x > 0 then addev_event.x = addev_event.x - 16 end
        end

        if speaker.name then
            screen.setAlpha(20, 1)
            screen.drawFillRect(SCREEN_UP, textbox.x, textbox.y, textbox.x + textbox.w, textbox.y + textbox.h, PW_BLACK)
            gui["BORDER"].draw(SCREEN_UP, textbox.x, textbox.y, textbox.w, textbox.h)
            if speaker.name and speaker.name ~= "" then
                screen.drawFillRect(SCREEN_UP, textbox.x + 3, textbox.y - 12, Font.getStringWidth(namefont, speaker.name) + 6, textbox.y - 1, PW_MIDNIGHTBLUE)
                gui["BORDER"].draw(SCREEN_UP, textbox.x + 1, textbox.y - 14, Font.getStringWidth(namefont, speaker.name) + 6, 16)
            end
            screen.setAlpha(ALPHA_OPAQUE)
            if speaker.name then screen.printFont(SCREEN_UP, textbox.x + 4, textbox.y - 12, speaker.name, PW_WHITE, namefont) end

            for j in pairs(letter) do
                screen.printFont(SCREEN_UP, textbox.x + 9 + letter[j].x, textbox.y - 12 + letter[j].y, letter[j].character, letter[j].color, font)
            end
        end

        if textbox.message then
            screen.drawFillRect(SCREEN_UP, 2, textbox.y + textbox.h + 2, 254, 192, PW_SIENNA)
            gui["BORDER"].draw(SCREEN_UP, 0, textbox.y + textbox.h, 256, 26)
            gui["BORDERED_TXT"].draw(SCREEN_UP, 128 - (Font.getStringWidth(font, textbox.message) / 2), textbox.y + textbox.h + 2, textbox.message, 0, gui["MENU_BTN"].color["BORDER"], gui["MENU_BTN"].color["SEL_BORDER"], font)
        end

        gui.draw()
    end
}

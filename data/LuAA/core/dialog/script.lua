--[[
                     _               ____ ____
                    | |             / _  |  _ \
                    | |      __  __/ /_| | |_\ \
                    | |     / / / /  __  |  __  \
                    | |____/ /_/ /  /  | | |  \  \
                    |______\____/__/   |_|_|   \__\

    Name :          LuAA - script.lua
                    Constructs dialog for script output.
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

fontcolor = Color.new(31, 31, 31)
alignment = ALIGN_LEFT

letter = {}

shake_event = {}
shake_event.length = 0
shake_event.offset = 0
shake_event.x = 0
shake_event.y = 0

ev_event = {}
ev_event.frame = 0
ev_event.direction = 1
ev_event.length = 0
ev_event.corner = TOP_LEFT
ev_event.pic = ""
ev_event.fg = nil
ev_event.bg = nil

addev_event = {}
addev_event.x = 0
addev_event.y = 0
addev_event.w = 0
addev_event.h = 0
addev_event.ev = nil
addev_event.fg = nil

function msg(text)
    local line = 1
    local start = 1
    local finish = 1
    local offset = 0
    local func = nil
    local param = nil

    letter = {}
    letter[1] = {}
    letter[1].character = ""
    letter[1].x = 0
    letter[1].y = 0
    letter[1].color = fontcolor

    if ev_event.frame ~= 0 then
        ev_event.frame = 0
        Image.destroy(ev_event.bg)
        ev_event.bg = nil
        Image.destroy(ev_event.fg)
        ev_event.fg = nil
    end

    if shake_event.length > 0 then
        shake_event = {}
        shake_event.length = 0
        shake_event.offset = 0
        shake_event.x = 0
        shake_event.y = 0
    end

    if char.name then
        if speaker.name == char.name then
            char.construct(char.active)
        else
            char.construct(char.idle)
        end
    end

    for i = 1, #text + 1 do
        i = i - offset
        if i > #text then break end
        if string.char(text:byte(i)) == "{" then
            if not (string.char(text:byte(i + 1)) == "n" and string.char(text:byte(i + 2)) == "}") then
                if string.find(text, "%(", i + 1) then
                    func = text:sub(i + 1, string.find(text, "%(", i + 1) - 1)
                    param = text:sub(string.find(text, "%(", i + 1) + 1, string.find(text, ")", i + 1) - 1)
                    suffix = text:sub(i + #func + #param + 4, #text)
                else
                    func = text:sub(i + 1, string.find(text, "}", i + 1) - 1)
                    suffix = text:sub(i + #func + 2, #text)

                end
                prefix = text:sub(1, i - 1)
                text = prefix .. suffix
                offset = offset + 1
            else
                prefix = text:sub(1, i - 1)
                suffix = text:sub(i + 3, #text)
                text = prefix .. suffix
                start = i
                finish = i
                line = line + 1
                newline = true
                offset = offset + 1
            end
        end
            letter[i] = {}
            letter[i].y = 16 * line
            letter[i].character = text:sub(i, i)
            letter[i].color = fontcolor

            if i == 1 then
                if alignment == ALIGN_LEFT then
                    letter[i].x = 0
                elseif alignment == ALIGN_CENTER then
                    letter[i].x = 128 - Font.getStringWidth(font, letter[i].character) / 2
                end
            elseif offsetnL then
                if alignment == ALIGN_LEFT then
                    letter[i].x = 0
                elseif alignment == ALIGN_CENTER then
                    letter[i].x = 128 - Font.getStringWidth(font, letter[i].character) / 2
                end
                offsetnL = false
            elseif newline then
                if alignment == ALIGN_LEFT then
                    letter[i].x = 0
                elseif alignment == ALIGN_CENTER then
                    letter[i].x = 128 - Font.getStringWidth(font, letter[i].character) / 2
                end
                offsetnL = true
                newline = false
            else
                if alignment == ALIGN_LEFT then
                    letter[i].x = letter[i - 1].x + Font.getStringWidth(font, letter[i - 1].character)
                elseif alignment == ALIGN_CENTER then
                    finish = finish + 1
                    for j = start + 1, finish do
                        letter[j-1].x = letter[j-1].x - Font.getStringWidth(font, letter[i-1].character) / 2
                    end
                    letter[i].x = letter[i - 1].x + Font.getStringWidth(font, letter[i - 1].character)
                end
                if letter[i].x > 230 then
                    local j = 0
                    local t = text:sub(1, i)

                    while true do
                        if string.find(t, " ", #t - j) ~= nil then
                            prefix = t:sub(1, string.find(t, " ", #t - j))
                            line = line + 1
                            letter[#prefix].y = 16 * line
                            letter[#prefix].character = ""
                            letter[#prefix].color = fontcolor
                            if alignment == ALIGN_LEFT then
                                letter[#prefix].x = 0
                            elseif alignment == ALIGN_CENTER then
                                letter[#prefix].x = 128 - Font.getStringWidth(font, letter[#prefix].character) / 2
                                start = i
                                finish = i
                            end

                            for i=#prefix+1, #t do
                                letter[i].x = letter[i - 1].x + Font.getStringWidth(font, letter[i - 1].character)
                                letter[i].y = 16 * line
                                letter[i].character = text:sub(i, i)
                                letter[i].color = fontcolor
                            end
                            break
                        end
                        j = j + 1
                    end
                end
            end

        gui.draw()

        if shake_event.length > 0 then
            shake_event.length = shake_event.length - 1
            shake_event.x = math.random(-1, 1) * shake_event.offset
            shake_event.y = math.random(-1, 1) * shake_event.offset
        elseif shake_event.offset > 0 then
            shake_event.offset = 0
            shake_event.x = 0
            shake_event.y = 0
        end

        if bg.img then
            Map.scroll(bg.map, bg.x + shake_event.x, bg.y + shake_event.y)
            Map.draw(SCREEN_UP, bg.map, 0, 0, 32, 24)
            --screen.blit(SCREEN_UP, bg.x + shake_event.x, bg.y + shake_event.y, bg.img)
        end

        if char.name then
            char.draw(i)
        end

        if fg.img then
            Map.scroll(fg.map, fg.x + shake_event.x, fg.y + shake_event.y)
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

                    if ev_event.fg then
                        Image.destroy(ev_event.fg)
                        ev_event.fg = nil
                    end

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
            screen.drawFillRect(SCREEN_UP, 0, 192 - 64, 256, 192, PW_BLACK)
            gui["BORDER"].draw(SCREEN_UP, 0, 192 - 64, 256, 64)
            if speaker.name and speaker.name ~= "" then
                screen.drawFillRect(SCREEN_UP, 3, 116, Font.getStringWidth(namefont, speaker.name) + 6, 127, PW_MIDNIGHTBLUE)
                gui["BORDER"].draw(SCREEN_UP, 1, 114, Font.getStringWidth(namefont, speaker.name) + 6, 16)
            end
            screen.setAlpha(ALPHA_OPAQUE)
            if speaker.name then screen.printFont(SCREEN_UP, 4, 116, speaker.name, PW_WHITE, namefont) end
            if i > 1 then
                if speaker.sound and isSpoken(letter[i].character, letter[i - 1].character) then
                    Sound.startSFX(speaker.sound)
                end
            end
            for j in pairs(letter) do
                screen.printFont(SCREEN_UP, 9 + letter[j].x, 116 + letter[j].y, letter[j].character, letter[j].color, font)
            end
        end

        if func then
            _G[ func ](param)
            func = nil
            param = nil
        end
        render()
    end

    if continueTalking then
        talking = true
        continueTalking = false
    else
        talking = false
    end

    if char.idle then
        char.construct(char.idle)
    end

    while not talking do
        gui.update()
    end

    if addev_event.fg then
        repeat
            shell.draw()
            render()
            addev_event.x = addev_event.x - 16
        until addev_event.x == -256
        Image.destroy(addev_event.fg)
        addev_event.fg = nil
        addev_event = {}
        addev_event.x = 0
        addev_event.y = 0
        addev_event.w = 0
        addev_event.h = 0
        addev_event.ev = nil
        addev_event.fg = nil
    end
    state = 0
    direction = 1
end

function flash(c)
    screen.drawFillRect(SCREEN_UP, 0, 0, 256, 192, tocolor (c))
end

function showshake(l, o)
    shake_event = {}
    shake_event.length = l
    shake_event.offset = o
end

function showev(l, c, ev)
    ev_event = {}
    ev_event.frame = 1
    ev_event.direction = 1
    ev_event.length = l
    ev_event.corner = c
    ev_event.pic = ev.pic
    ev_event.fg = nil
    ev_event.bg = nil
end

function showaddev(ev)
    addev_event = {}
    addev_event.x = 256
    addev_event.y = 16
    addev_event.w = 256
    addev_event.h = 80
    addev_event.ev = ev
    addev_event.fg = Image.load("art/ev/" .. ev.pic, RAM)
end

function goto(s, ...)
    _G[s](...)
end

function reset()
    Image.destroy(bg.img)
    bg.img = nil
    Image.destroy(char.img)
    char.img = nil
    Image.destroy(fg.img)
    fg.img = nil
    gui = nil
    dofile("core/core.lua")
end

function newalign(a)
    alignment = a
end

function newcolor(c)
    fontcolor = tocolor(c)
end

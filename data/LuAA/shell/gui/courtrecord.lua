--[[
                     _               ____ ____
                    | |             / _  |  _ \
                    | |      __  __/ /_| | |_\ \
                    | |     / / / /  __  |  __  \
                    | |____/ /_/ /  /  | | |  \  \
                    |______\____/__/   |_|_|   \__\

    Name :          LuAA - courtrecord.lua
                    Constructs methods for drawing/updating the court record GUI.
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

category = EVIDENCE

cmd = {}
cmd[1] = newRect(36, 64, 76, 104)
cmd[2] = newRect(84, 64, 124, 104)
cmd[3] = newRect(112, 64, 172, 104)
cmd[4] = newRect(160, 64, 220, 104)
cmd[5] = newRect(36, 112, 76, 152)
cmd[6] = newRect(84, 112, 124, 152)
cmd[7] = newRect(112, 112, 172, 152)
cmd[8] = newRect(160, 112, 220, 152)
cmd["Back"] = newRect(0, 160, 80, 192)
cmd["ev_Present"] = newRect(88, 0, 168, 32)
cmd["Category"] = newRect(176, 0, 256, 32)

record = {}
page = 1
selectedItem = 1
selected = nil

if DYNAMIC_GUI == false then
    btn = {}
    gui.loadBtn("Profiles")
    gui.loadBtn("Evidence")
    gui.loadBtn("Back")
    gui.loadBtn("ev_Present")
end

function gui.draw()
    gui["BACKGROUND"].draw()
    screen.drawFillRect(SCREEN_DOWN, 27, 38, 230, 54, PW_DIMGREY)
    gui["BORDER"].draw(SCREEN_DOWN, 25, 36, 207, 20)
    screen.drawFillRect(SCREEN_DOWN, 24, 56, 232, 160, PW_WHEAT)
    screen.drawRect(SCREEN_DOWN, 24, 56, 232, 160, PW_PERU)

    for i = 1, 8 do
        local x_buffer = i - 1
        local y_buffer = 0
        if i > 4 then
            x_buffer = i - 5
            y_buffer = 48
        end
        screen.drawRect(SCREEN_DOWN, 36 + 48 * x_buffer, 64 + y_buffer, 76 + 48 * x_buffer, 104 + y_buffer, PW_PERU)
        if record[i] then
            Image.scale(record[i], 40, 40)
            screen.blit(SCREEN_DOWN, 36 + 48 * x_buffer, 64 + y_buffer, record[i])
        end
        if i == selectedItem then
            gui["BORDER"].draw(SCREEN_DOWN, 36 + 48 * x_buffer - 2, 64 - 2 + y_buffer, 44, 44)
        end
    end
    gui["ADV_BTN"].draw(0, 56, 16, 96, "Left")
    gui["ADV_BTN"].draw(240, 56, 16, 96, "Right")
    gui["SCAN_LINES"].draw()

    gui["MENU_PANEL"].draw()
    if category == EVIDENCE then
        gui["MENU_BTN"].draw(176, 0, 80, 32, "Profiles", 0, 1)
        if evidence[selectedItem] then
            screen.printFont(SCREEN_DOWN, 27 + (203 / 2) - (Font.getStringWidth(font, evidence[((page - 1) * 8) + selectedItem].name) / 2), 36, evidence[((page - 1) * 8) + selectedItem].name, PW_ORANGE, font)
        end
    else
        gui["MENU_BTN"].draw(176, 0, 80, 32, "Evidence", 0, 1)
        if profile[selectedItem] then
            screen.printFont(SCREEN_DOWN, 27 + (203 / 2) - (Font.getStringWidth(font, profile[((page - 1) * 8) + selectedItem].name) / 2), 36, profile[((page - 1) * 8) + selectedItem].name, PW_ORANGE, font)
        end
    end
    if not dynamic_pst then gui["MENU_BTN"].draw(0, 160, 80, 32, "Back", 0, 2) end
    if pst then gui["MENU_BTN"].draw(88, 0, 80, 32, "ev_Present", 0, 0) end

end

function gui_.reloadItems()
    for i = 1, 8 do
        if record[i] then
            Image.destroy(record[i])
            record[i] = nil
        end
        local item = nil
        if category == EVIDENCE and evidence[i + ((page - 1) * 8)] ~= nil then
            if DYNAMIC_GUI == false then
                Image.destroy(btn["Profiles"])
                btn["Profiles"] = nil
                gui.loadBtn("Profiles")
            end
            item = "art/ev/" .. evidence[i + ((page - 1) * 8)].pic
        elseif category == PROFILES and profile[i + ((page - 1) * 8)] ~= nil then
            if DYNAMIC_GUI == false then
                Image.destroy(btn["Evidence"])
                btn["Evidence"] = nil
                gui.loadBtn("Evidence")
            end
            item = "art/ev/" .. profile[i + ((page - 1) * 8)].pic
        end
        if item then
            record[i] = Image.load(item, RAM)
        end
    end
end

gui_.reloadItems()

gui.fade_in()

function gui_.selectItem(slot)
    gui_.constructed = false
    gui_.new = "ev_profile"
    examining = slot
end

function gui.deconstruct()
    gui.fade_out()
    cmd = nil
    for i = 1, 8 do
        if record[i] then
            Image.destroy(record[i])
            record[i] = nil
        end
    end
    if DYNAMIC_GUI == false then
        Image.destroy(btn["Profiles"])
        btn["Profiles"] = nil
        Image.destroy(btn["Evidence"])
        btn["Evidence"] = nil
        Image.destroy(btn["Back"])
        btn["Back"] = nil
        Image.destroy(btn["ev_Present"])
        btn["ev_Present"] = nil
    end
    record = {}
    selectedItem = nil
    if examining then
        _category = category
        _page = page
        _pst = pst
    end
    gui.construct(gui_.new)
    if examining then
        category = _category
        pst = _pst
        item = (_page - 1) * 8 + examining
        if _category == EVIDENCE then ev = evidence[item] else ev = profile[item] end
        ev_pic = Image.load("art/ev/" .. ev.pic, RAM)
        gui_.reloadItem()
        examining = nil
        _category = nil
        _page = nil
        _pst = nil
    else
        category = nil
        page = nil
        pst = false
    end
    if selected then
        letter = {}
        if not dynamic then interact(PRESENT, selected)
        else talking = true
        end
    end
end

function gui.update()
    shell.draw()

    Controls.read()
    if (Stylus.released) then
        for i = 1, 8 do
            if pointCollide(cmd[i], Stylus) then
                if category == EVIDENCE and evidence[(page - 1) * 8 + i] ~= nil then
                    gui_.selectItem(i)
                    return
                elseif category == PROFILES and profile[(page - 1) * 8 + i] ~= nil then
                    gui_.selectItem(i)
                    return
                end
            end
        end
        if pointCollide(cmd["Left"], Stylus) and page > 1 then
            gui.click("ADV_BTN", "Left")
            page = page - 1
            gui_.reloadItems()
        elseif pointCollide(cmd["Right"], Stylus) then
            if category == EVIDENCE and evidence[page * 8 + 1] ~= nil then
                gui.click("ADV_BTN", "Right")
                if evidence[page * 8 + selectedItem] == nil then
                    selectedItem = 1
                end
                page = page + 1
                gui_.reloadItems()
            elseif profile[page * 8 + 1] ~= nil then
                if profile[page * 8 + selectedItem] == nil then
                    selectedItem = 1
                end
                page = page + 1
                gui_.reloadItems()
            end
        end
    end
    if (Stylus.released and pointCollide(cmd["Category"], Stylus)) or Keys.newPress.R then
            if category == EVIDENCE then
                gui.click("MENU_BTN", "Profiles", 1)
                cmd["Profiles"] = nil
                category = PROFILES
                if profile[(page - 1) * 8 + selectedItem] == nil then
                    page = 1
                    selectedItem = 1
                end
            else
                gui.click("MENU_BTN", "Evidence", 1)
                cmd["Evidence"] = nil
                category = EVIDENCE
                if evidence[(page - 1) * 8 + selectedItem] == nil then
                    page = 1
                    selectedItem = 1
                end
            end
            clicking = false
            gui_.reloadItems()
    elseif ((Stylus.released and pointCollide(cmd["Back"], Stylus)) or Keys.newPress.B) and dynamic_pst == false then
            gui.click("MENU_BTN", "Back" , 2)
            gui_.constructed = false
            gui_.new = gui.saved[1]
    elseif ((Stylus.released and pointCollide(cmd["ev_Present"], Stylus)) or Keys.newPress.Y) and pst == true then
        gui.click("MENU_BTN", "ev_Present" , 0)
        local ev_id = (page - 1) * 8 + selectedItem
        local _category = category
        gui_.constructed = false
        gui_.new = "advance"
        if _category == EVIDENCE then
            selected = evidence[ev_id].name
        else
            selected = profile[ev_id].name
        end
    end

    if Keys.newPress.A then
        if category == EVIDENCE and evidence[(page - 1) * 8 + selectedItem] ~= nil then
            gui_.selectItem(selectedItem)
        elseif category == PROFILES and profile[(page - 1) * 8 + selectedItem] ~= nil then
            gui_.selectItem(selectedItem)
        end
    end
    if Keys.newPress.Up and selectedItem > 4 then selectedItem = selectedItem - 4 end
    if Keys.newPress.Left then
        if selectedItem % 4 ~= 1 then selectedItem = selectedItem - 1
        elseif page > 1 then
            page = page - 1
            selectedItem = selectedItem + 3
        end
        gui_.reloadItems()
    end
    if category == EVIDENCE then
        if Keys.newPress.Down and selectedItem < 5 and evidence[selectedItem + ((page - 1) * 8) + 4] ~= nil then selectedItem = selectedItem + 4 end
        if Keys.newPress.Right and evidence[selectedItem + ((page - 1) * 8) + 1] ~= nil then
            if selectedItem % 4 ~= 0 then selectedItem = selectedItem + 1
            elseif evidence[page * 8 + 1] ~= nil then
                if selectedItem == 8 and evidence[page * 8 + 5] ~= nil then selectedItem = 5 else selectedItem = 1 end
                    page = page + 1
                    gui_.reloadItems()
            end
        end
    else
        if Keys.newPress.Down and selectedItem < 5 and profile[selectedItem + ((page - 1) * 8) +  4] ~= nil then selectedItem = selectedItem + 4 end
        if Keys.newPress.Right and profile[selectedItem + ((page - 1) * 8) + 1] ~= nil then
            if selectedItem % 4 ~= 0 then selectedItem = selectedItem + 1
            elseif profile[page * 8 + 1].name ~= nil then
                if selectedItem == 8 and profile[page * 8 + 5] ~= nil then selectedItem = 5 else selectedItem = 1 end
                    page = page + 1
                    gui_.reloadItems()
            end
        end
    end
    if not gui_.constructed then gui.deconstruct() end

    if not clicking then render() end
end

--[[
                     _               ____ ____
                    | |             / _  |  _ \
                    | |      __  __/ /_| | |_\ \
                    | |     / / / /  __  |  __  \
                    | |____/ /_/ /  /  | | |  \  \
                    |______\____/__/   |_|_|   \__\

    Name :          LuAA - animation.lua
                    Constructs dialog for dynamic animation output.
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

function yell(words)
    y_img = Image.load("art/fg/" .. words .. ".png", VRAM)
    y_map = Map.new(y_img, "art/fg/" .. words .. ".map", 32, 32, 8, 8)

    local timer = 0
    repeat
        gui.draw()
        if bg.img then Map.draw(SCREEN_UP, bg.map, bg.x + shake_event.x, bg.y + shake_event.y, 32, 24) end
        if char.img then
            char.draw(timer)
        end
        if fg.img then Map.draw(SCREEN_UP, fg.map, fg.x + shake_event.x, fg.y + shake_event.y, 32, 24) end
        Map.scroll(y_map, math.random(-1, 1), math.random(-1, 1))
        Map.draw(SCREEN_UP, y_map, 0, 0, 32, 24)
        render()
        timer = timer + 1
    until timer == 11
    Image.destroy(y_img)
    y_img = nil
end

function alpha_inout(words)
    f_img = Image.load("art/fg/" .. words .. ".png", VRAM)
    f_map = Map.new(f_img, "art/fg/" .. words .. ".map", 32, 32, 8, 8)

    local timer = 0
    local alpha = 2
    repeat
        gui.draw()
        if bg.img then Map.draw(SCREEN_UP, bg.map, bg.x + shake_event.x, bg.y + shake_event.y, 32, 24) end
        if char.img then
            char.draw(alpha)
        end
        if fg.img then Map.draw(SCREEN_UP, fg.map, fg.x + shake_event.x, fg.y + shake_event.y, 32, 24) end
        screen.setAlpha(alpha, 1)
        Map.draw(SCREEN_UP, f_map, 0, 0, 32, 24)
        render()
        screen.setAlpha(ALPHA_OPAQUE)
        alpha = alpha + 2
    until alpha == 32
    repeat
        gui.draw()
        if bg.img then Map.draw(SCREEN_UP, bg.map, bg.x + shake_event.x, bg.y + shake_event.y, 32, 24) end
        if char.img then
            char.draw(timer)
        end
        if fg.img then Map.draw(SCREEN_UP, fg.map, fg.x + shake_event.x, fg.y + shake_event.y, 32, 24) end
        Map.draw(SCREEN_UP, f_map, 0, 0, 32, 24)
        render()
        timer = timer + 1
    until timer == 60
    repeat
        gui.draw()
        if bg.img then Map.draw(SCREEN_UP, bg.map, bg.x + shake_event.x, bg.y + shake_event.y, 32, 24) end
        if char.img then
            char.draw(alpha)
        end
        if fg.img then Map.draw(SCREEN_UP, fg.map, fg.x + shake_event.x, fg.y + shake_event.y, 32, 24) end
        screen.setAlpha(alpha, 1)
        Map.draw(SCREEN_UP, f_map, 0, 0, 32, 24)
        render()
        screen.setAlpha(ALPHA_OPAQUE)
        alpha = alpha - 2
    until alpha == 0
    Image.destroy(f_img)
    f_img = nil
end

function objection()
    yell("objection")
end

function holdit()
    yell("holdit")
end

function takethat()
    yell("takethat")
end

--function gotcha()
--    yell("gotcha")
--end

function gavel()
    local path = fg.path
    local size = fg.size
    newfg("pregavel", 512)
    local timer = 0
    repeat
        gui.draw()
        Map.scroll(fg.map, 32 * timer, 0)
        Map.draw(SCREEN_UP, fg.map, 0, 0, 32, 24)
        render()
        timer = timer + 1
    until timer == 2
    newfg("gavel", 256)
    timer = 0
    repeat
        gui.draw()
        Map.scroll(fg.map, -2 + math.random(-1, 2), math.random(-1, 1))
        Map.draw(SCREEN_UP, fg.map, 0, 0, 32, 24)
        render()
        timer = timer + 1
    until timer == 11
    newfg(path, size)
end

function jury()
    local path = bg.path
    local size = bg.size

    newbg("locations/courtroomoverview", 256)
    local df_img = Image.load("art/spr/CRO/CRODf" .. defense .. ".png", VRAM)
    local pr_img = Image.load("art/spr/CRO/CROPr" .. prosecution .. ".png", VRAM)
    local wt_img = Image.load("art/spr/CRO/CROWt" .. witness .. ".png", VRAM)
    local j_img = Image.load("art/spr/CRO/CRO" .. judge .. ".png", VRAM)

    local crowd = {}
    local l_crowd = {}
    crowd[1] = Image.load("art/spr/CRO/CROCrowd-1.png", VRAM)
    crowd[2] = Image.load("art/spr/CRO/CROCrowd-2.png", VRAM)
    crowd[3] = Image.load("art/spr/CRO/CROCrowd-3.png", VRAM)
    l_crowd[1] = Image.load("art/spr/CRO/CROCrowd-1.png", VRAM)
    l_crowd[2] = Image.load("art/spr/CRO/CROCrowd-2.png", VRAM)
    l_crowd[3] = Image.load("art/spr/CRO/CROCrowd-3.png", VRAM)

    local timer = 0
    repeat
        gui.draw()
        Map.draw(SCREEN_UP, bg.map, bg.x, bg.y, 32, 24)
        screen.blit(SCREEN_UP, 165, 70, df_img)
        screen.blit(SCREEN_UP, 30, 70, pr_img)
        screen.blit(SCREEN_UP, 112, 48, j_img)
        screen.blit(SCREEN_UP, 64, 64, wt_img)
        screen.blit(SCREEN_UP, 64, 64, wt_img)
        screen.blit(SCREEN_UP, 216, 60, crowd[math.floor(timer / 3) % 3 + 1])
        Image.mirrorH(l_crowd[math.floor(timer / 3) % 3 + 1], true)
        screen.blit(SCREEN_UP, 0, 60, l_crowd[math.floor(timer / 3) % 3 + 1])
        render()
        timer = timer + 1
    until timer == 60
    Image.destroy(df_img)
    df_img = nil
    Image.destroy(pr_img)
    pr_img = nil
    Image.destroy(wt_img)
    wt_img = nil
    Image.destroy(j_img)
    j_img = nil
    for i=1,3 do
        Image.destroy(crowd[i])
        crowd[i] = nil
        Image.destroy(l_crowd[i])
        l_crowd[i] = nil
    end
    newbg(path, size)
end

function crossexamination()
    alpha_inout("crossexamination")
end

function witnesstestimony()
    alpha_inout("witnesstestimony")
end

function fade_in(screen_id, spd)
    local timer = 0
    local frame = 1

    repeat
        shell.draw()
        screen.setAlpha(frame, 1)
        screen.drawFillRect(screen_id, 0, 0, 256, 192, PW_BLACK)
        screen.setAlpha(ALPHA_OPAQUE, 1)
        render()
        if timer % spd == 0 then frame = frame + 1 end
        timer = timer + 1
    until frame == 32
end

function fade_out(screen_id, spd)
    local timer = 0
    local frame = 32

    repeat
        shell.draw()
        screen.setAlpha(frame, 1)
        screen.drawFillRect(screen_id, 0, 0, 256, 192, PW_BLACK)
        screen.setAlpha(ALPHA_OPAQUE, 1)
        render()
        if timer % spd == 0 then frame = frame - 1 end
        timer = timer + 1
    until frame == 1
end

function alpha_in(screen_id, spd, img, size)
    a_img = Image.load(img .. ".png", VRAM)
    a_map = Map.new(a_img, img .. ".map", size / 8, size / 8, 8, 8)

    local timer = 0
    local frame = 1

    repeat
        shell.draw()
        screen.setAlpha(frame, 1)
        Map.draw(screen_id, a_map, 0, 0, 32, 24)
        screen.setAlpha(ALPHA_OPAQUE, 1)
        render()
        if timer % spd == 0 then frame = frame + 1 end
        timer = timer + 1
    until frame == 32

    Image.destroy(a_img)
    a_img = nil
end

function alpha_out(screen_id, spd, img, size)
    a_img = Image.load(img .. ".png", VRAM)
    a_map = Map.new(a_img, img .. ".map", size / 8, size / 8, 8, 8)

    local timer = 0
    local frame = 32

    repeat
        shell.draw()
        screen.setAlpha(frame, 1)
        Map.draw(screen_id, a_map, 0, 0, 32, 24)
        screen.setAlpha(ALPHA_OPAQUE, 1)
        render()
        if timer % spd == 0 then frame = frame - 1 end
        timer = timer + 1
    until frame == 1

    Image.destroy(a_img)
    a_img = nil
end

function unlocksuccessful()

end


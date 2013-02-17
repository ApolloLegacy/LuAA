--[[
                     _               ____ ____
                    | |             / _  |  _ \
                    | |      __  __/ /_| | |_\ \
                    | |     / / / /  __  |  __  \
                    | |____/ /_/ /  /  | | |  \  \
                    |______\____/__/   |_|_|   \__\

    Name :          LuAA - main.lua
                    Turnabout Tutorial Example Script!
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

dofile("sound/soundbank.lua")

dofile("games/Turnabout Tutorial/evidence.lua")
dofile("games/Turnabout Tutorial/locations.lua")

function next()
    continueTalking = true
end

function p(seconds)
    Timer.wait(seconds)
end

function small_shake()
    show_shake(20, 1)
end

function gunshot()
    flash("FF0000")
end

function showbullet()
    show_ev(-1, TOP_LEFT, bullet)
end

function movie()
    new_bg("movie/boys", 256)
    new_speaker("???", SFX_BLIPMALE)
    fade_out(SCREEN_UP, 1)
    msg("Ey, you got the goods? {p(2)} {next}")
    msg("Just enough for me and my boys. Theo on the other hand... {p(2)} {next}")
    msg("What 'bout me? Huh? PUNK? {p(2)} {next}")
    fade_in(SCREEN_UP, 1)
    new_bg("movie/bang", 256)
    fade_out(SCREEN_UP, 1)
    msg("Dunno. whatta 'BOUT chu? {p(2)} {next}")
    msg("Hows 'bouts you pass it up or your pal 'Kuza gets it. {p(2)} {next}")
    msg("You JUNKIE sonuva-- {p(2)} {next}")
    new_bg(nil)
    msg("{gunshot()} {gunshot()}* BANG * {p(1)} {next}")
end

function scene1()
    fade_in(SCREEN_UP, 1)
    new_bg("movie/alarm", 256)
    new_speaker("")
    fade_out(SCREEN_UP, 1)
    new_color("F77339")
    msg("*BEEP* *BEEP*")
    new_speaker("Phoenix")
    new_color("6BC6F7")
    msg("(???)")
    msg("(Why's my alarm off... what was I supposed to do today?)")
    msg("(OH RIGHT! Murder case!)")
end

function scene2()
    add_ev(attorneybadge)
    add_ev(cellphone)
    add_ev(pr_phoenix)
    goto("Studio Path")
    new_speaker("", SFX_TYPEWRITER)
    new_align(ALIGN_CENTER)
    new_color("00FF00")
    msg("January 6th, 1:41 PM{n}Global Studios{n}Main Gate")
    new_align(ALIGN_LEFT)
    new_color("FFFFFF")
    new_speaker(nil)
    --alpha_in(SCREEN_UP, 1, "art/char/Gumshoe/thinking(talk)", 1536)
    new_speaker("Gumshoe", SFX_BLIPMALE)
    add_ev(pr_gumshoe)
    new_char("Gumshoe", "thinking", "talk", "blink")
    msg("Hey pal...")
    new_emo("thinking")
    msg("Looks like a murder's gone down here at Global Studios.")
    new_emo("disheartened")
    msg("As if enough stuff hasn't happened here since Hammer's death...{next}")
    new_bgm(MOD_GEIJISSU)

--    goto("interrogation")
    goto("Global Studio's Gate")
    goto("Studio Path")
end

function main()
    return function()
        --movie()
        --scene1()
        scene2()
    end
end

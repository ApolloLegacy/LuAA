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

dofile( "sound/soundbank.lua" )

dofile( "games/Turnabout Tutorial/evidence.lua" )
dofile( "games/Turnabout Tutorial/locations.lua" )

function next()
	continueTalking = true
end

function p( seconds )
	Timer.wait( seconds )
end

function small_shake()
	showshake(20, 1)
end

function gunshot()
	flash("FF0000")
end

function showbullet()
	showev(-1, TOP_LEFT, bullet)
end

function movie()
	newbg( "movie/boys", 256 )
	newspeaker("???", SFX_BLIPMALE)
	fade_out( SCREEN_UP, 1 )
	msg("Ey, you got the goods? {p(2)} {next}")
	msg("Just enough for me and my boys. Theo on the other hand... {p(2)} {next}")
	msg("What 'bout me? Huh? PUNK? {p(2)} {next}")
	fade_in( SCREEN_UP, 1 )
	newbg( "movie/bang", 256 )
	fade_out( SCREEN_UP, 1 )
	msg("Dunno. whatta 'BOUT chu? {p(2)} {next}")
	msg("Hows 'bouts you pass it up or your pal 'Kuza gets it. {p(2)} {next}")
	msg("You JUNKIE sonuva-- {p(2)} {next}")
	newbg( nil )
	msg("{gunshot()} {gunshot()}* BANG * {p(1)} {next}")
end

function scene1()
	fade_in( SCREEN_UP, 1 )
	newbg( "movie/alarm", 256 )
	newspeaker("")
	fade_out( SCREEN_UP, 1 )
	newcolor("F77339")
	msg("*BEEP* *BEEP*")
	newspeaker("Phoenix")
	newcolor("6BC6F7")
	msg("(???)")
	msg("(Why's my alarm off... what was I supposed to do today?)")
	msg("(OH RIGHT! Murder case!)")
end

function scene2()
	addev(attorneybadge)
	addev(cellphone)
	addev(pr_phoenix)
	goto("Studio Path")
	newspeaker( "", SFX_TYPEWRITER )
	newalign(ALIGN_CENTER)
	newcolor("00FF00")
	msg("January 6th, 1:41 PM{n}Global Studios{n}Main Gate")
	newalign(ALIGN_LEFT)
	newcolor("FFFFFF")
	newspeaker( nil )
	alpha_in( SCREEN_UP, 1, "art/char/Gumshoe/thinking(talk)", 1536 )
	newspeaker("Gumshoe", SFX_BLIPMALE)
	addev(pr_gumshoe)
	newchar( "Gumshoe", "thinking", "talk", "blink" )
	msg("Hey pal...")
	newemo("thinking")
	msg("Looks like a murder's gone down here at Global Studios.")
	newemo("disheartened")
	msg("As if enough stuff hasn't happened here since Hammer's death...{next}")
	newbgm( MOD_GEIJISSU )

--	goto("interrogation")
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

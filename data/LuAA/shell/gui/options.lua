--[[
                     _               ____ ____
                    | |             / _  |  _ \
                    | |      __  __/ /_| | |_\ \ 
                    | |     / / / /  __  |  __  \
                    | |____/ /_/ /  /  | | |  \  \ 
                    |______\____/__/   |_|_|   \__\
                    
    Name :          LuAA - options.lua
                    Constructs methods for drawing/updating the options GUI.
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

Stylus.released = false

gui_ = {}

cmd = {}
cmd[ "Back" ] = newRect(0, 160, 80, 192)

local opt_btn = {
	X = 109,
	Y = 35,
	WIDTH = 141,
	HEIGHT = 26
}

if DYNAMIC_GUI == false then
	btn = {}
	gui.loadBtn( "Court Record" )
	if not dynamic then gui.loadBtn( "Back" ) end
end

optSelected = 1

if opt == movOpt then
	paused = true
	--mov_img = Image.load( "art/bg/"..opt[optSelected].path, RAM )
elseif opt == tlkOpt then
	opt_btn.X = 12
	chk_img = Image.load( "art/gui/checkmark.gif", VRAM )
elseif opt == dynOpt then 
	opt_btn = {
		X = 16,
		Y = 35,
		WIDTH = 224,
		HEIGHT = 26
	}
	selectanswer( "Select your answer" )
end

for i,v in ipairs( opt ) do
	gui[ "OPT_BTN" ].draw( opt_btn.X, opt_btn.Y + 32*( i-1 ), opt_btn.WIDTH, opt_btn.HEIGHT, opt[ i ].text )
end

gui.draw = function()
	gui[ "BACKGROUND" ].draw()
	for i,v in ipairs( opt ) do
		gui[ "OPT_BTN" ].draw( opt_btn.X, opt_btn.Y + 32*( i-1 ), opt_btn.WIDTH, opt_btn.HEIGHT, opt[ i ].text )
		if talked[ opt[ i ].text ] then screen.blit( SCREEN_DOWN, 4, opt_btn.Y + 32*( i-1 ) - 9, chk_img ) end
	end
	gui[ "OPT_CURSOR" ].draw(cmd[ optSelected ].X1, cmd[ optSelected ].Y1, cmd[ optSelected ].X2 - cmd[ optSelected ].X1, cmd[ optSelected ].Y2 - cmd[ optSelected ].Y1)
	gui[ "SCAN_LINES" ].draw()
	if mov_img then
		screen.blit( SCREEN_DOWN, 3, 58, mov_img )
	end
	gui[ "MENU_PANEL" ].draw()
	gui[ "MENU_BTN" ].draw( 176, 0, 80, 32, "Court Record", 0, 1 )
	if not dynamic then 
		gui[ "MENU_BTN" ].draw( 0, 160, 80, 32, "Back", 0, 2 )
	end

end

gui.fade_in()

gui.deconstruct = function()
	gui.fade_out()
	paused = false
	cmd = nil
	
	if DYNAMIC_GUI == false then
		Image.destroy(btn["Court Record"])
		btn["Court Record"] = nil
		if not dynamic then
			Image.destroy(btn["Back"])
			btn["Back"] = nil
		end
	end
	
	if mov_img then
		Image.destroy( mov_img )
		mov_img = nil
	elseif chk_img then
		Image.destroy( chk_img )
		chk_img = nil
	end
	
	opt_btn = nil
	textbox = {
		x = 0,
		y = 128,
		w = 256,
		h = 64,
		message = nil
	}
end

gui.update = function()
	shell.draw()
	
	Controls.read()	
	if ( ( Stylus.released and pointCollide( cmd[ "Back" ], Stylus ) ) or Keys.newPress.B ) and not dynamic then
		gui.click( "MENU_BTN", "Back", 2 )
		gui.deconstruct()
		gui.construct( "interaction" )
	elseif ( Stylus.released and pointCollide( cmd[ "Court Record" ], Stylus ) ) or Keys.newPress.R then
		gui.click( "MENU_BTN", "Court Record", 1 )
		gui.saved[ 1 ] = "options"
		gui.deconstruct()
		gui.construct( "courtrecord" )
	elseif Keys.newPress.A then
		gui.click( "OPT_BTN", opt[ optSelected ].text )
		gui.deconstruct()
		gui.construct( "advance" )
		letter = {}
		if opt == tlkOpt then
			interact( TALK, opt[ optSelected ].text )
			talked[ opt[ optSelected ].text ] = true
		elseif opt == movOpt then interact( MOVE, opt[ optSelected ].text )
		else
			selected = opt[ optSelected ].text
			talking = true
		end

	elseif Keys.newPress.Down and cmd[ optSelected + 1 ] ~= nil then
		optSelected = optSelected + 1
		if opt == movOpt then
			--Image.destroy(mov_img)
			--mov_img = Image.load( "art/bg/"..opt[optSelected].path, RAM )
		end
	elseif Keys.newPress.Up and optSelected > 1 then
		optSelected = optSelected - 1
		if opt == movOpt then
			--Image.destroy(mov_img)
			--mov_img = Image.load( "art/bg/"..opt[optSelected].path, RAM )
		end
	else
		for i,v in ipairs( opt ) do
			if ( Stylus.released and pointCollide( cmd[ opt[ i ].text ], Stylus ) ) and cmd[ opt[ i ].text ] ~= nil then
				gui.click( "OPT_BTN", opt[ i ].text )
				gui.deconstruct()
				gui.construct( "advance" )
				letter = {}
				if opt == tlkOpt then
					interact( TALK, opt[ i ].text )
					talked[ opt[ i ].text ] = true
				elseif opt == movOpt then interact( MOVE, opt[ i ].text )
				else
					selected = opt[ i ].text
					talking = true
				end
			end
		end
	end

	if not clicking then render() end
end

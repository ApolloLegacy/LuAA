--[[
                     _               ____ ____
                    | |             / _  |  _ \
                    | |      __  __/ /_| | |_\ \ 
                    | |     / / / /  __  |  __  \
                    | |____/ /_/ /  /  | | |  \  \ 
                    |______\____/__/   |_|_|   \__\
                    
    Name :          LuAA - ev_profile.lua
                    Constructs methods for drawing/updating the evidence profile GUI.
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
cmd[ "ev_Present" ] = newRect( 88, 0, 168, 32 )
cmd[ "Category" ] = newRect( 176, 0, 256, 32 )

if DYNAMIC_GUI == false then
	btn = {}
	gui.loadBtn( "Profiles" )
	gui.loadBtn( "Evidence" )
	gui.loadBtn( "Back" )
	gui.loadBtn( "ev_Present" )
end

ev_pic = nil

ev = {}

item = nil

function gui_.reloadItem()
	if category == EVIDENCE then
		if DYNAMIC_GUI == false then
			Image.destroy(btn["Profiles"])
			gui.loadBtn( "Profiles" )
		end
		ev = evidence[ item ]
	else
		if DYNAMIC_GUI == false then
			Image.destroy(btn["Evidence"])
			gui.loadBtn( "Evidence" )
		end
		ev = profile[ item ]
	end
	Image.destroy( ev_pic )
	ev_pic = Image.load( "art/ev/" .. ev.pic, RAM )
end

function gui.deconstruct()
	cmd = nil
	if DYNAMIC_GUI == false then
		Image.destroy( btn["Profiles"] )
		btn["Profiles"] = nil
		Image.destroy( btn["Evidence"] )
		btn["Evidence"] = nil
		Image.destroy( btn["Back"] )
		btn["Back"] = nil
		Image.destroy( btn["ev_Present"] )
		btn["ev_Present"] = nil
	end
	Image.destroy( ev_pic )
	ev_pic = nil
	ev = nil
	item = nil
	gui.construct(gui_.new)
	if selected then
		letter = {}
		if not dynamic then interact( PRESENT, selected )
		else talking = true
		end
	end
end


function gui.draw()
	gui[ "BACKGROUND" ].draw()
	screen.drawFillRect( SCREEN_DOWN, 21, 39, 85, 103, PW_GREY )
	
	screen.drawFillRect( SCREEN_DOWN, 91, 39, 235, 56, PW_DIMGREY )
	screen.drawFillRect( SCREEN_DOWN, 92, 57, 235, 103, PW_LIGHTGREEN )
	screen.drawLine( SCREEN_DOWN, 91, 56, 235, 56, PW_PALEGREEN )
	screen.drawLine( SCREEN_DOWN, 91, 57, 91, 103, PW_PALEGREEN )
	screen.drawFillRect( SCREEN_DOWN, 9, 113, 247, 159, PW_WHEAT )
	screen.drawLine( SCREEN_DOWN, 9, 112, 247, 112, PW_PERU )
	screen.drawLine( SCREEN_DOWN, 8, 113, 8, 158, PW_PERU )
	screen.drawLine( SCREEN_DOWN, 247, 113, 247, 158, PW_PERU )
	
	gui[ "BORDER" ].draw( SCREEN_DOWN, 89, 37, 148, 67 )
	gui[ "ADV_BTN" ].draw( 0, 39, 16, 64, "Left" )
	gui[ "ADV_BTN" ].draw( 240, 39, 16, 64, "Right" )
	screen.blit( SCREEN_DOWN, 21, 40, ev_pic )
	gui[ "BORDER" ].draw( SCREEN_DOWN, 19, 37, 68, 67 )	
	screen.printFont( SCREEN_DOWN, 91 + ( 144 / 2 ) - ( Font.getStringWidth( font, ev.name ) / 2 ), 38, ev.name, PW_ORANGE, font )
	for i,v in ipairs( ev.info ) do
		screen.printFont( SCREEN_DOWN, 96, 59 + 15 * ( i - 1 ), v, PW_PALEGREEN, arial )
		screen.printFont( SCREEN_DOWN, 96, 58 + 15 * ( i - 1 ), v, PW_DIMGREY, arial )
	end
	for i,v in ipairs( ev.desc ) do
		screen.printFont( SCREEN_DOWN, 15, 112 + 15 * ( i - 1 ), v, PW_WHITE, font )
	end
	gui[ "SCAN_LINES" ].draw()
	
	gui[ "MENU_PANEL" ].draw()
	if category == EVIDENCE then 
		gui[ "MENU_BTN" ].draw( 176, 0, 80, 32, "Profiles", 0, 1 )
	else
		gui[ "MENU_BTN" ].draw( 176, 0, 80, 32, "Evidence", 0, 1 )
	end
	gui[ "MENU_BTN" ].draw( 0, 160, 80, 32, "Back", 0, 2 )
	if pst then gui[ "MENU_BTN" ].draw( 88, 0, 80, 32, "ev_Present", 0, 0 ) end
end

function gui.update()
	shell.draw()
	
	Controls.read()
	if ( Stylus.released and pointCollide( cmd[ "Category" ], Stylus ) ) or Keys.newPress.R then
		if category == EVIDENCE then
			gui.click( "MENU_BTN", "Profiles" , 1 )
			cmd[ "Profiles" ] = nil
			category = PROFILES
			if profile[ item ] == nil then item = 1 end
		else
			gui.click( "MENU_BTN", "Evidence" , 1 )
			cmd[ "Evidence" ] = nil
			category = EVIDENCE
			if evidence[ item ] == nil then item = 1 end
		end
		gui_.reloadItem()
	elseif ( Stylus.released and pointCollide( cmd[ "Back" ], Stylus ) ) or Keys.newPress.B then
		gui.click( "MENU_BTN", "Back" , 2 )
		gui_.constructed = false
		gui_.new = "courtrecord"
	elseif ( ( Stylus.released and pointCollide( cmd[ "ev_Present" ], Stylus ) ) or Keys.newPress.Y ) and pst == true then
		gui.click( "MENU_BTN", "ev_Present" , 0 )
		gui_.constructed = false
		gui_.new = "advance"
		selected = ev.name
	elseif ( Stylus.released and pointCollide( cmd[ "Left" ], Stylus ) ) or Keys.newPress.Left then
		gui.click( "ADV_BTN", "Left" )
		if item > 1 then
			item = item - 1
		else
			if category == EVIDENCE then
				item = table.maxn( evidence )
			else
				item = table.maxn( profile )
			end
		end
		gui_.reloadItem()
	elseif ( Stylus.released and pointCollide( cmd[ "Right" ], Stylus ) ) or Keys.newPress.Right then
		gui.click( "ADV_BTN", "Right" )
		if category == EVIDENCE then
			if item ~= table.maxn( evidence ) then
				item = item + 1
			else
				item = 1
			end
		else
			if item ~= table.maxn( profile ) then
				item = item + 1
			else
				item = 1
			end
		end
		gui_.reloadItem()
	end
	if not gui_.constructed then gui.deconstruct() end

	if not clicking then render() end
end

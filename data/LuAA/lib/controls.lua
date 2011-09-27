--[[
                     _               ____ ____
                    | |             / _  |  _ \
                    | |      __  __/ /_| | |_\ \ 
                    | |     / / / /  __  |  __  \
                    | |____/ /_/ /  /  | | |  \  \ 
                    |______\____/__/   |_|_|   \__\
                    
    Name :          LuAA - controls.lua
                    Control library.
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

Controls = {}

Stylus = {}
Stylus.X = -1
Stylus.Y = -1
Stylus.held = false
Stylus.released = false
Stylus.doubleClick = false
Stylus.deltaX = -1
Stylus.deltaY = -1
Stylus.newPress = false

Keys = {}
Keys.held = {}
Keys.released = {}
Keys.newPress = {}

Controls.read = function()
	ds_controls.read()
	Stylus.X = ds_controls.stylusX()
	Stylus.Y = ds_controls.stylusY()
	if not Stylus.held and ds_controls.stylusHeld() then Stylus.newPress = true else Stylus.newPress = false end
	Stylus.held = ds_controls.stylusHeld()
	Stylus.released = ds_controls.stylusReleased()
	Stylus.doubleClick = ds_controls.stylusDoubleClick()
	Stylus.deltaX = ds_controls.stylusDeltaX()
	Stylus.deltaY = ds_controls.stylusDeltaY()		
	if not Keys.held.A and ds_controls.heldA() then Keys.newPress.A = true else Keys.newPress.A = false end
	if not Keys.held.B and ds_controls.heldB() then Keys.newPress.B = true else Keys.newPress.B = false end
	if not Keys.held.X and ds_controls.heldX() then Keys.newPress.X = true else Keys.newPress.X = false end
	if not Keys.held.Y and ds_controls.heldY() then Keys.newPress.Y = true else Keys.newPress.Y = false end
	if not Keys.held.L and ds_controls.heldL() then Keys.newPress.L = true else Keys.newPress.L = false end
	if not Keys.held.R and ds_controls.heldR() then Keys.newPress.R = true else Keys.newPress.R = false end
	if not Keys.held.Start and ds_controls.heldStart() then Keys.newPress.Start = true else Keys.newPress.Start = false end
	if not Keys.held.Select and ds_controls.heldSelect() then Keys.newPress.Select = true else Keys.newPress.Select = false end
	if not Keys.held.Up and ds_controls.heldUp() then Keys.newPress.Up = true else Keys.newPress.Up = false end
	if not Keys.held.Down and ds_controls.heldDown() then Keys.newPress.Down = true else Keys.newPress.Down = false end
	if not Keys.held.Left and ds_controls.heldLeft() then Keys.newPress.Left = true else Keys.newPress.Left = false end
	if not Keys.held.Right and ds_controls.heldRight() then Keys.newPress.Right = true else Keys.newPress.Right = false end
	Keys.held.A = ds_controls.heldA()
	Keys.held.B = ds_controls.heldB()
	Keys.held.X = ds_controls.heldX()
	Keys.held.Y = ds_controls.heldY()
	Keys.held.Start = ds_controls.heldStart()
	Keys.held.Select = ds_controls.heldSelect()
	Keys.held.L = ds_controls.heldL()
	Keys.held.R = ds_controls.heldR()
	Keys.held.Up = ds_controls.heldUp()
	Keys.held.Down = ds_controls.heldDown()
	Keys.held.Left = ds_controls.heldLeft()
	Keys.held.Right  = ds_controls.heldRight()
	Keys.released.A = not ds_controls.heldA()
	Keys.released.B = not ds_controls.heldB()
	Keys.released.X = not ds_controls.heldX()
	Keys.released.Y = not ds_controls.heldY()
	Keys.released.Start = not ds_controls.heldStart()
	Keys.released.Select = not ds_controls.heldSelect()
	Keys.released.L = not ds_controls.heldL()
	Keys.released.R = not ds_controls.heldR()
	Keys.released.Up = not ds_controls.heldUp()
	Keys.released.Down = not ds_controls.heldDown()
	Keys.released.Left = not ds_controls.heldLeft()
	Keys.released.Right  = not ds_controls.heldRight()
end
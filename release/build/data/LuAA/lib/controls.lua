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
    Controls.read()
    Stylus.X = Controls.stylusX()
    Stylus.Y = Controls.stylusY()
    if not Stylus.held and Controls.stylusHeld() then Stylus.newPress = true else Stylus.newPress = false end
    Stylus.held = Controls.stylusHeld()
    Stylus.released = Controls.stylusReleased()
    Stylus.doubleClick = Controls.stylusDoubleClick()
    Stylus.deltaX = Controls.stylusDeltaX()
    Stylus.deltaY = Controls.stylusDeltaY()
    if not Keys.held.A and Controls.heldA() then Keys.newPress.A = true else Keys.newPress.A = false end
    if not Keys.held.B and Controls.heldB() then Keys.newPress.B = true else Keys.newPress.B = false end
    if not Keys.held.X and Controls.heldX() then Keys.newPress.X = true else Keys.newPress.X = false end
    if not Keys.held.Y and Controls.heldY() then Keys.newPress.Y = true else Keys.newPress.Y = false end
    if not Keys.held.L and Controls.heldL() then Keys.newPress.L = true else Keys.newPress.L = false end
    if not Keys.held.R and Controls.heldR() then Keys.newPress.R = true else Keys.newPress.R = false end
    if not Keys.held.Start and Controls.heldStart() then Keys.newPress.Start = true else Keys.newPress.Start = false end
    if not Keys.held.Select and Controls.heldSelect() then Keys.newPress.Select = true else Keys.newPress.Select = false end
    if not Keys.held.Up and Controls.heldUp() then Keys.newPress.Up = true else Keys.newPress.Up = false end
    if not Keys.held.Down and Controls.heldDown() then Keys.newPress.Down = true else Keys.newPress.Down = false end
    if not Keys.held.Left and Controls.heldLeft() then Keys.newPress.Left = true else Keys.newPress.Left = false end
    if not Keys.held.Right and Controls.heldRight() then Keys.newPress.Right = true else Keys.newPress.Right = false end
    Keys.held.A = Controls.heldA()
    Keys.held.B = Controls.heldB()
    Keys.held.X = Controls.heldX()
    Keys.held.Y = Controls.heldY()
    Keys.held.Start = Controls.heldStart()
    Keys.held.Select = Controls.heldSelect()
    Keys.held.L = Controls.heldL()
    Keys.held.R = Controls.heldR()
    Keys.held.Up = Controls.heldUp()
    Keys.held.Down = Controls.heldDown()
    Keys.held.Left = Controls.heldLeft()
    Keys.held.Right  = Controls.heldRight()
    Keys.released.A = not Controls.heldA()
    Keys.released.B = not Controls.heldB()
    Keys.released.X = not Controls.heldX()
    Keys.released.Y = not Controls.heldY()
    Keys.released.Start = not Controls.heldStart()
    Keys.released.Select = not Controls.heldSelect()
    Keys.released.L = not Controls.heldL()
    Keys.released.R = not Controls.heldR()
    Keys.released.Up = not Controls.heldUp()
    Keys.released.Down = not Controls.heldDown()
    Keys.released.Left = not Controls.heldLeft()
    Keys.released.Right  = not Controls.heldRight()
end
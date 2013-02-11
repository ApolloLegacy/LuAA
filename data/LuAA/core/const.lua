--[[
                     _               ____ ____
                    | |             / _  |  _ \
                    | |      __  __/ /_| | |_\ \
                    | |     / / / /  __  |  __  \
                    | |____/ /_/ /  /  | | |  \  \
                    |______\____/__/   |_|_|   \__\

    Name :          LuAA - const.lua
                    Defines constant variables.
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

DYNAMIC_GUI = false

PW_DELAY = 50
PW_BTN_DELAY = 100

ALIGN_LEFT = 0
ALIGN_CENTER = 1
ALIGN_RIGHT = 2

TOP_LEFT = 0
TOP_RIGHT = 1

EVIDENCE = 0

EXAMINE = 0
MOVE = 1
TALK = 2
PRESENT = 3

PW_WHITE = tocolor("FFFFFF")
PW_BLACK = tocolor("000000")
PW_MIDNIGHTBLUE = tocolor("191970")
PW_DIMGREY = tocolor("424242")
PW_GREY = tocolor("999999")
PW_TAN = tocolor("A27959")
PW_SIENNA = tocolor("712800")
PW_SADDLE = tocolor("632100")
PW_DARKORANGE = tocolor("CE8421")
PW_GOLD = tocolor("EFA521")
PW_GOLDENROD = tocolor("E79421")
PW_LEMON = tocolor("F0F060")
PW_SILVER = tocolor("DEDEDE")
PW_DARKKHAKI = tocolor("BDB76B")
PW_WHEAT = tocolor("847342")
PW_PERU = tocolor("735A42")
PW_ORANGE = tocolor("F8A818")
PW_TANGERINE = tocolor("F08830")
PW_YELLOW = tocolor("F0B030")
PW_PALEGREEN = tocolor("689068")
PW_LIGHTGREEN = tocolor("98C090")
PW_BLUE = tocolor("317BFF")
PW_BURGUNDY = tocolor ("5A1010")

HP_SHADE = {}
HP_SHADE[1] = tocolor ("41DA41")
HP_SHADE[2] = tocolor ("81FB82")
HP_SHADE[3] = tocolor ("00BA01")
HP_SHADE[4] = tocolor ("009B01")
HP_SHADE[5] = tocolor ("007201")
HP_SHADE[6] = tocolor ("FBA12F")
HP_SHADE[7] = tocolor ("FBB22F")
HP_SHADE[8] = tocolor ("FC9131")
HP_SHADE[9] = tocolor ("FB8231")
HP_SHADE[10] = tocolor ("D4792A")

ALPHA_OPAQUE = 1;
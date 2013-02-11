--[[
                     _               ____ ____
                    | |             / _  |  _ \
                    | |      __  __/ /_| | |_\ \ 
                    | |     / / / /  __  |  __  \
                    | |____/ /_/ /  /  | | |  \  \ 
                    |______\____/__/   |_|_|   \__\
                    
    Name :          LuAA - evidence.lua
                    Evidence index.
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

attorneybadge = {
    name = "Attorney Badge",
    pic = "evidence/lawyer badge.gif",
    info = {
        "Type: Other",
        "One of my possessions."
    },
    desc = {
        "It's my all-important badge.",
        "It shows that I am a",
        "defense attorney."
    },
    category = EVIDENCE
}

cellphone = {
    name = "Cell Phone",
    pic = "evidence/phoenix phone.gif",
    info = {
        "Type: Other",
        "One of my possessions."
    },
    desc = {
        "My trusty cell phone.",
        "Can't leave home without this.",
    },
    category = EVIDENCE
}

bullet = {
    name = "Bullet",
    pic = "evidence/bullet baggie.gif",
    info = {
        "Type: Weapons",
        "Submitted as evidence",
        "by Detective Gumshoe."
    },
    desc = {
        "8 mm bullet found in",
        "victim's body."
    },
    category = EVIDENCE
}

pistol = {
    name = "Pistol",
    pic = "evidence/pistol.gif",
    info = {
        "Type: Weapons",
        "Submitted as evidence",
        "by Detective Gumshoe."
    },
    desc = {
        "Shoots 8 mm bullets.",
        "Was used to kill the victim,",
        "Yak Uza."
    },
    category = EVIDENCE
}

soymilk = {
    name = "VeetaSoy Soy Milk",
    pic = "evidence/ev_case3_Milk_eng.gif",
    info = {
        "Type: Evidence",
        "Submitted as evidence",
        "by Detective Gumshoe."
    },
    desc = {
        "Found at the crime scene.",
        "Being expired, it's thick",
        "like tofu."
    },
    category = EVIDENCE
}

report = {
    name = "Autopsy Report",
    pic = "evidence/autopsy report.gif",
    info = {
        "Type: Reports",
        "Submitted as evidence",
        "by Detective Gumshoe."
    },
    desc = {
        "Time of death: unknown.",
        "Cause of death: Single",
        "bullet to the heart."
    },
    category = EVIDENCE
}

photo = {
    name = "Security Photo",
    pic = "evidence/photo.gif",
    info = {
        "Type: Photographs",
        "Taken from the security",
        "booth."
    },
    desc = {
        "A photo depicting Furio",
        "Tigre in front of the",
        "Global Studios park."
    },
    category = EVIDENCE
}

------------------------------------------------------------------------------
-- PROFILES
------------------------------------------------------------------------------

pr_phoenix = {
    name = "Phoenix Wright",
    pic = "profiles/phoenix.gif",
    info = {
        "Age : 24",
        "Gender : Male",
    },
    desc = {
        "Handsome, aren't I?"
    },
    category = PROFILES
}

pr_gumshoe ={
    name = "Dick Gumshoe",
    pic = "profiles/gumshoe.gif",
    info = {
        "Age : 30",
        "Gender : Male",
    },
    desc = {
        "The detective in charge of",
        "homicides down at the",
        "precinct."
    },
    category = PROFILES
}

pr_furio ={
    name = "Furio Tigre",
    pic = "profiles/zenitora.gif",
    info = {
        "Age : 40",
        "Gender : Male",
    },
    desc = {
        "Handsome, aren't I?"
    },
    category = PROFILES
}

pr_yakuza ={
    name = "Yak Uza",
    pic = "profiles/darke.gif",
    info = {
        "Age : 26",
        "Gender : Male",
    },
    desc = {
        "Victim in my murder case.",
        "Was killed with a single bullet",
        "to the chest."
    },
    category = PROFILES
}
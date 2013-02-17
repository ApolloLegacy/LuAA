--[[
                     _               ____ ____
                    | |             / _  |  _ \
                    | |      __  __/ /_| | |_\ \ 
                    | |     / / / /  __  |  __  \
                    | |____/ /_/ /  /  | | |  \  \ 
                    |______\____/__/   |_|_|   \__\
                    
    Name :          LuAA - locations.lua
                    Script file for locations.
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

_G["Studio 2"] = function()
    fade_in(SCREEN_UP, 1)
    new_bg("locations/globalstudio2", 512)
    fade_out(SCREEN_UP, 1)
    new_mov(gs_gate, gs_studio2)
    interact = function(mode, selected)
        if mode == EXAMINE then
            if selected == "Welcome Sign" then
                msg("(What a welcoming sign...)")
            elseif selected == "Broken Statue" then
                msg("(Looks like it's still broken. Hmm.)")
            elseif selected == "Camera" then
                msg("(Hmm, the camera's model number is SC-2M0.)")
            elseif selected == "Studio One Entrance" then
                msg("(There's no point in entering Studio One today...)")
            end
            goto("examine")
        elseif mode == MOVE then
            goto(selected)
        end
    end
    goto("interaction")
end

_G["Studio Path"] = function()
    fade_in(SCREEN_UP, 1)
    new_bg("locations/globalstudiocamera", 256)
    fade_out(SCREEN_UP, 1)
    new_hotspot(61, 2, 182, 34, "Welcome Sign")
    new_hotspot(109, 45, 71, 59, "Broken Statue")
    new_hotspot(34, 25, 27, 29, "Camera")
    new_hotspot(196, 70, 40, 25, "Studio One Entrance")
    new_mov(gs_gate, gs_studio2)
    interact = function(mode, selected)
        if mode == EXAMINE then
            if selected == "Welcome Sign" then
                msg("(What a welcoming sign...)")
            elseif selected == "Broken Statue" then
                msg("(Looks like it's still broken. Hmm.)")
            elseif selected == "Camera" then
                msg("(Hmm, the camera's model number is SC-2M0.)")
            elseif selected == "Studio One Entrance" then
                msg("(There's no point in entering Studio One today...)")
            end
            goto("examine")
        elseif mode == MOVE then
            goto(selected)
        end
    end
    goto("interaction")
end

_G["Global Studio's Gate"] = function()
    fade_in(SCREEN_UP, 1)
    new_bg("locations/globalstudioentrance", 256)
    fade_out(SCREEN_UP, 1)
    new_hotspot(5, 48, 68, 61, "Security Booth")
    new_hotspot(113, 91, 76, 30, "Gate")
    new_hotspot(191, 75, 56, 66, "Van")
    new_hotspot(70, 71, 21, 49, "Sign")
    new_mov(gs_entrance)
    new_tlk("Defendant", "Decisive evidence")
    interact = function(mode, selected)
        if mode == EXAMINE then
            new_speaker("Phoenix")
            new_color("6BC6F7")
            if selected == "Security Booth" then
                    msg("(The security booth containing images from various security cameras in the park.)")
                if gumshoeIsGone == true then
                    msg("(Hmm... it looks like all the camera IDs are here...)")
                    msg("(Which camera would have the images I want?){next}")
                    goto("dynamic_options", "SC-4G8", "SC-2M0", "SC-8Z1")
                    if selected == "SC-4G8" or selected == "SC-8Z1" then
                        msg("(Doesn't look like this one has anything I need...){next}")
                    else
                        msg("(...? Wait a second...)")
                        msg("(This could come in handy!)")
                        add_ev(photo)
                        show_add_ev(evidence[table.maxn(evidence)])
                        new_speaker("")
                        msg(evidence[table.maxn(evidence)].name .. " added to the court record.{next}")
                    end
                else
                    new_speaker("Gumshoe")
                    new_color("FFFFFF")
                    new_emo("mad")
                    msg("WHAT ARE YOU LOOKING AT, PAL?!")
                end
            elseif selected == "Gate" then
                msg("(The fenced, metal gate used to blockade the entrance for Global Studios.)")
                msg("(Apparently, there's been a lot of fanboys sneaking in lately...)")
            elseif selected == "Van" then
                msg("(A random van is parked in the parking lot.)")
            elseif selected == "Sign" then
                msg("(A sign illustrating Global Studio's map.)")
            else
                msg("(Nothing interesting here...)")
            end
            if has_ev(photo) == true then
                msg("(I think I'm ready for tomorrow's trial...)")
                msg("(Or at least, I better be ready...)")
                goto("District Lobby")
            end
            goto("examine")
        elseif mode == MOVE then
            --if gumshoeIsGone == true then
                goto(selected)
            --[[else
                new_speaker("Gumshoe")
                new_color("FFFFFF")
                new_emo("mad")
                msg("Don't be entering the crime scene now!{next}")
                goto("move")
            end]]
        elseif mode == TALK then
            new_speaker("Gumshoe")
            new_color("FFFFFF")
            if selected == "Defendant" then
                new_emo("normal")
                msg("The victim's name is Yak Uza.")
                if has_ev(pr_yakuza) == false then add_ev(pr_yakuza) end
                new_emo("confident")
                msg("He's had a history with the mafia... sort of had it coming.")
                new_emo("side")
                msg("Don't worry though, I think we found our man.")
                new_emo("mad")
                msg("This guy did it for sure! I'm telling you!")
                if has_ev(pr_furio) == false then add_ev(pr_furio) end
                new_emo("pumped")
                msg("They call him 'The Tiger'. He's a crook! His name's {new_color(F77339)}Furio Tigre{new_color(FFFFFF)}.")
                msg("All the evidence points against him, including his gun.")
                if has_opt("Murder Weapon") == false then
                    add_tlk("Murder Weapon")
                end
                new_emo("disheartened")
                msg("Oops. Pretend I didn't say that.{next}")
            elseif selected == "Murder Weapon" then
                new_emo("laughing")
                msg("I guess the cat's out of the bag.")
                new_emo("normal")
                msg("That Furio Tigre guy used his pistol.")
                new_emo("thinking")
                msg("Or at least I think it's his pistol.")
                new_emo("mad")
                msg("Anyways, he's a CROOK! I'm telling you!")
                new_emo("disheartened")
                msg("I'm afraid I don't have the pistol on me.")
                new_emo("confident")
                msg("But we also found a {showbullet()}bullet in the victim's body.")
                if has_ev(report) == false then
                    new_emo("normal")
                    msg("Here's the autopsy report.")
                    add_ev(report)
                    show_add_ev(evidence[table.maxn(evidence)])
                    new_speaker("")
                    new_color("6BC6F7")
                    msg(evidence[table.maxn(evidence)].name .. " added to the court record.{next}")
                    new_color("FFFFFF")
                    new_speaker("Gumshoe")
                else
                    new_emo("normal")
                    msg("The pistol used 8 mm bullets.{next}")
                end
            elseif selected == "Decisive evidence" then
                new_emo("normal")
                msg("The killer's fingerprints on the pistol match a set at the crime scene.")
                new_emo("thinking")
                msg("The set is on a bottle of expired soy milk, pal.")
                new_emo("laughing")
                msg("Yeah, we got a sour killer out there.")
                msg("Hahaha... pal.{next}")
            end
            if has_ev(pr_furio) == true and has_ev(report) == true and talked["Decisive evidence"] == true then
                msg("Hmm... looks like I gotta get back to the precinct.")
                new_emo("mad")
                msg("Don't be nosing around, pal!")
                gumshoeIsGone = true
                new_char(nil)
                new_speaker(nil)
                alpha_out(SCREEN_UP, 1, "art/char/Gumshoe/mad(talk)", 1024)
                goto("interaction")
            else
                goto("talk")
            end
        elseif mode == PRESENT then
            new_speaker("Gumshoe")
            new_color("FFFFFF")
            if selected == "Dick Gumshoe" then
                new_emo("confident")
                msg("Handsome, aren't I?{next}")
            elseif selected == "Attorney Badge" then
                new_emo("side")
                msg("I already know you're an attorney...{next}")
            elseif selected == "Autopsy Report" then
                new_speaker("Phoenix")
                msg("Why is the time of death unknown?")
                new_speaker("Gumshoe")
                new_emo("pumped")
                msg("Because it IS! Can't you read?!")
                new_speaker("Phoenix")
                new_color("6BC6F7")
                msg("(sheesh...){next}")
                new_color("FFFFFF")
            else
                new_emo("thinking")
                msg("Why are you showing me this?{next}")
            end
            goto("present")
        end
    end
    if gumshoeIsGone == true then goto("interaction") end
end

------------------------------------------------------------------------------
-- LOCATION VARIABLES
------------------------------------------------------------------------------

gs_gate = {
    name = "Global Studio's Gate",
    pic = "move/globalstudioentrance.gif",
}

gs_entrance = {
    name = "Studio Path",
    pic = "move/globalstudiocamera.gif",
}

gs_studio2 = {
    name = "Studio 2",
    pic = "move/globalstudio2a.gif",
}

gs_studio2van = {
    name = "Studio 2 Cottage",
    pic = "move/globalstudiovan.gif",
}

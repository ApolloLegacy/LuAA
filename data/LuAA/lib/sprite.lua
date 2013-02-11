--[[
                     _               ____ ____
                    | |             / _  |  _ \
                    | |      __  __/ /_| | |_\ \
                    | |     / / / /  __  |  __  \
                    | |____/ /_/ /  /  | | |  \  \
                    |______\____/__/   |_|_|   \__\

    Name :          LuAA - sprite.lua
                    Sprite library.
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

Sprite = {

    -- path: path of the file which contains the sprite
    -- height: height of the frames
    -- width: width of the frames
    -- dest: destination (RAM or VRAM)
    new = function(path_, width_, height_, dest)
        assert(path_ ~= nil, "Path can't be null")
        assert(width_ > 0, "Width must be positive")
        assert(height_ > 0, "Height must be positive")
        assert(dest == RAM or dest == VRAM, "Destination must be RAM or VRAM")
        local path = path_
        local height = height_
        local width = width_
        local img = Image.load(path, dest)
        local animations = {}

        -- ### Public methods ###

        -- Draw a frame
        -- scr: screen (SCREEN_UP or SCREEN_DOWN)
        -- x: X-coordinate where to draw the frame
        -- y: Y-coordinate where to draw the frame
        -- noFrame: number of the frame to draw
        local drawFrame = function(self, scr, x, y, noFrame)
            assert(scr == SCREEN_UP or scr == SCREEN_DOWN or scr == SCREEN_BOTH, "Bad screen number")
            assert(x ~= nil, "X can't be null")
            assert(y ~= nil, "Y can't be null")
            assert(noFrame ~= nil, "Frame number can't be null")
            boardWidth = Image.width(img) / width
            yy = math.floor(noFrame / boardWidth)
            xx = noFrame - (yy * boardWidth)
            screen.blit(scr, x, y, img, xx*width, yy*height, width, height)
        end

        -- Create an animation
        -- tabAnim: the table of the animation frames
        -- delay: delay between each frame
        local addAnimation = function(self, tabAnim, delay)
            assert(tabAnim ~= nil, "Table can't be null")
            assert(delay >= 0, "Delay  must be positive")
            tmp = SpriteAnimation.new(tabAnim,delay)
            table.insert(animations, tmp)
        end

        -- Reset an animation
        -- noAnim: number of the animation
        local resetAnimation = function(self, noAnim)
            assert(noAnim > 0, "Animation number must be 1 or more")
            animations[noAnim].tmr:reset()
        end

        -- Start an animation
        -- noAnim: number of the animation
        local startAnimation = function(self, noAnim)
            assert(noAnim > 0, "Animation number must be 1 or more")
            animations[noAnim].tmr:start()
        end

        -- Stop an animation
        -- noAnim: number of the animation
        local stopAnimation = function(self, noAnim)
            assert(noAnim > 0, "Animation number must be 1 or more")
            animations[noAnim].tmr:stop()
        end

        -- Return true if the animation is at the end of a loop
        -- noAnim: number of the animation
        local isAnimationAtEnd = function(self, noAnim)
            assert(noAnim > 0, "Animation number must be 1 or more")
            return math.floor(animations[noAnim].tmr:time()/animations[noAnim].delay+1) >= table.getn(animations[noAnim].tabAnim)
        end

        -- Play an animation
        -- scr: screen (SCREEN_UP or SCREEN_DOWN)
        -- x: X-coordinate where to draw the animation
        -- y: Y-coordinate where to draw the animation
        -- noAnim: number of the animation to draw
        local playAnimation = function(self, scr, x, y, noAnim)
            assert(scr == SCREEN_UP or scr == SCREEN_DOWN or scr == SCREEN_BOTH, "Bad screen number")
            assert(x ~= nil, "X can't be null")
            assert(y ~= nil, "Y can't be null")
            assert(noAnim > 0, "Animation number must be 1 or more")
            if not animations[noAnim].isPlayed then
                animations[noAnim].tmr:reset()
                animations[noAnim].tmr:start()
                animations[noAnim].isPlayed = true
            end
            if math.floor(animations[noAnim].tmr:time()/animations[noAnim].delay) >= table.getn(animations[noAnim].tabAnim) then
                resetAnimation(self, noAnim)
                startAnimation(self, noAnim)
            end
            animToDraw = animations[noAnim].tabAnim[math.floor(animations[noAnim].tmr:time()/animations[noAnim].delay)+1]
            if animToDraw ~= nil then
                drawFrame(self, scr, x, y, animToDraw)
            end
        end

        local getWidth = function(self)
            return width
        end

        local getHeight = function(self)
            return height
        end

        local destroy = function(self)
            local key, value
            for key, value in pairs(animations) do
                value = nil
            end
            Image.destroy(img)
            img = nil
        end

        -- ### Returns ###

        return {
            path = path,
            getWidth = getWidth,
            getHeight = getHeight,
            drawFrame = drawFrame,
            addAnimation = addAnimation,
            playAnimation = playAnimation,
            resetAnimation = resetAnimation,
            stopAnimation = stopAnimation,
            startAnimation = startAnimation,
            isAnimationAtEnd = isAnimationAtEnd,
            destroy = destroy
        }

    end

}

-- Declaration of the SpriteAnimation class
SpriteAnimation = {

    -- tabAnim: the table of the animation frames
    -- delay: delay between each frame
    new = function(tabAnim_, delay_)
            local tabAnim = tabAnim_
            local delay = delay_
            local tmr = Timer.new()
            local isPlayed = false
            return {
                tabAnim = tabAnim,
                delay = delay,
                tmr = tmr,
                isPlayed = isPlayed
            }
    end

}
LuAA
---------------------------------------------------------------------------------------------------------
<img src="https://secure.gravatar.com/avatar/d50f7f4c12a5a38821789463691b1911?s=140&d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" height="16px"> Documented by <a href="http://github.com/x711Li">x711Li</a>

**Disclaimer**: All trademarks and copyrights are the property of their respective owners. Phoenix Wright™ Ace Attorney ©CAPCOM CO., LTD. 2001, 2005 All Rights Reserved.

<p align="center">
    <img src="http://i51.tinypic.com/169g9af.png">
</p>

LuAA is a mobile visual novel application programmed in an open-source distribution of the extensible language, Lua, namely MicroLua. MicroLua is designed for ARM hardware architecture, specifically for an ARM7/ARM9 processor configuration found in the Nintendo DS. Thus, it disallows allocation of memory past 4MB, internally. It is packaged with the compiled (proprietary) ARM7/ARM9 binaries to prevent user manipulation. However, the front-end programmed in MicroLua is powerful enough for user customizability (re-compile all included files using NDSTool). LuAA placed <a href="http://www.neoflash.com/forum/index.php/topic,5608.0.html">1st in the Neoflash Spring Coding Competition 2009</a>, originally named AceAttorneyDS, winning a $300 prize.

Compilation
---------------------------------------------------------------------------------------------------------

Please follow the README found in the <a href="https://github.com/microlua/source">MicroLua source repository</a>.

Discussion Threads
---------------------------------------------------------------------------------------------------------

- All discussion regarding LuAA may be found in its respective <a href="http://microlua.xooit.fr/t837-LuAA-Ace-Attorney-Casemaker.htm">thread</a>.
- All discussion regarding the embedded file system implementation may be found in its respective <a href="http://microlua.xooit.fr/t1046-EFSLib-with-MicroLua-4-6-1.htm">thread</a>.

Background Information
---------------------------------------------------------------------------------------------------------

LuAA was developed for several reasons:

- To be the first ever Nintendo DS homebrew engine that works with an embedded file system.
- To aid the existing visual novel community with another platform they can migrate their work to (Nintendo DS).
- To test the extensibility and stability of the <a href="https://github.com/microlua">MicroLua</a> platform.

### Hardware Specifications

From Wikipedia:

**Memory capacity**: 4 MB RAM

**Top Screen**: A backlit, 3.12-inch, transmissive TFT color LCD with 256x192-pixel resolution and .24mm dot pitch, capable of displaying a total of 262,144 colors.

**Touch Screen**: Same specifications as top screen, but with a transparent analog touch screen.

**CPUs**: Two ARM processors, an ARM946E-S main CPU and ARM7TDMI coprocessor at clock speeds of 67 MHz and 33 MHz respectively.

An amazing diagram that illustrates the hardware architecture well is one of devkitPro's:

<p align="center">
    <img src="http://dev-scene.com/images/3/3d/Dov_DS_MemoryMap.png">
</p>

The most important parts to note are the screen sizes (256x192), the two CPUs (ARM7 and ARM9) and the RAM amount (4MB). Due to all of these factors, the graphics library for the Nintendo DS is somewhat limited.

1. Certain VRAM (video RAM) banks will operate on 15-bit RGB color. This implies that specified RGB values must be within (`0` - `31`), taking 2^5 bits of space each. The last bit is reserved to specify alpha levels on the memory bank.
2. The GBA (Gameboy Advance) cart is the "hack" used to accomplish my embedded file system implementation on external emulation. Basically, the Nintendo DS will act as if the embedded file system is actually extended RAM retrieved from the GBA slot, using resources found in the file system there. This is the sole reason why you must use the following command to run it on <a href="http://desmume.org/">DeSmuMe</a>:
    ~~~~~~~~~~~~~~~~~~
    ~ $ desmume gbaslot-rom=LuAA.nds LuAA.nds
    ~~~~~~~~~~~~~~~~~~

    This essentially allocates the GBA slot to the NDS ROM, allowing the actual run binary to access resources from it.
3. Each screen has four background layers (`BG0` ~ `BG3`). Each background layer, in 2D mode, has an 8-bit palette size limit and therefore can store tilemaps with up to 256 colours only.

### Software Specifications

The software architecture chosen for Lua is quite simple. If you open the `release/build` directory, you'll find the following files:

**arm7.bin**: The compiled binary for the 16-bit ARM7 processor found in the Nintendo DS. This handles 8 to 16 bit sound modules (think .mod, .xm, etc.) and some of the lesser functions required for operation.

**arm9.bin**: The compiled binary for the 32-bit ARM9 processor found in the Nintendo DS. This contains processing for just about everything else, including the GL, VRAM allocation and mathematical operations.

**banner.bin**: The palette and tilemap for the Nintendo DS ROM icon. Note that the palette length is 2 bytes and has a maximum colour amount of 16.

**header.bin**: The metadata required for the ROM to operate. Contains binary lengths, offsets, execution addresses, pointer tables and Nintendo publisher information.

**overarm7.bin/overarm9.bin**: The ARM7/ARM9 overlays help to map efficient routes to the compiled data files (images/sound/tilemaps) for speedy execution. However, since everything from LuAA is loaded from an embedded file system, these binaries are not used.

**data**: The external data used by the ROM that is not immediately loaded and cached by the ARM7/ARM9 processors. It should be of no surprise then, that this directory stores all the images, scripts and audio files required for LuAA to work.

`ndstool`, located in the `bin` directory, is used to compile these above into a standalone ROM that can be run on multiple emulators and on official hardware.

Below is documentation on how to use the actual API.

Usage
---------------------------------------------------------------------------------------------------------

### advance()
-----
_**Description**_: Forces an advance in the script.

##### *Parameters*
None.

##### *Return value*
None.

##### *Example*
~~~
advance()
~~~
-----


### yell(words)
-----
_**Description**_: Plays the Objection!, Gotcha! and Hold It! animations.

##### *Parameters*
words - specifies the yelled term ('objection', 'gotcha', 'holdit')

##### *Return value*
None.

##### *Example*
~~~
yell('objection')
yell('gotcha')
~~~
-----


### alpha_inout(words)
-----
_**Description**_: Fades an animation into the screen, then exits, fading out.

##### *Parameters*
words - specifies the term to use

##### *Return value*
None.

##### *Example*
~~~
alpha_inout('holdit')
~~~
-----


### gavel()
-----
_**Description**_: Plays the Gavel animation.

##### *Parameters*
None.

##### *Return value*
None.

##### *Example*
~~~
gavel()
~~~
-----


### jury()
-----
_**Description**_: Plays the jury animation.

##### *Parameters*
None.

##### *Return value*
None.

##### *Example*
~~~
jury()
~~~
-----


### cross_examination()
-----
_**Description**_: Plays the Cross Examination animation.

##### *Parameters*
None.

##### *Return value*
None.

##### *Example*
~~~
cross_examination()
~~~
-----


### fade_in(screen_id, spd)
-----
_**Description**_: Fades in the top screen, given it's id (0 - 3).

##### *Parameters*
screen_id - The screen ID (SCREEN_UP or SCREEN_DOWN)
spd - Speed for which the fade_in occurs (must be at least 0)

##### *Return value*
None.

##### *Example*
~~~
fade_in(SCREEN_DOWN, 56)
~~~
-----


### fade_out(screen_id, spd)
-----
_**Description**_: Fades out of the top screen, given it's id.

##### *Parameters*
screen_id - The screen ID (SCREEN_UP or SCREEN_DOWN)
spd - Speed for which the fade_out occurs (must be at least 0)

##### *Return value*
None.

##### *Example*
~~~
fade_out(SCREEN_UP, 4)
~~~
-----


### alpha_in(screen_id, spd, img, size)
-----
_**Description**_: Introduces an image to the screen, fading it in via an alpha animation.

##### *Parameters*
screen_id - The background layer (0 - 3)
spd - Speed for which the alpha_in occurs (must be at least 0)
img - The path to the image to be loaded
size - The size of the image's tilemap

##### *Return value*
None.

##### *Example*
~~~
alpha_in(SCREEN_UP, 1, "art/char/Gumshoe/thinking(talk)", 1536)
~~~
-----


### alpha_out(screen_id, spd, img, size)
-----
_**Description**_: Introduces an image to the screen, fading it out via an alpha animation.

##### *Parameters*
screen_id - The background layer (0 - 3)
spd - Speed for which the alpha_out occurs (must be at least 0)
img - The path to the image to be loaded
size - The size of the image's tilemap

##### *Return value*
None.

##### *Example*
~~~
alpha_out(SCREEN_UP, 1, "art/char/Gumshoe/thinking(talk)", 1536)
~~~
-----


### unlock_successful()
-----
_**Description**_: Shows the Unlock Successful animation.

##### *Parameters*
None.

##### *Return value*
None.

##### *Example*
~~~
unlock_successful()
~~~
-----


### dynamic_present()
-----
_**Description**_: Forcefully advances the player to a Present dialog.

##### *Parameters*
None.

##### *Return value*
None.

##### *Example*
~~~
dynamic_present()
~~~
-----


### present()
-----
_**Description**_: Moves the player to the Present dialog.

##### *Parameters*
None.

##### *Return value*
None.

##### *Example*
~~~
present()
~~~
-----


### has_ev(ev)
-----
_**Description**_: Given an evidence ID, has_ev checks to see if the player has the evidence item.

##### *Parameters*
ev - The Evidence ID

##### *Return value*
Returns whether or not the evidence was found in the Court Record.

##### *Example*
~~~
has_ev(attorneybadge)
~~~
-----


### add_ev(ev)
-----
_**Description**_: Given an evidence ID, add_ev adds the evidence item to the Court Record.

##### *Parameters*
ev - The Evidence ID

##### *Return value*
Returns the maximum size of the Court Record after the add.

##### *Example*
~~~
add_ev(pr_phoenix)
~~~
-----


### sub_ev(ev)
-----
_**Description**_: Given an evidence ID, sub_ev removes the evidence item from the Court Record.

##### *Parameters*
ev - The Evidence ID

##### *Return value*
Returns whether or not the evidence was found in the Court Record.

##### *Example*
~~~
sub_ev(attorneybadge)
~~~
-----


### dynamic_examine(path, size)
-----
_**Description**_: Forcefully advances the player to an Examine dialog.

##### *Parameters*
path - Path of the examine background.
size - The size of the examine background's tilemap.

##### *Return value*
None.

##### *Example*
~~~
dynamic_examine("movie/bang", 256)
~~~
-----


### examine()
-----
_**Description**_: Moves player to the Examine dialog.

##### *Parameters*
None.

##### *Return value*
None.

##### *Example*
~~~
examine()
~~~
-----


### new_hotspot()
-----
_**Description**_: Adds a new hotspot to an object.

##### *Parameters*
x - x value of the rectangle
y - y value of the rectangle
w - width of the rectangle
h - height of the rectangle
obj - the object to bind the hotspot to

##### *Return value*
Returns the amount of hotspots in the objection.

##### *Example*
~~~
new_hotspot(0, 0, 256, 192, "examined_map")
~~~
-----


### select_answer()
-----
_**Description**_: Selects the answer within the option dialog.

##### *Parameters*
text - The text assigned to the original answer.

##### *Return value*
None.

##### *Example*
~~~
select_answer("Why?")
~~~
-----


### interaction()
-----
_**Description**_: Prompts the Interaction dialog (Move, Examine).

##### *Parameters*
None.

##### *Return value*
None.

##### *Example*
~~~
interaction()
~~~
-----


### interrogation()
-----
_**Description**_: Prompts the Interrogation dialog (Move, Examine, Present, Talk).

##### *Parameters*
None.

##### *Return value*
None.

##### *Example*
~~~
interrogation()
~~~
-----


### move()
-----
_**Description**_: Prompts the Move dialog.

##### *Parameters*
None.

##### *Return value*
None.

##### *Example*
~~~
move()
~~~
-----


### talk()
-----
_**Description**_: Prompts the Talk dialog.

##### *Parameters*
None.

##### *Return value*
None.

##### *Example*
~~~
talk()
~~~
-----


### dynamic_options()
-----
_**Description**_: Forcefully prompts the Options dialog.

##### *Parameters*
… - Takes a list of parameters, each denoting the text for each option

##### *Return value*
None.

##### *Example*
~~~
dynamic_options("What?", "Why?", "Who?")
~~~
-----


### has_opt(opt)
-----
_**Description**_: Does the options dialog have the option?

##### *Parameters*
opt - The option value.

##### *Return value*
Returns whether or not the option is fine.

##### *Example*
~~~
has_opt("Who?")
~~~
-----


### new_opt()
-----
_**Description**_: Adds a new option to the Option dialog.

##### *Parameters*
None.

##### *Return value*
None.

##### *Example*
~~~
new_opt()
~~~
-----


### new_mov_opt(...)
-----
_**Description**_: Adds a new move option to the Move dialog.

##### *Parameters*
... - Takes a list of parameters, each denoting the text for each option

##### *Return value*
None.

##### *Example*
~~~
new_mov_opt("Toronto")
~~~
-----


### add_tlk(opt)
-----
_**Description**_: Adds a new talk option to the Talk dialog.

##### *Parameters*
opt - The talk option text

##### *Return value*
None.

##### *Example*
~~~
add_tlk("What?")
~~~
-----


### new_tlk(opt)
-----
_**Description**_: Adds a new talk option to the Talk dialog.

##### *Parameters*
opt - The talk option text

##### *Return value*
None.

##### *Example*
~~~
add_tlk("What?")
~~~
-----


### new_mov(opt)
-----
_**Description**_: Adds a new talk option to the Talk dialog.

##### *Parameters*
opt - The talk option text

##### *Return value*
None.

##### *Example*
~~~
add_tlk("What?")
~~~
-----


### goto_save(g, c, bm)
-----
_**Description**_: Forcefully prompts player to Save dialog.

##### *Parameters*
g - Game ID
c - Chapter ID
bm - Bookmark ID

##### *Return value*
None.

##### *Example*
~~~
goto_save(4, 3, 2)
~~~
-----


### new_bg(p, size)
-----
_**Description**_: Creates a new background.

##### *Parameters*
p - Path to the background image
size - Size of the background image's tilemap

##### *Return value*
None.

##### *Example*
~~~
new_bg("movie/alarm", 256)
~~~
-----


### new_fg(p, size)
-----
_**Description**_: Creates a new foreground.

##### *Parameters*
p - Path to the foreground image
size - Size of the foreground image's tilemap

##### *Return value*
None.

##### *Example*
~~~
new_fg("movie/bang", 256)
~~~
-----


### new_char(n, e, aa, ia, ta)
-----
_**Description**_: Create a new character.

##### *Parameters*
n - The name of the character
e - The default emotion the character conveys
aa - The default active animation
ia - The default idle animation
ta - The default transition animation

##### *Return value*
None.

##### *Example*
~~~
new_char("Gumshoe", "thinking", "talk", "blink")
~~~
-----


### new_emo(e)
-----
_**Description**_: Prompts a new emotion for the character.

##### *Parameters*
e - Emotion ID

##### *Return value*
None.

##### *Example*
~~~
new_emo("disheartened")
~~~
-----


### new_active(a)
-----
_**Description**_: Prompts a new active animation for the character.

##### *Parameters*
a - Active animation ID

##### *Return value*
None.

##### *Example*
~~~
new_active("thinking")
~~~
-----


### new_idle(a)
-----
_**Description**_: Prompts a new idle animation for the character.

##### *Parameters*
a - Idle animation ID

##### *Return value*
None.

##### *Example*
~~~
new_idle("disheartened")
~~~
-----


### new_transition(a)
-----
_**Description**_: Prompts a new transition animation for the character.

##### *Parameters*
a - Transition animation ID

##### *Return value*
None.

##### *Example*
~~~
new_transition("blink")
~~~
-----


### msg(text)
-----
_**Description**_: Shows text on the screen.

##### *Parameters*
text - The text value of the character text

##### *Return value*
None.

##### *Example*
~~~
msg("Hey, how's it going?")
~~~
-----


### flash(c)
-----
_**Description**_: Shows a flash on the screen.

##### *Parameters*
c - The hex color code of the flash

##### *Return value*
None.

##### *Example*
~~~
flash("#FF0000")
~~~
-----


### show_shake(l, o)
-----
_**Description**_: Shows a shake on the screen.

##### *Parameters*
l - Length of the shake
o - Offset of the shake

##### *Return value*
None.

##### *Example*
~~~
show_shake(8, 4)
~~~
-----


### show_ev(l, c, ev)
-----
_**Description**_: Shows an evidence item on the screen.

##### *Parameters*
l - How long the evidence is shown on the screen
c - Corner from which it appears
ev - The evidence item ID that is shown

##### *Return value*
None.

##### *Example*
~~~
show_ev(-1, TOP_LEFT, bullet)
~~~
-----


### show_add_ev(ev)
-----
_**Description**_: Shows an evidence item being added on the screen.

##### *Parameters*
ev - The evidence item ID that is shown

##### *Return value*
None.

##### *Example*
~~~
show_add_ev(bullet)
~~~
-----


### goto(s, ...)
-----
_**Description**_: Goes to a dialog, passing the parameters.

##### *Parameters*
s - Dialog name
... - Parameters for the dialog constructor

##### *Return value*
None.

##### *Example*
~~~
goto("dynamic_options", "Who?", "What?", "Where?")
~~~
-----


### reset()
-----
_**Description**_: Resets the engine to the beginning.

##### *Parameters*
None.

##### *Return value*
None.

##### *Example*
~~~
reset()
~~~
-----


### new_align(a)
-----
_**Description**_: Re-aligns the text to ALIGN_LEFT, ALIGN_CENTER or ALIGN_RIGHT.

##### *Parameters*
a - The align type: ALIGN_LEFT, ALIGN_CENTER or ALIGN_RIGHT

##### *Return value*
None.

##### *Example*
~~~
new_align(ALIGN_CENTER)
~~~

-----


### new_color(a)
-----
_**Description**_: Adds a new colour to the text.

##### *Parameters*
a - The hex color code

##### *Return value*
None.

##### *Example*
~~~
new_color("#00FF00")
~~~
-----


### new_bgm(bgm)
-----
_**Description**_: Loads and plays new background music.

##### *Parameters*
bgm - The background music ID.

##### *Return value*
None.

##### *Example*
~~~
new_bgm(MOD_GEIJISSU)
~~~
-----


### play_sfx(sfx)
-----
_**Description**_: Loads and plays a sound effect.

##### *Parameters*
sfx - The sound effect ID

##### *Return value*
None.

##### *Example*
~~~
play_sfx(SFX_TYPEWRITER)
~~~
-----


### new_speaker(n, s)
-----
_**Description**_: Adds a new speaker to the screen, alongside a sound effect.

##### *Parameters*
n - Name of the speaker
s - Sound effect

##### *Return value*
None.

##### *Example*
~~~
new_speaker("???", SFX_BLIPMALE)
~~~
-----


### dynamic_cross_examination()
-----
_**Description**_: Prompts the cross examination dialog.

##### *Parameters*
None.

##### *Return value*
None.

##### *Example*
~~~
dynamic_cross_examination()
~~~
-----


### add_hp(newhp)
-----
_**Description**_: Add health points to the user.

##### *Parameters*
newhp - The HP to add

##### *Return value*
None.

##### *Example*
~~~
add_hp(14)
~~~
-----


### show_risk(rhp)
-----
_**Description**_: Shows the risk animation to the health points of the character.

##### *Parameters*
rhp - The risked health points.

##### *Return value*
None.

##### *Example*
~~~
show_risk(24)
~~~
-----

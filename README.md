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

### crossexanimation()
-----
_**Description**_: Plays the Cross Examination animation.

##### *Parameters*
None.

##### *Return value*
None.

##### *Example*
~~~
crossexanimation()
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

### dynamicpresent()
-----
_**Description**_: Forcefully advances the player to a Present dialog.

##### *Parameters*
None.

##### *Return value*
None.

##### *Example*
~~~
dynamicpresent()
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

### hasev(ev)
-----
_**Description**_: Given an evidence ID, hasev checks to see if the player has the evidence item.

##### *Parameters*
ev - The Evidence ID

##### *Return value*
Returns whether or not the evidence was found in the Court Record.

##### *Example*
~~~
hasev(attorneybadge)
~~~
-----

### addev(ev)
-----
_**Description**_: Given an evidence ID, addev adds the evidence item to the Court Record.

##### *Parameters*
ev - The Evidence ID

##### *Return value*
Returns the maximum size of the Court Record after the add.

##### *Example*
~~~
addev(pr_phoenix)
~~~
-----

### subev(ev)
-----
_**Description**_: Given an evidence ID, subev removes the evidence item from the Court Record.

##### *Parameters*
ev - The Evidence ID

##### *Return value*
Returns whether or not the evidence was found in the Court Record.

##### *Example*
~~~
subev(attorneybadge)
~~~
-----

### dynamicexamine(path, size)
-----
_**Description**_: Forcefully advances the player to an Examine dialog.

##### *Parameters*
path - Path of the examine background.
size - The size of the examine background's tilemap.

##### *Return value*
None.

##### *Example*
~~~
dynamicexamine("movie/bang", 256)
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

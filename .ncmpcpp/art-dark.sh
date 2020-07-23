#!/bin/bash
getcolors () {
	FOREGROUND=$(xrdb -query | grep 'foreground:'| awk '{print $NF}')
	BACKGROUND=$(xrdb -query | grep 'background:'| awk '{print $NF}')
	BLACK=$(xrdb -query | grep 'color0:'| awk '{print $NF}')
	RED=$(xrdb -query | grep 'color1:'| awk '{print $NF}')
	GREEN=$(xrdb -query | grep 'color2:'| awk '{print $NF}')
	YELLOW=$(xrdb -query | grep 'color3:'| awk '{print $NF}')
	BLUE=$(xrdb -query | grep 'color4:'| awk '{print $NF}')
	MAGENTA=$(xrdb -query | grep 'color5:'| awk '{print $NF}')
	CYAN=$(xrdb -query | grep 'color6:'| awk '{print $NF}')
	WHITE=$(xrdb -query | grep 'color7:'| awk '{print $NF}')
}
#album_dir="${file%/*}"
# Only use the function above if the cache of paintmybox couldn't be found
if [ -e ~/.cache/paintmyboxcache ]; then
	. ~/.cache/paintmyboxcache
	else
	getcolors
fi

MUSIC_DIR=$HOME/Music

COVER=/tmp/kunst.jpg

function reset_background
{
    printf "\e]20;;100x100+1000+1000\a"
}

{
    album="$(mpc --format %album% current)"
    file="$(mpc --format %file% current)"
    album_dir="${file%/*}"
    [[ -z "$album_dir" ]] && exit 1
    album_dir="$MUSIC_DIR/$album_dir"

    covers="$(find "$album_dir" -type d -exec find {} -maxdepth 1 -type f -iregex ".*/.*\(${album}\|cover\|folder\|artwork\|front\).*[.]\(jpe?g\|png\|gif\|bmp\)" \; )"
    src="$(echo -n "$covers" | head -n1)"
    rm -f "$COVER" 
    if [[ -n "$src" ]] ; then
        #resize the image's height to 300px & extent it to cover the urxvt length
        #convert "$src" -resize 300x -background "#263238" -extent 1100x400 "$COVER"
        convert "$src" -resize 400x -background "#12171b" -extent 1100x400 "$COVER"
        if [[ -f "$COVER" ]] ; then
        
           #-- original script --
           #scale down the cover to 30% of the original
           #place it 1% away from left and 50% away from top.
           #printf "\e]20;${COVER};80x80+0+60:op=keep-aspect\a"
           #---------------------
           
           #no need to scale down, i have extent it
           printf "\e]20;${COVER};80x80+20+20:op=keep-aspect\a"
        else
            reset_background
        fi
    else
        reset_background
    fi
} &
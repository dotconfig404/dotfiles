# grep -q = silent
if  xrandr | grep -q "eDP-1 connected primary" 
then
    xrandr --output DP-2 --mode 3840x1600 --rate 60 --primary --output eDP-1 --off
else
    xrandr --output eDP-1 --mode 1920x1200 --rate 60 --primary --output DP-2 --off
fi


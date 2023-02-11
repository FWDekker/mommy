#!/bin/bash
# Script to help create `demo.gif` reproducibly. Requires `xdotool`.
#
# 1. Set font size to 32
# 2. Hide console border
# 3. In SimpleScreenRecorder, record entire console window
# 4. Start recording, activate this script with global shortcut, then stop recording
# 5. Create a GIF with `ffmpeg -i input.mkv -vf "fps=24,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 0 output.gif`

sleep 1

echo "Run faulty command"
xdotool type --delay 100 "mommy ./trest.sh"
sleep 1.5
xdotool key Return
sleep 2

echo "Run working command"
xdotool type --delay 100 "mommy ./test.sh"
sleep 1.5
xdotool key Return

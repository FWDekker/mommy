#!/bin/sh
# Script to help create `demo.gif` reproducibly. Requires `xdotool`.
#
# 1. Change `~/.config/mommy/config.sh` to contain only:
#    MOMMY_COLOR="lolcat";MOMMY_ENOURAGEMENTS="never give up, my love";MOMMY_COMPLIMENTS="mommy knew you could do it"
# 2. Open Konsole and change appearance:
#   * Set font size to 32
#   * Hide console border
#   * Resize window to 80x20
# 3. In SimpleScreenRecorder, select console window, and change width to 1900 and height to 800
# 4. Start recording, activate this script with global shortcut, then stop recording
# 5. Create a GIF with `ffmpeg -i input.mkv -vf "fps=24,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 0 demo.gif`

set -e

echo "Waiting 1 second before starting"
sleep "1"

echo "Run faulty command"
xdotool type --delay 100 "mommy ./trest.sh"
sleep "1.5"
xdotool key Return
sleep "2"

echo "Run working command"
xdotool type --delay 100 "mommy ./test.sh"
sleep "1.5"
xdotool key Return

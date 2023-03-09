#!/bin/sh
# Script to help create `demo.gif` reproducibly. Requires `xdotool`.
#
# 1. Change `~/.config/mommy/config.sh` to contain only:
#    MOMMY_ENCOURAGEMENTS="never give up, my love";MOMMY_COMPLIMENTS="mommy knew you could do it"
# 2. Open Konsole and change appearance:
#   * Set font size to 32
#   * Resize window to 80x20
#   * Hide console border
# 3. In SimpleScreenRecorder, select console window, and change width to 1900 and height to 800
# 4. Open `sh` shell
# 5. Start recording, activate this script with global shortcut, then stop recording
# 6. Create a GIF with `ffmpeg -y -i ~/Videos/simplescreenrecorder*.mkv -vf "fps=24,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 0 ./.github/img/demo.gif`

set -e

echo "Waiting 1 second before starting"
sleep "1"

echo "Run faulty command"
xdotool type --delay 100 "mommy make tesr"
sleep "1.5"
xdotool key Return
sleep "2"

echo "Run working command"
xdotool type --delay 100 "mommy make test"
sleep "1.5"
xdotool key Return
